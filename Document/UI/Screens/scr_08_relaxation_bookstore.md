# ĐẶC TẢ GIAO DIỆN: SCR-08 — RELAXATION BOOKSTORE (GÓC THƯ GIÃN — HIỆU SÁCH CŨ)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Thiết kế như một **"Kệ sách gỗ mộc mạc"**. Nơi Sen tìm đọc những tác phẩm văn học hoặc ghi chép tự sự chữa lành về thế giới động vật.
*   **Vibe cảm xúc**: Yên bình, tri thức, tĩnh tại.
*   **Triết lý bố cục**: Bìa sách dạng đứng tỷ lệ đứng chuẩn `3:4` được bo góc nhẹ, xếp gọn gàng theo hàng ngang. Phía dưới mỗi sách có thanh tiến trình đọc Matcha mỏng mảnh.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: ArrowLeft] Góc Thư Giãn      [Lucide: Gift]  | <--- Nút Wishlist #FCAFAF
|  =================================================    |
|                                                       |
|  +-------------------+  +-------------------------+  |
|  |    Đĩa Nhạc 🎵    |  | [  Kệ Sách Gỗ 📚  ]   |  | <--- Segmented Tabs (H 36px)
|  +-------------------+  +-------------------------+  |
|                                                       |
|  +---+  Tôi Là Một Chú Mèo                            | <--- Inter Bold 16px
|  |Cover |  Natsume Soseki                             | <--- Inter Regular 13px, mờ 60%
|  |      |                                             | <--- Bìa sách tỷ lệ 3:4, bo góc 6px
|  +---+                                                |
|  |====== 45% Đã Đọc                                   | <--- Thanh tiến trình Matcha 3px
|                                                       |
|  Cuốn tiểu thuyết chữa lành mô tả cuộc                | <--- Đoạn tóm tắt/cảm tưởng (Reflective Notes)
|  sống con người qua lăng kính dí dỏm                  |      Inter Regular 13px mờ 70%
|  của một chú mèo không tên...                         |
|  +-----------------------------------+                |
|  | "Hãy sống như một chú mèo, ngủ    |                | <--- Quote Block (Space Mono Italic 13px)
|  | khi mệt và kêu ca khi đói."       |                |      Nền kem ấm #F5F5F0, bo góc 8px
|  +-----------------------------------+                |
|                                                       |
|  +----------------+ +-----------------+               |
|  | Kệ Sách Gỗ 📚  | |   Mua Sách ➔    |               | <--- Nút phụ lưu kệ | Nút chính mua link ngoài
|  +----------------+ +-----------------+               |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                                           ____        | <--- Muji Bar under "Headphones"
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Tính Năng Chi Tiết (Interactions & Features)

1.  **Chuyển đổi sách ngang (Horizontal Book Carousel)**:
    *   Sen vuốt ngang để lật xem các đầu sách khác nhau trên kệ. Bìa sách, mô tả và khung trích dẫn sẽ chuyển đổi đồng bộ bằng hiệu ứng trượt 2D thanh thoát.
2.  **Khung trích dẫn tâm đắc (Quote Block)**:
    *   Hiển thị câu châm ngôn sâu sắc nhất của tác phẩm bằng font chữ Space Mono để Sen suy ngẫm. Chạm giữ câu quote để sao chép nhanh hoặc chia sẻ thẻ Meme.
3.  **Hành động Nút bấm (CTA Actions)**:
    *   **Nút "Mua Sách ➔"**: Điều hướng người dùng sang các sàn thương mại điện tử Tiki/Shopee bên ngoài để mua sách giấy ủng hộ tác giả.
    *   **Nút "Kệ Sách Gỗ 📚"**: Lưu tác phẩm vào danh mục muốn đọc cục bộ trên máy.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tiêu đề sách: `Inter Bold 16px` màu `#1C1C1E`.
    *   Tác giả: `Inter Regular 13px` màu xám mờ `60%`.
    *   Mô tả sách: `Inter Regular 13px` line-height `1.5`, màu Obsidian mờ `70%`.
    *   Câu trích dẫn (Quote): `Space Mono Italic 13px` màu nâu gỗ trầm ấm.
*   **Màu sắc**:
    *   Nền: `#FBFBFA` (Màu yến mạch giấy tái chế).
    *   Thanh tiến trình: Màu xanh Matcha `#8FA882`.
    *   Khung Quote: Nền màu sữa giấy thủ công `#F5F5F0`, không viền.
*   **Kích thước & Bo góc**:
    *   Bìa sách: `width: 72dp`, `height: 96dp`, bo góc `6px`.
    *   Khung Quote: Bo góc `8px`, padding `12px`.
    *   Nút "Mua Sách": Cao `48dp`, bo góc `12px`, nền Obsidian `#121212`, chữ trắng.
    *   Bottom Navigation Dock active indicator bar: `16x2px` trượt nằm sát dưới icon Headphones (chung Tab 4 Thư giãn).
