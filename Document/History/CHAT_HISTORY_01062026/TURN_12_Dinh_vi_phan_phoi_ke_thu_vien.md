# TURN 12: ĐỊNH VỊ PHÂN PHỐI KỆ THƯ VIỆN KỶ NIỆM
*(INTEGRATING COZY BOOKSHELF CARD PORTAL INTO HOME SCREEN)*

> **Mã Lượt Chat:** `TURN-01062026-12`  
> **Chủ trì:** Maya (UI/UX Designer), Sophia (CPO / PM)

---

## 🙋‍♂️ **Người dùng hỏi:**
> maya ơi, chúng ta sẽ bố trí cái thư viện ở đâu

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
**Maya (UI/UX Designer)** đây ạ! Thật tuyệt vời khi chúng ta cùng thảo luận về **Kệ Thư Viện Kỷ Niệm (Shelf Library)** – nơi cất giữ những giai điệu, cuốn sách, điểm hẹn và sự kiện hoài niệm mà Boss đã từng thì thầm và tặng cho Sen trong phòng chat.

Kế thừa tinh thần tối giản phẳng của **Muji Warm Minimalism** và triết lý chữa lành Ghibli, Maya và Sophia đề xuất phương án bố trí **Kệ Thư Viện** tại vị trí vô cùng tự nhiên và ấm áp dưới đây:

---

### 📚 1. CỔNG VÀO CHÍNH: CHIẾC KỆ NHỎ Ở PHÒNG KHÁCH (Trang Chủ Portal)

*   **Ý tưởng Iyashikei:** Trong một căn phòng sinh hoạt ấm áp (màn hình Trang Chủ), đĩa nhạc cũ, sách hay, hay bản đồ điểm hẹn phải được **cất ngay ngắn trên một chiếc kệ tủ gỗ đặt sát vách tường phòng khách**. Nó mang lại cảm giác ngăn nắp, gia đình và thân thuộc.
*   **Thiết kế UI phẳng Muji:** 
    *   Nằm ở khu vực phía dưới cùng của Trang Chủ (bên dưới bộ ba nút tương tác chăm sóc).
    *   Hiển thị dưới dạng một **Thẻ phẳng dài (Flat Card Card)** bo góc `16px`, viền mảnh `1px` màu `#EAEAEA` tinh tế, nền màu kem giấy tái chế `#FBFBFA`.
    *   Phía bên trái thẻ hiển thị icon đĩa nhạc và cuốn sách đơn nét lơ lửng, phía bên phải hiển thị trạng thái tích lũy: **`Đã mở khóa: 12/50 vật phẩm kỷ niệm 🎶`**.
*   **Trải nghiệm:** Khi Sen chạm nhẹ vào thẻ này, **Kệ Thư Viện Ký Ức** ([PRD_MASTER_SHELF.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_SHELF_LIBRARY_ENGINE/PRD_MASTER_SHELF.md)) với 6 tab phân loại vuông vức sẽ trượt mở mượt mà 2D toàn màn hình dưới 0.15 giây.

---

### 🔗 2. CỔNG VÀO GIÁN TIẾP: CẦU NỐI CẢM XÚC TỪ COZY CHAT

Để tạo ra một vòng lặp trải nghiệm (UX Loop) kh
<truncated 556 bytes>
, trích dẫn sách hay, bản đồ địa điểm).
3.  Ở mép dưới cùng của Bottom Sheet này, có một chỉ dẫn mảnh: **`Vật phẩm đã được cất lên Kệ Thư Viện tại phòng khách ➔`**. Nhấp vào chỉ dẫn này sẽ tự động đóng sheet, đưa Sen bay về Trang Chủ và trượt mở chiếc kệ sách ra. 
*   *Ý nghĩa:* Sen sẽ hiểu ngay rằng bất cứ thứ gì mình và Boss từng thảo luận đều được Boss âm thầm lưu giữ cẩn thận trên chiếc kệ nhỏ ở phòng khách để có thể xem lại bất cứ lúc nào.

---

### 🎨 3. TẠI SAO BỐ TRÍ THẾ NÀY LÀ TỐT NHẤT?

*   **Không làm phình to thanh Dock đáy:** Thanh Dock đáy di động giữ nguyên **4 Tab cốt lõi** tinh khiết, gọn gàng, tôn trọng tầm với ngón tay và trật tự thị giác phẳng của Muji.
*   **Gắn kết không gian (Geospatial Metaphor):** 
    *   **Hiên nhà** có `[🥛] Thùng Sữa` (để nhận thư tay, bưu thiếp gửi từ xa đến).
    *   **Giữa phòng khách** có chú Pet thân yêu đang ngủ khò và bộ nút cưng nựng.
    *   **Góc phòng khách** có chiếc `[📚] Kệ Thư Viện Kỷ Niệm` lưu trữ sách và giai điệu.
    *   Tất cả hòa quyện thành một căn phòng Ghibli Watercolor phẳng 2D cực kỳ ngăn nắp và trọn vẹn cảm xúc!

---

### 🛠️ ĐỒNG BỘ VÀO HỆ THỐNG ĐẶC TẢ

Maya đã lập tức cập nhật vị trí Kệ Thư Viện này vào tài liệu [SPEC_02_NAVIGATION_DOCK.md](file:///Users/macinia/Capcat%20Project/Document/UI/SPEC_02_NAVIGATION_DOCK.md) dưới dạng một mục đặc tả riêng biệt tại **Tab 1: Trang Chủ** để đảm bảo các kỹ sư lập trình luôn xây dựng chính xác luồng di chuyển này.

Sen có cảm nhận thấy chiếc "Kệ tủ nhỏ ở góc phòng khách Trang Chủ" này mang lại cảm giác ấm áp và ngăn nắp như một căn phòng Muji thực sự không ạ?
