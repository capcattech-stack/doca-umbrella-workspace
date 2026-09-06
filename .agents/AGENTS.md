# Project-Scoped Rules for Capcat Project

## 🎨 Design System & UI/UX (Web)
*   **Phosphor Icons Selection:** Khi phát triển, bảo trì hoặc mở rộng các tính năng giao diện mới trên trang Web Astro (`doca-affiliate-web`), bắt buộc sử dụng bộ icon **Phosphor Icons** (đã được nhúng qua CDN ở [Layout.astro](apps/doca-affiliate-web/src/layouts/Layout.astro)).
    *   **Quy chuẩn hiển thị:** 
        *   Sử dụng lớp `ph-light` (ví dụ: `class="ph-light ph-paw"`) làm tiêu chuẩn mặc định để đồng bộ với quy chuẩn thiết kế nét mảnh `1.7px` của logo mới.
        *   Sử dụng lớp `ph-thin` cho các vùng giao diện đặc biệt tối giản.
        *   Sử dụng lớp `ph-fill` hoặc `ph-duotone` cho các trạng thái được chọn (Active) hoặc khi hover.
*   **Muji Minimalist Color Palette:** Khi thiết kế hoặc viết CSS/Tailwind cho giao diện, bắt buộc tuân thủ hệ màu Muji Minimalist:
    *   **Nền chủ đạo (Primary BG):** Trắng giấy (`#FFFFFF`).
    *   **Nút bấm và chữ chính (Primary Text/Buttons):** Đen Than Muji (`#1C1C1E`) để tạo độ tương phản cao (High Contrast).
    *   **Điểm nhấn nhận diện (Identity Accent):** Xanh Neon (`#76C123`) cho các tương tác quan trọng nhất, trạng thái active hoặc nút nhấn nhấn mạnh chính.
    *   **Nền phụ (Surface BG):** Xám Yến Mạch (`#F8F9FA`) cho các thẻ Card, Bottom Sheet.
    *   Các nhóm màu phụ Healing (Wasabi, Matcha, Sakura, Sakura Warm, Peach, Amber, Indigo/Ai, Wabi) và màu chất liệu tự nhiên phải tuân thủ nghiêm ngặt quy tắc sử dụng và định mức ngữ nghĩa trong tài liệu thiết kế [Brand Guidelines](docs/BRAND_GUIDELINES.md).

## 📝 Tài liệu Quy hoạch & Báo cáo (Planning & Walkthrough)
*   **Ngôn ngữ tài liệu:** Bắt buộc viết các file tài liệu quy hoạch, kế hoạch thực hiện (`implementation_plan.md`), danh sách nhiệm vụ (`task.md`), và báo cáo hoàn thành (`walkthrough.md`) bằng **tiếng Việt** để lập trình viên và người dùng dễ dàng kiểm soát và đánh giá các thay đổi của dự án.

## 🐱 Thư viện Định danh Nhân vật (Doca House)
*   **Tham chiếu:** Khi cần tạo ảnh, viết kịch bản, lời tựa (story) hoặc tạo nội dung liên quan tới các nhân vật trong nhà Doca (Linh, Tina, Latte, Muối, Pi's), bắt buộc tham khảo và tuân thủ các quy tắc nhất quán (consistency_rules) được định nghĩa trong file [character_identities.json](docs/character_identities.json).

## 🗺️ Quản lý Danh mục Dịch vụ & Sub-Repositories (Single Source of Truth - SSOT)
*   **Điểm quản lý duy nhất:** File [apps/README.md](apps/README.md) là **Nguồn Chân Lý Duy Nhất (Single Source of Truth - SSOT)** quản lý toàn bộ danh sách các Sub-Repositories, microservices, link GitHub repo, tech stack và live domain trong hệ sinh thái DOCA.
*   **Quy tắc cập nhật:** Khi thêm mới, loại bỏ hoặc đổi thông tin bất kỳ ứng dụng con nào, **BẮT BUỘC chỉ cập nhật trực tiếp tại `apps/README.md`**. Tất cả tài liệu thiết kế hoặc báo cáo khác khi cần dẫn chứng danh mục dịch vụ chỉ được tạo hyperlink trỏ về file này.
