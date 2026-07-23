# Project-Scoped Rules for Capcat Project

## 🎨 Design System & UI/UX (Web)
*   **Phosphor Icons Selection:** Khi phát triển, bảo trì hoặc mở rộng các tính năng giao diện mới trên trang Web Astro (`doca-affiliate-web`), bắt buộc sử dụng bộ icon **Phosphor Icons** (đã được nhúng qua CDN ở [Layout.astro](file:///Users/macinia/Capcat%20Project/doca-affiliate-web/src/layouts/Layout.astro)).
    *   **Quy chuẩn hiển thị:** 
        *   Sử dụng lớp `ph-light` (ví dụ: `class="ph-light ph-paw"`) làm tiêu chuẩn mặc định để đồng bộ với quy chuẩn thiết kế nét mảnh `1.7px` của logo mới.
        *   Sử dụng lớp `ph-thin` cho các vùng giao diện đặc biệt tối giản.
        *   Sử dụng lớp `ph-fill` hoặc `ph-duotone` cho các trạng thái được chọn (Active) hoặc khi hover.

## 📝 Tài liệu Quy hoạch & Báo cáo (Planning & Walkthrough)
*   **Ngôn ngữ tài liệu:** Bắt buộc viết các file tài liệu quy hoạch, kế hoạch thực hiện (`implementation_plan.md`), danh sách nhiệm vụ (`task.md`), và báo cáo hoàn thành (`walkthrough.md`) bằng **tiếng Việt** để lập trình viên và người dùng dễ dàng kiểm soát và đánh giá các thay đổi của dự án.

## 🐱 Thư viện Định danh Nhân vật (Doca House)
*   **Tham chiếu:** Khi cần tạo ảnh, viết kịch bản, lời tựa (story) hoặc tạo nội dung liên quan tới các nhân vật trong nhà Doca (Linh, Tina, Latte, Muối, Pi's), bắt buộc tham khảo và tuân thủ các quy tắc nhất quán (consistency_rules) được định nghĩa trong file [character_identities.json](file:///Users/ricyuan/CAPCAT/docs/character_identities.json).
