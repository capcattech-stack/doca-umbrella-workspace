# Antigravity Agent Memory - DOCA FM Live Curation

## Feature 013: DOCA FM Live Sync & Weather Curation
*   **Planning Date:** 2026-07-04
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Upgraded the DOCA FM music player into a synchronized FM experience. All visitors hear the same track and position in real-time. Created Morning, Afternoon, and Evening slots. Integrated Open-Meteo weather API for coordinates `10.7222, 106.6783` (Bình Hưng, HCMC) and mapped dynamic host introductions by Tina.
*   **Key Decisions:**
    *   *ADR-004:* Client-side epoch modulo calculations for FM sync.
    *   *ADR-005:* Open-Meteo unauthenticated Weather API integration.
    *   *ADR-006:* Host assigned as Tina with Japanese novel titled stories.
    *   *ADR-007:* Added weather caching (`sessionStorage` 30-min TTL) and forecast comparison commentary (e.g., predicting rain or temperature drops) to remove API load latency.

## Feature 014: SSO Login & User Profile
*   **Planning Date:** 2026-07-06
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Implemented the client-side Google OAuth login flow using Supabase Auth, dynamic Navbar state updates (displaying login button or circular avatar), form email auto-fill logic (with dynamic Google quick connect circular button insertion and read-only verified badge), and a minimalist `/profile` page with simple layout and logout functionality.
*   **Key Decisions:**
    *   *ADR-007:* Client-side Supabase client initialization to preserve static SSG.
    *   *ADR-008:* Google as default built-in OAuth provider (Zalo integration deferred for future enhancement).
    *   *ADR-009:* Embedded Google quick-connect circular button on email inputs for smooth frictionless OAuth trigger, turning them into read-only verified fields.
    *   *ADR-010:* Skeleton rendering of navbar login container to eliminate layout flash, controlled globally through Layout.astro.
    *   *ADR-011:* Tinh giản nút kết nối Google trên Navbar thành hình tròn 32px đồng bộ kích thước/vị trí với Avatar và dùng logo Google 4 màu để tiết kiệm không gian.
    *   *ADR-012:* Giải quyết lỗi form reset làm rỗng email đã điền thông qua thuộc tính defaultValue và bổ sung reset event listener trên Form cha.
    *   *ADR-013:* Cấu trúc lại trang /profile, di chuyển liên kết .back-link ra ngoài lề trái để đồng bộ bố cục hoàn hảo với trang Quiz, Blog và About Us.


