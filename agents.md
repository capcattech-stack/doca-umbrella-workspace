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

## Feature 017: Cozy Light Kiosk Dashboard & Fast Creation
*   **Planning Date:** 2026-07-16
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Redesigned the Kiosk addition dashboard to a light-themed design (Cozy Cloud/Paper) and transitioned the added link lists into a beautiful grid of mini product cards. Implemented a double-layered metadata extractor using Vercel Serverless scraping API combined with client-side fallback image/title mapper.
*   **Key Decisions:**
    *   *ADR-021:* Transformed dark container styling into light mode (Cozy Cloud `--cozy-bg-pure` background, Matcha and Charcoal accents) for a cleaner, unified healing look.
    *   *ADR-022:* Remapped added product layout to a responsive CSS grid displaying dynamic custom product cards with hover effects and red trash actions.
    *   *ADR-023:* Bypassed Astro server-side compiler error (`kiosk is not defined`) using span placeholders populated programmatically on client-side setup.
    *   *ADR-024:* Implemented double-layered scraping strategy: Layer 1 calls Vercel serverless scraper endpoint with Scraper API proxy; Layer 2 falls back client-side to slug regex parsing and keyword-to-image Unsplash mapping.

## Feature 018: Kiosk Grid Layout Alignment & Client-side Pagination
*   **Planning Date:** 2026-07-17
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Aligned Kiosk viewer product grid with doca-affiliate-web (5 columns on desktop, 2 columns on mobile, 3 columns on tablet). Added client-side pagination displaying 10 products per page with smooth scroll-up transitions and styled page buttons matching the Matcha forest theme.
*   **Key Decisions:**
    *   *ADR-025:* Swapped `.polaroid-grid` layout for responsive `.products-grid` matching global styling.
    *   *ADR-026:* Implemented client-side pagination DOM manipulation hiding/showing active page cards.
    *   *ADR-027:* Integrated a localhost mock data duplicator (15 test products) specifically for the "test" kiosk to ease local UI testing.

## Feature 019: Kiosk Bio & Multiple Social Links Integration
*   **Planning Date:** 2026-07-17
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Integrated customizable bios (up to 150 characters) and multiple social channel links (YouTube, TikTok, Facebook, Instagram) into Kiosk. Upgraded the Creator settings dashboard into a consolidated settings form and redesigned Kiosk header to display bio quotes and circular social icons.
*   **Key Decisions:**
    *   *ADR-028:* Extended Supabase `creator_kiosks` table with `bio` (TEXT) and `social_links` (JSONB) columns.
    *   *ADR-029:* Unified settings controls in `kiosk.astro` saving avatar, bio, and social object payload under a single database transaction.
    *   *ADR-030:* Redesigned viewer header in `index.astro` to render an inline group of minimal social icons with backward compatibility for the legacy `kiosk.channel` link.

## Feature 020: Kiosk Dashboard Clean Redesign & Bottom Sheet Add Product
*   **Planning Date:** 2026-07-17
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Redesigned Kiosk settings dashboard by moving the Shopee product addition form and live preview from the main screen into a smooth, animated Bottom Sheet (which scales into a centered Modal on desktop view). Added a green Matcha CTA "Thêm sản phẩm" trigger in the header of the product list to open the sheet.
*   **Key Decisions:**
    *   *ADR-031:* Moved raw form wrapper into fixed overlay container `#kiosk-add-product-sheet` to isolate layout constraints.
    *   *ADR-032:* Controlled background body scroll lock (`overflow: hidden`) during sheet activation to prevent double scrolling.
    *   *ADR-033:* Implemented auto-close sheet trigger and form reset actions inside the post-submission success callback block.
    *   *ADR-034:* Aligned settings product list grid and pagination (5 columns desktop, 2 columns mobile, 10 items per page) client-side to synchronize UI consistency with Kiosk viewer page.

## Feature 021: Shopee API Scraper & Local Product Image Upload
*   **Planning Date:** 2026-07-17
*   **Status:** Success (Fully Implemented & Verified)
*   **Description:** Resolved Shopee image scraping issues by upgrading serverless functions with internal Shopee API support (bypassing cors block) and implementing a local file upload mechanism for products.
*   **Key Decisions:**
    *   *ADR-035:* Extracted shopid and itemid using serverless regex routing, requesting Shopee internal API directly or fallback through corsproxy.io.
    *   *ADR-036:* Refined UX by replacing input listener debounce scraper with a manual "Kiểm tra" button, auto-checking links before link database insertion if title or image fields are blank.
    *   *ADR-037:* Added device file upload support on product creation page, resizing selected images to 300x300 pixels (JPEG 0.85) using hidden HTML5 Canvas to keep db storage footprint minimal.

