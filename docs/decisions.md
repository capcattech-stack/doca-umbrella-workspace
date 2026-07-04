# Architectural Decisions (ADR) - DOCA FM Live Sync & Weather Integration

This document contains the Architecture Decision Records (ADRs) for the live synchronized FM player, coordinates, and weather integrations.

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
*   **Context:** We need to keep playback synchronized across all users without running a expensive WebSockets stream server or audio transcribing proxy.
*   **Decision:** Compute the shared playhead offset client-side using the system epoch timestamp modulo the total active playlist duration.
*   **Alternatives Rejected:** Live icecast/shoutcast server (rejected due to high hosting costs and complex setup).
*   **Consequences:** Extremely lightweight, cost-free, zero-setup synchronization. Playback is synced down to the second for all users whose system clocks are synchronized.

## ADR-005: Client-Side Open-Meteo Integration for Weather Context
*   **Context:** Tina's greetings need real-time weather at Bình Hưng, HCMC.
*   **Decision:** Fetch current weather conditions at page load using the client browser to call the Open-Meteo API (Latitude 10.7222, Longitude 106.6783).
*   **Alternatives Rejected:** Server-side cron job updating weather (rejected because browser-side fetch is instant, free, and represents the real-time weather at the moment the page is opened).
*   **Consequences:** Dynamic, live greetings. A 1.5s timeout is used so that if the weather API is down, the user experience is unaffected and falls back to default weather text.

## ADR-006: Tina as Doca FM Host
*   **Context:** Choosing which cat to host Doca FM.
*   **Decision:** Assign **Tina** as the primary radio host of DOCA FM, presenting her warm, literary light-novel style introductions.
