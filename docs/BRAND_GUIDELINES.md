# 🎨 Hướng Dẫn Thương Hiệu & Quy Chuẩn Thiết Kế (Brand Guidelines)

Tài liệu này xác định các quy chuẩn thiết kế, hệ thống Grid, Typography và màu sắc (Design Tokens) áp dụng cho tính năng **Đăng nhập SSO** và **Trang thông tin cá nhân (Profile)** trên trang Web Affiliate của DOCA.

---

## 1. Bảng Màu Hệ Thống (Color Palette)

Hệ thống màu sắc tuân thủ triết lý **Muji Minimalist** (Tối giản Nhật Bản): Nền chủ đạo là trắng giấy, các nút bấm và chữ chính màu đen than sắc nét, sử dụng màu Xanh Neon (#76C123) làm điểm nhấn nhận diện/quan trọng nhất. Các màu nhẹ nhàng khác đóng vai trò làm màu phối phụ (Healing).

### 1.1. Bảng màu cơ bản (Primitives)
*   **Trắng Muji** (`white` | `#FFFFFF`): Nền chính sạch sẽ, khoáng đạt.
*   **Đen Than Muji** (`deep-obsidian` | `#1C1C1E`): Chữ chính, nút bấm chính (High Contrast).
*   **Xanh Neon Điểm Nhấn** (`neon-green` | `#76C123`): Nhận diện quan trọng, trạng thái nhấn mạnh, active chính.
*   **Xám Yến Mạch** (`oatmeal-bg` | `#F8F9FA`): Nền phụ cho Card, Bottom Sheet.
*   **Kem Sữa Muji** (`milk-beige` | `#F5F5F0`): Lớp nền phụ thứ hai, tạo cảm giác tactile ấm.
*   **Kem Giấy Chữa Lành** (`paper-cream` | `#FDFBF7`): Nền nâng cao, dịu mắt.
*   **Hồng Đào Ấm** (`sakura-pink` | `#FCAFAF`): Màu phối: Chỉ số cảm xúc, nhịp tim, nhạc Lo-fi.
*   **Xanh Matcha** (`matcha-green` | `#8FA882`): Màu phối: Nhãn trạng thái thiên nhiên, an toàn.
*   **Vàng Hổ Phách Nhạt** (`warm-amber` | `#FFF9C4`): Màu phối: Cảnh báo nhẹ, ghi chú ấm áp.
*   **Cam Đào Boss** (`cat-peach` | `#FFD1BA`): Màu phối: Minh họa Boss Mèo, màu phụ dễ thương.
*   **Xám Gợi Ý** (`hint-gray` | `#8C8C8C`): Chữ phụ, placeholder trong Input.
*   **Viền Sáng** (`border-light` | `#EAEAEA`): Đường kẻ chia mảnh, viền nút phụ.
*   **Viền Xám Ấm** (`border-subtle` | `#D2D2CC`): Viền các thẻ card phong cách vintage nhẹ.

### 1.2. Ánh xạ ngữ nghĩa (Semantic Aliases) cho 2 chế độ Sáng / Tối
| Token Ngữ Nghĩa | Cozy Light (Sáng) | Cozy Dark (Tối) | Ứng Dụng Thực Tế |
| :--- | :--- | :--- | :--- |
| `color/bg/primary` | `white` (`#FFFFFF`) | `dark-slate` (`#0D0D0D`) | Nền chính của toàn app |
| `color/bg/surface` | `oatmeal-bg` (`#F8F9FA`) | `ticket-charcoal` (`#1E1F24`) | Nền của các thẻ Card, Bottom Sheet |
| `color/bg/elevated` | `paper-cream` (`#FDFBF7`) | `ticket-charcoal` (`#1E1F24`) | Nền Card nổi bật hoặc Dialog |
| `color/text/primary` | `deep-obsidian` (`#1C1C1E`) | `white` (`#FFFFFF`) | Văn bản chính, tiêu đề |
| `color/text/secondary` | `hint-gray` (`#8C8C8C`) | `border-subtle` (`#D2D2CC`) | Văn bản phụ, mô tả |
| `color/text/hint` | `hint-gray` (`#8C8C8C`) | `hint-gray` (`#8C8C8C`) | Input placeholder |
| `color/accent/identity` | `neon-green` (`#76C123`) | `neon-green` (`#76C123`) | Điểm nhấn thương hiệu, nút nhấn mạnh chính |
| `color/accent/emotion` | `sakura-pink` (`#FCAFAF`) | `sakura-pink` (`#FCAFAF`) | Điểm nhấn cảm xúc (âm nhạc, nhịp tim) |

### 1.3. Nhóm màu chất liệu (Material Colors)
Nhóm màu đặc biệt mô phỏng bề mặt vật liệu tự nhiên (Gỗ, Đất sét, Rêu phong, Đá sỏi) theo triết lý Muji:
*   **Đen Than Mộc** (`#1F2022` / `#262626`): Màu than gỗ tự nhiên. Phối cho nét vẽ tay, icon nét mảnh hoặc khung kim loại tối.
*   **Xanh Rêu Đá** (`#242A27` / `#1E2421`): Tông xanh lục sẫm tĩnh lặng. Phối cho các chi tiết rêu phong, nhãn phụ mang vibe sân vườn Nhật Bản.
*   **Xám Đá Phiến** (`#242A27` / `#242831`): Xám xanh trầm ổn của đá sỏi mịn. Phối cho đường viền tủ sách hoặc các thanh ngăn vật lý.
*   **Nâu Đất Nung** (`#20252E` / `#352F2B`): Màu đất sét nung lò gốm ấm áp. Phối cho các mảng khối Lofi, hình vẽ thủ công tạo độ ấm.

### 1.4. Các Bộ Màu Phối Phụ & Quy Tắc Sử Dụng (Coordination Palettes & Heuristics)
Để duy trì tính nhất quán của trải nghiệm chữa lành (Iyashikei) và giảm thiểu tải nhận thức (cognitive load) cho người dùng, dưới đây là đặc tả chi tiết của 8 bộ màu phối phụ cùng quy tắc sử dụng nghiêm ngặt cho từng bộ:

#### 🟢 Nhóm WASABI (Wasabi Tươi Mát)
*   **Wasabi 1** (`#a8d84e` - Tươi): Xanh lá non nhạt. Dùng làm nền phụ hoặc viền active cho các khu vực mang tính sinh thái, vườn tược.
*   **Wasabi 2** (`#76c123` - Cay): Xanh Neon Điểm Nhấn chính của toàn app. Chỉ dùng làm điểm nhấn nhận diện thương hiệu đặc biệt hoặc trạng thái active quan trọng.
*   **Wasabi 3** (`#4d8a10` - Đậm): Xanh lục đậm. Dùng cho các nút hoặc nét vẽ cần độ tương phản cao trên nền sáng.

#### 🍵 Nhóm MATCHA (Matcha Sức Khỏe & Dinh Dưỡng)
*   **Matcha 1** (`#a8cc6e` - Sữa): Xanh matcha sữa dịu mát. Dùng làm nền cho các thẻ thông tin về bữa ăn, thực đơn dinh dưỡng của Boss.
*   **Matcha 2** (`#4a8a2e` - Cổ Điển): Xanh lá Matcha truyền thống. Biểu thị trạng thái sức khỏe tốt (Healthy/Healed), chỉ số ăn uống/vận động khoa học.
*   **Matcha 3** (`#2d5a1b` - Tối): Xanh lá đậm trầm lắng. Dùng cho chữ hiển thị trên nền Matcha 1 hoặc các viền khung dinh dưỡng.

#### 🌸 Nhóm SAKURA (Sakura Cảm Xúc & Trạng Thái Vui Vẻ)
*   **Sakura 1** (`#fbbccc` - Ngọt): Hồng nhạt ngọt ngào. Dùng làm màu nền cho các thông báo chúc mừng, tin vui hoặc huy hiệu đặc biệt.
*   **Sakura 2** (`#e8688a` - Hoa): Màu hoa anh đào nở rộ. Dùng cho trạng thái cảm xúc hạnh phúc của Boss hoặc làm điểm nhấn trang cá nhân.
*   **Sakura 3** (`#c0305e` - Thâm): Hồng đỏ đậm đà. Dùng cho văn bản nổi bật hoặc icon yêu thích trong khối giao diện hệ Sakura.

#### 💝 Nhóm SAKURA WARM (Hồng San Hô - Nhịp Đập Trái Tim & Lofi)
*   **Warm 1** (`#fdd5c0` - Phấn): Hồng phấn ngả cam. Dùng làm nền cho khu vực phát nhạc Lofi thư giãn hoặc giao diện đĩa hát.
*   **Warm 2** (`#fcafaf` - San Hô): Hồng Đào Ấm chính của nhịp tim. Chỉ dùng cho các tương tác gắn kết tình cảm trực tiếp giữa Sen và Boss (vuốt ve, chải lông, trò chuyện).
*   **Warm 3** (`#e06868` - Đỏ Hồng): Đỏ hồng đất nung. Dùng làm cảnh báo/nút hủy/xóa khẩn cấp mang tính chất nhẹ nhàng, chữa lành (tránh dùng màu đỏ tươi gắt).

#### 🍑 Nhóm PEACH (Cam Đào - Vật Phẩm & Vui Chơi)
*   **Peach 1** (`#ffe8d6` - Bông): Cam đào nhạt như bông. Dùng làm màu nền cho hộp thoại của Pet hoặc các bóng bóng chat đối thoại.
*   **Peach 2** (`#ffd1ba` - Tươi): Cam Đào Boss tươi. Làm màu nền đại diện cho đồ chơi, phụ kiện, hoặc các tương tác vui đùa của Boss.
*   **Peach 3** (`#e8906a` - Chín): Cam đào sẫm. Dùng cho text hoặc các nét vẽ minh họa sketch mộc của vật phẩm.

#### 🍯 Nhóm AMBER (Vàng Hổ Phách - Ghi Chú & Nhắc Nhở)
*   **Amber 1** (`#fff9c4` - Nhạt): Vàng Hổ Phách Nhạt. Chỉ dùng làm màu nền cho các hộp thoại ghi chú (memo), nhật ký viết tay của Sen.
*   **Amber 2** (`#f5c842` - Mật): Vàng mật ong. Dùng cho các huy hiệu thành tích vui chơi hoặc cúp lưu niệm của Boss.
*   **Amber 3** (`#d4900a` - Đậm): Vàng đậm hổ phách khô. Dùng cho nhãn nhắc nhở lịch trình nhẹ nhàng (ví dụ: "Đến giờ đi dạo", "Lịch tiêm phòng sắp tới"). Luôn đi kèm chữ màu Đen Than Mộc.

#### 🌌 Nhóm AI 藍 (Indigo - Chàm Tĩnh Lặng & Giao Diện Đêm)
*   **Hanada 縹** (`#7aaec8` - Triều Đỉnh): Xanh lam nhạt của mây trời hừng đông. Làm nền phụ hoặc các khối phụ ở chế độ Cozy Dark.
*   **Ai 藍** (`#1e4d7a` - Chàm): Xanh chàm đậm truyền thống. Dùng cho các nút hoặc trạng thái tĩnh mịch của giao diện đêm.
*   **Kon 紺** (`#0f2a45` - Kimono): Xanh đen đại dương đêm. Dùng làm màu nền chính của giao diện tối (Cozy Dark).

#### 🪵 Nhóm WABI (Wabi-Sabi - Vật Liệu & Đồ Gỗ Tự Nhiên)
*   **Sugi 杉** (`#8b5e3c` - Sugi Wood): Màu gỗ tuyết tùng Nhật Bản. Làm viền tủ sách Lofi hoặc các nét vẽ nhà cửa mộc mạc.
*   **Kogecha 焦茶** (`#4a2418` - Kogecha Tea): Màu nước trà đậm hoặc gỗ gụ. Dùng cho văn bản, nét vẽ outline, hoặc nét đổ bóng mộc của nội thất Lofi.
*   **Kohaku 琥珀** (`#b8860a` - Amber Gem): Màu hổ phách thô tự nhiên. Phối cho các chi tiết kim loại vintage hoặc khuy bấm cổ của đĩa nhạc.

### 1.5. Màu Thương Hiệu SSO (Third-Party Identity Colors)
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
