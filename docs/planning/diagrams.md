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
