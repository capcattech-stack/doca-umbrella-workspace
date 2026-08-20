# System Architecture Diagrams - DOCA FM & SSO Integration

This document defines the C4 architectural diagrams and data representations for the DOCA FM real-time synchronization and the Supabase SSO authentication flow.

## 1. C4 Context Diagram

```mermaid
graph TD
    User([Site Visitor / Owner])
    Web[DOCA Affiliate Web - Astro static site]
    SupaStorage[Supabase Storage - playlist.json & audio files]
    Meteo[Open-Meteo Weather API]
    SupaAuth[Supabase Auth Service]
    OAuth[OAuth Providers - Google / Zalo]

    User -->|Visits / Listens| Web
    Web -->|Fetches playlist| SupaStorage
    Web -->|Fetches current weather| Meteo
    Web -->|Triggers authentication| SupaAuth
    SupaAuth -->|Validates credentials| OAuth
    OAuth -->|Redirects session| Web
```

---

## 2. Container/Component Diagram

```mermaid
graph TD
    subgraph Client Browser
        UI[Astro Page UI]
        Player[Cozy Audio Player Script]
        AuthNav[Navbar Auth Capsule Script]
        SupaSDK[Supabase Auth JS Client SDK]
        LocalStorage[(LocalStorage / Cookies)]
    end

    subgraph External Services
        Supabase[(Supabase Storage & Database)]
        OpenMeteo[Open-Meteo API]
        GoogleOAuth[Google OAuth Server]
        ZaloOAuth[Zalo OAuth Server]
    end

    UI --> Player
    UI --> AuthNav
    AuthNav --> SupaSDK
    Player -->|fetch weather| OpenMeteo
    Player -->|fetch playlist| Supabase
    SupaSDK -->|read/write tokens| LocalStorage
    SupaSDK -->|OAuth request| GoogleOAuth
    SupaSDK -->|OAuth request| ZaloOAuth
```

---

## 3. Data Model

### 3.1. LocalStorage Cache Structure (Pet Profiles)
To maintain user pet profiles under key `doca_user_bosses`:

```json
[
  {
    "id": "uuid-v4",
    "name": "Bánh Mì",
    "species": "Cat",
    "age": 2,
    "created_at": "2026-07-06T14:00:00Z"
  }
]
```

### 3.2. Supabase User Metadata Structure
When logged in, user session profile details returned by Supabase Auth (`supabase.auth.getUser()`):

```mermaid
classDiagram
    class UserSession {
        +String id (UUID)
        +String email
        +UserMetadata user_metadata
        +String created_at
    }
    class UserMetadata {
        +String full_name
        +String avatar_url
        +String provider
        +List bosses (Optional sync backup)
    }
    UserSession --> UserMetadata
```

---

## 4. Sơ đồ thành phần C4 - Admin Dashboard & UTM Tracking (C4 Component Diagram)

```mermaid
graph TD
    User[Người dùng / Khách truy cập]
    Admin[Quản trị viên / Marketer]
    Google[Google Identity Service]
    
    subgraph DOCA Astro Web Application
        QuizRoute[/quiz/slug]
        AdminRoute[/admin/*]
        AuthModule[Supabase Auth Integration]
        UTMParser[UTM JS Parser]
    end

    subgraph Supabase Back-end
        DB_Leads[(Bảng: quiz_leads)]
        DB_Quizzes[(Bảng: quizzes)]
        DB_Admins[(Bảng: admins)]
    end

    User -->|Xem trang chứa UTM| QuizRoute
    QuizRoute -->|Đọc tham số UTM| UTMParser
    User -->|Gửi câu trả lời| DB_Leads
    
    Admin -->|Truy cập trang quản trị| AdminRoute
    AdminRoute -->|Chuyển hướng xác thực| AuthModule
    AuthModule -->|Xác thực SSO| Google
    AdminRoute -->|Đọc/Ghi câu hỏi| DB_Quizzes
    AdminRoute -->|Xem & tải danh sách| DB_Leads
    AuthModule -->|So khớp email| DB_Admins
```

## 5. Sơ đồ mô hình dữ liệu (ERD)

```mermaid
erDiagram
    ADMINS {
        int id PK
        text email UK "Email của admin được duyệt"
        timestamptz created_at
    }

    QUIZZES {
        int id PK
        text slug UK "Định danh URL câu đố"
        text question "Nội dung câu hỏi"
        jsonb options "Mảng 4 đáp án"
        int correct_answer "Chỉ số đáp án đúng (0-3)"
        text explanation "Lời giải nghĩa của Tina"
        text og_image "Đường dẫn ảnh OG"
        timestamptz created_at
    }

    QUIZ_LEADS {
        int id PK
        text email "Email của Lead"
        text quiz_slug "Slug câu đố đối chiếu"
        int selected_option "Chỉ số đáp án chọn"
        text utm_source "Nguồn chiến dịch (fb, google, organic)"
        text utm_medium "Phương tiện (post, cpc, reels)"
        text utm_campaign "Tên chiến dịch"
        timestamptz created_at
    }

    QUIZZES ||--o{ QUIZ_LEADS : "đối chiếu câu trả lời"
```

## 6. Quy trình đăng nhập Google SSO & Phân quyền (Sequence Diagram)

```mermaid
sequenceDiagram
    actor Admin as Quản trị viên
    participant Web as Trình duyệt (/admin)
    participant Supabase as Supabase Client Auth
    participant Google as Google OAuth Service
    participant DB as Bảng admins

    Admin->>Web: Nhấp "Đăng nhập với Google"
    Web->>Supabase: signInWithOAuth(provider: 'google')
    Supabase->>Google: Chuyển hướng đăng nhập Google
    Google-->>Supabase: Trả về Token xác thực & Email (admin@capcat.vn)
    Supabase->>DB: Truy vấn SELECT count(*) WHERE email = 'admin@capcat.vn'
    alt Email được tìm thấy trong bảng admins
        DB-->>Web: Trả về Số lượng > 0 (Hợp lệ)
        Web-->>Admin: Mở khóa giao diện Dashboard quản trị
    else Email không được tìm thấy
        DB-->>Web: Trả về Số lượng = 0 (Không hợp lệ)
        Web->>Supabase: Tự động chạy signOut()
        Web-->>Admin: Hiển thị thông báo: "Email này không có quyền quản trị."
    end
```

---

## 7. Sơ đồ cấu trúc phân bố Layout Trang Chủ mới

```mermaid
graph TD
    Index[index.astro - Trang chủ]
    Index --> Hero[Hero Section & FM Player]
    Index --> Blog[Lifestyle Blog - Swipe Carousel]
    Index --> Namiya[NamiyaMailbox.astro - Hòm thư Namiya]
    Index --> Curation[Product Section - Tabs tương tác]
    Curation --> ProdCard[ProductCard.astro - Mini Polaroid]
    Curation --> PolSheet[PolaroidSheet.astro - Bottom Sheet/Modal]
    Index --> Banner[Kiosk Banner - Kêu gọi hành động cuối trang]
```

---

## 8. Sơ đồ trạng thái Hòm thư Namiya (Namiya Mailbox State Diagram)

```mermaid
stateDiagram-v2
    [*] --> Collapsed : Mặc định chỉ hiển thị Hòm thư gỗ Nhật
    Collapsed --> Expanded : Click nút "Viết thư gửi gắm tâm sự"
    
    state Expanded {
        [*] --> EmptyInput : Đợi nhập tâm sự (Nút gửi Disabled)
        EmptyInput --> GoogleAutofill : Click Google SSO
        GoogleAutofill --> EmailVerified : Email tự động điền & verified (tick xanh)
        EmailVerified --> FormReady : Nhập tâm sự >= 10 ký tự
        FormReady --> EmptyInput : Xóa nội dung
    }

    Expanded --> Sending : Click "Gửi thư vào Hòm Gỗ" (FormReady)
    Sending --> SuccessAnim : Chạy hiệu ứng phong thư bay vào hòm
    SuccessAnim --> WindChimePlay : Phát âm thanh chuông gió (Audio R2)
    WindChimePlay --> SuccessMsg : Hiển thị thông báo gửi thành công
    SuccessMsg --> Collapsed : Tự động đóng sau 3 giây hoặc click đóng
```

---

## 9. Sơ đồ cấu trúc C4 - Phân hệ Ví Xu & Thanh toán (C4 Component Diagram)

Quy hoạch hệ thống Ví Xu kết nối các cổng thanh toán và công cụ kế toán:

```mermaid
graph TD
    User[Người dùng / Khách mua xu]
    Admin[Quản trị viên / Kế toán]
    
    subgraph Client Application (Astro Frontend)
        UI_Profile[Trang Hồ sơ /profile]
        UI_Wallet[Trang Nạp xu /profile/wallet]
        UI_AdminBilling[Trang Admin Billing /admin/billing/*]
    end

    subgraph Backend API (Astro API Routes)
        API_Recharge[/api/billing/recharge]
        API_Webhook[/api/billing/webhook/*]
        API_Report[/api/billing/report]
        Core_Wallet[Core Wallet Service]
        Order_Manager[Order Billing Service]
        Provider_Adapter[Payment Providers Adapter]
    end

    subgraph Infrastructure
        DB[(PostgreSQL Database)]
        Redis[(Redis Idempotency Store)]
    end

    subgraph External Gateways
        ZP[Cổng ZaloPay Open API]
        Momo[Cổng MoMo Business API]
        Invoice[API Hóa đơn Misa MeInvoice]
    end

    User -->|Xem số dư & nạp xu| UI_Profile
    User -->|Chọn gói & thanh toán| UI_Wallet
    UI_Wallet -->|Gọi API nạp| API_Recharge
    
    API_Recharge --> Order_Manager
    Order_Manager --> Provider_Adapter
    Provider_Adapter -->|Tạo yêu cầu thanh toán| ZP
    Provider_Adapter -->|Tạo yêu cầu thanh toán| Momo

    ZP -->|IPN Webhook| API_Webhook
    Momo -->|IPN Webhook| API_Webhook
    
    API_Webhook --> Order_Manager
    Order_Manager -->|Đối soát & Khóa ví| Redis
    Order_Manager -->|Cập nhật & ghi nhận log| Core_Wallet
    Core_Wallet -->|Database Transaction| DB

    Admin -->|Đối soát & xem báo cáo| UI_AdminBilling
    UI_AdminBilling -->|Yêu cầu báo cáo| API_Report
    API_Report --> DB
    
    %% Tác vụ tự động
    Cron[Cron Job Serverless] -->|Gom doanh thu & gọi xuất| Invoice
    API_Report -->|Đẩy hóa đơn tổng| Invoice
```

---

## 10. Sơ đồ thực thể cơ sở dữ liệu (ERD - Billing System)

```mermaid
erDiagram
    USERS {
        uuid id PK
        string email
        string name
    }

    WALLETS {
        uuid id PK
        uuid user_id FK
        bigint balance "Số dư xu hiện có"
        datetime updated_at
    }

    COIN_TRANSACTIONS {
        uuid id PK
        uuid wallet_id FK
        uuid order_id FK "Null nếu tiêu dùng nội bộ"
        bigint amount "Số xu biến động (Ví dụ: +100 hoặc -50)"
        string type "RECHARGE, CONSUME, REFUND, ADJUST"
        string description
        datetime created_at
    }

    ORDERS {
        uuid id PK
        uuid user_id FK
        string provider "MOMO, ZALOPAY, PAYOS"
        string provider_tx_id "Mã giao dịch từ cổng thanh toán"
        bigint amount_vnd "Số tiền VNĐ thực tế"
        bigint coin_amount "Số xu quy đổi"
        string status "PENDING, SUCCESS, FAILED"
        datetime created_at
    }

    USERS ||--|| WALLETS : "sở hữu"
    WALLETS ||--o{ COIN_TRANSACTIONS : "có lịch sử"
    USERS ||--o{ ORDERS : "tạo hóa đơn"
    ORDERS ||--|| COIN_TRANSACTIONS : "ghi nhận khi thành công"
```

---

## 11. Sơ đồ trạng thái Giao dịch Thanh toán (Payment Transaction State Diagram)

Mô tả vòng đời của đơn nạp tiền từ lúc khởi tạo đến khi xử lý cộng xu:

```mermaid
stateDiagram-v2
    [*] --> Pending : User tạo đơn nạp xu (Đơn hàng ở trạng thái PENDING)
    
    state Pending {
        [*] --> AwaitingPayment : Đang chờ khách hàng quét mã QR thanh toán
        AwaitingPayment --> WebhookReceived : Webhook từ ZaloPay/MoMo gửi thông tin thành công
        AwaitingPayment --> Expired : Quá 15 phút không thanh toán (Hết hạn mã QR)
    }

    Expired --> Failed : Đơn hàng thất bại (status: FAILED)
    Failed --> [*]

    state Processing {
        WebhookReceived --> IdempotencyCheck : Kiểm tra trùng lặp trên Redis (txnId)
        IdempotencyCheck --> DuplicateIgnored : Đơn đã xử lý -> Phản hồi 200 OK ngay cho Cổng
        IdempotencyCheck --> DB_Transaction : Đơn chưa xử lý -> Bắt đầu DB Transaction
        
        state DB_Transaction {
            [*] --> LockWallet : Chạy SELECT wallets FOR UPDATE
            LockWallet --> UpdateOrderStatus : Chuyển status đơn sang SUCCESS
            UpdateOrderStatus --> WriteCoinTx : Thêm dòng ghi nhận +Xu vào coin_transactions
            WriteCoinTx --> UpdateBalance : wallets.balance = balance + amount
            UpdateBalance --> [*]
        }
    }

    DuplicateIgnored --> Success : Hoàn tất đơn hàng thành công (status: SUCCESS)
    DB_Transaction --> Success : Commit Transaction thành công
    DB_Transaction --> Rollback : Lỗi khi ghi DB -> Rollback dữ liệu
    
    Rollback --> Pending : Giữ đơn ở trạng thái PENDING để ZaloPay/MoMo gửi lại webhook sau
    Success --> [*]
```



---

# System Architecture Diagrams - Capcat Coin Hub (`apps/coin-hub`)

## 1. C4 Container Diagram

```mermaid
graph TD
    subgraph Clients ["Client Layer"]
        Web[Capcat Web / Doca FM - Astro :4321]
        Mobile[Capcat Mobile App - Flutter]
        Admin[Capcat Admin Portal - Astro :4325]
    end

    subgraph CoinHub ["Capcat Coin Hub Microservice (:3005)"]
        API[NestJS REST API Controllers]
        OrderModule[Order & Gateway Module]
        WalletModule[Wallet & Ledger Module]
        QueueProducer[Webhook Ingestion Producer]
        QueueWorker[BullMQ Ledger Processor]
    end

    subgraph Storage ["Storage Layer"]
        Postgres[("PostgreSQL DB (COIN_HUB_DB)")]
        Redis[("Redis (BullMQ & Idempotency)")]
    end

    subgraph Gateways ["External Gateways"]
        ZaloPay[ZaloPay API & Webhook Server]
        MockGW[Internal Mock Gateway Simulator]
    end

    Web -->|Create Order / Spend| API
    Mobile -->|Create Order / Spend| API
    Admin -->|Reconcile & Packages| API

    API --> OrderModule
    API --> WalletModule
    OrderModule --> ZaloPay
    OrderModule --> MockGW

    ZaloPay -->|Webhook| API
    MockGW -->|Webhook| API
    API --> QueueProducer
    QueueProducer --> Redis
    Redis --> QueueWorker
    QueueWorker --> Postgres
    WalletModule --> Postgres
```

## 2. Relational Database Schema (PostgreSQL ERD)

```mermaid
erDiagram
    users ||--o{ wallets : "owns"
    users ||--o{ payment_orders : "places"
    wallets ||--o{ coin_transactions : "records"
    coin_packages ||--o{ payment_orders : "contains"

    users {
        uuid id PK
        string email UK "nullable"
        string phone UK "nullable"
        string status "ACTIVE | BLOCKED"
        timestamp created_at
        timestamp updated_at
    }

    wallets {
        uuid id PK
        uuid user_id FK
        string tenant_id "capcat | english_app"
        string currency_code "FISH | STAR"
        decimal balance "15,2"
        timestamp created_at
        timestamp updated_at
    }

    coin_packages {
        uuid id PK
        string tenant_id
        string name
        decimal amount_vnd
        decimal coin_amount
        int bonus_percentage
        boolean is_active
        int sort_order
    }

    payment_orders {
        uuid id PK
        uuid user_id FK
        uuid package_id FK
        string tenant_id
        decimal amount_vnd
        decimal coin_amount
        string gateway "ZALOPAY | MOCK"
        string status "PENDING | SUCCESS | FAILED | EXPIRED"
        string gateway_trans_id
        string idempotency_key UK
        text order_url
        text qr_code
        timestamp expires_at
    }

    coin_transactions {
        uuid id PK
        uuid wallet_id FK
        string tenant_id
        decimal amount
        decimal balance_before
        decimal balance_after
        string type "RECHARGE | SPEND | BONUS | MANUAL_CREDIT"
        string source_ref
        jsonb metadata
        timestamp created_at
    }
```
