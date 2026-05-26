# Tài Liệu Đặc Tả Công Cụ "Product Forge" - Phiên bản MVP v0 (CẬP NHẬT THEO PIVOT 19/05)

> **⚠️ LƯU Ý QUAN TRỌNG:** Tài liệu này đã được đồng bộ hóa hoàn toàn với `MVP_V0_PIVOT.md`. Các khái niệm cũ như tính điểm RICE, ROI tự động, Agent Leo (Data) và luồng đa đồ thị đã bị lược bỏ để tối ưu cho **Mobile-First, Chat-Centric** và **Seamless Mom Test**.

## 1. Tổng Quan Dự Án
**Tên tạm gọi:** Product Forge (Lò rèn Sản phẩm) / Idea Workshop
**Mục tiêu:** Xóa bỏ khoảng cách giữa giai đoạn Lên ý tưởng (Ideation) và Viết Đặc tả (PRD). Cung cấp một môi trường nơi ý tưởng kinh doanh của Business User được mài giũa bởi "Huấn luyện viên AI" (Tough Coach) để trở nên tường minh, thực tế, cuối cùng tự động xuất ra tài liệu PRD.
**Đối tượng sử dụng:**
- **Business User (Mobile-First):** Người đưa ra ý tưởng, không cần đăng nhập ban đầu, trải nghiệm ma sát bằng 0.
- **Admin / Product Owner (PO):** Người quản lý tổng thể vòng đời sản phẩm qua Kanban.

---

## 2. Kiến Trúc AI Mới (Single Chat Graph)

Hệ thống AI không còn dùng các luồng rẽ nhánh phức tạp. Kiến trúc MVP v0 sử dụng **Single Chat Graph**:

### 2.1. Cố vấn Trực tiếp: Sophia (Product Groomer)
- Đóng vai trò là điểm chạm duy nhất (Single Point of Contact) với người dùng.
- Vận hành theo thuật toán **6 Pillars Framework** (cuốn chiếu 6 trụ cột) và **Maya UX Doctrine** (tư vấn UI/UX chủ động).
- Hấp thụ rủi ro từ các Agent ngầm để chất vấn người dùng một cách tự nhiên.

### 2.2. Ban Bệ Ngầm (Background Evaluators)
- **Arthur (Market Agent - Mom Test):** Chạy ngầm khi Sophia có đủ 6 trụ cột. Không tiếp xúc User, chỉ bới móc lỗ hổng thị trường và mớm câu hỏi "hành vi quá khứ" cho Sophia.
- **Alan (Tech Agent):** Chạy ngầm cuối luồng để đánh giá rủi ro kỹ thuật, tạo **Insight Report** đính kèm vào PRD cho Admin xem (không chặn User).
- **Leo (Data Agent):** Đã tạm ngưng ở MVP v0 để tránh rủi ro AI bịa số (Hallucination).

---

## 3. Hành Trình Người Dùng (Mobile-First User Journey)

### 3.1. Luồng Người Dùng Ý Tưởng (Business User)
**Bảo mật Hybrid:** Bắt đầu bằng Ẩn danh (Idea ID + PIN). Có thể Đăng nhập sau qua Side Drawer để đồng bộ.

1. **Khởi tạo (Blank Canvas):** User vào Landing Page (Dark Mode), gõ ý tưởng vào ô trống ở giữa màn hình mà không cần đăng nhập. (Hỗ trợ nhập liệu bằng giọng nói Voice-to-Text).
2. **Grooming Room (Full-screen Chat):**
   - User chat 1-1 với Sophia. Có tích hợp nút Microphone to ở khung chat để User có thể nói thay vì gõ chữ, loại bỏ ma sát nhập liệu.
   - Dải **Progress Thread** mỏng ở trên cùng hiển thị tiến độ 6 trụ cột.
   - Sophia sử dụng **Contextual Suggestion Chips** hiển thị ngay trên bàn phím để User bấm phản hồi siêu tốc.
3. **The Mom Test (Thử lửa):** Sophia bất ngờ hỏi các câu hỏi xoáy sâu vào "hành vi quá khứ" để kiểm tra tính thực tế của nỗi đau.
4. **Nhận kết quả (Bottom Sheet):**
   - Khi hoàn thành, nút Floating **[Xem PRD ✨]** hiện ra. 
   - Ấn vào sẽ trượt lên một Bottom Sheet chứa PRD chuẩn Markdown (hoặc Báo cáo Mom Test nếu thất bại).

### 3.2. Luồng Quản Trị Viên (Admin Kanban)
1. **Cột 1: Ý Tưởng:** Chứa các Idea đang được User và AI thảo luận (Read-only).
2. **Cột 2: Kiểm Chứng (Đã ra PRD):** Chứa các Idea đã sinh PRD thành công. Kèm theo **Insight Report** (Tech/Market) từ Alan và Arthur để Admin duyệt.
3. **Cột 3: Phát Triển:** Kéo thả để theo dõi tiến độ Dev.
4. **Cột 4: Nghiệm Thu (UAT):** Chỗ QA Agent đọc PRD sinh Testcase (V1.1).
5. **Cột 5, 6:** Theo dõi vận hành, nâng cấp.

---

## 4. Cơ Chế Suggestion Chips (Bong bóng Gợi ý)
- Sinh ra tự động dựa trên Context của ý tưởng + Câu hỏi hiện tại của Sophia.
- Tối đa 4 chip. Nằm đè trên Input. Biến mất ngay khi User gõ phím hoặc chọn.
- **Proactive App Reference:** Nếu đang bàn về Flow/UI, các chip sẽ chứa dẫn chứng từ các app lớn (VD: *"Như MoMo: Nhập SĐT → OTP"*).

---

## 5. Output (Tài liệu đầu ra)
Hệ thống sử dụng `PRD_GENERATOR_PROMPT` gom toàn bộ 6 Trụ cột và lịch sử chat để xuất ra **DUAL OUTPUT** (2 phần độc lập):

- **Phần 1: One-Page Business Canvas (Dành cho Business User):**
  - Hiển thị trên Bottom Sheet của User Mobile.
  - Bao gồm: Chân dung khách hàng, Luồng hành trình, Rủi ro, và Nỗ lực Tech (Mức độ Khó/Dễ). Không có API hay Database.
  
- **Phần 2: Full Technical PRD (Dành cho Dev / Admin):**
  - Lưu ngầm vào Database và chỉ hiển thị ở Cột 2 trên Bảng Kanban Admin.
  - Bao gồm: Đặc tả luồng chi tiết, Edge Cases, Database Schema thô, API Payload, và Acceptance Criteria.

- **Trường hợp Trượt (Failed Mom Test / Rỗng):** Trả về Kế hoạch Phỏng vấn Mom Test (3 câu hỏi thực tế) để User tự đi hỏi khách hàng.

*(Tài liệu này đã được dọn dẹp bởi Ada QA Agent)*
