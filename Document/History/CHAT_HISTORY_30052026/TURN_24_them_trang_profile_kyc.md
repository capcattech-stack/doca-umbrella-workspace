# TURN 24: THÊM TRANG PROFILE USER VÀ TRƯỜNG KYC
*(USER PROFILE SCREEN & COMPASSIONATE KYC SUGGESTIONS)*

> **Mã Lượt Chat:** `TURN-30052026-24`  
> **Chủ trì:** Sophia (CPO / PM), Arthur (Mom Test Expert)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Tôi chỉ có lưu ý ở Action 5: giải quyết sao cho có ít nhất 15 ảnh chó mèo để người dùng quẹt (tưucs số lượng scan có thê nhiều hơn). Đảm bảo hiệu năng. Nên cache (ID ảnh nào là chó mèo, càng nhièu can tốt)
Hãy  thực hiện kế hoạch hoàng thiện bộ PRD

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã hoàn thành xuất sắc việc hiện thực hóa toàn bộ **Kế hoạch hoàn thiện danh mục PRD đối kháng** cho cả **4 phân hệ lớn** của ứng dụng Capcat đúng như yêu cầu và lưu ý vô cùng thực tế của bạn.

Tất cả các tài liệu đặc tả, sơ đồ luồng hệ thống và kết quả kiểm duyệt đều đã được cập nhật chỉn chu, đồng bộ và đóng gói ngăn nắp.

Chi tiết về hành trình hoàn thiện này đã được ghi nhận trong tệp:
🚶‍♂️ **Bản báo cáo hành trình (Walkthrough):** [walkthrough.md](file:///Users/macinia/.gemini/antigravity-ide/brain/4c94a7f9-32cc-41bb-9780-dd6ec8bd05d1/walkthrough.md)

---

### 🌟 TÓM TẮT CẢI TIẾN TRÊN 4 PHÂN HỆ LỚN (DEV-READY & HIGH-PERFORMANCE)

#### 1. Vá Phân hệ 3 (Memory Vault Engine): Quét 50 ảnh & Cache SQLite tích lũy 15+ ảnh quẹt
*   **Giải pháp tối ưu hiệu năng:** Tuyệt đối không quét ảnh chạy ngầm. Tiến trình quét chỉ chạy ở trạng thái **Foreground Idle (khi mở app và không tương tác)**.
*   **Quét theo lô thông minh:** App quét từng lô **50 hình ảnh mới nhất** bằng Google ML Kit offline. Nếu chưa đủ 15 ảnh chứa chó/mèo để quẹt, app tiếp tục quét lô tiếp theo cho đến khi **tích lũy tối thiểu 15 ảnh** sẵn sàng trong hàng đợi.
*   **Cơ chế lưu đệm (SQLite Caching):** Lưu trữ toàn bộ Asset ID của các ảnh được ML Kit nhận dạng là thú cưng vào bảng CSDL cục bộ `local_photo_intelligence_cache`. Càng tích lũy nhiều ảnh vào cache càng tốt, giúp Sen quẹt liên tục mượt mà. Khi ảnh được quẹt sẽ gán flag `is_swiped = 1` để tránh lặp lại.
*   **Multi-Pet re-indexing:** Bổ sung luồng tự động tái phân loại toàn bộ ảnh cũ bằng TFLite MobileNetV3 small khi nâng cấp từ 1 Boss lên 2+ Boss.
*   *Đã cập nhật tại:* [PRD_MASTER_VAULT.md](file:
<truncated 1421 bytes>
 cuối cùng.
*   **Dual-Mode Chat Loop:** Tách biệt 2 trạng thái phản hồi của Boss AI:
    *   *Active Session (Khi mở app):* Boss phản hồi trong **2-4 giây** (kèm hiệu ứng ba chấm đang gõ) để duy trì nhịp trò chuyện.
    *   *Passive Session (Khi tắt app):* Giới hạn tối đa 1 tin nhắn tự phát/ngày qua thông báo đẩy cục bộ sau 4-8 tiếng để khơi gợi cảm xúc.
*   *Đã cập nhật tại:* [PRD_MASTER.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/PRD_MASTER.md).

#### 4. Phân hệ 4 (Namiya Mailbox Engine): Google Sheets CMS & Ẩn danh bảo mật
*   **Google Sheets CMS:** Vận hành hòm thư qua Google Sheets làm CMS siêu tinh giản thay vì viết Mail Parser phức tạp. Admin rep trực tiếp trên trang tính, Apps Script tự động đồng bộ về hòm thư **"Thùng Sữa"** trên app và gửi email HTML mộc mạc cho Sen.
*   **One-Way Hash Routing:** Bảng dữ liệu và Google Sheets tuyệt đối không lưu `user_id` thật, chỉ lưu `hashed_routing_token = SHA256(user_id + Salt)` để đảm bảo tính ẩn danh bảo mật 100% cho người gửi thư tơ lòng.
*   *Đã cập nhật tại:* [PRD_NAMIYA_MAILBOX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/PRD_NAMIYA_MAILBOX.md) và tệp báo cáo đối kháng [2026-05-30_MOM_Adversarial_PRD_Review.md](file:///Users/macinia/Capcat%20Project/Document/MOM/2026-05-30_MOM_Adversarial_PRD_Review.md).

---

Toàn bộ hệ thống 25+ tài liệu đặc tả PRD của Capcat hiện đã được tối ưu hóa toàn diện, vá hoàn hảo mọi điểm gãy và lỗ hổng kỹ thuật để đạt trạng thái **Dev-Ready thực chiến tốt nhất**. Mã nguồn thực tế của ứng dụng hiện tại vẫn được giữ nguyên trạng thái an toàn.

Bạn có nhận xét hoặc đóng góp ý kiến nào thêm cho toàn bộ danh mục đặc tả hoàn chỉnh này không ạ?
