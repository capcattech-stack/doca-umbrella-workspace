# System and User Flows - DOCA FM & SSO Integration

This document details the user-facing and backend system flows for the live synchronized FM player and the client-side SSO authentication system.

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

When the user interacts with the music controls, playback is synchronized in real-time:

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
```

---

## 3. SSO Login Redirection & Callbacks Flow

When a user clicks "Đăng nhập" and selects an SSO provider:

```mermaid
sequenceDiagram
    participant User as User
    participant App as Website (Astro Client)
    participant Sub as Supabase Auth SDK
    participant OAuth as OAuth Provider (Google/Zalo)
    
    User->>App: Click 'Đăng nhập'
    App->>App: Render Modal Overlay
    User->>App: Click 'Google' or 'Zalo'
    App->>Sub: signInWithOAuth(provider)
    Sub->>OAuth: Redirect user to OAuth authorization page
    User->>OAuth: Authenticate & authorize app permissions
    OAuth->>App: Redirect back to site with code (e.g. /#access_token=...)
    App->>Sub: Auto-detect hash/query parameter and parse session
    Sub->>App: Emit AUTH_STATE_CHANGE (Signed In)
    App->>User: Render signed-in Navbar capsule & enable Profile access
```

---

## 4. Navigation Bar Auth Synchronization Flow

On page mount, the Navbar establishes the authentication capsule:

```mermaid
sequenceDiagram
    participant Browser as Browser
    participant Nav as Navbar Script
    participant Sub as Supabase Client
    
    Browser->>Nav: DOMContentLoaded Event
    Nav->>Nav: Render invisible/skeleton auth capsule (prevent layout flash)
    Nav->>Sub: Get current active session (from LocalStorage/Cookie)
    alt Session exists (User Logged In)
        Sub-->>Nav: Return Session user metadata
        Nav->>Nav: Build avatar & name capsule linking to /profile
        Nav->>Nav: Fade in User Capsule
    else No Session (Guest User)
        Sub-->>Nav: Return null
        Nav->>Nav: Build "Đăng nhập" button
        Nav->>Nav: Fade in Guest Button
    end
```
