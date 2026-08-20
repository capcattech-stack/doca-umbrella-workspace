# System Memory and Constraints - DOCA FM & SSO Integration

## 1. Known Blockers
*   **None:** Supabase Auth is enabled on the configured project dashboard (`fkilmtcjyommdbtogmeo.supabase.co`).tks Ant

## 2. Accepted Assumptions
*   **Clock Synchronization (FM)**: We assume the user's system clock is synchronized via NTP. A difference of 1-3 seconds in clocks is acceptable.
*   **Browser Storage Access (SSO)**: We assume the client browser has `localStorage` and `cookie` permissions enabled. If cookies are disabled, authentication sessions might fail to persist across page reloads.
*   **Redirection Configuration**: We assume the allowed redirect URLs in the Supabase Dashboard include:
    *   `http://localhost:4321/` (Affiliate Web Dev Port)
    *   `http://localhost:4321/profile`
    *   Production domains once deployed.

## 3. Historical Constraints & Rules
*   **Active Host**: Tina is the active host of Doca FM.
*   **Design Aesthetics**: Soft glassmorphism cards, watercolor background, peeking cat.
*   **Icon Selection**: Phosphor Icons in `ph-light` weight standard as default, `ph-thin` for minimal elements, `ph-fill` or `ph-duotone` for active states.
*   **Content Voice**: Cozy, therapeutic, quiet Japanese novel style (Iyashikei) tone for Vietnamese copy.

## 4. TrustGraph Notes
*   **Status**: TrustGraph local cluster (Neo4j:7474) is offline.
*   **Action**: Falling back to filesystem storage and local planning artifacts under `docs/`.

---

## 5. Bộ Nhớ Dự Án (Project Memory) - Admin Dashboard & UTM Tracking

### 5.1. Các giả định được chấp thuận (Accepted Assumptions)
*   **Giả định 1 (Astro Hybrid Mode):** Máy chủ chạy ứng dụng Astro cần cấu hình chế độ `hybrid` hoặc `server` để hỗ trợ hiển thị SSR động cho các trang trong `/admin` (nhằm kiểm tra cookie/session và lấy dữ liệu động), trong khi vẫn giữ nguyên cơ chế SSG tĩnh cho các trang người dùng như `/quiz/[slug]`.
*   **Giả định 2 (Cấu hình Google Console):** Chủ sở hữu dự án sẽ chịu trách nhiệm tạo một dự án trên Google Cloud Platform, cấu hình OAuth consent screen và tạo Client ID/Client Secret để nạp vào mục Google Provider trên Supabase Auth Settings.

### 5.2. Ràng buộc lịch sử & Tính nhất quán (Historical Constraints)
*   **Đồng bộ Supabase:** Việc di chuyển dữ liệu câu hỏi trắc nghiệm từ file JSON lên cơ sở dữ liệu Supabase yêu cầu hàm `getStaticPaths()` trong tệp Astro phải chuyển đổi phương thức đọc dữ liệu tương ứng.
*   **Thẩm mỹ Muji/Cozy:** Giao diện trang Admin mặc dù có nhiều bảng biểu nhưng vẫn phải duy trì tông màu thư thái, khoảng cách lề thoáng và phong cách nét vẽ mảnh tinh tế giống như ứng dụng chính.

### 5.3. Các vấn đề chưa giải quyết (Unresolved Issues)
*   *Đồng bộ tự động CI/CD:* Khi admin sửa đổi câu đố trên Supabase, trang tĩnh người dùng sẽ không đổi ngay lập tức cho đến khi kích hoạt build lại trang (Rebuild). Cần nghiên cứu tích hợp Webhook kích hoạt build tự động (ví dụ Netlify/Vercel webhook) hoặc chuyển trang câu đố sang chế độ On-demand Rendering (ISR).

---

## 6. Bộ Nhớ Dự Án (Project Memory) - Tái Cấu Trúc Giao Diện Trang Chủ

### 6.1. Các giả định được chấp thuận (Accepted Assumptions)
*   **Nạp âm thanh chuông gió:** File âm thanh chuông gió nhẹ nhàng khi gửi thư Namiya thành công được host ổn định trên Cloudflare R2 công cộng để giảm tải băng thông cho máy chủ chính.
*   **Kích thước hình ảnh tối ưu:** Các ảnh Polaroid sản phẩm được nén Canvas client-side xuống 300x300px trước khi tải lên, đảm bảo tốc độ tải mượt mà trên di động (Mobile-first).

### 6.2. Ràng buộc lịch sử & Tính nhất quán (Historical Constraints)
*   Quy định phối màu Muji Minimalist là bất di bất dịch, mọi sửa đổi layout đều phải kế thừa các class tiện ích trong `global.css` thay vì viết đè ad-hoc CSS.
*   Các icon của Phosphor Icons phải giữ nguyên định dạng lớp `ph-light` nét mảnh.

### 6.3. Các vấn đề chưa giải quyết (Unresolved Issues)
*   *Trải nghiệm scroll-snap trên iOS:* Một số phiên bản cũ của Safari Mobile có thể gặp hiện tượng giật nhẹ khi vuốt Horizontal Carousel của Blog. Cần kiểm thử E2E kỹ lưỡng trên thiết bị iOS thật.

---

## 7. Bộ Nhớ Dự Án (Project Memory) - Phân hệ Ví Xu & Thanh toán

### 7.1. Các giả định được chấp thuận (Accepted Assumptions)
*   **Đồng bộ thời gian giao dịch:** Các sự kiện nạp tiền dựa trên mốc thời gian Unix Epoch của cổng thanh toán. Hệ thống chấp nhận lệch múi giờ tối đa 5 giây khi đối soát.
*   **Idempotency Key TTL:** Redis lưu thông tin giao dịch (`txnId`) trong vòng 24 giờ là đủ để ngăn chặn các webhook gửi trùng lặp từ MoMo/ZaloPay.
*   **Ủy quyền hóa đơn:** Việc xuất hóa đơn điện tử tổng cuối ngày được người dùng chấp nhận mặc định thông qua điều khoản dịch vụ (TOS), không cần xuất hóa đơn lẻ cho từng giao dịch 10k, 20k.

### 7.2. Ràng buộc lịch sử & Tính nhất quán (Historical Constraints)
*   **Khóa dòng ví bắt buộc (Row-Level Locking):** Bất kỳ lệnh viết mã nào liên quan đến trừ xu (Vd: mở khóa nội dung) hoặc cộng xu (nạp tiền) đều phải bọc trong Database Transaction và chạy khóa dòng (`SELECT FOR UPDATE`). Tuyệt đối không thực hiện cập nhật số dư bằng truy vấn thông thường để tránh Race Condition.
*   **Tuyệt đối cấm giao dịch 2 chiều:** Không viết bất kỳ mã nguồn nào hỗ trợ rút xu ra tiền thật hoặc chuyển xu giữa các người dùng để đảm bảo tuân thủ Nghị định 72 của Chính phủ Việt Nam.

### 7.3. Các vấn đề chưa giải quyết (Unresolved Issues)
*   *Xử lý lỗi timeout webhook:* Nếu server chính bị sập hoặc quá tải đúng lúc ZaloPay/MoMo gọi webhook, đơn hàng sẽ bị treo ở trạng thái `PENDING`. Cần lập trình API đối soát chạy định kỳ mỗi 1 tiếng để tự động quét tìm và hoàn thành các đơn hàng này.


---

# System Memory & Constraints - Capcat Coin Hub (`apps/coin-hub`)

## 1. Microservice Ports & Networking
*   **Coin Hub Port**: Runs on `http://localhost:3005` (API & Swagger at `/docs`).
*   **Core Platforms Port**: Runs on `http://localhost:3000`.
*   **Affiliate Web Port**: Runs on `http://localhost:4321`.
*   **Admin Web Port**: Runs on `http://localhost:4325`.

## 2. Accepted Assumptions & Constraints
*   **Tenant Scoping**: All database tables enforce a `tenant_id` column, defaulting to `'capcat'` during Phase 1.
*   **HKD Tax Compliance**: Physical currency (VND) collected across all tenants aggregates to a single merchant bank account for daily consolidated e-Invoice generation.
*   **Local Test Ergonomics**: Developers can toggle `MOCK_GATEWAY_AUTO_SUCCESS=true` in `.env` to complete payment simulations without real bank credentials.
