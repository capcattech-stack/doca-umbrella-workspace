# Screen Inventory and UI States - DOCA FM Live Sync & Weather Integration

This document details the UI design, states, and accessibility details for the Cozy Audio Player and Host Tina card.

## 1. Screen Inventory & Route Map

*   **Route:** `/` (Home Page)
*   **Widget Location:** Floating Cozy Player at the bottom right corner (desktop) or sticky bottom bar (mobile).
*   **Host Card Location:** Displayed inside the expanded playlist dropdown, positioned right above the track list.
*   **Playlist Schedule View:** The list of tracks below the Host Card acts as a visual schedule, indicating what songs are in the current loop.

---

## 2. Widget UI States

### 2.1. Initial / Loading State
*   **Visuals:** Player displays "Đang kết nối đài FM...". The vinyl disc is stationary.
*   **Logic:** Triggered while both `playlist.json` (from Supabase) and the current weather (from Open-Meteo) are being fetched.

### 2.2. Active Synced State (Paused)
*   **Visuals:** Displays the current active track name. Play icon is visible.
*   **Host Card (Tina):**
    *   Displays Tina's name: "Tina 🐾 (Doca FM Host)"
    *   Displays the active slot theme badge (e.g. "Nắng Sớm Bên Hiên ☕" for Morning).
    *   Displays the dynamic introduction message blending date, month, and live weather.
    *   Displays the Japanese novel titled story toggle.

### 2.3. Active Synced State (Playing)
*   **Visuals:** Displays current track. Pause icon is visible. The vinyl disc rotates slowly. The green status dot on Tina's avatar pulses.
*   **Logic:** Syncs currentTime to client time modulo active playlist duration.

### 2.4. Expanded Story State
*   **Visuals:** Clicking "Đọc câu chuyện hôm nay" slides down a warm paper-like panel displaying:
    *   A stylized Japanese-novel title in bold, italic text (e.g., *“Khu Vườn Mưa Và Tiếng Bước Chân Mèo”*).
    *   The story description text explaining why the music was selected.

---

## 3. Keyboard & Responsive Constraints

*   **Touch Targets:** All interactive controls (Play/Pause button, Playlist toggle, "Read story" link) have a minimum touch target size of `44x44px`.
*   **Disabled Clicks:** Track items in the schedule list are visual-only. Clicking them is ignored, and cursor styles are set to default (not pointer) to prevent confusing the user. A small label "Đang phát trực tiếp" or clock icon replaces individual play icons.
