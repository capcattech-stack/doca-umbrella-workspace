# 📄 ĐẶC TẢ CHI TIẾT BLOG & CHIẾN LƯỢC SEO (BLOG & SEO SPECIFICATION)
*(DOCA Affiliate & Validation Web MVP - Blog Architecture, Frontmatter & SEO Schema)*

> **Mã Tài Liệu:** `PRD-WEBSITE-BLOG-SEO`  
> **Phiên bản:** `V1.1 (Quy trình thêm bài viết)`  
> **Chủ trì:** Sophia (CPO) & Alan (Tech Lead)  
> **Mục tiêu:** Định nghĩa cấu trúc bài viết Nhật ký lối sống (Blog), thiết kế cấu trúc dữ liệu tĩnh (Frontmatter) ánh xạ sản phẩm, cấu hình SEO, và hướng dẫn quy trình thêm bài viết mới.

---

## 🧭 1. Định Vị: "Nhật Ký Lối Sống" (The Lifestyle Journal)

Trong thế giới của DOCA, chúng ta không dùng từ "Blog" hay "Tin tức" trên giao diện của người dùng. Thay vào đó, nó được gọi là **"Nhật Ký Lối Sống"** (đối với độc giả) hoặc **"Nhật Ký Của Cô/Chú & các bạn đồng Meo"**.
*   **Hình thức hiển thị:** Dạng blog cá nhân, giọng văn chiêm nghiệm, ấm áp.
*   **Trang chi tiết bài viết:** Tập trung 100% vào trải nghiệm đọc tối giản (Readability). Cỡ chữ lớn (`18px` - `20px`), giãn dòng thoáng (`1.6` - `1.8`), màu nền kem dịu mắt, hoàn toàn không có sidebar quảng cáo gây xao nhãng.

---

## 💾 2. Thiết Kế Data Cho Bài Viết (Static File Architecture)

Vì chúng ta xây dựng Website bằng **Astro (Static Site Generator)**, thông tin bài viết sẽ **không lưu ở database Supabase** mà được lưu ở dạng **file Markdown tĩnh (.md)** trong thư mục nguồn của website. 

### 💡 Tại sao lưu tĩnh?
*   **Tốc độ tải trang:** Load tức thì (< 0.5s) vì bài viết đã được biên dịch sẵn thành file HTML tĩnh, đạt điểm tối đa Google PageSpeed (Lighthouse 100).
*   **SEO hoàn hảo:** Google Crawlers có thể đọc toàn bộ bài viết ngay lập tức mà không phải đợi render JavaScript.

### 📝 Cấu trúc Metadata Bài Viết (Frontmatter Spec)
Mỗi file markdown bài viết sẽ khai báo thông tin cấu trúc (Frontmatter) ở đầu file để Astro tự động ánh xạ với sản phẩm trong Supabase:

```yaml
---
title: "Bí quyết Setup góc nhỏ làm việc chuẩn tối giản Iyashikei & MUJI cùng chú mèo"
description: "Cải tạo góc làm việc ngổn ngang lông mèo thành không gian ấm cúng chuẩn tối giản Iyashikei & MUJI để làm việc chánh niệm cùng thú cưng."
publishDate: "2026-06-24"
coverImage: "/images/blog/setup-ghibli-cat.webp"
category: "phu_kien" # thuc_an, vat_pham, sach, phu_kien
tags: ["Góc bình yên", "Setup phòng", "Chữa lành"]
relatedProducts: ["den-totoro", "tham-linen-muji"] # Ánh xạ khóa ngoại (slug) của sản phẩm trong Supabase
---

# Nội dung bài viết bắt đầu từ đây bằng định dạng Markdown...
Nuôi thú cưng không chỉ là cho ăn, đó là việc chia sẻ không gian sống cùng nhau...
```

---

## 📐 3. Layout Chi Tiết Trang Bài Viết (Blog Detail Page Wireframe)

```
┌────────────────────────────────────────────────────────┐
│  [🐾 Trở về trang chủ]                                  │
├────────────────────────────────────────────────────────┤
│  Lối Sống Chữa Lành > Phụ Kiện                         │
│  <h1>Bí quyết Setup góc nhỏ làm việc chuẩn tối giản Iyashikei & MUJI</h1>  │
│  Đăng lúc: 24/06/2026 • ⏳ 3 phút đọc                  │
├────────────────────────────────────────────────────────┤
│  [Ảnh minh họa phong cách màu nước Iyashikei & MUJI ấm áp]       │
│                                                        │
│  Nuôi thú cưng không chỉ là cho ăn...                  │
│  ... rải một vài chiếc *thảm linen ủi phẳng*...        │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │ 🎁 GỢI Ý CỦA BOSS (Polaroid Card)                │  │
│  │ ┌──────────┐ Đèn ngủ gỗ Totoro Thần Rừng          │  │
│  │ │          │ Giá lẻ: 250.000đ                    │  │
│  │ │  [Ảnh]   │ "Giữ một đốm sáng vàng ấm áp..."     │  │
│  │ └──────────┘                                     │  │
│  │ [Tìm sách/đồ trên Shopee 🐾] [Gom mua chung giá sỉ]│  │
│  └──────────────────────────────────────────────────┘  │
│                                                        │
├────────────────────────────────────────────────────────┤
│  📮 HÒM THƯ GỖ NAMIYA (Nhúng Widget)                   │
│  Nếu cô/chú có những nỗi buồn muốn kể, hãy gửi cho tụi con...│
│  [Nhập tâm sự của cô/chú...]                            │
│  [ Gửi thư vào hòm gỗ ✉️ ]                              │
└────────────────────────────────────────────────────────┘
```

---

## 🚀 4. Chiến Lược SEO Tối Ưu (SEO & Social Share Spec)

Trang chi tiết bài viết sẽ được cấu hình tự động các yếu tố SEO sau:

### 4.1. Meta Tags chuẩn Google
*   **Title Tag:** Lấy từ trường `title` trong frontmatter (Độ dài từ 50-60 ký tự).
*   **Meta Description:** Lấy từ trường `description` trong frontmatter (Độ dài từ 140-160 ký tự, chứa từ khóa SEO ngách).
*   **Robots.txt & XML Sitemap:** Tự động sinh danh sách toàn bộ các bài viết để nộp cho Google Search Console qua plugin `@astrojs/sitemap`.

### 4.2. Open Graph & Twitter Cards (SEO Mạng xã hội)
Giúp hiển thị ảnh bìa Polaroid màu nước và tóm tắt bài viết tuyệt đẹp khi bạn chia sẻ link lên Group Facebook (1.5k members) hoặc Zalo:
*   `og:type` = `article`
*   `og:title` = `title` của bài viết
*   `og:description` = `description` của bài viết
*   `og:image` = Ảnh cover của bài viết (Kích thước chuẩn: `1200x630px`).

### 4.3. Schema Markup (Structured Data JSON-LD)
Nhúng mã dữ liệu cấu trúc tự động vào thẻ `<head>` để Google hiển thị bài viết dưới dạng kết quả tìm kiếm giàu tính năng (Rich Snippets):

```json
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "headline": "Bí quyết Setup góc nhỏ làm việc chuẩn tối giản Iyashikei & MUJI cùng chú mèo",
  "image": "https://docacorner.com/images/blog/setup-ghibli-cat.webp",
  "datePublished": "2026-06-24",
  "description": "Cải tạo góc làm việc ngổn ngang lông mèo thành không gian ấm cúng chuẩn tối giản Iyashikei & MUJI...",
  "author": {
    "@type": "Person",
    "name": "Đội ngũ DOCA"
  }
}
```

---

## 🛠️ 5. Quy Trình Thêm Bài Viết Mới (How to Add a New Post)

Quy trình xuất bản một bài viết mới cực kỳ nhanh gọn và được chia làm 4 bước:

### 📥 Bước 1: Tạo file Markdown bài viết mới
Tạo một file `.md` mới nằm trong thư mục nội dung blog (Ví dụ: `src/content/blog/routine-ngam-trang.md`). Tên file viết liền không dấu, ngăn cách bằng dấu gạch ngang (chính là URL của bài viết).

### 🖋️ Bước 2: Thiết lập thông tin Frontmatter ở đầu file
Sao chép cấu trúc metadata và điền thông tin bài viết mới. Lưu ý khai báo đúng slug của sản phẩm liên quan trong Supabase vào mục `relatedProducts` (để hiển thị Polaroid Card).

### 📝 Bước 3: Soạn thảo nội dung bài viết
Viết nội dung bài bằng cú pháp Markdown thông dụng:
*   Dùng `#`, `##` để làm tiêu đề bài viết.
*   Chèn ảnh: `![Tên ảnh](/images/blog/ten-anh.webp)`.
*   Tạo link affiliate ngữ cảnh (chữ nghiêng hoặc link): `[lược chải lông massage](url-affiliate)`.

### 🚀 Bước 4: Commit và Push lên GitHub
Đưa code mới lên kho lưu trữ. Hệ thống CI/CD (Vercel/Netlify) sẽ phát hiện bài viết mới và tự động build/deploy đưa bài viết lên mạng trong vòng **dưới 1 phút** mà bạn không cần cấu hình gì thêm.

*(Mẹo: Bạn có thể yêu cầu Trợ lý AI viết bài trực tiếp bằng cách nói: "Hãy soạn cho tôi bài viết mới về chủ đề X và chèn sản phẩm Y", AI sẽ tự động tạo file và đẩy lên Git cho bạn).*

---

## 🏁 6. Định Nghĩa Hoàn Thành SEO (DoD)

Trang bài viết chi tiết đạt chuẩn SEO khi:
*   [ ] Đạt điểm kiểm tra hiệu năng SEO di động trên Chrome Lighthouse $\ge 95$.
*   [ ] Các thẻ Meta Title, Meta Description và Open Graph Image hiển thị chính xác khi chia sẻ thử nghiệm lên Facebook/Zalo.
*   [ ] Mã JSON-LD được kiểm tra thành công, không báo lỗi trên Công cụ kiểm tra dữ liệu có cấu trúc của Google.
