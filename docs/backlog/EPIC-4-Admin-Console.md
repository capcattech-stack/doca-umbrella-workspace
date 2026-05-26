# EPIC 4: Hệ thống Quản trị Nội bộ (Admin Console)

**Mô tả:** Phân hệ dành riêng cho Product Owner (PO) và Admin để quản lý, giám sát và cấu hình toàn bộ hệ thống Idea Workshop. Các User thông thường không có quyền truy cập vào phân hệ này.

---

## US 4.1: Admin Kanban Board
*   **As an** Admin
*   **I want to** xem một bảng Kanban (Trello-like) chứa tất cả các ý tưởng được gửi vào hệ thống
*   **So that** tôi có cái nhìn tổng quan về trạng thái của từng Idea.
*   **Acceptance Criteria:**
    *   Chia làm 3 cột chính: Negotiating (Đang thương lượng/Hỏi đáp), Rejected (Bị từ chối), Approved (Đã chốt).
    *   Khu vực Header phải có thanh Global Search (tìm kiếm theo ID hoặc từ khóa) và Dropdown Filter (lọc theo loại tài liệu PRD/Tất cả).
    *   Mỗi thẻ (Card) hiển thị Idea_ID, Trạng thái (New/Enhance), RICE score và Thumbnail của tài liệu đính kèm (nếu có).

## US 4.2: Chat Logs Audit
*   **As an** Admin
*   **I want to** click vào một Idea bất kỳ để xem lại toàn bộ lịch sử trò chuyện (Chat Logs) giữa User và dàn AI Agents
*   **So that** tôi có thể audit (kiểm tra) xem tại sao AI lại Reject ý tưởng này, hoặc AI đã truy vấn những gì.
*   **Acceptance Criteria:**
    *   Giao diện hiển thị rõ role (User, System/Sophia, Arthur, Leo...).
    *   Logs không thể bị xóa hay thay đổi.

## US 4.3: Admin Agent Config
*   **As an** Admin
*   **I want to** có một màn hình quản lý danh sách Đặc vụ (Agents)
*   **So that** tôi có thể chủ động cập nhật API Key, đổi LLM Model (GPT-4o, Claude 3.5, Gemini) và sửa System Prompt mà không cần nhờ Dev sửa code.
*   **Acceptance Criteria:**
    *   Liệt kê đầy đủ 5 Agents cốt lõi.
    *   Form cập nhật được bảo mật, API Key hiển thị dạng password mask.
    *   Dữ liệu lưu vào SQLite bảng `AgentConfig`.

## US 4.4: PO Human-in-the-loop Verify
*   **As a** PO (Product Owner)
*   **I want to** có quyền "nhảy" trực tiếp vào luồng Chat của một Idea đang ở trạng thái Negotiating/Draft
*   **So that** tôi có thể tự mình làm rõ yêu cầu với BA Agent (Sophia) và nghe tham vấn từ Tech Lead Agent (Alan) trước khi tự tay bấm nút "Approved".
*   **Acceptance Criteria:**
    *   Cung cấp thanh input chat riêng cho PO.
    *   PO có quyền ghi đè (override) quyết định của AI, ép hệ thống chuyển trạng thái sang Approved hoặc Rejected.

## US 4.5: Google SSO & Whitelist Authentication
*   **As a** PO/Admin
*   **I want to** bắt buộc phải đăng nhập bằng tài khoản Google (SSO) để truy cập `/admin`
*   **So that** hệ thống được bảo mật chặt chẽ.
*   **Acceptance Criteria:**
    *   Tích hợp Next-Auth v5.
    *   Chỉ những Email nằm trong danh sách trắng (`ADMIN_EMAILS` trong `.env`) mới được phép qua cổng.
    *   Chặn truy cập trái phép bằng Next.js Middleware.

## US 4.6: Cấu hình Baseline Metrics & Tham số (Baseline Config)
*   **As an** Admin
*   **I want to** có một màn hình quản lý các tham số cốt lõi (Cost per Man-day, Target Market) và cập nhật số liệu nền tảng (Baseline Metrics hiện tại)
*   **So that** các Agent (đặc biệt là Leo và Arthur) có dữ liệu kinh doanh và bối cảnh vùng miền chính xác nhất để tính toán và phản biện.
*   **Acceptance Criteria:**
    *   Form cập nhật `cost_per_manday` (Chi phí cho 1 ngày công của Dev) và `opex_multiplier` (Hệ số chi phí vận hành).
    *   Form cập nhật **Quốc gia - Country Context** (Ví dụ: "Việt Nam", "USA") để thiết lập bối cảnh kinh tế vĩ mô. (Bối cảnh vùng miền chi tiết sẽ do Arthur chủ động hỏi User).
    *   Một ô nhập liệu (Textarea) để Admin dán nội dung số liệu kinh doanh hiện tại (VD: MAU = 100k, ARPU = 50K) thay vì phải up file tĩnh.
    *   Dữ liệu được lưu vào bảng `AdminSetting` và tự động load làm Context mỗi khi các Agent tính toán RICE.
