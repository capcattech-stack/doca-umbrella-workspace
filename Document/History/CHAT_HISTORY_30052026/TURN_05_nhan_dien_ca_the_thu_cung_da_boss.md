# TURN 05: NHẬN DIỆN CÁ THỂ THÚ CƯNG ĐA BOSS
*(PET VISUAL FINGERPRINT ENGINE & MULTI-PET RECOGNITION)*

> **Mã Lượt Chat:** `TURN-30052026-05`  
> **Chủ trì:** Alan (Tech Lead), Arthur (Mom Test Expert), Sophia (CPO / PM)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Offline_ML có thể phân biệt được đâu là mèo bánh mỳ đâu là mèo bánh cam để có thể gắn tag từng bé ko ? Vì 1 user có thẻ có nhiều hơn 1 bé.

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chúng tôi đã thiết kế thành công kiến trúc **[SPEC_08_PET_INDIVIDUAL_RECOGNITION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_08_PET_INDIVIDUAL_RECOGNITION.md)** để giải quyết trọn vẹn bài toán phân biệt cá thể Pet này cục bộ 100%:

1.  **Lõi trích xuất TFLite MobileNetV3-Small (2.5MB):** Sử dụng mô hình mạng nơ-ron MobileNetV3-Small chạy trực tiếp trên thiết bị (Inference chỉ mất ~12ms) để trích xuất ra một vector đặc trưng 1024 chiều đại diện cho "dấu vân pháp thị giác" của Pet.
2.  **Chiến lược 3 tầng nhận dạng (3-Tier Recognition Strategy):**
    *   **Tầng 1: Sen dạy bé (Bootstrap Onboarding):** Sen chọn 3-5 ảnh rõ mặt cho mỗi bé mới đăng ký để hệ thống tính toán vector trung tâm (Centroid Vector) lưu vào SQLite.
    *   **Tầng 2: So sánh Cosine Similarity cục bộ:** So sánh vector ảnh mới với centroid của từng bé. Độ tin cậy $\ge 0.75$ tự động gắn tag; từ $0.50$ - $0.74$ hiển thị prompt hỏi confirm nhẹ nhàng; $< 0.50$ cho Sen chọn danh sách pet thủ công.
    *   **Tầng 3: Tự học cải thiện liên tục (Self-Learning Loop):** Mỗi lượt confirm/sửa của Sen sẽ nạp lại vector ảnh đó để cập nhật centroid chính xác hơn. Áp dụng cơ chế Sliding Window tối đa 30 ảnh tham chiếu để centroid tự trôi theo ngoại hình lớn lên/thay đổi của Pet.
3.  **Xử lý các tình huống phức tạp:** Bối cảnh 2 boss ngủ chung một khung hình, nhận nuôi bé mới hồi tố ảnh cũ, và phân biệt 2 bé giống hệt nhau cùng màu mắt bằng các chi tiết vân lông tinh tế mà ML Kit Image Labeling thông thường không làm được.
4.  **Bypass thông minh cho người dùng 1 Boss:** Hệ thống tự phát hiện số lượng Pet = 1 để tắt hoàn toàn luồng bootstrap và trích xuất vân pháp, tự động gán nhãn duy nhất để tối ưu hóa pin và trải nghiệm.
