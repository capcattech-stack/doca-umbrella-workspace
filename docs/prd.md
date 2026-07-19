# Product Requirements Document (PRD) - DOCA FM & SSO User Integration

## 1. Product Goal
*   **DOCA FM Live Sync**: Implement a synchronized, shared ambient FM radio experience for pet owners (Sen) and pets (Boss). All visitors hear the exact same track at the exact same playhead position at any given moment. Playlists are rotated across three daily slots (Morning, Afternoon, Evening) with dynamic introductions by Tina the Cat.
*   **SSO Login & User Profile**: Implement a client-side Single Sign-On (SSO) authentication system (supporting Google and Zalo OAuth) using Supabase Auth, along with a dedicated User Profile page (`/profile`) allowing users to see their personal information and manage their pets (Bosses) details.

## 2. Problem Statement
*   **DOCA FM**: A standard music player playing static playlists lacks the communal feel of a real-time radio broadcast.
*   **SSO & User Profile**: Visitors need a way to log in seamlessly without remembering passwords to access personal features like saving pet info. We need to implement this on a static Astro website (SSG) securely without adding server-side build blockages.

## 3. User Stories
### 3.1. DOCA FM
*   **As a User (Sen):** I want to know that other pet owners and pets are listening to the exact same melody as me right now, creating a sense of shared calm.
*   **As a User (Sen):** I want to read Tina's daily radio host introductions that mention the real-time weather in HCMC, so that the radio feels live, cozy, and interactive.
*   **As a User (Sen):** I want to read Japanese-novel-style titled stories explaining the playlist curation to help me relax.

### 3.2. SSO Login & User Profile
*   **As a User (Sen):** I want to log in using my Google or Zalo account so that I don't need to sign up for a new account.
*   **As a User (Sen):** I want my authenticated state to show clearly on the Navbar via an avatar and my name, replacing the generic "Đăng nhập" button.
*   **As a User (Sen):** I want to access a private `/profile` page to view my personal details and add my pets (Bosses) profiles.

## 4. Functional Requirements
### 4.1. DOCA FM Live Sync
*   **`FR-001` (Synchronized FM Playback)**: The player MUST synchronize playback using the server/unix time modulo the active playlist's total duration.
*   **`FR-002` (Single-Control Player)**: The player MUST disable track-level skipping, pausing for all users, or track selection. The dropdown playlist acts strictly as a schedule.
*   **`FR-003` (3 Daily Playlist Slots)**: The system MUST automatically load the correct playlist based on local time:
    *   Morning (Sáng): 06:00:00 - 11:59:59
    *   Afternoon (Chiều): 12:00:00 - 17:59:59
    *   Evening (Tối): 18:00:00 - 05:59:59
*   **`FR-004` (Weather Caching & Integration)**: The browser MUST fetch the current weather description for Bình Hưng, HCMC (coordinates `10.7222, 106.6783`) from Open-Meteo API.
*   **`FR-005` (Tina the Cat Host)**: The host card MUST feature Tina and render her intro card with dynamic weather-aware greeting scripts.
*   **`FR-006` (Japanese-Novel Stories)**: Each playlist configuration MUST include a `story_title` (in Japanese novel translation style) and a text `story` detailing why these tracks were selected.

### 4.2. SSO Login & User Profile
*   **`FR-007` (Supabase Client Integration)**: The system MUST integrate the Supabase JS client SDK client-side to manage sessions, configuration, and OAuth tokens.
*   **`FR-008` (SSO Providers Support)**: The system MUST offer Google and Zalo OAuth logins inside a modal overlay triggered by clicking the "Đăng nhập" button.
*   **`FR-009` (Dynamic Navigation Bar)**: The Navbar MUST dynamically update its right-hand controls based on auth state. Authenticated state shows user avatar/name capsule linking to `/profile`. Unauthenticated shows "Đăng nhập".
*   **`FR-010` (Private Profile Route)**: Access to `/profile` MUST be restricted to authenticated users. Guests trying to access it MUST be redirected to `/` within `0.5s`.
*   **`FR-011` (Pet Management)**: The profile page MUST allow users to view, add, and save pet profiles (name, species, age) to `localStorage` or `user_metadata` in Supabase.
*   **`FR-012` (Logout Action)**: Clicking "Đăng xuất" MUST destroy the active Supabase session and redirect the user back to the home page.

## 5. Non-Functional Requirements
*   **`NFR-001` (Aesthetics)**: The UI components must use cozy Muji minimalism styles, soft glassmorphism, watercolor palettes, and Phosphor icons (`ph-light` as default).
*   **`NFR-002` (Robustness)**: External API requests (weather, auth checks) must execute asynchronously and fail gracefully.
*   **`NFR-003` (Build Safety)**: All client-side dependencies (including `@supabase/supabase-js`) MUST be safely isolated to prevent build-time SSG compile failures in Astro.
*   **`NFR-004` (UX Transitions)**: Auth state changes must fade in smoothly to prevent jarring page layout flashes.

## 6. Scope Boundaries
*   **In Scope:**
    *   Dynamic live FM playhead synchronization.
    *   Morning, Afternoon, Evening playlists.
    *   Client-side weather fetch fallback.
    *   Client-side Supabase authentication with Google and Zalo SSO.
    *   Static `/profile` layout with localStorage pet profiles.
*   **Out of Scope:**
    *   Database-backed global pet sharing community feed.
    *   Real-time chat or voice stream broadcasts.

## 7. Acceptance Criteria
*   **`AC-001`**: Given a user opens the page, when they play music, then the audio plays from the calculated synchronized position.
*   **`AC-002`**: Given the user opens the track dropdown, when they click a track item, then the click is ignored (no track selection).
*   **`AC-003`**: Given the host card is loaded, when the weather API resolves, then the text includes the current weather condition of Bình Hưng, TP.HCM.
*   **`AC-004`**: Given a guest clicks "Đăng nhập" and selects Google, they are redirected to Google's authentication page, and redirected back as a logged-in user.
*   **`AC-005`**: Given a guest navigates to `/profile`, they are immediately redirected to the home page `/`.
*   **`AC-006`**: Given a logged-in user clicks "Đăng xuất", their session is cleared and the Navbar reverts to showing the "Đăng nhập" button.

## 8. Open Questions & Accepted Risks
*   **Client-side session dependency**: Since this website is static, session validation is handled on the client. We accept the small delay in establishing auth state when page loads, mitigated by skeleton loading states to prevent layout shifts.

---

# Product Requirement Document (PRD): Bảng Điều Khiển Quản Trị & Theo Dõi Nguồn Tiếp Thị (UTM)

## 1. Mục tiêu sản phẩm (Product Goal)
Xây dựng hệ thống quản trị nội dung câu hỏi trắc nghiệm (Quizzes) và theo dõi kết quả chuyển đổi email người dùng (Leads) kèm theo nguồn tiếp thị (UTM parameters). Bảo mật hệ thống thông qua Google SSO (OAuth2) và phân quyền quản trị dựa trên cơ sở dữ liệu.

## 2. Người dùng mục tiêu (Target Users)
*   **Quản trị viên (Admin/Creator):** Người sáng tạo câu hỏi, chỉnh sửa bài học của Tina và theo dõi dữ liệu email của người tham gia.
*   **Nhà tiếp thị (Marketers):** Tạo và theo dõi liên kết tiếp thị từ mạng xã hội (Facebook, Group, YouTube, Reels) để đo lường tỷ lệ chuyển đổi nguồn.

## 3. Tuyên bố bài toán (Problem Statement)
Ở Phase 1, các câu hỏi trắc nghiệm được lưu tĩnh trong file JSON và email ghi nhận chưa thể phân loại nguồn lưu lượng (traffic source). Điều này gây cản trước cho việc:
1.  Người dùng không thể tự thay đổi hoặc thêm câu hỏi mới nếu không phải là lập trình viên (không thể sửa file JSON trực tiếp trên server tĩnh).
2.  Bộ phận marketing không biết lead email đến từ bài đăng cụ thể nào trên Facebook, Group hay từ kênh YouTube nào để đo lường hiệu quả (ROI).
3.  Thiếu một trang quản trị bảo mật để duyệt danh sách email đã đăng ký.

Bảng điều khiển `/admin` và luồng trích xuất UTM sẽ giải quyết trọn vẹn các thách thức này.

## 4. Câu chuyện người dùng (User Stories)
*   `US-001 (Theo dõi UTM)`: Là một nhà tiếp thị, tôi muốn chia sẻ liên kết trắc nghiệm có kèm tham số UTM (ví dụ `utm_source=fb_page`), để hệ thống lưu trữ chính xác nguồn này khi người dùng gửi email trả lời. [C001]
*   `US-002 (Đăng nhập Google SSO)`: Là quản trị viên, tôi muốn truy cập nhanh vào trang quản trị bằng cách nhấp chọn đăng nhập bằng tài khoản Google doanh nghiệp (Google SSO) mà không cần nhớ mật khẩu. [C002]
*   `US-003 (Xem & Sửa Câu đố)`: Là một quản trị viên, tôi muốn sửa nội dung câu đố, đáp án và lời giải của Tina trực tiếp trên giao diện web và nhìn thấy thay đổi xuất hiện trên trang người dùng sau khi dự án build lại.
*   `US-004 (Quản lý danh sách Lead)`: Là quản trị viên, tôi muốn xem danh sách email thu thập được kèm theo đáp án đúng/sai và nguồn UTM của họ, đồng thời xuất được danh sách này ra tệp CSV để phân tích.
*   `US-005 (Phân quyền bảo mật)`: Là chủ dự án, tôi muốn hệ thống chỉ cho phép các email đăng nhập Google có trong danh sách được chỉ định trước (hoặc có đuôi email `@capcat.vn`) được quyền truy cập trang quản trị. [C003]

## 5. Yêu cầu tính năng (Functional Requirements)
*   `FR-013`: Trích xuất UTM và gửi kèm: Client-side script của trang `/quiz/[slug]` tự động quét URL để lấy `utm_source`, `utm_medium`, `utm_campaign`, lưu tạm và gửi kèm lên API Supabase khi chèn lead mới. [C001]
*   `FR-014`: Chuyển đổi dữ liệu câu đố sang bảng Supabase: Tạo bảng `quizzes` và di chuyển dữ liệu từ file JSON cục bộ lên.
*   `FR-015`: Trang đăng nhập quản trị `/admin/login`: Tích hợp nút đăng nhập Google SSO thông qua Supabase Auth.
*   `FR-016`: Phân quyền Admin: Tạo bảng `admins` lưu danh sách email admin hợp lệ. Thực hiện kiểm tra email sau khi xác thực Google. Nếu email hợp lệ, cho phép vào trang dashboard. Ngược lại, đăng xuất và từ chối truy cập. [C003]
*   `FR-017`: Dashboard quản lý câu hỏi `/admin/quizzes`: Hiển thị danh sách câu đố, cho phép thêm câu đố mới, chỉnh sửa nội dung câu hỏi, 4 đáp án, chỉ số đáp án đúng và lời giải thích.
*   `FR-018`: Dashboard xem lead `/admin/leads`: Hiển thị bảng danh sách email người tham gia, đáp án họ chọn, nguồn UTM, ngày giờ. Bổ sung nút "Tải file CSV".
*   `FR-019`: Webhook build lại trang: Khi admin nhấn lưu chỉnh sửa câu đố, hệ thống tự động gửi yêu cầu gọi API webhook (ví dụ Netlify/Vercel) để kích hoạt build lại trang tĩnh nhằm cập nhật giao diện người dùng.

## 6. Yêu cầu phi chức năng (Non-Functional Requirements)
*   `NFR-005`: Bảo mật RLS: Bật Row Level Security cho bảng `quizzes` và `quiz_leads`, chỉ cho phép vai trò admin đã xác thực được sửa đổi dữ liệu hoặc đọc danh sách lead. [C003]
*   `NFR-006`: UX/UI: Áp dụng triết lý Muji-minimalism đồng bộ, bảng biểu trực quan, gọn gàng, sử dụng các icon nét mảnh Phosphor (`ph-light`).
*   `NFR-007`: Hiệu năng: Trang admin hiển thị và tải dữ liệu client-side cực nhanh bằng cơ chế phân trang (Pagination).

## 7. Tiêu chí nghiệm thu (Acceptance Criteria)
*   `AC-007`: Gửi lead từ link có UTM ghi nhận chính xác trường `utm_source` trong cơ sở dữ liệu.
*   `AC-008`: Truy cập `/admin/quizzes` when chưa đăng nhập will be redirected to `/admin/login`.
*   `AC-009`: Một email không nằm trong bảng `admins` khi đăng nhập Google SSO thành công sẽ bị từ chối truy cập vào dashboard quản trị.
*   `AC-010`: Sửa câu hỏi trên admin và lưu thành công, dữ liệu bảng `quizzes` trong Supabase được cập nhật tương ứng.

## 8. Ngoài phạm vi dự án (Out of Scope)
*   Chưa hỗ trợ hệ thống gửi email phản hồi tự động trực tiếp từ trang admin (Sẽ thực hiện ở các Phase sau).

## 9. Câu hỏi mở và Chấp nhận rủi ro
*   *Câu hỏi:* Cách quản lý ảnh OG động khi tạo câu hỏi mới?
*   *Chấp nhận rủi ro:* Khi admin tạo một câu đố hoàn toàn mới trên trang quản trị, họ cần tự thiết kế ảnh xem trước (1200x630px) chứa câu hỏi mới và tải lên máy chủ thông qua một nút tải ảnh lên (Upload file) của trang Admin (lưu vào Supabase Storage hoặc host CDN) rồi điền liên kết vào ô `ogImage`.

