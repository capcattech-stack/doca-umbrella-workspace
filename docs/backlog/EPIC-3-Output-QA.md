# EPIC 3: Trích xuất Tài liệu & Hậu kiểm (Output & QA)

**Mô tả:** Giai đoạn đóng gói sản phẩm trí tuệ của AI. Chuyển hóa các phân tích thành tài liệu tiêu chuẩn, có thể đem đi bàn giao cho team Development ngay lập tức, và hỗ trợ chỉnh sửa tài liệu liên tục thông qua Chat.

---

## US 3.1: Output Sizing Matrix
*   **As a** System
*   **I want to** dựa vào quy mô của tính năng (Effort Man-days do Alan tính) để quyết định xuất ra định dạng file phù hợp (Size S, M, L)
*   **So that** tránh việc viết một PRD dài 10 trang cho một tính năng chỉ mất 1 ngày code.
*   **Acceptance Criteria:**
    *   Size S (Dưới 3 ngày): Xuất User Story + Acceptance Criteria.
    *   Size M (3 - 10 ngày): Xuất Feature Brief + List of User Stories.
    *   Size L (Trên 10 ngày): Xuất Full PRD theo `PRD_Template.md`.
*   **Business Rules (Quy tắc Nghiệp vụ):**
    *   **[BR-OUTPUT-SIZE] Ma trận định dạng:** Việc chọn Template xuất file phụ thuộc hoàn toàn vào biến số `Estimated_Mandays` do Tech Lead (Alan) tính toán ở EPIC 2. Không được phép xuất Full PRD (Size L) cho các task < 3 mandays để tránh lãng phí tài nguyên.

## US 3.2: QA Agent & Auto UAT Testcases
*   **As a** System (Eve)
*   **I want to** tự động đọc hiểu văn bản đầu ra và sinh ra các kịch bản nghiệm thu (UAT Test-cases)
*   **So that** PO và QA thực tế có ngay công cụ để kiểm thử sau khi code xong.
*   **Acceptance Criteria:**
    *   Testcase phải được viết dưới dạng Gherkin (Given-When-Then) hoặc dạng Check-list.
    *   Đính kèm tự động vào cuối file PRD/User Story.

## US 3.3: Iterative Refinement via Chat (Cập nhật tài liệu)
*   **As a** User
*   **I want to** có thể tiếp tục chat với hệ thống sau khi tài liệu đã được sinh ra để yêu cầu thêm/bớt tính năng
*   **So that** tôi có thể tinh chỉnh (refine) tài liệu cho đến khi ưng ý.
*   **Acceptance Criteria:**
    *   User gõ yêu cầu thay đổi -> BA Agent (Sophia) cập nhật tài liệu.
    *   Tech Lead Agent (Alan) tự động chạy ngầm để kiểm tra tính khả thi của phần update. Nếu phi logic, Alan sẽ nhảy vào khung chat để phản đối.
    *   Sinh ra phiên bản mới của tài liệu (Version control cơ bản).
