# 🎨 Hướng Dẫn Thương Hiệu & Quy Chuẩn Thiết Kế (Brand Guidelines)

Tài liệu này xác định các quy chuẩn thiết kế, hệ thống Grid, Typography và màu sắc (Design Tokens) áp dụng cho tính năng **Đăng nhập SSO** và **Trang thông tin cá nhân (Profile)** trên trang Web Affiliate của DOCA.

---

## 1. Bảng Màu Hệ Thống (Color Palette)

Hệ thống màu sắc tiếp tục kế thừa phong cách **Cozy Muji Minimalism** ấm áp, mộc mạc và được bổ sung thêm các sắc độ dành riêng cho các dịch vụ SSO bên thứ ba để đảm bảo khả năng nhận diện thương hiệu nhưng không phá vỡ tổng thể.

### 1.1. Màu Nền & Trung Tính (Neutral Warm)
*   **Nền chính trang Profile**: `var(--cozy-bg-oatmeal)` (`#E8E3D6`) - Màu cát ấm Nhật Bản.
*   **Thẻ thông tin (Cards/Modal)**: `var(--cozy-bg-pure)` (`#FBFAF6`) - Màu mây trắng sữa/vải thô Canvas.
*   **Nền phụ/Khu vực phụ**: `var(--cozy-bg-beige)` (`#F4F1E9`) - Màu giấy ấm áp.
*   **Đường viền/Phân cách**: `var(--cozy-border-light)` (`#D4CDBF`) - Màu cát Muji mảnh.
*   **Chữ & Nút bấm chính**: `var(--cozy-text-obsidian)` (`#15170F`) - Màu mực Charcoal.

### 1.2. Màu Nhấn Đặc Trưng (Matcha & Sakura V2)
*   **Matcha Green (Chủ đạo)**: `var(--cozy-green-matcha)` (`#8FBF4F`) - Xanh matcha ấm áp, dùng cho trạng thái tích cực hoặc hoạt động.
*   **Sakura Pink (Nhấn)**: `var(--cozy-pink-sakura)` (`#F4ABBE`) - Hồng cánh đào ngọt ngào, dùng cho các nút tương tác nhẹ, biểu tượng thú cưng.

### 1.3. Màu Thương Hiệu SSO (Third-Party Identity Colors)
Để các nút đăng nhập SSO dễ nhận diện mà vẫn giữ tính tối giản:

| Cổng SSO | Token Màu Nền (Background) | Token Màu Chữ / Icon | Ghi Chú Thiết Kế |
| :--- | :--- | :--- | :--- |
| **Google** | `#FFFFFF` (hoặc `var(--cozy-bg-pure)`) | `var(--cozy-text-obsidian)` | Viền mảnh `1px solid var(--cozy-border-light)`. Sử dụng Logo G-color tiêu chuẩn. |
| **Zalo** | `#0068FF` (Thương hiệu gốc) hoặc `#E1F5FE` (Pastel) | `#FFFFFF` (trên nền xanh) hoặc `#0068FF` (trên nền Pastel) | Đề xuất: Dạng viền mảnh (Outline) nền trắng viền xanh nhạt để dịu mắt, hoặc nút nền xanh Zalo đặc trưng khi cần kêu gọi hành động mạnh. |

---

## 2. Hệ Thống Typography (Thang Đo Chữ)

Sử dụng phông chữ **Inter** (sans-serif) làm phông chữ hệ thống chủ đạo cho toàn bộ giao diện tương tác, biểu mẫu và trang Profile.

*   **Tiêu đề lớn trang Profile (H1)**: `2.25rem` (~36px) | Font-weight: `700` | Line-height: `1.25`
*   **Tiêu đề nhóm/Thẻ (H2 / Card Title)**: `1.25rem` (~20px) | Font-weight: `600` | Line-height: `1.4`
*   **Chữ thân bài/Nhãn biểu mẫu (Body / Label)**: `0.95rem` (~15px) | Font-weight: `500` hoặc `400` | Line-height: `1.6`
*   **Chú thích nhỏ (Caption / Whisper)**: `0.75rem` (~12px) | Font-weight: `400` | Màu chữ: `#6E6E73` (Xám ấm)

---

## 3. Quy Chuẩn Khoảng Cách & Bo Góc (Grid & Spatial Rhythm)

Toàn bộ khoảng cách tuân thủ **Hệ số 8 (8px grid)** để tạo cảm giác cân đối, thoáng đãng kiểu Nhật Bản.

### 3.1. Khoảng Cách (Margins & Paddings)
*   **Padding trong Modal Đăng nhập**: `2rem` (32px) hoặc `2.5rem` (40px) để tạo khoảng thở rộng rãi.
*   **Padding trong Thẻ Profile**: `1.5rem` (24px).
*   **Khoảng cách giữa các nút SSO**: `0.75rem` (12px) theo chiều dọc.
*   **Khoảng cách giữa các trường thông tin Profile**: `1rem` (16px).

### 3.2. Bo Góc (Border Radius)
*   **Cửa sổ đăng nhập (Modal Overlay)**: `20px` (Bo góc tròn mềm mại hơn card thông thường).
*   **Thẻ thông tin Profile / Pet Card**: `var(--radius-card)` (`16px`).
*   **Nút bấm SSO / Nút Đăng xuất**: `var(--radius-button)` (`12px`).
*   **Ảnh đại diện (Avatar)**: `50%` (Hình tròn hoàn hảo cho avatar người dùng) hoặc `var(--radius-avatar)` (`8px`) cho avatar thú cưng.

---

## 4. Biểu Tượng Giao Diện (Icons Standard)

Bắt buộc sử dụng bộ thư viện **Phosphor Icons** theo đúng chỉ đạo thiết kế nét mảnh:
*   Trạng thái bình thường: Sử dụng lớp `ph-light` (nét mảnh `1.7px`).
*   Trạng thái hover/active: Sử dụng lớp `ph-fill` hoặc `ph-duotone` để nhấn mạnh phản hồi thị giác.
*   **Các icon đề xuất**:
    *   Nút Đăng nhập: `ph-light ph-sign-in`
    *   Nút Đăng xuất: `ph-light ph-sign-out`
    *   Trang cá nhân (User Capsule): `ph-light ph-user` hoặc `ph-light ph-paw`
    *   Thẻ thú cưng (Pet Card): `ph-light ph-sparkles` hoặc `ph-light ph-heart`
