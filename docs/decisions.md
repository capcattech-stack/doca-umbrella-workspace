# Architectural Decisions (ADR) - DOCA FM & SSO Integration

This document contains the Architecture Decision Records (ADRs) for the live synchronized FM player and the client-side SSO authentication system.

## ADR-001: Media Storage in Supabase Storage vs. Git Repository
*   **Decision:** Move all audio files to public Supabase Storage bucket `audio`.
*   **Consequences:** Reclaimed ~150MB Git bloat, optimized streaming CDN performance.

## ADR-002: Storing Playlist Metadata in Supabase Storage (JSON) vs. Supabase Database Table
*   **Decision:** Store metadata in a single `playlist.json` file in Supabase Storage, loaded on client page load.
*   **Consequences:** Low latency (CDN cached), no database query cost at load time.

## ADR-003: US Military Works & Showa Jazz vs. 1920s Scratchy Archives
*   **Decision:** Use modern digital recordings by US Military Jazz Bands and pre-1976 Japanese Showa Jazz recordings for sweet, clean audio.
*   **Consequences:** 100% legal compliance, cozy digital-quality sound.

## ADR-004: Shared FM Playback Sync via Client Time Modulo
*   **Decision:** Compute the shared playhead offset client-side using the system epoch timestamp modulo the total active playlist duration.
*   **Consequences:** Extremely lightweight, cost-free, zero-setup synchronization.

## ADR-005: Client-Side Open-Meteo Integration for Weather Context
*   **Decision:** Fetch current weather conditions at page load using the client browser to call the Open-Meteo API.
*   **Consequences:** Dynamic, live greetings. A 1.5s timeout is used to fallback to "trời mát mẻ" if the API is down.

## ADR-006: Tina as Doca FM Host
*   **Decision:** Assign **Tina** as the primary radio host of DOCA FM, presenting her warm, literary light-novel style introductions.

## ADR-007: Client-side Supabase Auth Client Integration
*   **Context:** The website is a statically generated site (Astro SSG). We need user authentication without moving to a fully SSR server-side model which would increase hosting costs and latency.
*   **Decision:** Initialize and run the Supabase client SDK client-side. The session is managed browser-side via cookies/localStorage.
*   **Consequences:** Retains pure static site hosting compatibility (e.g. on Netlify/Vercel/VnHost) while granting secure OAuth workflows. Avoids Astro build-time compile failures by isolating SDK initialization to client-side scripts.

## ADR-008: Google and Zalo SSO Providers Integration
*   **Context:** Users need quick authentication options. Zalo is highly popular in Vietnam, while Google is universally supported.
*   **Decision:** Enable Google OAuth via Supabase's built-in provider dashboard. Enable Zalo OAuth as a custom OAuth2 Identity Provider inside Supabase's Custom Provider configuration.
*   **Consequences:** Provides a seamless login flow for local and global users. Zalo's authorization request is routed via `oauth.zaloapp.com` and exchanged via client redirections.

## ADR-009: Pet Profile Metadata Storage
*   **Context:** The profile page needs to save and render the user's pet details.
*   **Decision:** Store pet metadata inside Supabase Auth's `user_metadata` field (via `supabase.auth.updateUser()`) and cache it in browser `localStorage` for instant load.
*   **Alternatives Rejected:** Creating a separate `pets` PostgreSQL table (rejected because the current requirement is only a basic pet card section without relational lookups, making user-metadata the simplest, zero-database-maintenance choice).
*   **Consequences:** Highly portable, secure, zero database infrastructure changes required.

## ADR-010: Neutral Skeleton Authentication States
*   **Context:** On static pages, pre-rendered navigation bars will default to showing "Đăng nhập" (Guest state) before client-side JS finishes loading the active session, causing a visual flash.
*   **Decision:** Pre-render the login container as an invisible/skeleton block by default (`opacity: 0` or `.loading-state`), then dynamically transition to the Guest button or User capsule once the Supabase auth state finishes client-side initialization.
*   **Consequences:** Eliminates visual glitches (layout flash), resulting in a premium, fluid aesthetic feel.
