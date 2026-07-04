# Product Requirements Document (PRD) - DOCA FM Live Sync & Contextual Storytelling

## 1. Product Goal
The goal is to implement a synchronized, shared ambient FM radio experience ("DOCA FM") for pet owners (Sen) and pets (Boss). All visitors hear the exact same track at the exact same playhead position at any given moment, with manual track selection and skipping disabled. Playlists are rotated across three daily slots (Morning, Afternoon, Evening). The host, Tina the Cat, introduces each playlist with dynamic context (day, month, and live weather at Bình Hưng, HCMC) and shares a Japanese-style titled story about the music selections.

## 2. Problem Statement
A standard music player playing static playlists lacks the communal feel of a real-time radio broadcast. Furthermore, static messages can feel repetitive and cold. To align with DOCA's vision of a warm, comforting, and organic community space, the player needs to be synchronized in real-time across all users and adapt its host introductions dynamically using real-time weather and calendar data.

## 3. User Stories
*   **As a User (Sen):** I want to know that other pet owners and pets are listening to the exact same melody as me right now, creating a sense of shared calm.
*   **As a User (Sen):** I want to read Tina's daily radio host introductions that mention the real-time weather in HCMC, so that the radio feels live, cozy, and interactive.
*   **As a User (Sen):** I want to read Japanese-novel-style titled stories explaining the playlist curation to help me relax.

## 4. Functional Requirements
*   **`FR-001` (Synchronized FM Playback)**: The player MUST synchronize playback using the server/unix time modulo the active playlist's total duration.
*   **`FR-002` (Single-Control Player)**: The player MUST disable track-level skipping, pausing for all users, or track selection. The dropdown playlist acts strictly as a visual schedule.
*   **`FR-003` (3 Daily Playlist Slots)**: The system MUST automatically load the correct playlist based on the local time:
    *   **Morning (Sáng):** 06:00:00 - 11:59:59 (10-15 tracks)
    *   **Afternoon (Chiều):** 12:00:00 - 17:59:59 (10-15 tracks)
    *   **Evening (Tối):** 18:00:00 - 05:59:59 (10-15 tracks)
*   **`FR-004` (Weather Caching & Integration)**: The browser MUST fetch the current weather description for Bình Hưng, HCMC (coordinates `10.7222, 106.6783`) from Open-Meteo API.
*   **`FR-005` (Tina the Cat Host)**: The host card MUST feature Tina (instead of Mimi) and render her intro card with dynamic weather-aware greeting scripts.
*   **`FR-006` (Japanese-Novel Stories)**: Each playlist configuration MUST include a `story_title` (in Japanese novel translation style, e.g., "Khu Vườn Mưa Và Tiếng Bước Chân Mèo") and a text `story` detailing why these tracks were selected.

## 5. Non-Functional Requirements
*   **`NFR-001` (Aesthetics)**: The host card UI must use cozy microcopy and soft glassmorphism styles with Phosphor icons (`ph-light`).
*   **`NFR-002` (Robustness)**: Open-Meteo fetch calls must time out in 1.5 seconds and fall back to "trời mát mẻ" to ensure the page renders immediately.

## 6. Scope Boundaries
*   **In Scope:**
    *   Dynamic live FM playhead synchronization.
    *   Morning, Afternoon, Evening playlists (10-15 tracks each).
    *   Open-Meteo client-side weather API integration for Binh Hung.
    *   Host Tina card UI and Japanese novel titled stories.
*   **Out of Scope:**
    *   A live chat or voice broadcast stream.

## 7. Acceptance Criteria
*   **`AC-001`**: Given a user opens the page, when they play music, then the audio plays from the calculated synchronized position.
*   **`AC-002`**: Given the user opens the track dropdown, when they click a track item, then the click is ignored (no track selection).
*   **`AC-003`**: Given the hour is 14:00, when the page is loaded, then the Afternoon playlist is active.
*   **`AC-004`**: Given the host card is loaded, when the weather API resolves, then the text includes the current weather condition of Bình Hưng, TP.HCM.

## 8. Open Questions & Accepted Risks
*   **Accepted Risk:** Using a client-side weather API is dependent on the API's availability and the user's internet. The UI must fallback gracefully to default greetings in case of API failure.
