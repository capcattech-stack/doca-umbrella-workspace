# 🛠️ Idea Workshop - AI-Powered Ideation & Validation Matrix

**Idea Workshop** (Xưởng Idea) là hệ thống kiến trúc điều phối AI đa đặc vụ (Multi-Agent Orchestration) được sinh ra để tự động hóa vòng đời phát triển sản phẩm (SDLC). Nó xóa bỏ khoảng cách giữa giai đoạn Lên ý tưởng (Ideation) mộng mơ và Giai đoạn Nghiệm thu (UAT) thực tế.

Bằng cách áp dụng **Khung Đánh đổi (Trade-off Matrix)**, **P&L / RICE Score**, và **The Mom Test**, hệ thống AI sẽ bẻ gãy mọi ý tưởng viển vông *trước khi* dòng code đầu tiên được viết ra, tự động sinh ra tài liệu PRD hoặc User Story đạt chuẩn.

---

## 🎯 Cấu Trúc Dự Án (Project Hierarchy)

Dự án này là nền tảng khởi chạy phiên bản MVP v0 của Idea Workshop:

*   **`docs/`**: Bộ Não Kiến Trúc. Chứa các tài liệu đặc tả MVP v0, C4 Diagram, DAG Orchestration (luồng điều phối đặc vụ AI), API Contract và các File Mẫu (PRD_Template). Xem chi tiết tại [docs/README.md](docs/README.md).
*   **`core/`**: Chứa lõi Prototype (Bản POC bằng Python `poc_cli.py`) để chạy thử nghiệm và mô phỏng luồng tư duy của AI Orchestrator (Sophia) và Ban bệ đặc vụ.
*   **`web/`**: Giao diện Web Application (Next.js) - *Đang trong quá trình triển khai*.
*   **`.agents/`**: Kho lưu trữ các Đặc vụ AI (Skills & Workflows). Nơi chứa "Linh hồn" (Prompt/Soul) của các đặc vụ như `sophia-product-manager`, `alan-tech-lead`, và đặc biệt là kỹ năng `personatwin` (chuyên giả lập Mom Test).

---

## 🚀 Hướng Dẫn Chạy Thử Prototype (MVP v0 CLI)

Bản POC (Proof of Concept) hiện đã hoàn thiện và bao bọc toàn bộ luồng tư duy của hệ thống:
1. Phân loại ý tưởng tự động (Auto-Routing).
2. Tính toán P&L (cho tính năng mới) và RICE Score (cho cải tiến).
3. Sử dụng Output Sizing Matrix để xuất file (PRD 10 phần hoặc User Story).

**Để chạy giả lập:**
Mở Terminal tại thư mục gốc và chạy lệnh:
```bash
python3 core/poc_cli.py
```
*Kết quả xuất ra sẽ tự động lưu vào thư mục `samples/`.*

---

## 🏗️ Kiến Trúc AI Điều Phối (Marcus Orchestration DAG)

Hệ thống sử dụng mô hình Máy Trạng thái Phân cấp (Hierarchical State Machine) để tránh tình trạng lặp vô hạn (Infinite Loop).

- **Tầng 1 (Gateway):** Cố Vấn Ảo & Sophia (Product Agent) phân loại ý tưởng thành `[NEW]` hoặc `[ENHANCE]`.
- **Tầng 2 (Interrogation Loop):** 
  - *Arthur (Market Agent)* ép bằng chứng và phạt niềm tin (Confidence).
  - *Leo (Data Agent)* lập bảng P&L hoặc đối chiếu `baseline_metrics.md`.
  - *Alan (Tech Tech)* đánh giá Man-days (Effort).
- **Tầng 3 (Arbitrator):** Sophia chốt điểm ROI/RICE và dùng **Output Sizing Matrix** để quyết định xuất File gì.
- **Tầng 4 (Hậu kiểm):** Eve (QA Agent) tự động viết UAT Testcases.

*(Tham chiếu chi tiết luồng DAG bằng Mermaid tại: [docs/ai_orchestration_dag.mmd](docs/ai_orchestration_dag.mmd))*

---

## 📌 Về Bộ Kỹ Năng PersonaTwin (Mom Test Simulator)
*(Hệ thống sử dụng kỹ năng PersonaTwin làm Core Filter cho Market Agent)*

Kỹ năng này áp dụng nghiêm ngặt nguyên lý **The Mom Test** để bẻ gãy mọi ý tưởng viển vông dựa trên lời khen giao tiếp xã giao. Mọi bằng chứng không xuất phát từ data đều bị phạt điểm tự tin (Confidence) xuống 10%.
Nội dung giới thiệu cũ của hệ thống giả lập PersonaTwin vẫn được lưu trữ vẹn nguyên tại thư mục `.agents/skills/personatwin/`.

---
*Tài sản trí tuệ thuộc về hệ sinh thái Antigravity & Idea Workshop - Khởi tạo 05/2026*
