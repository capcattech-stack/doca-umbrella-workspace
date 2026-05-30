# CapCat - Soul of Pet 🐾

Ứng dụng kết nối cảm xúc, lưu trữ kỷ niệm và chữa lành sự cô đơn dành cho những người yêu thương thú cưng.

---

## 🛠️ Trình Soạn Thảo Notion-Grade Tái Sử Dụng (Reusable Notion-Style Writing Editor)

Trình soạn thảo văn bản được phát triển cho chức năng ẩn nhận nuôi thú cưng được thiết kế theo triết lý **Modularity (Mô-đun hóa)** và **Decoupled Architecture (Kiến trúc phân tách)**. Điều này cho phép tái sử dụng toàn bộ giao diện và logic soạn thảo cho các tính năng viết lách khác trong tương lai của Capcat mà không cần viết lại mã nguồn.

### 🌟 Tính Năng Nổi Bật của Trình Soạn Thảo:
1. **Thiết kế Tối giản phẳng (Notion-grade Flat UI):** Loại bỏ hoàn toàn đường viền cứng nhắc, mang lại không gian viết rộng rãi và thư thái.
2. **Focus Management mượt mà:** Điều hướng tiêu điểm thông minh từ ô Tiêu đề tự động nhảy xuống Thân bài viết.
3. **Thanh công cụ Accessory Bar dính bàn phím:** Tự động điều chỉnh theo trạng thái nổi lên của bàn phím hệ thống, tích hợp phản hồi xúc giác nhẹ (Haptics) khi bấm nút.
4. **Bộ đếm từ thời gian thực (Real-time Word Count):** Cập nhật liên tục để đo lường độ dài của nội dung.
5. **Keyboard-Aware Physics:** Tự động điều chỉnh cuộn màn hình để dòng chữ đang gõ luôn nằm ngang tầm mắt người dùng, không bao giờ bị bàn phím che khuất.

### 🔄 Các Kịch Bản Tái Sử Dụng Trong Tương Lai:
Với thiết kế hướng mô-đun, trình soạn thảo này có thể dễ dàng tái cấu trúc thành một Widget dùng chung (ví dụ: `CapcatNotionEditor`) để tích hợp vào các chức năng sau:
*   **Trình viết Nhật ký / Moments:** Người dùng ghi lại các câu chuyện hàng ngày với Boss.
*   **Hộp thư tâm tình (Feedback & Love letters):** Gửi phản hồi, đóng góp ý kiến hoặc chia sẻ câu chuyện trực tiếp cho đội ngũ vận hành Capcat.
*   **Trình tạo Caption thông minh:** Cho phép chỉnh sửa caption tự do sau khi AI đề xuất trước khi đăng bài.

---

## ⚖️ Quy Trình Đánh Giá Đồng Bộ Tính Năng (Feature Alignment & Mom Test Workflow)

Để bảo vệ sứ mệnh chữa lành cảm xúc cốt lõi của Capcat, mọi đề xuất tính năng mới trong tương lai bắt buộc phải tuân thủ nghiêm ngặt quy trình đánh giá dưới đây trước khi đưa vào phát triển kỹ thuật:

### 🧭 Bộ 3 Câu Hỏi Vàng (Khung Đánh Giá Tầm Nhìn):
1. **Câu hỏi 1:** *Tính năng này có giải quyết trực tiếp sự cô đơn hoặc mang lại tiếng cười cho người dùng không?*
2. **Câu hỏi 2:** *Tính năng này có dựa trên hoặc làm giàu thêm hồ sơ sinh học (`PetDetail`) và bộ nhớ kỷ niệm (`Moments`) của Boss không?*
3. **Câu hỏi 3:** *Nó có thúc đẩy tương tác 2 chiều hài hước, biến thiên không?*

> **Định mức thông qua:** Tính năng bắt buộc phải đạt **3/3 điểm ĐỒNG Ý**.

### 👩‍👦 Quy trình kiểm thử Mom Test:
*   Sau khi vượt qua Bộ 3 Câu Hỏi Vàng, tính năng sẽ được đưa vào mô phỏng **Mom Test** (tương tác trực tiếp với các tệp Persona ảo chân thực) để đánh giá hành vi và nhu cầu thực tế ngoài đời thực, lọc bỏ các giả định chủ quan trước khi tiến hành viết code.
