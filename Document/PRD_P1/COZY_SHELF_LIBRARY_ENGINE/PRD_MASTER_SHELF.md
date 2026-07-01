# TÀI LIỆU YÊU CẦU SẢN PHẨM MASTER: PHÂN HỆ GÓC CẢM XÚC (DOCA CORNER)
*(MASTER PRODUCT REQUIREMENT DOCUMENT - PRD V1.2 - THƯƠNG HIỆU: DOCA)*

---

## 🧭 I. TẦM NHÌN & ĐỊNH VỊ SẢN PHẨM (VISION & ALIGNMENT)

### 1. Sứ mệnh cảm xúc (Iyashikei Symbiosis):
Trong quá trình trò chuyện ấm áp tại phòng chat Cozy Chat ([PRD_COZY_CHAT_RESONANCE_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_CHAT_RESONANCE_ENGINE/PRD_COZY_CHAT_RESONANCE_ENGINE.md)), Boss ảo sẽ giới thiệu những bài hát, cuốn sách hay điểm hẹn chữa lành cho Sen dựa trên thời tiết và tâm trạng thực tế.

**DOCA Corner (Góc Cảm Xúc)** đóng vai trò là một **không gian triển lãm cá nhân yên bình**, nơi Sen lưu trữ và trưng bày các vật phẩm văn hóa mà Boss đã từng tặng hoặc thảo luận cùng mình. Đối với những con người nhạy cảm và giàu cảm xúc, việc có một góc riêng tư bày biện các đĩa nhạc yêu thích, quyển sách hay, card bo góc hay poster là một liệu pháp xoa dịu tinh thần cực kỳ quan trọng.

### 2. Triết lý thiết kế MUJI (The MUJI Design Commandments):
Triết lý thiết kế của DOCA Corner tuân thủ nghiêm ngặt **chủ nghĩa tối giản MUJI (MUJI Warm Minimalism)**:
*   **❌ KHÔNG giả lập kệ gỗ vật lý 3D/2D:** Không vẽ vân gỗ, không dựng hình tủ chè hay bàn trà hoài cổ gây rối mắt và làm nặng tiến trình kết xuất.
*   **❌ KHÔNG thiết kế thô mộc gồ ghề:** Không sử dụng các nét vẽ tay sứt sẹo, rách nát, các nét màu loang lổ thiếu trật tự, giữ đúng tinh thần phẳng tối giản MUJI.
*   **✅ Tối giản MUJI tinh khiết (MUJI Warm Minimalism):** Giao diện phẳng hoàn toàn, sử dụng lưới ngăn nắp (Clean Grid System), đường viền siêu mảnh (`1px`), nhiều khoảng thở (negative space), màu sắc nhã nhặn (trắng kem giấy tái chế kết hợp xám nhạt) và typography cực kỳ sắc sảo. 
*   **✅ Thẻ bài bo góc phẳng (Flat Cards):** Các đĩa nhạc, quyển sách được hiển thị dạng thẻ phẳng bo góc (`12-16px`) xếp ngay ngắn theo lưới để giữ sự gọn gàng đặc trưng của Muji nhưng vẫn tạo cảm giác tinh tế, dễ chạm.

---

## 🏛️ II. BẢN ĐỒ TÍNH NĂNG PHÂN HỆ (FEATURE MATRIX)

Góc Cảm Xúc được chia làm 3 khu vực chức năng chính:

```
+-------------------------------------------------------------------------+
| [🔍] GÓC CẢM XÚC - DOCA CORNER (Bottom Nav Tab 3 Entry)                 |
+-------------------------------------------------------------------------+
| [TẤT CẢ]  [ĐĨA NHẠC]  [SÁCH CŨ]  [TÁC GIẢ]  [NHÂN VẬT]  [ĐIỂM HẸN]      | <--- Phân loại thẻ cảm xúc
+-------------------------------------------------------------------------+
| +---------------------+   +---------------------+   +---------------------+
| | [🎧] (Poster)       |   | [📚] (Postcard)     |   | [👤] (Card bo góc)  |
| | Blue in Green       |   | Rừng Na Uy          |   | Haruki Murakami     | <--- Lưới Thẻ Bo Góc Muji
| | Thả tim • Đang treo |   | 28/05 • Mở khóa     |   | 01/06 • Mở khóa     |
| +---------------------+   +---------------------+   +---------------------+
+-------------------------------------------------------------------------+
```

1.  **Hệ thống Thẻ Phân loại (Categorized Tabs):**
    *   Chia làm 6 danh mục: *Tất cả*, *Đĩa nhạc* (Vinyls - đĩa than phát lofi), *Sách cũ* (Books - trích dẫn quotes), *Tác giả* (Authors - chân dung nhà văn), *Nhân vật* (Characters - các mascot nhà DOCA), *Điểm hẹn* (Locations - quán cafe mộc).
2.  **Trưng bày Lưới Thẻ MUJI (Poster Grid View):**
    *   Hiển thị vật phẩm dưới dạng thẻ bài bo góc xếp lưới phẳng ngăn nắp. Mỗi thẻ bài có hiệu ứng lật thẻ 3D phẳng nhẹ nhàng.
3.  **Tương tác Quà tặng Cảm xúc (Happiness Gifting):**
    *   Bên cạnh việc treo lên tường kỷ niệm, Sen có thể nhấn nút "Tặng cho Boss" một vật phẩm văn hóa từ Góc Cảm Xúc. Hành động tặng quà tinh thần này sẽ hiển thị hoạt ảnh Boss vui vẻ và tự động lưu vào danh sách quà tặng yêu thích của Boss, khơi gợi các chủ đề trò chuyện mới.
4.  **Hệ thống Nút Tiếp thị Liên kết (Contextual Affiliate Action):**
    *   Mỗi thẻ vật phẩm khi hiển thị chi tiết (Bottom Sheet) sẽ tích hợp một nút hành động dạng phẳng Notion-style trỏ đến link mua sắm / nghe nhạc trực tiếp (Shopee Affiliate, Fahasa, Spotify, Apple Music) đi kèm token tracking của nhà phát triển để mang lại nguồn doanh thu trực tiếp cho ứng dụng mà không cần hệ thống ví tiền ảo phức tạp.
5.  **Giới hạn tính năng MVP (Content Playback & Reading Constraints):**
    *   **Không phát nhạc đầy đủ:** Ứng dụng tuyệt đối không hỗ trợ nghe trọn vẹn cả bài hát. Bản thử âm nhạc tối đa chỉ phát 30 giây (preview). Nút hành động sẽ điều hướng người dùng ra trình duyệt hoặc ứng dụng chuyên nghiệp ngoài (Spotify, Apple Music).
    *   **Không đọc sách toàn văn:** Ứng dụng không hỗ trợ đọc sách trực tiếp trên app. Thẻ sách cũ chỉ chứa đoạn trích (quotes) nổi bật và bài viết đánh giá/cảm nhận ngắn gọn từ Boss AI. Nút liên kết sẽ mở webview/deep-link của các đối tác cung cấp dịch vụ chuyên nghiệp (Shopee, Fahasa, Tiki).

---

## ⚙️ III. BẢO MẬT & VẬN HÀNH DỮ LIỆU CỤ CỤC BỘ (DATA RECONCILIATION)

*   **100% Caching Cục bộ (SQLite / Hive):** DOCA Corner được nạp hoàn toàn từ cơ sở dữ liệu SQLite cục bộ `unlocked_shelf_items` dưới thiết bị để đảm bảo tốc độ mở trang tức thì < 50ms.
*   **Luồng Kích Hoạt Tự Nhiên (Natural Activation):** Vật phẩm chỉ xuất hiện trong Góc Cảm Xúc sau khi Sen đã nhấp vào các liên kết gợi ý trong luồng chat Cozy Chat của Boss.

---

## 📅 IV. DANH MỤC ĐẶC TẢ CHI TIẾT (SPECS INDEX)

Phân hệ `DOCA_CORNER_ENGINE` (trước đây là `COZY_SHELF_LIBRARY_ENGINE`) bao gồm các tài liệu đặc tả kỹ thuật chi tiết:

1.  **[SPEC_01_MUJI_GRID_SHELF.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_SHELF_LIBRARY_ENGINE/SPEC_01_MUJI_GRID_SHELF.md):** Đặc tả thiết kế lưới thẻ bo góc, thanh phân loại, và hiệu ứng lật thẻ 3D phẳng chuẩn typography Muji.
2.  **[SPEC_02_SHELF_BOTTOMSHEET.md](file:///Users/macinia/Capcat%20Project/Document/PRD_P1/COZY_SHELF_LIBRARY_ENGINE/SPEC_02_SHELF_BOTTOMSHEET.md):** Đặc tả trình phát nhạc 30s (iTunes API), trích dẫn sách cũ và nút tặng quà cho Boss.

---

*Tài liệu Master PRD này được đồng thuận ký tên bởi CPO Sophia, Tech Lead Alan và Senior Dev Benny.*
