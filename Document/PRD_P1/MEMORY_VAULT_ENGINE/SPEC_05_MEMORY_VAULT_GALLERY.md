# ĐẶC TẢ CHI TIẾT 05: HỘP KÝ ỨC PHẲNG TỐI GIẢN MUJI & CẢM QUAN IYASHIKEI NGĂN NẮP
*(MEMORY VAULT MUJI FLAT GALLERY & WARM MINIMALISM AESTHETICS)*

> **Mã Đặc Tả:** `SPEC-VAULT-05`  
> **Chủ trì:** Maya (UI/UX Designer), Benny (Senior Mobile Dev), Arthur (Mom Test), Alan (Tech Lead)  
> **Định hướng thẩm mỹ:** **Tối giản Muji** — Không loè loẹt, không giả lập không gian vật lý phức tạp, tập trung vào khoảng trắng rộng lớn, lưới phẳng vuông vắn ngăn nắp và hiệu năng kết xuất tối đa.

---

## 🧭 1. Triết Lý Thiết Kế: "Sự Tĩnh Lặng Từ Sự Ngăn Nắp"

Để Hộp Ký Ức (Memory Vault) đạt đến cảnh giới chữa lành cao nhất của dòng văn học Iyashikei Nhật Bản, chúng ta **loại bỏ hoàn toàn các giả lập vật lý thô ráp gượng ép** (như giấy da thô ráp nhám, góc nghiêng lệch giả lập scrapbook hay hiệu ứng 3D phức tạp). 

Cảm giác bình yên thực sự đến từ sự ngăn nắp, thuần khiết và gọn gàng của **ngôn ngữ thiết kế Muji**:
*   Giao diện phẳng hoàn toàn, tối giản tối đa các chi tiết trang trí thừa thãi.
*   Lập trật tự thị giác bằng cách sử dụng các khối phẳng có tổ chức (Clean Grid System), đường viền mảnh `1px` và typography sắc sảo.
*   Võng mạc được thư giãn tuyệt đối nhờ khoảng trắng (negative space) rộng lớn giúp giảm tải căng thẳng thần kinh.

---

## 🎨 2. Đặc Tả Giao Diện Lưới Phẳng Muji (Muji Gallery Layout)

Chúng ta thay thế toàn bộ lưới so le phức tạp và các hạt bụi 3D bằng một giao diện lưới phẳng Muji cực kỳ ngăn nắp:

### 2.1. Bố Cục Lưới Đồng Đều Ngăn Nắp (Uniform Muji Grid)
*   **Bố cục lưới:** Lưới 2 cột đồng đều (`GridView.builder` với `SliverGridDelegateWithFixedCrossAxisCount` vuông vức).
*   **Tỷ lệ khung hình:** Tỷ lệ thẻ cố định (ví dụ: `childAspectRatio: 0.75`), đảm bảo các thẻ bài xếp hàng thẳng tắp, ngăn nắp giống như chiếc kệ tủ lưu hồ sơ Muji.
*   **Độ thoáng đãng (Breathable Spacing):** `Padding: 16px` ở các mép ngoài thiết bị, khoảng cách giữa các thẻ là `12px`.
*   **Bảng màu Muji tĩnh lặng (Muji Warm Palette):**
    *   *Nền thư viện:* Trắng kem giấy tái chế cực sạch và dịu (`#FBFBFA`).
    *   *Nền thẻ kỷ niệm:* Trắng tinh khiết (`#FFFFFF`) giúp nổi bật hình ảnh kỷ niệm.
    *   *Đường viền mảnh:* `border: Border.all(color: Color(0xFFEAEAEA), width: 1.0)`.
    *   *Bóng đổ tối giản:* Không đổ bóng nặng, chỉ dùng viền chỉ mảnh.
    *   *Typography:* Sử dụng font chữ tròn thanh nhã **`Quicksand`** màu đen ấm Obsidian (`#262626`) cho tiêu đề, và màu xám tro `#8C8C8C` cho ngày tháng/biệt danh Pet.
*   **HỦY BỎ hoàn toàn Bụi Nắng Gyroscope và Phối cảnh 3D:** Loại bỏ hoàn toàn particle system chạy ngầm và cảm biến con quay hồi chuyển Gyroscope để bảo toàn 100% tài nguyên CPU/GPU, giúp máy mát lạnh và không tốn pin.

### 2.2. HỦY BỎ Hệ Âm Thanh Vật Lý (Zero Sonic Friction Policy)
*   Loại bỏ hoàn toàn các tệp âm thanh lật giấy (`paper_shuffle.mp3`), tiếng viết bút chì (`pencil_write.mp3`) hay tiếng đóng sáp (`stamp_press.mp3`).
*   *Lý do:* Việc phát âm thanh cơ học liên tục trong app tạo cảm giác ồn ào và giả tạo. Sự chữa lành thực sự nằm ở **khoảng lặng tuyệt đối (Silent Healing Space)** khi người dùng tương tác trong đêm khuya.

---

## 📋 3. Luồng Thêm Ký Ức Thủ Công Bằng Tay (Warm & Simple Manual Post Flow)

Để Sen chủ động ghi chép kỷ niệm, Hộp Ký Ức cung cấp một nút bấm phẳng thanh lịch **[Thêm Kỷ Niệm 📋]** ở góc dưới màn hình:

### 3.1. Thiết kế Bottom Sheet Muji Flat:
*   Khi nhấn nút, một Bottom Sheet phẳng mượt mà trượt lên bo nhẹ góc trên (`borderRadius: 16px`), nền màu `#FBFBFA` tinh khiết.
*   Giao diện sử dụng các form điền phẳng, tối giản tối đa các đường kẻ phân cách không cần thiết.
*   **Tự Do Nội Dung Tuyệt Đối:** Luồng nạp thủ công chấp nhận mọi hình ảnh kỷ niệm (không bắt buộc phải có chó/mèo như game vuốt thẻ Buffet tự động).

### 3.2. Ba chế độ hiển thị thẻ bài Muji:
1.  **Thẻ Kỷ Niệm Thường (Photo Card):** Thẻ ảnh phẳng vuông vức, bên dưới là tên kỷ niệm và dòng mô tả lãng đãng viết bằng font `Quicksand`.
2.  **Thẻ Sự Kiện Chăm Sóc (Care Event Card):** Không có ảnh. Chỉ hiển thị một biểu tượng icon phẳng đơn sắc (Music, Book, Hospital, Food) nằm trong ô vuông pastel nhạt (`charAccent`, `eventAccent`), kế bên là nội dung sự kiện và ghi chú viết tay của Sen.
3.  **Thẻ Kết Hợp (Hybrid Card):** Thẻ ảnh phẳng, có một **nhãn dán phẳng (Flat Badge)** siêu mảnh đính ở chân thẻ mô tả sự kiện chăm sóc đi kèm (Ví dụ: `🏥 Khám định kỳ`).

---

## 🔄 4. Thuật Toán Sắp Xếp & Lọc Trí Tuệ (Intellectual Sorting & Filters)

*   **Sắp xếp theo Ngày Chụp (EXIF Photo Date - Mặc định):** Đọc metadata ảnh để sắp xếp dòng thời gian từ mới đến cũ. Nhóm nhanh theo 4 Mùa (`SPRING`, `SUMMER`, `AUTUMN`, `WINTER`).
*   **Sắp xếp theo Ngày Thêm Vào (Upload Date):** Đọc ngày ghi nhận SQLite để hỗ trợ tìm kiếm nhanh ảnh vừa quẹt.
*   **Bộ lọc Tab phẳng Muji:** Thanh tab phẳng ở trên cùng để lọc nhanh: `[ Tất cả ]`, `[ Lucky 🐱 ]`, `[ Bánh Mỳ 🐱 ]`, `[ 📸 Ảnh đẹp ]`, `[ 📋 Chăm sóc ]`.

---

## ✉️ 5. Phân Hệ Recall Flashback — Trải Nghiệm Hoài Niệm Chữa Lành

### 5.1. Hộp Thư Cổ Kính Phẳng Tối Giản (Retro Flat Letter Sheet)
*   **HỦY BỎ 3D Origami/Gập thư/Trượt lướt 3D:**
*   **Cơ chế hoạt động:** Khi người dùng chạm vào phong thư cũ trên Home, một popup phẳng (`showDialog`) mở ra êm ái.
*   **Bố cục lá thư Muji:** Một trang giấy phẳng màu trắng kem `#FBFBFA` bo góc nhẹ, viền xám mảnh 1px. Nội dung lời thoại thấu cảm của Boss hiển thị rõ nét bằng font `Quicksand` đen Obsidian. Chân trang thư hiển thị một ảnh Polaroid nhỏ phẳng (ảnh thật lấy từ SQLite Moments).
*   **Nút Hành Động Phẳng:** Nút đen Obsidian phẳng: **[🕯️ Trò chuyện về kỷ niệm này]** để mở Cozy Chat và inject context tự động cho LLM.

### 5.2. HỦY BỎ Bưu Thiếp Hoài Niệm Xoay 3D (No 3D Postcard Flips)
*   Loại bỏ hoàn toàn phép lật xoay Y-axis phối cảnh 3D phức tạp mô tả ở bản cũ.
*   Thay thế bằng **Flat Double-sided Card (Thẻ phẳng hai mặt slide mượt)**: Khi nhấp vào, thẻ bài khẽ trượt nhẹ sang bên cạnh (slide transition) để hiển thị mặt sau chứa văn bản một cách phẳng phiu và tinh tế.

---

## 🔒 6. Bảng Minh Bạch Dữ Liệu Tối Cao (Muji Data Transparency Panel)

Thay thế "Tấm sớ giấy da" và "Ổ khóa đồng cổ kính" bằng một **Bảng điều khiển phẳng tối giản (Flat Transparency Panel)**:

*   **Trực quan:** Khi Sen bấm nút **"Minh Bạch 🔒"** ở góc màn hình, một panel phẳng trượt ra từ bên phải:
    *   **Phân vùng Cục bộ (Local Data):** Trình bày trực quan các danh mục dữ liệu chỉ được lưu an toàn trên máy Sen.
    *   **Phân vùng Đồng bộ (Synced Data):** Trình bày các token mã hóa để đồng bộ thiết bị, cam kết không tải ảnh thô lên Server.
*   **Bộ Đôi Hành Động Phẳng:**
    1.  **📥 Nút [Tải Bản Sao Lưu Kỷ Niệm .zip]:** Nén toàn bộ ảnh Polaroid đã lưu và xuất kèm một tệp `index.html` được thiết kế phẳng Muji siêu đẹp để người dùng có thể xem lại album kỷ niệm viết tay ngoại tuyến trên máy tính.
    2.  **🗑️ Nút [Xóa Sạch Dữ Liệu & Quên Đi Vĩnh Viễn]:** Khi Sen gõ đúng chữ **"QUÊN ĐI"**, hệ thống xóa sạch database cục bộ SQLite, dọn cache và hủy tài khoản máy chủ vĩnh viễn dưới hiệu ứng fade-out phẳng dịu nhẹ.

---

## 🔒 7. Tiêu Chí Nghiệm Thu Muji (Acceptance Criteria)

1.  **AC-1 (Uniform Muji Layout):** Hộp ký ức hiển thị dưới dạng lưới vuông vức, thẳng hàng, các thẻ phẳng có kích thước đồng đều và viền chỉ xám mảnh 1px. Không nghiêng lệch, không so le.
2.  **AC-2 (Zero Gyroscope & Particles):** Không chạy particle hệ thống hạt bụi nắng ngầm, CPU nhàn rỗi ở mức 0% khi mở màn hình thư viện.
3.  **AC-3 (Zero Sounds):** Không phát ra bất kỳ hiệu ứng âm thanh lật giấy hay dập dấu nào khi kéo vuốt thẻ.
4.  **AC-4 (Flat Redirection):** Bấm thư cũ mở popup sớ giấy phẳng 2D, click nút Action dẫn sang Cozy Chat không độ trễ.
5.  **AC-5 (Flat Double-Sided Card):** Khi chạm lật thẻ bưu thiếp, thẻ trượt ngang 2D mượt mà để hiện mặt sau dưới 0.15 giây.
