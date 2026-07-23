# Architectural Decisions (ADR) - DOCA FM & SSO Integration

This document contains the Architecture Decision Records (ADRs) for the live synchronized FM player and the client-side SSO authentication system.

## ADR-001: Media Storage in Supabase Storage vs. Git Repository
*   **Decision:** Move all audio files to public Supabase Storage bucket `audio`.
*   **Consequences:** Reclaimed ~150MB Git bloat, optimized streaming CDN performance.

## ADR-002: Storing Playlist Metadata in Supabase Storage (JSON) vs. Supabase Database Table
*   **Decision:** Store metadata in a single `playlist.json` file in Supabase Storage, loaded on client page load.
*   **Consequences:** Low latency (CDN cached), no database query cost at load time.

## ADR-003: US Military Works & Showa Jazz vs. 1920s Scratchy Archives
*   **Decision:** Use modern digital recordings by US Military Jazz Bands and pre-1976 Japanese Showa Jazz recordings for sweet, clean audio.
*   **Consequences:** 100% legal compliance, cozy digital-quality sound.

## ADR-004: Shared FM Playback Sync via Client Time Modulo
*   **Decision:** Compute the shared playhead offset client-side using the system epoch timestamp modulo the total active playlist duration.
*   **Consequences:** Extremely lightweight, cost-free, zero-setup synchronization.

## ADR-005: Client-Side Open-Meteo Integration for Weather Context
*   **Decision:** Fetch current weather conditions at page load using the client browser to call the Open-Meteo API.
*   **Consequences:** Dynamic, live greetings. A 1.5s timeout is used to fallback to "trời mát mẻ" if the API is down.

## ADR-006: Tina as Doca FM Host
*   **Decision:** Assign **Tina** as the primary radio host of DOCA FM, presenting her warm, literary light-novel style introductions.

## ADR-007: Client-side Supabase Auth Client Integration
*   **Context:** The website is a statically generated site (Astro SSG). We need user authentication without moving to a fully SSR server-side model which would increase hosting costs and latency.
*   **Decision:** Initialize and run the Supabase client SDK client-side. The session is managed browser-side via cookies/localStorage.
*   **Consequences:** Retains pure static site hosting compatibility (e.g. on Netlify/Vercel/VnHost) while granting secure OAuth workflows. Avoids Astro build-time compile failures by isolating SDK initialization to client-side scripts.

## ADR-008: Google and Zalo SSO Providers Integration
*   **Context:** Users need quick authentication options. Zalo is highly popular in Vietnam, while Google is universally supported.
*   **Decision:** Enable Google OAuth via Supabase's built-in provider dashboard. Enable Zalo OAuth as a custom OAuth2 Identity Provider inside Supabase's Custom Provider configuration.
*   **Consequences:** Provides a seamless login flow for local and global users. Zalo's authorization request is routed via `oauth.zaloapp.com` and exchanged via client redirections.

## ADR-009: Pet Profile Metadata Storage
*   **Context:** The profile page needs to save and render the user's pet details.
*   **Decision:** Store pet metadata inside Supabase Auth's `user_metadata` field (via `supabase.auth.updateUser()`) and cache it in browser `localStorage` for instant load.
*   **Alternatives Rejected:** Creating a separate `pets` PostgreSQL table (rejected because the current requirement is only a basic pet card section without relational lookups, making user-metadata the simplest, zero-database-maintenance choice).
*   **Consequences:** Highly portable, secure, zero database infrastructure changes required.

## ADR-010: Neutral Skeleton Authentication States
*   **Context:** On static pages, pre-rendered navigation bars will default to showing "Đăng nhập" (Guest state) before client-side JS finishes loading the active session, causing a visual flash.
*   **Decision:** Pre-render the login container as an invisible/skeleton block by default (`opacity: 0` or `.loading-state`), then dynamically transition to the Guest button or User capsule once the Supabase auth state finishes client-side initialization.
*   **Consequences:** Eliminates visual glitches (layout flash), resulting in a premium, fluid aesthetic feel.

---

## ADR-038: Tích hợp Google SSO qua Supabase Auth

### Bối cảnh
Chúng ta cần một giải pháp đăng nhập an toàn, tiện lợi cho quản trị viên mà không cần phát triển hệ thống lưu trữ mật khẩu, xác thực OTP phức tạp.

### Quyết định
Sử dụng **Google OAuth2 (SSO)** làm phương thức xác thực duy nhất cho trang quản trị `/admin`, được cấu hình thông qua cổng Supabase Auth.

### Các giải pháp thay thế đã bị loại bỏ
*   **Đăng nhập bằng Email/Password:** Bị loại bỏ vì tăng rủi ro bảo mật (như lộ mật khẩu), tăng chi phí bảo trì (quên mật khẩu, đổi mật khẩu) và trải nghiệm kém hơn.
*   **Đăng nhập bằng mã OTP qua Email:** Tương đối tiện lợi nhưng có chi phí gửi email và độ trễ nhận mã.

### Bằng chứng / Nguồn tham chiếu
*   `S002`, `E002`, `C002`.

### Hệ quả
*   **Ưu điểm:** Độ bảo mật tuyệt đối từ Google, không cần quản lý mật khẩu trong DB, tiện dụng.
*   **Nhược điểm:** Cần cấu hình Google Cloud Console (OAuth Client ID) và khai báo URI callback ở trang quản trị Supabase.

---

## ADR-039: Phân quyền quản trị viên thông qua Bảng Admins và RLS

### Bối cảnh
Đăng nhập Google SSO thành công chỉ xác nhận người dùng là chủ sở hữu của một tài khoản Google bất kỳ. Chúng ta cần một cơ chế phân quyền (Authorization) để chỉ cho phép những tài khoản Google được chỉ định được truy cập trang admin.

### Quyết định
Tạo bảng `public.admins` lưu danh sách trắng các email được cấp quyền. Trên cơ sở dữ liệu Supabase, viết chính sách RLS (Row Level Security) cho bảng `quizzes` và `quiz_leads` so khớp email của JWT token (`auth.jwt()->>'email'`) với email trong bảng `admins`.

### Các giải pháp thay thế đã bị loại bỏ
*   **Phân quyền hoàn toàn ở phía client (Astro logic):** Bị loại bỏ vì không an toàn. Nếu RLS trên database không bật, kẻ xấu có thể gọi trực tiếp API Supabase để đọc/ghi đè dữ liệu mà không cần thông qua giao diện Admin.

### Bằng chứng / Nguồn tham chiếu
*   `S003`, `E003`, `C003`.

### Hệ quả
*   **Ưu điểm:** Bảo mật ở mức cơ sở dữ liệu (Database-level security), chặn đứng các truy cập trái phép trực tiếp qua API. Dễ dàng thêm bớt quyền của admin bằng cách thêm/xóa email khỏi bảng `admins`.

---

## ADR-040: Định dạng UTM theo dõi nguồn tiếp thị

### Bối cảnh
Cần đo lường hiệu quả chuyển đổi từ các bài đăng trên Facebook Page, Facebook Group, Reels và YouTube.

### Quyết định
Sử dụng client-side script trên trang câu đố để đọc 3 tham số URL tiêu chuẩn: `utm_source`, `utm_medium`, và `utm_campaign`. Dữ liệu này được lưu cùng với bản ghi lead trong bảng `quiz_leads`.

### Bằng chứng / Nguồn tham chiếu
*   `S001`, `E001`, `C001`.

---

## ADR-044: Weather-based Curation & Japanese Vibe Stories (DEV)

### Bối cảnh
Người dùng mong muốn DOCA FM trên môi trường DEV phát nhạc phù hợp với thời tiết ngày mai (thay vì lặp lại tuần hoàn tĩnh) và lời dẫn tựa của host Tina phải mang phong cách tiểu thuyết Nhật Bản nhưng lồng ghép khéo léo tên các bài hát đang phát.

### Quyết định
1. **Lấy thời tiết ngày mai:** Dùng API Open-Meteo để dự báo thời tiết tại khu vực Bình Hưng, TP.HCM cho ngày mai (T+1).
2. **Phân loại nhạc dựa trên cấu trúc thư mục R2:** Kiểm tra đường dẫn URL của các file nhạc để phân biệt thể loại (Morning Tea, Deep Sleep, v.v.) rồi lọc bài hát phù hợp với nhóm thời tiết tương ứng (Mưa giông, Nắng nóng, Mát mẻ).
3. **Gọi trực tiếp Gemini API trong Python:** Sử dụng module chuẩn `urllib.request` để gửi yêu cầu sinh truyện ngắn mang vibe tiểu thuyết Nhật Bản lồng ghép tên các bài hát trong slot phát và lời chào của Tina.
4. **Cập nhật đè trước 1 ngày:** Chỉ cập nhật đè dữ liệu của ngày mai (`tomorrow_day_idx`) trong tệp `playlist.json` của R2 để đảm bảo các ngày còn lại hoạt động tuần hoàn bình thường.

### Hệ quả
*   **Ưu điểm:** Tự động hóa hoàn toàn việc soạn thảo danh sách phát và nội dung dẫn chuyện theo thời tiết và bài hát, mang lại trải nghiệm đậm chất nghệ thuật cho người nghe. Không phát sinh thư viện phụ thuộc Python.
*   **Nhược điểm:** Phụ thuộc vào tính sẵn sàng của Gemini API (có cơ chế Fallback tĩnh để đảm bảo an toàn tuyệt đối).

