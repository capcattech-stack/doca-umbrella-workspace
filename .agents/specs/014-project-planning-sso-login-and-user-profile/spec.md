# Đặc Tả Tính Năng: Đăng nhập SSO và Trang Cá Nhân (User Profile)

> Feature ID: `014-project-planning-sso-login-and-user-profile`
> Created: `2026-07-06`
> Status: Active
> Source Prompt: triển khai chức năng login SSO cho tôi

## 1. Purpose

Triển khai tính năng đăng nhập bằng cơ chế SSO (Google và Zalo) thông qua Supabase Auth trên giao diện Client-side của trang Web Affiliate. Giúp biến trang web tĩnh thành một ứng dụng có tính cá nhân hóa cao hơn, cho phép người dùng (Sen) quản lý thông tin cơ bản của bản thân và lưu giữ hồ sơ thú cưng (Boss) trên một trang cá nhân (/profile).

---

## 2. User Stories

- [x] **Là một Sen (User)**, tôi muốn đăng nhập nhanh qua Google hoặc Zalo để tôi không cần nhớ thêm mật khẩu mới mà vẫn bảo mật.
- [x] **Là một Sen đã đăng nhập**, tôi muốn truy cập trang Profile cá nhân để tôi có thể xem thông tin của mình và quản lý thông tin các Boss (thú cưng) của tôi.
- [x] **Là một khách truy cập (Guest)**, tôi muốn thấy nút "Đăng nhập" trực quan để tôi biết mình có thể tham gia thành viên.
- [x] **Là một Sen đã đăng nhập**, tôi muốn trạng thái của mình được hiển thị rõ trên thanh điều hướng (Navbar) dưới dạng avatar và tên để tôi biết mình đang trong trạng thái đăng nhập.

---

## 3. Functional Requirements

- `FR-001` (Tích hợp Supabase Auth Client-side): Hệ thống MUST khởi tạo client Supabase trên trình duyệt bằng cách sử dụng các biến môi trường `PUBLIC_SUPABASE_URL` và `PUBLIC_SUPABASE_ANON_KEY`.
- `FR-002` (Nút bấm và Modal Đăng Nhập SSO): Hệ thống MUST cung cấp Modal Overlay đăng nhập chứa hai nút liên kết SSO: Google và Zalo.
- `FR-003` (Đồng bộ Trạng thái Navbar): Navbar MUST tự động cập nhật hiển thị dựa trên trạng thái auth của Supabase.
    - Chưa đăng nhập: Hiện nút "Đăng nhập" (`ph-light ph-sign-in`).
    - Đã đăng nhập: Hiện Avatar và tên kèm liên kết nhanh tới `/profile`.
- `FR-004` (Trang Profile cá nhân `/profile`):
    - Hệ thống MUST chỉ cho phép người dùng đã đăng nhập truy cập trang này. Khách chưa đăng nhập truy cập sẽ bị chuyển hướng (Redirect) về trang chủ `/`.
    - Trang này MUST hiển thị thông tin lấy từ Supabase Auth (Tên, Email, Avatar).
    - Trang này MUST hiển thị danh sách thú cưng ("Bosses") được lưu trữ trong `localStorage` hoặc metadata của user trong Supabase.
- `FR-005` (Chức năng Đăng Xuất): Hệ thống MUST cung cấp nút đăng xuất để xóa phiên làm việc (Session) của Supabase và chuyển hướng người dùng về trang chủ.

---

## 4. Non-Functional Requirements

- `NFR-001` (Thẩm mỹ & Giao diện): Giao diện Modal đăng nhập và trang Profile MUST tuân thủ nghiêm ngặt Hướng dẫn Thương hiệu ([BRAND_GUIDELINES.md](file:///Users/macinia/Capcat%20Project/docs/BRAND_GUIDELINES.md)), sử dụng màu trung tính ấm áp, font Inter và biểu tượng Phosphor với class `ph-light`.
- `NFR-002` (Bảo mật): Token truy cập (Access Token) và phiên đăng nhập MUST được quản lý tự động bởi SDK Supabase và lưu trữ an toàn trong LocalStorage/Cookie của trình duyệt.
- `NFR-003` (Hiệu năng): Việc khởi tạo auth Client-side không được gây nghẽn quá trình tải trang tĩnh (SSG) của Astro. Toàn bộ logic auth phải được tải bất đồng bộ (defer/client:only).

---

## 5. Acceptance Criteria

- `AC-001`: Cho nút đăng nhập Google, khi click, người dùng phải được chuyển hướng đến luồng xác thực của Google OAuth và sau đó quay lại trang web của chúng ta dưới trạng thái đã đăng nhập.
- `AC-002`: Cho trang cá nhân `/profile`, khi người dùng chưa đăng nhập cố gắng truy cập, hệ thống phải tự động chuyển hướng họ về trang chủ `/` trong vòng dưới `0.5s`.
- `AC-003`: Cho Navbar, khi đăng nhập thành công, nút "Đăng nhập" phải biến mất ngay lập tức và thay thế bằng User Capsule hiển thị đúng tên/avatar của người dùng.

---

## 6. Clarifications

Không có câu hỏi mở cần làm rõ. Người dùng đã phê duyệt kế hoạch triển khai sơ bộ và lựa chọn cổng đăng nhập mặc định (Google, Zalo) kết hợp Modal Overlay.

---

## 7. Constraints

- Chỉ sử dụng các thư viện Client-side (như `@supabase/supabase-js`) do dự án được xây dựng dưới dạng trang tĩnh Astro.
- Bắt buộc dùng icon Phosphor qua class `ph-light` làm nét vẽ mặc định.

---

## 8. Risks

| Rủi Ro | Mức Độ Ảnh Hưởng | Phương Án Giảm Thiểu |
| :--- | :--- | :--- |
| Trình duyệt chặn cookie/localStorage làm mất phiên đăng nhập | Trung bình | Supabase client sẽ tự động lưu dự phòng trên bộ nhớ phiên (session memory) và cảnh báo người dùng. |
| Xung đột thư viện khi chạy SSG build trên Node.js | Cao | Bao bọc toàn bộ mã nguồn sử dụng `@supabase/supabase-js` trong khối kiểm tra `if (typeof window !== 'undefined')` hoặc thẻ script Client-side của Astro. |
| Zalo SSO cấu hình phức tạp hoặc cần qua Zalo App ID | Trung bình | Triển khai mock-up/cấu hình chuyển hướng OAuth của Zalo tương tự Google, cấu hình thông qua bảng điều khiển của Supabase. |

---

## 9. Traceability

| Requirement | Plan Section | Tasks | Verification |
| :--- | :--- | :--- | :--- |
| `FR-001` | Cấu hình Client-side | TBD | Kiểm tra kết nối Supabase thành công |
| `FR-002` | Modal Đăng nhập | TBD | Trigger Modal hiện đúng thiết kế |
| `FR-003` | Navbar Capsule | TBD | Trạng thái hiển thị cập nhật theo Auth |
| `FR-004` | Trang /profile | TBD | Hiển thị thông tin cá nhân và Boss |
| `FR-005` | Nút Đăng xuất | TBD | Hủy phiên Supabase thành công |
