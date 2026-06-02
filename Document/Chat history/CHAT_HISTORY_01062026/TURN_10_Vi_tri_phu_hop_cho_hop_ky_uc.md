# TURN 10: VỊ TRÍ PHÙ HỢP CHO HỘP KÝ ỨC
*(REHOMING MEMORY VAULT TO BOTTOM NAVIGATION DOCK)*

> **Mã Lượt Chat:** `TURN-01062026-10`  
> **Chủ trì:** Sophia (CPO / PM), Maya (UI/UX Designer)

---

## 🙋‍♂️ **Người dùng hỏi:**
> tôi thấy chúng ta quên Hộp ký ức. bạn đinh bố trí ở đâu

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Ồ! Rất xin lỗi bạn vì sự thiếu sót này. Bạn nói hoàn toàn chính xác, **Hộp Ký Ức (Memory Vault / Memory Box)** chính là một trong những phân hệ thiêng liêng và mang tính cốt lõi nhất của Capcat, nơi lưu giữ toàn bộ hình ảnh Polaroid, nhật ký viết tay và các sự kiện hoài niệm của Boss ảo.

**Maya (UI/UX)** và **Sophia (CPO)** đã lập tức ngồi lại để tìm ra vị trí bố trí tối ưu nhất cho Hộp Ký Ức.

### 🎨 Giải Pháp Thiết Kế: Tránh Sự Rối Rắm Của Dock & Tích Hợp Đa Điểm Chữa Lành
Theo triết lý tối giản của **Muji**, thanh Dock đáy nên được giới hạn ở **4 Tab chính** để tránh gây quá tải thị giác cho ngón cái (Thumb reach zone). Do đó, thay vì cố nhồi nhét Hộp Ký Ức làm một tab thứ 5 dưới Dock, chúng tôi đề xuất phương án **Tích hợp Đa điểm Chữa lành (Cozy Multi-entry Gate)** vô cùng tự nhiên và thuận tiện dưới đây:

#### 1. Cổng Vào Chính Trên Trang Chủ (Home Screen - Primary Gate)
*   **Vị trí:** Đặt tại góc trên cùng bên phải của AppBar Trang Chủ (căn phòng khách ấm áp), hiển thị dưới dạng một biểu tượng máy ảnh Polaroid đơn nét siêu mảnh **`[📸]`**.
*   **Trải nghiệm:** Chạm nhẹ vào icon này sẽ mở ra màn hình **Hộp Ký Ức** ([SPEC_05_MEMORY_VAULT_GALLERY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_05_MEMORY_VAULT_GALLERY.md)) dưới dạng lưới phẳng Muji ngăn nắp. Đây là thư viện tổng hợp hiển thị toàn bộ album kỷ niệm của tất cả các bé Pet mà Sen nuôi.

#### 2. Lối Tắt Nhanh Trong Phòng Chat (Chat Screen - Quick Gate)
*   **Vị trí:** Tại AppBar của Phòng Chat riêng tư (bên cạnh nút thông tin Pet), hiển thị một icon album ảnh nhỏ **`[📸]`**.
*   **Trải nghiệm:** Nhấp vào icon này sẽ mở thẳng H
<truncated 264 bytes>
 Năng Vuốt Nhanh Trên Danh Sách Chat (Swipe-to-Vault)
*   **Vị trí:** Đối với Sen nuôi từ 2 Pet trở lên, tại màn hình danh sách cuộc hội thoại của Tab **Tri Kỷ (💬)**.
*   **Trải nghiệm:** Khi Sen vuốt nhẹ một dòng Pet sang bên trái (Swipe Left Gesture), giao diện sẽ lộ ra một nút chức năng phẳng Notion-style màu Matcha: **`[Ký Ức 📸]`**. Nhấn vào sẽ mở nhanh album ảnh riêng của bé Boss đó, cực kỳ tiết kiệm thao tác.

#### 4. Cổng Quản Lý Kỹ Thuật Ở Tab Tôi (Tôi Screen - Storage Gate)
*   Như đã đặc tả ở Tab **Tôi**, chúng tôi bố trí khu vực **"Bộ nhớ & Tập tin cục bộ"** hiển thị dung lượng (ví dụ: `124.5 MB`) kèm hai nút: **[Dọn dẹp tủ ký ức]** (xóa cache ảnh tạm) và **[Minh bạch dữ liệu & Xuất .zip]** (tải toàn bộ ảnh gốc và logs chat về máy). Đây là cổng quản lý dung lượng và sao lưu ngoại tuyến an toàn cho Hộp Ký Ức.

---

### 🛠️ Các Cập Nhật Đã Được Đồng Bộ Vào Code Đặc Tả

Chúng tôi đã cập nhật ngay các cổng vào này vào tài liệu [SPEC_02_NAVIGATION_DOCK.md](file:///Users/macinia/Capcat%20Project/Document/UI/SPEC_02_NAVIGATION_DOCK.md):
*   **Mục 2.1 (Trang Chủ):** Thêm cổng vào Hộp Ký Ức `[📸]` ở góc phải AppBar.
*   **Mục 3.1 & 3.2 (Tab Tri Kỷ):** Thêm lối tắt nhanh Hộp Ký Ức trong phòng chat riêng và cử chỉ vuốt ngang dòng danh sách chat để xem nhanh album kỷ niệm.

Cách bố trí này giúp **Hộp Ký Ức vừa hiển thị vô cùng tự nhiên** (giống như cuốn album ảnh luôn đặt sẵn trên chiếc bàn trà ở căn phòng khách Trang Chủ), vừa **xuất hiện đúng lúc đúng chỗ** khi Sen đang chat với Boss, mà vẫn **bảo toàn được thanh Dock đáy Muji phẳng phiêu, rộng rãi**.

Bạn có hài lòng với sự sắp xếp đa điểm chữa lành này không ạ?
