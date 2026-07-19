# Architecture Knowledge Base - DOCA FM & SSO Integration

## 1. Tech Stack & APIs
*   **Weather API (FM Curation)**: Open-Meteo Forecast API (unauthenticated).
    *   **Bình Hưng, HCMC Coordinates**: Latitude `10.7222`, Longitude `106.6783`.
*   **Media Storage**: Supabase Storage (public bucket `audio`).
*   **Web Framework**: Astro (v4.16) SSG. Client-side JS fetches and streams the playlist and weather at runtime.
*   **Authentication Provider**: Supabase Auth (client-side integration via `@supabase/supabase-js`).
    *   **Google OAuth**: Default built-in provider in Supabase Auth.
    *   **Zalo OAuth (Custom Provider)**: Configured as an external OAuth2 Identity Provider in the Supabase backend.
        *   Authorization URL: `https://oauth.zaloapp.com/v4/permission`
        *   Token URL: `https://oauth.zaloapp.com/v4/access_token`
        *   User Info URL: `https://graph.zalo.me/v2.0/me`

## 2. Naming, UI & Phosphor Icon Standards
*   **Active Host**: **Tina** (primary radio host).
*   **Icon Library**: **Phosphor Icons** (`ph-light` weight standard, `ph-thin` for minimal elements, `ph-fill` or `ph-duotone` for active state).
*   **Playlist Slots**:
    *   Morning (Sáng): `06:00` - `12:00`
    *   Afternoon (Chiều): `12:00` - `18:00`
    *   Evening (Tối): `18:00` - `06:00` next day
*   **Japanese Novel Style**: Playlist configurations must include `story_title` (e.g. *"Khu Vườn Mưa Và Tiếng Bước Chân Mèo"*).
*   **Auth UI Naming**:
    *   Login Modal container class: `.cozy-login-modal`
    *   Zalo SSO button class: `.cozy-btn-zalo`
    *   Google SSO button class: `.cozy-btn-google`
    *   Navbar user status container: `.user-capsule`

## 3. Core Logic & Implementation Protocols

### 3.1. Mathematical Real-Time FM Synchronization
To make sure all users hear the same track at the same time:
1.  Sum the durations of all tracks in the active playlist to get `totalDuration` in seconds.
2.  Get the current epoch timestamp in seconds: `const now = Math.floor(Date.now() / 1000);`
3.  Compute the playlist playhead offset: `const playlistOffset = now % totalDuration;`
4.  Find the active track `i` where `playlistOffset >= track[i].start` and `playlistOffset < track[i].start + track[i].duration`.
5.  The local track playhead position is: `const trackOffset = playlistOffset - track[i].start;`
6.  Set `audio.currentTime = trackOffset` and call `audio.play()`.

### 3.2. SSG Build Safety & Client-Side Auth
To prevent Astro build-time compile errors for browser-specific objects:
*   Wrap all Supabase JS client initializations and session checks in client-side script contexts:
    ```typescript
    // In Astro files
    <script>
      import { supabase } from '../lib/supabaseClient';
      // Safe to use window, localStorage, and supabase auth methods
    </script>
    ```
*   Use `client:only` directives or defer client scripts if importing interactive components that use browser features.

## 4. "Never Do" List
*   **NEVER** allow users to select or skip tracks on the player (strictly a schedule).
*   **NEVER** hardblock the UI waiting for the weather API (1.5s timeout fallback to "trời mát mẻ").
*   **NEVER** initialize the Supabase client directly in the frontmatter script block of an Astro component, as this will run at build time on the server (causing "window is not defined" crashes). Initialize client-side or safeguard via `typeof window !== 'undefined'`.

## 5. Weather Codes Mapping
*   `0`: "trời trong xanh"
*   `1, 2, 3`: "trời mây nhẹ, mát mẻ"
*   `45, 48`: "trời sương mù nhẹ"
*   `51, 53, 55`: "mưa phùn nhè nhẹ"
*   `61, 63, 65`: "trời mưa rào"
*   `71, 73, 75`: "trời lạnh mát"
*   `80, 81, 82`: "mưa giông bất chợt"
*   `95, 96, 99`: "sấm chớp bão bùng"
*   *Default (Bình Hưng):* "trời mát mẻ"

---

## 6. Kiến Thức Dự Án (Knowledge Base) - Admin Dashboard & UTM Tracking

### 6.1. Công nghệ áp dụng (Tech Stack)
*   **Xác thực & SSO:** Supabase Auth Google Provider (Google SSO).
*   **Cơ sở dữ liệu:** Supabase PostgreSQL.
*   **Trình quản trị UI:** Astro (chế độ kết hợp Hybrid/SSR cho các trang `/admin` cần kiểm tra Session động, chế độ SSG cho các trang `/quiz/[slug]`).
*   **Bộ icon:** **Phosphor Icons** (CDN). Sử dụng định dạng nét mảnh `ph-light` mặc định. [C003]

### 6.2. Tiêu chuẩn viết code (Code Standards)
*   **Định tuyến Admin:**
    *   Trang login: `src/pages/admin/login.astro`
    *   Dashboard quản lý câu hỏi: `src/pages/admin/quizzes.astro`
    *   Dashboard xem leads: `src/pages/admin/leads.astro`
*   **Đồng bộ Layout:** Tất cả trang trong `/admin` phải được bọc trong một layout chung `src/components/AdminLayout.astro` để quản lý phiên đăng nhập và giao diện nhất quán.
*   **Tham số UTM:** Tên các tham số UTM phải tuân thủ chuẩn viết thường: `utm_source`, `utm_medium`, `utm_campaign`.

### 6.3. Quy định bảo mật & Phân quyền (Security & Authorization Constraints)
*   **Bảo vệ DB bằng RLS (Row Level Security):**
    *   Bảng `quizzes`: Cho phép mọi người (Anon) đọc để hiển thị câu hỏi trên web. Nhưng quyền INSERT, UPDATE, DELETE phải kiểm tra email của user đăng nhập có khớp với email trong bảng `admins`.
    *   Bảng `quiz_leads`: Cho phép mọi người (Anon) chèn (INSERT). Nhưng quyền SELECT phải bị khóa, chỉ cho phép vai trò admin.
    *   Bảng `admins`: Chỉ cho phép đọc bởi admin hoặc qua database function bảo mật.
*   **Kiểm tra phân quyền phía Client (Astro Edge/Middleware):** Trong Layout trang quản trị, phải kiểm tra trạng thái Session từ Supabase Auth. Nếu chưa đăng nhập hoặc email không có quyền quản trị viên, lập tức chuyển hướng về trang `/admin/login`.

### 6.4. Danh sách cấm thực hiện (Never Do List)
*   **Không bao giờ** phơi bày Supabase `service_role_key` trong code phía client (chỉ sử dụng `anon_key` ở client, và dùng RLS để bảo mật dữ liệu).
*   **Không bao giờ** cho phép các email không thuộc bảng `admins` đọc danh sách lead trong bảng `quiz_leads` qua API client-side.
*   **Không bao giờ** bỏ qua việc mã hóa hoặc dọn dẹp (sanitize) dữ liệu khi xuất file CSV từ bảng admin để tránh lỗ hổng CSV Injection.

