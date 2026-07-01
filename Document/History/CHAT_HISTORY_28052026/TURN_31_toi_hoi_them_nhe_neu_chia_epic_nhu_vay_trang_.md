# 📚 CAPCAT CHAT HISTORY: LƯỢT 31
*(NHẬT KÝ THẢO LUẬN & ĐẶC TẢ CHI TIẾT NGÀY 28/05/2026)*

---

### 🙋‍♂️ **Người dùng hỏi:**
> tôi hổi thêm nhé. Nếu chia epic như vậy trang home sẽ nằm ở Epic nào ?

---

### 🤖 **Đặc vụ phản hồi:**

Đây là một câu hỏi **cực kỳ thú vị về mặt cấu trúc trải nghiệm (UX Architecture)** trong quản lý sản phẩm Agile.

Với tư cách là CPO, tôi xin giải thích chi tiết cách phân bổ **Trang Home (Home Screen)** dưới góc nhìn quản lý dự án chuyên nghiệp:

Trang Home của Capcat đóng vai trò là **"Trung tâm hiển thị chung" (The Common Dashboard Hub)** chứ không phải là một tính năng cô lập. Đó là nơi **dữ liệu của các Epics khác nhau hội tụ lại** để trình diễn cho người dùng. 

Tuy nhiên, trong quá trình lập trình và phân rã công việc, **Trang Home sẽ nằm trọng tâm ở EPIC 3: HỘP KÝ ỨC & ĐỒ HỌA MEME (MEMORY BOX & PRIVATE DIARY).**

---

### 🔍 LÝ DO CHI TIẾT VÀ CÁCH PHÂN BỔ DỮ LIỆU TRÊN TRANG HOME:

```
+-------------------------------------------------------------+
|  [ Lucky 🐶 ]  [ Bánh Mỳ 🐱 ]  [ + Thêm Pet ]  --> EPIC 1   |  (Boss Carousel - Đọc dữ liệu từ EPIC 1)
+-------------------------------------------------------------+
|                                                             |
|                 BẢNG TIN MOMENTS (80% diện tích)            |
|                                                             |
|   + Bức ảnh dìm Lucky bị ngã chổng vó                       |
|   + Lời "khịa" của AI Bánh Mỳ mách lẻo             |  --> EPIC 3   |  (Moments Feed - Thuộc EPIC 3)
|                                                             |
+-------------------------------------------------------------+
|   [ Floating FAB Trợ lý Boss ảo ]                  --> EPIC 4   |  (Overlay Widget - Thuộc EPIC 4)
+-------------------------------------------------------------+
```

1.  **Nội dung cốt lõi của trang Home (chiếm 80% diện tích) thuộc EPIC 3:**
    *   Xương sống của trang Home là **Moments Feed (Dòng kỷ niệm)** hiển thị danh sách nhật ký, hình ảnh dìm và các câu khịa AI. Đây chính là giao diện chính của **Hộp Ký Ức (EPIC 3)**.
2.  **Mỏ neo kích hoạt các tính năng của EPIC 3 nằm trên Home:**
    *   Popup trò chơi *"Buffet Ký ức Tinder Game"* (US-3.2) và nút bấm tạo *"Mẻ ảnh ghép khung meme"* (US-3.3) đều được kích hoạt trực tiếp từ trang Home.
3.  **Thành phần thuộc EPIC 1 trên trang Home chỉ là "Tầng Hiển Thị" (UI View):**
    *   **Boss Carousel (Vòng xoay Boss)** ở đầu trang Home hiển thị các thẻ bài tóm tắt của Lucky/Bánh Mỳ chỉ là giao diện đọc (Read-only View) dữ liệu đã được khởi tạo thành công từ luồng Onboarding của **EPIC 1 (Thiết lập Thần thái Boss)**.

---

### ⚖️ KẾT LUẬN CỦA SOPHIA VỀ PHÂN CHIA HỒ SƠ LẬP TRÌNH:

*   Khi **Maya thiết kế Prototype**: Cô ấy sẽ vẽ trang Home như một "tổng thể hoàn chỉnh" bao gồm cả Vòng xoay Boss (EPIC 1) và Bảng tin Kỷ niệm (EPIC 3).
*   Khi **Alan & Benny lập trình**: 
    *   Họ sẽ code bộ khung trang Home và bảng tin Moments trước dưới task của **EPIC 3**.
    *   Sau đó, họ sẽ móc nối dữ liệu của vòng xoay Boss lên đầu trang dưới task của **EPIC 1**.

Cách phân chia này giúp đội ngũ phát triển không bị chồng chéo code và luôn biết rõ luồng dữ liệu nào đang điều phối màn hình nào! Bạn thấy cách phân tích cấu trúc màn hình Home này đã rõ ràng và hợp lý chưa?

---
*Tài liệu phân tách tự động từ hệ thống logs của Antigravity AI.*
