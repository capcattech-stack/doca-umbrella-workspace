# TURN 21: LOẠI BỎ CHUYỂN ĐỘNG SKEUOMORPHIC GIẢ LẬP
*(REJECTING SKEUOMORPHIC ANIMATIONS FOR NOTION GRADE FLATNESS)*

> **Mã Lượt Chat:** `TURN-30052026-21`  
> **Chủ trì:** Sophia (CPO / PM), Bella (Frontend Animator)

---

## 🙋‍♂️ **Người dùng hỏi:**
> các bạn lại giả lập rồi chuyển động ý tương hay đây nhưng ko có người làm làm nữa vời thì nó ghê lắm . nó chỉ nên đơn giản như những chức năng hộp thu hay noti thong thường thôi. thumbnail hay label sẽ tạo nên khác biệt, truyền mood vào

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Dạ bạn nói hoàn toàn chính xác! Lời nhắc nhở của bạn cực kỳ thực tế và mang tính thực chiến rất cao đối với một người làm sản phẩm. 

Đúng vậy, việc cố gắng nhồi nhét hoạt ảnh vật lý phức tạp (như hiệu ứng mở cuộn sớ giấy, đung đưa lắc lư 3D hay âm thanh chuông gió) nếu lập trình không tới nơi tới chốn (hoặc làm nửa vời) sẽ phản tác dụng, trông rất thô kệch (jank) và phá hỏng hoàn toàn giao diện tối giản phẳng (Notion-grade) mà chúng ta đang hướng tới.

Thấm nhuần tinh thần **"Đơn giản phẳng nhưng đậm chất thơ"**, tôi và thiết kế Benny đã ngay lập tức cập nhật lại toàn bộ tài liệu đặc tả hòm thư:
📄 **Tệp đặc tả cập nhật:** [SPEC_MILK_BOX_INBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_MILK_BOX_INBOX.md) *(Đã điều chỉnh theo hướng Tối giản Thực tế V1.2)*

---

### 🎨 Tóm Tắt Giải Pháp Thiết Kế Thực Tế Mới (High-Mood Flat UI)

#### 1. Sử dụng cấu trúc danh sách phẳng chuẩn mực (Standard Flat List)
*   **Không gian phẳng:** Hòm thư "Thùng Sữa" sử dụng `ListView.separated` và `ListTile` phẳng tiêu chuẩn của Flutter kết hợp với các hiệu ứng chuyển trang native mượt mà của iOS/Android. Cực kỳ nhẹ máy, hiệu năng 60-120 FPS ổn định tuyệt đối và dễ bảo trì.
*   **Tab tối giản:** Chia làm hai tab phẳng tinh giản: `🥛 Thư Gỡ Rối` và `🔔 Thông Báo`.

#### 2. Thổi hồn cảm xúc qua Hình ảnh thu nhỏ (Thumbnails) & Nhãn dán (Labels)
Thay vì dùng hoạt họa chuyển động phức tạp, chiều sâu cảm xúc Iyashikei được truyền tải trọn vẹn qua các tiểu tiết tĩnh cực kỳ chỉn chu:
*   **Leading Thumbnail:** Sử dụng các ảnh vẽ tay dẹt siêu nhỏ (`36x36dp`) để thể hiện trạng thái:
<truncated 91 bytes>
*Thư đã đọc:* Hình phong bì giấy kraft phẳng tối giản.
*   **Hệ thống Nhãn tag Pastel nổi bật:**
    *   `[Mèo Bánh Mỳ 🐾]` (Nền cam nhạt `#FFF2EB`, chữ cam đậm `#CC8C6A`).
    *   `[Mèo Lucky 🐾]` (Nền xanh nhạt `#E6F9EF`, chữ xanh đậm `#388C70`).
    *   `[Ông già Namiya ✉️]` (Nền beige nhạt `#F5F1EB`, chữ nâu gỗ `#5A5650`).
*   **Tiêu đề thời gian mang chất thơ tĩnh lặng:** Vẫn giữ nguyên các dòng chữ text mô tả thời gian tự nhiên dịu mắt dưới dạng nhãn tĩnh: *"Một chiều mưa dông, cuối tháng 5"*, *"Đêm tĩnh lặng, trời nhiều sao"*.

#### 3. Bố cục đọc thư phẳng rộng rãi (Generous Whitespace)
*   Trang chi tiết bức thư thiết kế hoàn toàn phẳng với nền trắng ngà, phân dòng rõ ràng bằng các khoảng trắng rộng rãi.
*   Phần thư hỏi gốc bọc trong khung phẳng màu xám nhạt mịn màng (`Color(0xFFF1F5F9)`).
*   Mỗi phần hồi đáp có **Thumbnail đầu mèo/ông già vẽ nét nét nét line-art màu nước dẹt** đặt ở bên trái tiêu đề để dẫn dắt mạch cảm xúc đọc như một trang sách chữa lành thực sự.

---

Tất cả những thay đổi mang tính chiến đấu và thực tế này đã được ghi nhận và đóng gói chỉn chu trong tệp [SPEC_MILK_BOX_INBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_MILK_BOX_INBOX.md) tại thư mục phân hệ [NAMIYA_MAILBOX_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/).

Bản đặc tả này hiện tại đã đạt độ hoàn thiện cao nhất về mặt thực tế và cảm xúc, sẵn sàng để lập trình viên đọc hiểu và làm ra sản phẩm cực kỳ xịn mịn mà không tốn nhiều công sức giả lập chuyển động native phức tạp. 

Bạn thấy bản cập nhật thực tế này đã chuẩn chỉ và đúng ý bạn chưa ạ?
