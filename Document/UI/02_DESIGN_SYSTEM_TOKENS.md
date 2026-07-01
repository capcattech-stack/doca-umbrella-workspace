# 02. ĐỒNG BỘ HỆ THỐNG TOKENS THIẾT KẾ (DESIGN SYSTEM TOKENS)

---

## 🎨 1. Hệ Thống Màu Sắc (Color Tokens)

Hệ thống màu sắc được chia thành **Chủ đề Sáng (Cozy Light) làm mặc định** cho toàn bộ giao diện thông thường, và **Chủ đề Tối (Cozy Dark) chuyên biệt** cho các màn hình giàu cảm xúc (Postcard, Swipe, Boarding Pass).

### 1.1. Dải Màu Bản Sắc (Brand Colors)

| Token Name | Hex Code | HSL Value | Ý Nghĩa Thẩm Mỹ & Ứng Dụng |
| :--- | :--- | :--- | :--- |
| **COZY LIGHT (Mặc định)** | | | |
| `Pure White` | `#FBFAF6` | `hsl(48, 45%, 97%)` | **Cloud:** Nền ứng dụng chính nhã nhặn, dịu mắt. |
| `Oatmeal Background`| `#E8E3D6` | `hsl(42, 21%, 87%)` | **Sand:** Nền phụ hoặc khay chứa danh mục điều khiển. |
| `Soft Milk Beige` | `#F4F1E9` | `hsl(43, 26%, 93%)` | **Paper:** Bề mặt giấy ấm áp thương hiệu, nền thẻ Moments. |
| `Deep Obsidian` | `#15170F` | `hsl(72, 29%, 10%)` | **Charcoal Ink:** Chữ chính trên nền sáng, rõ nét nhưng dịu mắt. |
| `Charcoal Black` | `#15170F` | `hsl(72, 29%, 10%)` | **Charcoal Ink:** Các nút hành động chính (Primary Button). |
| **COZY DARK (Chuyên biệt)**| | | |
| `Dark Slate` | `#0D0D0D` | `hsl(0, 0%, 5%)` | Bóng đêm vô cực làm nền chính cho game quẹt thẻ, postcard. |
| `Ticket Charcoal` | `#1E1F24` | `hsl(228, 9%, 13%)` | Màu thẻ Ticket, Boarding Pass (bo góc `28px`). |
| `Neon Healing Green`| `#76C123` | `hsl(88, 69%, 45%)` | Màu nhấn phát sáng cho mốc đo lường và trạng thái Premium. |
| `Warm Amber Light` | `#FFF9C4` | `hsl(54, 100%, 89%)` | Ánh đèn ngủ ấm áp ban đêm, vạt nắng xiên nhẹ dịu. |
| **MÀU NHẤN CẢM XÚC (Matcha & Sakura V2)** | | | |
| `Sakura Pastel` | `#F4ABBE` | `hsl(346, 78%, 82%)` | **Hồng Anh Đào Pastel:** Nút cảm xúc mèo, ngọt ngào mùa xuân (Mặc định). |
| `Sakura Bright` | `#E07090` | `hsl(343, 67%, 66%)` | **Hồng Anh Đào Rực:** Nút tương phản mạnh với Brand green. |
| `Sakura Mauve`  | `#C470A0` | `hsl(326, 42%, 60%)` | **Tím Hồng Mauve:** Phong cách sang trọng, bí ẩn. |
| `Matcha Warm`   | `#8FBF4F` | `hsl(85, 47%, 53%)`  | **Xanh Matcha Ấm Áp:** Nút đi dạo chó, safe-vet (Mặc định). |
| `Matcha Forest` | `#4A8A2E` | `hsl(102, 50%, 36%)` | **Xanh Matcha Đậm:** Nền banner, sắc từ rừng đến nhạt. |
| `Matcha Dark`   | `#1F3E12` | `hsl(102, 55%, 16%)` | **Xanh Matcha Tối:** Tối premium kết hợp brand green. |
| `Matcha Cream`  | `#F5EDD5` | `hsl(45, 59%, 90%)`  | **Nền kem Matcha:** Ấm áp dễ chịu phối cùng Matcha. |
| **MÀU GỖ TRUYỀN THỐNG (Wood Accents)** | | | |
| `Sugi` 杉       | `#8B5E3C` | `hsl(26, 40%, 39%)`  | **Gỗ tuyết tùng:** Màu gỗ ấm áp, trung tính, thanh lịch. |
| `Kogecha` 焦茶  | `#4A2418` | `hsl(14, 51%, 19%)`  | **Nâu cháy đậm:** Nền tối truyền thống, phong cách cổ điển. |
| `Kohaku` 琥珀   | `#B8860A` | `hsl(43, 89%, 38%)`  | **Vàng hổ phách:** Nền sơn mài / tre già óng ả sang trọng. |

### 1.2. Màu Trạng Thái Hệ Thống (Semantic Soft Colors)

Tránh tuyệt đối các tông màu đỏ chói hay xanh neon thương mại. Tất cả thông điệp hệ thống đều sử dụng dải màu dịu ngọt:
*   **Thành công (Cozy Success):** `#E8F5E9` (Pastel Sage Green) - Gợi cảm giác xanh tươi của cây cỏ vườn nhà.
*   **Cảnh báo (Cozy Warning):** `#FFE0B2` (Soft Apricot Orange) - Màu cam của vỏ quýt chín.
*   **Lỗi / Khẩn cấp (Cozy Error):** `#FFCDD2` (Dusty Cherry Pink) - Màu hồng nhạt cánh hoa anh đào úa.
*   **Thông tin (Cozy Info):** `#E1F5FE` (Pale Sky Blue) - Màu xanh da trời ban mai lãng đãng sương mù.

### 1.3. Phân Cấp Màu Sắc Nút Bấm (Button Color Hierarchy)

#### Cozy Light Mode (Mặc Định)
1.  **Nút Bấm Chính (Primary Button):** Nền `Charcoal` (`#15170F`), chữ `Cloud` (`#FBFAF6`), font `Inter Bold`.
2.  **Nút Bấm Phụ (Secondary Button):** Nền `Sand` (`#E8E3D6`), viền `1px` màu `#D4CDBF`, chữ `Charcoal` (`#15170F`), font `Inter Medium`.
3.  **Nút Cảm Xúc Mèo (Sensory Cat):** Nền `Sakura Pastel` (`#F4ABBE` độ mờ 20%), chữ `Charcoal` (`#15170F`), font `Inter SemiBold`.
4.  **Nút Cảm Xúc Chó (Sensory Dog):** Nền `Matcha Warm` (`#8FBF4F` độ mờ 15%), chữ `Charcoal` (`#15170F`), font `Inter SemiBold`.

#### Cozy Dark Mode (Chuyên Biệt)
1.  **Nút Bấm Chính (Primary Button):** Nền `Pure White` (`#FFFFFF`), chữ `Charcoal Black` (`#121212`), font `Inter Bold`.
2.  **Nút Bấm Phụ (Secondary Button):** Nền kính mờ `Glassmorphism` (`rgba(255, 255, 255, 0.08)`), viền mỏng trắng mờ, chữ `Soft Milk Beige` (`#F5F5F0`), font `Inter Medium`.
3.  **Nút Phát Sáng Neon (Neon Glowing):** Nền `Neon Healing Green` (`#76C123`), chữ `Charcoal Black`, font `Inter Bold`. `boxShadow` tỏa sáng xanh lá mờ.

---

## ✍️ 2. Hệ Thống Kiểu Chữ (Typography Tokens)

Để đạt được sự nhẹ nhàng, dễ chịu cho võng mạc, hệ thống kiểu chữ được chuẩn hóa thành **hai phông duy nhất**:

1.  **Inter (Google Fonts — `Font.primary`):** Font không chân hình học trung tính, tỷ lệ hoàn hảo, cực kỳ dễ đọc. Đóng vai trò **linh hồn giao tiếp chủ đạo** cho toàn bộ UI (tiêu đề, nút bấm, tin nhắn, nhãn form, con số, chú thích).
2.  **Space Mono (Google Fonts — `Font.mono`):** Font máy đánh chữ (typewriter monospace) mang cảm giác thủ công, ấm áp và hoài cổ. **Tuyệt đối giới hạn** chỉ dùng cho: nhật ký trích dẫn cảm xúc, timestamp, streak count, và lời thì thầm chiêm nghiệm đêm muộn (`whisperMono`).

```html
<!-- Import cả hai phông từ Google Fonts bằng 1 dòng -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">
```

### Bảng Phân Cấp Kiểu Chữ Chuẩn (Typography Hierarchy Scale)

| Token Name | Font Family | Size (sp/dp) | Weight | Line Height | Ứng Dụng Thực Tế |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `displayLarge` | **Inter** | `32` | Bold (700) | `1.2` | Tiêu đề chào mừng lớn, Tên Pet ở Dashboard |
| `headlineLarge` | **Inter** | `24` | Bold (700) | `1.3` | Tiêu đề Thẻ Ký ức (Moments Card) |
| `titleLarge` | **Inter** | `20` | SemiBold (600) | `1.4` | Tên người dùng, Tiêu đề Chat, Tiêu đề Popup |
| `bodyLarge` | **Inter** | `16` | Medium (500) | `1.5` | Nội dung tin nhắn thân mật của Boss & Sen |
| `bodyMedium` | **Inter** | `14` | Regular (400) | `1.5` | Mô tả hoạt động chăm sóc thường nhật, thẻ phụ |
| `whisperMono` | **Space Mono** | `15` | Regular (400) Italic | `1.6` | **[Điểm nhấn máy đánh chữ]** Lời thì thầm, nhật ký cảm xúc |
| `numericLabel` | **Inter** | `13` | SemiBold (600) | `1.2` | Số cân nặng, số phút đi dạo, mốc thời gian |
| `buttonText` | **Inter** | `15` | SemiBold (600) | `1.0` | Chữ hiển thị trên các nút bấm hành động |
| `captionText` | **Inter** | `12` | Regular (400) | `1.4` | Timestamp phụ, chú thích nhỏ |
| `monoCaption` | **Space Mono** | `11` | Regular (400) | `1.4` | Timestamp trong nhật ký, streak counter |

---

## 🎴 3. Hình Khối & Bo Góc (Border Radius & Shapes)

Sự bo cong được khống chế ở tỷ lệ vừa phải, phẳng và ngăn nắp, mang lại cảm giác dễ chịu và chuyên nghiệp:

*   **`Radius.cozyCard` (16px):** Áp dụng cho các thẻ bài chính hiển thị ở màn hình Dashboard, Moments, và hộp thoại pop-up trung tâm. Giúp thẻ bài có cấu trúc phẳng gọn gàng, thanh nhã, tránh phồng bong bóng thô kệch.
*   **`Radius.cozyButton` (12px):** Áp dụng cho các nút bấm hành động, thanh input chat, bảng điều khiển phụ.
*   **`Radius.cozyTag` (8px):** Dành cho các nhãn phân loại nhỏ như loài pet (Chó, Mèo), nhãn hoạt động, nhãn thời gian.
*   **`Radius.cozyAvatar` (8px):** Áp dụng cho avatar của Pet hoặc người dùng.

---

## 🌌 4. Kính Mờ & Đổ Bóng (Glassmorphism & Shadows)

*   **Hiệu ứng Kính Mờ (Glassmorphism):** Áp dụng cho các panel điều khiển phụ nổi trên nền tối để tạo hiệu ứng sương mù.
    *   *Nền chứa:* `rgba(255, 255, 255, 0.04)` kết hợp lớp phủ mờ vật lý `backdrop-filter: blur(16px)`.
    *   *Viền mờ:* Đường viền siêu mảnh `0.5px solid` với độ mờ 30% của màu nhấn tương ứng.
*   **Đổ bóng tối giản (Cozy Shadows):**
    *   *Default State:* Bóng đổ cực loãng để tạo chiều sâu tinh tế: `boxShadow: rgba(28, 28, 30, 0.04), blur: 12px, y: 4px`.
    *   *Hover State:* Bóng sâu hơn để biểu thị trạng thái nổi: `boxShadow: rgba(28, 28, 30, 0.10), blur: 20px, y: 8px`.

---

## 🧭 5. Bộ Biểu Tượng Tiêu Chuẩn (Icon Concept)

Hệ thống sử dụng bộ icon **Lucide Icons** làm tiêu chuẩn thiết kế. Icon dạng đơn nét đơn giản, độ nét mềm mại với độ dày nét vẽ (stroke width) khống chế ở `2px` hoặc `2.5px`, đầu nét và góc nối bo tròn (`round caps & joins`).

### Mã mapping các biểu tượng cốt lõi:
*   **Bottom Navigation Dock:**
    *   Tab 1: Trang Chủ $\rightarrow$ Lucide `Home`
    *   Tab 2: Tri Kỷ (Chat) $\rightarrow$ Lucide `MessageSquare`
    *   Tab 3: Hộp Ký Ức (Gallery) $\rightarrow$ Lucide `Camera`
    *   Tab 4: Góc Thư Giãn (Relax) $\rightarrow$ Lucide `Headphones`
    *   Tab 5: Tôi (Profile) $\rightarrow$ Lucide `User`
*   **Hành động & Điều phối:**
    *   Nút Đóng / Bỏ qua $\rightarrow$ Lucide `X`
    *   Nút Thêm / Đón Pet $\rightarrow$ Lucide `Plus`
    *   Nút Cài đặt $\rightarrow$ Lucide `Settings`
    *   Nút Chỉnh sửa $\rightarrow$ Lucide `Pencil`
    *   Nút Mũi tên dẫn hướng / Tiếp tục $\rightarrow$ Lucide `ArrowRight` (hoặc `ChevronRight`)
    *   Nút Lưu trữ / Quà tặng $\rightarrow$ Lucide `Gift`
    *   Nút Phát nhạc $\rightarrow$ Lucide `Play` / `Pause`
    *   Hiển thị / Ẩn mật khẩu $\rightarrow$ Lucide `Eye` / `EyeOff`
