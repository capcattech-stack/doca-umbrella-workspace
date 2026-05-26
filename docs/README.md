# 📚 Product Forge - Documentation Repository

Thư mục `docs/` là "Bộ Não Kiến Trúc" của dự án **Product Forge**. Đây là nơi lưu trữ toàn bộ các tài liệu đặc tả, bản thiết kế (Blueprints), sơ đồ luồng dữ liệu (DAG/C4), và các quy chuẩn đầu ra của hệ thống AI (PRD Templates).

Mục tiêu của thư mục này là đảm bảo sự minh bạch, nhất quán trong tư duy kiến trúc giữa con người (Quản trị viên/Kỹ sư) và các Đặc vụ AI (Marcus, Sophia, Alan, v.v.).

---

## 📂 Cấu trúc Tài liệu & Mục đích sử dụng

### 1. Đặc Tả Lõi (Core Specifications)
- **[`product_forge_mvp_v0.md`](./product_forge_mvp_v0.md):** 
  Tài liệu cốt lõi nhất (Kinh thánh của dự án). Chứa toàn bộ đặc tả hệ thống MVP v0, User Journey, mô hình Cố vấn Ảo & Ban bệ, cùng các cơ chế định tuyến phân tích đánh đổi (P&L vs RICE Score).

### 2. Sơ Đồ Kiến Trúc (Architecture Diagrams)
- **[`ai_orchestration_dag.mmd`](./ai_orchestration_dag.mmd):**
  Sơ đồ Mermaid quy định luồng Định tuyến Nhận thức (Cognitive Routing) của hệ thống AI. Mô tả chính xác quá trình đi từ Ý tưởng thô -> Phân loại -> Thẩm định đa đặc vụ -> Ma trận Quyết định đầu ra.
- **[`product_forge_c4.mmd`](./product_forge_c4.mmd):**
  Sơ đồ Cấu trúc C4 cấp độ Container, thể hiện bức tranh tổng thể về cách Web App, AI Orchestrator, PostgreSQL và Vector DB tương tác với nhau.

### 3. Tiêu Chuẩn Cấu Hình & Đầu Ra (Standard Templates)
- **[`PRD_Template.md`](./PRD_Template.md):**
  Bộ khung 10 phần bắt buộc mà AI (Product Agent) phải tuân thủ khi xuất tài liệu đặc tả PRD cho các tính năng quy mô lớn (Size L/XL). Thiết kế đặc biệt để chống *Scope Creep* với các mục In/Out of Scope rõ ràng.
- **[`baseline_metrics_template.md`](./baseline_metrics_template.md):**
  Tài liệu mẫu lưu trữ dữ liệu "Ground Truth" (Tổng user, Phễu, Lỗi). Quản trị viên (Admin) cập nhật file này định kỳ để Data Analytics Agent dùng làm mốc tính Reach/ROI, ngăn chặn hiện tượng AI "ảo giác" tự bịa số liệu.

### 4. Nhật Ký Phiên Làm Việc (Decision History)
- **[`chat_history_100526.md`](./chat_history_100526.md):**
  Ghi chép (Log) các quyết định chiến lược trong phiên làm việc ngày 10/05/2026 (Chốt hạ các cơ chế quan trọng như Auto-Routing, P&L, RICE Score và Output Sizing Matrix).

---

## 🛡️ Chỉ Thị Dành Cho Đặc Vụ AI (AI Agent Directives)

> **MANDATORY RULES:**
> 1. Trừ file lịch sử (`chat_history`), tuyệt đối **KHÔNG** sửa đổi các file kiến trúc cốt lõi nếu không có lệnh trực tiếp từ *Marcus Orchestrator* hoặc sự phê duyệt của *Human Admin*.
> 2. Bất cứ khi nào nhận lệnh xuất "PRD", AI **BẮT BUỘC** phải gọi lệnh đọc `PRD_Template.md` trước để tuân thủ định dạng.
> 3. Bất cứ khi nào cần kiểm tra luồng vận hành của hệ thống Product Forge, hãy tham chiếu file `ai_orchestration_dag.mmd`.
