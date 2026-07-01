# TURN 03: NHẬT KÝ CHĂM SÓC BOSS (CARE DIARY ENGINE)
*(CARE EVENT LOG & TIMELINE INTEGRATION)*

> **Mã Lượt Chat:** `TURN-30052026-03`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead), Arthur (Mom Test Expert)

---

## 🙋‍♂️ **Người dùng hỏi:**
> bên cạnh những ký ức là hình ảnh thông thường 1 số ký ức và sự kiện rất quan trọng tôi muốn ghi nhận đó là tiêm ngừa, sổ giun, tắm, cạo lông, bị nấm,.... ko quá ý tế trong giai đoạn này để tránh nhữg phiền phức chuyên môn. Team nghĩ chúng ta nên làm gi để get được?

---

## 🤖 **Đặc vụ phản hồi (Sophia & Alan & Arthur):**
Chúng tôi đã kiến tạo đặc tả hoàn chỉnh cho phân hệ **[SPEC_07_CARE_DIARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_07_CARE_DIARY_ENGINE.md)** nhằm đáp ứng trọn vẹn yêu cầu này:

1.  **Triết lý "Ghi chú của Mẹ" (Scrapbook):** Độc lập 100% với bệnh án y khoa. Tuyệt đối không lưu trữ biệt dược, liều lượng, hay cảnh báo chẩn đoán bệnh. Chỉ ghi lại ngày tháng và cảm nghĩ của Sen khi tắm, tiêm ngừa, cạo lông để tránh rủi ro chuyên môn.
2.  **Danh mục 16 sự kiện tiêu biểu:** Chia làm 4 nhóm chính: 🛁 Làm Đẹp, 💊 Sức Khỏe, 🍽️ Cuộc Sống, và 🌟 Cột Mốc.
3.  **Tự động nhận diện ý định qua Cozy Chat (NLP Intent Detection):** Khi Sen nhắn *"Hôm nay Bánh Mỳ mới được tắm sạch nè"*, hệ thống tự động nhận diện hành vi tắm, kích hoạt Boss hỏi thăm dễ thương để tự lưu sự kiện chăm sóc vào SQLite.
4.  **Hệ thống nhắc hẹn thông minh bằng giọng Boss:** Nhắc nhở cắt móng, tắm, sổ giun định kỳ theo văn phong tri kỷ ngộ nghĩnh (ví dụ: *"Mùi trẫm đang hơi lạ rồi đó Sen ơi... Tắm trẫm nha!"*).
5.  **Cầu nối y tế khẩn cấp:** Sự kiện 🤒 *Hôm nay Boss không khỏe* (`FEELING_UNWELL`) không có biểu mẫu nhập mà được liên kết chuyển tiếp thẳng sang Cozy Chat RAG Engine (Safe-Vet AI) để boss chẩn đoán phân loại cấp cứu khẩn cấp.
6.  **Tích hợp đa Boss (SPEC-08):** Tự động liên kết `pet_id` dựa trên nhận dạng cá thể pet của ảnh gốc hoặc tên pet được trích xuất từ hội thoại chat.
