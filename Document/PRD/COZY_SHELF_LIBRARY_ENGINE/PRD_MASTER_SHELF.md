# TÀI LIỆU YÊU CẦU SẢN PHẨM MASTER: PHÂN HỆ KỆ THƯ VIỆN TỐI GIẢN MUJI
*(MASTER PRD - COZY MUJI SHELF LIBRARY ENGINE)*

> **Mã Phân Hệ:** `COZY_SHELF_LIBRARY_ENGINE`  
> **Chủ trì:** Sophia (CPO / PM) & Alan (Tech Lead) & Benny (Senior Flutter Dev)  
> **Trạng thái:** Thiết lập mới (Dev-Ready)  
> **Định hướng thiết kế cốt lõi:** **Tối giản MUJI (MUJI Minimalism)** — Gọn gàng, ngăn nắp, thuần khiết, tập trung tối đa vào khoảng trắng và sự thanh lịch phẳng. KHÔNG giả lập kệ gỗ, KHÔNG thô mộc wabi-sabi.

---

## 🧭 I. TẦM NHÌN & ĐỊNH VỊ SẢN PHẨM (VISION & ALIGNMENT)

### 1. Sứ mệnh cảm xúc (Iyashikei Symbiosis):
Trong quá trình trò chuyện ấm áp tại phòng chat Cozy Chat ([SPEC-COZY-07](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_07_EXTERNAL_AMBIENT_SENSING.md)), Boss ảo sẽ giới thiệu những bài hát, cuốn sách hay điểm hẹn chữa lành cho Sen dựa trên thời tiết và tâm trạng.

**Cozy MUJI Shelf Library Engine** đóng vai trò là một **cuốn catalog ký ức gọn gàng**, nơi lưu trữ toàn bộ các vật phẩm văn hóa mà Boss đã từng tặng hoặc thảo luận cùng Sen. Nhìn vào kệ hàng, người dùng cảm nhận được một **không gian tĩnh lặng, ngăn nắp và tràn ngập sự thấu hiểu** mà Boss dành cho mình qua từng ngày bên nhau.

### 2. Triết lý thiết kế MUJI (The MUJI Design Commandments):
Để tránh sự phức tạp trong hiển thị, loại bỏ hoàn toàn gánh nặng nợ kỹ thuật (Tech Debt) và đảm bảo tính dễ dàng trong triển khai mã nguồn Flutter, chúng tôi đặt ra quy tắc thiết kế cứng:
*   **❌ KHÔNG giả lập kệ gỗ vật lý 3D/2D:** Không vẽ vân gỗ, không dựng hình tủ chè hay bàn trà hoài cổ gây rối mắt và làm nặng tiến trình kết xuất.
*   **❌ KHÔNG Wabi-Sabi thô mộc:** Không sử dụng các nét vẽ tay sứt sẹo, rách nát, các nét màu loang lổ thiếu trật tự.
*   **✅ Tối giản MUJI tinh khiết (MUJI Warm Minimalism):** Giao diện phẳng hoàn toàn, sử dụng lưới ngăn nắp (Clean Grid System), đường viền siêu mảnh (`1px`), nhiều khoảng thở (negative space), màu sắc nhã nhặn (trắng kem giấy tái chế kết hợp xám nhạt) và typography cực kỳ sắc sảo. 

---

## 🏛️ II. BẢN ĐỒ TÌNH NĂNG PHÂN HỆ (FEATURE MATRIX)

Chiếc kệ Muji được tổ chức thành 3 phân vùng giao diện phẳng cực kỳ ngăn nắp:

```
+-------------------------------------------------------------------------+
| [🔍] KỆ THƯ VIỆN MUJI (Home Screen Menu Entry)                           |
+-------------------------------------------------------------------------+
| [TẤT CẢ]  [GIAI ĐIỆU]  [TRANG SÁCH]  [ĐIỂM HẸN]  [NHÂN VẬT]  [SỰ KIỆN]    | <--- Các Tab Phân Loại Ngăn Nắp
+-------------------------------------------------------------------------+
| +---------------------+   +---------------------+   +---------------------+
| | [🎧]                 |   | [📚]                 |   | [👤]                 |
| | Blue in Green       |   | Rừng Na Uy          |   | John Lennon         | <--- Lưới Thẻ Phẳng Muji
| | 31/05 • Bánh Mỳ     |   | 28/05 • Bánh Mỳ     |   | 01/06 • Bánh Mỳ     |
| +---------------------+   +---------------------+   +---------------------+
| +---------------------+   +---------------------+
| | [📍]                 |   | [📅]                 |
| | Cafe Sách Gỗ        |   | Ra mắt Doraemon     |
| | Tan ca muộn         |   | 01/06 • Bánh Mỳ     |
| +---------------------+   +---------------------+
+-------------------------------------------------------------------------+
```

1.  **Hệ thống Phân loại Ngăn nắp (Categorized Tabs - Spec 01):**
    *   Chia làm 6 tab phẳng: *Tất cả*, *Giai điệu* (Music), *Trang sách* (Books), *Điểm hẹn* (Locations), *Nhân vật* (Characters), *Sự kiện hoài niệm* (Nostalgic Events).
2.  **Lưới Thẻ Phẳng MUJI (Flat Grid Cards - Spec 01):**
    *   Hiển thị vật phẩm dưới dạng thẻ bài phẳng tối giản. Mỗi thẻ có viền xám mờ siêu mảnh, hiển thị biểu tượng category tối giản, tên vật phẩm, ngày mở khóa, và tên bé Pet đã tặng.
3.  **Hộp thoại chi tiết phẳng (Muji Bottom Sheet - Spec 02):**
    *   Khi nhấp vào thẻ bài, một Bottom Sheet phẳng mượt mà trượt lên, hiển thị tranh Polaroid tối giản, lời thoại thấu cảm của Boss, audio player 30s, quote sách, tiểu sử nhân vật hoặc dấu mốc thời gian và nút Action một chạm phẳng.

---

## ⚙️ III. BẢO MẬT & VẬN HÀNH DỮ LIỆU CỤ CỤC BỘ (DATA RECONCILIATION)

*   **100% Caching Cục bộ (SQLite / Hive):** Thư viện Muji được nạp hoàn toàn từ cơ sở dữ liệu SQLite cục bộ `unlocked_shelf_items` dưới thiết bị. Đảm bảo tốc độ hiển thị lập tức < 50ms khi người dùng bấm vào.
*   **Luồng Kích Hoạt Tự Nhiên (Natural Activation):** Vật phẩm chỉ được đưa lên kệ thư viện sau khi Sen **đã nhấp vào** liên kết hyperlink dotted màu hồng nhạt/xanh sage trong Cozy Chat lần đầu tiên. Điều này tạo cơ chế tích lũy cảm xúc có chủ đích.
*   **Tách biệt Gia đình Đa Pet:** Kệ thư viện có thể lọc hiển thị toàn bộ hoặc lọc riêng theo từng Boss ảo trong gia đình thông qua một dropdown menu phẳng tinh tế ở góc trên cùng.

---

## 📅 IV. DANH MỤC ĐẶC TẢ CHI TIẾT (SPECS INDEX)

Phân hệ `COZY_SHELF_LIBRARY_ENGINE` bao gồm 2 tài liệu đặc tả kỹ thuật chi tiết:

1.  **[SPEC_01_MUJI_GRID_SHELF.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_SHELF_LIBRARY_ENGINE/SPEC_01_MUJI_GRID_SHELF.md):** Đặc tả cấu trúc lưới phẳng, thanh phân loại Tab, micro-interaction co giãn nhẹ và thiết kế Typography chuẩn phong cách Muji.
2.  **[SPEC_02_SHELF_BOTTOMSHEET.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_SHELF_LIBRARY_ENGINE/SPEC_02_SHELF_BOTTOMSHEET.md):** Đặc tả luồng tương tác Bottom Sheet, trình phát nhạc 30s (iTunes API), trích dẫn sách và liên kết dẫn ngoài bảo mật.

---

*Tài liệu Master PRD này được đồng thuận ký tên bởi CPO Sophia, Tech Lead Alan và Senior Dev Benny.*
