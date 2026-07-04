# Feature Specification: DOCA FM Live Curation and Contextual Storytelling

> Feature ID: `013-doca-fm-live-curation-and-contextual-storytelling`
> Created: `2026-07-04`
> Status: Active
> Source Prompt: Add FM-style shared playback, morning/afternoon/evening playlist rotation, Tina the cat host, and live weather weather-contextual introductions for Binh Hung, TP.HCM

## 1. Purpose
Upgrade the DOCA FM music player into a true shared-live FM experience. All visitors will hear the same track and position at any given moment. Track skipping and selection will be disabled. Playlists will rotate across three daily slots (Morning, Afternoon, Evening) containing 10-15 tracks. The host, Tina the Cat, will introduce the playlist using dynamic context (day, month, and live weather at Bình Hưng, HCMC) and present a Japanese-style titled story connecting the playlist tracks.

## 2. User Stories

*   **US-001 (Shared FM Playback):** As a user, I want the music to play in sync with everyone else without the ability to change or skip tracks, creating a shared communal ambient atmosphere.
*   **US-002 (3 Daily Playlists):** As a user, I want different music styles and themes depending on whether it is Morning (06:00-12:00), Afternoon (12:00-18:00), or Evening (18:00-06:00).
*   **US-003 (Tina the Host & Weather Context):** As a user, I want to read Tina's introduction cards which adapt dynamically to the day, month, and live weather in Bình Hưng, HCMC, making the app feel alive.
*   **US-004 (Japanese-Novel Story):** As a user, I want to read a story with a Japanese-novel style title explaining the curation selection.

## 3. Functional Requirements

*   `FR-001` (Synchronized FM): The system MUST compute playhead offset based on the current unix timestamp modulo the active playlist's total duration.
*   `FR-002` (Disable Skip/Select): The system MUST disable track selection and skipping. The player UI will only show a single Play/Pause toggle.
*   `FR-003` (3 Daily Slots): The active playlist MUST be determined by the local time:
    *   **Morning (Sáng):** 06:00:00 - 11:59:59 (10-15 tracks)
    *   **Afternoon (Chiều):** 12:00:00 - 17:59:59 (10-15 tracks)
    *   **Evening (Tối):** 18:00:00 - 05:59:59 (10-15 tracks)
*   `FR-004` (Weather Fetching): The frontend MUST fetch the current weather from the Open-Meteo API for coordinates `10.7222, 106.6783` (Bình Hưng, TP.HCM) with a 1.5s timeout.
*   `FR-005` (Dynamic Speech Builder): The system MUST construct Tina's intro text dynamically by inserting the current day of the week, the month, and the resolved weather condition into a localized template.
*   `FR-006` (Japanese-Novel Story): Every playlist configuration MUST include a `story_title` (written in Ghibli/Japanese light novel style) and `story` body.

## 4. Non-Functional Requirements

*   `NFR-001` (Aesthetics): Follow DOCA's Japanese Iyashikei tone guidelines and slim Phosphor icon standards (`ph-light`).
*   `NFR-002` (Robustness): If the Open-Meteo API is slow or offline, the player MUST fall back to a default weather description ("trời mát mẻ") and continue rendering the intro card without breaking.

## 5. Acceptance Criteria

*   `AC-001`: Given the user loads the page, when they click Play, the audio starts at the synchronized time offset (shared across all users).
*   `AC-002`: Given the user views the tracklist, when they click a track item, then direct play is ignored (tracklist acts as a display-only schedule).
*   `AC-003`: Given the local time is 08:30 AM, when the page is loaded, then the Morning playlist is selected.
*   `AC-004`: Given the host card is rendered, when the weather API resolves, then Tina's intro text contains the current weather (e.g. "nắng dịu" or "mưa rào").

## 6. Constraints

*   Coordinates: `10.7222, 106.6783`
*   No third-party CSS frameworks. Only vanilla CSS and Phosphor icons.
