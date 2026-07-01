# 🐾 DOCA Project - Soul of Pet

Chào mừng bạn đến với dự án **DOCA** (trước đây là Capcat). Đây là không gian phát triển và lưu trữ của ứng dụng di động chữa lành cảm xúc, kết nối linh hồn kỹ thuật số độc bản của thú cưng với chủ nuôi.

---

## 🗺️ Quy hoạch Cấu trúc Thư mục (Workspace Layout)

Không gian làm việc được tổ chức chặt chẽ thành các phân vùng chức năng sau:

*   **`Document/`**: Thư mục chứa toàn bộ tài liệu đặc tả, thiết kế, báo cáo, và tuyên ngôn của dự án.
    *   [Tổng quan dự án](file:///Users/macinia/Capcat%20Project/Document/02_OVERALL.md)
    *   [Kim chỉ nam sứ mệnh](file:///Users/macinia/Capcat%20Project/Document/03_VISION_MANIFESTO.md)
    *   [Tuyên ngôn định vị thương hiệu & MKT](file:///Users/macinia/Capcat%20Project/Document/04_BRAND_MARKETING_MANIFESTO.md)
    *   [Danh sách tính năng MVP](file:///Users/macinia/Capcat%20Project/Document/05_FEATURE_LIST.md)
    *   `History/`: Thư mục lưu trữ nhật ký hội thoại đồng sáng tạo (Chat History) của team.
*   **`lib/`**: Mã nguồn cốt lõi của ứng dụng di động Flutter.
    *   `theme/`: Hệ thống style, font chữ (`Quicksand`, `Motterdam`) và palette màu ấm áp hoài niệm (Cozy Earthy Palette).
*   **`.agents/`**: Cấu hình, workflows và kỹ năng nội tại dành riêng cho các Đặc vụ AI (AI Agents).

---

## 🏛️ Nguyên tắc Hành xử & Phát triển (Behavioral Rules for Developers & Agents)

Để dự án vận hành mượt mà, tránh nợ kỹ thuật (Tech Debt) và lệch hướng sản phẩm (Scope Creep), tất cả lập trình viên và các Đặc vụ AI bắt buộc phải tuân thủ các nguyên tắc sau:

### 1. Tuyệt đối tôn trọng Phạm vi MVP & Định vị (Scope & Boundaries)
*   **Không phình to tính năng (Scope Creep):** Tuyệt đối không phát triển hay đặc tả các tính năng ngoài định vị (như *Safe Vet Engine*, *Assistant Host* toàn cục phức tạp). Mọi tính năng đề xuất phải được chấm qua bộ ba câu hỏi vàng tại [Tuyên ngôn sứ mệnh](file:///Users/macinia/Capcat%20Project/Document/03_VISION_MANIFESTO.md#L84-L92) và đạt 3/3 điểm đồng ý mới được thực hiện.
*   **Không tự ý khôi phục các thư mục đã xóa:** Thư mục `capcat_app` đã được dọn dẹp do không nằm trong lộ trình code của nhánh hiện tại. Không tự ý tạo lại hoặc import code rác.

### 2. Đồng bộ hoá và Chăm sóc Tài liệu (Documentation Integrity)
*   **Lưu trữ Nhật ký Hội thoại chuẩn xác:** Mọi file chat history (dạng `CHAT_HISTORY_DDMMYYYY.md` hoặc thư mục turn chi tiết) bắt buộc phải gom vào thư mục [Document/History/](file:///Users/macinia/Capcat%20Project/Document/History).
*   **Liên kết chéo (Interlocking):** Khi tạo hoặc cập nhật tài liệu mới, hãy luôn bổ sung liên kết tương ứng đến các tài liệu liên quan (MOM, PRD, Brand/Vision Manifesto) để đảm bảo tính truy vết (Traceability).
*   **Giữ tài liệu sạch sẽ:** Xoá bỏ các file spec/design đã lỗi thời hoặc bị loại bỏ khỏi phạm vi (ví dụ: spec Safe Vet).

### 3. Ngôn ngữ thiết kế & Trải nghiệm Iyashikei
*   Tông giọng viết nội dung truyền thông và hiển thị UI phải nhất quán theo [Tuyên ngôn Thương hiệu](file:///Users/macinia/Capcat%20Project/Document/04_BRAND_MARKETING_MANIFESTO.md) (Cozy, tối giản MUJI ấm áp, chân thành, hóm hỉnh dưới góc nhìn thứ nhất của Boss, không gây hoang mang hay hối thúc user bằng thông báo rác).
*   Mọi component giao diện phải được xây dựng dựa trên theme màu gỗ ấm hoài niệm và các token thiết kế đã được định nghĩa.

---

## 🚀 Hướng dẫn Bắt đầu Nhanh (Quick Start)

1.  **Nghiên cứu Định hướng:** Đọc kỹ hai tài liệu cốt lõi là [Brand Marketing Manifesto](file:///Users/macinia/Capcat%20Project/Document/04_BRAND_MARKETING_MANIFESTO.md) và [Vision Manifesto](file:///Users/macinia/Capcat%20Project/Document/03_VISION_MANIFESTO.md) trước khi sửa code hoặc viết tài liệu.
2.  **Vận hành mã nguồn:** Các logic state management và widget nằm gọn trong `lib/`. Hãy tuân thủ cấu trúc Clean Architecture của Flutter khi thêm tính năng mới.
