# Ý tưởng phát triển: Cửa hàng cá nhân KOC / Trang đơn sản phẩm Affiliate (Creator Store V1)

Tài liệu này lưu trữ toàn bộ phân tích, thiết kế hệ thống và lộ trình triển khai tính năng cho phép người dùng tự tạo trang đơn (Landing Page / Shop cá nhân) để chia sẻ các sản phẩm thú cưng khuyên dùng kèm link Shopee Affiliate của họ trên hệ thống DOCA.pet.

---

## 1. Mục tiêu chiến lược
*   **Tăng trưởng traffic đột phá (Viral Loop)**: KOL/KOC tự đi quảng bá link shop của họ trên DOCA (ví dụ: `doca.pet/lin`) lên các kênh mạng xã hội (TikTok, Instagram, Bio), kéo fan truy cập thẳng vào hệ thống DOCA hoàn toàn miễn phí.
*   **Thu hút và giữ chân User**: Người dùng mới tham gia vào hệ sinh thái để quản lý shop cá nhân, tạo tiền đề để khai thác các tính năng khác (Lưu giữ ký ức, AI PetTwin, Hòm thư Namiya).
*   **Tạo dòng tiền thụ động**: Chia sẻ doanh thu hoa hồng một cách văn minh thông qua cơ chế kỹ thuật thông minh.

---

## 2. Thiết kế tính năng chính (Feature Scope)
1.  **Dynamic Routing `/profile/[username]` (Trang cá nhân)**:
    *   Hiển thị thông tin cá nhân: Ảnh đại diện, Tên KOC, Lời nhắn chữa lành, liên kết mạng xã hội.
    *   Danh mục sản phẩm đề xuất (Grid/List) với hiệu ứng ảnh polaroid đẹp mắt.
    *   Mỗi sản phẩm có ảnh, tên, giá bán và nút **"Mua ngay trên Shopee"** (dẫn qua link affiliate).
2.  **Tool cào sản phẩm 1-Click (Shopee Link Scraper)**:
    *   Người dùng chỉ cần dán link Shopee gốc của sản phẩm bất kỳ.
    *   Hệ thống tự động chạy ngầm, cào thông tin sản phẩm (Tên, Giá bán, URL ảnh gốc) và tự điền vào Form tạo sản phẩm trên DOCA.
    *   Người dùng chỉ cần dán thêm link affiliate cá nhân của họ (sinh từ app Shopee) và bấm đăng.

---

## 3. Mô hình doanh thu chia sẻ (Win - Win Monetization)
Để đảm bảo vận hành và sinh lời cho hệ thống, chúng ta áp dụng 2 cơ chế:
*   **Cơ chế Chia sẻ Click (Traffic Split)**:
    *   Với tài khoản miễn phí: 90% số lượt click của khách hàng vào sản phẩm sẽ dùng mã affiliate của KOC sở hữu trang, **10% số click ngẫu nhiên còn lại sẽ tự động chuyển đổi sang mã affiliate của hệ thống DOCA**.
    *   KOC được dùng công cụ tạo shop đẹp miễn phí, DOCA nhận được dòng tiền hoa hồng thụ động để nuôi vận hành.
*   **Gói Premium Member**:
    *   Thu phí cố định theo tháng (ví dụ: 99k/tháng).
    *   Mở khóa: Giữ 100% hoa hồng (không chia sẻ click), chèn mã Facebook/TikTok Pixel để bám đuổi quảng cáo, tùy biến giao diện cao cấp.

---

## 4. Phân tích sức tải trên Hạ tầng Miễn phí (Vercel & Supabase Free)
Hệ thống lưu trữ ảnh thông qua URL gốc của Shopee (không tải file ảnh lên máy chủ riêng), giúp tối ưu hóa dung lượng lưu trữ tối đa:

| Thành phần | Giới hạn gói Free | Lượng tiêu thụ thực tế | Sức chịu tải thực tế |
| :--- | :--- | :--- | :--- |
| **Supabase DB** | 500 MB | ~2 KB mỗi sản phẩm (lưu text) | Lưu được **~250.000 sản phẩm** (đủ cho **8.000 users**). |
| **Vercel Băng thông** | 100 GB / tháng | ~50 KB / lượt xem trang đơn | Chịu được **1.000.000 - 2.000.000 Pageviews/tháng** (30k - 60k lượt/ngày). |
| **Vercel Serverless** | 100 giờ / tháng | ~1.5 giây / lượt cào Shopee | Đủ cho **240.000 lần tạo sản phẩm / tháng**. |

---

## 5. Lộ trình triển khai kỹ thuật (Roadmap)
*   [ ] **Bước 1: Thiết kế Database Schema**:
    *   Tạo bảng `public.creator_shops` (liên kết với `profiles`) để cấu hình thông tin cửa hàng cá nhân.
    *   Tạo bảng `public.products` (id, shop_id, name, price, original_url, image_url, affiliate_url).
*   [ ] **Bước 2: Viết API cào dữ liệu Shopee**:
    *   Viết một Astro API Endpoint hoặc Supabase Edge Function nhận link Shopee, sử dụng thư viện cào HTML (hoặc API trung gian) để trích xuất Tên, Giá, Ảnh sản phẩm.
*   [ ] **Bước 3: Xây dựng Giao diện trang cá nhân và Builder**:
    *   Tạo trang Builder đơn giản cho người dùng quản lý sản phẩm.
    *   Thiết kế giao diện hiển thị shop cá nhân theo phong cách Muji tối giản.
*   [ ] **Bước 4: Tích hợp logic chia sẻ click 90/10**:
    *   Viết hàm chuyển hướng link (Redirection Handler) để thực hiện tráo mã affiliate ngẫu nhiên theo tỷ lệ quy định trước khi đưa người dùng sang Shopee.
