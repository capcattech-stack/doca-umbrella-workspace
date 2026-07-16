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

## Feature 015: Creator Kiosk & Curation
*   **Planning Date:** 2026-07-16
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Built the Creator Kiosk feature enabling dynamic store configuration on profile page, admin approval page on admin web, and catch-all SPA routing for user Kiosk views. Added auto-moderation for link type (Shopee only) and description text safety (offline bad words check matching family page design).
*   **Key Decisions:**
    *   *ADR-014:* Created new public tables `creator_kiosks` and `kiosk_links` with explicit RLS permissions for selective viewer read and creator manage rights.
    *   *ADR-015:* Implemented catch-all Single Page Application (SPA) routing in `kios_capcat_web` to route all subpaths `/{kios_name}` to `index.html` via Vercel rewrites, avoiding build-time static paths compilation.
    *   *ADR-016:* Adopted the zero-latency client-side text check mechanism (`checkTextSafety` blocklist) from `family.astro` for kiosk descriptions to ensure design consistency and fast UX.
    *   *ADR-017:* Decoupled Kiosk registration and configuration dashboard into its own route `/profile/kiosk` from `/profile`, adding dynamic CTAs on the Profile page based on active kiosk database status.

## Feature 016: Kiosk Details & Product Layout Alignment
*   **Planning Date:** 2026-07-16
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Added Shopee link details extraction, custom name/image editing, Kiosk Avatar settings, and redesigned Kiosk viewer layout to align with the product cards of doca-affiliate-web.
*   **Key Decisions:**
    *   *ADR-018:* Client-side regex parsing of Shopee link path slugs to pre-fill product names.
    *   *ADR-019:* Added Unsplash pet portraits and local product images as pre-configured quick selection options for Kiosk Avatar and Product Images.
    *   *ADR-020:* Client-side routing fallback via URLSearchParams `?kiosk=xxx` to bypass local Astro dev server routing limitations.

