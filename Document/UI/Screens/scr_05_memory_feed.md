# ĐẶC TẢ GIAO DIỆN: SCR-05 — MEMORY FEED SCREEN (HỘP KÝ ỨC TRI KỶ)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Ký ức được lưu trữ phẳng phiu, ngăn nắp như một chiếc tủ gỗ đựng ảnh cũ của gia đình phong cách **Muji**.
*   **Vibe cảm xúc**: Hoài niệm, ấm áp, trân trọng từng khoảnh khắc.
*   **Bố cục lưới (Layout Grid)**: Lưới 2 cột dọc đồng đều. Để giữ nguyên tính chân thực, hình ảnh không bị cắt xén (no crop) mà tự co giãn theo tỷ lệ ảnh gốc (Pinterest staggered style), viền mỏng tinh tế.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: Search] Hộp Ký Ức             [Lucide: Plus] | <--- Top App Bar
|  [ Tất Cả ] [ Bánh Mỳ 🐱 ] [ Lucky 🐶 ] [ 📸 Ảnh đẹp ]| <--- Segmented Tabs
|  =================================================    |
|                                                       |
|  |--- 2026.06.13 - - - - - - - - |  Cozy Timeline    | <--- Timeline Divider (Space Mono 12px mờ)
|                                                       |
|  +------------------+   +-----------------+          |
|  |  [  HÌNH ẢNH  ]  |   |  [  HÌNH ẢNH ] |          | <--- Pinterest Staggered Grid (2 col)
|  |                  |   |                 |          |      Bo góc 12px, nền #F5F5F0
|  |  "Boss ngã vó"   |   | "Mặt ngáy ngủ"  |          |      Không cắt xén ảnh gốc
|  |  📅 26/05        |   | 📅 25/05        |          |
|  +------------------+   |                 |          |
|                          ⛅ [Nắng ấm]     |          | <--- Ambient Badge (10px Inter, #1C1C1E)
|  +------------------+   +-----------------+          |
|  |  [  HÌNH ẢNH  ]  |   +-----------------+          |
|  |  "Ngủ bàn phím"  |   |  [  HÌNH ẢNH ] |          |
|  |  📅 24/05        |   | "Ăn vụng cá mòi"|          |
|  +------------------+   +-----------------+          |
|                                                       |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                                 ____                  | <--- Muji Bar under "Camera"
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Hiệu Ứng (Interactions & Effects)

1.  **Hiệu ứng Lật Thẻ Kỷ Niệm 2D (Card Flip)**:
    *   Khi chạm vào một bức ảnh: Tấm ảnh sẽ xoay ngang 2D (`duration: 300ms`) để lật ra mặt sau.
    *   **Mặt sau thẻ chứa**: Những dòng nhật ký ghi chú cảm xúc của Sen gõ lúc đăng ảnh (dùng font chữ typewriter Space Mono), ngày tháng và địa điểm chụp.
    *   Góc đáy mặt sau có nút phẳng: **[Chế Meme 🎨]** để mở trình ghép khung hài hước tự phát.
2.  **Bộ lọc phân mục (Segmented Category Filters)**:
    *   Chạm chọn bộ lọc trên cùng sẽ lọc nhanh ảnh của từng Boss hoặc theo tag. Tab active trượt mượt mà.
3.  **Hành động thêm mới [Lucide: Plus]**:
    *   Chạm mở popup chọn: **[Tải ảnh thủ công]** hoặc **[Trò chơi Buffet Ký Ức 5s]**.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Chú thích ảnh: `Inter Regular 13px` màu `#1C1C1E`.
    *   Thời gian Timeline: `Space Mono Regular 12px` màu `#8C8C8C`.
    *   Nhật ký mặt sau card: `Space Mono Regular 12px`, line-height `1.6` màu `#1C1C1E`.
*   **Màu sắc**:
    *   Nền Timeline Divider: Nét đứt màu `#EAEAEA` (`dashPattern [4,4]`).
    *   Nền thẻ ảnh mặt sau: Màu sữa giấy thủ công `#F5F5F0`.
    *   Ambient Badge (Nhãn thời tiết/cảm xúc): Nền `rgba(255,255,255,0.85)` trong suốt mờ, chữ `#1C1C1E`.
*   **Kích thước & Bo góc**:
    *   Bo góc thẻ ảnh: `12px` (`Radius.cozyCard` nhỏ).
    *   Khoảng cách lưới (Staggered spacing): `8dp` ngang và dọc.
    *   Bottom Dock active indicator bar: `16x2px` nằm sát dưới icon Camera.
