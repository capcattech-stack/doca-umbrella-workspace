# Quy Chuẩn Git & Chiến Lược Phân Nhánh (Git Conventions & Branching Strategy)

> Tài liệu quy chuẩn áp dụng cho toàn bộ thành viên dự án (PO, Developers) và các AI Agents trong hệ sinh thái Capcat / DOCA.

---

## 1. 🌳 Bố Cục Phân Nhánh Chuẩn (Branching Hierarchy)

Áp dụng thống nhất cho tất cả các Repository (Root Meta-Repo, Submodule `doca-affiliate-web`, Sub-repos `apps/coin-hub`, `apps/core-platforms`):

*   **`main` / `master` (Production):**
    *   Chứa mã nguồn đang chạy trực tiếp trên môi trường Production (`doca.capcat.vn`, `admin.capcat.vn`).
    *   **Tuyệt đối không commit trực tiếp**, chỉ nhận pull/merge từ nhánh `staging` (hoặc hotfix đã qua kiểm thử).
*   **`staging` (Pre-production / CI/CD Gate):**
    *   Nhánh đệm để Vercel / CI/CD tự động bắt sự kiện, build và chạy kiểm tra trước khi release.
    *   Khi kiểm thử trên `staging` đạt chuẩn ➔ Tạo Pull Request merge vào `main`.
*   **`dev` (Integration / Tổng hợp code):**
    *   Nhánh làm việc chung chứa code mới nhất của toàn team, nơi hội tụ code hàng ngày từ các thành viên và AI Agents.
*   **Tầng nhánh con (Feature / Fix / Research):**
    *   Tách từ `dev` (hoặc từ `main` nếu là Hotfix hoặc tính năng độc lập).
    *   **Tên nhánh:** Ưu tiên theo đúng chỉ định của User/PO (`khai_dev`, `nguyen_define`...); nếu không có chỉ định thì dùng tiền tố chuẩn (`feat/...`, `fix/...`, `chore/...`).

---

## 2. 🎯 Nguyên Tắc "Lazy Branching" Ở Source Con (Submodules & Apps)

*   Mọi luồng công việc bắt đầu từ thư mục Root (`capcat_project.git`).
*   **Chỉ tạo/chuyển branch ở thư mục con** (`doca-affiliate-web`, `apps/coin-hub`...) **KHI VÀ CHỈ KHI** task đó có phát sinh chỉnh sửa trực tiếp bên trong thư mục con đó.
*   Nếu task không đụng đến code của thư mục con ➔ Giữ nguyên, không tạo nhánh rác ở source con.

---

## 3. 🚦 Phân Luồng Xử Lý & Đồng Bộ (Workflow Protocols)

### A. Luồng Sửa Lỗi / Hotfix (Ưu tiên an toàn tuyệt đối)
1.  **Nguồn gốc:** Tách branch `fix/...` trực tiếp từ **`main`**.
2.  **Đồng bộ trước khi làm:** Kéo code mới nhất từ `origin main`.
3.  **Quy tắc Hợp nhất (Multi-Merge):** Sau khi sửa xong và test OK ➔ Merge đồng thời vào cả **`main`**, **`staging`**, và **`dev`** để đảm bảo bản vá có mặt ở mọi môi trường, không bao giờ bị trôi bug.

### B. Luồng Tính Năng Mới / Nghiên Cứu (Linh hoạt theo ngữ cảnh)
Agent/Dev tự động kiểm tra hiện trạng code:
*   **Có phụ thuộc code mới:** Nếu tính năng cần các thay đổi mới nhất đang có trên `dev` ➔ Tách từ **`dev`** (và pull `origin dev`).
*   **Tính năng độc lập:** Nếu tính năng tách biệt hoặc `dev` đang chứa nhiều code dở dang không liên quan ➔ Tách từ **`main`** (và pull `origin main`).

---

## 4. 💬 QUY TẮC VÀNG: Luôn Hỏi Xác Nhận (Confirm) Trước Khi Thao Tác

AI Agent **tuyệt đối không tự ý switch branch hay commit đè** mà luôn đưa ra đề xuất rõ ràng để User/PO quyết định:

*   **Khi nhận yêu cầu SỬA LỖI (Fixbug / Hotfix):**
    > *"Hiện tại bạn đang có một số thay đổi dở dang trên nhánh `[tên_nhánh_hiện_tại]`. Mình sẽ commit/stash lưu lại những gì bạn đang làm, sau đó tạo branch `fix/[tên-lỗi]` từ `main` để xử lý lỗi này nhé?"*
*   **Khi nhận yêu cầu TÍNH NĂNG MỚI (Feature):**
    > *"Tính năng này độc lập với nhánh `dev` (hoặc: cần code mới nhất trên `dev`). Bạn muốn mình tách branch mới `feat/[tên-tính-năng]` từ `[main / dev]` để làm, hay bạn muốn tiếp tục trao đổi và làm luôn trên branch hiện tại (`[tên_nhánh_hiện_tại]`)?"*

---

## 5. 🛡️ Giới Hạn Commit & Push An Toàn (Strict Push Boundary)

*   **KHÔNG BAO GIỜ tự động `git push` lên `origin`:** Trừ khi có sự yêu cầu/xác nhận rõ ràng từ con người.
*   **KHÔNG BAO GIỜ tự ý ghi đè (Force Push -f):** Tuyệt đối không dùng `git push --force` trên các nhánh dùng chung (`main`, `staging`, `dev`).
*   **Chỉ Commit/Push khi có lệnh:** Luôn giữ thay đổi ở local working directory cho đến khi người dùng yêu cầu commit hoặc bàn giao.
