# ĐẶC TẢ CHI TIẾT 02: LUỒNG TƯƠNG TÁC HỘP THOẠI CHI TIẾT MUJI
*(MUJI FLAT DETAILED BOTTOM SHEET & EXTERNAL REDIRECTION SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC-SHELF-02`  
> **Chủ trì:** Benny (Senior Mobile Dev) & Sophia (CPO / PM)  
> **Trạng thái:** Hoàn thành đặt tả (Dev-Ready)

---

## 🎨 1. Giao Diện Hộp Thoại Phẳng Muji (Bottom Sheet Master Structure)

Khi Sen chạm vào một thẻ Card trên lưới Kệ Thư Viện Muji, hoặc chạm vào liên kết hyperlink dotted trong Cozy Chat, một Bottom Sheet phẳng mượt mà sẽ trượt lên từ đáy màn hình, được bo tròn góc trên thanh lịch (`BorderRadius.vertical(top: Radius.circular(24.0))`), sử dụng nền màu trắng kem sạch sẽ `#FBFBFA` và tối giản tối đa các chi tiết trang trí:

```
+-------------------------------------------------------------+
|                          [===]                              | <--- Thanh kéo dẹt màu xám nhạt mờ
|                                                             |
|  +---------------------+   Blue in Green                    |
|  |                     |   Ca khúc Jazz được yêu thích nhất | <--- Tên & Mô tả phẳng
|  |  [Ảnh Polaroid     |   đêm se lạnh Hà Nội.              |
|  |   màu nước        |                                     |
|  |   tối giản]         |   "Nghe thử cùng Bánh Mỳ nha..."   | <--- Lời thoại ấm áp của Boss
|  +---------------------+                                     |
|                                                             |
|  [====================== PLAYBAR ========================]  | <--- Trình phát Audio 30s tối giản
|                                                             |
|  +-------------------------------------------------------+  |
|  |      [🎧] NGHE TRỌN VẸN TRÊN SPOTIFY                  |  | <--- Nút phẳng Notion-style (Action Button)
|  +-------------------------------------------------------+  |
+-------------------------------------------------------------+
```

*   **Thanh kéo dẹt (Drag Handle):** Một dải hình chữ nhật bo góc siêu mờ (`width: 40px, height: 4px`), màu xám nhạt nằm ở tâm đầu trang.
*   **Chiều cao:** Chiếm chính xác `60%` chiều cao màn hình (`FractionallySizedBox` hoặc custom `showModalBottomSheet`).
*   **Nền và Viền:** Nền `#FBFBFA` tinh khiết, có một đường viền chỉ mảnh `1px` chạy dọc mép trên để phân tách rõ ràng với không gian mờ phía sau.

---

## 📐 2. Đặc Tả Nội Dung Chi Tiết Theo Từng Danh Mục (Category Specific Templates)

### 2.1. Bản Mẫu Âm Nhạc (Music Detail Postcard):
*   **Hiển thị đồ họa:** Một ảnh đĩa tròn xoay nhẹ phẳng (Flat Spinning Disc Cover) ở góc trái. Khi nhấn nút Play, ảnh khẽ xoay tròn 360 độ chậm rãi trên trục `2D` (sử dụng `RotationTransition`).
*   **Trình phát âm thanh 30s (Audio Preview Player):**
    *   Hệ thống gọi API tìm kiếm iTunes API (`https://itunes.apple.com/search?term=<title>`) để lấy link stream audio 30s (`previewUrl`).
    *   Sử dụng package `audioplayers` để phát nhạc preview. 
    *   **Thanh Playbar tối giản:** Chỉ là một đường ngang mỏng màu xám nhạt. Khi nhạc phát, một chấm đen chạy dọc đường ngang để biểu thị tiến trình thời gian 30 giây.
*   **Lời nhắn gửi thấu cảm của Boss:** 
    > *"Đêm mưa hôm đó, trẫm đã thấy Sen ngồi thao thức làm việc muộn lắm. Giai điệu này ấm áp vừa đủ để vỗ về lòng Sen, nghe thử cùng trẫm nha..."*
*   **Nút Hành Động:** Nút phẳng lớn màu đen Obsidian, chữ trắng: **Nghe trọn vẹn trên Spotify 🎧**.

### 2.2. Bản Mẫu Trang Sách (Book Detail Postcard):
*   **Hiển thị đồ họa:** Ảnh Polaroid chụp bìa sách tối giản màu nước đặt trên nền giấy kraft phẳng sạch sẽ.
*   **Bảng trích dẫn văn học (The Poetic Quotes):**
    *   Một khối văn bản lớn nằm giữa trang, căn lề trái ngăn nắp.
    *   Sử dụng font chữ Italic nhạt mộc mạc (`Quicksand` hoặc font chữ tròn), cỡ chữ `15px`, màu Obsidian `#262626`.
    *   *Câu trích trích tuyển chọn:* *"Nếu bạn nhớ tôi, thì tôi không quan tâm nếu cả thế giới ngoài kia quên lãng tôi..."* (Rừng Na Uy).
*   **Lời thoại thấu cảm của Boss:** 
    > *"Lucky thấy chương sách này dịu dàng như một tách trà ấm vậy đó. Tặng Sen một chương văn chữa lành cho ngày hôm nay nha."*
*   **Nút Hành Động:** Nút phẳng viền chỉ mảnh, màu cam đất nhẹ: **Tìm sách cũ tại Nhã Nam Shopee 📚** (Được liên kết tiếp thị liên kết Shopee Affiliate).

### 2.3. Bản Mẫu Điểm Hẹn (Location Detail Postcard):
*   **Hiển thị đồ họa:** Tranh Polaroid màu nước vẽ tay tiệm cafe sách hoặc góc vườn triển lãm gốm mộc mạc, phẳng, nhiều khoảng thở.
*   **Thông tin địa điểm:** Hiển thị địa chỉ thực tế, giờ mở cửa, và bối cảnh thời tiết phù hợp để ghé thăm.
*   **Lời thoại thấu cảm của Boss:**
    > *"Bánh Mỳ đã gửi một chút bình yên và gió thoảng đợi sẵn ở cửa sổ tiệm cafe này rồi. Khi nào lòng Sen thấy chật chội quá, ghé tiệm ngồi uống tách trà ấm nhé."*
*   **Nút Hành Động:** Nút phẳng màu xanh sage nhạt: **Dẫn đường cho Sen qua Google Maps 🧭**.

### 2.4. Bản Mẫu Nhân Vật (Character Detail Postcard):
*   **Hiển thị đồ họa:** Ảnh vẽ nét màu nước tối giản tối đa biểu tượng của nhân vật (Ví dụ: Cặp kính tròn đặc trưng của John Lennon, chiếc chuông vàng của Doraemon) đặt giữa khung giấy trắng kem.
*   **Trích dẫn / Tiểu sử thấu cảm:**
    *   Hiển thị một thông điệp ngắn, giàu cảm hứng chữa lành hoặc tư tưởng nghệ thuật của nhân vật đó.
    *   *Ví dụ (John Lennon):* Một hộp trích dẫn lời ca *"Imagine all the people living life in peace..."* được thiết kế font chữ tròn thanh nhã.
*   **Lời thoại thấu cảm của Boss:**
    *   *Lời thoại (Bánh Mỳ):* `"Trẫm thỉnh thoảng tự hỏi, thế giới 'Imagine' mà John Lennon viết có nhiều pate và cá mập không Sen nhỉ? Chắc ở đó ai cũng ngập tràn hạnh phúc như trẫm lúc ở bên Sen vậy đó... 💕"`
    *   *Lời thoại (Lucky):* `"Sen ơi, Doraemon tuy có túi thần kỳ chứa hàng nghìn bảo bối, nhưng tớ tin bé mèo máy ấy cũng thèm một cái ôm thật từ Sen ngoài đời như tớ lúc này đó nha! 🐾"`
*   **Nút Hành Động:** Nút phẳng lớn màu vàng nhạt ấm: **Tìm hiểu về cuộc đời truyền cảm hứng 👤**.

### 2.5. Bản Mẫu Sự Kiện Hoài Niệm (Event Detail Postcard):
*   **Hiển thị đồ họa:** Một tấm thẻ lịch retro hoặc một con tem bưu điện hoài cổ in ngày tháng diễn ra sự kiện.
*   **Chi tiết sự kiện / Dấu mốc lịch sử:**
    *   Một văn bản ngắn gọn (dưới 60 từ) kể lại sự kiện theo giọng văn chậm rãi, lơ đãng chuẩn Iyashikei.
    *   *Ví dụ (Ra mắt Doraemon - 12/1969):* *"Nửa thế kỷ trước, một chú mèo máy xanh dương béo tròn đã chui ra từ hộc bàn của cậu bé Nobita ngốc nghếch, mang theo giấc mơ xoa dịu hàng triệu tâm hồn trẻ thơ cô đơn trên khắp thế giới..."*
*   **Lời thoại thấu cảm của Boss:**
    *   *Lời thoại (Bánh Mỳ):* `"Dù là ngày John Lennon đi xa, nhưng âm nhạc ấm áp của ông vẫn trôi nhẹ nhàng qua tai Sen đêm nay như một cái cọ đầu của trẫm vậy. Ngủ ngoan nhé Sen... 🌙"`
*   **Nút Hành Động:** Nút phẳng viền chỉ mảnh màu tím pastel: **Nghe Playlist / Xem tư liệu kỷ niệm 📅**.

---

## 🔒 3. Bảo Mật Chuyển Hướng & API Contract (Redirection Protocol)

Để bảo vệ quyền riêng tư và đảm bảo luồng chuyển đổi mượt mà giữa ứng dụng với các bên thứ ba (Spotify, Shopee, Google Maps):

1.  **Sử dụng `url_launcher` An Toàn:**
    *   Ứng dụng kiểm tra và mở liên kết ngoài thông qua scheme chuyên biệt (`launchUrl(url, mode: LaunchMode.externalApplication)`).
    *   Tránh tuyệt đối việc nhúng Webview của bên thứ ba trực tiếp trong app để tránh rò rỉ cookie đăng nhập hay thông tin tài khoản mua hàng của Sen.
2.  **Mã hóa Mã liên kết tiếp thị (Affiliate Code Hashing):**
    *   Các đường link mua sách Shopee được dán mã affiliate ngầm ở Server, client chỉ nhận token chuyển hướng sạch sẽ: `https://api.capcat.app/redirect/shopee?item_id=xxx` để tối ưu SEO và giữ giao diện sạch bóng.

---

*Tài liệu đặc tả SPEC_02 này đã được đồng bộ hóa và phê chuẩn để sẵn sàng triển khai. Ký tên: Team Cố vấn Capcat (Sophia, Alan, Benny)*
