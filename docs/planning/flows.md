# System and User Flows - DOCA FM & SSO Integration

This document details the user-facing and backend system flows for the live synchronized FM player and the client-side SSO authentication system.

## 1. Client-Side Playlist & Weather Loading Flow

The sequence of actions when a user visits the website:

```mermaid
sequenceDiagram
    participant User as Site Visitor (Browser)
    participant Player as Cozy Audio Player
    participant Meteo as Open-Meteo API
    participant Storage as Supabase Storage
    
    User->>Player: Open Homepage (/)
    Par Load Playlist & Weather
        Player->>Storage: GET public/audio/playlist.json
        Storage-->>Player: Return tracks library & slots config
    and Load Weather (timeout 1.5s)
        Player->>Meteo: GET weather for coordinates (10.7222, 106.6783)
        Meteo-->>Player: Return WMO weather code & temperature
    End
    Player->>Player: Determine Active Slot (Morning/Afternoon/Evening)
    Player->>Player: Parse WMO code to Vietnamese description
    Player->>Player: Dynamically build Tina's Host Intro Text
    Player->>Player: Render Host Tina Card & Visual Playlist Schedule
```

---

## 2. Playback FM Synchronization Flow

When the user interacts with the music controls, playback is synchronized in real-time:

```mermaid
sequenceDiagram
    participant User as Site Visitor
    participant Player as Cozy Audio Player
    participant Audio as HTML5 Audio Element
    
    User->>Player: Click Play button
    Player->>Player: Get Date.now() / 1000
    Player->>Player: Calculate playhead offset = currentEpoch % totalPlaylistDuration
    Player->>Player: Find active track and track-relative offset
    Player->>Audio: Set src = activeTrack.url
    Player->>Audio: Listen for 'loadedmetadata'
    Audio-->>Player: Metadata loaded
    Player->>Audio: Set currentTime = trackOffset
    Player->>Audio: Execute play()
    Player->>User: Play synchronized ambient jazz music
```

---

## 3. SSO Login Redirection & Callbacks Flow

When a user clicks "Đăng nhập" and selects an SSO provider:

```mermaid
sequenceDiagram
    participant User as User
    participant App as Website (Astro Client)
    participant Sub as Supabase Auth SDK
    participant OAuth as OAuth Provider (Google/Zalo)
    
    User->>App: Click 'Đăng nhập'
    App->>App: Render Modal Overlay
    User->>App: Click 'Google' or 'Zalo'
    App->>Sub: signInWithOAuth(provider)
    Sub->>OAuth: Redirect user to OAuth authorization page
    User->>OAuth: Authenticate & authorize app permissions
    OAuth->>App: Redirect back to site with code (e.g. /#access_token=...)
    App->>Sub: Auto-detect hash/query parameter and parse session
    Sub->>App: Emit AUTH_STATE_CHANGE (Signed In)
    App->>User: Render signed-in Navbar capsule & enable Profile access
```

---

## 4. Navigation Bar Auth Synchronization Flow

On page mount, the Navbar establishes the authentication capsule:

```mermaid
sequenceDiagram
    participant Browser as Browser
    participant Nav as Navbar Script
    participant Sub as Supabase Client
    
    Browser->>Nav: DOMContentLoaded Event
    Nav->>Nav: Render invisible/skeleton auth capsule (prevent layout flash)
    Nav->>Sub: Get current active session (from LocalStorage/Cookie)
    alt Session exists (User Logged In)
        Sub-->>Nav: Return Session user metadata
        Nav->>Nav: Build avatar & name capsule linking to /profile
        Nav->>Nav: Fade in User Capsule
    else No Session (Guest User)
        Sub-->>Nav: Return null
        Nav->>Nav: Build "Đăng nhập" button
        Nav->>Nav: Fade in Guest Button
    end
```

---

## 5. Quy trình trích xuất UTM và gửi kèm Lead Email

Khi khách truy cập nhấp vào liên kết từ mạng xã hội có chứa UTM parameters:

```mermaid
sequenceDiagram
    participant User as Khách truy cập
    participant Web as Trình duyệt (/quiz/slug?utm_source=fb)
    participant Memory as Window URL / SessionStorage
    participant DB as Bảng quiz_leads (Supabase)

    User->>Web: Truy cập liên kết câu đố
    Web->>Web: Quét URL Search Params
    alt Tìm thấy utm_source, utm_medium, utm_campaign
        Web->>Memory: Ghi nhớ các giá trị UTM vào biến tạm
    else URL không chứa UTM
        Web->>Web: Bỏ qua / Thiết lập giá trị null
    end
    User->>Web: Điền email & Gửi câu trả lời
    Web->>DB: Gửi POST /quiz_leads (email, answers, utm_source, utm_medium, utm_campaign)
    DB-->>Web: Phản hồi thành công (201 Created)
    Web-->>User: Mở khóa đáp án & Lời giải của Tina
```

---

## 6. Quy trình Admin chỉnh sửa câu hỏi & Kích hoạt Webhook build lại trang tĩnh

Khi quản trị viên thực hiện lưu chỉnh sửa một câu hỏi trắc nghiệm:

```mermaid
sequenceDiagram
    actor Admin as Quản trị viên
    participant Web as Dashboard (/admin/quizzes)
    participant DB as Bảng quizzes (Supabase)
    participant Webhook as Trình kích hoạt Netlify / Vercel Webhook
    participant CI as CI/CD Pipeline Build Astro Static
    
    Admin->>Web: Sửa câu hỏi & Nhấp "Lưu"
    Web->>DB: Thực hiện UPDATE table quizzes WHERE id = x
    DB-->>Web: Trả về trạng thái Lưu thành công
    Web->>Webhook: Gọi API POST Webhook build lại trang tĩnh
    Webhook-->>Web: Nhận webhook thành công
    Webhook->>CI: Kích hoạt Astro static build pipeline
    CI->>DB: Fetch toàn bộ bảng quizzes mới nhất
    CI->>CI: Build lại các trang tĩnh /quiz/*
    CI-->>Admin: Cập nhật giao diện mới nhất cho tất cả người dùng
```

---

## 7. Quy trình tương tác trượt mở Hòm thư Namiya & Điền nhanh Google SSO

Khi khách truy cập muốn gửi thư tâm sự ẩn danh:

```mermaid
sequenceDiagram
    participant User as Người dùng (Sen)
    participant Web as Trình duyệt (Homepage)
    participant Sub as Supabase Auth SDK
    
    User->>Web: Click nút "Viết thư gửi gắm tâm sự ✉"
    Web->>Web: Trượt mở form nhập liệu (CSS transition height/opacity)
    User->>Web: Click nút Google SSO nhanh cạnh ô Email
    Web->>Sub: signInWithOAuth(provider: 'google')
    Sub-->>Web: Trả về thông tin email đã xác thực
    Web->>Web: Tự động điền email vào input và hiển thị tích xanh (Verified)
    User->>Web: Viết tâm sự & Click "Gửi thư vào Hòm Gỗ"
    Web->>Web: Kích hoạt hoạt ảnh phong thư bay vào hòm gỗ
    Web->>Web: Phát âm thanh chuông gió thành công (Audio R2)
    Web->>User: Hiển thị thông báo "Thư đã được gửi đi 🌸"
```

---

## 8. Quy trình chuyển Tab Kệ quà của mẹ không reload trang

Khi người dùng lọc sản phẩm theo Boss:

```mermaid
sequenceDiagram
    participant User as Người dùng (Sen)
    participant Web as Trình duyệt (Homepage)
    participant DOM as Lưới sản phẩm (Product Grid)
    
    User->>Web: Click Tab Boss (ví dụ: Latte - Thức ăn)
    Web->>Web: Lọc danh sách sản phẩm từ cache Supabase đã fetch sẵn lúc build
    Web->>DOM: Thay đổi danh sách thẻ sản phẩm (DOM Manipulation)
    DOM->>DOM: Thực thi hiệu ứng thẻ Polaroid xoay nhẹ 2-3 độ
    DOM-->>User: Hiển thị danh sách sản phẩm thức ăn của Latte
```

---

## 9. Quy trình nạp xu qua cổng ZaloPay/MoMo (Web to App)

Khi người dùng thực hiện nạp xu thông qua giao diện ứng dụng:

```mermaid
sequenceDiagram
    actor User as Người dùng
    participant App as Trình duyệt (Client)
    participant API as Backend (Astro API)
    participant ZP as Cổng ZaloPay/MoMo
    participant DB as Database (Postgres)
    participant Redis as Redis Cache

    User->>App: Chọn gói nạp & Nhấn "Thanh toán"
    App->>API: POST /api/billing/recharge (packageId, userId)
    API->>DB: Tạo đơn hàng nạp xu (status: PENDING)
    API->>ZP: Gọi API tạo đơn hàng (createOrder) kèm Signature Key1
    ZP-->>API: Trả về link thanh toán & mã QR
    API-->>App: Trả về link & mã QR
    App->>User: Hiển thị mã QR động trên Desktop (Hoặc deep link app trên Mobile)
    User->>ZP: Quét mã & xác nhận thanh toán trên App ZaloPay/MoMo
    ZP->>API: Gọi Webhook / Callback thông báo thành công (signature, data)
    
    note over API: Xử lý Webhook an toàn
    API->>Redis: Kiểm tra Idempotency Key (txnId)
    alt txnId đã xử lý
        API-->>ZP: Phản hồi 200 OK ngay (bỏ qua bước dưới)
    else txnId chưa xử lý
        API->>Redis: Lưu txnId với TTL 24h
        API->>DB: Bắt đầu Transaction
        API->>DB: SELECT wallet FOR UPDATE (khóa dòng ví user)
        API->>DB: Cập nhật đơn hàng (status: SUCCESS)
        API->>DB: Ghi log +100 xu vào coin_transactions
        API->>DB: Cập nhật wallets.balance = balance + 100
        API->>DB: Kết thúc Transaction
        API-->>ZP: Phản hồi 200 OK
        API->>App: Thông báo real-time qua WebSockets / Server-Sent Events
        App-->>User: Hiển thị thông báo "Nạp xu thành công! 🐾"
    end
```

---

## 10. Quy trình đối soát tự động hàng ngày cho Kế toán (Automated Reconciliation)

Quy trình tự động hóa đối khớp doanh thu vào ban đêm:

```mermaid
sequenceDiagram
    participant Cron as Hệ thống tác vụ (Cron Job)
    participant API as Backend (Astro API)
    participant ZP as API Đối soát ZaloPay/MoMo
    participant DB as Database (Postgres)
    participant Tele as Kênh cảnh báo (Telegram/Discord)

    Cron->>API: Kích hoạt đối soát lúc 00:30 hàng ngày
    API->>ZP: Lấy danh sách giao dịch thành công ngày hôm trước
    ZP-->>API: Trả về danh sách mã giao dịch (momo_txn_id / zalopay_txn_id)
    API->>DB: Truy vấn các đơn nạp xu thành công tương ứng
    API->>API: Chạy thuật toán đối khớp chéo (Reconciliation Algorithm)
    alt Phát hiện chênh lệch (Lệch số tiền, hoặc giao dịch ZaloPay báo thành công nhưng DB chưa ghi nhận)
        API->>Tele: Gửi thông báo khẩn cấp cho Kế toán & Đội Kỹ thuật
    else Đối khớp 100% khớp nhau
        API->>DB: Ghi log đối soát ngày thành công (Reconciliation Log)
    end
```

---

## 11. Quy trình xuất hóa đơn điện tử tự động cuối ngày (Daily Automated E-Invoicing)

Để tối ưu hóa thủ tục xuất hóa đơn thuế cho các giao dịch nạp xu lẻ:

```mermaid
sequenceDiagram
    participant Cron as Hệ thống tác vụ (Cron Job)
    participant API as Backend (Astro API)
    participant DB as Database (Postgres)
    participant Invoice as API Hóa đơn điện tử (Misa MeInvoice)

    Cron->>API: Kích hoạt xuất hóa đơn tổng lúc 23:55 hàng ngày
    API->>DB: Tính tổng doanh thu nạp xu thành công trong ngày
    DB-->>API: Trả về tổng tiền (Ví dụ: 1,500,000đ)
    API->>Invoice: Gửi yêu cầu POST /invoices (xuất 01 hóa đơn tổng ghi nhận doanh thu dịch vụ trong ngày)
    Invoice->>Invoice: Xác thực & Ký số hóa đơn điện tử
    Invoice-->>API: Trả về mã số hóa đơn & file PDF
    API->>DB: Lưu thông tin hóa đơn vào bảng nhật ký thuế



---

# System and User Flows - Doca Coin Hub (`apps/coin-hub`)

## 1. Payment Inflow & Coin Recharge Flow (ZaloPay & Mock)

```mermaid
sequenceDiagram
    autonumber
    actor User as User (Sen / Mobile / Web)
    participant Client as Client App (Astro / Flutter)
    participant Hub as Coin Hub API (:3005)
    participant Gateway as Payment Gateway (ZaloPay / Mock)
    participant Queue as BullMQ (Redis)
    participant Worker as Ledger Worker
    participant DB as PostgreSQL (Coin Hub DB)

    User->>Client: Select Coin Package (e.g. 10,000 VND = 100 Cá)
    Client->>Hub: POST /api/v1/orders/create { tenant_id: 'doca', email/phone, package_id, gateway }
    Hub->>DB: Find or create User & Wallet
    Hub->>DB: INSERT payment_orders (status: 'PENDING')
    Hub->>Gateway: Create Order (amount, order_id, HMAC)
    Gateway-->>Hub: Return order_url, qr_code, app_trans_token
    Hub-->>Client: Return Order Response (QR code + Deep link)
    
    alt Desktop Web
        Client->>User: Display Dynamic QR Code Modal
        User->>Gateway: Scan QR code with ZaloPay App & Confirm Pay
    else Mobile App
        Client->>User: App-to-App Deep Link Redirect
        User->>Gateway: Authorize Payment in ZaloPay App
    end

    Gateway->>Hub: POST /api/v1/webhooks/zalopay (callback data + mac)
    Hub->>Hub: Verify HMAC-SHA256 signature
    Hub->>Queue: Enqueue job { order_id, gateway_trans_id, amount }
    Hub-->>Gateway: HTTP 200 { return_code: 1, return_message: 'success' } (<50ms)

    Queue->>Worker: Pick job 'ledger-credit-job'
    Worker->>DB: BEGIN TRANSACTION
    Worker->>DB: SELECT wallet FOR UPDATE (Row Lock)
    Worker->>DB: UPDATE payment_orders SET status = 'SUCCESS'
    Worker->>DB: INSERT coin_transactions (+100 Cá, type: 'RECHARGE')
    Worker->>DB: UPDATE wallets SET balance = balance + 100
    Worker->>DB: COMMIT TRANSACTION
    Worker->>Client: Emit Realtime Noti / Client Polls GET /orders/:id/status
    Client->>User: Display "Nạp Cá Thành Công!" & Update Balance Box
```

## 2. Coin Spend & Feature Unlock Flow

```mermaid
sequenceDiagram
    autonumber
    actor User as User (Sen)
    participant Client as Capcat Client App
    participant Hub as Coin Hub API (:3005)
    participant DB as PostgreSQL (Coin Hub DB)

    User->>Client: Click "Unlock Tina Special Story" (Cost: 30 Cá)
    Client->>Hub: POST /api/v1/wallets/spend { tenant_id: 'doca', email/phone, amount: 30, service_ref: 'STORY_015' }
    Hub->>DB: BEGIN TRANSACTION
    Hub->>DB: SELECT wallet FOR UPDATE WHERE user_id = ... AND tenant_id = 'doca'
    alt Balance < 30 Cá
        Hub->>DB: ROLLBACK
        Hub-->>Client: HTTP 400 "Insufficient Coin Balance"
        Client->>User: Prompt "Số dư không đủ! Nạp thêm Cá"
    else Balance >= 30 Cá
        Hub->>DB: INSERT coin_transactions (-30 Cá, type: 'SPEND', source_ref: 'STORY_015')
        Hub->>DB: UPDATE wallets SET balance = balance - 30
        Hub->>DB: COMMIT TRANSACTION
        Hub-->>Client: HTTP 200 { success: true, remaining_balance: 70 }
        Client->>User: Unlock Feature & Render Content
    end
```
