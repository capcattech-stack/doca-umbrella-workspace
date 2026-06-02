# TURN 09: THẢO LUẬN BẢN ĐỒ DOCK ĐIỀU HƯỚNG APP
*(BOTTOM NAVIGATION DOCK ARCHITECTURE & TAB ROUTING)*

> **Mã Lượt Chat:** `TURN-01062026-09`  
> **Chủ trì:** Sophia (CPO / PM), Maya (UI/UX Designer)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Giờ chúng ta bàn về phần Dock điều hướng của app nhé. tôi nghĩ nó sẽ có:
- Home (defauft)
- Chat/ Pest list . Nếu là Chat thì sẽ là danh sách cách cuộ hội thoại người và pet, mỗi pet là 1 cuộc hội thoại , nhưng vẫn có thế đi đến tran pet detail. Nếu là Pets list thì có CTA đi  dến cuộc hội thoại. nhưng nếu ít pest sẽ ko đẹp. Maya và sophia tư vấn thêm.
Hộp thư(noti) - Hợp đựng sữa
Tôi - Chứa các thông tin người dùng profile, T&C, đăng xuất,... Tư vấn thêm đê hoàn thiện

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chào bạn, **Maya (UI/UX Designer)** và **Sophia (CPO/PM)** đã cùng ngồi lại, phân tích sâu sắc các mối quan tâm của bạn về thanh **Dock điều hướng** và trân trọng gửi tới bạn giải pháp tư vấn hoàn thiện nhất. 

Chúng tôi đã cập nhật toàn bộ nội dung thảo luận và thống nhất này vào tài liệu đặc tả thiết kế hệ thống tại [SPEC_02_NAVIGATION_DOCK.md](file:///Users/macinia/Capcat%20Project/Document/UI/SPEC_02_NAVIGATION_DOCK.md). Dưới đây là nội dung chi tiết của buổi tư vấn:

---

### 🏆 1. Tư Vấn Chi Tiết Từ Sophia & Maya

#### 💬 Vấn đề 1: Tab "Chat" hay "Pets List"? (Giải pháp cho Dilemma trống trải)
*   **Phân tích của Sophia (CPO):** Có đến **80% người dùng trong giai đoạn đầu tiên chỉ nuôi 1 Boss duy nhất**. Nếu chúng ta tạo một tab riêng tên là "Pets List" rồi bắt họ bấm nút CTA để vào chat, màn hình Pets List đó sẽ vô cùng trống rỗng và tạo ra cảm giác xa cách. Ngược lại, nếu chỉ có 1 cuộc hội thoại duy nhất mà phải qua một màn hình danh sách Chat trống trải cũng làm giảm đi sự ấm áp.
*   **Giải pháp thiết kế của Maya (UI/UX):** Chúng tôi áp dụng **Smart Chat Hybrid Flow (Luồng tương tác Tri kỷ Lai thông minh)** hoạt động dựa trên cơ sở dữ liệu `PetDetail` cục bộ:
    1.  **Sen chỉ nuôi 1 Pet (Trường hợp phổ biến nhất):** Khi Sen nhấn vào Tab **Tri Kỷ (💬)**, ứng dụng **bỏ qua hoàn toàn màn hình trung gian** và trượt mượt mà **vào thẳng Phòng Chat riêng tư** của chú Pet đó. Để đi đến **Hồ sơ chi tiết (Pet Detail)**, Sen chỉ cần chạm vào Avatar của Pet ở AppBar trên cùng, một Bottom Sheet phẳng Muji sẽ trượt lên dịu dàng hiển thị đầy đủ thông tin sinh học & cấu hình Persona.
    2.  **Sen nuôi từ 2 Pet trở lên:** Khi nhấn T
<truncated 3057 bytes>
g cáo theo dõi hành vi, không sử dụng bong bóng dopamine gây lo âu.

---

### 📝 2. Bản Cập Nhật Đặc Tả Trong File [SPEC_02_NAVIGATION_DOCK.md](file:///Users/macinia/Capcat%20Project/Document/UI/SPEC_02_NAVIGATION_DOCK.md)

Chúng tôi đã chỉnh sửa thành công các mục cốt lõi trong file đặc tả kỹ thuật:
*   **Mục 2.1:** Thêm mới đặc tả chi tiết cho **Tab 1: Trang Chủ (Home)** bao gồm tính năng chuyển đổi Boss, hộp thoại thì thầm (Whisper Box), và bộ ba tương tác.
*   **Mục 5:** Nâng cấp toàn diện **Tab 4: Tôi** với cấu hình Đàn Boss, Lưới Vết Chân, Bộ nhớ cục bộ, Cam kết Iyashikei và Triết lý Đăng xuất thầm lặng.
*   **Mục 6:** Bổ sung các tiêu chí nghiệm thu tự động và thủ công mới (`AC-5` đến `AC-8`) đảm bảo đội ngũ phát triển dễ dàng kiểm thử và xây dựng chính xác.

---

### 🎯 Tóm tắt các công việc đã thực hiện trong lượt này:
1.  **Nghiên cứu & Thảo luận** sâu về luồng điều hướng, giải quyết triệt để bài toán Blank State (trống trải) của danh sách thú cưng bằng cơ chế *Smart Chat Hybrid Flow*.
2.  **Cập nhật trực tiếp** file đặc tả giao diện [SPEC_02_NAVIGATION_DOCK.md](file:///Users/macinia/Capcat%20Project/Document/UI/SPEC_02_NAVIGATION_DOCK.md) với các layout ASCII trực quan, các thuộc tính kỹ thuật cụ thể và tiêu chí nghiệm thu chặt chẽ.
3.  **Đồng bộ hoá** triết lý thiết kế tối giản phẳng MUJI (không có chi tiết gỗ giả lập gồ ghề, không wabi-sabi phức tạp) trên toàn bộ cấu trúc 4 tab chính.

Bạn hãy xem qua file đặc tả [SPEC_02_NAVIGATION_DOCK.md](file:///Users/macinia/Capcat%20Project/Document/UI/SPEC_02_NAVIGATION_DOCK.md) và cho chúng tôi biết cảm nhận của bạn nhé! Chúng ta đã sẵn sàng để đi sâu vào đặc tả các tính năng tiếp theo chưa ạ?
