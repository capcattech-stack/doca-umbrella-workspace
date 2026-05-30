# TURN 18: TỔ CHỨC MÃ NGUỒN VÀ FOLDER TÀI LIỆU
*(NAMIYA DIRECTORY SCHEME & SPEC ORGANIZATION)*

> **Mã Lượt Chat:** `TURN-30052026-18`  
> **Chủ trì:** Alan (Tech Lead), Sophia (CPO / PM)

---

## 🙋‍♂️ **Người dùng hỏi:**
> đặt tả cho chức năng và giao diện viết thư ở trên cũng bỏ vào dây.  Luồng thư nhận nuôi cũng bỏ vào chung thu mục này

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã hoàn tất việc tổng hợp và cấu trúc lại toàn bộ các tài liệu đặc tả liên quan vào một phân mục lưu trữ hợp nhất đúng như yêu cầu của bạn. 

Hiện tại, thư mục phân hệ **`NAMIYA_MAILBOX_ENGINE`** đã chứa đầy đủ 3 tài liệu đặc tả dev-ready cốt lõi:

📁 **Thư mục phân hệ:** [Document/PRD/NAMIYA_MAILBOX_ENGINE/](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/)

---

### 🗂️ Danh sách các tài liệu đặc tả chi tiết bên trong:

1.  📄 **Đặc tả chính phân hệ:** [PRD_NAMIYA_MAILBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/PRD_NAMIYA_MAILBOX.md)
    *   **Nội dung:** Đặc tả chi tiết về tính năng **"Tiệm tạp hóa Namiya - Gỡ rối tơ lòng"**, 3 điểm chạm giao diện chiến lược (Pre-login, Home Widget, Cozy Chat AI trigger), sơ đồ luồng dữ liệu tuần tự Mermaid, đặc tả cơ chế thông báo **"Thùng Sữa"** và thiết kế API/Database Schema đi kèm.
2.  📄 **Đặc tả trình soạn thảo dùng chung:** [SPEC_NOTION_EDITOR.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_NOTION_EDITOR.md)
    *   **Nội dung:** Chi tiết về kiến trúc tối giản và mô-đun hóa của **CapcatNotionEditor** (màu nền, khoảng cách lề, font chữ, cơ chế FocusNode, Keyboard Accessory Bar, rung xúc giác Haptic và tự động cuộn trang chống che khuất). Bao gồm mã nguồn Flutter Dart hoàn chỉnh sẵn sàng tích hợp khi bạn quyết định viết code.
3.  📄 **Đặc tả luồng nhận nuôi ẩn:** [PRD_HIDDEN_ADOPTION_FLOW.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/PRD_HIDDEN_ADOPTION_FLOW.md)
    *   **Nội dung:** Đặc tả chi tiết về **Luồng nhận nuôi thú cưng thật ngoài đời thực** (ẩn ý cứu hộ chó mèo hoang khi danh sách thú cưng trống trên `MyPetsScreen`). Thiết kế nút CTA tinh tế, **AdoptPetBottomSheet** chia sẻ đầy trách nhiệm và cấu hình lọc tự nhiên tối thiểu 20 từ trước khi kích hoạt `url_launcher` mailto về `support@capcat.app`.

---

Toàn bộ các tài liệu nghiên cứu và đặc tả của chúng ta đều đã được đóng gói và lưu trữ ngăn nắp, sẵn sàng để phục vụ cho các phiên làm việc và lập trình tiếp theo. Mọi hành động trên đều tuân thủ chặt chẽ nguyên tắc **chỉ nghiên cứu đặc tả và lưu trữ tài liệu**, mã nguồn thực tế của ứng dụng hiện tại vẫn được giữ nguyên trạng thái gốc.

Bạn có muốn chúng ta nghiên cứu làm rõ thêm chi tiết tương tác hoặc khía cạnh trải nghiệm nào khác nữa không ạ?
