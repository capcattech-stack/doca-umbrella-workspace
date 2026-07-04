# 🧪 HƯỚNG DẪN LẬP TRÌNH & KIỂM THỬ ĐỒNG BỘ (DEV & QA GAP FIXES)
*(DOCA Affiliate & Validation Web MVP - Developer Blueprints & QA Checklist)*

> **Mã Tài Liệu:** `PRD-WEBSITE-DEV-QA-GUIDELINES`  
> **Phiên bản:** `V1.0 (MVP)`  
> **Chủ trì:** Ada (QA) phối hợp cùng Alan (Tech Lead) và Sophia (CPO)  
> **Mục tiêu:** Vá toàn bộ các khoảng trống kỹ thuật (Gaps) để lập trình viên bắt tay vào phát triển dự án Astro & Supabase ngay lập tức mà không phải phỏng đoán.

---

## 📂 1. Cấu Trúc Mã Nguồn Astro Chuẩn (Astro Source Tree)

Alan (Tech Lead) định nghĩa cấu trúc thư mục nguồn của website Astro để Benny (Frontend Dev) sắp xếp mã nguồn khoa học:

```
capcat_project/ (Root Workspace)
├── Document/Website/ (Thư mục chứa tài liệu thiết kế hiện tại)
└── src/ (Mã nguồn Web Astro)
    ├── components/               # Các UI Component độc lập
    │   ├── NamiyaMailbox.astro   # Widget hòm thư gỗ Namiya (Tally Iframe/Custom Form)
    │   ├── PolaroidSheet.astro   # Polaroid Bottom Sheet (Hiển thị thông tin & click log)
    │   └── ProductCard.astro     # Thẻ hiển thị sản phẩm trên kệ hàng
    ├── content/
    │   ├── config.ts             # Khai báo kiểu dữ liệu Frontmatter bài viết
    │   └── blog/                 # Chứa các file Markdown .md bài viết tĩnh
    │       ├── meo-mu-chu.md
    │       ├── setup-ghibli-cat.md
    │       └── routine-ngam-trang.md
    ├── layouts/
    │   └── Layout.astro          # Bọc khung HTML chung, tự động nhúng SEO Tags & GA4
    ├── pages/
    │   ├── index.astro           # Trang chủ (Kệ sản phẩm + Hòm thư Namiya)
    │   ├── about.astro           # Trang giới thiệu App DOCA (Waitlist)
    │   └── blog/
    │       └── [slug].astro      # Routing bài viết động đọc từ src/content/blog/
    └── styles/
        └── index.css             # Chứa biến màu CSS và utility classes (Design System)
```

---

## ⚙️ 2. Cấu Hình Biến Môi Trường (`.env.example`)

Lập trình viên tạo file `.env` tại root của web để cấu hình kết nối bảo mật đến Supabase API:

```env
# URL của Supabase Project (Xem tại Settings -> API trên Supabase)
PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co

# API Key ẩn danh (Bắt buộc dùng tiền tố PUBLIC_ để client-side JS trong Astro đọc được)
PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.your-anon-key-here
```

---

## 📡 3. Đặc Tả Tương Tác API Supabase (Client-side Fetch Spec)

Để tối ưu hóa tốc độ tải trang (tối giản bundle size), **không cài đặt bộ SDK Supabase nặng nề** xuống trình duyệt. Thay vào đó, sử dụng hàm `fetch()` mặc định của trình duyệt để gửi dữ liệu trực tiếp đến REST API sinh tự động của Supabase:

### 3.1. API Ghi nhận Click chuột (Affiliate / Mua chung Fake Door)
*   **Endpoint:** `POST ${import.meta.env.PUBLIC_SUPABASE_URL}/rest/v1/product_clicks`
*   **Headers:**
    ```json
    {
      "apikey": "[PUBLIC_SUPABASE_ANON_KEY]",
      "Authorization": "Bearer [PUBLIC_SUPABASE_ANON_KEY]",
      "Content-Type": "application/json",
      "Prefer": "return=minimal"
    }
    ```
*   **Payload gửi lên:**
    ```json
    {
      "product_id": "uuid-sản-phẩm-ở-supabase",
      "click_type": "group_buy" // Hoặc 'affiliate'
    }
    ```

### 3.2. API Đăng Ký Waitlist
*   **Endpoint:** `POST ${import.meta.env.PUBLIC_SUPABASE_URL}/rest/v1/waitlist`
*   **Payload gửi lên:**
    ```json
    {
      "email": "sen_doca@example.com",
      "source_channel": "bottom_sheet"
    }
    ```

---

## 🛢️ 4. Dữ Liệu Mẫu SQL Khởi Tạo Sản Phẩm (Seed Database SQL)

Chạy tập lệnh SQL này để nạp dữ liệu mẫu cho 3 sản phẩm phục vụ cho 3 bài viết mẫu đầu tiên:

```sql
INSERT INTO public.products (id, slug, name, category, price, wholesale_price, min_group_size, affiliate_url, image_url, quote)
VALUES 
  (
    'a3c87fb2-c12e-4b68-98e9-4e78a6358c21',
    'sach-tam-ly-meo',
    'Sách Hiểu Người Bạn Mèo',
    'sach',
    120000.00,
    85000.00,
    15,
    'https://shope.ee/fahasa-sach-tam-ly-meo-aff',
    '/images/products/sach-meo-polaroid.webp',
    'Hiểu sâu sắc những tiếng meo meo lạ lùng của thú cưng để xích lại gần nhau hơn...'
  ),
  (
    'b7b25fc8-87e3-4c91-9e23-7fa98c3e4125',
    'den-totoro-go',
    'Đèn Ngủ Gỗ Totoro Ấm Áp',
    'phu_kien',
    250000.00,
    175000.00,
    10,
    'https://shope.ee/shopee-den-totoro-aff',
    '/images/products/den-totoro-polaroid.webp',
    'Giữ một vạt sáng vàng dịu trong đêm tĩnh lặng để Boss yên tâm ngon giấc.'
  ),
  (
    'c2f39c29-379e-4e31-8e99-4d929f123891',
    'luoc-massage-tao-bot',
    'Lược Chải Lông Massage Tạo Bọt',
    'vat_pham',
    95000.00,
    65000.00,
    20,
    'https://shope.ee/shopee-luoc-massage-aff',
    '/images/products/luoc-massage-polaroid.webp',
    'Hãy chải chuốt nhẹ nhàng cho Boss mỗi tối như một hoạt động chánh niệm cùng nhau.'
  );
```

---

## 🛡️ 5. Danh Mục Kiểm Thử Chất Lượng Của Ada (QA Test Boundary Checklist)

Ada (QA Agent) yêu cầu kiểm thử nghiêm ngặt các ranh giới chức năng sau trước khi nghiệm thu bàn giao:

### 🧪 5.1. Kiểm thử bảo mật (RLS Security Test)
*   [ ] **Chặn quyền đọc trái phép:** Thử chạy lệnh `curl` đọc dữ liệu `waitlist` hoặc `namiya_letters` bằng khóa `anon key`. Kết quả bắt buộc phải trả về mã lỗi `401 Unauthorized` hoặc `403 Forbidden` (Chính sách RLS hoạt động tốt).
    ```bash
    # Lệnh test thử đọc waitlist - KẾT QUẢ BẮT BUỘC PHẢI THẤT BẠI
    curl -X GET "https://your-project-id.supabase.co/rest/v1/waitlist" \
      -H "apikey: your-anon-key" \
      -H "Authorization: Bearer your-anon-key"
    ```
*   [ ] **Quyền đọc công khai sản phẩm:** Thử chạy lệnh đọc danh sách `products` bằng `anon key`. Kết quả bắt buộc phải thành công trả về dữ liệu JSON của 3 sản phẩm mẫu.

### 🧪 5.2. Kiểm thử tương tác biên (Edge Cases & Stress Testing)
*   [ ] **Trùng lặp Email Waitlist:** Nhập một email trùng nhau 2 lần vào Form Waitlist. Hệ thống phải xử lý mượt mà (không gây crash trang, có thể hiển thị thông báo cute: *"Tụi con đã ghi nhận email này của cô/chú từ trước rồi ạ! 🐾"*).
*   [ ] **Trùng lặp Click Mua chung:** Click liên tục 5 lần vào nút Mua chung của cùng một sản phẩm. Database bắt buộc chỉ ghi nhận duy nhất 1 bản ghi click nhờ ràng buộc Unique Index `idx_preorder_interest_email_product` (hoặc tránh ghi đè click ảo liên tục).
*   [ ] **Tâm sự trống / Ký tự lạ:** Gửi thư Namiya với nội dung rỗng hoặc chứa toàn ký tự mã độc (XSS payload như `<script>alert(1)</script>`). Hệ thống bắt buộc phải lọc sạch ký tự nguy hiểm (Sanitize input) trước khi lưu vào Supabase.

### 🧪 5.3. Kiểm thử hiệu năng di động (Performance Test)
*   [ ] Điểm số Google PageSpeed / Lighthouse trên di động cho trang bài viết chi tiết phải đạt tối thiểu **90 điểm** cho cả 3 mục: Performance, Accessibility, và SEO.
*   [ ] Thời gian tải trang tương tác được (Time to Interactive) trên môi trường 3G chậm phải dưới **2.5 giây**.
