# 🎛️ Quy Chuẩn Trạng Thái Thành Phần (UI Components State)

Tài liệu này chi tiết hóa hành vi tương tác, hiệu ứng chuyển động (transitions) và trạng thái hiển thị của các thành phần giao diện liên quan đến **Đăng nhập SSO** và **Trang Profile** trên trang Web Affiliate của DOCA.

---

## 1. Nút Đăng Nhập trên Header (Header Auth Button/Capsule)

Thành phần này nằm ở góc phải thanh điều hướng (Navbar). Có hai trạng thái lớn:

### 1.1. Trạng thái Chưa đăng nhập (Guest State)
Hiển thị một nút tối giản hoặc liên kết dạng nút bấm: "Đăng nhập" kèm icon `ph-light ph-sign-in`.
*   **Mặc định (Default)**: Nền trong suốt hoặc viền mảnh cực loãng, chữ màu Charcoal (`var(--cozy-text-obsidian)`), icon `ph-light ph-sign-in` đứng yên.
*   **Hover (Rê chuột)**:
    *   Nền chuyển sang màu kem nhạt (`var(--cozy-bg-beige)`).
    *   Biểu tượng icon dịch chuyển nhẹ sang phải `2px` (CSS: `transform: translateX(2px)`).
    *   Transition: `all 0.2s ease`.
*   **Active (Nhấp chuột)**: Nút thu nhỏ nhẹ (`transform: scale(0.96)`).

### 1.2. Trạng thái Đã đăng nhập (User Capsule State)
Hiển thị avatar tròn của người dùng và tên hiển thị rút gọn (ví dụ: "Sen Doca 🐾").
*   **Mặc định (Default)**: Một capsule bo góc hoàn toàn (`border-radius: 999px`) chứa ảnh đại diện (`32x32px`) và text bên cạnh. Có viền mảnh `var(--cozy-border-light)`.
*   **Hover (Rê chuột)**:
    *   Hiện bóng mờ nhẹ (`box-shadow: var(--cozy-shadow-hover)`).
    *   Avatar phóng to nhẹ `1.05` lần.
    *   Có thể hiển thị menu thả xuống (Dropdown Menu) chứa liên kết nhanh: "Trang cá nhân", "Thành viên gia đình", "Đăng xuất" (`ph-light ph-sign-out`).
*   **Dropdown Menu transition**: Trượt nhẹ từ trên xuống (Slide Down) kết hợp mờ dần (Fade In).
    *   CSS: `transform: translateY(10px) -> translateY(0); opacity: 0 -> 1; transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1)`.

---

## 2. Cửa Sổ Đăng Nhập (SSO Login Modal Overlay)

Khi người dùng nhấp "Đăng nhập", một cửa sổ Modal sẽ hiện lên giữa màn hình.

### 2.1. Lớp Nền Làm Mờ (Backdrop Overlay)
*   **Quy chuẩn**: Phủ một lớp màu đen loãng `rgba(21, 23, 15, 0.3)` kết hợp hiệu ứng làm mờ kính Nhật Bản (`backdrop-filter: blur(8px)`).
*   **Transition**: `opacity: 0 -> 1` trong `0.3s` sử dụng `ease-out`.

### 2.2. Hộp Đăng Nhập (Modal Card Container)
*   **Hiệu ứng xuất hiện**: Xuất hiện từ giữa màn hình, trượt nhẹ từ dưới lên và phóng to dần.
    *   CSS: `transform: scale(0.95) translateY(20px) -> scale(1) translateY(0); transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1)`.
*   **Nút Đóng (Close Button - X)**: Góc trên bên phải.
    *   Mặc định: Icon `ph-light ph-x` màu xám.
    *   Hover: Xoay nhẹ 90 độ (`transform: rotate(90deg)`), đổi màu sang `var(--cozy-green-matcha)`.

---

## 3. Các Nút Bấm SSO (SSO Buttons)

Các nút bấm đăng nhập bằng Google và Zalo.

### 3.1. Nút Google SSO
*   **Default**: Nền màu trắng thuần (`#FFFFFF`), viền `1px solid var(--cozy-border-light)`. Chữ đen Charcoal.
*   **Hover**:
    *   Nền chuyển sang màu kem Matcha loãng (`var(--cozy-bg-cream-warm)`).
    *   Bóng đổ nổi nhẹ (`box-shadow: 0 4px 12px rgba(21,23,15,0.06)`).
*   **Active / Press**: Nút thu nhỏ nhẹ (`transform: scale(0.98)`).

### 3.2. Nút Zalo SSO
*   **Default**: Nền xanh Zalo (`#0068FF`), chữ trắng tinh, viền không màu.
*   **Hover**:
    *   Độ sáng nút giảm nhẹ (`filter: brightness(0.95)`).
    *   Bóng đổ nổi nhẹ.
*   **Active / Press**: Nút thu nhỏ nhẹ (`transform: scale(0.98)`).

### 3.3. Trạng thái Đang kết nối (Loading State)
Khi nhấp vào một cổng SSO và chờ xác thực:
*   **Hiển thị**: Nút bị mờ đi (`opacity: 0.6`), con trỏ chuột đổi thành `not-allowed`.
*   **Hiệu ứng**: Text trên nút chuyển thành "Đang kết nối..." và xuất hiện một biểu tượng xoay tròn (Spinner) nét mảnh ở trước chữ.
    *   CSS: Phép quay liên tục `infinite linear` trong `1s`.

---

## 4. Trang Thông Tin Cá Nhân (Profile Page UI States)

Trang `/profile` được chia làm các khối thông tin gọn gàng.

### 4.1. Khối Thông Tin Cá Nhân (User Info Card)
*   **Default**: Thẻ lớn viền mảnh, nền trắng sữa `var(--cozy-bg-pure)`.
*   **Hover**: Nổi nhẹ lên (`transform: translateY(-2px); box-shadow: var(--cozy-shadow-hover)`).

### 4.2. Danh Sách Thú Cưng (My Boss Cards)
Các thẻ thú cưng nhỏ được xếp dạng lưới (Grid).
*   **Thẻ Pet có sẵn**: Hiển thị ảnh tròn của Boss, Tên, Tuổi, Giống loài. Rê chuột vào thẻ sẽ làm biểu tượng `ph-light ph-heart` chuyển sang `ph-fill ph-heart` màu hồng đào Sakura (`var(--cozy-pink-sakura)`).
*   **Nút "Thêm Boss" (Add Pet Card)**:
    *   Default: Thẻ nét đứt (`border: 2px dashed var(--cozy-border-light)`), nền trong suốt, giữa thẻ có biểu tượng `ph-light ph-plus`.
    *   Hover: Viền nét đứt chuyển sang màu Matcha (`var(--cozy-green-matcha)`), nền chuyển sang màu trắng sữa ấm áp. Icon dấu cộng nảy nhẹ lên (`transform: translateY(-4px)`).

### 4.3. Nút Đăng Xuất (Sign-out Button)
*   **Default**: Viền mảnh màu nhạt, chữ màu Charcoal, icon `ph-light ph-sign-out`.
*   **Hover**:
    *   Nền chuyển sang màu hồng đỏ nhạt (`var(--cozy-error)` / `#FFCDD2`).
    *   Chữ và icon đổi thành màu đỏ sẫm để cảnh báo hành động thoát tài khoản.
