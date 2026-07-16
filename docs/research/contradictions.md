# Contradictions and Resolutions

This document tracks conflicting requirements or design patterns discovered during planning, along with their resolution and accepted risks.

## Contradiction 1: Static Playlist Compilation vs. Real-Time Dynamic Database

*   **Topic:** Music playlist storage and serving architecture.
*   **Conflict:** 
    *   **Source A:** `06_DATABASE_DESIGN.md` establishes a database-driven design where Supabase PostgreSQL handles dynamic site data.
    *   **Source B:** The existing website code in [index.astro](file:///Users/ricyuan/CAPCAT/doca-affiliate-web/src/pages/index.astro) relies heavily on static compilations at build-time (Astro SSG) for extreme performance.
*   **Practical Impact:** Fetching the playlist from a database table on every page load adds runtime latency. However, hardcoding it in the static site means any changes to the playlist require rebuilding and redeploying the entire website.
*   **Resolution:** 
    *   We will store the playlist metadata as a JSON file (`playlist.json`) hosted inside the **public Supabase Storage bucket** alongside the audio files.
    *   The sync script will upload this `playlist.json` dynamically when syncing new tracks.
    *   The client-side player on [index.astro](file:///Users/ricyuan/CAPCAT/doca-affiliate-web/src/pages/index.astro) will fetch this file at runtime via `fetch()`.
    *   This gives us the best of both worlds: zero database query overhead, real-time playlist updates without rebuilding the site, and simple static architecture.

## Contradiction 2: Full Track Playback vs. 30-Second Preview Limit

*   **Topic:** Audio playback duration constraint.
*   **Conflict:**
    *   **Source A:** `PRD_MASTER_SHELF.md` states: *"Không phát nhạc đầy đủ: Ứng dụng tuyệt đối không hỗ trợ nghe trọn vẹn cả bài hát. Bản thử âm nhạc tối đa chỉ phát 30 giây (preview)."*
    *   **Source B:** `2026-05-29_MOM_Cozy_Chat_Resonance_Engine.md` states that for the relaxation area, *"nhạc phát sẽ hoàn toàn là Nhạc cổ điển thuộc phạm vi công cộng (Public Domain) hoặc nhạc Lofi không bản quyền đã mua đứt... giúp Sen vẫn có không gian thư giãn 100% trọn vẹn."*
*   **Practical Impact:** Clarifying whether the home page player should restrict play to 30 seconds or play full songs.
*   **Resolution:**
    *   The **30-second preview limit** is a legal constraint that applies only to **promotional artist music/vinyls** in the DOCA Corner (which are copyrighted commercial songs redirecting to Spotify).
    *   For the **ambient background music player** on the homepage, the website is allowed to play full-length tracks because they are **Public Domain or Royalty-Free** with no copyright restrictions.

## Contradiction 3: Client-Side Auth State vs. Static Page Pre-rendering

*   **Topic:** How to display the user's logged-in status on statically generated pages (SSG) without layout flashes.
*   **Conflict:**
    *   **Source A:** Astro pre-renders HTML at build-time (SSG), which means the navigation bar defaults to pre-rendered HTML matching the Guest state (i.e. showing the "Đăng nhập" button).
    *   **Source B:** The client-side Supabase client asynchronously loads the active session state from LocalStorage after the page mounts on the browser.
*   **Practical Impact:** When a logged-in user visits the site, they will see the "Đăng nhập" button for a fraction of a second before it flashes and switches to the User Capsule (Avatar & Name). This creates a jarring visual glitch.
*   **Resolution:**
    *   To prevent layout flash, the pre-rendered HTML for the login control will render a **neutral skeleton capsule** or hide the auth block entirely by default (`opacity: 0` or a loading skeleton).
    *   The client-side script will detect the auth state immediately on mount and trigger a fade-in animation for either the login button or the user capsule. This ensures smooth visual transitions without a noticeable flash.
