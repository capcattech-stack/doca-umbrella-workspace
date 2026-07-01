# ĐẶC TẢ GIAO DIỆN: SCR-06 — MEMORY SWIPE SCREEN (TRÒ CHƠI BUFFET KÝ ỨC)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Lấy cảm hứng từ game vuốt Tinder nhưng ứng dụng vào mục đích **lọc ảnh kỷ niệm**. Thuật toán cục bộ (ML Kit) quét album ảnh điện thoại và tìm ra 15 bức ảnh chứa thú cưng, xếp chồng thành các thẻ bài cho Sen vuốt chọn.
*   **Vibe cảm xúc**: Tập trung cao độ, thú vị, hoài niệm.
*   **Không gian hiển thị**: Toàn màn hình Cozy Dark Mode (`#0D0D0D`), không hiển thị thanh Dock điều hướng dưới đáy để Sen hoàn toàn đắm chìm vào kỷ niệm.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: X] Buffet Ký Ức                     [📊]   | <--- Nền Obsidian #0D0D0D
|  =================================================    |
|                                                       |
|           +-----------------------+                  |
|           |   /\_/\               |                  | <--- Thẻ bài phía sau (góc +2°, Obsidian mờ)
|       +---|  ( =.= )              |---+               |
|       |   +-----------------------+   |               |
|       |   |                       |   |               | <--- Thẻ bài chính (góc 0°, radius 28px)
|       |   |    [  📸 Ảnh Boss  ]  |   |               |
|       |   |                       |   |               |
|       |   |  Ngày: 2026.06.13     |   |               | <--- Space Mono Regular 12px #8C8C8C
|       |   |  "Bánh Mỳ ngủ nướng" |   |               | <--- Inter Regular 14px #FFFFFF
|       |   +-----------------------+   |               |
|       +-----------------------------------+           |
|                                                       |
|  [ 🍃 Bỏ Qua ]               [ 😻 Ghi Nhớ ]          | <--- Nút bo tròn 28px
|  (Nền Matcha #8FA882 mờ)      (Nền Sakura #FCAFAF mờ) |      Chữ #FFFFFF Inter Medium 14px
|                                                       |
|   <- Vuốt Trái: Bỏ Qua     Vuốt Phải: Lưu Lại ->    | <--- Inter Regular 12px #5C5C58
+-------------------------------------------------------+
|  (Không có Dock trong Dark Mode Swipe Screen)          |
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Cử Chỉ (Gestures & Flow)

1.  **Cử chỉ Vuốt Thẻ (Card Swiping Gestures)**:
    *   **Vuốt sang Phải (Swipe Right / Ghi Nhớ)**: Thẻ ảnh bay mượt sang phải. Ảnh được lưu vào **Memory Vault**, cộng điểm thân mật của Boss, phát âm thanh hạt cát lofi nhẹ và kích hoạt rung nhẹ (`light haptic`).
    *   **Vuốt sang Trái (Swipe Left / Bỏ Qua)**: Thẻ ảnh bay sang trái, ảnh được giữ riêng tư, không lưu vào app. Không rung haptic.
2.  **Hành động Nút bấm (CTA Click)**:
    *   Sen có thể bấm trực tiếp nút **[🍃 Bỏ Qua]** hoặc **[😻 Ghi Nhớ]** dưới chân thẻ để thực hiện hành động vuốt tương ứng.
3.  **Hoạt ảnh Chồng thẻ (Card Stacking Animation)**:
    *   Thẻ phía sau hơi lệch góc `2 độ` và có độ mờ `60%`. Khi thẻ trên cùng bay đi, thẻ dưới trượt lên thay thế đồng thời xoay về góc `0 độ` trong vòng `200ms`.
4.  **Kết thúc game**:
    *   Khi vuốt hết 15 ảnh, màn hình hiển thị bảng tổng kết phẳng tối giản số lượng ảnh đã lưu, sau đó tự động đóng để quay lại **SCR-05: Memory Feed**.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tiêu đề ảnh: `Inter Regular 14px` màu `#FFFFFF`.
    *   Ngày chụp: `Space Mono Regular 12px` màu `#8C8C8C`.
    *   Dòng chú giải cử chỉ: `Inter Regular 12px` màu `#5C5C58`.
*   **Màu sắc**:
    *   Nền: `#0D0D0D` (Deep Obsidian).
    *   Nền thẻ ảnh chính: `rgba(255, 255, 255, 0.06)` (Kính mờ trắng cực mỏng), viền `1px solid rgba(255,255,255,0.1)`.
    *   Nút Bỏ Qua: Nền xám xanh Matcha mờ `rgba(143, 168, 130, 0.3)`.
    *   Nút Ghi Nhớ: Nền hồng anh đào mờ `rgba(252, 175, 175, 0.3)`.
*   **Kích thước & Bo góc**:
    *   Bo góc thẻ bài: `28px` (Góc bo lớn tạo cảm giác thân thiện mềm mại).
    *   Bo góc nút bấm: `28px`.
    *   Chiều cao nút: `50dp`.
