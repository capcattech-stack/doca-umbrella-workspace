# ĐẶC TẢ GIAO DIỆN: SCR-07 — RELAXATION MUSIC SCREEN (GÓC THƯ GIÃN — ĐĨA NHẠC LOFI)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Thiết kế như một **"Góc nghe nhạc đĩa than analog"** hoài cổ. Không có quảng cáo ngắt quãng, chỉ có âm thanh lofi êm dịu giúp Sen thư giãn cùng Boss.
*   **Vibe cảm xúc**: Yên bình, chữa lành, cổ cổ.
*   **Đĩa than xoay chậm**: Ở trung tâm là một đĩa than (Vinyl disk) vẽ phác thảo xoay chậm rãi 1 vòng mỗi 15 giây khi nhạc phát. Khi dừng nhạc, đĩa dừng xoay một cách từ tốn (`deceleration transition`).

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: ArrowLeft] Góc Thư Giãn      [Lucide: Gift]  | <--- Nút Wishlist #FCAFAF
|  =================================================    |
|                                                       |
|  +-------------------+  +-------------------------+  |
|  | [  Đĩa Nhạc 🎵  ] |  | [  Kệ Sách Gỗ 📚  ]   |  | <--- Segmented Tabs (H 36px)
|  +-------------------+  +-------------------------+  |
|                                                       |
|              /-------\                               |
|             /  [💿]  \                              | <--- Đĩa than Lottie xoay chậm
|             \         /                              |      (diameter 180px)
|              \-------/                               |
|                                                       |
|           Gió Đùa Nhành Tre                          | <--- Inter Bold 18px #1C1C1E
|                Thế Sơn                               | <--- Inter Regular 13px #6E6E6A
|                                                       |
|    ======●---------------------------  0:15           | <--- Muji Slider (ray 4px Obsidian)
|                                                       |
|         [ Nghe Bản Đầy Đủ [Lucide: ExternalLink] ]   | <--- Primary Button H 48dp #121212
|                                                       |
|  - - - - - - - - - - - - - - - - - - - - - - - - -   |
|  [Lucide: Play] Bài kế tiếp: Mưa Hồng...             |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                                           ____        | <--- Muji Bar under "Headphones"
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Điều Khiển (Interactions & Playback Controls)

1.  **Thanh trượt tiến trình mộc mạc (Muji Slider)**:
    *   Ray trượt dày `4px` phẳng phiu. Phần đã phát tô đen Obsidian `#121212`, phần chưa phát tô xám nhạt `#EAEAEA`.
    *   Thumb kéo dẹt `16x16px` màu trắng tinh, viền xám mảnh. Kéo thumb phát ra nhịp rung haptic cực kỳ nhỏ theo từng giây trượt (`HapticFeedback.selectionClick`).
2.  **Nút liên kết nghe bản đầy đủ (External Redirect)**:
    *   Vì lý do bản quyền và tối ưu app, app chỉ phát thử 15-30s lofi. Để nghe bản đầy đủ, Sen chạm nút **[Nghe Bản Đầy Đủ]** để gọi Deep Link chuyển tiếp mượt mà sang Spotify hoặc Apple Music của nghệ sĩ.
3.  **Hoạt ảnh tai nghe ở Navigation Dock**:
    *   Khi nhạc đang phát ngầm ở background, icon tai nghe `[🎧]` ở thanh Dock đáy biến đổi thành hoạt ảnh **3 vạch sóng nhạc nhấp nhô** nhẹ nhàng để nhắc Sen nhạc vẫn đang bật.
4.  **Pha trộn âm lượng ambient**:
    *   Trượt ngón tay dọc hai bên sườn đĩa than để điều khiển độc lập: Sườn trái = âm lượng Lofi, Sườn phải = âm lượng Tiếng mưa rơi ngoài hiên.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tên bài hát: `Inter Bold 18px` màu `#1C1C1E`.
    *   Nghệ sĩ: `Inter Regular 13px` màu xám trung tính `#6E6E6A`.
    *   Bộ đếm giây: `Space Mono Regular 12px` màu `#1C1C1E`.
*   **Màu sắc**:
    *   Nền phòng: `#FBFBFA` (Màu yến mạch giấy tái chế).
    *   Segmented Tabs: Khay nền xám yến mạch `#F8F9FA`, tab active nền trắng `#FFFFFF` bo góc `6px` có shadow loãng `rgba(0,0,0,0.03)`.
*   **Kích thước & Bo góc**:
    *   Đĩa than: Đường kính `180dp` tròn trịa.
    *   Nút External: Cao `48dp`, bo góc `12px`.
    *   Bottom Navigation Dock active indicator bar: `16x2px` trượt nằm sát dưới icon Headphones.
