# Project-Scoped Rules for Capcat Project

## 🎨 Design System & UI/UX (Web)
*   **Phosphor Icons Selection:** Khi phát triển, bảo trì hoặc mở rộng các tính năng giao diện mới trên trang Web Astro (`doca-affiliate-web`), bắt buộc sử dụng bộ icon **Phosphor Icons** (đã được nhúng qua CDN ở [Layout.astro](file:///Users/macinia/Capcat%20Project/doca-affiliate-web/src/layouts/Layout.astro)).
    *   **Quy chuẩn hiển thị:** 
        *   Sử dụng lớp `ph-light` (ví dụ: `class="ph-light ph-paw"`) làm tiêu chuẩn mặc định để đồng bộ với quy chuẩn thiết kế nét mảnh `1.7px` của logo mới.
        *   Sử dụng lớp `ph-thin` cho các vùng giao diện đặc biệt tối giản.
        *   Sử dụng lớp `ph-fill` hoặc `ph-duotone` cho các trạng thái được chọn (Active) hoặc khi hover.
