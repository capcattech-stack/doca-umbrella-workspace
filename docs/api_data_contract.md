# 📄 Data Schema & API Contract (MVP v0)

**Tài liệu chuẩn hóa giao tiếp giữa Frontend (Next.js) và Backend (AI Orchestrator)**
Được chốt bởi BA & CPO.

---

## 1. Database Schema (Mô hình Dữ liệu Core)

Trong MVP v0, chúng ta chỉ cần 2 bảng cốt lõi (PostgreSQL hoặc SQLite):

### Bảng `ideas`
Lưu trữ thông tin tổng quan của một phiên Ideation.
- `id` (UUID) - Primary Key.
- `idea_code` (String, e.g., "IDEA-1234") - Dùng để User tra cứu.
- `pin_code` (String, Hash) - Mã PIN 4 số.
- `raw_idea` (Text) - Ý tưởng gốc ban đầu.
- `status` (Enum) - `[NEGOTIATING, REJECTED, APPROVED]`.
- `doc_type` (Enum) - `[NONE, USER_STORY, FEATURE_BRIEF, PRD]`.
- `doc_url` (String) - Đường dẫn tới file Markdown đã sinh ra (Lưu trên S3 hoặc local folder).
- `created_at` (Timestamp).

### Bảng `chat_logs`
Lưu trữ lịch sử hội thoại 1-1 giữa User và AI Virtual Advisor.
- `id` (UUID) - Primary Key.
- `idea_id` (UUID) - Foreign Key -> `ideas.id`.
- `role` (Enum) - `[USER, SYSTEM, AI_ADVISOR]`.
- `content` (Text) - Nội dung tin nhắn.
- `created_at` (Timestamp).

---

## 2. API Contract (Giao thức Kết nối)

### API 1: Khởi tạo Ý tưởng mới (Create Idea)
- **Endpoint:** `POST /api/v1/ideas`
- **Request Body:**
  ```json
  {
    "raw_idea": "Tôi muốn thêm nút thanh toán Momo",
    "pin": "1234"
  }
  ```
- **Response (200 OK):**
  ```json
  {
    "idea_id": "uuid-1234...",
    "idea_code": "IDEA-9988",
    "message": "Ý tưởng đã được ghi nhận. Chuyển sang phòng Chat."
  }
  ```

### API 2: Tra cứu / Đăng nhập phiên Idea (Track/Login)
- **Endpoint:** `POST /api/v1/ideas/track`
- **Request Body:**
  ```json
  {
    "idea_code": "IDEA-9988",
    "pin": "1234"
  }
  ```
- **Response (200 OK):**
  ```json
  {
    "idea_id": "uuid-1234...",
    "status": "NEGOTIATING",
    "chat_history": [
      {"role": "USER", "content": "Tôi muốn thêm nút..."},
      {"role": "AI_ADVISOR", "content": "Để tôi hỏi lại..."}
    ]
  }
  ```

### API 3: Gửi tin nhắn Chat & Nhận phản hồi AI (Streaming Chat)
- **Endpoint:** `POST /api/v1/chat/message`
- **Header:** `Authorization: Bearer <Idea_ID_Token>`
- **Request Body:**
  ```json
  {
    "idea_id": "uuid-1234...",
    "message": "Doanh thu kỳ vọng là 50 triệu."
  }
  ```
- **Response (Trích xuất dạng SSE / Server-Sent Events để hiển thị typing):**
  *Trả về Text Stream từng chữ một cho đến khi hoàn tất.*
  *(Hệ thống AI Backend tự động chạy DAG ẩn dưới API này).*

### API 4: Cập nhật Cấu hình Admin (Admin Settings)
- **Endpoint:** `PUT /api/v1/admin/settings`
- **Request Body:**
  ```json
  {
    "cost_per_manday": 1000000,
    "opex_multiplier": 0.15
  }
  ```
- **Response (200 OK):** `{"status": "success"}`

---
*Ghi chú: Team Backend và Frontend cam kết sử dụng đúng chuẩn JSON và cấu trúc này để làm việc song song.*
