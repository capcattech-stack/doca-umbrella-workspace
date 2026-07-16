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
