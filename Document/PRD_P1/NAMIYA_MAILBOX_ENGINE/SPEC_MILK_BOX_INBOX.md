# 🥛 ĐẶC TẢ CHI TIẾT: THÙNG SỮA NAMIYA & THÔNG BÁO TỐI GIẢN
*(SPEC_MILK_BOX_INBOX - PRAGMATIC FLAT NOTIFICATION & INBOX UX SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC_MILK_BOX_INBOX`  
> **Phân hệ cha:** `NAMIYA_MAILBOX_ENGINE`  
> **Người biên soạn:** Sophia (CPO / PM) & Benny (Lead UI/UX)  
> **Trạng thái:** Hoàn thành (Dev-Ready & Low-Complexity)  

---

## I. TRIẾT LÝ UX/UI: ĐƠN GIẢN, PHẲNG & ĐẬM CHẤT THƠ (FLAT & HIGH-MOOD)

> **Lưu ý quan trọng từ CPO & Dev:**  
> Để tránh việc giả lập chuyển động vật lý nửa vời dễ gây cảm giác nặng nề hoặc lỗi thời (skeuomorphic jank), **Thùng Sữa Namiya** sẽ được triển khai hoàn toàn bằng **giao diện phẳng (Flat Modern UI) tối giản và chuẩn mực**. 
> 
> Sự khác biệt, chiều sâu cảm xúc và tính chữa lành (Iyashikei mood) sẽ được truyền tải trọn vẹn thông qua:
> 1.  **Hệ thống Nhãn (Labels/Tags) ấm áp:** Phân loại phản hồi rõ ràng.
> 2.  **Ảnh đại diện thu nhỏ (Thumbnails):** Nét vẽ tay màu nước tối giản mô tả chai sữa, nắp sáp niêm phong hoặc chân dung 3 chú mèo.
> 3.  **Từ ngữ gợi mood:** Tiêu đề thư thơ mộng và các dòng thông báo được cá nhân hóa chậm rãi.

---

## II. ĐIỂM CHẠM VÀ THÔNG BÁO HỆ THỐNG (ENTRY POINTS & PUSH)

### 1. Icon Hòm Thư trên Home Screen
*   **Giao diện:** Một icon dẹt đơn giản vẽ tay hình chiếc thùng sữa gỗ nhỏ nhắn, nằm thanh lịch ở góc trên màn hình Home.
*   **Thông báo mới:** Khi có thư hồi âm mới, một nhãn nhỏ màu đào pastel (`AppColors.pinkGenderAccent`) hiển thị chữ *"Có thư mới 🐾"* xuất hiện nhẹ nhàng ngay bên cạnh icon. Không nhấp nháy, không đỏ chói, tôn trọng sự tĩnh lặng của người dùng.

### 2. General App Notifications (Nhật ký Chuông Gió)
*   Tất cả các thông báo hệ thống thông thường (thích, bình luận Moments) được hợp nhất chung vào một luồng danh sách chuẩn của app nhưng được viết lại với lời văn ấm áp:
    *   *“Lucky đã yêu thích kỷ niệm 'Chiều nắng ấm' của bạn.”*
    *   *“Bánh Mỳ vừa gửi đến bạn một lời thì thầm đêm muộn.”*

---

## III. GIAO DIỆN HÒM THƯ "THÙNG SỮA" (FLAT INBOX LIST)

Khi mở hòm thư, ứng dụng hiển thị một trang danh sách phẳng chuẩn mực, cuộn dọc mượt mà (`ListView.separated`), tối ưu hóa hiệu năng tối đa:

```
+---------------------------------------------------+
|  [<]               Thùng Sữa Namiya               |  <-- Standard Flat Header (Cao: 56dp)
+---------------------------------------------------+
|                                                   |
|   🥛 Thư Gỡ Rối            🔔 Thông Báo           |  <-- Standard Flat Tabs
|  ================          -------------          |
|                                                   |
|   +-------------------------------------------+   |
|   | [Icon 🥛]  "Một chiều mưa dông..."        |   |  <-- Item 1: Thumbnail chai sữa vẽ tay
|   |            Phản hồi bởi: Mèo Bánh Mỳ 🐾   |   |  <-- Nhãn tag chú mèo
|   |            Đêm mưa rơi, cuối tháng 5      |   |  <-- Tiêu đề thời gian thơ ca
|   +-------------------------------------------+   |
|                                                   |
|   +-------------------------------------------+   |
|   | [Icon ✉️]  "Bức thư gửi từ trăng khuyết..."|   |  <-- Item 2: Thumbnail phong bì thư dẹt
|   |            Phản hồi bởi: Ông già Namiya   |   |
|   |            Đêm tĩnh lặng, nhiều sao       |   |
|   +-------------------------------------------+   |
|                                                   |
+---------------------------------------------------+
```

### 1. Cấu trúc mỗi Item Thư trong danh sách (`ListTile` chuẩn):
*   **Leading (Bên trái - Thumbnail):** Một ảnh vẽ tay màu nước dẹt siêu nhỏ (`36x36dp`):
    *   Nếu là thư mới chưa đọc: Hình chai sữa tươi có nắp thắt dây đỏ.
    *   Nếu là thư đã đọc: Hình phong bì thư giấy kraft phẳng tối giản.
*   **Title (Ở giữa - Tiêu đề & Nhãn):**
    *   Tiêu đề bức thư dựa trên cảm xúc hoặc mốc thời gian thơ ca (Ví dụ: *"Đêm tĩnh lặng, trời nhiều sao"*, *"Một chiều mưa dông, cuối tháng 5"*).
    *   Một dòng nhãn nhỏ (Label/Tag) có nền màu pastel nhẹ nhàng mô tả người trả lời: 
        *   `[Mèo Bánh Mỳ 🐾]` (Nền màu cam nhạt `#FFF2EB`, chữ màu cam đậm `#CC8C6A`).
        *   `[Mèo Lucky 🐾]` (Nền màu xanh nhạt `#E6F9EF`, chữ màu xanh đậm `#388C70`).
        *   `[Ông già Namiya ✉️]` (Nền màu beige nhạt `#F5F1EB`, chữ màu nâu gỗ `#5A5650`).
*   **Subtitle (Dưới cùng - Trích đoạn):** Một dòng ngắn hiển thị trích đoạn thư trả lời để kích thích tò mò: *"Meo meo! Lucky đây. Trẫm khuyên Sen là..."*
*   **Trailing (Bên phải):** Một icon chevron nhỏ mảnh (`Icons.chevron_right_rounded`, màu xám nhẹ) báo hiệu có thể nhấn vào xem chi tiết.

---

## IV. GIAO DIỆN ĐỌC THƯ (FLAT DETAIL VIEW)

Khi chạm vào một lá thư, ứng dụng mở màn hình chi tiết bằng hiệu ứng chuyển trang tiêu chuẩn của hệ điều hành (mượt mà, tốc độ phản hồi cao). 

Giao diện chi tiết là một trang phẳng trắng tinh khiết, phân cách hoàn hảo bằng các khoảng trắng thoáng đãng, mang lại trải nghiệm đọc giống như đọc một chương truyện ngắn yên bình:

```
+---------------------------------------------------+
|  [<]               Thư Hồi Âm                     |
+---------------------------------------------------+
|  Gửi biệt danh: "Trái tim cô đơn Quận 1"          |
|                                                   |
|  +---------------------------------------------+  |
|  | THƯ GỬI ĐI CỦA BẠN:                         |  |
|  | Dạo này áp lực công việc quá... con buồn...  |  |  <-- Khung phẳng màu xám nhạt mịn màng
|  +---------------------------------------------+  |
|                                                   |
|  [Thumbnail Mèo]  MÈO LUCKY PHẢN HỒI:              |  <-- Label & Thumbnail mèo vẽ tay dẹt
|  Meo meo! Lucky đây. Trẫm khuyên Sen là cứ mỗi  |
|  lần mệt thì đi ngủ đi, ăn pate rồi lại chiến     |  <-- Lời khuyên ngộ nghĩnh của Boss
|  tiếp. Cố lên nhé Sen của trẫm!                   |
|                                                   |
|  -----------------------------------------------  |  <-- Divider mảnh
|                                                   |
|  [Thumbnail Ông già] ÔNG GIÀ NAMIYA PHẢN HỒI:      |
|  Con thương mến, ta hiểu những vất vả của con.  |
|  Ta mong con biết rằng mỗi giọt nước mắt hôm    |  <-- Lời khuyên sâu sắc từ Admin
|  nay là hạt mầm cho sự kiên cường ngày mai...   |
|                                                   |
+---------------------------------------------------+
```

### 1. Bố cục dọc ba phần phẳng tinh tế:
1.  **Phần 1 - Khung Thư Gốc:** Nền màu xám phẳng mịn (`Color(0xFFF1F5F9)`), chữ màu xám đậm (`Color(0xFF64748B)`), cỡ chữ `14sp` mô tả lại bức thư người dùng đã gửi.
2.  **Phần 2 - Lời Khuyên Của Mèo:**
    *   Một dòng tiêu đề phẳng kèm **Thumbnail đầu mèo vẽ tay nhỏ xinh** đặt ở bên trái nhãn: **[Mèo Lucky phản hồi 🐾]**.
    *   Đoạn văn lời khuyên in nghiêng, màu sắc dịu mắt.
3.  **Phần 3 - Lời Nhắn Từ Ông Già Namiya:**
    *   Tiêu đề phẳng kèm **Thumbnail ông lão vẽ nét line-art tối giản**: **[Ông già Namiya phản hồi ✉️]**.
    *   Đoạn văn phản hồi chính chữ đứng thẳng, cỡ chữ `16sp`, chiều cao dòng `1.5` chuẩn Notion để mang lại trải nghiệm đọc sách mượt mà nhất.

---

## V. ƯU ĐIỂM CỦA THIẾT KẾ THỰC TẾ (BENEFITS)

*   **Zero-Jank & High Performance:** Hoàn toàn không sử dụng các hiệu ứng cuộn sớ giấy hay chuyển động 3D phức tạp, đảm bảo ứng dụng luôn chạy mượt mà ở tốc độ 60-120 FPS kể cả trên các thiết bị cấu hình thấp.
*   **Clean & Modern:** Phù hợp tuyệt đối với ngôn ngữ thiết kế phẳng hiện đại của toàn bộ ứng dụng Capcat.
*   **Easy Maintenance:** Sử dụng các thành phần cốt lõi của Flutter (`ListTile`, `TabBar`, `Navigator`), giúp đội ngũ lập trình có thể dễ dàng triển khai chỉ trong 1-2 ngày mà sản phẩm ra lò vẫn vô cùng **chỉn chu, sạch đẹp và ngập tràn cảm xúc (Cozy & Premium Mood)** nhờ sự chau chuốt ở hình ảnh Thumbnail và Câu từ.

---

*Biên bản đặc tả thực tế này đã sẵn sàng để chuyển giao lập trình. Ký tên: Team Cố vấn Capcat (Sophia & Benny)*
