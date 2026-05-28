# 📚 CAPCAT CHAT HISTORY: LƯỢT 10
*(NHẬT KÝ THẢO LUẬN & ĐẶC TẢ CHI TIẾT NGÀY 28/05/2026)*

---

### 🙋‍♂️ **Người dùng hỏi:**
> hãy viết lại tài liệu mô tả giải pháp xây dựng cẩm nang y khoa  và phân loai khẩn tấp này vào 1 tài liệu đặt tả. Lưu ở document

---

### 🤖 **Đặc vụ phản hồi:**

Tôi đã hoàn thành việc viết và biên soạn tài liệu đặc tả giải pháp **Safe-Vet AI Engine (Cẩm nang Y khoa & Phân loại Khẩn cấp)** cho dự án mới của bạn. 

Tài liệu đã được lưu trữ thành công trực tiếp vào thư mục mã nguồn của bạn tại:
👉 **[Document/03_SAFE_VET_AI_SPEC.md](file:///Users/macinia/Capcat%20Project/Document/03_SAFE_VET_AI_SPEC.md)**

---

### 📝 Tóm tắt Nội dung chính của Tài liệu Đặc tả (`03_SAFE_VET_AI_SPEC.md`):

1.  **Kiến trúc lõi RAG (Retrieval-Augmented Generation):**
    *   Sơ đồ hóa luồng nạp tri thức y học (từ MSD Vet Manual, ASPCA, Local FAQs) chuyển thành Vector embeddings và lưu trữ tại Vector DB.
    *   Cơ chế kết hợp câu hỏi người dùng + Tri thức y khoa truy xuất được + Thông tin động của Boss từ `PetDetail` (Loài, giống, số tháng tuổi, cân nặng, trạng thái triệt sản) để tạo prompt cực kỳ chính xác cho LLM.
2.  **Quy trình Phân loại Khẩn cấp (Safety Triage Protocol):**
    *   **🔴 Cấp độ Đèn Đỏ (Nguy kịch):** Nhận diện từ khóa/triệu chứng nghiêm trọng (khó thở, co giật, ngộ độc, chấn thương chảy máu). Hành động của AI: **Ngắt tư vấn thông thường**, hiển thị **Thẻ Cảnh báo Cấp cứu**, tự động dùng GPS **đề xuất 3 phòng khám gần nhất đang mở cửa**, và hiển thị **3 bước sơ cứu duy trì sự sống**.
    *   **🟡 Cấp độ Đèn Vàng (Cần theo dõi):** Triệu chứng nhẹ (tiêu chảy nhẹ, viêm da, ngứa tai). AI đưa ra cẩm nang tự chăm sóc dựa trên chỉ số cân nặng và giống loài của Boss.
    *   **🟢 Cấp độ Đèn Xanh (Thường ngày):** Chế độ ăn uống, huấn luyện, tiêm phòng. AI trò chuyện nhập vai tự nhiên theo tính cách của Boss (`PetPersona`).
3.  **Hợp đồ dữ liệu (API Contract):**
    *   Đặc tả chi tiết cấu trúc JSON Request gửi từ App Flutter lên Server và JSON Response từ Server trả về (chứa dữ liệu phân cấp Đèn báo triệu chứng, danh sách phòng khám cứu hộ gần nhất và tài liệu tham khảo).
4.  **Kế hoạch triển khai kỹ thuật (Implementation Roadmap):**
    *   **Tầng Backend:** Quy trình cào/cắt dữ liệu (LangChain), tạo vector và triển khai API.
    *   **Tầng Frontend (Flutter App):** Thiết kế giao diện **Emergency Warning Card** nổi bật, tích hợp cuộc gọi khẩn cấp/bản đồ chỉ đường (`url_launcher`), và nâng cấp State Management của Riverpod (`nanny_chat_provider.dart`).

---

### 🚀 Định hướng tiếp theo:
Dự án của bạn giờ đây đã có một tài liệu định hướng sản phẩm (PRD/Spec) cực kỳ rõ ràng, thực tế và mang tính ứng dụng cao. 
*   Bạn có muốn tôi bắt đầu cấu hình lại mã nguồn Flutter hiện có trong thư mục `capcat_app` (ví dụ như chuẩn bị lại Model `PetDetail` hoặc luồng `nanny_chat_provider.dart`) để chuẩn bị cho việc kết nối API y tế này không?
*   Hoặc nếu bạn muốn tôi bổ sung thêm phần nào vào tài liệu đặc tả này, hãy cứ cho tôi biết nhé!

---
*Tài liệu phân tách tự động từ hệ thống logs của Antigravity AI.*
