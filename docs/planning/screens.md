# Screen Inventory and UI States - DOCA FM & SSO Integration

This document details the UI design, states, and accessibility details for the Cozy Audio Player and the SSO Login / Profile views.

## 1. Screen Inventory & Route Map

*   **Route:** `/` (Home Page)
    *   **Navbar Auth Control:** Placed at the right side of the navbar. Defaults to invisible skeleton state, fading into "Đăng nhập" button (Guest) or User Capsule (Authenticated).
    *   **Login Modal Overlay:** Displayed over the page when the "Đăng nhập" button is clicked. Features Google & Zalo SSO login options.
*   **Route:** `/profile` (User Profile Page) [NEW]
    *   **Accessibility:** Private route. Redirects unauthorized guests to `/`.
    *   **User Info Card:** Displays user avatar, full name, email, and sign-out button.
    *   **Pet Info Grid ("Thông tin Boss"):** Displays a grid of pet profile cards (name, age, species) with a dotted "Thêm Boss" card to trigger a pet addition form.

---

## 2. Widget & Interface UI States

### 2.1. Navbar Authentication Controls
*   **Pre-load / Skeleton State:** Auth container is empty, matching a width of `120px` to reserve space, with an opacity of `0`. This prevents layout shifts.
*   **Guest Mode:** Renders the "Đăng nhập" button with a `ph-light ph-sign-in` icon. Smoothly fades in (`opacity: 1`, transition `0.3s`).
*   **Authenticated Mode:** Renders the user avatar (circular, `32x32px`) and the display name capsule with a right-arrow icon pointing to `/profile`.

### 2.2. SSO Login Modal Overlay
*   **Default State:** Displays the cozy header "Đăng nhập góc nhỏ DOCA" with subtext, followed by stacked Google and Zalo login buttons.
*   **Loading State (SSO connecting):** When a login option is clicked, the button fades to `60%` opacity, displays a spinning paw icon (`ph-light ph-paw` rotating), and disables pointer events.
*   **Error State:** Displays a soft cherry-pink warning card (`var(--cozy-error)`) at the top of the modal if the authentication fails.

### 2.3. User Profile Page (`/profile`)
*   **Loading Profile State:** Displays a pulsing skeleton card for both the User details and Pet profiles list.
*   **Active Profiles View:** Renders:
    *   User metadata card.
    *   Pet cards: soft pure-white backgrounds with custom pet species badges, age tags, and a clickable Sakura-pink heart button (`ph-light ph-heart` transitions to `ph-fill` on hover/toggle).
    *   Add Pet Card: Dotted line empty-state card with a plus symbol. Clicking opens a simple inline form to input Pet Name, Species, and Age.

---

## 3. Keyboard, Accessibility & Responsive Constraints

*   **Touch Targets:** All interactive controls (SSO buttons, close buttons, pet card controls) must have a minimum interactive touch area of `44x44px`.
*   **Modal Overlay accessibility:**
    *   The overlay container must use `role="dialog"` and `aria-modal="true"`.
    *   Pressing the `Escape` key must automatically close the modal.
    *   Focus must trap inside the modal when open and return to the login button once closed.
*   **Responsive layouts:**
    *   On desktop: Profile page displays as a two-column grid (Left: User card, Right: Pet grid).
    *   On mobile: Profile page collapses into a single vertical layout (User card stacked above Pet list).

---

## 4. Đặc tả Giao diện Bảng Điều Khiển Admin & UTM

### 4.1. Giao diện trang đăng nhập quản trị `/admin/login`
*   **Thiết kế:** Muji-minimalism cực tối giản. Container căn giữa màn hình trên nền Cozy Paper (`#F7F4EF`).
*   **Thành phần:**
    *   Logo Capcat nét mảnh (Stroke 1.7px) kèm tên thương hiệu.
    *   Hộp chào mừng: "Bảng điều khiển quản trị Capcat".
    *   Nút "Đăng nhập bằng tài khoản Google" (Google SSO) định dạng lớn, bo góc tròn 8px, viền mảnh màu xám nhạt, logo Google 4 màu căn giữa.
    *   Trạng thái tải (Loading state): Hiển thị vòng xoay spinner mảnh khi đang kết nối OAuth.

### 4.2. Bố cục Dashboard Quản trị `/admin/quizzes` và `/admin/leads`
*   **Bố cục hai cột (Sidebar Layout):**
    *   **Sidebar trái (Cố định):** Rộng `240px`, chứa logo và danh mục quản trị:
        *   "Danh sách Câu đố" (icon: `ph-light ph-question`) - Link tới `/admin/quizzes`
        *   "Dữ liệu Chuyển đổi (Leads)" (icon: `ph-light ph-envelope-open`) - Link tới `/admin/leads`
        *   Nút "Trở lại trang chủ" và nút "Đăng xuất" đặt ở góc dưới cùng.
    *   **Main Content (Phải):** Chiếm trọn không gian còn lại. Nền trắng Cozy Cloud (`#FAF8F5`).

### 4.3. Bảng quản lý câu hỏi `/admin/quizzes`
*   **Thành phần chính:**
    *   Tiêu đề trang: "Quản lý câu hỏi trắc nghiệm".
    *   Nút Matcha Green "Thêm câu đố mới" (góc phải trên).
    *   Bảng dữ liệu (Table):
        *   Cột: Ảnh OG preview | Câu hỏi | Slug | Ngày tạo | Hành động (Sửa, Xóa).
        *   Hành động "Sửa" mở ra một Sidebar Drawer trượt từ cạnh phải màn hình (rộng 500px) chứa form điền: Câu hỏi, 4 đáp án (A, B, C, D), dropdown chọn đáp án đúng, Lời giải Tina, link ảnh OG, nút "Lưu thay đổi".
        *   Hành động "Xóa" hiển thị popup cảnh báo xác nhận.

### 4.4. Bảng danh sách email thu thập `/admin/leads`
*   **Thành phần chính:**
    *   Tiêu đề trang: "Dữ liệu Leads & UTM".
    *   Nút Matcha Green "Xuất tệp CSV" (góc phải trên) để tải về toàn bộ danh sách lead.
    *   Bảng dữ liệu:
        *   Cột: Email | Tên câu hỏi | Lựa chọn | UTM Source | UTM Medium | UTM Campaign | Ngày đăng ký.
        *   Phân trang (Pagination) ở góc dưới: Hiển thị 10 dòng mỗi trang, nút Next/Prev nét mảnh tinh tế.

---

## 5. Đặc tả Giao diện & Trạng thái UI Mới của Trang Chủ (Tái Cấu Trúc Layout)

### 5.1. Nhật ký lối sống (Lifestyle Blog Section)
*   **Trạng thái Mobile (Carousel):**
    *   Chiều rộng card cố định khoảng `280px` - `300px`, hỗ trợ trượt ngang với `scroll-snap-type: x mandatory`.
    *   Hiển thị tag phân mục màu nhạt ở góc trên bên trái, thời gian đọc ở góc trên bên phải.
*   **Trạng thái Desktop (Grid):**
    *   CSS Grid 3 cột, khoảng cách gap `24px`.
    *   Hiệu ứng Hover: Card sản phẩm Polaroid xoay nhẹ `transform: rotate(2deg)`, bóng đổ nhạt lan rộng, tiêu đề chính xuất hiện gạch chân Neon `#76C123` bằng nét vẽ tay SVG.

### 5.2. Kệ quà của mẹ (Product Curation Section)
*   **Thanh điều hướng Tab:** 
    *   Hiển thị 4 tab bo góc mềm mại: `[Sách của Tina]`, `[Pate của Latte]`, `[Đồ chơi của Muối]`, `[Góc ngủ của Pi's]`.
    *   Tab đang chọn có màu nền Charcoal `#1C1C1E` và chữ màu trắng tinh khiết (High contrast).
*   **Trạng thái Lưới sản phẩm:**
    *   *Mobile:* 2 cột (`grid-cols-2`). Ảnh sản phẩm hiển thị dạng Polaroid vuông. Nút mua hàng thu gọn thành icon xe đẩy tròn đen `32x32px` đặt ở góc dưới cùng bên phải.
    *   *Desktop:* 4 hoặc 5 cột.
*   **Trạng thái Polaroid Detail View (Bottom Sheet / Modal):**
    *   *Mobile:* Bottom Sheet trượt lên từ đáy màn hình, chiếm `65%` chiều cao màn hình, nền xám Oatmeal `#F8F9FA`. Có tay kéo (drag handle) mỏng ở trên.
    *   *Desktop:* Modal Polaroid cố định ở trung tâm màn hình, bao quanh bởi một lớp phủ mờ (backdrop-filter: blur(8px)). Trình diễn ảnh sản phẩm Polaroid khổ lớn bên trái, mô tả chi tiết và nút "Mua sản phẩm" màu xanh Neon bên phải.

### 5.3. Hộp thư nhỏ Namiya (Interactive Mailbox)
*   **Trạng thái Mặc định (Collapsed):**
    *   Chỉ hiển thị hình ảnh minh họa hòm thư gỗ và một nút bấm duy nhất `[Viết thư gửi gắm tâm sự ✉]`. 
*   **Trạng thái Nhập liệu (Expanded Form):**
    *   Khi click nút, vùng form trượt mở ra mượt mà sử dụng `transition: max-height 0.4s ease, opacity 0.4s ease`.
    *   Ô nhập Email chứa biểu tượng Google SSO nhanh hình tròn ở mép phải. Sau khi click xác thực, ô Email chuyển sang chế độ read-only, hiển thị một tick xanh lục tròn "Đã xác thực" (`ph-fill ph-check-circle`).
*   **Trạng thái Gửi thành công (Success Animation):**
    *   Form ẩn đi nhanh chóng, thay thế bằng hoạt ảnh phong thư bay vào hòm gỗ.
    *   Phát âm thanh chuông gió nhẹ nhàng, sau đó hiện thông báo: *"Thư của bạn đã được bỏ vào hòm gỗ Namiya. Tina sẽ gửi phản hồi sớm cho bạn qua hòm thư nhé! 🐾"*.

---

## 6. Đặc tả Màn hình Ví Xu & Thanh toán (User Facing)

### 6.1. Khối Ví Xu tại Trang Hồ sơ cá nhân (`/profile`)
*   **Vị trí:** Đặt bên trong thẻ `profile-card` (nằm phía trên khối quản trị Kiosk).
*   **Trạng thái giao diện:**
    *   *Số dư:* Hiển thị số dư xu của người dùng hiện tại (ví dụ: `120 Xu`), đi kèm icon `ph-light ph-coins`.
    *   *Nút "Nạp thêm xu":* Sử dụng class `.cozy-btn`, màu xanh Matcha Forest, dẫn tới trang `/profile/wallet`.
    *   *Nút "Lịch sử":* Nút viền mảnh (outline), icon `ph-light ph-clock-counter-clockwise` mở Drawer lịch sử giao dịch.

### 6.2. Trang chọn gói nạp xu (`/profile/wallet`)
*   **Thiết kế:** Nền màu Cozy Paper `#F7F4EF`.
*   **Bố cục danh sách gói nạp (Grid):**
    *   Hiển thị danh sách các gói nạp xu (Ví dụ: 10,000đ = 100 Xu, 50,000đ = 500 Xu + tặng 50 Xu).
    *   Các thẻ gói nạp có hiệu ứng hover xoay nhẹ polaroid và viền xanh Matcha khi click chọn.
*   **Giao diện Modal Thanh toán (Desktop):**
    *   Hiển thị mã QR động do ZaloPay/MoMo sinh ra kèm theo số tiền và hướng dẫn quét mã.
    *   Hiển thị một đồng hồ đếm ngược thời hạn hiệu lực của mã QR (15 phút).
    *   Có biểu tượng loading nhấp nháy mảnh biểu thị hệ thống đang kiểm tra trạng thái thanh toán tự động (auto-polling).
*   **Giao diện chuyển hướng thanh toán (Mobile):**
    *   Không hiện mã QR, hiển thị nút bấm nổi bật: `[Mở ứng dụng ZaloPay để thanh toán]`. Khi click sẽ kích hoạt deep link mở thẳng ZaloPay/MoMo trên máy điện thoại của user.

### 6.3. Bảng Lịch sử giao dịch ví xu (Transaction History Drawer)
*   Hiển thị dưới dạng một Drawer trượt từ cạnh phải màn hình (hoặc Bottom Sheet trên Mobile).
*   Danh sách lịch sử hiển thị rõ:
    *   *Giao dịch cộng (Nạp tiền, sự kiện):* Số xu màu xanh Matcha kèm dấu `+` (ví dụ: `+100 Xu`).
    *   *Giao dịch trừ (Mở nhạc, mua đồ):* Số xu màu xám Charcoal kèm dấu `-` (ví dụ: `-50 Xu`).
    *   *Nội dung và Thời gian:* Rõ ràng, dễ đọc.

---

## 7. Đặc tả Giao diện Quản trị & Đối soát Billing (Admin & Accountant Portal)

Các trang quản lý billing được đặt bên trong bảng điều khiển `/admin` và được bọc bởi `AdminLayout.astro`:

### 7.1. Trang Đối soát Giao dịch `/admin/billing/transactions`
*   **Thành phần:**
    *   Bảng nhật ký giao dịch chứa: Mã hóa đơn | Người dùng (Email) | Cổng thanh toán | Số tiền (VND) | Số xu đổi | Trạng thái (Thành công / Chờ thanh toán / Thất bại) | Ngày tạo.
    *   Bộ lọc nhanh theo Trạng thái giao dịch và Cổng thanh toán (MoMo, ZaloPay, PayOS).
    *   Nút "Cộng xu thủ công" (dành riêng cho Super Admin): Mở form điền Email người nhận, số xu, lý do cộng và mật khẩu phê duyệt.

### 7.2. Trang Cấu hình Gói nạp `/admin/billing/packages`
*   **Thành phần:**
    *   Danh sách các gói nạp hiện có trên website dưới dạng thẻ danh sách.
    *   Nút bật/tắt (Toggle) trạng thái hiển thị của gói nạp trên client.
    *   Form chỉnh sửa giá tiền VND, số lượng xu nhận được và tỷ lệ khuyến mãi đi kèm.

### 7.3. Trang Báo cáo Doanh thu cho Kế toán `/admin/billing/report`
*   **Thành phần:**
    *   Biểu đồ doanh thu dạng cột (Doanh thu VND nạp qua MoMo, ZaloPay).
    *   Báo cáo ba chỉ số chính: Tổng dòng tiền nạp (VND), Tổng số xu phát hành, Tổng số xu tiêu dùng trong hệ thống.
    *   Nút "Xuất báo cáo đối soát CSV/Excel" theo khoảng ngày đã chọn.
    *   Khu vực Upload file CSV đối soát từ MoMo/ZaloPay Merchant để chạy thuật toán so khớp chéo tự động.




---

# Screen Inventory & UI States - Doca Coin Hub

## 1. User-Facing Screens (Capcat Web & Mobile)

*   **View:** `/profile` (Profile Wallet Box)
    *   **State Authenticated:** Displays current coin balance with Phosphor icon `ph-light ph-coins` (e.g. "150 Cá").
    *   **Action Button (Primary):** "Nạp thêm Cá" (Matcha Green) -> navigates to `/profile/wallet`.
    *   **Action Button (Secondary):** "Lịch sử giao dịch" -> opens transaction drawer.

*   **View:** `/profile/wallet` (Coin Package Selector & Checkout Modal)
    *   **Package Grid:** Responsive grid (3 columns Desktop, 2 columns Mobile) displaying package cards with bonus tags.
    *   **Desktop Checkout Modal:** Cozy modal overlay displaying dynamic ZaloPay / Mock QR code with polling/socket auto-completion.
    *   **Mobile Checkout:** Triggers direct app-to-app ZaloPay deep link.

*   **View:** `/profile/history` (Transaction History Drawer)
    *   **List Items:** Infinite scroll list showing `+` (Matcha green) for recharges and `-` (Charcoal) for spent coins, with timestamps and transaction descriptions.

## 2. Admin Management Screens (`doca-admin-web`)

*   **Route:** `/admin/payment/orders` (Transaction & Order Audit)
    *   **Filters:** Date range, Gateway (`ZALOPAY` | `MOCK`), Status (`PENDING`, `SUCCESS`, `FAILED`), Email/Phone search.
    *   **Action:** "Tra cứu ZaloPay" button to query gateway status API for pending/stuck transactions.
    *   **Action:** "Bù xu thủ công" button with required audit reason modal.

*   **Route:** `/admin/payment/packages` (Package & Promo Management)
    *   **Actions:** Create/Edit package, set VNĐ pricing, coin amounts, bonus percentage, and toggle active status.
