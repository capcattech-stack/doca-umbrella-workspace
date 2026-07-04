# Architecture Knowledge Base - DOCA FM Live Sync & Weather Integration

This document details the technical standards, API integrations, and constraints established for the live synchronized FM player, coordinates, and weather integrations.

## 1. Tech Stack & APIs
*   **Weather API:** Open-Meteo Forecast API (unauthenticated, free for non-commercial use).
    *   **Endpoint:** `https://api.open-meteo.com/v1/forecast?latitude=10.7222&longitude=106.6783&current=temperature_2m,weather_code`
    *   **Bình Hưng, Bình Chánh, HCMC Coordinates:** Latitude `10.7222`, Longitude `106.6783`.
*   **Media Storage:** Supabase Storage (public bucket `audio`).
*   **Web Framework:** Astro (v4.16) SSG. Client-side JS fetches and streams the playlist and weather at runtime.

## 2. Naming and UI Standards
*   **Active Host:** **Tina** (one of the 3 cats of Doca).
*   **Icon Library:** **Phosphor Icons** (`ph-light` weight standard).
*   **Playlist Slots:**
    *   Morning (Sáng): `06:00` - `12:00` (6:00 AM - 11:59:59 AM)
    *   Afternoon (Chiều): `12:00` - `18:00` (12:00 PM - 5:59:59 PM)
    *   Evening (Tối): `18:00` - `06:00` (6:00 PM - 5:59:59 AM next day)
*   **Japanese Novel Title:** Every playlist configuration must contain a `story_title` field (e.g. "Khu Vườn Mưa Và Tiếng Bước Chân Mèo" - Japanese light-novel translation style).

## 3. Mathematical Real-Time FM Synchronization
To make sure all users hear the same track at the same time:
1.  Sum the durations of all tracks in the active playlist to get `totalDuration` in seconds.
2.  Get the current epoch timestamp in seconds: `const now = Math.floor(Date.now() / 1000);`
3.  Compute the playlist playhead offset: `const playlistOffset = now % totalDuration;`
4.  Find the active track `i` where `playlistOffset >= track[i].start` and `playlistOffset < track[i].start + track[i].duration`.
5.  The local track playhead position is: `const trackOffset = playlistOffset - track[i].start;`
6.  Set `audio.currentTime = trackOffset` and call `audio.play()`.

## 4. "Never Do" List
*   **NEVER** allow users to select or skip tracks. The dropdown is strictly a schedule view.
*   **NEVER** hardblock the UI waiting for the weather API. The Open-Meteo call must timeout in 1.5 seconds, defaulting to a fallback description ("trời mát mẻ") if it fails or lags.

## 5. Open-Meteo Weather Codes Mapping
We map the Open-Meteo WMO weather codes to Vietnamese descriptions:
*   `0`: "trời trong xanh"
*   `1, 2, 3`: "trời mây nhẹ, mát mẻ"
*   `45, 48`: "trời sương mù nhẹ"
*   `51, 53, 55`: "mưa phùn nhè nhẹ"
*   `61, 63, 65`: "trời mưa rào"
*   `71, 73, 75`: "trời lạnh mát" (mưa tuyết - không xảy ra ở HCMC nhưng giữ làm fallback)
*   `80, 81, 82`: "mưa giông bất chợt"
*   `95, 96, 99`: "sấm chớp bão bùng"
*   *Default (Bình Hưng):* "trời mát mẻ"
