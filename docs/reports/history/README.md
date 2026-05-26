# Hướng Dẫn Lưu Trữ Lịch Sử Cuộc Hội Thoại (Chat History SOP)

Thư mục `docs/reports/history/` này được sử dụng để lưu trữ toàn bộ các biên bản làm việc, thiết kế kiến trúc, và các quyết định chiến lược giữa Product Owner (PO) và các Đặc vụ AI (Sophia, Alan, Arthur, Leo, v.v.).

## ⚠️ CHỈ THỊ CHO HỆ THỐNG AI (SYSTEM INSTRUCTION)
Bất kỳ AI Agent nào khi được yêu cầu "Lưu lại lịch sử chat" hoặc "Lưu biên bản làm việc", **BẮT BUỘC** phải tuân thủ nghiêm ngặt 3 quy tắc sau:

### 1. Quy tắc Đặt tên File (Naming Convention)
*   File phải được tạo và lưu tại thư mục: `docs/reports/history/`.
*   Định dạng tên file: `chat_history_DDMMYY.md` (Ví dụ: `chat_history_170526.md`).
*   Nếu trong cùng một ngày có nhiều phiên làm việc, nối thêm hậu tố (Ví dụ: `chat_history_170526_p2.md`).

### 2. Cấu trúc File Bắt Buộc (Mandatory Structure)
Mỗi file lịch sử phải luôn chứa đủ 3 phần mạch lạc:
*   **Phần 1: Tổng hợp những việc đã làm (What was done):** Gạch đầu dòng tóm tắt các quyết định kỹ thuật, tài liệu đã cập nhật, hoặc tính năng vừa chốt.
*   **Phần 2: Đã đạt được gì (Outcomes/Impact):** Nêu bật giá trị cốt lõi của phiên làm việc (Ví dụ: "Đã bít kín kẽ hở logic của tính năng X").
*   **Phần 3: Full Transcript (Ghi chép Hội thoại chi tiết):** Đây là phần quan trọng nhất. Phải ghi lại diễn biến cuộc họp theo kịch bản nhân vật (Role-play). **Tuyệt đối không chỉ tóm tắt chung chung, phải ghi rõ AI nào nói gì và PO chỉ đạo gì.**

### 3. Ví dụ mẫu cho Phần 3 (Transcript Format)
```text
**👤 PO (Người dùng):** [Nội dung yêu cầu hoặc bóc lỗi...]
**🤖 Sophia (CPO):** [Giải thích giải pháp hoặc vá lỗi...]
**🕵️ Alan (Tech Lead):** [Nhận xét rủi ro từ góc độ kỹ thuật...]
```

> **Lưu ý tối quan trọng (Core Memory):** Thư mục này là "hộp đen" giải thích "TẠI SAO" dự án lại có hình thù như hiện tại. Mọi AI sau này khi đọc vào dự án phải quét thư mục này để hiểu Context lịch sử trước khi ra quyết định mới. Tuyệt đối không xóa các file cũ.
