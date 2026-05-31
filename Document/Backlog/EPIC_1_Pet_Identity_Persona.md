# EPIC 1: THIẾT LẬP THẦN THÁI BOSS (PET IDENTITY & PROFILING)
*(ĐẶC TẢ CHI TIẾT USER STORIES & ACCEPTANCE CRITERIA)*

---

## 🐶 MÔ TẢ EPIC
Phân hệ này xây dựng và quản lý danh tính sinh học chuẩn khoa học của thú cưng, kết hợp với các cấu hình nhân cách AI (`PetPersona`) để làm nền tảng cốt lõi định hình ngôn từ, cảm xúc giao tiếp của Boss ảo trong suốt toàn bộ ứng dụng.

---

## 📋 DANH SÁCH USER STORIES

### US-1.1: Đăng ký & Thiết lập Thông tin Sinh học của Boss
*   **Phát biểu:** 
    *   *Là một:* Chủ nuôi thú cưng (Sen),
    *   *Tôi muốn:* Điền các thông tin cơ bản của Boss (loài, giống, giới tính, cân nặng, ngày nhận nuôi) một cách nhanh gọn,
    *   *Để:* App tự động tính toán các chỉ số sinh học động của Boss.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Onboarding Form):** Hiển thị form bo cong Glassmorphism tinh tế để nhập: Loài (Chó/Mèo chọn qua icon), Tên Boss, Giống loài (Dropdown searchable), Giới tính (Đực/Cái/Khác), Cân nặng (kg), Ngày sinh nhật, Ngày nhận nuôi.
    *   **AC-2 (Calculated Fields):** Hệ thống tự động tính toán chính xác và hiển thị:
        - Số ngày ở bên nhau (`togetherDays`) kể từ ngày nhận nuôi.
        - Số ngày đếm ngược đến sinh nhật tiếp theo.
        - **Tuổi người quy đổi** của Boss dựa trên công thức nhân học của loài.
        - Phân tích **Giai đoạn phát triển** (`LifeStage`) phù hợp kèm lời khuyên y khoa/dinh dưỡng vắn tắt.
    *   **AC-3 (Validation):** Không cho phép bỏ trống tên Boss và loài. Cân nặng phải nhập dạng số dương.
*   **Technical Context (Alan):** Dữ liệu lưu xuống Model `PetDetail` cục bộ qua `shared_preferences`.

---

### US-1.2: Chọn Mẫu cá tính & Cấu hình Linh hồn Boss (`PetPersona`)
*   **Phát biểu:**
    *   *Là một:* Chủ nuôi thú cưng,
    *   *Tôi muốn:* Lựa chọn mẫu cá tính đặc trưng cho Boss (Ngáo ngơ, Chảnh chọe, Đanh đá, Nịnh nọt),
    *   *Để:* Định hình giọng điệu giao tiếp của Boss ảo trong suốt ứng dụng.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Selection UI):** Hiển thị danh sách 4 thẻ bài cá tính với hình minh họa Boss màu nước phong cách Ghibli ngộ nghĩnh và mô tả ngắn về thói quen của cá tính đó (Ví dụ: *Chảnh chọe - Thích lờ Sen đi khi không có pate*).
    *   **AC-2 (Self-Terms Update):** Khi chọn một cá tính, hệ thống tự động gán cấu hình xưng hô tương ứng:
        - *Chảnh chọe:* Boss xưng "Trẫm", gọi chủ là "Sen".
        - *Nịnh nọt:* Boss xưng "Con", gọi chủ là "Ba/Mẹ".
        - *Đanh đá:* Boss xưng "Tao", gọi chủ là "Đứa hầu".
        - *Ngáo ngơ:* Boss xưng "Tớ", gọi chủ là "Cậu".
*   **Technical Context (Benny):** Maya cần vẽ 4 trạng thái Boss màu nước phong cách Ghibli khác nhau tương ứng với 4 cá tính này.

---

### US-1.3: Trò chơi Trắc nghiệm Hỏi xoáy điền Profile (Conversational Builder)
*   **Phát biểu:**
    *   *Là một:* Chủ nuôi thú cưng lười điền thông tin,
    *   *Tôi muốn:* Trả lời các câu hỏi trắc nghiệm ngắn vui vẻ do Boss AI hỏi hàng ngày trong chat,
    *   *Để:* Tự động hoàn thiện hồ sơ sở thích/thói quen của Boss mà không cảm thấy nhàm chán.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Daily Trigger):** Mỗi ngày 1 lần duy nhất khi người dùng mở chat, Boss AI sẽ gửi 1 câu hỏi trắc nghiệm về thói quen của Boss dưới dạng các nút bấm nhanh (Ví dụ: *"Đố Sen biết trẫm ghét bị tắm bằng gì nhất? [A. Nước lạnh] \| [B. Sữa tắm mùi nhài] \| [C. Ghét tất cả]"*).
    *   **AC-2 (Profile Ingestion):** Khi người dùng click chọn nút đáp án, hệ thống tự động ghi nhận thuộc tính đó vào trường `PetDetail.brief` (Likes/Dislikes) và lưu lại mà không bắt người dùng nhập text.
    *   **AC-3 (AI Response):** Boss AI lập tức phản hồi 1 câu chọc ghẹo phù hợp với đáp án vừa chọn trước khi quay lại luồng chat tự do.

---

### US-1.4: Vòng xoay Boss Carousel Tương Tác Gõ Đầu Boss (Interactive Touch Ghibli Carousel - ĐỘT PHÁ MOM TEST)
*   **Phát biểu:**
    *   *Là một:* Chủ nuôi cô đơn quay lại trang Home,
    *   *Tôi muốn:* Có thể tương tác gõ nhẹ vào chú thú cưng Ghibli động ở đầu trang,
    *   *Để:* Nhận lại phản hồi xúc giác nhẹ kèm câu nói trêu đùa của Boss, tránh cảm giác nhàm chán tĩnh lặng.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Touch Area):** Chú Ghibli Boss màu nước (động bằng Lottie) ở đầu trang Home có vùng nhận diện cảm ứng (GestureDetector) nhạy bén.
    *   **AC-2 (Expressive Reaction):** Khi chạm vào Ghibli Boss:
        - Kích hoạt nhẹ phản hồi rung xúc giác của điện thoại (Haptic Feedback).
        - Boss hiển thị biểu cảm giật mình/nháy mắt ngộ nghĩnh.
        - Hiển thị bong bóng thoại nhỏ (Bubble text) ngẫu nhiên 1 trong 5 câu nói "khịa" chuẩn cá tính (Ví dụ: Mèo chảnh: *"Lại gõ đầu trẫm à Sen? Pate đâu?"*, Chó ngáo: *"Bắt quả tang Sen gõ đầu tớ nhé, đi chơi đi!"*).
    *   **AC-3 (Cool-down):** Đặt thời gian hồi chiêu (Cool-down) 5 giây giữa các lần gõ để tránh người dùng click liên tục gây spam thông báo.
