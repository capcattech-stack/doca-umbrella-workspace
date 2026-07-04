# Feature Specification: Project Planning - DOCA FM Curation and Presentation

> Feature ID: `012-project-planning-doca-fm-curation-and-presentation`
> Created: `2026-07-04`
> Status: Active
> Source Prompt: Add metadata labelling, daily playlists with theme, story, and voice-over introductions to DOCA FM

## 1. Purpose
Implement a cozy, healing, retro-style radio experience ("DOCA FM") for pet owners (Sen) and pets (Boss). In addition to playing copyright-safe, high-quality jazz tracks, the player will present daily curated playlists. Each playlist will rotate daily, featuring a specific theme, a heartwarming story, and an attractive introduction (matching the tone of a cozy radio host).

## 2. User Stories

*   **US-001 (Daily Theme):** As a user, I want the DOCA FM player to display a different, beautiful theme every day (e.g., "Morning Warmth", "Rainy Cat Cafe") so that the music fits the daily mood.
*   **US-002 (Storytelling & Host Intro):** As a user, I want to read a short, cozy story and a "radio host introduction" for today's playlist so that I feel a sense of healing and warmth.
*   **US-003 (Metadata Labeling):** As a content curator, I want the music tracks to be tagged with metadata (`mood`, `vibe`, `tempo`) so that they can be easily segmented and selected for playlists.

## 3. Functional Requirements

*   `FR-001`: The system MUST support metadata labeling for audio tracks (e.g., `mood`, `vibe`, `tempo`, `artist`, `title`, `duration`).
*   `FR-002`: The system MUST store a configuration of 7 daily playlists (one for each day of the week), each containing:
    *   `title`: The theme name (e.g., "Góc Nhỏ Chiều Mưa").
    *   `story`: A cozy, therapeutic story about pets and healing.
    *   `intro`: A short, host-like spoken/written introduction (e.g., "Sen ơi, ngoài kia trời đang mưa đấy...").
    *   `tracks`: A list of track references matching the day's mood.
*   `FR-003`: The website player MUST fetch this configuration and dynamically display the active playlist's title, story description, and host introduction card based on the current day of the week.
*   `FR-004`: The frontend MUST render the host introduction card with cozy, premium styling (e.g., a warm, card layout with a radio host avatar, typing or floating micro-animations).

## 4. Non-Functional Requirements

*   `NFR-001` (Aesthetics): The UI must feel extremely premium, warm, and cozy (adhering to DOCA's Japanese Iyashikei healing theme).
*   `NFR-002` (Performance): The playlist JSON must load asynchronously within 300ms without blocking page render.
*   `NFR-003` (Maintainability): Playlist configurations must be stored in a single JSON file (`playlist.json`) on Supabase Storage so that they can be easily updated without redeploying the frontend.

## 5. Acceptance Criteria

*   `AC-001`: Given the user visits `http://localhost:4321/`, when the player loads, it displays the correct daily playlist title (e.g., "Hoàng Hôn Bình Yên" on Saturday) and its corresponding cozy introduction.
*   `AC-002`: Given the music sync script runs, when it writes `playlist.json`, it includes 7 daily playlist blocks with mood tags, stories, and host introductions.
*   `AC-003`: Given the user clicks the playlist dropdown, when it expands, they see only the tracks assigned to today's active playlist.

## 6. Clarifications

All high-impact requirements have been clarified. 
*   *Ambiguity Accepted:* We will use written introductions (cozy host speech text cards) instead of actual spoken audio files to keep page loading fast and lightweight.

## 7. Constraints

*   Existing files or modules in scope: [index.astro](file:///Users/ricyuan/CAPCAT/doca-affiliate-web/src/pages/index.astro), [sync_music.py](file:///Users/ricyuan/CAPCAT/doca-affiliate-web/scripts/sync_music.py).
*   Must follow: Workspace-scoped rules (Phosphor icons, light weight, cozy microcopy).

## 8. Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Supabase request fails or is slow | Low (Player displays empty or broken playlist) | Fallback to a hardcoded local daily playlist structure in client-side Javascript. |

## 9. Traceability

| Requirement | Plan Section | Tasks | Verification |
| --- | --- | --- | --- |
| `FR-001`, `FR-002` | Proposed Changes -> sync_music.py | TSK-011 | Check Supabase Storage playlist.json |
| `FR-003`, `FR-004` | Proposed Changes -> index.astro | TSK-012 | Verify UI in browser |
