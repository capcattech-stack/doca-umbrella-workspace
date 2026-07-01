# 📋 DANH SÁCH BACKLOG & KẾ HOẠCH PHÂN CHIA SPRINT (SPRINT BACKLOG)
*(DOCA Affiliate & Validation Web MVP - Agile Tickets & Sprint Roadmap)*

> **Mã Tài Liệu:** `PRD-WEBSITE-BACKLOG-SPRINTS`  
> **Phiên bản:** `V1.0 (MVP)`  
> **Chủ trì:** Noah (Agile Product Owner)  
> **Mục tiêu:** Phân rã Đặc tả sản phẩm (PRD) và Thiết kế hệ thống (SDD) thành các Task/Ticket JIRA-style khả thi với thời gian ước lượng chi tiết (Developer Days) và tiêu chí nghiệm thu (Acceptance Criteria) nhị phân rõ ràng, đảm bảo tiến độ triển khai ngăn nắp.

---

## 🧭 1. Lộ Trình Sprint Tổng Quan (Sprint Roadmap)

Dự án Website MVP được phân chia thành **2 Sprint chính** (mỗi Sprint kéo dài khoảng 5 ngày làm việc của 1 Developer):

```
[SPRINT 1: INFRA & CORE COMPONENTS] (5 Ngày)
  ├── WEB-001: Khởi tạo Astro & Repo Git
  ├── WEB-002: Khởi tạo DB Supabase & Seed dữ liệu
  ├── WEB-003: Thiết lập bảo mật RLS Supabase
  ├── WEB-004: Xây dựng Base Layout & CSS Tokens
  └── WEB-005: Xây dựng Component Kệ sản phẩm

[SPRINT 2: INTERACTION & DEPLOYMENT] (5 Ngày)
  ├── WEB-006: Lập trình Polaroid Sheet & Ghi Click Log
  ├── WEB-007: Lập trình Hòm thư Namiya (Widget)
  ├── WEB-008: Lập trình Form Đăng ký Waitlist
  ├── WEB-009: Đấu nối Vercel & CI/CD tự động
  └── WEB-010: Kiểm thử QA & Tối ưu SEO Lighthouse
```

---

## 🎫 2. Chi Tiết Sprint Backlog & Acceptance Criteria (JIRA-style Tickets)

---

### 🧱 SPRINT 1: Thiết lập hạ tầng & Giao diện cốt lõi (Infrastructure & UI Base)

#### 🎫 Ticket WEB-001: Bootstrap Dự án Astro & Git Setup
*   **Mô tả:** Khởi tạo dự án Astro tĩnh mới tại thư mục `doca-affiliate-web`, thiết lập cấu hình CSS, cài đặt routing cơ bản cho các trang và đẩy mã nguồn lên kho lưu trữ GitHub mới.
*   **Thời gian ước lượng:** 0.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Dự án khởi chạy được ở môi trường Local (`npm run dev`) tại cổng mặc định `localhost:4321`.
    *   [ ] Đã cấu hình và import các phông chữ chỉ định (Playfair Display, Inter, Space Mono) vào dự án.
    *   [ ] Repo Git local đã được liên kết và push thành công lên GitHub Repository mới.

#### 🎫 Ticket WEB-002: Supabase Database Init & SQL Seed Data
*   **Mô tả:** Khởi tạo một Project Supabase mới, chạy các mã lệnh SQL DDL khởi tạo 4 bảng (`products`, `product_clicks`, `waitlist`, `namiya_letters`) kèm các index hiệu năng. Chạy script SQL seed để nạp 3 sản phẩm mẫu vào bảng `products`.
*   **Thời gian ước lượng:** 0.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] 4 bảng cơ sở dữ liệu hiển thị chính xác trong Supabase Table Editor.
    *   [ ] Bảng `products` đã được nạp thành công 3 bản ghi sản phẩm mẫu (Sách hiểu mèo, Đèn Totoro, Lược chải lông).

#### 🎫 Ticket WEB-003: Thiết lập chính sách bảo mật Supabase RLS
*   **Mô tả:** Kích hoạt tính năng Row Level Security (RLS) trên cả 4 bảng và áp dụng các chính sách bảo mật: Cho phép `SELECT` công khai bảng `products`, chỉ cho phép `INSERT` công khai đối với 3 bảng còn lại, và khóa toàn bộ quyền `SELECT/UPDATE/DELETE` cho API ẩn danh.
*   **Thời gian ước lượng:** 0.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Lệnh `curl` truy vấn đọc danh sách bảng `waitlist` bằng anon key trả về mã lỗi `401` hoặc `403`.
    *   [ ] Lệnh `curl` truy vấn đọc danh sách bảng `products` bằng anon key trả về mã thành công `200` kèm dữ liệu.

#### 🎫 Ticket WEB-004: Xây dựng Layout.astro & Reset CSS Tokens
*   **Mô tả:** Xây dựng file Layout chung (`Layout.astro`) để bọc các trang con. Định nghĩa toàn bộ hệ thống biến màu CSS (`:root`) và font chữ chỉ định từ tài liệu `08_DESIGN_FOUNDATION_WEB.md`.
*   **Thời gian ước lượng:** 1.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Layout chứa đầy đủ các thẻ `<meta>` phục vụ SEO, Open Graph và thẻ theo dõi GA4.
    *   [ ] Các biến màu CSS và phông chữ hiển thị chính xác trên toàn bộ trình duyệt di động mà không bị nháy chữ (FOUC).

#### 🎫 Ticket WEB-005: Xây dựng Component Kệ sản phẩm (`ProductCard.astro`)
*   **Mô tả:** Xây dựng component hiển thị thông tin sản phẩm dạng card theo phong cách tối giản của MUJI. Component đọc dữ liệu truyền vào (props) bao gồm: ảnh bìa, tên sản phẩm, giá gốc, giá sỉ và link tiếp thị.
*   **Thời gian ước lượng:** 1.0 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Hiển thị chính xác tên, giá lẻ, giá sỉ của sản phẩm theo dạng lưới (Grid) responsive trên mobile và desktop.
    *   [ ] Card sản phẩm bao gồm 2 nút bấm tương tác: `[Mua sản phẩm 🐾]` và `[Gom sỉ mua chung]`.

---

### ⚡ SPRINT 2: Lập trình tương tác & Đấu nối hệ thống (Interaction & Go-Live)

#### 🎫 Ticket WEB-006: Lập trình Polaroid Sheet & Click Log API
*   **Mô tả:** Viết mã lệnh Javascript client-side xử lý hiệu ứng trượt mở Polaroid Bottom Sheet khi nhấp sản phẩm. Khi nhấp nút Mua sỉ, hiện thông báo dễ thương Toast/Popup. Gửi yêu cầu ghi log click (`click_type` = 'affiliate' hoặc 'group_buy') ẩn danh về Supabase qua API fetch.
*   **Thời gian ước lượng:** 1.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Polaroid Bottom Sheet trượt lên/xuống mượt mà (< 0.4s) trên trình duyệt Safari và Chrome di động.
    *   [ ] Nhấp nút Mua chung kích hoạt Popup thông báo cute chỉ định: *"Tính năng này đang được tụi con chuẩn bị..."*.
    *   [ ] Mỗi lượt click vào một trong hai nút bấm thành công thêm 1 bản ghi click mới vào bảng `product_clicks` trên Supabase.

#### 🎫 Ticket WEB-007: Lập trình Component Hòm thư Namiya (Confession Widget)
*   **Mô tả:** Xây dựng biểu mẫu nhúng Hòm thư gỗ Namiya. Cho phép người dùng gửi lời tâm sự và email. Gửi payload dữ liệu trực tiếp vào bảng `namiya_letters` trên Supabase qua API.
*   **Thời gian ước lượng:** 1.0 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Biểu mẫu ngăn chặn việc bấm gửi khi chưa nhập nội dung tâm sự.
    *   [ ] Gửi thư thành công lưu chính xác bản ghi tâm sự vào Supabase và kích hoạt hoạt ảnh thông báo thành công dễ thương.

#### 🎫 Ticket WEB-008: Lập trình Form Đăng ký Waitlist App DOCA
*   **Mô tả:** Thiết lập form thu thập email waitlist tại trang chủ và chân trang bài viết blog. Kiểm tra định dạng email và đẩy dữ liệu về bảng `waitlist` trên Supabase.
*   **Thời gian ước lượng:** 0.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Form từ chối các email sai định dạng (Ví dụ: thiếu chữ `@` hoặc `.com`).
    *   [ ] Email hợp lệ được lưu trữ thành công vào bảng `waitlist` của Supabase.

#### 🎫 Ticket WEB-009: Cấu hình Hosting Vercel & CI/CD tự động
*   **Mô tả:** Liên kết GitHub Repository của website với nền tảng Vercel hoặc Netlify để tự động biên dịch và triển khai web mỗi khi có commit mới ở nhánh `main`. Cấu hình các biến môi trường API Key của Supabase trên Vercel.
*   **Thời gian ước lượng:** 0.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Đẩy code thử nghiệm lên nhánh `main` kích hoạt thành công tiến trình build và deploy tự động.
    *   [ ] Trang web hoạt động trực tuyến trên Production sử dụng đúng các cấu hình của Supabase mà không bị lỗi CORS hay API.

#### 🎫 Ticket WEB-010: QA Pre-flight Audit & SEO Validation
*   **Mô tả:** Thực hiện kiểm thử toàn bộ hệ thống (E2E), chạy Google Lighthouse để đo đạc điểm số SEO, Accessibility và Performance. Kiểm tra chính sách RLS lần cuối.
*   **Thời gian ước lượng:** 0.5 ngày làm việc.
*   **Tiêu chí nghiệm thu (Acceptance Criteria - AC):**
    *   [ ] Điểm số Google Lighthouse SEO đạt tối thiểu **95 điểm**.
    *   [ ] Không phát hiện bất kỳ rò rỉ dữ liệu hoặc lỗi bảo mật nào từ phía Supabase Logs.
