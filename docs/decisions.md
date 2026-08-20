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

---

## ADR-045: Cấu trúc Layout Trang Chủ theo Mô Hình Hành Trình AIDA

### Bối cảnh
Bố cục trang chủ hiện tại đặt Banner quảng cáo Kiosk ngay dưới trình phát nhạc DOCA FM, gây cảm giác thương mại hóa quá sớm cho người dùng mới truy cập, đồng thời mục Blog (Nhật ký lối sống) bị đẩy xuống quá sâu dưới đáy trang.

### Quyết định
Tái phân bổ vị trí các section theo mô hình phễu AIDA:
1. **Attention:** Giữ Hero Section và DOCA FM Player ở đầu trang để thu hút bằng giai điệu chữa lành.
2. **Interest:** Đưa Nhật ký lối sống (Blog) lên ngay dưới Player nhạc để người dùng tiếp thu các giá trị phi thương mại trước.
3. **Desire:** Đặt Kệ quà của mẹ (Merchandising) dưới hòm thư để khơi gợi nhu cầu mua sắm đồ tốt cho Boss.
4. **Action:** Di chuyển Banner Kiosk ("Mở sạp gỗ cùng Tina") xuống chân trang để kêu gọi hành động đăng ký Kiosk sau khi người dùng đã trải nghiệm trọn vẹn website.

### Hệ quả
*   **Ưu điểm:** Tạo dòng chảy tâm lý mượt mà, tăng độ thiện cảm và nâng cao tỷ lệ chuyển đổi đăng ký Kiosk lẫn mua sắm Affiliate.

---

## ADR-046: Trực quan hóa Kệ hàng bằng Tab nhân vật Doca House & Polaroid Modal

### Bối cảnh
"Kệ quà của mẹ" trưng bày danh sách sản phẩm nằm ngang cố định gây khó khăn cho việc phân loại đồ dùng của người dùng theo nhu cầu và làm loãng giao diện khi số lượng sản phẩm tăng lên.

### Quyết định
1. **Tích hợp Tab lọc nhân vật:** Chia sản phẩm thành 4 nhóm theo các Boss: Tina (Sách), Latte (Thức ăn), Muối (Đồ chơi), Pi's (Góc ngủ) hiển thị dưới dạng thanh Tab cuộn ngang trên mobile.
2. **Lưới sản phẩm dynamic:** 2 cột trên Mobile (nút xe mua sắm thu gọn) và 4-5 cột trên Desktop.
3. **Trải nghiệm chi tiết qua Modal Polaroid:** Bấm sản phẩm sẽ mở Bottom Sheet (Mobile) hoặc Modal Polaroid căn giữa màn hình với phông nền mờ blur (Desktop).

### Hệ quả
*   **Ưu điểm:** Giảm tải nhận thức (Cognitive Load) cho người dùng, tối giản giao diện trang chủ mà vẫn giới thiệu được nhiều sản phẩm hơn.

---

## ADR-047: Trải nghiệm Hòm thư Namiya ẩn dạng Drawer

### Bối cảnh
Form gửi thư Namiya tĩnh chiếm diện tích lớn trên trang chủ, làm giao diện trở nên thô ráp và giảm tính tò mò khám phá.

### Quyết định
Ẩn form nhập liệu đằng sau một hình vẽ line-art hòm thư gỗ và một nút bấm duy nhất `[Viết thư tâm sự ✉]`. Khi click, form nhập liệu sẽ trượt mở ra mượt mà ngay tại chỗ bằng CSS transition. Tích hợp đăng nhập Google điền email tự động 1 chạm để loại bỏ ma sát điền form (Friction Eradication).

### Hệ quả
*   **Ưu điểm:** Giao diện tinh tế, khơi gợi cảm giác tò mò và loại bỏ hoàn toàn ma sát nhập liệu trên Mobile.

---

## ADR-048: Cấu trúc cơ sở dữ liệu Ví Xu dạng Sổ cái (Ledger Schema)

### Bối cảnh
Cần thiết kế cấu trúc dữ liệu lưu trữ số dư và lịch sử giao dịch xu của người dùng. Thiết kế thông thường là lưu trực tiếp cột `balance` trong bảng `users`, nhưng cách này không thể đối soát khi xảy ra chênh lệch dữ liệu hoặc có tranh chấp giao dịch.

### Quyết định
Tách riêng bảng `wallets` và bảng lịch sử giao dịch `coin_transactions` theo mô hình sổ cái kế toán (Double-entry Ledger). Số dư hiển thị thực tế của người dùng phải tương ứng với tổng các giao dịch cộng/trừ trong lịch sử.

### Hệ quả
*   **Ưu điểm:** Đảm bảo tính minh bạch, dễ dàng chạy đối soát tài chính khi có khiếu nại.
*   **Nhược điểm:** Phải thực hiện ghi chép 2 bảng đồng thời, tăng số lượng câu lệnh SQL ghi DB.

---

## ADR-049: Khóa dòng ví (Row-level Lock) và Database Transaction

### Bối cảnh
Khi người dùng mua lượt nhạc hoặc nạp tiền và nhấn nút liên tục (hoặc do hacker spam API), hệ thống có thể gặp hiện tượng Race Condition (xử lý đồng thời nhiều request dẫn đến trừ xu sai hoặc cộng xu thừa).

### Quyết định
Mọi lệnh cập nhật số dư ví đều phải được bọc trong một Database Transaction và sử dụng truy vấn khóa dòng `SELECT ... FOR UPDATE` ví của người dùng trước khi ghi số dư mới.

### Hệ quả
*   **Ưu điểm:** Loại bỏ hoàn toàn lỗi Race Condition và Double Spending.
*   **Nhược điểm:** Làm tăng độ trễ xử lý nhẹ và có nguy cơ nghẽn DB (Deadlock) nếu viết transaction không tối ưu. (Giải quyết bằng cách giữ thời gian chạy transaction ngắn nhất có thể).

---

## ADR-050: Sử dụng Redis chống xử lý trùng lặp Webhook (Idempotency Lock)

### Bối cảnh
Cổng thanh toán MoMo/ZaloPay có cơ chế tự động gửi lại (retry) Webhook thông báo thanh toán thành công nếu server của chúng ta phản hồi chậm hoặc lỗi mạng. Nếu không kiểm soát, người dùng sẽ được cộng xu nhiều lần cho cùng một hóa đơn.

### Quyết định
Sử dụng bộ nhớ cache Redis làm kho lưu trữ Idempotency Key. Khi nhận webhook, backend kiểm tra xem mã giao dịch `txnId` đã tồn tại trong Redis chưa. Nếu có, bỏ qua và phản hồi 200 OK ngay lập tức. Nếu chưa, set key với TTL 24h và bắt đầu xử lý cộng xu.

### Hệ quả
*   **Ưu điểm:** Ngăn chặn hoàn toàn việc cộng xu trùng lặp từ webhook của cổng thanh toán.

---

## ADR-051: Tự động xuất hóa đơn điện tử tổng cuối ngày

### Bối cảnh
Các đơn hàng nạp xu thường có giá trị nhỏ (10k, 20k) và phát sinh liên tục trong ngày. Nếu xuất hóa đơn điện tử lẻ cho từng đơn hàng sẽ tạo ra lượng lớn số hóa đơn gây tốn kém chi phí mua hóa đơn dịch vụ (Misa/Viettel) và gây quá tải cho bộ máy kế toán đối soát.

### Quyết định
Sử dụng tác vụ tự động (Cron Job) gom toàn bộ doanh thu nạp xu thành công trong ngày và gọi API cổng hóa đơn điện tử để xuất duy nhất **01 hóa đơn tổng** ghi nhận doanh thu dịch vụ trong ngày vào cuối ngày lúc 23:55.

### Hệ quả
*   **Ưu điểm:** Giảm số lượng hóa đơn điện tử cần mua từ hàng ngàn số xuống còn 365 số/năm. Đơn giản hóa tờ khai thuế GTGT hàng quý.


---

# Architecture Decisions (ADR) - Capcat Coin Hub (`apps/coin-hub`)

## ADR-022: Microservice Topology for Capcat Coin Hub
*   **Context:** We need a robust virtual economy, payment gateway, and wallet ledger engine that serves Capcat today and can serve other company apps (English app, Comic app) tomorrow.
*   **Decision:** Build `apps/coin-hub` as a standalone NestJS microservice running on port `:3005`, isolated from `apps/core-platforms` and web frontends.
*   **Consequences:** Eliminates cross-service memory leaks; ensures high availability of financial ledger independently of backend domain refactorings.

## ADR-023: Universal User Identity with Email and Phone Auto-Linking
*   **Context:** Web leads and SSO users are identified by Email, whereas Mobile App and Core Backend users are identified by Phone number.
*   **Decision:** The Coin Hub `users` table uses nullable unique `email` and nullable unique `phone` with constraint `CHECK (email IS NOT NULL OR phone IS NOT NULL)`. An auto-link endpoint coalesces temporary guest wallets upon registration.
*   **Consequences:** Seamless user experience across web quizzes and mobile app without requiring central SSO on Day 1.

## ADR-024: BullMQ Queue-Decoupled Webhook Processing and Row Locking
*   **Context:** Webhook callbacks from payment gateways must respond in <500ms to avoid retries, but ledger balance updates require strict relational locking.
*   **Decision:** Webhooks verify HMAC signatures, push the payload into a Redis BullMQ queue, and return HTTP 200 immediately. A background worker processes the job with `SELECT wallet FOR UPDATE` in a PostgreSQL transaction.
*   **Consequences:** Guaranteed 0% gateway timeout rate; eliminates race conditions and double-spending.

## ADR-025: Dedicated PostgreSQL Database and Independent Redis Store
*   **Context:** Financial ledger tables require strict transactional isolation and dedicated migration lifecycles.
*   **Decision:** Provision a separate PostgreSQL database (`COIN_HUB_DATABASE_URL`) and Redis instance (`COIN_HUB_REDIS_URL`) for `apps/coin-hub`.
*   **Consequences:** Database failures or migrations in `core-platforms` do not interrupt the payment ledger.

## ADR-026: Strategy Pattern for Gateway Adapters (Mock Sandbox + ZaloPay)
*   **Context:** We need to develop and test E2E payment flows offline immediately while integrating production ZaloPay.
*   **Decision:** Define a polymorphic `PaymentGatewayInterface` with a built-in `MockGatewayAdapter` (instant QR and sandbox testing) and `ZaloPayGatewayAdapter` (HMAC SHA-256 App-to-App & Dynamic QR).
*   **Consequences:** 100% testable locally without waiting for merchant registration approvals; ready for MoMo, VietQR, and PayOS expansion.
