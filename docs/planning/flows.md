# System and User Flows - DOCA FM Live Sync & Weather Integration

This document details the user-facing and backend system flows for the live synchronized FM player, weather API fetching, and playlist rotation.

## 1. Client-Side Playlist & Weather Loading Flow

The sequence of actions when a user visits the website:

```mermaid
sequenceDiagram
    participant User as Site Visitor (Browser)
    participant Player as Cozy Audio Player
    participant Meteo as Open-Meteo API
    participant Storage as Supabase Storage
    
    User->>Player: Open Homepage (/)
    Par Load Playlist & Weather
        Player->>Storage: GET public/audio/playlist.json
        Storage-->>Player: Return tracks library & slots config
    and Load Weather (timeout 1.5s)
        Player->>Meteo: GET weather for coordinates (10.7222, 106.6783)
        Meteo-->>Player: Return WMO weather code & temperature
    End
    Player->>Player: Determine Active Slot (Morning/Afternoon/Evening)
    Player->>Player: Parse WMO code to Vietnamese description
    Player->>Player: Dynamically build Tina's Host Intro Text
    Player->>Player: Render Host Tina Card & Visual Playlist Schedule
```

---

## 2. Playback FM Synchronization Flow

When the user interacts with the music controls, playback is synchronized in real-time across all users:

```mermaid
sequenceDiagram
    participant User as Site Visitor
    participant Player as Cozy Audio Player
    participant Audio as HTML5 Audio Element
    
    User->>Player: Click Play button
    Player->>Player: Get Date.now() / 1000
    Player->>Player: Calculate playhead offset = currentEpoch % totalPlaylistDuration
    Player->>Player: Find active track and track-relative offset
    Player->>Audio: Set src = activeTrack.url
    Player->>Audio: Listen for 'loadedmetadata'
    Audio-->>Player: Metadata loaded
    Player->>Audio: Set currentTime = trackOffset
    Player->>Audio: Execute play()
    Player->>User: Play synchronized ambient jazz music
    
    Note over User,Player: Clicks on track list items are ignored (FM mode)
```

---

## 3. Failure & Recovery Flows

### Failure Mode 1: Open-Meteo Weather API is slow or offline
*   **Detection:** Fetch to `api.open-meteo.com` exceeds 1.5s or returns non-200.
*   **Mitigation:** The player catches the error and falls back to a default weather description ("trời mát mẻ"). Tina's introduction text compiles normally using this fallback, preventing UI breakages.

### Failure Mode 2: Client's clock is drift or off by minutes
*   **Detection:** High offset discrepancies.
*   **Mitigation:** We accept standard OS-level NTP drift (1-3s). If the clock is completely off, the music will still play correctly and loop locally, but the playhead synchronization will be offset relative to other users. No crash occurs.
