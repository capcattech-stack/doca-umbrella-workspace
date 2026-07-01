# HƯỚNG DẪN LƯU TRỮ & VẬN HÀNH NHẬT KÝ HỘI THOẠI (CHAT HISTORY)
*(CHAT HISTORY ARCHIVING & CONSISTENT STORAGE GUIDELINES)*

> **Mã Tài Liệu:** `DOC-CHAT-GUIDELINE`  
> **Chủ trì:** Sophia (CPO / PM)  
> **Mục tiêu:** Lưu vết lịch sử tư duy phát triển sản phẩm (Traceability)

---

## 🧭 1. Mục Đích Của Việc Lưu Trữ Chat History

Trong quá trình đồng sáng tạo ứng dụng **DOCA**, các ý kiến phản biện của Sáng lập viên (User) và câu trả lời phân tích của đội ngũ Cố vấn ảo chứa đựng rất nhiều kiến thức sản phẩm chuyên sâu, lập luận kiến trúc kỹ thuật và giải pháp P&L quý giá.

Việc lưu trữ nhật ký chat (Chat History) nhất quán nhằm:
1.  **Lưu vết tư duy phát triển (Developmental Context):** Hiểu rõ tại sao một giải pháp kỹ thuật lại được lựa chọn thay thế (ví dụ: lý do chọn iTunes API thay vì Spotify API, lý do chọn Google Sheets CMS...).
2.  **Độc lập và an toàn Git:** Chia nhỏ các lượt chat hoặc gom lại thành file nhật ký ngày giúp tránh xung đột mã nguồn (Git conflicts) khi nhiều lập trình viên cùng chỉnh sửa code.
3.  **Tái sử dụng Prompt (Prompt Reusability):** Làm giàu bộ Prompt mẫu cho các Agent ảo trong tương lai.

---

## 📂 2. Quy Tắc Lưu Trữ & Phân Loại Nhất Quán (Archiving Rules)

Hệ thống **DOCA** áp dụng song song **Hai cấp độ lưu trữ Nhật ký** để tối ưu hóa truy xuất và quản lý phiên bản:

### Cấp độ A: Tệp Nhật Ký Tổng Hợp Ngày (Consolidated Day File)
*   **Vị trí:** Lưu trữ trực tiếp tại thư mục `Document/History/`.
*   **Quy tắc đặt tên:** `CHAT_HISTORY_DDMMYYYY.md` (Sử dụng định dạng ngày tháng của Việt Nam).
    *   *Ví dụ chuẩn:* `CHAT_HISTORY_29052026.md` (Nhật ký chat ngày 29 tháng 05 năm 2026).
*   **Cấu trúc tệp:** 
    *   Bao gồm **Mục lục các lượt chat (TOC)** có gắn Anchor Links.
    *   Chia rõ từng lượt chat: `🙋‍♂️ Người dùng hỏi` và `🤖 Đặc vụ phản hồi`.

### Cấp độ B: Thư Mục Phân Rã Theo Lượt (Segmented Turn Folder)
*   **Vị trí:** Lưu trữ tại thư mục con `/Document/History/CHAT_HISTORY_DDMMYYYY/`.
*   **Quy tắc đặt tên:** `TURN_[NN]_[Ten_Ngan_Gon_Cua_Luot_Chat].md`
    *   *Ví dụ chuẩn:* `TURN_01_Get_thoi_tiet_lam_mo_bai.md`
*   **Mục tiêu:** Giúp hệ thống quản lý git siêu nhẹ, dễ dàng xem chi tiết một lượt chat cụ thể mà không cần mở tệp tổng hợp nặng hàng trăm kilobyte.

---

## ✍️ 3. Quy Chuẩn Trình Bày Nội Dung (Formatting Standard)

Khi lưu trữ một lượt chat mới, biên tập viên cần tuân thủ nghiêm ngặt quy định trình bày Markdown sau:

1.  **Sử dụng Blockquote cho câu hỏi của Người dùng:**
    ```markdown
    #### 🙋‍♂️ **Người dùng hỏi:**
    > [Nội dung câu hỏi thô của người dùng giữ nguyên 100% không chỉnh sửa]
    ```
2.  **Chia rõ vai trò của các Cố vấn ảo trong câu trả lời:**
    *   Khi **Sophia** nói: Sử dụng nhãn `### 👩‍💼 Sophia (CPO / PM):`
    *   Khi **Alan** nói: Sử dụng nhãn `### 🛠️ Alan (Tech Lead):`
    *   Khi **Arthur** nói: Sử dụng nhãn `### 🧠 Arthur (Mom Test Expert):`
    *   Khi **Leo** nói: Sử dụng nhãn `### 📊 Leo (Finance Analyst):`

---

## 🔗 4. Ma Trận Đối Chiếu Nhất Quán (Traceability Matrix)

Để hệ thống tài liệu đạt độ nhất quán cao nhất, mỗi tệp `CHAT_HISTORY_DDMMYYYY.md` bắt buộc phải có liên kết chéo (Interlocking) tới tệp Biên bản họp tương ứng của ngày hôm đó nằm trong thư mục `Document/MOM/` (Ví dụ: `2026-05-29_MOM_Cozy_Chat_Resonance_Engine.md`).

Điều này tạo nên một **vòng khép kín thông tin**:
$$\text{Chat History} \Longleftrightarrow \text{MOM} \Longleftrightarrow \text{PRD / Specs}$$
Giúp đội ngũ phát triển có thể tự do tra cứu ngược xuôi mọi quyết định kỹ thuật và nghiệp vụ của dự án một cách khoa học.
