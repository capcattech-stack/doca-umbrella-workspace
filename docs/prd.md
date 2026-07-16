# Product Requirements Document (PRD) - DOCA FM & SSO User Integration

## 1. Product Goal
*   **DOCA FM Live Sync**: Implement a synchronized, shared ambient FM radio experience for pet owners (Sen) and pets (Boss). All visitors hear the exact same track at the exact same playhead position at any given moment. Playlists are rotated across three daily slots (Morning, Afternoon, Evening) with dynamic introductions by Tina the Cat.
*   **SSO Login & User Profile**: Implement a client-side Single Sign-On (SSO) authentication system (supporting Google and Zalo OAuth) using Supabase Auth, along with a dedicated User Profile page (`/profile`) allowing users to see their personal information and manage their pets (Bosses) details.

## 2. Problem Statement
*   **DOCA FM**: A standard music player playing static playlists lacks the communal feel of a real-time radio broadcast.
*   **SSO & User Profile**: Visitors need a way to log in seamlessly without remembering passwords to access personal features like saving pet info. We need to implement this on a static Astro website (SSG) securely without adding server-side build blockages.

## 3. User Stories
### 3.1. DOCA FM
*   **As a User (Sen):** I want to know that other pet owners and pets are listening to the exact same melody as me right now, creating a sense of shared calm.
*   **As a User (Sen):** I want to read Tina's daily radio host introductions that mention the real-time weather in HCMC, so that the radio feels live, cozy, and interactive.
*   **As a User (Sen):** I want to read Japanese-novel-style titled stories explaining the playlist curation to help me relax.

### 3.2. SSO Login & User Profile
*   **As a User (Sen):** I want to log in using my Google or Zalo account so that I don't need to sign up for a new account.
*   **As a User (Sen):** I want my authenticated state to show clearly on the Navbar via an avatar and my name, replacing the generic "Đăng nhập" button.
*   **As a User (Sen):** I want to access a private `/profile` page to view my personal details and add my pets (Bosses) profiles.

## 4. Functional Requirements
### 4.1. DOCA FM Live Sync
*   **`FR-001` (Synchronized FM Playback)**: The player MUST synchronize playback using the server/unix time modulo the active playlist's total duration.
*   **`FR-002` (Single-Control Player)**: The player MUST disable track-level skipping, pausing for all users, or track selection. The dropdown playlist acts strictly as a schedule.
*   **`FR-003` (3 Daily Playlist Slots)**: The system MUST automatically load the correct playlist based on local time:
    *   Morning (Sáng): 06:00:00 - 11:59:59
    *   Afternoon (Chiều): 12:00:00 - 17:59:59
    *   Evening (Tối): 18:00:00 - 05:59:59
*   **`FR-004` (Weather Caching & Integration)**: The browser MUST fetch the current weather description for Bình Hưng, HCMC (coordinates `10.7222, 106.6783`) from Open-Meteo API.
*   **`FR-005` (Tina the Cat Host)**: The host card MUST feature Tina and render her intro card with dynamic weather-aware greeting scripts.
*   **`FR-006` (Japanese-Novel Stories)**: Each playlist configuration MUST include a `story_title` (in Japanese novel translation style) and a text `story` detailing why these tracks were selected.

### 4.2. SSO Login & User Profile
*   **`FR-007` (Supabase Client Integration)**: The system MUST integrate the Supabase JS client SDK client-side to manage sessions, configuration, and OAuth tokens.
*   **`FR-008` (SSO Providers Support)**: The system MUST offer Google and Zalo OAuth logins inside a modal overlay triggered by clicking the "Đăng nhập" button.
*   **`FR-009` (Dynamic Navigation Bar)**: The Navbar MUST dynamically update its right-hand controls based on auth state. Authenticated state shows user avatar/name capsule linking to `/profile`. Unauthenticated shows "Đăng nhập".
*   **`FR-010` (Private Profile Route)**: Access to `/profile` MUST be restricted to authenticated users. Guests trying to access it MUST be redirected to `/` within `0.5s`.
*   **`FR-011` (Pet Management)**: The profile page MUST allow users to view, add, and save pet profiles (name, species, age) to `localStorage` or `user_metadata` in Supabase.
*   **`FR-012` (Logout Action)**: Clicking "Đăng xuất" MUST destroy the active Supabase session and redirect the user back to the home page.

## 5. Non-Functional Requirements
*   **`NFR-001` (Aesthetics)**: The UI components must use cozy Muji minimalism styles, soft glassmorphism, watercolor palettes, and Phosphor icons (`ph-light` as default).
*   **`NFR-002` (Robustness)**: External API requests (weather, auth checks) must execute asynchronously and fail gracefully.
*   **`NFR-003` (Build Safety)**: All client-side dependencies (including `@supabase/supabase-js`) MUST be safely isolated to prevent build-time SSG compile failures in Astro.
*   **`NFR-004` (UX Transitions)**: Auth state changes must fade in smoothly to prevent jarring page layout flashes.

## 6. Scope Boundaries
*   **In Scope:**
    *   Dynamic live FM playhead synchronization.
    *   Morning, Afternoon, Evening playlists.
    *   Client-side weather fetch fallback.
    *   Client-side Supabase authentication with Google and Zalo SSO.
    *   Static `/profile` layout with localStorage pet profiles.
*   **Out of Scope:**
    *   Database-backed global pet sharing community feed.
    *   Real-time chat or voice stream broadcasts.

## 7. Acceptance Criteria
*   **`AC-001`**: Given a user opens the page, when they play music, then the audio plays from the calculated synchronized position.
*   **`AC-002`**: Given the user opens the track dropdown, when they click a track item, then the click is ignored (no track selection).
*   **`AC-003`**: Given the host card is loaded, when the weather API resolves, then the text includes the current weather condition of Bình Hưng, TP.HCM.
*   **`AC-004`**: Given a guest clicks "Đăng nhập" and selects Google, they are redirected to Google's authentication page, and redirected back as a logged-in user.
*   **`AC-005`**: Given a guest navigates to `/profile`, they are immediately redirected to the home page `/`.
*   **`AC-006`**: Given a logged-in user clicks "Đăng xuất", their session is cleared and the Navbar reverts to showing the "Đăng nhập" button.

## 8. Open Questions & Accepted Risks
*   **Client-side session dependency**: Since this website is static, session validation is handled on the client. We accept the small delay in establishing auth state when page loads, mitigated by skeleton loading states to prevent layout shifts.
