# 📝 Chat History - Phiên làm việc ngày 10/05/2026

**Chủ đề:** Nâng cấp Năng lực Thẩm định AI (P&L, RICE Score) & Hoàn thiện Kiến trúc Điều phối (DAG) cho Product Forge MVP v0.

---

## 1. Các Quyết định Chiến lược (Strategic Decisions)

1. **Cơ chế Phân loại Tự động (Auto-Routing):**
   - **Tính năng Mới (New Feature):** Chạy luồng **P&L**. Ép User cam kết doanh thu. Nếu Chi phí Dev (Man-days) > Doanh thu -> Đánh rớt hoặc ép cắt giảm Scope.
   - **Tính năng Cải tiến (Enhancement):** Chạy luồng **RICE Score**. 

2. **Cơ chế Ràng buộc Dữ liệu (Chống AI ảo giác - Hallucination):**
   - **Ground Truth cho [Reach]:** Bắt buộc đọc file `baseline_metrics.md` (do Admin cấu hình tĩnh).
   - **T-Shirt Sizing cho [Impact / Effort]:** Admin cấu hình bảng trọng số.
   - **Phạt niềm tin [Confidence]:** Nếu User không có "bằng chứng" (data, báo cáo) mà chỉ phỏng đoán cảm tính -> Phạt Confidence xuống 10% -> Đánh rớt RICE Score.

3. **Ma trận Quyết định Đầu ra (Output Sizing Matrix):** Chống Over-engineering.
   - Size S (< 3 ngày): Chỉ sinh `User Story + AC`.
   - Size M (3-10 ngày): Sinh `Feature Brief + List US`.
   - Size L/XL (> 10 ngày): Sinh `Full PRD`.

4. **Chuẩn hóa PRD Template (10 Phần bắt buộc):**
   - Đã thống nhất thêm 3 phần cực kỳ quan trọng do Product Manager đề xuất: **Người dùng mục tiêu**, **Chỉ số đo lường (Success Metrics)**, và **Ngoài phạm vi (Out of Scope)** (để lưu giữ bằng chứng thu hẹp ý tưởng, chống Scope Creep).

## 2. Các Tài liệu & Code đã Cập nhật/Tạo mới
- 📄 `docs/product_forge_mvp_v0.md`: Cập nhật Đặc tả MVP v0 toàn diện với các cơ chế trên.
- 📄 `docs/baseline_metrics_template.md`: Tạo file mẫu khung số liệu (MAU, Phễu, Lỗi) cho hệ thống để Admin dùng.
- 📄 `docs/PRD_Template.md`: Bộ khung PRD 10 phần tiêu chuẩn bắt buộc AI phải tuân thủ.
- 🗺️ `docs/ai_orchestration_dag.mmd`: Sơ đồ Cấu trúc AI điều phối đa đặc vụ (Máy trạng thái phân cấp - Hierarchical State Machine).
- ⚙️ `core/poc_cli.py`: Nâng cấp lại toàn bộ mã Python mô phỏng (POC) để chạy mượt mà cấu trúc DAG và các thuật toán đánh giá trên.

---
*Ghi chú: Lịch sử này được tự động lưu lại vào hệ thống để các Agents sau này có thể tham chiếu lại tiến trình ra quyết định của phiên làm việc.*
