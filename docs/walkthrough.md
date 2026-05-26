# 📓 Nhật Ký Thay Đổi & Lịch Sử Bản Pivot (Walkthrough - MVP v0 Pivot)

Tài liệu này ghi lại toàn bộ lịch sử thảo luận, các quyết định thiết kế chiến lược và các thay đổi thực tế trong codebase/backlog cho đợt **Pivot chiến lược sang Mobile-First & Single Chat Graph** ngày 19/05/2026.

---

## 🎯 1. Tóm Tắt Quyết Định Pivot
Dự án **Product Forge (Idea Workshop)** đã thực hiện một bước chuyển dịch quan trọng từ mô hình Web Dashboard phức tạp (Notion-like) sang trải nghiệm di động **Mobile-First & Chat-Centric**.

### Các Trụ Cột Thay Đổi:
1. **Trải Nghiệm Chat Tối Giản (Claude-Style):** Chuyển sang giao diện chat toàn màn hình, tông màu Dark Mode mặc định, dải Progress Thread hiển thị tiến trình cuốn chiếu 6 Trụ cột.
2. **Loại Bỏ Độ Trễ Bằng Single Chat Graph:** Thay thế luồng gọi nhiều agent luân phiên (Path A / Path B) bằng một đồ thị hội thoại duy nhất do **Sophia (Product Groomer)** làm chủ.
3. **Phản Biện Ngầm Mom Test (Arthur):** Arthur (Market Agent) hoạt động chạy ngầm, không trực tiếp lộ diện để tránh gây cảm giác bị thẩm vấn cho người dùng. Sophia sẽ hấp thụ các rủi ro từ Arthur để chất vấn một cách tinh tế.
4. **Nhập Liệu Ma Sát Bằng 0 (Voice-to-Text):** Hỗ trợ nút ghi âm giọng nói ngay trên bàn phím ảo giúp giảm tải việc gõ phím trên mobile.
5. **Cơ Chế Tinh Tế (Reward before Request):** Khen ngợi và đồng cảm với bài toán thực tế của ý tưởng trước khi đưa ra các câu hỏi phản biện gắt gao.
6. **Dual Output (Canvas + PRD):** Trả về **One-Page Business Canvas** cho User trên di động, đồng thời lưu ngầm **Full Technical PRD** trong database phục vụ cho Dev.

---

## 🛠️ 2. Các File Đã Thay Đổi (Changelog)

### 📂 Tài Liệu Cốt Lõi (System & Backlog Docs):
- **[NEW] [MVP_V0_PIVOT.md](file:///Users/ricyuan/Documents/New%20repo/docs/MVP_V0_PIVOT.md):** Định nghĩa Single Source of Truth về chiến lược Pivot mới.
- **[NEW] [mobile_ux_spec.md](file:///Users/ricyuan/Documents/New%20repo/docs/mobile_ux_spec.md):** Đặc tả chi tiết UI/UX cho Claude-style Mobile Chat.
- **[NEW] [eco_moat_strategy.md](file:///Users/ricyuan/Documents/New%20repo/docs/eco_moat_strategy.md):** Chiến lược tích hợp Knowledge Base nội bộ làm "Cái hào phân cách" khác biệt so với ChatGPT công cộng.
- **[MODIFY] [EPIC-1-User-Experience.md](file:///Users/ricyuan/Documents/New%20repo/docs/backlog/EPIC-1-User-Experience.md):** Thay đổi các US từ Notion-style sang Mobile Chat, tích hợp Hybrid Auth, Suggesstion Chips và Voice-to-Text (US 1.8).
- **[MODIFY] [EPIC-2-Orchestration-Core.md](file:///Users/ricyuan/Documents/New%20repo/docs/backlog/EPIC-2-Orchestration-Core.md):** Xóa bỏ luồng DAG/RICE/P&L rườm rà, thay bằng Single Chat Graph + Arthur Mom Test và Dual Output Generation (US 2.4).
- **[MODIFY] [EPIC-5-AI-Agents.md](file:///Users/ricyuan/Documents/New%20repo/docs/backlog/EPIC-5-AI-Agents.md):** Cập nhật vai trò mới của Sophia (Product Mentor) và Arthur (Seamless Mom Test). Tạm treo đặc vụ Leo (Data).
- **[MODIFY] [product_forge_mvp_v0.md](file:///Users/ricyuan/Documents/New%20repo/docs/product_forge_mvp_v0.md):** Đồng bộ hóa tài liệu đặc tả chung của sản phẩm với PIVOT 19/05.
- **[MODIFY] [MVP_v0_Implementation_Plan.md](file:///Users/ricyuan/Documents/New%20repo/docs/MVP_v0_Implementation_Plan.md):** Cập nhật DoD cho các nhóm Frontend/Backend, cập nhật Nhật ký nợ kỹ thuật (Tech Debt Log) về chiến lược quản lý Token của Marcus.

### 💻 Codebase (AI Logic):
- **[MODIFY] [prompts.ts](file:///Users/ricyuan/Documents/New%20repo/web/src/lib/ai/prompts.ts):** 
  - Tích hợp nguyên tắc bọc đường tinh tế ở RULE-1 và RULE-5.
  - Viết lại `PRD_GENERATOR_PROMPT` theo chuẩn Dual Output ( Canvas + Full PRD).

---

## 📈 3. Kế Hoạch Tiếp Theo (Next Steps)
1. **Backend Integration:** Tích hợp `loadEcoContext` vào `graph.ts` để đọc dữ liệu từ `eco_context.md` phục vụ cơ chế "Fake RAG".
2. **Frontend UI Setup:** Dựng khung Next.js chat toàn màn hình, parse logic hiển thị Contextual Suggestion Chips từ LLM response.
3. **Voice Testing:** Hiện thực hóa API nhận file ghi âm giọng nói chuyển thành text.

---
*Báo cáo được tổng hợp và phê duyệt bởi Ada QA & Marcus Architect.*
