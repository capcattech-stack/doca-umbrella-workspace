# TURN 06: CƠ CHẾ KÍCH HOẠT BUFFET KỶ NIỆM & THIẾT KẾ LƯỚI SO LE WABI-SABI HỘP KÝ ỨC
*(TINDER BUFFER TRIGGERS & JAPANDI WABI-SABI MASONRY GALLERY)*

> **Mã Lượt Chat:** `TURN-30052026-06`  
> **Chủ trì:** Sophia (CPO / PM), Maya (UI/UX Designer), Alan (Tech Lead), Bella (Lead Animator)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Vuốt thẻ bài sẽ được trigger thế nào ? Mới onboard, cuối tuần rảnh rỗi,haowcj các lý do khác mà bạn đề xuất sẽ là trigger chủ động, chưng 10-15 hình. Còn nếu người dùng vào hợp kí ức họ có thế thêm ký ức theo cách phổ thông có thể chọn sự kiệ, hoặc chọn hình ảnh hoạc cả 2 . Nếu chỉ chọ hình ảnh thì sẽ gióng 1 ký ức được quét trên thẻ. còn nếu chọn sự kiện thi sẽ là 1 dòng khác biệt và nổi bật có icon. hộp ký ức nên có thể sort theo ngày tải lên hoặc ngày chụp (metadata) . Còn về layout theo dạn nào hợp mood thì nhờ maya tư vấn.

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chúng tôi đã phân tích thấu đáo và cập nhật trực tiếp các giải pháp chữa lành đột phá vào **[SPEC_01_SWIPE_STACK_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_01_SWIPE_STACK_ENGINE.md#L68)** và **[SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md)**:

1.  **5 Kịch bản kích hoạt Buffet Ký ức (Tinder Swipe Triggers):**
    *   **Kịch bản 1: Mới Onboarding:** Bốc nhanh 10-15 ảnh đầu tiên chạy stack giúp Sen làm quen game lập tức.
    *   **Kịch bản 2: Chiều cuối tuần thảnh thơi:** Nhắc nhở Boss ngáp lười rủ Sen lướt kỷ niệm vào Thứ 7/Chủ Nhật.
    *   **Kịch bản 3: Chạm mốc thân mật (Intimacy Milestone):** Mừng cấp độ thân thiết mới.
    *   **Kịch bản 4: Kỷ niệm trở về (Golden Reunion):** Trị liệu xa cách khi Sen vắng mặt 7+ ngày.
    *   **Kịch bản 5: Đổi mùa tĩnh lặng (Seasonal Solstice):** Rủ xem lại ảnh cùng mùa này ở năm ngoái khi thời tiết dông bão/se lạnh.
2.  **Luồng thêm ký ức thủ công phối trộn độc đáo:**
    *   **Photo Only:** Polaroid Card truyền thống hiển thị ảnh kèm chữ viết tay.
    *   **Event Only:** Event Card có màu nền pastel theo nhóm chăm sóc và một **Icon sự kiện lớn nổi bật** ở bên trái (🛁, 💉, 🏥).
    *   **Both (Photo + Event Hybrid):** Polaroid Hybrid Card đặc biệt, có ảnh Polaroid làm tâm điểm và một **Huy hiệu Sự kiện (Care Event Badge)** nhỏ xinh đè nhẹ lên góc ảnh.
3.  **Thuật toán Sắp xếp đa chiều (Dual Sorting):**
    *   **Ngày Chụp (EXIF Photo Taken Date - Mặc định):** Phản ánh đúng chuỗi lớn lên tự nhiên của Boss.
    *   **Ngày Tải Lên / Thêm vào (Added Date):** Giúp tìm nhanh các ký ức vừa tạo hôm nay.
4.  **Layout Wabi-Sabi Masonry (Maya tư vấn):**
    *   Thiết kế lưới so le đứng 2 cột với chiều cao thẻ co giãn tự nhiên (Masonry Grid) như một cuốn sổ dán Scrapbook thủ công thay thế lưới vuông công nghiệp.
    *   Chuyển cảnh mượt mà 60 FPS kết hợp cảm ứng Gyroscope nghiêng bóng đổ bụi nắng bay xiên độc bản.
