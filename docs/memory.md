# System Memory and Constraints - DOCA FM & SSO Integration

## 1. Known Blockers
*   **None:** Supabase Auth is enabled on the configured project dashboard (`fkilmtcjyommdbtogmeo.supabase.co`).

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

