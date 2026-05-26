# EPIC 2: Lõi Điều phối AI Đặc vụ (AI Orchestration Core) — CẬP NHẬT THEO PIVOT 19/05/2026

**Mô tả:** Đây là "bộ não" của hệ thống. Kiến trúc đã chuyển từ "Auto-Routing P&L/RICE" rườm rà sang **Single Chat Graph (Sophia) + Mom Test ngầm (Arthur)** để giảm độ trễ, tránh AI Hallucination và tạo trải nghiệm mượt mà (Zero Friction) trên Mobile.

---

## US 2.1: Single Chat Graph (Sophia Grooming)
*   **As a** System
*   **I want to** chạy một Graph duy nhất do Sophia làm chủ để trò chuyện trực tiếp với User
*   **So that** hệ thống không bị trễ (latency) khi phải gọi nhiều Agent luân phiên.
*   **Acceptance Criteria:**
    *   Sophia sử dụng thuật toán cuốn chiếu (The 6 Pillars Framework) để hỏi User.
    *   Sophia chủ động tư vấn UI/UX (Maya Doctrine) thay vì chỉ ghi chép.
    *   Sophia tự động sinh ra chuỗi `[CHIPS: ...]` để Frontend parse thành các nút bấm gợi ý ngữ cảnh.

## US 2.2: The Mom Test Background Evaluation (Arthur)
*   **As a** System
*   **I want to** chạy ngầm (Background) sự đánh giá của Arthur khi Sophia thu thập đủ 6 Trụ cột
*   **So that** phát hiện các lỗ hổng thị trường mà không làm gián đoạn cuộc hội thoại của người dùng.
*   **Acceptance Criteria:**
    *   Arthur chỉ nhận Input là bản tóm tắt 6 Trụ cột từ Sophia.
    *   Output của Arthur là 2-3 RISK và QUESTION (hành vi quá khứ).
    *   Sophia hấp thụ các RISK/QUESTION này và tiếp tục hỏi User bằng giọng văn của mình (Seamless Integration) — tuyệt đối không tiết lộ danh tính của Arthur.

## US 2.3: Insight Graph (Admin Report)
*   **As a** System
*   **I want to** chạy một Graph ngầm song song (Insight Graph) bao gồm Alan (Tech) và Arthur (Market) khi kết thúc
*   **So that** tạo ra một báo cáo phân tích sâu (Insight Report) đính kèm vào PRD cho Admin xem khi duyệt bài.
*   **Acceptance Criteria:**
    *   Bỏ Leo (Data Agent) khỏi MVP v0.
    *   Alan đánh giá Tech Debt, Arthur đánh giá Mom Test Pass/Fail.
    *   Insight Report này KHÔNG hiển thị cho Business User, chỉ hiển thị ở màn hình Admin Kanban.

## US 2.4: PRD & Document Generation (Dual Output)
*   **As a** System
*   **I want to** sinh ra MỘT LÚC 2 định dạng tài liệu (One-Page Canvas và PRD) nếu ý tưởng đệ trình thành công
*   **So that** Business User có thể đọc bản Canvas nhẹ nhàng trên Mobile, còn Dev/Admin có bản PRD đầy đủ kỹ thuật.
*   **Acceptance Criteria:**
    *   Sử dụng Prompt độc lập (`PRD_GENERATOR_PROMPT`) để gom toàn bộ Chat History + 6 Pillars.
    *   **Phần 1 (Cho User):** One-Page Business Canvas (Chân dung KH, Luồng lõi, Rủi ro, Nỗ lực Tech). Hiển thị trên Bottom Sheet của User.
    *   **Phần 2 (Cho Dev):** Full Technical PRD (Có API, DB Schema, Edge Cases). Lưu ngầm vào Database và chỉ hiển thị ở giao diện Kanban của Admin.
    *   Nếu User không vượt qua Mom Test, hệ thống sinh ra "Kế hoạch Phỏng vấn Mom Test" thay vì PRD.
