# ĐẶC TẢ GIAO DIỆN: SCR-10 — ACCOUNT & PROFILE SCREEN (HỒ SƠ SEN & KHÔNG GIAN BẢO MẬT)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Mảnh vườn riêng tư của Sen. Nơi lưu trữ thông tin đồng hành và thực thi quyền kiểm soát dữ liệu tuyệt đối (Offline-First Privacy).
*   **Vibe cảm xúc**: Tôn trọng, bình yên, minh bạch, bảo mật.
*   **Điểm nhấn độc quyền (Boarding Pass Card)**: Thẻ vé tàu kỷ niệm Capcat Cozy Premium được thiết kế theo phong cách Cozy Dark mờ ảo sang trọng, có vết cắt vé răng cưa đứt nét và chấm phát sáng Matcha báo hiệu kích hoạt thành công.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: ArrowLeft] Tài Khoản                        |
|  =================================================    |
|                                                       |
|                    ( O )                              | <--- Avatar Sen (tròn 80px)
|                 Sen Đáng Yêu                          | <--- Inter Bold 16px #1C1C1E
|              user@example.com                         | <--- Inter Regular 13px #6E6E6A
|                                                       |
|  +--------------------------------------------------+ |
|  |           🎫 CAPCAT COZY PREMIUM                  | | <--- Thẻ Vé Tàu (Boarding Pass)
|  |        Hành Trình Gắn Kết Vô Hạn                 | |      Nền Obsidian #1E1F24 + Sakura #FCAFAF
|  |   Trạng thái:  ● Đang hoạt động                  | |      radius 16px, Cozy Dark mode
|  +--------------------------------------------------+ |
|                                                       |
|  THÔNG TIN TÀI KHOẢN                                  |
|  ___________________________________________________  |
|  Email                       user@example.com         | <--- Info Field tĩnh (H 48px)
|  Ngày Tham Gia                     2026.06.12         |
|  ___________________________________________________  |
|                                                       |
|  VƯỜN VẾT CHÂN ĐỒNG HÀNH (Companion Heatmap)          | <--- Lưới 12 tuần đồng hành
|  [🐾][🐾][  ][🐾][🐾][  ][  ][🐾][🐾][🐾][🐾][🐾]     |      Màu Matcha hoặc Sakura Pink
|                                                       |
|  HÀNH ĐỘNG BẢO MẬT & BỘ NHỚ                           |
|  ___________________________________________________  |
|  Dọn dẹp tủ ký ức (Xóa cache tạm: 124MB)              | <--- Tải lại mượt mà, giải phóng bộ nhớ
|  Minh bạch dữ liệu (Xuất sao lưu tệp .zip)             | <--- Đóng gói chat logs + hình ảnh
|  Đăng xuất và nghỉ ngơi một chút...                   | <--- Dòng text mỏng màu xám tro
|  ___________________________________________________  |
|                                                       |
|           Xóa tài khoản vĩnh viễn                    | <--- Màu đỏ cảnh báo #FF5252
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                                                 ____  | <--- Muji Bar under "User"
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Tính Năng Chi Tiết (Interactions & Features)

1.  **Lưới Vườn Vết Chân (Tiny Paw Heatmap)**:
    *   Hiển thị ma trận `12 cột x 7 dòng` (12 tuần hoạt động gần nhất). Mỗi ô đại diện cho một ngày.
    *   Nếu ngày đó có hoạt động tương tác với thú cưng: ô đó in hình bàn chân nhỏ màu xanh Matcha `#8FA882` hoặc hồng Sakura `#FCAFAF`.
    *   Chạm nhẹ vào một ô hiển thị tooltip mờ chỉ số tương tác của ngày đó (ví dụ: *"25/05/2026: 3 lần cho ăn, 12 tin nhắn"*).
2.  **Dọn dẹp bộ nhớ & Xuất dữ liệu (Data Operations)**:
    *   **Dọn dẹp tủ ký ức**: Chạm vào sẽ xóa cache hình ảnh cục bộ, giải phóng dung lượng điện thoại nhưng giữ nguyên SQLite database chat logs. Hiển thị thông báo Toast phẳng: *"Đã dọn dẹp 124MB cache tủ ký ức 🧹"*.
    *   **Minh bạch dữ liệu**: Đóng gói SQLite hội thoại và toàn bộ ảnh thư mục cục bộ thành một tệp `.zip` tiện dụng và mở khay chia sẻ để Sen lưu trữ. Không khóa dữ liệu (No vendor lock-in).
3.  **Triết lý Đăng xuất (Silent Logout)**:
    *   Không thiết kế nút bấm màu đỏ giật gân. Đăng xuất hiển thị dưới dạng một liên kết chữ xám ấm. Chạm vào sẽ hiện Dialog tối giản Muji xác nhận nhẹ nhàng để bảo vệ tâm lý người dùng.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tên Sen: `Inter Bold 16px` màu `#1C1C1E`.
    *   Thông tin đồng hành: `Inter Regular 13px` màu `#6E6E6A`.
    *   Chữ vé tàu Boarding Pass: `Inter Bold 16px` (Tiêu đề) và `Space Mono Regular 12px` (Số vé/Trạng thái).
*   **Màu sắc**:
    *   Nền màn hình: `#FBFBFA` (Màu yến mạch giấy tái chế).
    *   Thẻ Boarding Pass: Nền đen Obsidian trầm `#1E1F24`, viền mảnh `#2C2C2E`. Nét xé vé đứt đoạn `1px dashed rgba(255,255,255,0.15)`. Chấm hoạt động Matcha `#76C123` phát sáng mờ.
*   **Kích thước & Bo góc**:
    *   Avatar Sen: `80x80px`, bo góc `8px` (`Radius.cozyAvatar`).
    *   Thẻ Boarding Pass: Bo góc `28px` sang trọng, cao `140dp`.
    *   Bottom Navigation Dock active indicator bar: `16x2px` trượt nằm sát dưới icon User.
