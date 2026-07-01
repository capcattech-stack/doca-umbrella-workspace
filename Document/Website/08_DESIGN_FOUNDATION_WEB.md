# 🎨 BẢN THƯ VIỆN TOKENS THIẾT KẾ CHO WEB (WEB DESIGN FOUNDATION)
*(DOCA Affiliate & Validation Web MVP - Design System & CSS Variables)*

> **Mã Tài Liệu:** `PRD-WEBSITE-DESIGN-FOUNDATION`  
> **Phiên bản:** `V1.0 (MVP Web)`  
> **Chủ trì:** Alan (Tech Lead) & Sophia (CPO)  
> **Mục tiêu:** Đồng bộ hóa Design Tokens từ App di động sang định dạng Web CSS Custom Properties (CSS Variables) và cấu hình lớp CSS tiện ích cốt lõi cho trang web Astro.

---

## 🎨 1. Hệ Thống Biến CSS Màu Sắc (CSS Color Variables)

Chúng ta chuyển đổi dải màu đặc trưng của ứng dụng di động thành các biến CSS gốc (`:root`) dùng cho website (Chủ đề sáng Cozy Light là chủ đạo cho blog/affiliate):

```css
:root {
  /* --- NỀN VÀ KHUNG CHỮ (Core Neutral) --- */
  --cozy-bg-pure: #FBFAF6;              /* Màu mây trắng sữa (Cloud) thương hiệu mới */
  --cozy-bg-oatmeal: #E8E3D6;           /* Màu cát ấm (Sand) thương hiệu mới */
  --cozy-bg-beige: #F4F1E9;             /* Màu giấy ấm áp (Paper) thương hiệu mới */
  --cozy-text-obsidian: #15170F;        /* Màu chữ mực Charcoal ấm áp thương hiệu mới */
  --cozy-text-charcoal: #15170F;        /* Nút bấm màu mực Charcoal thương hiệu mới */
  --cozy-border-light: #EAEAEA;         /* Đường viền mảnh */

  /* --- MÀU NHẤN THƯƠNG HIỆU & CẢM XÚC (Matcha & Sakura V2) --- */
  /* Matcha Green (3 phiên bản) */
  --cozy-green-matcha: #8FBF4F;         /* Matcha Warm - Xanh vừa ấm áp chủ đạo */
  --cozy-green-matcha-forest: #4A8A2E;  /* Matcha Forest - Xanh đậm làm nền banner */
  --cozy-green-matcha-dark: #1F3E12;    /* Matcha Dark - Xanh sẫm tối phong cách premium */
  --cozy-bg-cream-warm: #F5EDD5;        /* Nền kem Matcha ấm áp */

  /* Sakura Pink (3 phiên bản) */
  --cozy-pink-sakura: #F4ABBE;          /* Sakura Pastel - Hồng cánh đào ngọt ngào chủ đạo */
  --cozy-pink-sakura-bright: #E07090;   /* Sakura Bright - Hồng rực tương phản mạnh */
  --cozy-pink-sakura-mauve: #C470A0;    /* Sakura Mauve - Tím hồng sang trọng, bí ẩn */
  
  --cozy-amber-light: #FFF9C4;          /* Vạt nắng vàng ấm ban đêm */

  /* Wood Accents (3 màu gỗ Nhật Bản truyền thống) */
  --cozy-wood-sugi: #8B5E3C;            /* Sugi (Tuyết tùng) - Gỗ ấm áp, trung tính */
  --cozy-wood-kogecha: #4A2418;         /* Kogecha (Nâu cháy) - Nâu đậm, nền tối truyền thống */
  --cozy-wood-kohaku: #B8860A;          /* Kohaku (Hổ phách) - Vàng sơn mài/tre già */

  /* --- MÀUsemantic mềm dịu (Soft Status) --- */
  --cozy-success: #E8F5E9;              /* Pastel Sage Green */
  --cozy-warning: #FFE0B2;              /* Soft Apricot Orange */
  --cozy-error: #FFCDD2;                /* Dusty Cherry Pink */
  --cozy-info: #E1F5FE;                 /* Pale Sky Blue */

  /* --- HIỆU ỨNG ĐỔ BÓNG (Shadows) --- */
  --cozy-shadow-default: 0 4px 12px rgba(28, 28, 30, 0.04);
  --cozy-shadow-hover: 0 8px 20px rgba(28, 28, 30, 0.10);
  
  /* --- BO GÓC (Border Radius) --- */
  --radius-card: 16px;                  /* Khung card bài viết, hòm thư */
  --radius-button: 12px;                /* Nút bấm, thanh tìm kiếm */
  --radius-tag: 8px;                    /* Nhãn phân loại bài viết */
  --radius-avatar: 8px;                 /* Ảnh đại diện thú cưng */
}
```

---

## ✍️ 2. Hệ Thống Kiểu Chữ Web (Typography CSS)

Để trang web mang cảm giác kết hợp giữa **mộc mạc thủ công** và **thoáng mát dễ chịu**, chúng ta sử dụng 3 bộ font cho web:
1.  **Playfair Display (Serif)**: Font chữ có chân cổ điển dùng cho Tiêu đề lớn (`h1`, `h2`) tạo chất thơ.
2.  **Inter (Sans-serif)**: Font không chân trung tính cực kỳ sắc nét dùng cho toàn bộ nội dung chính (Body Text).
3.  **Space Mono (Monospace)**: Font máy đánh chữ dùng cho các timestamp, trích dẫn, lời thì thầm của Boss.

```html
<!-- Nhúng Font từ Google Fonts trong thẻ <head> -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,600;0,700;1,400&family=Space+Mono:ital,wght@0,400;1,400&display=swap" rel="stylesheet">
```

```css
/* --- CẤU HÌNH TYPOGRAPHY --- */
h1, .display-large {
  font-family: 'Playfair Display', Georgia, serif;
  font-weight: 700;
  font-size: 2rem;           /* 32px */
  line-height: 1.25;
  color: var(--cozy-text-obsidian);
}

h2, .headline-large {
  font-family: 'Playfair Display', Georgia, serif;
  font-weight: 600;
  font-size: 1.5rem;          /* 24px */
  line-height: 1.3;
}

body, .body-large {
  font-family: 'Inter', -apple-system, sans-serif;
  font-weight: 400;
  font-size: 1rem;            /* 16px */
  line-height: 1.6;
  color: var(--cozy-text-obsidian);
}

.caption-text {
  font-family: 'Inter', sans-serif;
  font-weight: 400;
  font-size: 0.75rem;         /* 12px */
  color: #6E6E73;
}

.whisper-mono {
  font-family: 'Space Mono', monospace;
  font-size: 0.9rem;          /* ~14px */
  font-style: italic;
  line-height: 1.6;
  color: #8E8E93;
}
```

---

## 🧩 3. Các Lớp CSS Tiện Ích Cốt Lõi (Core UI Components)

Dưới đây là các lớp CSS viết sẵn để lập trình viên áp dụng đồng bộ trên giao diện web Astro:

### 3.1. Thẻ bài viết / Hộp thư Gỗ (`.cozy-card`)
Giao diện phẳng, có viền mảnh và đổ bóng mờ loãng để tạo cảm xúc nhẹ nhàng:
```css
.cozy-card {
  background-color: var(--cozy-bg-pure);
  border: 1px solid var(--cozy-border-light);
  border-radius: var(--radius-card);
  box-shadow: var(--cozy-shadow-default);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  padding: 1.5rem;
}

.cozy-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--cozy-shadow-hover);
}
```

### 3.2. Link Affiliate Gạch Chân Chấm Mảnh (`.cozy-dotted-link`)
Thay thế link xanh công nghiệp bằng link tối giản phong cách giấy thủ công:
```css
.cozy-dotted-link {
  color: var(--cozy-text-obsidian);
  text-decoration: none;
  border-bottom: 1.5px dotted var(--cozy-green-matcha);
  font-weight: 500;
  transition: all 0.2s ease;
}

.cozy-dotted-link:hover {
  color: var(--cozy-green-matcha);
  border-bottom-style: solid;
}
```

### 3.3. Các nút bấm hành động (`.cozy-btn`)
Nút bấm bo góc mượt mà có hiệu ứng phản hồi xúc giác giả lập (Tactile Response):
```css
.cozy-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-family: 'Inter', sans-serif;
  font-size: 0.95rem;
  font-weight: 600;
  padding: 0.75rem 1.5rem;
  border-radius: var(--radius-button);
  border: none;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Hiệu ứng ấn nút lún nhẹ (Tactile Press) */
.cozy-btn:active {
  transform: scale(0.96);
}

/* Nút bấm chính (Mua lẻ Shopee) */
.cozy-btn-primary {
  background-color: var(--cozy-text-charcoal);
  color: var(--cozy-bg-pure);
}

.cozy-btn-primary:hover {
  opacity: 0.9;
}

/* Nút bấm phụ (Mua chung Fake Door) */
.cozy-btn-secondary {
  background-color: var(--cozy-bg-oatmeal);
  color: var(--cozy-text-obsidian);
  border: 1px solid var(--cozy-border-light);
}

.cozy-btn-secondary:hover {
  background-color: #EAEAEA;
}
```

---

## 🔄 4. Giao Diện Trượt Polaroid Bottom Sheet CSS

Khi người dùng click vào link affiliate trên di động, sheet sẽ trượt lên mượt mà từ đáy:

```css
.polaroid-bottom-sheet {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(16px); /* Kính mờ Glassmorphism */
  border-top: 1px solid rgba(255, 255, 255, 0.3);
  border-top-left-radius: 24px;
  border-top-right-radius: 24px;
  box-shadow: 0 -10px 40px rgba(0, 0, 0, 0.08);
  transform: translateY(100%);
  transition: transform 0.4s cubic-bezier(0.25, 1, 0.5, 1);
  z-index: 1000;
  padding: 2rem 1.5rem;
}

.polaroid-bottom-sheet.open {
  transform: translateY(0);
}

/* Khung ảnh Polaroid nhỏ nghiêng nghệ thuật */
.polaroid-frame {
  background: white;
  padding: 10px 10px 25px 10px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.06);
  transform: rotate(-2deg); /* Nghiêng nhẹ tạo nét thủ công */
  max-width: 150px;
}

.polaroid-frame img {
  width: 130px;
  height: 130px;
  object-fit: cover;
}
```

---

## 🏁 5. Định Nghĩa Hoàn Thành Giao Diện (DoD)

Kiến trúc CSS nền tảng được nghiệm thu khi:
*   [ ] Đã cấu hình tệp `index.css` chứa đầy đủ các biến gốc `:root` và utility classes trên dự án web Astro.
*   [ ] Đảm bảo web tải mượt các font chữ chỉ định mà không bị nháy chữ (FOUC).
*   [ ] Các tương tác nút bấm và hiệu ứng trượt Polaroid Bottom Sheet hoạt động trơn tru ở tốc độ 60fps trên trình duyệt Chrome Mobile.
