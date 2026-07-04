# Implementation Task List - DOCA FM Live Curation & Weather Integration

This list details the work steps to implement the live synchronized FM player, morning/afternoon/evening rotation, Open-Meteo weather API integration, and Host Tina cards.

## Task Breakdown

### TSK-021: Define 3 Daily Playlists & Sync Script
*   **ID:** `TSK-021`
*   **Owner:** `alan-tech-lead`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `/Users/ricyuan/CAPCAT/doca-affiliate-web/scripts/sync_music.py`
*   **Dependencies:** None
*   **Description:** Update `sync_music.py` to:
    1. Organize the 10 curated tracks (plus some additional pre-verified tracks) to populate 3 daily playlists (Morning, Afternoon, Evening).
    2. Add `story_title` (Japanese-novel style) and `story` content for each of the 3 playlists.
    3. Run the script to upload the structured configuration to `playlist.json` on Supabase Storage.
*   **Verification Method:**
    *   Execute `python3 doca-affiliate-web/scripts/sync_music.py`.
    *   Verify `playlist.json` has `morning`, `afternoon`, and `evening` configurations.

---

### TSK-022: Implement Shared FM Sync & Host Tina with Weather API
*   **ID:** `TSK-022`
*   **Owner:** `benny-frontend-engineer`
*   **Parallel-Safe:** `Yes` [P]
*   **Write Scope:** `/Users/ricyuan/CAPCAT/doca-affiliate-web/src/pages/index.astro`
*   **Dependencies:** `TSK-021`
*   **Description:** Modify the Cozy Audio Player in `index.astro` to:
    1. Fetch `playlist.json` and resolve the active playlist:
       * Morning (Sáng): 06:00 - 12:00
       * Afternoon (Chiều): 12:00 - 18:00
       * Evening (Tối): 18:00 - 06:00 (next day)
    2. Synchronize playback playhead: compute `Math.floor(Date.now() / 1000) % totalDuration` to set the starting audio offset.
    3. Disable track selection/skipping. Make list click-to-play inactive.
    4. Fetch live weather for Bình Hưng (`10.7222, 106.6783`) from Open-Meteo API.
    5. Construct Host Tina's greetings dynamically, blending the current month, day of week, and weather description.
    6. Style the Host Card for Tina with her avatar (`🐱` or custom emoji) and the Japanese novel titled stories.
*   **Verification Method:**
    *   Run `npm run dev` and open `http://localhost:4321/`.
    *   Confirm the correct slot playlist loads and plays at a synced offset.
    *   Verify Tina's intro card renders the month, day, and live weather correctly.

---

### TSK-023: Execute E2E Verification
*   **ID:** `TSK-023`
*   **Owner:** `ada-qa-agent`
*   **Parallel-Safe:** `No`
*   **Dependencies:** `TSK-021`, `TSK-022`
*   **Description:** Run a complete integration check, verify Open-Meteo failure fallback, and confirm no TypeScript compilation errors occur.
*   **Verification Method:**
    *   Run `npm run build` and ensure compilation is error-free.
    *   Verify the player controls operate correctly and show a single play/pause button.
