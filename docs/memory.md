# System Memory and Constraints - DOCA FM & SSO Integration

## 1. Known Blockers
*   **None:** Supabase Auth is enabled on the configured project dashboard (`fkilmtcjyommdbtogmeo.supabase.co`).

## 2. Accepted Assumptions
*   **Clock Synchronization (FM)**: We assume the user's system clock is synchronized via NTP. A difference of 1-3 seconds in clocks is acceptable.
*   **Browser Storage Access (SSO)**: We assume the client browser has `localStorage` and `cookie` permissions enabled. If cookies are disabled, authentication sessions might fail to persist across page reloads.
*   **Redirection Configuration**: We assume the allowed redirect URLs in the Supabase Dashboard include:
    *   `http://localhost:4321/` (Affiliate Web Dev Port)
    *   `http://localhost:4321/profile`
    *   Production domains once deployed.

## 3. Historical Constraints & Rules
*   **Active Host**: Tina is the active host of Doca FM.
*   **Design Aesthetics**: Soft glassmorphism cards, watercolor background, peeking cat.
*   **Icon Selection**: Phosphor Icons in `ph-light` weight standard as default, `ph-thin` for minimal elements, `ph-fill` or `ph-duotone` for active states.
*   **Content Voice**: Cozy, therapeutic, quiet Japanese novel style (Iyashikei) tone for Vietnamese copy.

## 4. TrustGraph Notes
*   **Status**: TrustGraph local cluster (Neo4j:7474) is offline.
*   **Action**: Falling back to filesystem storage and local planning artifacts under `docs/`.
