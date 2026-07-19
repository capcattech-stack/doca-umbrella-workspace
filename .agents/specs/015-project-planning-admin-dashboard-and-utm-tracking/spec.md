# Feature Specification: Project Planning - Admin Dashboard and UTM Tracking

> Feature ID: `015-project-planning-admin-dashboard-and-utm-tracking`
> Created: `2026-07-05`
> Status: Draft
> Source Prompt: dựng 1 trang admin.capcat.vn để xem và chỉnh sửa nội dung các câu hổi cũng như kết quả câu trả lời. link có gắn UTM dể biết nguồn traffic. VD lấy link có UTM fb post lên facebook, user vào trả lời sẽ ghi nhận được nguồn . trang này phải login băng SSO GG và phân quyền

## 1. Purpose

Xây dựng bảng điều khiển quản trị (Admin Dashboard) tại tên miền `admin.capcat.vn` (tích hợp trực tiếp dưới dạng route `/admin` trên web app chính) nhằm quản lý tập trung nội dung câu đố trắc nghiệm (Quizzes) và theo dõi kết quả chuyển đổi danh sách email (Leads). 
Tích hợp cơ chế thu thập dữ liệu nguồn chiến dịch (UTM Parameters) khi người dùng truy cập liên kết từ mạng xã hội. Bảo mật trang quản trị thông qua Google SSO (OAuth2) kết hợp phân quyền danh sách email được duyệt (RBAC).

## 2. User Stories

*   **US-001 (Theo dõi UTM):** Là một nhà tiếp thị, tôi muốn gắn các tham số UTM (như `utm_source=facebook`) vào liên kết chia sẻ câu đố để hệ thống tự động ghi nhận nguồn traffic này khi người dùng gửi email tham gia, giúp tôi đánh giá hiệu quả kênh tiếp thị.
*   **US-002 (Đăng nhập Google SSO):** Là một quản trị viên, tôi muốn đăng nhập vào trang quản trị bằng tài khoản Google doanh nghiệp (SSO) để truy cập nhanh chóng và an toàn mà không cần thêm tài khoản mật khẩu mới.
*   **US-003 (Quản lý Câu đố):** Là một quản trị viên, tôi muốn xem danh sách, chỉnh sửa nội dung câu hỏi, đáp án, lời giải thích của Tina, hoặc thêm câu hỏi mới trực tiếp trên giao diện quản trị.
*   **US-004 (Quản lý Lead):** Là một quản trị viên, tôi muốn xem danh sách các email thu thập được từ quiz kèm theo câu trả lời của họ và nguồn UTM để xuất dữ liệu chăm sóc khách hàng.
*   **US-005 (Phân quyền bảo mật):** Là chủ sở hữu dự án, tôi muốn hệ thống chặn quyền truy cập của các tài khoản Google lạ không thuộc danh sách quản trị viên được chỉ định trước (hoặc không thuộc tên miền `@capcat.vn`).

## 3. Functional Requirements

*   **FR-001 (Thu thập UTM phía Client):** Script client-side trên trang `/quiz/[slug]` phải tự động phân tích URL và trích xuất các tham số `utm_source`, `utm_medium`, `utm_campaign`.
*   **FR-002 (Cấu trúc dữ liệu Quiz Leads nâng cấp):** Bảng `public.quiz_leads` trong cơ sở dữ liệu Supabase được bổ sung 3 trường: `utm_source` (VARCHAR), `utm_medium` (VARCHAR), `utm_campaign` (VARCHAR) để ghi nhận nguồn traffic.
*   **FR-003 (Di chuyển nguồn dữ liệu Quizzes lên Supabase):** Chuyển đổi dữ liệu câu đố từ tệp JSON tĩnh sang bảng `public.quizzes` trong Supabase PostgreSQL để hỗ trợ đọc/ghi động từ trang Admin. Hàm `getStaticPaths()` của Astro sẽ truy vấn bảng này tại thời điểm build.
*   **FR-004 (Đăng nhập Google SSO):** Trang `/admin/login` tích hợp thư viện Supabase Auth để xác thực đăng nhập qua Google OAuth2.
*   **FR-005 (Cơ chế Phân quyền Quản trị viên):** 
    *   Tạo bảng `public.admins` chứa danh sách email admin hợp lệ.
    *   Sau khi đăng nhập qua Google, hệ thống kiểm tra email người dùng có khớp với bảng `public.admins` (hoặc kiểm tra đuôi email `@capcat.vn`). Nếu không hợp lệ, thực hiện đăng xuất và báo lỗi truy cập.
*   **FR-006 (Giao diện Quản trị /admin):**
    *   Trang danh sách câu hỏi: xem, thêm, sửa câu hỏi và cập nhật đường dẫn ảnh OG.
    *   Trang danh sách lead: hiển thị bảng chứa Email, Quiz đã làm, Đáp án đã chọn, Nguồn UTM, và Ngày giờ. Hỗ trợ nút Xuất file CSV (Export CSV).

## 4. Non-Functional Requirements

*   **NFR-001 (Bảo mật cơ sở dữ liệu):** Cấu hình Row Level Security (RLS) trên Supabase cho bảng `public.quizzes`:
    *   SELECT: Cho phép mọi người (Anon) đọc để hiển thị câu hỏi trên web.
    *   INSERT/UPDATE/DELETE: Chỉ cho phép người dùng đã xác thực (Authenticated) và có email nằm trong bảng `public.admins`.
*   **NFR-002 (Trải nghiệm Cozy):** Giao diện quản trị sạch sẽ, tối giản theo phong cách Muji (tông màu mây trắng sữa, xám ấm và viền mảnh cát ấm).

## 5. Acceptance Criteria

*   **AC-001:** Khi người dùng click vào link `http://localhost:4323/quiz/meo-hieu-tieng-nguoi-khong?utm_source=facebook&utm_medium=post`, điền email gửi câu trả lời, bản ghi trong bảng `quiz_leads` trên Supabase phải có trường `utm_source = 'facebook'` và `utm_medium = 'post'`.
*   **AC-002:** Khi truy cập `/admin`, nếu chưa đăng nhập, người dùng phải bị chuyển hướng về `/admin/login`.
*   **AC-003:** Khi một tài khoản Google lạ đăng nhập thành công qua SSO Google nhưng email không thuộc bảng `public.admins`, hệ thống phải hiển thị thông báo: *"Tài khoản này không có quyền truy cập trang quản trị"* và chặn chuyển hướng vào dashboard.
*   **AC-004:** Thay đổi nội dung câu hỏi trong giao diện admin và lưu lại, trang `/quiz/[slug]` tương ứng sẽ được cập nhật nội dung mới khi build lại hoặc tải động.

## 6. Clarifications

*   [NEEDS CLARIFICATION: Phương án deploy domain admin.capcat.vn?]
    *   *Quyết định:* Để triển khai tối giản và hiệu quả nhất, trang Admin sẽ được code dưới dạng một route tĩnh/SSR `/admin` trong cùng dự án Astro hiện tại. Sau đó, cấu hình DNS tại Cloudflare trỏ subdomain `admin.capcat.vn` về đường dẫn `/admin` của trang web (Sử dụng URL Rewrites ở CDN Cloudflare hoặc chỉ đơn giản là trỏ subdomain và xử lý routing).
*   [NEEDS CLARIFICATION: Cách quản lý danh sách email admin?]
    *   *Quyết định:* Tạo bảng `public.admins` chứa cột `email` (TEXT, UNIQUE). Mọi tài khoản muốn truy cập admin phải được thêm trước email vào bảng này.

## 7. Constraints

*   Sử dụng Supabase Auth Google Provider.
*   Tài nguyên icon: **Phosphor Icons** (`ph-light` mặc định).

## 8. Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Lộ API key hoặc cấu hình sai RLS | High | Cấu hình chính sách RLS cực kỳ chặt chẽ trên Supabase, chỉ cho phép vai trò admin cập nhật bảng `quizzes` và đọc toàn bộ bảng `quiz_leads`. |
| Google SSO Redirect URI lỗi | Medium | Đăng ký đầy đủ URL redirect ở Supabase Auth Settings cho cả localhost (`http://localhost:4323/admin`) và production (`https://capcat.vn/admin`). |

## 9. Traceability

| Requirement | Plan Section | Tasks | Verification |
| --- | --- | --- | --- |
| `FR-001` | UTM Capture | Viết JS đọc params | Điền UTM vào URL và kiểm tra console log |
| `FR-002` | Database | Nâng cấp bảng quiz_leads | Kiểm tra cấu trúc cột trên Supabase |
| `FR-003` | Database | Tạo bảng quizzes | Di chuyển dữ liệu mẫu từ JSON lên DB |
| `FR-004` | Auth | Tích hợp Google SSO | Đăng nhập thử bằng tài khoản Google |
| `FR-005` | Auth | Phân quyền RBAC | Đăng nhập bằng email ngoài danh sách admin để xác nhận bị chặn |
| `FR-006` | UI Admin | Viết các trang quản trị | Truy cập `/admin` thực hiện CRUD |
