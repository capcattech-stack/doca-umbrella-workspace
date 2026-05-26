# EPIC 1: Trải nghiệm Nhập liệu & Tương tác Người dùng (User Experience) — CẬP NHẬT THEO PIVOT 19/05/2026

**Mô tả:** Epic này tập trung vào điểm tiếp xúc đầu tiên của người dùng (User) với hệ thống Idea Workshop. Trải nghiệm được định hướng hoàn toàn theo **Mobile-First, Dark Mode mặc định, Chat-Centric** (Notion-like đã chuyển sang Claude Mobile Pattern). Mục tiêu là khuyến khích người dùng chia sẻ ý tưởng thô một cách tự nhiên nhất với ma sát bằng 0.

---

## US 1.1: Landing Page & Form Nhập Ý Tưởng
*   **As a** User
*   **I want to** xem một Landing Page tối giản trên điện thoại (Blank Canvas) với một ô nhập liệu lớn ở trung tâm
*   **So that** tôi có thể gõ ngay ý tưởng thô của mình vào hệ thống một cách nhanh chóng mà không qua các bước onboarding rườm rà.
*   **Acceptance Criteria:**
    *   Giao diện hiển thị theo phong cách Blank Canvas (Dark Mode), placeholder mờ *"Bạn đang ấp ủ điều gì?"*.
    *   Header tối giản (Logo + Icon Menu hamburger). Khi bắt đầu gõ, header fade out để tối đa diện tích nhập liệu.
    *   Không yêu cầu đăng ký tài khoản lúc đầu (Frictionless).

## US 1.2: Chat Room & Streaming UI
*   **As a** User
*   **I want to** được chuyển vào một phòng chat toàn màn hình (Full-screen Mobile Chat), nơi Cố vấn Ảo trả lời bằng hiệu ứng gõ chữ
*   **So that** tôi có cảm giác đang được tư vấn 1-1 bởi một chuyên gia thực thụ.
*   **Acceptance Criteria:**
    *   Giao diện Chat là 1 cột duy nhất, scroll tự do (không có split-pane trên mobile).
    *   Sử dụng Server-Sent Events (SSE) hoặc WebSocket để stream text từ AI.
    *   **Progress Thread:** Dưới header có một dải gradient mảnh (~3px) hiển thị tiến trình (6 bước Grooming). Tap vào sẽ trượt lên Bottom Sheet chi tiết.

## US 1.3: Nhận Kết Quả Trực Tiếp
*   **As a** User
*   **I want to** nhận được quyết định và tài liệu PRD ngay trong khung chat mà không làm gián đoạn luồng trò chuyện
*   **So that** tôi có thể xem kết quả trực tiếp trên điện thoại dễ dàng.
*   **Acceptance Criteria:**
    *   Khi ý tưởng được "APPROVED", xuất hiện một Nút Floating Action Button (FAB) **"Xem PRD ✨"** ở góc dưới phải.
    *   Click vào FAB sẽ mở **Full-screen Bottom Sheet** trượt lên chứa nội dung PRD (Markdown rendered).
    *   Bottom Sheet có nút "Tải xuống" và "Chia sẻ".

## US 1.4: Tải Lên Đa Phương Thức (Multimodal Upload)
*   **As a** User
*   **I want to** có thể đính kèm tài liệu (PDF, Word) hoặc hình ảnh (Ảnh chụp màn hình, UI flowchart) vào ô nhập ý tưởng
*   **So that** AI có đầy đủ ngữ cảnh để phân tích và viết PRD chính xác hơn.
*   **Acceptance Criteria:**
    *   Hiển thị khu vực Drag & Drop bên dưới ô Text.
    *   Giới hạn tải lên tối đa 3 file (Tối đa 5MB/file).
    *   Hỗ trợ các định dạng: `.pdf`, `.doc`, `.png`, `.jpg`, `.txt`.
    *   Hiển thị progress bar khi đang upload và icon xóa file nếu đổi ý.

## US 1.5: Khôi phục phiên làm việc (Hybrid Auth Model)
*   **As a** User
*   **I want to** có một mã PIN cho chế độ ẩn danh, nhưng cũng có thể Đăng nhập tài khoản nếu muốn
*   **So that** tôi vừa có thể bắt đầu nhanh (ẩn danh), vừa có thể đồng bộ toàn bộ ý tưởng về một nơi an toàn lâu dài.
*   **Acceptance Criteria:**
    *   **Luồng Ẩn danh (Default):** Giống ban đầu, tạo ý tưởng -> cấp mã PIN 6 số. Mở máy khác cần link + PIN.
    *   **Luồng Đăng nhập (Upgrade):** Trong Side Drawer có tùy chọn "Đăng nhập" (Google/Email). Khi login thành công, hệ thống merge toàn bộ ý tưởng ẩn danh hiện tại vào tài khoản. Từ đó về sau không cần hỏi PIN nữa.

## US 1.6: Menu Trượt & Lịch sử Ý tưởng (Side Drawer)
*   **As a** User
*   **I want to** mở một Menu trượt từ cạnh trái màn hình (Drawer) để quản lý phiên làm việc
*   **So that** tôi có thể xem nhanh Lịch sử Ý tưởng và truy cập Cài đặt mà không tốn diện tích màn hình chat.
*   **Acceptance Criteria:**
    *   Sử dụng `LocalStorage` hoặc Database (nếu đã login) để hiển thị danh sách các ý tưởng gần nhất trong Drawer.
    *   Drawer chứa 3 phần: (1) Danh sách ý tưởng, (2) Đăng nhập / Account, (3) Cài đặt (Ngôn ngữ, Thông báo).

---

## US 1.7: Bong bóng Gợi ý Ngữ cảnh (Contextual Suggestion Chips)
*   **As a** User
*   **I want to** thấy tối đa 4 bong bóng gợi ý xuất hiện phía trên ô nhập liệu
*   **So that** tôi có thể phản hồi nhanh mà không phải gõ phím.
*   **Acceptance Criteria:**
    *   Chips tự động ẩn đi ngay khi User bấm chọn hoặc bắt đầu gõ.
    *   Sophia tự suy luận ngữ cảnh để sinh ra chip, tối đa 4 chip.
    *   **Proactive App Reference:** Nếu bàn về Flow, chip chứa dẫn chứng từ app nổi tiếng (Ví dụ: "Như MoMo: Nhập SĐT → OTP").

## US 1.8: Nhập liệu bằng Giọng nói (Voice-to-Text)
*   **As a** User
*   **I want to** có một nút Microphone lớn trên màn hình để thu âm ý tưởng
*   **So that** tôi không phải gõ những đoạn văn dài trên điện thoại.
*   **Acceptance Criteria:**
    *   Bấm giữ (hoặc tap) nút Mic để thu âm. Có hiệu ứng sóng âm (wave) khi thu.
    *   Hệ thống chuyển đổi Speech-to-Text và tự động điền vào ô chat.
    *   Giúp loại bỏ hoàn toàn ma sát nhập liệu trên Mobile.
