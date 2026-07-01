# ĐẶC TẢ GIAO DIỆN: SCR-09 — SETTINGS SCREEN (TRANG CÀI ĐẶT BÌNH YÊN)
*Chủ trì: Maya (Principal UI/UX Architect) & Sophia (CPO)*

---

## 🎨 1. Không Gian Mỹ Thuật & Trải Nghiệm (Aesthetic & UX Vibe)

*   **Ý tưởng chủ đạo**: Trang cài đặt không chỉ là các tùy chọn kỹ thuật khô khan mà là **nơi tinh chỉnh giác quan** để đạt tới trạng thái thư giãn tốt nhất.
*   **Vibe cảm xúc**: Tinh tế, gọn gàng, tôn trọng sự tĩnh lặng.
*   **Triết lý bố cục**: Thiết kế phẳng dẹt hoàn toàn. Chia nhóm tùy chọn rõ ràng bằng chữ in hoa nhỏ màu xám nhạt, các dòng option cách biệt bằng đường kẻ chỉ mảnh.

---

## 🗺️ 2. Bố Cục Wireframe (ASCII Layout)

```
+-------------------------------------------------------+
|  [ 22:00 ]                                     [ 90%] |
|  [Lucide: ArrowLeft] Cài Đặt                          | <--- Top App Bar (H 56px)
|  =================================================    |
|                                                       |
|  CÀI ĐẶT BOSS VÀ SEN                                  | <--- Nhóm Label (Inter Medium 11px #8C8C8C)
|  ___________________________________________________  |
|  Thông Tin Thú Cưng                [Lucide: ChevronRight]| <--- Muji Info Field chỉnh sửa (H 56px)
|  Độ Nhạy Purring Haptic            [Lucide: ChevronRight]|
|  ___________________________________________________  |
|                                                       |
|  TƯƠNG TÁC & ÂM THANH                                 |
|  ___________________________________________________  |
|  Âm Thanh Nền (Ambient)    [==●=== Cozy Switch ON]    | <--- Cozy Switch: #8FA882 khi ON
|  Hiệu Ứng Rung Haptic      [===○== Cozy Switch OFF]   |      #EAEAEA khi OFF
|  ___________________________________________________  |
|                                                       |
|  THÔNG TIN KHÁC                                       |
|  ___________________________________________________  |
|  Trợ Giúp & Phản Hồi               [Lucide: ChevronRight]|
|  Điều Khoản Sử Dụng                [Lucide: ChevronRight]|
|  ___________________________________________________  |
|                                                       |
+-------------------------------------------------------+
|  [Lucide: Home]  [Lucide: MessageSquare]  [Lucide: Camera]  [Lucide: Headphones]  [Lucide: User]  |
|                                                 ____  | <--- Muji Bar under "User"
+-------------------------------------------------------+
```

---

## ⚙️ 3. Hành Vi Tương Tác & Điều Khiển (Interactions & Custom Switches)

1.  **Công tắc Cozy Switch độc quyền (Muji Cozy Switch)**:
    *   **Trạng thái ON**: Thanh trượt dài chuyển màu xanh Matcha `#8FA882`, nút tròn di chuyển sang phải mượt mà.
    *   **Trạng thái OFF**: Thanh trượt chuyển màu xám nhạt `#EAEAEA`, nút tròn nằm bên trái.
    *   *Tương tác*: Chạm công tắc phát ra nhịp rung phản hồi xúc giác nhẹ (`light haptic`). Nếu bật Rung Haptic ON -> phát thử nhịp rung hơi thở mèo 1.4s để Sen trải nghiệm trước.
2.  **Chạm dòng Option (Row Selection)**:
    *   Chạm mở Bottom Sheet (ví dụ: Chỉnh sửa Bio Boss) hoặc điều hướng sang trang tương ứng, sử dụng hiệu ứng trượt màn hình ngang (Slide Transition) kiểu iOS.

---

## 📐 4. Đặc Tả Token & Định Dạng (Design Tokens Specification)

*   **Phông chữ**:
    *   Tên tùy chọn: `Inter Medium 14px` màu `#5C5C58` (Xám đen).
    *   Nhãn nhóm cài đặt: `Inter Medium 11px` viết hoa, màu `#8C8C8C`.
*   **Màu sắc**:
    *   Nền: `#FBFBFA` (Màu yến mạch giấy tái chế).
    *   Công tắc active: `#8FA882` (Matcha Green).
    *   Đường phân tách ngang: `1px solid #EAEAEA`.
*   **Kích thước & Bo góc**:
    *   Muji Switch: Kích thước vỏ ngoài `44x24px`, bo góc `12px`. Chốt tròn bên trong `18x18px` trắng tinh.
    *   Chiều cao dòng option: `56dp`.
    *   Bottom Navigation Dock active indicator bar: `16x2px` trượt nằm sát dưới icon User (chung Tab 5 Profile).
