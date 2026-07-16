# Screen Inventory and UI States - DOCA FM & SSO Integration

This document details the UI design, states, and accessibility details for the Cozy Audio Player and the SSO Login / Profile views.

## 1. Screen Inventory & Route Map

*   **Route:** `/` (Home Page)
    *   **Navbar Auth Control:** Placed at the right side of the navbar. Defaults to invisible skeleton state, fading into "Đăng nhập" button (Guest) or User Capsule (Authenticated).
    *   **Login Modal Overlay:** Displayed over the page when the "Đăng nhập" button is clicked. Features Google & Zalo SSO login options.
*   **Route:** `/profile` (User Profile Page) [NEW]
    *   **Accessibility:** Private route. Redirects unauthorized guests to `/`.
    *   **User Info Card:** Displays user avatar, full name, email, and sign-out button.
    *   **Pet Info Grid ("Thông tin Boss"):** Displays a grid of pet profile cards (name, age, species) with a dotted "Thêm Boss" card to trigger a pet addition form.

---

## 2. Widget & Interface UI States

### 2.1. Navbar Authentication Controls
*   **Pre-load / Skeleton State:** Auth container is empty, matching a width of `120px` to reserve space, with an opacity of `0`. This prevents layout shifts.
*   **Guest Mode:** Renders the "Đăng nhập" button with a `ph-light ph-sign-in` icon. Smoothly fades in (`opacity: 1`, transition `0.3s`).
*   **Authenticated Mode:** Renders the user avatar (circular, `32x32px`) and the display name capsule with a right-arrow icon pointing to `/profile`.

### 2.2. SSO Login Modal Overlay
*   **Default State:** Displays the cozy header "Đăng nhập góc nhỏ DOCA" with subtext, followed by stacked Google and Zalo login buttons.
*   **Loading State (SSO connecting):** When a login option is clicked, the button fades to `60%` opacity, displays a spinning paw icon (`ph-light ph-paw` rotating), and disables pointer events.
*   **Error State:** Displays a soft cherry-pink warning card (`var(--cozy-error)`) at the top of the modal if the authentication fails.

### 2.3. User Profile Page (`/profile`)
*   **Loading Profile State:** Displays a pulsing skeleton card for both the User details and Pet profiles list.
*   **Active Profiles View:** Renders:
    *   User metadata card.
    *   Pet cards: soft pure-white backgrounds with custom pet species badges, age tags, and a clickable Sakura-pink heart button (`ph-light ph-heart` transitions to `ph-fill` on hover/toggle).
    *   Add Pet Card: Dotted line empty-state card with a plus symbol. Clicking opens a simple inline form to input Pet Name, Species, and Age.

---

## 3. Keyboard, Accessibility & Responsive Constraints

*   **Touch Targets:** All interactive controls (SSO buttons, close buttons, pet card controls) must have a minimum interactive touch area of `44x44px`.
*   **Modal Overlay accessibility:**
    *   The overlay container must use `role="dialog"` and `aria-modal="true"`.
    *   Pressing the `Escape` key must automatically close the modal.
    *   Focus must trap inside the modal when open and return to the login button once closed.
*   **Responsive layouts:**
    *   On desktop: Profile page displays as a two-column grid (Left: User card, Right: Pet grid).
    *   On mobile: Profile page collapses into a single vertical layout (User card stacked above Pet list).
