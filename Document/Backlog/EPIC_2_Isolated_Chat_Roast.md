# EPIC 2: PHÒNG CHAT TRI KỶ AI & ROAST ẢNH DÌM (ISOLATED CHAT & ROAST)
*(ĐẶC TẢ CHI TIẾT USER STORIES & ACCEPTANCE CRITERIA)*

---

## 💬 MÔ TẢ EPIC
Phân hệ này xây dựng không gian trò chuyện tri kỷ 2 chiều thời gian thực giữa chủ nuôi và từng linh hồn thú cưng ảo. AI được tích hợp khả năng nhận diện hình ảnh để "Roast/Khịa" ảnh dìm, và đặc biệt là cơ chế tương tác gia đình chéo (mách lẻo xuyên pet) tạo trải nghiệm đắm chìm tối đa.

---

## 📋 DANH SÁCH USER STORIES

### US-2.1: Giao diện Phòng Chat riêng biệt tách bản (Isolated Chat Threads)
*   **Phát biểu:** 
    *   *Là một:* Chủ nuôi có nhiều thú cưng,
    *   *Tôi muốn:* Chat với từng Boss trong các phòng chat hoàn toàn riêng biệt,
    *   *Để:* Cảm xúc không bị loãng và giữ nguyên tính tri kỷ độc bản của từng con.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Isolated UI):** Khi mở chat với Lucky (chó), toàn bộ avatar, hình nền khung chat, và màu sắc bong bóng chat mang phong cách của Lucky. Khi sang chat với Bánh Mỳ (mèo), giao diện thay đổi 100% sang phong cách của Bánh Mỳ.
    *   **AC-2 (State Isolation):** Lịch sử tin nhắn, hàng đợi tin nhắn của Pet nào phải nằm trọn vẹn trong phòng chat của Pet đó, tuyệt đối không bị trộn lẫn dữ liệu.
    *   **AC-3 (Navigation Quick Transition):** Cho phép bấm vào icon chuyển nhanh giữa các Pet ở góc trên thanh công cụ phòng chat để đổi sang Pet khác mà không cần lùi lại màn hình danh sách chat.
*   **Technical Context (Alan):** Quản lý luồng chat thông qua `petId` định danh trong Riverpod state (`nanny_chat_provider.dart`).

---

### US-2.2: Gửi ảnh dìm hàng - AI Vision Roast
*   **Phát biểu:**
    *   *Là một:* Chủ nuôi thích chụp ảnh dìm của Boss,
    *   *Tôi muốn:* Gửi ảnh chụp Boss ngáo ngơ trực tiếp vào khung chat,
    *   *Để:* Nhận lại câu phản hồi "khịa" hài hước, chọc ghẹo từ AI dựa trên bức ảnh đó.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Photo Upload & Compress):** Nút gửi ảnh hoạt động mượt mà trong khung chat. Trước khi gửi lên API, ảnh được nén ngầm bằng `flutter_image_compress` để tiết kiệm băng thông mạng.
    *   **AC-2 (Vision Roast Response):** Hệ thống gửi ảnh qua Vision LLM API. AI trả về câu bình luận chuẩn xác về tư thế hoặc trạng thái của thú cưng trong ảnh (Ví dụ: ngủ há mồm, ngã chổng vó) kèm giọng điệu trêu đùa của cá tính Boss.
    *   **AC-3 (Auto-Moment Generation):** Bức ảnh gửi lên kèm câu khịa của AI tự động được hệ thống lưu lại và đóng gói thành một bài nhật ký mới trên bảng tin Moments cá nhân ở màn hình chính.

---

### US-2.3: Tương tác Gia đình Chéo (Mách lẻo xuyên Pet - ĐỘT PHÁ GIA ĐÌNH)
*   **Phát biểu:**
    *   *Là một:* Chủ nuôi có từ 2 thú cưng trở lên,
    *   *Tôi muốn:* Boss A (mèo) nhắn tin kể xấu/mách lẻo về trò đùa của Boss B (chó) với tôi và ngược lại,
    *   *Để:* Cảm nhận không khí gia đình thú cưng sống động, vui nhộn thực tế.
*   **Tiêu chí Nghiệm thu (Acceptance Criteria):**
    *   **AC-1 (Cross-Context Injection):** Khi mở phòng chat của Pet A, prompt AI sẽ nhận thêm ngữ cảnh tóm tắt từ các Moments gần nhất có gắn tag `petId` của Pet B trong cùng một gia đình (sử dụng thuộc tính `petRelationships` để xác định mối quan hệ anh em/đối thủ chéo trong nhà).
    *   **AC-2 (Conversational Snitch):** AI Pet A sẽ ngẫu nhiên chủ động nhắn tin mách lẻo về trò nghịch ngợm của Pet B (Ví dụ: *"Sen ơi nãy thằng Lucky nó ngáo ngơ lắm, chạy loăng quăng rồi đập đầu vào cạnh bàn kia kìa, đúng là ngốc xít!"*).
    *   **AC-3 (Emotional Feedback Loop):** Khi người dùng sang phòng chat của Pet B, Pet B sẽ có phản hồi ấm ức, hờn dỗi hoặc giải thích ngây ngô khi bị chủ nuôi hỏi tội.
