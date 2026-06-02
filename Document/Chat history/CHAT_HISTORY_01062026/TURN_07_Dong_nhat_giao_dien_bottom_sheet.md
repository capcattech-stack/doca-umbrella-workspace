# TURN 07: ĐỒNG NHẤT GIAO DIỆN BOTTOM SHEET VÀ CARD
*(MUJI FLAT CONTAINER AND DIALOG SYSTEM STANDARD)*

> **Mã Lượt Chat:** `TURN-01062026-07`  
> **Chủ trì:** Maya (UI/UX Designer), Sophia (CPO / PM)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Ra soát để thóng nhất ngôn ngữ thiết kế cảu các bottom sheet cũng như là card.

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã tiến hành rà soát và cập nhật trực tiếp tài liệu nền tảng thiết kế cốt lõi của dự án: **[08_DESIGN_SYSTEM_FOUNDATION.md](file:///Users/macinia/Capcat%20Project/Document/08_DESIGN_SYSTEM_FOUNDATION.md)**. 

Bằng việc bổ sung **Mục 10: Tiêu Chuẩn Thống Nhất Giao Diện (MUJI Flat Cards & MUJI Bottom Sheets)**, toàn bộ hệ thống Card hiển thị và Hộp thoại Bottom Sheet trong toàn bộ ứng dụng từ nay đã được quy chuẩn hóa đồng bộ, chặt chẽ dưới ngôn ngữ thiết kế **Tối giản Muji (MUJI Warm Minimalism)**.

Mọi thiết kế kiểu giả lập không gian wabi-sabi phức tạp hay bất khả thi về mặt lập trình đều đã bị loại bỏ hoàn chỉnh khỏi quy chuẩn.

---

### 🎴 1. TIÊU CHUẨN THỐNG NHẤT FLAT CARDS (MUJI FLAT CARD SPECIFICATION)
Mọi thẻ hiển thị trong toàn app (Thẻ Moments, đĩa nhạc, sách cũ, điểm hẹn, nhân vật, sự kiện) bắt buộc phải tuân thủ nghiêm ngặt cấu trúc phẳng 2D:

*   **Hình khối & Bo góc (Radius):**
    *   Bo góc cố định: `BorderRadius.circular(8.0)` cho các thẻ lưới danh mục nhỏ (Grid Card) và `BorderRadius.circular(16.0)` cho các thẻ card Moments lớn.
    *   **Tuyệt đối KHÔNG xoay nghiêng chéo:** Loại bỏ hoàn toàn việc xoay lệch thẻ 2-3 độ kiểu giả lập ảnh cắt dán thủ công, giữ thẻ thẳng tắp ngăn nắp.
*   **Độ dày & Viền chỉ (Borders):**
    *   Sử dụng viền chỉ xám tro siêu mảnh: `border: Border.all(color: Color(0xFFEAEAEA), width: 1.0)`.
*   **Bóng đổ tối giản (Clean Shadows):**
    *   Tuyệt đối không sử dụng bóng đổ dầy màu tối. Chỉ sử dụng bóng đổ tán xạ siêu loãng và rộng:
    *   `boxShadow: [BoxShadow(color: Color(0xFF1C1C1E).withOpacity(0.01), blurRadius: 16, offset: Offset(0, 4))]`.
*   **Bố cục phân vùng (Internal Layout):**
    *   *Ô biểu tượng:*
<truncated 2187 bytes>
ố định 8px/16px và viền chỉ mảnh 1px xám tro giúp mình dễ dàng cấu hình `ThemeData` toàn cục cho app. Giờ đây mình chỉ cần khai báo một class `AppDecorations.lightCardDecoration` và `showModalBottomSheet` chuẩn Muji là toàn bộ Card và Bottom Sheet trong app tự động đồng bộ đẹp đẽ, phẳng phiu!"
*   **Alan (Tech Lead):** "Đặc tả này rất tuyệt. Việc dẹp bỏ bóng đổ dầy màu tối và các vân gỗ ráp giúp giảm tải đáng kể dung lượng bộ nhớ đệm đồ họa (Graphic Cache). Card phẳng 2D không xoay lệch giúp GridView tính toán toạ độ render cực kỳ nhẹ nhàng, không gây giật lag khung hình khi cuộn lướt nhanh."
*   **Sophia (CPO/PM):** "Đúng vậy. Sự thống nhất này làm cho Capcat trở nên cực kỳ tinh tế, chuyên nghiệp và mang đúng tinh thần Muji Warm Minimalism. Sự chữa lành đến từ tính ngăn nắp, thuần khiết và những khoảng thở trắng rộng lớn của giao diện để tâm hồn người dùng được tĩnh lặng sâu sắc."

---

### 🐾 BƯỚC TIẾP THEO

Toàn bộ hệ thống thiết kế cơ bản cùng các đặc tả Cards và Bottom Sheets hiện đã ở trạng thái **Thống nhất - Khả thi - Sẵn sàng lập trình**. 

Chúng ta đã hoàn tất việc rà soát và thiết lập thành công ngôn ngữ thiết kế Muji tinh khiết cho toàn bộ dự án Capcat. Bạn muốn tiếp tục thảo luận làm rõ phân hệ nào của MVP tiếp theo:

1.  **Phân hệ Meme Card Generator (SPEC_03 - Memory Vault):** Cách tự động cắt khuôn mặt Pet ghép vào 15 khung hình phẳng tối giản Muji bằng Canvas cục bộ trên máy để Sen lưu giữ và chia sẻ.
2.  **Động cơ Safe-Vet AI Engine (SPEC_01 - Hỗ trợ khẩn cấp):** Đặc tả luồng lọc triệu chứng nguy kịch và hiển thị Emergency Card phẳng đỏ nhấp nháy chỉ đường phòng khám gần nhất.
