# EPIC 3: BUFFET KÝ ỨC TINDER GAME (TINDER SWIPE & MEME CARDS)
*(ĐẶC TẢ CHI TIẾT USER STORIES & ACCEPTANCE CRITERIA)*

---

## 📸 MÔ TẢ EPIC
Phân hệ này xây dựng cơ chế nạp hình ảnh/ký ức Boss vào app một cách siêu tốc, an toàn quyền riêng tư, và có tính giải trí gây nghiện cao. Tích hợp công nghệ AI nhận diện ảnh cục bộ offline và tính năng tạo thẻ bài meme độc bản để lan tỏa nhận diện thương hiệu.

---

## 📋 DANH SÁCH USER STORIES

### US-3.1: Xin quyền Limited Access & Quét ảnh Pet Cục bộ (Offline ML Kit)
*   **Phát biểu:** 
    *   *Là một:* Người dùng chú trọng bảo mật riêng tư,
    *   *Tôi muốn:* Ứng dụng chỉ được phép xem các bức ảnh mà tôi cho phép,
    *   *Để:* Tôi cảm thấy an toàn và tin cậy khi sử dụng.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Limited Dialog):** Hệ thống kích hoạt hộp thoại phân quyền hệ điều hành dạng **"Chỉ cho phép truy cập các ảnh được chọn"**.
    *   **AC-2 (Offline Scan):** Bộ quét ảnh chạy ngầm cục bộ 100% bằng ML Kit trên máy người dùng, nhận diện và lọc ra tối đa 15 ảnh chứa Chó/Mèo trong số ảnh được phân quyền. **Tuyệt đối không gửi ảnh lên máy chủ trong bước này.**
    *   **AC-3 (Failure State):** Nếu quét không ra ảnh Pet nào, hiển thị màn hình trống thân thiện hướng dẫn người dùng cách bấm nút nạp thêm ảnh Pet trong Cài Đặt.
    *   **AC-4 (Prominent Settings Button - ĐỘT PHÁ MOM TEST):** Nút **"Cập nhật ảnh cho phép quét"** (Permission Update) được đặt ở vị trí nổi bật tại Tab Settings với biểu tượng Camera tươi sáng để người dùng dễ dàng nạp thêm ảnh dìm mới bất cứ lúc nào.

---

### US-3.2: Trò chơi "Buffet Ký Ức" 5 giây (Tinder Swipe Card Game)
*   **Phát biểu:**
    *   *Là một:* Chủ nuôi bận rộn và lười upload ảnh,
    *   *Tôi muốn:* Vuốt trái/phải các thẻ bài ảnh dìm Boss như chơi game Tinder,
    *   *Để:* Nạp ký ức nhanh chóng dưới 5 giây và nhận Dopamine tương tác vui vẻ.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Swipe UI):** Hiển thị 15 ảnh đã quét dưới dạng một stack thẻ bài xếp chồng lên nhau ở trung tâm trang Home. Cho phép vuốt trái hoặc vuốt phải mượt mà kèm hiệu ứng xoay nghiêng thẻ bài theo ngón tay kéo.
    *   **AC-2 (Swipe Right Action):** Vuốt phải = Đồng ý nạp ảnh. Ảnh lập tức được tải lên ngầm (Background upload), tạo bài viết Moments mới, cộng `Intimacy +5` cho Pet, và kích hoạt bong bóng thoại AI chọc ghẹo bay lên từ đầu Boss.
    *   **AC-3 (Swipe Left Action):** Vuốt trái = Bỏ qua ảnh. Thẻ bài bay ra ngoài màn hình và ảnh giữ nguyên trạng thái riêng tư cục bộ trên máy.
    *   **AC-4 (Feast Summary):** Khi vuốt hết 15 ảnh, hiển thị màn hình tổng kết Boss vẽ màu nước Ghibli nằm ôm bụng căng tròn no nê và tặng thưởng 1 viên Kẹo Ảo.
    *   **AC-5 (Dynamic Banner Hiding - ĐỘT PHÁ MOM TEST):** 
        - *GIVEN* Người dùng chưa chơi Buffet tuần này -> Banner Buffet hiện to rực rỡ ở giữa trang Home.
        - *GIVEN* Người dùng đã hoàn thành Buffet tuần này -> Banner tự động ẩn hoàn toàn hoặc thu nhỏ thành 1 icon nhỏ góc màn hình để giải phóng diện tích cho Moments Feed.

---

### US-3.3: Thẻ bài Meme ghép khung tự động (Meme Card Generator - 0đ)
*   **Phát biểu:**
    *   *Là một:* Người nuôi thú cưng thích khoe ảnh dìm,
    *   *Tôi muốn:* Tự động ghép khuôn mặt của Boss trong ảnh dìm vào các khung hình meme hài hước vẽ sẵn,
    *   *Để:* Dễ dàng tải về hoặc chia sẻ lên Story Instagram/Facebook.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Local Compositing):** App tự động sử dụng thư viện đồ họa cục bộ trên máy để cắt khuôn mặt Boss và ghép đè vào các khung hình meme Ghibli ngộ nghĩnh (không gọi API tốn phí).
    *   **AC-2 (Template Library):** Cung cấp danh sách các khung hình meme (phi hành gia, hoàng đế) trượt ngang phía dưới để người dùng thay đổi khung hình theo ý thích.
    *   **AC-3 (Social Share):** Nút **"Chia sẻ Story"** hoạt động chính xác, tạo ra ảnh đầu ra chất lượng cao kèm watermark nhỏ "Capcat: Soul of Pet" ở góc dưới.

---

### US-3.4: Bộ lọc nhanh Moments Feed theo từng Pet (Quick Filter Tags - ĐỘT PHÁ MOM TEST)
*   **Phát biểu:**
    *   *Là một:* Chủ nuôi có nhiều Pet,
    *   *Tôi muốn:* Lọc nhanh các bài viết trên Moments Feed theo từng Pet riêng biệt,
    *   *Để:* Bảng tin Moments của tôi không bị loạn ảnh chó mèo trộn lẫn.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Filter Bar UI):** Hiển thị thanh bộ lọc trượt ngang nhỏ gọn ngay phía trên Moments Feed (Ví dụ: `[Tất cả] | [Lucky 🐶] | [Bánh Mỳ 🐱]`).
    *   **AC-2 (Filtering Logic):** Khi chọn lọc theo Pet nào, Moments Feed ngay lập tức cập nhật mượt mà (Fade transition) chỉ hiển thị các Moments có gắn `petId` của Pet đó.
