# ĐẶC TẢ GIAO DIỆN: SCR-00 — SPLASH SCREEN (MÀN HÌNH KHỞI ĐỘNG KÝ ỨC)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Thay vì màn hình splash công nghiệp hiển thị logo nhàm chán, Capcat khởi động bằng **"Ký ức bất chợt"**. Mỗi lần mở ứng dụng, màn hình sẽ tải ngẫu nhiên một bức ảnh kỷ niệm cũ của Boss từ SQLite cục bộ, phủ lớp gradient tối dệt nên một bầu không khí hoài niệm bình yên.
*   **Vibe cảm xúc**: Nhẹ nhàng, ấm áp, bất ngờ (Dopamine lành mạnh).
*   **Chế độ màu**: Mặc định thích ứng (Adaptive) theo ảnh gốc, sử dụng lớp phủ tối để bảo vệ mắt.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|                                                       |
|                                                       |
|                                                       |
|              ( ẢNH BOSS TOÀN MÀN HÌNH )               |
|              ( Full-screen Cover Photo )               |
|                                                       |
|          ====  Lớp Phủ Tối Dần (Vignette)  ====       |
|                                                       |
|      "Sen về rồi đó à? Hôm nay trẫm đợi              |
|       Sen hơi lâu đấy nhé!"                           | <--- Space Mono Italic 15px #FFFFFF
|                                                       |
|                  o  o  ●  o  o                        | <--- Page indicator dots
|                                                       |
|      +-------------------+  +-------------------+    |
|      |    Bước Vào       |  |    Xem Lại        |    | <--- Inter Bold 15px
|      | (Nền trắng #FFF)  |  | (Viền trắng mờ)  |    |      BorderRadius 28px, H 50dp
|      +-------------------+  +-------------------+    |
|                                                       |
|    Kỷ niệm ngày 28/05/2026 của Bánh Mỳ                | <--- Inter Regular 11px #FFF 50%
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Chuyển Động (Interactions & Animations)

1.  **Hiệu ứng Khởi động (Intro Animation)**:
    *   Ảnh Boss và câu thoại sẽ phóng to nhẹ nhàng từ `scale: 1.0` lên `scale: 1.05` trong vòng `3.0s` bằng hiệu ứng Ken Burns để tạo chiều sâu chuyển động chậm.
2.  **Vuốt ảnh luân phiên (Horizontal Memory Carousel)**:
    *   Sen có thể vuốt ngang (Swipe Left/Right) để đổi ảnh kỷ niệm khác của Boss. Page indicator dots bên dưới sẽ nhảy vị trí tương ứng.
3.  **Hành động Nút bấm (CTA Actions)**:
    *   **Nút "Bước Vào"**: Khi chạm vào, màn hình sẽ mờ dần (Fade out) và chuyển tiếp mượt mà sang **SCR-01: Auth Screen**. Kích hoạt rung phản hồi nhấp chuột nhẹ (`Light Haptic`).
    *   **Nút "Xem Lại"**: Khi chạm vào, ứng dụng sẽ mở trực tiếp màn hình chi tiết dòng ký ức đó trong **SCR-05: Memory Feed**.
4.  **Haptic Feedback**:
    *   Selection click khi vuốt qua lại giữa các ảnh: rung nhẹ `selectionClick`.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Câu thoại Boss: `Space Mono Italic 15px`, line-height `1.5`, màu `#FFFFFF` (độ tương phản đảm bảo dễ đọc trên nền tối).
    *   Nhãn nút: `Inter Bold 15px`, màu `#121212` (trên nút trắng) và `#FFFFFF` (trên nút viền).
    *   Thông tin kỷ niệm: `Inter Regular 11px`, màu `#FFFFFF` với độ mờ `50%` (`rgba(255, 255, 255, 0.5)`).
*   **Màu sắc & Gradient**:
    *   Lớp phủ tối đáy (Vignette): `LinearGradient` bắt đầu từ tọa độ y=30% (`rgba(0, 0, 0, 0)`) kéo xuống y=100% (`rgba(0, 0, 0, 0.85)`).
    *   Nền nút "Bước Vào": `#FFFFFF` (Pure White).
    *   Viền nút "Xem Lại": `1px solid rgba(255, 255, 255, 0.35)`.
*   **Kích thước & Bo góc**:
    *   Chiều cao nút: `50dp`.
    *   Bo góc nút: `28px` (Tạo hình hạt đậu tròn trịa, ôm tay).
    *   Dấu trang (Page Indicator Dot): Active = đường kính `8px` trắng tinh. Inactive = đường kính `6px` trắng mờ `40%`. Khoảng cách giữa các chấm = `8px`.
