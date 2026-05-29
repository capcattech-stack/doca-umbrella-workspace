# HƯỚNG DẪN VẬN HÀNH & LƯU TRỮ BIÊN BẢN HỌP (MOM)
*(MOM CREATION & CONSISTENT STORAGE GUIDELINES)*

> **Mã Tài Liệu:** `DOC-MOM-GUIDELINE`  
> **Chủ trì:** Sophia (CPO / PM)  
> **Quy chuẩn chất lượng:** Dev-Ready & Project Traceability

---

## 🧭 1. Mục Đích Của Thư Mục `MOM/`

Thư mục `Document/MOM/` được sử dụng làm **"Hồ sơ lưu trữ trí tuệ tập thể"** của dự án Capcat. Mỗi cuộc họp chiến lược giữa Sáng lập viên (User) và đội ngũ Cố vấn ảo (Sophia, Alan, Leo, Bella, Arthur) đều bắt buộc phải được đúc kết thành một Biên bản họp (MOM - Minutes of Meeting) chuẩn mực nhằm:
1.  **Ghi lại các Quyết định cốt lõi:** Tránh tình trạng tranh cãi hoặc trôi mất các quyết định quan trọng (như việc xoay trục MVP, hoãn tính năng).
2.  **Định hướng Lập trình (Action Items):** Cung cấp danh sách đầu việc rõ ràng, được giao cụ thể cho từng thành viên (Tech Lead Alan, UI/UX Benny/Bella).
3.  **Lịch sử đối chiếu (Traceability):** Giúp các thành viên mới gia nhập dự án nắm bắt ngay lập tức lý do tại sao một tính năng lại được thiết kế hoặc hoãn lại như hiện tại.

---

## 📂 2. Quy Tắc Đặt Tên & Lưu Trữ Nhất Quán (Naming Conventions)

Mọi tệp tin MOM được tạo ra bắt buộc phải tuân thủ nghiêm ngặt quy tắc đặt tên sau:

$$\text{[YYYY-MM-DD]\_[MOM]\_[Ten\_Chu\_De\_Hop].md}$$

*   **YYYY-MM-DD:** Ngày diễn ra cuộc họp theo giờ hệ thống (Ví dụ: `2026-05-29`).
*   **MOM:** Nhãn nhận diện tệp là Biên bản họp (viết hoa).
*   **Ten_Chu_De_Hop:** Tên ngắn gọn của tính năng hoặc chủ đề họp viết bằng tiếng Anh không dấu, nối với nhau bằng dấu gạch dưới `_`.
*   *Ví dụ chuẩn:* `2026-05-29_MOM_Cozy_Chat_Resonance_Engine.md`

---

## 📝 3. Cấu Trúc File MOM Chuẩn (Standard MOM Template)

Mỗi tệp MOM phải bao gồm các phần cốt lõi sau (sử dụng định dạng Markdown):

1.  **Tiêu đề:** Tên cuộc họp viết hoa nổi bật kèm phụ đề.
2.  **Metadata cuộc họp:** Thời gian diễn ra, Địa điểm, và danh sách các thành viên tham gia đầy đủ vai trò.
3.  **I. CÁC QUYẾT ĐỊNH CHIẾN LƯỢC QUAN TRỌNG:** Ghi lại các quyết định thống nhất cao (ví dụ: Zero-RAG, Sheets làm CMS, hoãn đĩa than ảo).
4.  **II. HỆ THỐNG ĐẶC TẢ CHI TIẾT ĐÃ HOÀN THÀNH (SPECS INDEX):** Bảng tổng hợp các file Spec con (`SPEC_01` -> `SPEC_N`) được tạo mới hoặc cập nhật trong phiên họp kèm link click trực tiếp.
5.  **III. KẾT QUẢ ĐÁNH GIÁ PHẢN BIỆN (MOM TEST & DOANH THU):** Kết quả chạy giả lập Mom Test với các Persona của Arthur và dự báo tài chính của Leo.
6.  **IV. KẾ HÀNH HÀNH ĐỘNG TIẾP THEO (ACTION ITEMS):** Giao việc cụ thể, có tag trạng thái (✅ Hoàn thành / ⏳ Chờ thực hiện) kèm tên người chịu trách nhiệm.

---

## 🔗 4. Liên Kết Nhất Quán Giữa MOM & Chat History

*   Mỗi tệp MOM tại `Document/MOM/` phải có một tệp Nhật ký hội thoại tương ứng tại `Document/Chat history/` hoặc một file tổng hợp `Document/CHAT_HISTORY_YYYYMMDD.md` để đối chiếu luồng suy nghĩ.
*   Ở phần Metadata hoặc cuối file MOM, bắt buộc phải chèn link dẫn trực tiếp sang Chat History của ngày đó để bất kỳ lập trình viên nào cũng có thể đọc lại toàn bộ nội dung thảo luận chi tiết khi cần đào sâu ngữ cảnh.
