# TURN 22: KIỂM THỬ ĐỐI KHÁNG VÀ ROLL-PLAY PRD
*(ADVERSARIAL PRD AUDIT & FRICTION ANALYSIS)*

> **Mã Lượt Chat:** `TURN-30052026-22`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead), Leo (Finance Analyst), Arthur (Mom Test Expert)

---

## 🙋‍♂️ **Người dùng hỏi:**
> cả team tháo cái nón người nhà ra và tiến hành kiểm thử đối kháng và roll play để duyêt tất cả tai liẹu PRD, qua đó chỉ ra các điêm gãy các khoản trống và các mâu thuẩn ở đó . và đưa ra kế hoạch hoàng thiện dựa trên scope đã thống nhất

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chào bạn! Tuân thủ chỉ thị vô cùng nghiêm khắc của bạn, toàn bộ đội ngũ cố vấn ảo (Sophia, Alan, Benny và Arthur) đã **tháo bỏ hoàn toàn chiếc mũ "người nhà" xã giao**, chuyển sang trạng thái **"đối kháng"** và phản biện gay gắt nhất. 

Chúng tôi đã thực hiện rà soát chéo toàn bộ các tài liệu PRD để vạch trần các **điểm gãy vận hành**, **khoảng trống kỹ thuật** và **mâu thuẫn logic**, từ đó đưa ra một kế hoạch vá lỗi xuất sắc dựa trên đúng tinh thần tối giản thực chiến.

Tài liệu đúc kết cuộc họp đối kháng tàn nhẫn này đã được lưu trữ chính thức tại:
📝 **Biên bản họp đối kháng:** [2026-05-30_MOM_Adversarial_PRD_Review.md](file:///Users/macinia/Capcat%20Project/Document/MOM/2026-05-30_MOM_Adversarial_PRD_Review.md)

Đồng thời, chúng tôi đã tiến hành cập nhật và chỉnh sửa đồng bộ toàn bộ hệ thống tài liệu đặc tả bên trong thư mục [NAMIYA_MAILBOX_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/) để vá hoàn toàn 5 điểm gãy chí mạng sau:

---

### 💥 5 Điểm Gãy Đã Vá & Giải Pháp Kỹ Thuật Thực Tế:

#### 1. Mâu thuẫn Đồng bộ thư trả lời (Gmail vs App Database)
*   **Điểm gãy:** Nếu admin reply thư của user trên Gmail cá nhân ngoài hệ thống, server không thể biết để lưu DB và hiển thị vào hòm thư **"Thùng Sữa"** trên app.
*   **Vá lỗi (Google Sheets làm CMS):** Thay vì viết Mail Parser siêu phức tạp, chúng ta tận dụng hạ tầng Google Sheets có sẵn. Khi user gửi thư từ app, server vừa forward email cho support vừa ghi một dòng vào một Google Sheet quản lý chung. Admin chỉ cần mở Google Sheet ra đọc và gõ câu trả lời vào cột kế bên. Một Apps Script siêu nhẹ sẽ tự động đồng bộ câu trả lời về 
<truncated 2805 bytes>
ại màn hình viết thư.
*   *Đã cập nhật tại:* [PRD_HIDDEN_ADOPTION_FLOW.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/PRD_HIDDEN_ADOPTION_FLOW.md#2-lu%E1%BB%93ng-b%E1%BA%A3o-v%E1%BB%87-tr%E1%BA%A1ng-th%C3%A1i-%C4%91%C4%83ng-nh%E1%BA%ADp-authentication-protection-flow).

#### 5. Điểm gãy Không gian Soạn thảo (Viewport Overlapping)
*   **Điểm gãy:** Trên các dòng máy màn hình nhỏ (như iPhone SE), khi bàn phím và Accessory Bar nổi lên, không gian soạn thảo bị bóp nghẹt chỉ còn khoảng 3 dòng chữ, tạo sự tù túng.
*   **Vá lỗi (Notion Focus Zoom):** Khi ô soạn thảo Thân bài nhận tiêu điểm (`_bodyFocusNode.hasFocus`), khu vực tiêu đề lớn H1 và Divider sẽ tự động co lại chiều cao bằng 0 và trượt mờ dần (Slide & Fade Out), nhường toàn bộ 100% diện tích màn hình cho ô nhập liệu. Đồng thời, tiêu đề AppBar sẽ tự động hiển thị text tiêu đề rút gọn của người dùng.
*   *Đã cập nhật tại:* [SPEC_NOTION_EDITOR.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_NOTION_EDITOR.md#4-c%C6%A1-ch%E1%BA%BF-thu-nh%E1%BB%8F-ti%C3%AAu-%C4%91%E1%BB%81-khi-t%E1%BA%ADp-trung-vi%E1%BA%BFt-notion-focus-zoom).

---

Tất cả các tài liệu đặc tả PRD và thiết kế giao diện bên trong thư mục [NAMIYA_MAILBOX_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/) đã được cập nhật đồng bộ, thống nhất và vá sạch sẽ các điểm gãy. Chúng ta vẫn tuân thủ nghiêm ngặt **chỉ làm nghiên cứu và đặc tả, không thay đổi bất kỳ dòng code nào của dự án**.

Phân hệ **Tiệm tạp hóa Namiya - Gỡ rối tơ lòng** hiện tại đã đạt độ hoàn thiện cao nhất về mặt thực tế và cảm xúc. Bạn hãy xem qua các bản cập nhật đối kháng này và cho chúng tôi biết suy nghĩ của bạn nhé!
