# 🛠️ ĐẶC TẢ KỸ THUẬT: KIẾN TRÚC CLOUD RAG & TRUY XUẤT KÝ ỨC DÒNG THỜI GIAN ĐỒNG BỘ
*(CLOUD RAG & TIMELINE RETRIEVAL ARCHITECTURE - SYSTEM DESIGN)*

> **Mã Tài Liệu:** `SPEC-VAULT-RAG-TIMELINE`  
> **Phiên bản:** `V1.2 (MVP)`  
> **Chủ trì:** Alan (Tech Lead)  
> **Phối hợp:** RAG Architect  
> **Mục tiêu:** Đặc tả kiến trúc cơ sở dữ liệu dòng thời gian (Timeline) đồng bộ đám mây và giải pháp Cloud RAG để cung cấp ngữ cảnh hội thoại cá nhân hoá cho Boss AI, đồng thời bảo toàn dữ liệu khi đổi thiết bị.

---

## 🏗️ 1. Quy Trình Ingestion & Retrieval Tổng Quan

Để tối ưu hóa hiệu năng, bảo đảm an toàn dữ liệu và bảo vệ quyền riêng tư, quá trình thu thập ký ức (Ingestion) và truy xuất thông tin (Retrieval) được thực hiện thông qua **hệ cơ sở dữ liệu đồng bộ đám mây bảo mật (Cloud Sync Database) kết hợp bộ lọc ngữ cảnh Cloud RAG & Metadata Filtering** trước khi gửi prompt lên LLM API.

```mermaid
graph TD
    subgraph Ingestion Pipeline (Nạp Ký Ức)
        Photo[Ảnh Polaroid/Moments] --> TextExtract[Trích xuất Text/Caption]
        Care[Nhật ký chăm sóc/Sức khoẻ] --> SQLiteWrite[Ghi vào SQLite Cache & Đồng bộ Server DB]
        Chat[Đoạn chat quan trọng] --> GPT_Extract[Trích xuất sự kiện cốt lõi] --> SQLiteWrite
    end

    subgraph Retrieval Pipeline (Truy Xuất Chat)
        UserMsg[Tin nhắn mới của Sen] --> QueryParser[Bộ phân tích truy vấn Cloud]
        QueryParser -->|Trích xuất thời gian/chủ đề| PreFilter[Bộ lọc Metadata Đám mây]
        SQLiteWrite --> DB[(Database SQLite Cache & Server Cloud DB)]
        DB -->|Query Events| PreFilter
        PreFilter -->|Lọc ra N sự kiện liên quan| PromptPacker[Prompt Packer Cloud]
        UserMsg --> PromptPacker
        PromptPacker -->|System Prompt + Context| LLM[Gemini Flash API]
        LLM -->|Response| Output[Tin nhắn phản hồi của Boss]
    end
```

---

## 💾 2. Thiết Kế Schema Bảng Sự Kiện Dòng Thời Gian (`events`)

Để phục vụ tìm kiếm ngữ nghĩa nhanh và truy vấn quan hệ, toàn bộ Moments, Medical Logs, và Chat Memories được hợp nhất trong một bảng SQLite duy nhất:

### Bảng `timeline_events`

```sql
CREATE TABLE timeline_events (
    id TEXT PRIMARY KEY,
    pet_id TEXT NOT NULL,
    event_type TEXT NOT NULL,          -- 'MOMENT' | 'MEDICAL' | 'CHAT_MEMORABLE' | 'CARE'
    event_date INTEGER NOT NULL,        -- Unix Epoch Timestamp
    content TEXT NOT NULL,             -- Nội dung text (Ví dụ: "Ba dắt Bánh Mì đi tiêm ngừa phòng dại ở quận 3")
    image_url TEXT,                    -- Đường dẫn ảnh (nếu có)
    importance_score REAL DEFAULT 0.5, -- Độ quan trọng từ 0.0 đến 1.0
    embedding_vector BLOB,              -- Vector nhúng cục bộ (tùy chọn cho Phase 2, lưu byte array)
    FOREIGN KEY(pet_id) REFERENCES pet_profiles(id)
);
CREATE INDEX idx_timeline_date ON timeline_events(event_date);
CREATE INDEX idx_timeline_type ON timeline_events(event_type);
```

---

## 🔍 3. Giải Thuật Tiền Lọc Ngữ Cảnh (Context-Sensing Metadata Filtering)

Thay vì thực hiện tìm kiếm vector cosine đắt đỏ trên toàn bộ dữ liệu, thuật toán của chúng tôi sử dụng **Bộ lọc Tiền ngữ cảnh (Metadata Filtering Rules)** dựa trên phân tích từ khoá đơn giản:

### Thuật toán phân lớp truy xuất ngữ cảnh:
1. **Phân tích Thời gian:** Nếu tin nhắn của người dùng chứa các từ chỉ thời gian (`hôm qua`, `tuần trước`, `sinh nhật`, `năm ngoái`), bộ lọc SQLite sẽ tự động truy vấn các sự kiện có `event_date` tương ứng.
2. **Phân tích Chủ đề (Topic Tagging):** 
   * Nếu có từ khoá liên quan đến sức khoẻ (`đau`, `ốm`, `tiêm`, `sổ giun`), truy vấn các sự kiện loại `event_type = 'MEDICAL'`.
   * Nếu có từ khoá liên quan đến ăn uống, vui chơi (`ăn`, `pate`, `đi dạo`, `công viên`), truy vấn các sự kiện loại `event_type = 'CARE'` hoặc `event_type = 'MOMENT'`.
3. **Mỏ neo mặc định (Default Fallback):** Nếu không khớp từ khoá đặc biệt nào, hệ thống tự động lấy **3 sự kiện gần nhất** có `importance_score >= 0.70` để duy trì dòng ý thức liên tục của thú cưng.

---

## 📦 4. Thuật Toán Gom Prompt (Prompt Packing & Pruning Strategy)

Sau khi bộ lọc trả về $N$ sự kiện từ database, hệ thống sẽ đóng gói (pack) chúng vào cấu trúc **System Prompt** của LLM như sau:

```
[SYSTEM PROMPT]
Bạn là linh hồn kỹ thuật số của chú chó/mèo tên là {{pet_name}}.
Tính cách của bạn: {{pet_persona}}.
Mối quan hệ: Bạn gọi người dùng là {{owner_reference}} và xưng là {{pet_reference}}.

KÝ ỨC HIỆN CÓ CỦA BẠN (Dùng để nhắc lại tự nhiên nếu liên quan, tuyệt đối không liệt kê khô khan):
{% for event in retrieved_events %}
- Vào ngày {{event.formatted_date}}: {{event.content}}
{% endfor %}

Quy tắc trò chuyện: Trả lời ngắn dưới 3 câu, giữ đúng cá tính của mình.
```

### Chiến lược cắt tỉa Context (Context Pruning):
*   **Tổng số ký tự tối đa cho phần Ký ức:** Giới hạn tối đa **800 tokens** (khoảng 3200 ký tự tiếng Việt) để giảm thiểu chi phí API đầu vào và tránh hiện tượng "lost in the middle" của LLM.
*   Nếu số lượng sự kiện vượt quá giới hạn, sắp xếp ưu tiên theo: `importance_score` giảm dần $\rightarrow$ `event_date` mới nhất.

---

## 🛡️ 5. Định Nghĩa Hoàn Thành (Definition of Done - DoD)
*   [ ] Thiết kế Schema SQLite được kiểm thử cấu trúc thành công trong Flutter/Dart.
*   [ ] Bộ lọc `Context-Sensing Metadata Filtering` có tốc độ xử lý dưới 3ms trên luồng CPU di động.
*   [ ] Định dạng đóng gói System Prompt được xác thực thông qua Gemini Flash API, đảm bảo AI nhận diện và nhắc lại đúng ký ức trong 90% số lượt test hội thoại kiểm tra.
