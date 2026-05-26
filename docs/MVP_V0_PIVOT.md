# 🚀 Product Forge MVP V0 — PIVOT DOCUMENT
> **Ngày cập nhật:** 19/05/2026
> **Người lập:** Sophia (AI Product Advisor) & PO
> **Mục tiêu tài liệu:** Ghi nhận lại toàn bộ những thay đổi mang tính bản lề (Pivot) về hướng tiếp cận sản phẩm và UX/UI so với tài liệu `product_forge_mvp_v0.md` gốc. Tài liệu này là nguồn chân lý (Single Source of Truth) mới cho Dev Team.

---

## PHẦN 1: PIVOT TRONG CÁCH TIẾP CẬN SẢN PHẨM (PRODUCT LOGIC PIVOT)

Chúng ta đã chuyển dịch từ tư duy **"Trọng tài máy móc" (Hard Gatekeeper)** sang tư duy **"Huấn luyện viên ráo riết" (Tough Coach)**.

### 1. Luồng Orchestration & Data Validation
* **[Cũ] Auto-routing & Toán học:** Hệ thống chia luồng P&L (Lợi nhuận) và RICE (Xứng đáng), dùng Leo (Data Agent) bắt bẻ số liệu dựa trên file baseline để tự động đánh trượt ý tưởng.
* **[Mới] Single Chat Graph & Mom Test:** Hệ thống chỉ chạy 1 luồng chat duy nhất. Bỏ hoàn toàn việc tính toán điểm ROI tự động để tránh AI ảo giác (Hallucination). Trọng tâm chuyển sang việc đánh giá "Sự thấu cảm khách hàng".

### 2. Sự "Bốc hơi" của Leo (Data Agent)
* Leo đã được loại bỏ khỏi luồng chặn người dùng.
* Hiện tại hệ thống ngầm (`InsightGraph`) chỉ dùng Arthur (Đánh giá rủi ro Mom Test) và Alan (Đánh giá chi phí kỹ thuật) để tổng hợp báo cáo (Insight Report) gửi cho Admin.

### 3. Vòng lặp Grooming & Áp dụng Mom Test
Thay vì cho phép người dùng tự do viết dông dài, Sophia giờ đây BẮT BUỘC phải khai thác đủ **6 Trụ cột (The 6 Pillars Framework)** bằng cách đặt câu hỏi cuốn chiếu:
1. Target User (Ai dùng?)
2. Context & Entrypoint (Ở đâu, khi nào?)
3. Core Value (Nỗi đau thực sự?)
4. Happy Path (Luồng chuẩn)
5. Edge Cases (Ngoại lệ)
6. Resolution (Cách xử lý ngoại lệ)

**Điểm ngoặt (The Twist):**
Khi đủ 6 thông tin, hệ thống tự động chèn cờ `[MOM_TEST_REQUIRED]`. Lúc này, Arthur sẽ chạy ngầm và vặn vẹo lại bản tóm tắt bằng 3 câu hỏi hóc búa (chuẩn Mom Test). Sophia truyền đạt lại 3 câu này để bắt người dùng phải đối mặt với rủi ro thị trường trước khi cho phép đệ trình (Submit).

---

## PHẦN 2: PIVOT VỀ TRẢI NGHIỆM NGƯỜI DÙNG (UX/UI PIVOT)

Toàn bộ triết lý thiết kế chuyển sang: **Mobile-First, Dark Mode, Chat-Centric, và Tối giản kognitive (Cognitive Load Minimization)**. Lấy cảm hứng từ sự mượt mà của Claude Mobile và Linear.

### 1. Định dạng Thiết kế Cốt lõi
* **Mobile-First:** Bỏ giao diện Desktop 2 cột (Split-pane) làm ưu tiên. Mọi trải nghiệm phải hoàn hảo trên màn hình dọc nhỏ gọn.
* **Màu sắc:** Dark Mode mặc định (`--bg-primary: #0D0D0F`, `--brand-accent: #6C63FF`). Không có nút gạt (toggle) sáng/tối để giảm effort phát triển.
* **Menu Navigation:** Sử dụng Side Drawer (Menu trượt từ trái) thay vì Header ngang, chứa: Lịch sử ý tưởng, Đăng nhập và Cài đặt.

### 2. Mô hình Xác thực (Auth)
* **[Cũ]** Hoàn toàn ẩn danh (Anonymous + PIN 6 số).
* **[Mới] Hybrid Model:** Mặc định vẫn là ẩn danh + PIN để rào cản sử dụng bằng 0. Nhưng bổ sung tùy chọn **Đăng nhập (Google/Email)** trong Menu. Khi login, toàn bộ ý tưởng ẩn danh được đồng bộ về tài khoản (Sync Server) và người dùng không cần nhớ PIN nữa.

### 3. Sáng kiến UX: Contextual Suggestion Chips (US 1.7)
Đây là thay đổi "wow" nhất để giảm ma sát cho người dùng trên Mobile:
* **Vị trí:** Chips hiển thị nổi ngay **phía trên** ô nhập liệu (Floating over input bar), dạng scroll ngang.
* **Logic xuất hiện:** Không hiện lúc mới chào. Chỉ hiện SAU khi Sophia đặt câu hỏi Grooming. Tự động trượt xuống (biến mất) ngay khi User bấm chọn hoặc tự gõ phím.
* **Nội dung thông minh (Contextual):** Khác với tĩnh (static), chip được sinh từ AI dựa trên ngữ cảnh. 
* **Quy tắc Tham chiếu App (App Reference Rule):** Nếu Sophia hỏi về "Luồng (Flow)", 2 trong 4 chip gợi ý bắt buộc phải là luồng tham chiếu từ các app lớn (MoMo, Shopee, Grab) kèm theo mô tả ngắn (VD: *"Như MoMo: Nhập số -> OTP -> Xác nhận"*). Sophia sẽ hỏi sâu sự khác biệt sau khi User chọn chip này.

### 4. Progress Journey & PRD Viewer (Mobile)
* **Thanh Tiến trình (Progress Thread):** Thay vì các chấm (dots) tốn diện tích, hệ thống dùng một dải gradient rất mảnh (~3px) nằm ngay dưới Header. Khi User chạm vào dải này, một Bottom Sheet trượt lên hiển thị chi tiết tiến trình 6 bước Grooming.
* **Xem tài liệu PRD:** Không nhồi nhét text trên giao diện chat. Khi trạng thái là `APPROVED`, một Floating Action Button (FAB) "Xem PRD ✨" nổi lên góc dưới phải. Bấm vào mở Full-screen Bottom Sheet chứa tài liệu Markdown để tải hoặc chia sẻ.

---

### TÓM TẮT THÔNG ĐIỆP
> "MVP V0 giờ đây không phải là một công cụ AI viết Document khô khan. Nó là một **Người Cố vấn Cầm Tay Chỉ Việc** trên Mobile. Rào cản nhập liệu bằng 0. User không cần gõ nhiều nhờ Suggestion Chips thông minh. Bị AI phản biện gắt gao để ý tưởng trưởng thành. Và cuối cùng là nhận PRD chất lượng cao."
