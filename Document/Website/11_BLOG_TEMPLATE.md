# 📝 HƯỚNG DẪN VIẾT BÀI & MẪU CẤU TRÚC BLOG (BLOG ARTICLE TEMPLATE)
*(DOCA Affiliate & Validation Web - Blog Writing Specifications & Frontmatter Schema)*

> **Mã Tài Liệu:** `PRD-WEBSITE-BLOG-TEMPLATE`  
> **Phiên bản:** `V1.0 (Lưu Trữ)`  
> **Chủ trì:** Alan (Tech Lead) & Sophia (CPO)  
> **Mục tiêu:** Hướng dẫn cách tạo bài viết mới bằng file Markdown (.md), nhúng hình ảnh minh họa đúng thư mục, và cấu hình liên kết sản phẩm (Affiliate) từ database Supabase hiển thị tự động.

---

## 📂 1. Quy Trình Lưu Trữ Tệp (File Locations)

Để bài viết mới được hệ thống Astro tự động nhận diện và sinh trang web tĩnh (SSG), bạn cần lưu các tệp đúng vị trí sau:

| Loại Tệp | Thư Mục Lưu Trữ | Ví dụ Đường Dẫn |
| :--- | :--- | :--- |
| **Nội dung bài viết (.md)** | `src/content/blog/` | `src/content/blog/bai-viet-cua-ban.md` |
| **Hình ảnh minh họa** | `public/images/blog/` | `public/images/blog/anh-minh-hoa.webp` |

> [!NOTE]
> * Tên tệp Markdown viết thường, không dấu, ngăn cách bằng dấu gạch ngang (ví dụ: `routine-ngam-trang.md`).
> * Định dạng hình ảnh khuyên dùng là `.webp` hoặc `.png` để tối ưu dung lượng tải trang.

---

## 🛠️ 2. Định Nghĩa Cấu Trúc Đầu Trang (Frontmatter Schema)

Phần khai báo Frontmatter (nằm giữa hai dòng `---` ở đầu file Markdown) định hình các siêu dữ liệu cho SEO, hiển thị ở trang chủ, và đính kèm sản phẩm:

```yaml
title: "Tiêu đề bài viết hiển thị trên Web và thẻ SEO Title"
description: "Mô tả ngắn gọn nội dung bài viết hiển thị ở thẻ mô tả trang chủ và SEO Meta Description."
publishDate: "YYYY-MM-DD" # Ngày xuất bản bài viết (ví dụ: 2026-06-25)
coverImage: "/images/blog/ten-anh-cua-ban.webp" # Ảnh bìa của bài viết
category: "sach" # Chỉ chọn 1 trong 4 danh mục: 'thuc_an', 'vat_pham', 'sach', 'phu_kien'
tags: ["Tag1", "Tag2"] # Thẻ phân loại phụ (tùy chọn)
relatedProducts: ["slug-san-pham-1", "slug-san-pham-2"] # Liên kết sản phẩm (tùy chọn)
```

---

## 📦 3. Danh Sách Slug Sản Phẩm Đang Hoạt Động (Supabase Sync)

Khi điền thông số `relatedProducts`, bạn hãy sử dụng chính xác các **Slug** sản phẩm dưới đây từ cơ sở dữ liệu Supabase:

1.  `hat-dinh-duong-huu-co` — Hạt Dinh Dưỡng Hữu Cơ Cho Mèo (Thức Ăn Mèo)
2.  `luoc-massage-tao-bot` — Lược Chải Lông Massage Tạo Bọt (Vật Phẩm Chăm Sóc)
3.  `sach-tam-ly-meo` — Sách Hiểu Người Bạn Mèo (Sách Chữa Lành)
4.  `den-totoro-go` — Đèn Ngủ Gỗ Totoro Ấm Áp (Phụ Kiện Nhà Ở)

---

## 📋 4. Mẫu File Markdown Tiêu Chuẩn (Blog Template Markdown)

Bạn hãy sao chép toàn bộ nội dung khối lệnh dưới đây, tạo tệp `.md` mới trong `src/content/blog/` và chỉnh sửa:

```markdown
---
title: "Tên bài viết mới thật chữa lành của bạn"
description: "Mô tả ngắn gọn về bài viết để hiển thị ở trang chủ và tối ưu hóa SEO."
publishDate: "2026-06-25"
coverImage: "/images/blog/ten-anh-minh-hoa.webp"
category: "thuc_an"
tags: ["Dinh Dưỡng", "Chăm Sóc", "Mèo"]
relatedProducts: ["hat-dinh-duong-huu-co"]
---

Bắt đầu viết nội dung bài viết bằng tiếng Việt tại đây. Bạn có thể sử dụng các định dạng Markdown thông thường.

## 🐾 Tiêu đề phụ (Heading 2)
Bạn có thể chèn ảnh minh họa trực tiếp vào nội dung bài viết bằng cú pháp:
![Ảnh Boss đang ăn](/images/blog/anh-boss-an-ngon.jpg)

### 🐱 Tiêu đề nhỏ hơn (Heading 3)
*   **Chữ in đậm:** Đặt chữ giữa hai dấu sao đôi (ví dụ: **chữ in đậm**).
*   *Chữ in nghiêng:* Đặt chữ giữa hai dấu sao đơn (ví dụ: *chữ in nghiêng*).
*   Danh sách gạch đầu dòng: Sử dụng dấu sao `*` hoặc gạch ngang `-` ở đầu dòng.

> "Đây là một câu trích dẫn nổi bật hoặc danh ngôn chữa lành để nhấn mạnh nội dung."

Chúc bạn và thú cưng luôn có những phút giây thư thái và sống chậm cùng nhau!
```

---

## 🏁 5. Quy Chuẩn Kiểm Tra (DoD - Definition of Done)

Một bài viết Markdown mới được coi là hoàn thiện và sẵn sàng triển khai khi:
1. [ ] Không chứa lỗi cú pháp trong Frontmatter (đảm bảo đúng định dạng thụt lề YAML).
2. [ ] Các sản phẩm được gắn thẻ trong `relatedProducts` trùng khớp với các `slug` sản phẩm trong database Supabase.
3. [ ] Chạy thử nghiệm cục bộ với lệnh `npm run build` thành công, tạo ra tệp HTML tĩnh tương ứng (ví dụ: `/dist/blog/bai-viet-cua-ban/index.html`) mà không gặp lỗi biên dịch.
