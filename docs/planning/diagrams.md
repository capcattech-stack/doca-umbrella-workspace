# Architectural Diagrams - DOCA FM Live Sync & Weather Integration

This document houses the structural, data, and behavioral diagrams for the live synchronized FM player and weather integrations.

## 1. C4 Container Diagram

The high-level architecture of the website media integration:

```mermaid
graph TD
    User([Site Visitor])
    
    subgraph Client [Client-Side Browser]
        Astro[Astro Web App]
        Player[Cozy Audio Player Widget]
        HostCard[Cozy Host Tina Card UI]
    end
    
    subgraph Supabase [Supabase Cloud Platform]
        Storage[(Supabase Storage Bucket: 'audio')]
    end
    
    subgraph OpenMeteo [Open-Meteo Weather Platform]
        Meteo_API[Open-Meteo Forecast API]
    end
    
    subgraph Wikimedia [Wikimedia Commons Platform]
        WM_API[Commons Media Search & Metadata API]
        WM_S3[Commons Media Upload Servers]
    end
    
    subgraph ScriptEnv [Python Execution Environment]
        SyncScript[sync_music.py Script]
    end
    
    User -->|Visits /| Astro
    Player -->|1. Fetches playlist.json| Storage
    Player -->|2. Streams MP3/OGG tracks| Storage
    Player -->|3. Fetches weather| Meteo_API
    HostCard -->|Displays dynamic greeting| Player
    
    SyncScript -->|1. Queries media metadata| WM_API
    WM_API -->|Direct Download| WM_S3
    SyncScript -->|2. Uploads audio & playlist.json| Storage
```

---

## 2. Data Model Diagram

The structure of the `playlist.json` metadata model showing the 3 slots:

```mermaid
classDiagram
    class PlaylistConfig {
        +Track[] tracks
        +SlotsConfig playlists
    }
    class Track {
        +String id
        +String title
        +String artist
        +String url
        +Integer duration
        +String vibe
        +String tempo
    }
    class SlotsConfig {
        +DailySlots 0
        +DailySlots 1
        +DailySlots 2
        +DailySlots 3
        +DailySlots 4
        +DailySlots 5
        +DailySlots 6
    }
    class DailySlots {
        +PlaylistSlot morning
        +PlaylistSlot afternoon
        +PlaylistSlot evening
    }
    class PlaylistSlot {
        +String title
        +String story_title
        +String story
        +String intro
        +String[] tracks
    }
    PlaylistConfig --> Track : contains all tracks
    PlaylistConfig --> SlotsConfig : contains slots config
    SlotsConfig --> DailySlots : maps days (0-6)
    DailySlots --> PlaylistSlot : contains morning, afternoon, evening
```

---

## 3. Audio Player Lifecycle State Diagram

The lifecycle of the Cozy Audio Player widget including the daily host card:

```mermaid
stateDiagram-v2
    [*] --> Loading : Initialize Player
    Loading --> Loaded : fetch(playlist.json) Success
    Loading --> Fallback : fetch(playlist.json) Fails
    
    Loaded --> LoadWeather : Fetch Open-Meteo Weather
    Fallback --> LoadWeather : Fetch Open-Meteo Weather
    
    LoadWeather --> ResolvedActiveSlot : Resolve Current Time Slot
    
    ResolvedActiveSlot --> Paused : Render Host Card & Tracks
    
    state Paused {
        [*] --> Idle
        Idle --> StoryExpanded : Click "Read Story"
        StoryCollapsed --> Idle : Collapse Story
    }
    
    Paused --> Playing : Click Play
    Playing --> Paused : Click Pause
    Playing --> Playing : Track Ends (Auto-select next track in loop)
    Playing --> Error : Stream Error
    Error --> Paused : Load fallback track
```

---

## 4. Observability & Telemetry Map

We track player interactions in Google Analytics 4 (GA4) as defined in our analytics integration:

```mermaid
graph LR
    Play[Click Play] -->|GA4 Event| play_fm_radio
    Pause[Click Pause] -->|GA4 Event| pause_fm_radio
    Expand[Open Playlist] -->|GA4 Event| expand_playlist_dropdown
```
