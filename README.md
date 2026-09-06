# 🐾 DOCA Project - Soul of Pet

Chào mừng bạn đến với dự án **DOCA** (trước đây là Capcat). Đây là không gian phát triển và lưu trữ của ứng dụng di động chữa lành cảm xúc, kết nối linh hồn kỹ thuật số độc bản của thú cưng với chủ nuôi.

---

## 🗺️ Quy hoạch Cấu trúc Thư mục (Workspace Layout)

Không gian làm việc Umbrella Workspace được tổ chức chặt chẽ thành các phân vùng chức năng sau:

*   **`apps/`**: **Nguồn Chân Lý Duy Nhất (SSOT)** quản lý toàn bộ các ứng dụng con (Sub-Repositories) và Microservices độc lập trong hệ sinh thái DOCA (Web Khách hàng, Web Admin, Kiosk Creator, Coin Hub API, Core Platforms...).
    *   Xem danh mục chi tiết, live domain và lệnh lazy clone tại [apps/README.md](apps/README.md).
*   **`docs/`**: Hệ thống tài liệu kiến trúc kỹ thuật chuẩn mới, [Brand Guidelines](docs/BRAND_GUIDELINES.md), [Tuyên ngôn nhân vật](docs/character_identities.json), PRD và Task Ledger.
*   **`Document/`**: Thư mục chứa toàn bộ tài liệu đặc tả, thiết kế, báo cáo, và tuyên ngôn nền tảng của dự án.
    *   [Tổng quan dự án](Document/02_OVERALL.md)
    *   [Kim chỉ nam sứ mệnh](Document/03_VISION_MANIFESTO.md)
    *   [Tuyên ngôn định vị thương hiệu & MKT](Document/04_BRAND_MARKETING_MANIFESTO.md)
    *   [Danh sách tính năng MVP](Document/05_FEATURE_LIST.md)
    *   `History/`: Thư mục lưu trữ nhật ký hội thoại đồng sáng tạo (Chat History) của team.
*   **`lib/`**: Mã nguồn cốt lõi của ứng dụng di động Flutter.
    *   `theme/`: Hệ thống style, font chữ (`Quicksand`, `Motterdam`) và palette màu ấm áp hoài niệm (Cozy Earthy Palette).
*   **`.agents/`**: Cấu hình quy tắc (`AGENTS.md`), workflows và kỹ năng nội tại dành riêng cho các Đặc vụ AI (AI Agents).

---

## 🏛️ Nguyên tắc Hành xử & Phát triển (Behavioral Rules for Developers & Agents)

Để dự án vận hành mượt mà, tránh nợ kỹ thuật (Tech Debt) và lệch hướng sản phẩm (Scope Creep), tất cả lập trình viên và các Đặc vụ AI bắt buộc phải tuân thủ các nguyên tắc sau:

### 1. Quản lý Sub-Repositories & Apps Registry (SSOT)
*   Mọi thông tin về các ứng dụng con, microservices, tech stack và remote git URL đều được quản lý duy nhất tại [apps/README.md](apps/README.md).
*   Áp dụng cơ chế **Lazy Clone (Kéo mã nguồn theo nhu cầu)**: Lập trình viên và AI Agent chỉ cần clone repo của app cần làm việc vào thư mục `apps/` khi có tác vụ liên quan.

### 2. Tuyệt đối tôn trọng Phạm vi MVP & Định vị (Scope & Boundaries)
*   **Không phình to tính năng (Scope Creep):** Tuyệt đối không phát triển hay đặc tả các tính năng ngoài định vị (như *Safe Vet Engine*, *Assistant Host* toàn cục phức tạp). Mọi tính năng đề xuất phải được chấm qua bộ ba câu hỏi vàng tại [Tuyên ngôn sứ mệnh](Document/03_VISION_MANIFESTO.md#L84-L92) và đạt 3/3 điểm đồng ý mới được thực hiện.
*   **Không tự ý khôi phục các thư mục đã xóa:** Thư mục `capcat_app` đã được dọn dẹp do không nằm trong lộ trình code của nhánh hiện tại. Không tự ý tạo lại hoặc import code rác.

### 3. Đồng bộ hoá và Chăm sóc Tài liệu (Documentation Integrity)
*   **Lưu trữ Nhật ký Hội thoại chuẩn xác:** Mọi file chat history (dạng `CHAT_HISTORY_DDMMYYYY.md` hoặc thư mục turn chi tiết) bắt buộc phải gom vào thư mục [Document/History/](Document/History).
*   **Liên kết chéo (Interlocking):** Khi tạo hoặc cập nhật tài liệu mới, hãy luôn bổ sung liên kết tương ứng đến các tài liệu liên quan (MOM, PRD, Brand/Vision Manifesto) để đảm bảo tính truy vết (Traceability).
*   **Giữ tài liệu sạch sẽ:** Xoá bỏ các file spec/design đã lỗi thời hoặc bị loại bỏ khỏi phạm vi (ví dụ: spec Safe Vet).

### 4. Ngôn ngữ thiết kế & Trải nghiệm Iyashikei
*   Tông giọng viết nội dung truyền thông và hiển thị UI phải nhất quán theo [Tuyên ngôn Thương hiệu](Document/04_BRAND_MARKETING_MANIFESTO.md) (Cozy, tối giản MUJI ấm áp, chân thành, hóm hỉnh dưới góc nhìn thứ nhất của Boss, không gây hoang mang hay hối thúc user bằng thông báo rác).
*   Mọi component giao diện phải được xây dựng dựa trên theme màu gỗ ấm hoài niệm và các token thiết kế đã được định nghĩa.

### 5. Ngôn ngữ Tài liệu Quy hoạch (Planning Language)
*   **Tiếng Việt cho Tài liệu Quy hoạch:** Tất cả các tài liệu quy hoạch, kế hoạch triển khai (`implementation_plan.md`), danh sách nhiệm vụ (`task.md`), và tài liệu bàn giao (`walkthrough.md`) bắt buộc phải được viết bằng **tiếng Việt** để người dùng dễ dàng kiểm soát và đánh giá các thay đổi kỹ thuật của hệ thống.

---

## 🚀 Hướng dẫn Bắt đầu Nhanh (Quick Start)

1.  **Nghiên cứu Định hướng:** Đọc kỹ hai tài liệu cốt lõi là [Brand Marketing Manifesto](Document/04_BRAND_MARKETING_MANIFESTO.md) và [Vision Manifesto](Document/03_VISION_MANIFESTO.md) trước khi sửa code hoặc viết tài liệu.
2.  **Khám phá Ứng dụng & Dịch vụ:** Xem danh mục các sub-repositories tại [apps/README.md](apps/README.md) để bắt đầu phát triển các module Web/Backend/Mobile tương ứng.
3.  **Vận hành mã nguồn Flutter:** Các logic state management và widget nằm gọn trong `lib/`. Hãy tuân thủ cấu trúc Clean Architecture của Flutter khi thêm tính năng mới.
