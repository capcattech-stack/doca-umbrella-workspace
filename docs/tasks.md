# Implementation Task List - DOCA Live Curation & SSO User Integration

This list details the work steps to implement the live synchronized FM player, coordinates weather integration, and the client-side SSO authentication & profile page.

## Task Breakdown

### TSK-021: Define 3 Daily Playlists & Sync Script
*   **ID:** `TSK-021`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/scripts/sync_music.py`
*   **Dependencies:** None
*   **Description:** Update `sync_music.py` to organize curated tracks, add stories and upload config to Supabase Storage.
*   **Verification Method:** Run script and verify output.

---

### TSK-022: Implement Shared FM Sync & Host Tina with Weather API
*   **ID:** `TSK-022`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Completed`
*   **Parallel-Safe:** `Yes` [P]
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`
*   **Dependencies:** `TSK-021`
*   **Description:** Implement client-side playhead calculation, load weather, and style Host Tina greeting cards.
*   **Verification Method:** Verify slot loading and greeting text output.

---

### TSK-023: Execute FM E2E Verification
*   **ID:** `TSK-023`
*   **Owner:** `ada-qa-agent`
*   **Status:** `Completed`
*   **Parallel-Safe:** `No`
*   **Dependencies:** `TSK-021`, `TSK-022`
*   **Description:** Run integration checks and compile tests.
*   **Verification Method:** Build test pass.

---

### TSK-024: Install Supabase JS SDK & Bootstrap Auth Client
*   **ID:** `TSK-024`
*   **Owner:** `alan-tech-lead`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/package.json`, `doca-affiliate-web/src/lib/supabaseClient.ts` [NEW]
*   **Dependencies:** None
*   **Description:** Install `@supabase/supabase-js` package. Create a helper file `supabaseClient.ts` to initialize the Supabase client browser-side using `PUBLIC_SUPABASE_URL` and `PUBLIC_SUPABASE_ANON_KEY`. Protect the initialization against execution in Node environments (SSG build).
*   **Verification Method:**
    *   Verify `@supabase/supabase-js` is added to package.json.
    *   Ensure Astro builds successfully without build-time initialization errors.

---

### TSK-025: Implement SSO Login Modal Overlay Component
*   **ID:** `TSK-025`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `Yes` [P]
*   **Write Scope:** `doca-affiliate-web/src/components/LoginModal.astro` [NEW]
*   **Dependencies:** `TSK-024`
*   **Description:** Build the Muji-minimalist Login Modal component containing Google and Zalo login buttons. Apply backdrop blur and standard animations defined in [UI_COMPONENTS_STATE.md](file:///Users/macinia/Capcat%20Project/docs/UI_COMPONENTS_STATE.md).
*   **Verification Method:**
    *   Trigger modal and verify typography, colors, and layout in the browser.

---

### TSK-026: Integrate Client-Side Auth State in Navigation Bars
*   **ID:** `TSK-026`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `Yes` [P]
*   **Write Scope:** `doca-affiliate-web/src/pages/index.astro`, `doca-affiliate-web/src/pages/family.astro`, `doca-affiliate-web/src/pages/product.astro`, `doca-affiliate-web/src/pages/about.astro`
*   **Dependencies:** `TSK-025`
*   **Description:** Insert the Login Modal component and update headers to handle Supabase Auth state. Replace the hardcoded "Đăng nhập" buttons with user capsules showing user names and avatars when authenticated. Attach click actions to trigger the Modal or route to `/profile`. Handle the "Đăng xuất" (logout) function.
*   **Verification Method:**
    *   Perform login via mock SSO/Supabase dashboard and verify Navbar state capsule update.
    *   Test logout redirect.

---

### TSK-027: Create Private User Profile Page (`/profile`)
*   **ID:** `TSK-027`
*   **Owner:** `benny-frontend-engineer`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Write Scope:** `doca-affiliate-web/src/pages/profile.astro` [NEW]
*   **Dependencies:** `TSK-026`
*   **Description:** Create a new page `profile.astro` accessible at `/profile`. Ensure it redirects guests to `/` on load. Display user profile data (name, email, photo) from Supabase session. Render a list of pets (Bosses) stored in `localStorage` or `user_metadata`, and implement options to add/delete pet cards.
*   **Verification Method:**
    *   Visit `/profile` as guest and verify redirection.
    *   Visit as logged-in user and verify name display and pet card interactions.

---

### TSK-028: Audit & E2E Validation
*   **ID:** `TSK-028`
*   **Owner:** `ada-qa-agent`
*   **Status:** `Pending`
*   **Parallel-Safe:** `No`
*   **Dependencies:** `TSK-024`, `TSK-025`, `TSK-026`, `TSK-027`
*   **Description:** Check the complete authentication pipeline, inspect Zalo/Google configurations, run production builds to ensure zero TypeScript errors, and verify the design tokens are strictly applied.
*   **Verification Method:**
    *   Run `npm run build` inside `doca-affiliate-web`.
