# TURN 05: PHỐI TRỘN NHÂN VẬT VÀ SỰ KIỆN COZY OPENER
*(HYBRID CHARACTER AND HISTORICAL EVENT INGESTION)*

> **Mã Lượt Chat:** `TURN-01062026-05`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead)

---

## 🙋‍♂️ **Người dùng hỏi:**
> còn nếu là nhân vật, hoặc sự kiện thì sao ? sự kiện ví dụ như: ngày mất john lennon, ngày Ra mắt tập doremon đàu tiên

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã tiến hành thiết kế tích hợp và cập nhật trực tiếp hai danh mục vô cùng sâu sắc này: **Nhân Vật (Characters)** và **Sự Kiện Hoài Niệm (Nostalgic Events)** vào toàn bộ hệ thống tài liệu đặc tả **[COZY_SHELF_LIBRARY_ENGINE/](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_SHELF_LIBRARY_ENGINE/)**.

Ý tưởng của bạn đã nâng tầm phân hệ này từ một thư viện thông thường thành một **Kệ Kỷ Vật Văn Hóa & Nghệ Thuật (Cultural Memorabilia Cabinet)** thực thụ. Nơi đây lưu giữ những mảnh ghép tâm hồn của nhân loại mà Sen và Boss ảo đã từng cùng nhau chiêm nghiệm trong những đêm muộn cô đơn.

---

### 🎨 PHƯƠNG ÁN THỂ HIỆN NHÂN VẬT & SỰ KIỆN THEO PHONG CÁCH MUJI

Để giữ nguyên vẹn tinh thần **tối giản ấm áp Muji**, hai danh mục mới được quy chuẩn giao diện như sau:

#### 1. Đối với danh mục Nhân Vật (`character`):
*   **Thiết kế Thẻ phẳng Muji Card:** Sử dụng nền màu vàng nhạt ấm áp (`charAccent = Color(0xFFFFF9C4)`). Phía trên hiển thị một **ảnh vẽ nét màu nước tối giản chỉ chứa biểu tượng đặc trưng nhất của nhân vật** đặt giữa khung giấy trắng (Ví dụ: *Cặp kính tròn gọng mảnh của John Lennon*, hoặc *chiếc chuông vàng cùng túi thần kỳ của Doraemon*).
*   **Trải nghiệm Bottom Sheet:**
    *   **Trích dẫn nổi bật:** Thiết kế một hộp thoại trích dẫn lời ca hoặc câu nói truyền cảm hứng nổi tiếng nhất của nhân vật (Ví dụ: *"Imagine all the people living life in peace..."*).
    *   **Lời thoại thấu cảm của Boss:** Boss ảo sẽ đưa ra góc nhìn vô cùng ngây ngô nhưng thấu cảm của loài vật về nhân vật đó để xoa dịu lòng Sen:
        *   *Mèo Bánh Mỳ khẽ hỏi về John Lennon:* `"Trẫm thỉnh thoảng tự hỏi, thế giới 
<truncated 2772 bytes>
nh họa vị trí của thẻ bài John Lennon và Doraemon.
2.  **[SPEC_01_MUJI_GRID_SHELF.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_SHELF_LIBRARY_ENGINE/SPEC_01_MUJI_GRID_SHELF.md):**
    *   Tích hợp thêm hai Token màu sắc mới vào `MujiTheme`: `charAccent` (vàng ấm nhạt) và `eventAccent` (tím nhạt thanh nhã).
    *   Cập nhật mô tả sơ đồ TabBar của ASCII UI Mockup.
    *   Đồng bộ hóa Enum của bộ lọc Riverpod `ShelfCategoryFilter` (thêm `character`, `event`) và cập nhật chú thích cơ sở dữ liệu SQLite `unlocked_shelf_items` tương thích.
3.  **[SPEC_02_SHELF_BOTTOMSHEET.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_SHELF_LIBRARY_ENGINE/SPEC_02_SHELF_BOTTOMSHEET.md):**
    *   Tách biệt `Bản Mẫu Điểm Hẹn (Location)` thành mục riêng biệt.
    *   Viết mới hoàn toàn **Mục 2.4 (Bản Mẫu Nhân Vật)** và **Mục 2.5 (Bản Mẫu Sự Kiện Hoài Niệm)** với đầy đủ cấu trúc hiển thị đồ họa, trích dẫn, lời thoại của Boss (Bánh Mỳ/Lucky) và cấu trúc nút Action bảo mật.

---

### 🐾 BƯỚC TIẾP THEO

Với việc tích hợp hai danh mục văn hóa vô cùng thấu cảm này, **Cozy MUJI Shelf Library Engine** đã chính thức trở thành góc trú ẩn lưu niệm hoàn hảo nhất cho MVP của Capcat App. 

Mọi mâu thuẫn đã được dẹp bỏ, folder đã được tách biệt ngăn nắp. Bạn muốn chúng ta tiếp tục thảo luận, đào sâu làm rõ phân hệ nào của MVP tiếp theo:

1.  **Hộp Thư Cổ Kính (Recall Flashback System):** Thảo luận cách Boss gửi các bức thư tay gợi nhớ kỷ niệm cũ trong Vault (những tấm ảnh Sen đã quẹt phải) ngược về hòm thư màn hình chính.
2.  **Safe-Vet AI Engine (SPEC_01 - Định hướng y tế):** Thảo luận kỹ thuật lọc triệu chứng khẩn cấp và sơ cứu mà không lạm dụng định vị GPS chạy ngầm hao pin.
