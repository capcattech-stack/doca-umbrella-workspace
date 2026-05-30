# TURN 17: VỊ TRÍ ĐẶT TÍNH NĂNG HỘP THƯ NAMIYA
*(NAMIYA MAILBOX ENTRY POINT MATRIX)*

> **Mã Lượt Chat:** `TURN-30052026-17`  
> **Chủ trì:** Sophia (CPO / PM), Arthur (Mom Test Expert)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Vậy chúng ta hay tìm vị tri đặt tính năng này. thâm chí tôi nghĩ có thể đặt nó trước cả bước đăng ký đăng nhập, ở Home và có thể cho các pé pets nhắc đến trong những đoạn chat. Luồng đơn giản. 1 click to typing..... rồi gửi đi. sau đó chờ thư hồi âm. Thu hồi âm sẽ dến ở 1 thông báo ,như mục thong báo này tôi sẽ đặt tên là thùng sữa cho gióng với câu chuyện chính. tên chưuc năng cũng là Tiệm tạp hoá Namiya - Gỡ rối tơ lòng. Luống bên dưới thì đơn giản là gủi thư về mail cho tôi, tôi sẽ trả lời thu trả lời sẽ được gũi đến mail đk và đến hộp sữa thông báo trên app. họ có thể đọc ở cả 2 nơi. đặt tả vẽ luồng nhé. Tạo thành 1 folder cho chức năng

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã làm việc chặt chẽ cùng chuyên gia nghiên cứu thị trường **Arthur** và kỹ sư di động **Benny** để hiện thực hóa toàn bộ ý tưởng đột phá của bạn thành một tài liệu đặc tả PRD hoàn chỉnh và lưu trữ trong thư mục riêng của phân hệ mới này:

📁 **Đường dẫn thư mục phân hệ mới:** [Document/PRD/NAMIYA_MAILBOX_ENGINE/](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/)  
📄 **Tệp đặc tả PRD chi tiết:** [PRD_NAMIYA_MAILBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/PRD_NAMIYA_MAILBOX.md)

---

### 🌟 Tóm Tắt Giải Pháp & Thiết Kế Đã Đạt Tả

#### 1. Ba Điểm Chạm Giao Diện (Multi-Entry Points)
*   **Trước Đăng Ký (Guest Mode):** Đặt một link dẫn nhẹ nhàng *"Ghé Tiệm tạp hóa Namiya viết thư gửi tơ lòng (Ẩn danh) ✉️"* ngay tại màn hình Login/Register. Điều này đóng vai trò là phễu thu hút (Viral Loop) cực tốt cho những người dùng chưa sẵn sàng tạo tài khoản hay chưa có thú cưng.
*   **Màn Hình Chính (Home Widget):** Một chiếc hộp gỗ Wabi-Sabi mộc mạc đặt cạnh bình hoa nhỏ, mời gọi viết thư.
*   **Lời nhắc từ Boss trong Cozy Chat (AI Trigger):** Khi chat, nếu AI của Pet phát hiện Sen đang buồn bã, nó sẽ chủ động và tự nhiên khuyên Sen ghé hòm thư gỗ Namiya ngoài Home để trút bầu tâm sự.

#### 2. Thùng Sữa Namiya (Milk Box Notification Box) - Hòm Thư Chữa Lành
*   Đúng tinh thần tác phẩm, câu trả lời từ Admin (Ông già Namiya & 3 Mèo mascot) sau khi trả lời từ email sẽ được tự động đổ về **"Thùng Sữa" (Milk Box)** trên app và gửi song song về email đăng ký của người dùng.
*   **UX "Thùng Sữa":** Có icon chai sữa gỗ lắc lư khi có thư mới. Khi mở ra, nội dung được định dạng như cuộn giấy viết tay ngà mộc mạc, chia làm hai phần: *Lời khuyên hóm hỉnh của mèo* và *Lời khuyên sâu sắc từ ông già Namiya*.

#### 3. Sơ đồ Luồng Kỹ Thuật (System Sequence Diagram)
*   Vẽ chi tiết sơ đồ Mermaid luồng đi của lá thư từ Client (Guest/User) -> Server API -> Email Admin (`support@capcat.app`).
*   Và luồng hồi âm từ Admin -> Server -> Trả về song song qua Email khách & Đẩy về Hộp thông báo "Thùng Sữa" trên app.

#### 4. Cấu Trúc Dữ Liệu & API (Backend & Database Spec)
*   Thiết kế sẵn lược đồ cơ sở dữ liệu (SQLite/Server Schema) gồm 2 bảng: `namiya_letters` (lưu thư gửi) và `namiya_replies` (lưu thư phản hồi).
*   Định nghĩa rõ ràng cấu trúc JSON cho các API endpoints `POST /api/namiya/send_letter` và `GET /api/namiya/replies`.

---

Toàn bộ tài liệu đặc tả PRD và thiết kế luồng này hiện đã được lưu trữ an toàn trong dự án tại tệp [PRD_NAMIYA_MAILBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/PRD_NAMIYA_MAILBOX.md). Chúng ta vẫn đang ở **giai đoạn nghiên cứu/đặc tả và chưa thay đổi bất kỳ dòng code nào** của dự án.

Bạn hãy xem qua tài liệu PRD này và cho tôi biết cảm nhận cũng như chỉ đạo tiếp theo của bạn nhé!
