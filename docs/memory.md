# System Memory and Constraints - DOCA FM Live Sync & Weather Integration

This document tracks known blockers, accepted assumptions, unresolved contradictions, and historical constraints for the live FM player and weather integrations.

## 1. Known Blockers
*   **None:** Supabase Storage is configured and accessible.

## 2. Accepted Assumptions
*   **Clock Synchronization:** We assume the user's system clock is synchronized via NTP (standard on modern OSes). A difference of 1-3 seconds in clocks is acceptable for ambient background music.
*   **Client Weather API Access:** We assume the client browser has outbound network access to `api.open-meteo.com`. If blocked, the player falls back to "trời mát mẻ" without blocking rendering.

## 3. Historical Constraints & Rules
*   **Active Host:** Tina is the active host of Doca FM. Make sure the avatar reflects Tina (e.g. 🐱 or custom cozy label).
*   **Design Aesthetics:** Soft glassmorphism cards, watercolor background, peeking cat.
*   **Icon Selection:** Phosphor Icons in `ph-light` weight standard.
*   **Content Voice:** Cozy, therapeutic, quiet Japanese novel style (Iyashikei) tone for Vietnamese copy.

## 4. TrustGraph Notes
*   **Status:** TrustGraph local cluster (Neo4j:7474) is offline.
*   **Action:** Falling back to filesystem storage and local planning artifacts under `docs/`.
