# TURN 15: THIẾT KẾ LẠI HỒ SƠ PET PHẲNG TỐI GIẢN MUJI
*(REDESIGNING EXTREME MINIMALIST PET PROFILE & FLAT SCHEMA)*

> **Mã Lượt Chat:** `TURN-01062026-15`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead)

---

## 🙋‍♂️ **Người dùng hỏi:**
> dặt tả lại pet profile theo hướng mà bạn đề xuất, chưa code. Hệ thống hoá database

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
**PM Sophia** và **Tech Lead Alan** xin báo cáo kết quả hoàn tất đặc tả nâng cấp **Hồ Sơ Pet Đa Chiều (`PetProfileScreen`)** và **Hệ thống hóa Cơ sở dữ liệu Cục bộ SQLite**.

Chúng tôi đã viết lại toàn bộ cẩm nang thiết kế và kiến trúc lập trình tại tệp đặc tả [SPEC_06_SHARABLE_PET_PROFILE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/SPEC_06_SHARABLE_PET_PROFILE.md).

---

### 🗺️ 1. Bản Đồ Tái Cấu Trúc Mã Nguồn Phẳng (Muji Clean Architecture)

Để giải quyết triệt để lỗi "God Class" khổng lồ hiện tại, chúng tôi đã chia nhỏ mã nguồn thành một thư mục phẳng, ngăn nắp:
*   **Màn hình chính (`pet_profile_screen.dart`):** Chỉ còn <500 dòng code, chịu trách nhiệm điều phối hiệu ứng kéo trượt `DraggableScrollableSheet` và Parallax Cover.
*   **Thư mục Component (`widgets/pet_profile/`):** Tách độc lập thành 8 tệp Widget con riêng lẻ (AppBar sương mù, Avatar thì thầm, Thẻ chẩn đoán vòng đời, Lưới polaroid hình ảnh, Hồ sơ tiêm phòng, Từ điển sở thích, Lịch ăn hạt & pate...).
*   **Quản lý trạng thái (`pet_profile_provider.dart`):** Sử dụng Riverpod `AsyncNotifier` gia đình để xử lý toàn bộ logic API ngầm và nạp database cục bộ, triệt tiêu hoàn toàn `setState` và các Rebuild thừa thãi.

---

### 🔄 2. Quy Trình Đồng Bộ Ngoại Tuyến Thầm Lặng (Offline-First Flow)

Loại bỏ hoàn toàn vòng xoay Loading vô tận khi người dùng mất mạng hoặc sóng yếu:
1.  **Đọc SQLite cục bộ ngay lập tức (<50ms):** Hiển thị ngay thông tin y tế, cân nặng và thói quen sinh hoạt đã lưu trên thiết bị.
2.  **Khởi chạy Background Sync Worker:** Gọi API ngầm để lấy dữ liệu mới nhất từ server.
3.  **So sánh & Hợp nhất:** So sánh mốc thời gian `updated_at`.
<truncated 1191 bytes>
ẩu phần ăn chi tiết (hạt, pate), dị ứng thức ăn và từ điển sở thích động trích xuất từ Cozy Chat.

---

### 🎨 4. Đặc Tả Nâng Cấp UI/UX Của Maya

*   **Khôi phục Bong bóng Thì Thầm (`w_avatar_whisper.dart`):** Giải phóng comment, hiển thị một bong bóng thoại phẳng màu sữa chứa lời tự sự chiêm nghiệm thấu cảm của Boss trích từ chat. Rung nhẹ máy khi chạm giữ.
*   **Xử lý va chạm Parallax:** Sử dụng Listener đo độ cuộn của sheet để nội suy tỷ lệ Scale của Avatar nổi (giảm từ `1.0x` về `0.0x`) đồng thời tăng dần độ mờ của Avatar nhỏ và Tên Pet trên AppBar. **Layout hoàn toàn sạch sẽ, không chồng lấn lên nhau khi kéo kịch trần.**
*   **Chia sẻ phân quyền thực tế:** Sen được chọn chia sẻ riêng *"Chế độ Thú Y"* (chỉ xuất cân nặng + vaccine) hoặc *"Chế độ Khách Sạn"* (chỉ xuất lịch ăn + dị ứng thức ăn), bảo vệ 100% sự riêng tư.

---

### 🎯 Tóm tắt các công việc đã thực hiện trong lượt này:
1.  **Code & UX Review:** Phân tích kỹ thuật chuyên sâu và tìm ra 6 điểm gãy lớn trong file mã nguồn 2.280 dòng hiện tại của Capcat.
2.  **Product Specification:** Viết lại toàn bộ cẩm nang đặc tả hồ sơ Pet tại [SPEC_06_SHARABLE_PET_PROFILE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/AUTHENTICATION_AND_ONBOARDING_ENGINE/SPEC_06_SHARABLE_PET_PROFILE.md) với thiết kế Clean Architecture, cơ chế Offline-first SQLite, khôi phục Whisper bubble và giải quyết va chạm giao diện.
3.  **Database Systematization:** Thiết lập cấu trúc Mermaids và SQLite Database 4 bảng được phân chia phân vùng bảo mật rõ ràng.

Tài liệu hiện tại đã đạt độ hoàn chỉnh tối đa cho khâu lập trình di động. Bạn đánh giá thế nào về bản đặc tả nâng cấp này của chúng tôi ạ?
