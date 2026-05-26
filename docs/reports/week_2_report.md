# BÁO CÁO TUẦN 2: DỰ ÁN IDEA WORKSHOP (MVP v0)
*Tài liệu này được tối ưu hóa để làm đầu vào (Input) cho NotebookLM tạo Slide thuyết trình.*

---

## Slide 1: Tuyên Bố Vấn Đề (The Problem)
*   **Thực trạng:** Các ý tưởng công nghệ hiện nay thường được duyệt và đưa vào code dựa trên cảm tính hoặc trực giác của người đề xuất.
*   **Nỗi đau:** 
    *   Tốn hàng tháng trời và hàng trăm triệu chi phí Dev để xây dựng những tính năng mà thị trường không cần.
    *   Thiếu sự phản biện độc lập (Mom Test) và dự báo Lãi/Lỗ (ROI) trước khi bắt tay vào làm.

## Slide 2: Giải Pháp - Idea Workshop (The Solution)
*   **Định nghĩa:** Một "Phòng khám Ý tưởng" vận hành hoàn toàn bằng hệ thống Đa đặc vụ Trí tuệ Nhân tạo (Multi-Agent AI).
*   **Mục tiêu:** Chuyển đổi từ ý tưởng thô (Raw Idea) -> Trải qua vòng lặp chất vấn đa chiều -> Phân loại và xuất ra Đặc tả kỹ thuật (PRD) hoặc Kịch bản khảo sát (Mom Test).
*   **Giá trị Kinh doanh (Business Value):**
    *   *Với nội bộ:* Chặn đứng các tính năng rác trước khi tiêu tốn tài nguyên Dev.
    *   *Với khách hàng (Lead Gen):* Trở thành vũ khí tạo "Đòn bẩy Niềm tin" (Trust Factor). Khách hàng sẽ tin tưởng một Agency dám phản biện và bảo vệ túi tiền của họ, thay vì gật đầu làm bừa.
*   **Khẩu hiệu:** *Mài giũa ý tưởng trước khi tốn một dòng code nào.*

## Slide 3: Kiến trúc Ban Cố Vấn Ảo (The Advisory Board)
Hệ thống sử dụng mô hình **Facade Pattern** (Một giao diện duy nhất) để tối ưu trải nghiệm người dùng:
*   **Sophia (Cố vấn Trưởng / Trọng tài):** Người duy nhất chat với User. Mang thái độ thấu cảm, tổng hợp điểm số và chắp bút viết PRD.
*   **Arthur (Kẻ Phản Biện Thị Trường):** Hoạt động ngầm. Chạy mô phỏng khách hàng ảo (`PersonaTwin`) để ép User phải có bằng chứng hành vi thực tế.
*   **Leo (Kế toán Trưởng):** Hoạt động ngầm. Dùng dữ liệu nội bộ (`baseline_metrics.md`) để tính Độ phủ (Reach) và Lãi/Lỗ (P&L).
*   **Alan (Kỹ sư Trưởng):** Hoạt động ngầm. Dựa vào kiến trúc hệ thống cũ (`eco_system_context.md`) để báo giá số ngày công (Tech Cost).

## Slide 4: Phạm Vi Dự Án (MVP v0 Scope Lock-in)
*   **Luồng Người dùng (Anonymous User):**
    *   Không cần đăng nhập. Nhập ý tưởng và nhận mã PIN bảo mật 6 số.
    *   Chat Streaming theo thời gian thực. Hỗ trợ upload file đính kèm.
    *   Khôi phục phiên làm việc chéo thiết bị (Cross-device) bằng Link + mã PIN.
*   **Luồng Quản trị (Admin/PO):**
    *   Đăng nhập bằng Google SSO (Next-Auth).
    *   Bảng Kanban theo dõi toàn bộ các ý tưởng đang được AI đánh giá.
    *   Khu vực cấu hình AI (Agent Config) và cập nhật số liệu kinh doanh.

## Slide 5: Những "Luật Thép" Độc Tôn (Core Business Rules)
Dự án sở hữu các cơ chế phòng thủ thông minh để AI không bị "ảo giác" (Hallucination):
*   **RICE Cut-off:** Tự động từ chối ý tưởng nếu điểm đánh giá quá thấp.
*   **Pivot & Dry-Run (Bẻ lái ngầm):** Khi ý tưởng thất bại, hệ thống không chỉ trích, mà tự động chạy thử ngầm một giải pháp thay thế. Nếu khả thi mới dùng thái độ thấu cảm để đề xuất cho User.
*   **Assumption Override (Quyền Vượt Rào):** Cho phép User ép hệ thống duyệt tính năng dù rủi ro cao, nhưng sẽ bị gắn nhãn đỏ `[HIGH RISK MVP]`.
*   **Đầu ra thích ứng (Adaptive Output):** AI sẽ tự nhận diện độ "chín" của ý tưởng. Ý tưởng non nớt sẽ nhận được *Kịch bản đi phỏng vấn khách hàng*. Ý tưởng chín muồi mới nhận được *Đặc tả Kỹ thuật (PRD)*. Tránh Over-engineering.

## Slide 6: Hiện Trạng Dự Án & Kế Hoạch Tiếp Theo (Status & Next Steps)
*   **Trạng thái hiện tại (Đã hoàn thành Phase 1 & 2):**
    *   Tài liệu Backlog (EPIC 1-5) và Sơ đồ luồng (Cross-Verification Workflow) đã được khóa chặt.
    *   Database Schema (Prisma/SQLite) và thư mục Next.js đã khởi tạo xong.
    *   Toàn bộ Giao diện Giả lập (Mock UI) từ Landing Page, Chat Room chia đôi, đến Bảng quản trị Kanban đã được code xong và tinh chỉnh UX hoàn hảo bởi Maya.
    *   Hệ thống bảo mật (Google SSO, PIN Wall) đã dựng xong (Phase 3).
*   **Nợ Kỹ Thuật (Tech Debt MVP v0):** Chấp nhận một số rủi ro về giới hạn bộ nhớ AI (Context Window) và độ trễ chờ đợi (Latency). Sẽ khắc phục bằng UI loading thông minh.
*   **Lộ trình (Roadmap) tiếp theo:**
    *   **Tuần 3:** Ghép nối Não bộ AI LangGraph và API (OpenAI).
    *   **Tuần 4:** Kiểm thử nội bộ (UAT) bằng dàn Đặc vụ QA (Eve) và Go-live.
