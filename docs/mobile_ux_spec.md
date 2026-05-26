# Mobile-First UX Specification — Idea Workshop
> **Grooming session:** 19/05/2026 — Thống nhất giữa Product Owner & Sophia (AI Product Advisor)
> **Trạng thái:** ✅ LOCKED — Sẵn sàng để thiết kế & phát triển

---

## 1. Định hướng Thiết kế Tổng thể

| Thuộc tính | Quyết định |
|---|---|
| **Platform ưu tiên** | Mobile-first (Web Responsive) |
| **Target User màn hình mobile** | Business User (người gửi ý tưởng) |
| **UI Pattern tham chiếu** | Claude Mobile — Full-screen chat, chips gợi ý nổi phía trên input |
| **Color Mode** | Dark Mode (mặc định, không toggle) |
| **Ngôn ngữ** | Tiếng Việt |

---

## 2. Kiến trúc Màn hình (Screen Architecture)

### 2.1 Landing Page (Mobile)
- **Pattern:** Blank Canvas — ô nhập liệu lớn chiếm trung tâm màn hình, placeholder mờ *"Bạn đang ấp ủ điều gì?"*
- Không có onboarding, không có splash screen
- Header tối giản: Logo trái + icon menu (☰) phải
- Khi user bắt đầu gõ → header/logo fade out, toàn màn hình là textarea

### 2.2 Chat Room (Mobile)
- **Layout:** Full-screen single-column chat (không có split-pane)
- **Header:** Mảnh, sticky — Logo + tên idea ngắn + icon (☰) để mở menu
- **Progress Thread:** Thanh gradient mảnh 3px ngay dưới header. Tap → mở Bottom Sheet hiện 6 bước Grooming Journey chi tiết
- **Chat Area:** Bubble chat toàn màn hình, scroll tự do
- **Input Zone (Bottom 40%):**
  - Suggestion Chips nổi phía **trên** input bar (theo US 1.7)
  - Input bar sticky bottom với paperclip + send button
  - Safe area padding cho notch/home indicator iOS/Android

### 2.3 Side Menu (Drawer — trượt từ trái ra, giống Claude)
Chứa 3 phần:
1. **Danh sách ý tưởng** — Lịch sử các ý tưởng đã tạo (lưu LocalStorage + Server nếu đã login)
2. **Đăng nhập / Tài khoản** — Optional upgrade từ anonymous → có account (xem §3)
3. **Settings** — Ngôn ngữ, thông báo, và các tùy chọn cơ bản

### 2.4 PRD Preview (Mobile)
- **Không hiện PRD trong chat** khi đang Grooming
- Khi ý tưởng được **APPROVED** → Xuất hiện floating button **"Xem PRD ✨"** ở góc dưới phải
- Tap → Mở **Full-screen Bottom Sheet** trượt lên, chứa nội dung PRD
- Bottom Sheet có nút **"Tải xuống"** và **"Chia sẻ"**

---

## 3. Authentication Model (Hybrid Anonymous + Optional Login)

```
[Lần đầu dùng]
  → Không cần đăng nhập
  → Tạo ý tưởng → Nhận Idea ID + PIN 6 số
  → Dữ liệu lưu LocalStorage + Server (anonymous session)

[Menu → "Đăng nhập"]
  → Đăng nhập Google / Email
  → Hệ thống merge toàn bộ ý tưởng anonymous vào account
  → Từ đây: Danh sách ý tưởng sync server, cross-device, không cần PIN nữa

[Người dùng có account]
  → Mở app → Tự động restore session
  → Danh sách ý tưởng hiện trong Side Menu
```

**Business Rule:** PIN vẫn được giữ cho anonymous user. Khi đã login, PIN trở thành secondary auth cho ý tưởng cũ.

---

## 4. Contextual Suggestion Chips trên Mobile (US 1.7 — Mobile Spec)

> Chi tiết đầy đủ tại `docs/backlog/EPIC-1-User-Experience.md#US-1.7`

### Vị trí & Behavior trên Mobile:
- **Vị trí:** Floating row ngay **phía trên** input bar, trong vùng safe input zone (bottom 40%)
- **Hiển thị:** Chips scroll ngang nếu nhiều hơn 2 chip (không xuống dòng — tránh che chat)
- **Số lượng:** Tối đa 4 chip. Chip thứ 4 luôn là escape hatch
- **Trigger:** Chỉ xuất hiện SAU câu hỏi Grooming đầu tiên của Sophia (không hiện khi chào hỏi)
- **Animation:** Chips slide-up từ dưới lên với stagger 80ms/chip
- **Dismiss:** Tap chip hoặc bắt đầu gõ → chips slide-down và biến mất
- **App Reference Chips:** Khi hỏi về luồng/flow → tối thiểu 2/4 chip tham chiếu app nổi tiếng cùng domain (kèm mô tả flow ngắn)

---

## 5. Progress Journey Indicator (Mobile)

| Element | Spec |
|---|---|
| **Dạng hiển thị** | Thin gradient thread (3px height) ngang full-width |
| **Màu sắc** | Gradient `#6C63FF → #FF6584` (filled portion) / `rgba(255,255,255,0.1)` (unfilled) |
| **Vị trí** | Ngay dưới sticky header |
| **Interaction** | Tap vào thread → Bottom Sheet trượt lên hiển thị 6 bước chi tiết với tên + icon |
| **Animation** | Fill mượt với spring easing khi chuyển bước |
| **6 Bước** | Khởi tạo → Khách hàng → Giá trị lõi → Luồng chuẩn → Ngoại lệ → Giải pháp |

---

## 6. Dark Mode Design Tokens

| Token | Giá trị |
|---|---|
| `--bg-primary` | `#0D0D0F` (nền chính) |
| `--bg-surface` | `#1A1A1F` (card, input) |
| `--bg-elevated` | `#252530` (chips, menu items) |
| `--text-primary` | `#F2F2F7` |
| `--text-secondary` | `#8E8EA0` |
| `--brand-accent` | `#6C63FF` (tím - màu Sophia) |
| `--brand-warm` | `#FF9066` (cam - CTA, highlights) |
| `--user-bubble` | `#1E1E2E` |
| `--ai-bubble` | `transparent` (text trực tiếp, không có bubble) |

---

## 7. Điều chỉnh với Desktop

Desktop vẫn được support nhưng **không phải priority**:
- Chat room desktop: Split-pane (Chat | PRD) như hiện tại — giữ nguyên
- Landing page desktop: Blank canvas — giữ nguyên
- Progress bar desktop: Hiển thị đầy đủ 6 bước trong header — giữ nguyên
- Side menu desktop: Không có hamburger, thay bằng link thẳng trong header

---

## 8. Open Items Cần Quyết định Tiếp

| # | Câu hỏi | Mức độ ưu tiên |
|---|---|---|
| OI-1 | Settings chứa gì? (Thông báo push? Ngôn ngữ? API Key?) | Medium |
| OI-2 | Onboarding flow cho user lần đầu có cần tutorial không? | Low |
| OI-3 | Tên chính thức của app thay cho "Idea Workshop"? | High |
| OI-4 | Sophia avatar/visual identity trên mobile (hình tròn gradient? icon AI?) | Medium |

---
*Tài liệu được tạo từ Grooming Session 19/05/2026. Sophia (AI PM) + Product Owner.*
*Cập nhật tiếp theo cần approval của Product Owner.*
