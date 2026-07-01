# ĐẶC TẢ CHI TIẾT 02: HỆ THỐNG THẺ CHI TIẾT CẢM XÚC & LIÊN KẾT AFFILIATE
*(EMOTIONAL AFFILIATE DETAIL CARDS & BOTTOM SHEET TEMPLATES)*

> **Mã Đặc Tả:** `SPEC-SHELF-02`  
> **Chủ trì:** Maya (UI/UX Designer) & Benny (Senior Mobile Dev)  
> **Trạng thái:** Phê duyệt thiết kế theo hình minh họa (Dev-Ready V1.3)

---

## 🎨 1. Giao Diện Chung Của Thẻ Chi Tiết (Common Postcard Sheet Structure)

Khi Sen chạm vào một thẻ trên lưới của **DOCA Corner** hoặc chạm vào liên kết văn bản trong **Cozy Chat**, một Bottom Sheet (hoặc thẻ Dialog phủ mờ) sẽ trượt lên mượt mà. 

### 📐 Thông số UI chung:
*   **Nền (Fill):** Màu trắng kem giấy tái chế `#FBFBFA` hoặc trắng tinh khiết `#FFFFFF` tạo cảm giác sạch sẽ, mộc mạc.
*   **Bo góc (Radius):** `24px` cho toàn bộ khung viền ngoài.
*   **Đường viền:** Đường chỉ siêu mảnh `1px solid #EAEAEA` bao quanh, không đổ bóng nặng (chỉ dùng shadow cực mờ `rgba(0,0,0,0.02) blur 12px`).
*   **Cơ chế đóng:** Vuốt dọc xuống để đóng, hoặc bấm nút **Quay lại** ở chân trang.
*   **Cặp nút hành động kép ở chân trang (Bottom Action Buttons):**
    *   *Nút bên trái (Quay lại):* Nút phẳng nền trắng, viền mảnh `1px solid #EAEAEA`, chữ màu xám đen `#262626`. Kèm icon nhịp tim/sóng rung tự nhiên `⚡` hoặc sóng điện tim vẽ nét.
    *   *Nút bên phải (Bắt đầu ngay):* Nút phẳng Obsidian đen tuyền (`#0D0D0D`), chữ màu trắng tinh khiết `#FFFFFF` nổi bật. Kèm icon nhịp tim/sóng tương tự. Khi nhấn nút này, hệ thống sẽ mở trình duyệt/deep-link liên kết tiếp thị liên kết (Affiliate) để hướng user đến nơi mua sách, đĩa nhạc hoặc vật phẩm thực tế.

---

## 📐 2. Đặc Tả 5 Bản Mẫu Chi Tiết (The 5 Detail Card Templates)

Dựa trên hình ảnh minh họa thiết kế, hệ thống chia làm 5 bản mẫu chuyên biệt tương ứng với từng thể loại nội dung:

### 2.1. Bản Mẫu Ca Khúc Âm Nhạc (Music Track Postcard)
Dành cho các ca khúc đơn lẻ (Ví dụ: *From Me to You - Mono / The Beatles*).

```
+-------------------------------------------------------------+
|  +-----+  [🍏 Spotify]                                      | <--- Logo Badge của nền tảng (Xanh Spotify)
|  | (O) |  From Me to You - Mono / ...                       | <--- Tên ca khúc
|  +-----+  The Beatles                                       | <--- Tên ca sĩ / Ban nhạc
|                                                             |
|  +-------------------------------------------------------+  |
|  |  From Me to You - Mono / ...                     ||   |  | <--- Thanh Audio Player mini tích hợp
|  |  =======================================              |  | <--- Tiến trình phát nhạc
|  +-------------------------------------------------------+  |
|                                                             |
|  Âm nhạc êm dịu chữa lành của Ngọt đã đồng hành cùng...    | <--- Đoạn văn mô tả cảm xúc, lãng đãng (Inter, 12px)
|                                                             |
|  +---------------------+   +-----------------------------+  |
|  |  ⚡ Quay lại         |   |  ⚡ Bắt đầu ngay            |  | <--- Nút hành động kép ở chân trang
|  +---------------------+   +-----------------------------+  |
+-------------------------------------------------------------+
```
*   **Đầu trang:** Cover art của bài hát nằm trong khung tròn (`48x48px`). Kế bên là **Nhãn dịch vụ màu xanh Spotify** `[🟢 Spotify]` (hoặc `[🍏 Apple Music]`) và Tiêu đề bài hát + Ca sĩ.
*   **Trình phát Audio Player (Giới hạn MVP - Audio Preview Only):**
    *   Một container phẳng bo góc `8px`, nền xám nhạt `#F4F4F4`.
    *   Hiển thị tên bài hát đang phát ở góc trái và nút **Play/Pause** (`||` hoặc `▶`) ở góc phải.
    *   Một thanh tiến trình (progress bar) mảnh màu xanh Matcha chạy dọc dưới để báo thời lượng phát **tối đa 30 giây** (iTunes API preview stream). **Không hỗ trợ nghe full toàn bộ bài hát trực tiếp trên ứng dụng.**
*   **Mô tả:** Đoạn văn chữ tối lãng đãng kể về hoàn cảnh ra đời hoặc ý nghĩa bài hát.
*   **Link Affiliate:** Nút *Bắt đầu ngay* dẫn deep-link trực tiếp đến bài hát trên ứng dụng hoặc webview Spotify/Apple Music với token affiliate của nhà phát triển.

---

### 2.2. Bản Mẫu Nghệ Sĩ / Ban Nhạc (Artist / Band Postcard)
Dành cho nghệ sĩ hoặc ban nhạc (Ví dụ: *Ban nhạc Ngọt*).
*   **Đầu trang:** Ảnh chân dung nghệ sĩ/ban nhạc cắt tròn (`48x48px`). Nhãn `[🟢 Spotify]` kế bên. Tên ban nhạc và phụ đề `Ban nhạc` ở dưới.
*   **Trình phát Audio Player:** Tự động gọi ca khúc tiêu biểu nhất của ban nhạc đó (Ví dụ: bài hát *Em dạo này* của Ngọt). Giao diện và cơ chế tương tự bản mẫu ca khúc đơn.
*   **Mô tả:** Bài viết giới thiệu ngắn gọn phong cách nhạc và lời nhắn của Pet thấu cảm.
*   **Link Affiliate:** Nút *Bắt đầu ngay* mở trang danh mục nghệ sĩ trên Spotify.

---

### 2.3. Bản Mẫu Vật Phẩm / Sản Phẩm Đời Thường (Product Postcard)
Dành cho đồ chơi, cát mèo, phụ kiện chăm sóc hoặc quà tặng (Ví dụ: *Cát Đậu Nành Không Bụi Siêu Hút*).
*   **Đầu trang:** Ảnh chụp vuông bo góc nhẹ (`72x72px`) mô tả sản phẩm ở góc trái. Phía phải là **Nhãn cam Shopee** `[🟠 Shopee]` (hoặc `[🔵 Tiki]`/`[🔴 Lazada]`) và Tên sản phẩm cỡ chữ đậm nét.
*   **Mô tả cảm quan:** Văn bản mô tả công năng, độ an toàn và lý do khuyên dùng dưới góc nhìn thấu cảm.
*   **Lưới ảnh phụ (Thumbnail Preview Row):**
    *   Một hàng ngang gồm 3 ô vuông nhỏ (`54x54px`), bo góc `4px`, nền xám nhạt để hiển thị các góc chụp chi tiết khác của sản phẩm hoặc ảnh Pet đang sử dụng sản phẩm ngoài đời thực.
*   **Link Affiliate:** Nút *Bắt đầu ngay* mở deep-link Shopee/Lazada Affiliate dẫn thẳng tới trang mua hàng có giá rẻ và uy tín nhất.

---

### 2.4. Bản Mẫu Tác Phẩm Sách (Book Postcard)
Dành cho sách cũ, tiểu thuyết chữa lành (Ví dụ: *Tôi Là Một Chú Mèo - Natsume Soseki*).
*   **Đầu trang:** Bìa sách đứng phẳng hình chữ nhật bo góc nhẹ (`48x64px`). Nhãn cam Shopee `[🟠 Shopee]` và Tiêu đề sách + Tên tác giả.
*   **Hộp trích dẫn nổi bật (Highlight Quote Box):**
    *   Một khối hộp nằm ngang, nền xám kem nhạt `#F5F5F3`, bo góc `4px`.
    *   **Điểm nhấn:** Có đường chỉ dọc màu đỏ hồng pastel sậm (`width: 3px`, màu `#D37A7A`) chạy sát mép trái của hộp để làm nổi bật câu trích dẫn.
    *   *Nội dung:* `"Hãy sống như một chú mèo, ngủ khi mệt và kêu ca khi đói."` (Space Mono Italic, 12px).
*   **Mô tả (Giới hạn MVP - Excerpt & Review Only):** Bài giới thiệu ngắn về cuốn sách, đoạn trích và bài đánh giá/cảm nhận cảm xúc ngắn gọn của Boss AI khi đọc cùng Sen. **Ứng dụng hoàn toàn không tích hợp tính năng đọc sách toàn văn (no in-app reading).**
*   **Link Affiliate:** Nút *Bắt đầu ngay* mở deep-link dẫn đến gian hàng sách hoặc webview Shopee Mall của Nhã Nam hoặc Fahasa để người dùng xem và đặt sách.

---

### 2.5. Bản Mẫu Nhà Văn / Tác Giả (Author Postcard)
Dành cho chân dung tác giả văn học chữa lành (Ví dụ: *Haruki Murakami - Nhà văn*).
*   **Đầu trang:** Chân dung tác giả cắt tròn (`48x48px`). Nhãn cam Shopee `[🟠 Shopee]` kế bên. Tên tác giả và phụ đề `Nhà văn`.
*   **Mô tả:** Đoạn văn viết về văn phong của tác giả, gợi ý các cuốn sách hay nhất của họ nên đọc vào đêm mưa.
*   **Hộp trích dẫn nổi bật (Highlight Quote Box):** Đặt ở phần dưới cùng của nội dung mô tả (ngay phía trên cặp nút hành động). Thiết kế hộp chữ nhật bo góc có viền đỏ bên trái tương tự như bản mẫu sách.
*   **Link Affiliate:** Nút *Bắt đầu ngay* dẫn đến trang danh sách sách của tác giả trên Shopee/Fahasa để Sen dễ tìm mua.

---

## 🔒 3. Phương Án Chuyển Hướng An Toàn & Cookie Tracking

1.  **Mở app ngoài (Deep-Linking Scheme):**
    *   Spotify: Gọi `spotify:track:[id]` hoặc `spotify:artist:[id]`.
    *   Shopee: Gọi `shopeevn://product/[shop_id]/[item_id]`.
2.  **Web Fallback & Webview:**
    *   Nếu thiết bị chưa cài đặt ứng dụng (Ví dụ: máy không có app Spotify/Shopee), hệ thống tự động fallback mở trình duyệt Safari/Chrome mặc định hoặc hiển thị Webview trực tiếp trỏ đến URL chuyển hướng của các đối tác chuyên nghiệp (**Apple Partnerize / Shopee Affiliate Link / Fahasa Web**) để đảm bảo cookie tracking hoa hồng vẫn được ghi nhận thành công và người dùng có thể thưởng thức đầy đủ dịch vụ một cách trọn vẹn nhất.
3.  **Tự động ngắt Audio:**
    *   Khi người dùng nhấn nút *Bắt đầu ngay* chuyển hướng sang ứng dụng ngoài, hệ thống bắt buộc kích hoạt `audioPlayer.stop()` để lập tức dừng phát đoạn nhạc preview 30s đang chạy ngầm, tránh đè âm thanh khó chịu.

---

*Đặc tả giao diện chi tiết này đã được Maya cập nhật và lưu trữ vào kho PRD_P1. Ký tên: Maya & Benny.*
