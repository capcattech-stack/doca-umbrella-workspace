# Implementation Task List - DOCA Live Curation & SSO User Integration

This list details the work steps to implement the live synchronized FM player, coordinates weather integration, and the client-side SSO authentication & profile page.

## Task Breakdown

### TSK-021: Define 3 Daily Playlists & Sync Script
*   **ID:** `TSK-021`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/scripts/sync_music.py`
*   **Dependencies:** None
*   **Description:** Update `sync_music.py` to organize curated tracks, add stories and upload config to Supabase Storage.
*   **Verification Method:** Run script and verify output.

---

### TSK-022: Implement Shared FM Sync & Host Tina with Weather API
*   **ID:** `TSK-022`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Completed`
*   **Parallel-Safe:** `Yes` [P]
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`
*   **Dependencies:** `TSK-021`
*   **Description:** Implement client-side playhead calculation, load weather, and style Host Tina greeting cards.
*   **Verification Method:** Verify slot loading and greeting text output.

---

### TSK-023: Execute FM E2E Verification
*   **ID:** `TSK-023`
*   **Owner:** `ada-qa-agent`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Dependencies:** `TSK-021`, `TSK-022`
*   **Description:** Run integration checks and compile tests.
*   **Verification Method:** Build test pass.

---

### TSK-024: Install Supabase JS SDK & Bootstrap Auth Client
*   **ID:** `TSK-024`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/package.json`, `doca-affiliate-web/src/lib/supabaseClient.ts` [NEW]
*   **Dependencies:** None
*   **Description:** Install `@supabase/supabase-js` package. Create a helper file `supabaseClient.ts` to initialize the Supabase client browser-side using `PUBLIC_SUPABASE_URL` and `PUBLIC_SUPABASE_ANON_KEY`. Protect the initialization against execution in Node environments (SSG build).
*   **Verification Method:**
    *   Verify `@supabase/supabase-js` is added to package.json.
    *   Ensure Astro builds successfully without build-time initialization errors.

---

### TSK-025: Implement SSO Login Modal Overlay Component
*   **ID:** `TSK-025`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `Yes` [P]
*   **Write Scope:** `doca-affiliate-web/src/components/LoginModal.astro` [NEW]
*   **Dependencies:** `TSK-024`
*   **Description:** Build the Muji-minimalist Login Modal component containing Google and Zalo login buttons. Apply backdrop blur and standard animations defined in [UI_COMPONENTS_STATE.md](file:///Users/macinia/Capcat%20Project/docs/UI_COMPONENTS_STATE.md).
*   **Verification Method:**
    *   Trigger modal and verify typography, colors, and layout in the browser.

---

### TSK-026: Integrate Client-Side Auth State in Navigation Bars
*   **ID:** `TSK-026`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `Yes` [P]
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`, `doca-affiliate-web/src/pages/family.astro`, `doca-affiliate-web/src/pages/product.astro`, `doca-affiliate-web/src/pages/about.astro`
*   **Dependencies:** `TSK-025`
*   **Description:** Insert the Login Modal component and update headers to handle Supabase Auth state. Replace the hardcoded "Đăng nhập" buttons with user capsules showing user names and avatars when authenticated. Attach click actions to trigger the Modal or route to `/profile`. Handle the "Đăng xuất" (logout) function.
*   **Verification Method:**
    *   Perform login via mock SSO/Supabase dashboard and verify Navbar state capsule update.
    *   Test logout redirect.

---

### TSK-027: Create Private User Profile Page (`/profile`)
*   **ID:** `TSK-027`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/src/pages/profile.astro` [NEW]
*   **Dependencies:** `TSK-026`
*   **Description:** Create a new page `profile.astro` accessible at `/profile`. Ensure it redirects guests to `/` on load. Display user profile data (name, email, photo) from Supabase session. Render a list of pets (Bosses) stored in `localStorage` or `user_metadata`, and implement options to add/delete pet cards.
*   **Verification Method:**
    *   Visit `/profile` as guest and verify redirection.
    *   Visit as logged-in user and verify name display and pet card interactions.

---

### TSK-028: Audit & E2E Validation
*   **ID:** `TSK-028`
*   **Owner:** `ada-qa-agent`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Dependencies:** `TSK-024`, `TSK-025`, `TSK-026`, `TSK-027`
*   **Description:** Check the complete authentication pipeline, inspect Zalo/Google configurations, run production builds to ensure zero TypeScript errors, and verify the design tokens are strictly applied.
*   **Verification Method:**
    *   Run `npm run build` inside `doca-affiliate-web`.

---

### TSK-029: Cấu hình Cơ sở dữ liệu và RLS Policies
*   **ID:** `TSK-029`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/scripts/create_tables.sql` [NEW]
*   **Dependencies:** None
*   **Description:** Tạo các bảng `quizzes`, `quiz_leads`, `admins` trên cơ sở dữ liệu Supabase. Bật Row Level Security (RLS) cho tất cả các bảng. Định nghĩa các chính sách cho phép Admin đọc/ghi và người dùng được phép chèn bản ghi.
*   **Verification Method:** Chạy các lệnh SQL trên Console của Supabase và kiểm tra trạng thái bảng cùng chính sách RLS.

---

### TSK-030: Thiết lập Google SSO trên Supabase
*   **ID:** `TSK-030`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Completed`
*   **Parallel-Safe:** `Yes`
*   **Write Scope:** Cấu hình Console Supabase & Google Cloud Console
*   **Dependencies:** `TSK-029`
*   **Description:** Tạo ứng dụng OAuth2 trên Google Cloud Console, lấy Client ID và Client Secret. Cấu hình các thông số này trong phần Authentication Providers của Supabase và thiết lập Redirect URIs trỏ về tên miền trang quản trị.
*   **Verification Method:** Kiểm tra tính năng đăng nhập Google trả về token thành công.

---

### TSK-031: Trích xuất UTM và Đăng ký Leads
*   **ID:** `TSK-031`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Completed`
*   **Parallel-Safe:** `Yes`
*   **Write Scope:** `doca-affiliate-web/src/pages/quiz/[slug].astro`
*   **Dependencies:** `TSK-029`
*   **Description:** Viết client-side script phân tích URL Search Params để trích xuất `utm_source`, `utm_medium`, `utm_campaign` khi tải trang câu đố. Lưu trữ tạm thời và gửi các tham số này kèm email đăng ký của người dùng lên API Supabase.
*   **Verification Method:** Truy cập link chứa tham số UTM, nhập email trả lời và kiểm tra bảng `quiz_leads` trong Supabase xem dữ liệu UTM được lưu chính xác không.

---

### TSK-032: Phát triển Trang đăng nhập quản trị `/admin/login`
*   **ID:** `TSK-032`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Completed`
*   **Parallel-Safe:** `Yes`
*   **Write Scope:** `doca-affiliate-web/src/pages/admin/login.astro` [NEW]
*   **Dependencies:** `TSK-030`
*   **Description:** Thiết kế giao diện trang đăng nhập quản trị theo đúng phong cách tối giản Muji. Tích hợp nút kích hoạt Google SSO của Supabase. Thêm hiệu ứng loading spinner khi xử lý callback.
*   **Verification Method:** Truy cập `/admin/login`, click nút đăng nhập và kiểm tra xem có chuyển hướng sang trang SSO Google hay không.

---

### TSK-033: Bảng điều khiển quản trị Quizzes & Leads
*   **ID:** `TSK-033`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/src/pages/admin/quizzes.astro` [NEW], `doca-affiliate-web/src/pages/admin/leads.astro` [NEW]
*   **Dependencies:** `TSK-032`
*   **Description:** Xây dựng dashboard giao diện 2 cột với sidebar điều hướng. Trang `/admin/quizzes` hiển thị bảng danh sách câu đố, hỗ trợ form Drawer trượt để sửa hoặc thêm câu đố. Trang `/admin/leads` hiển thị danh sách email leads kèm phân trang và nút tải CSV. Bảo vệ các trang này bằng client-side auth filter so khớp email với bảng `admins`.
*   **Verification Method:** Đăng nhập bằng tài khoản không có quyền admin và verify bị từ chối truy cập. Đăng nhập bằng admin hợp lệ và verify các chức năng của bảng hoạt động đúng.

---

### TSK-034: Tự động hóa Webhook & Build
*   **ID:** `TSK-034`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Completed`
*   **Parallel-Safe:** `Yes`
*   **Write Scope:** Cấu hình Webhook
*   **Dependencies:** `TSK-033`
*   **Description:** Cấu hình Netlify/Vercel build webhook. Viết hàm gọi API gọi webhook này khi Admin nhấn lưu thay đổi nội dung câu hỏi trên trang dashboard nhằm kích hoạt lại build tĩnh cho trang web.
*   **Verification Method:** Chỉnh sửa một câu hỏi trên Admin, lưu lại và kiểm tra xem Netlify/Vercel build pipeline có tự động chạy hay không.

---

### TSK-035: Kiểm thử và Nghiệm thu E2E
*   **ID:** `TSK-035`
*   **Owner:** `ada-qa-agent`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Dependencies:** `TSK-031`, `TSK-033`, `TSK-034`
*   **Description:** Chạy toàn bộ các ca kiểm thử E2E về luồng UTM, đăng nhập SSO phân quyền, quản trị và build webhook. Biên dịch thử dự án để kiểm tra lỗi TypeScript.
*   **Verification Method:** Đảm bảo toàn bộ hệ thống hoạt động ổn định và build thành công không lỗi.

---

### TSK-036: Weather-based Curation & Japanese Vibe Stories (DEV)
*   **ID:** `TSK-036`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/scripts/sync_drive_to_r2.py`
*   **Dependencies:** None
*   **Description:** Cải tiến script `sync_drive_to_r2.py` để tích hợp API Open-Meteo dự báo thời tiết ngày mai, phân loại nhạc dựa trên tên thư mục chứa nhạc lưu trên Cloudflare R2, và sử dụng Gemini API để sinh truyện ngắn mang phong cách Nhật Bản lồng ghép tên các bài hát đang phát.
*   **Verification Method:** Chạy thử nghiệm và kiểm tra xem `playlist.json` được cập nhật đè phần ngày mai thành công.

---

### TSK-037: Tái cấu trúc Layout và Thứ tự các Phân vùng trên Trang Chủ
*   **ID:** `TSK-037`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`
*   **Dependencies:** None
*   **Description:** Sắp xếp lại thứ tự Render của các Section trong file `index.astro` theo trình tự: Hero & DOCA FM -> Blog (Nhật ký lối sống) -> Namiya Mailbox -> Product Curation (Kệ quà của mẹ) -> Kiosk Banner -> Footer.
*   **Verification Method:** Chạy server dev `npm run dev` và kiểm tra trực quan thứ tự các section trên trình duyệt.

---

### TSK-038: Tái thiết kế Section Nhật ký lối sống (Blog)
*   **ID:** `TSK-038`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `Yes`
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`, `doca-affiliate-web/src/styles/`
*   **Dependencies:** `TSK-037`
*   **Description:** 
    *   *Mobile:* Triển khai Horizontal Swipe Carousel sử dụng CSS flexbox `overflow-x-scroll` và snap points. Hiển thị 1 slide trọn vẹn và 15% slide kế tiếp.
    *   *Desktop:* Layout CSS Grid 3 cột. Thêm CSS transition/transform làm ảnh Polaroid xoay nhẹ 2-3 độ khi hover và tiêu đề gạch chân Neon `#76C123`.
*   **Verification Method:** Vuốt thử carousel trên thiết bị giả lập di động (Chrome DevTools Mobile mode) và hover các card blog trên Desktop.

---

### TSK-039: Triển khai Hệ thống Tabs cho Kệ quà của mẹ
*   **ID:** `TSK-039`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`, `doca-affiliate-web/src/components/ProductCard.astro`
*   **Dependencies:** `TSK-037`
*   **Description:** Tạo thanh Tab chọn ngang: Tina (sách), Latte (thức ăn), Muối (đồ chơi), Pi's (góc ngủ). Viết Javascript client-side lọc danh sách sản phẩm hiển thị dựa trên tab được kích hoạt. Lấy dữ liệu sản phẩm từ biến Supabase toàn cục.
*   **Verification Method:** Click vào các Tab khác nhau và verify danh sách sản phẩm thay đổi ngay lập tức không bị load lại trang.

---

### TSK-040: Tái thiết kế Lưới sản phẩm & Polaroid Bottom Sheet
*   **ID:** `TSK-040`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `Yes`
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`, `doca-affiliate-web/src/components/ProductCard.astro`, `doca-affiliate-web/src/components/PolaroidSheet.astro`
*   **Dependencies:** `TSK-039`
*   **Description:**
    *   *Mobile Card:* Hiển thị grid 2 cột. Thay thế nút `SHOPEE` văn bản dài bằng icon xe mua sắm Phosphor (`ph-light ph-shopping-cart`) tròn nhỏ màu đen.
    *   *Desktop Grid:* Hiển thị grid 4 hoặc 5 cột.
    *   *Detail View:* Khi click sản phẩm, trượt lên Bottom Sheet (Mobile) hoặc mở Modal Polaroid căn giữa màn hình với phông nền blur (Desktop).
*   **Verification Method:** Bấm chọn sản phẩm trên cả mobile và desktop, kiểm tra giao diện Polaroid Sheet và nút xe đẩy mua sắm.

---

### TSK-041: Tái thiết kế Hòm thư Namiya tương tác
*   **ID:** `TSK-041`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `Yes`
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`, `doca-affiliate-web/src/components/NamiyaMailbox.astro`
*   **Dependencies:** `TSK-037`
*   **Description:** Thay thế form tĩnh bằng hình vẽ hòm thư gỗ Nhật và nút bấm. Khi click nút, dùng CSS transition mở form mượt mà. Tích hợp nút Google điền nhanh email cạnh input. Ràng buộc logic disabled nút gửi cho đến khi input hợp lệ.
*   **Verification Method:** Click mở form, gõ nội dung, click Google SSO verify email điền tự động, verify nút gửi chuyển trạng thái active.

---

### TSK-042: Kiểm thử E2E & Tối ưu hóa CLS/A11y
*   **ID:** `TSK-042`
*   **Owner:** `ada-qa-agent`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Dependencies:** `TSK-038`, `TSK-040`, `TSK-041`
*   **Description:** Đo lường chỉ số CLS (Cumulative Layout Shift) của trang chủ khi tương tác tabs và trượt mở form Namiya. Đảm bảo toàn bộ icon và nút bấm thu gọn có thẻ `aria-label` đầy đủ cho người khiếm thị.
*   **Verification Method:** Chạy Audit Lighthouse trên Chrome và verify CLS < 0.1, chỉ số Accessibility > 90.

