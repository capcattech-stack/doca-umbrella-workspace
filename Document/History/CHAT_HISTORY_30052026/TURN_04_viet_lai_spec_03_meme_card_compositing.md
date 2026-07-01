# TURN 04: VIẾT LẠI SPEC 03 — MEME CARD COMPOSITING
*(MEME COMPOSITING REWRITE V2.0 & VIRAL SOCIAL ENGAGEMENT)*

> **Mã Lượt Chat:** `TURN-30052026-04`  
> **Chủ trì:** Alan (Tech Lead), Bella (Frontend Animator), Leo (Finance Analyst)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Viết lại Spec 3 chi tiết hơn về thư viện, hay công nghệ sử dụng. Meme là tính năng mở rộng dùng để viral, nên có UX hổ trợ để share nhanh sản phẩm meme lên social

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chúng tôi đã viết lại hoàn chỉnh và nâng cấp tài liệu **[SPEC_03_MEME_CARD_COMPOSITING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/MEMORY_VAULT_ENGINE/SPEC_03_MEME_CARD_COMPOSITING.md)** đạt chuẩn thiết kế sản xuất (V2.0):

1.  **Ma trận công nghệ chi tiết:**
    *   **ML Kit Face Detection:** Nhận diện vị trí khuôn mặt Pet cục bộ và lấy bounding box (đạt độ chính xác ~65%).
    *   **Fallback UX thông minh:** Khi ML Kit thất bại, Sen được tự động cung cấp vòng tròn cắt thủ công bằng cử chỉ pinch-to-zoom và kéo vuốt mượt mà.
    *   **Dart `image` & `RepaintBoundary`:** Kết xuất ảnh ghép không nén 3x PNG offline 100%.
2.  **Trải nghiệm Viral 1 chạm (Instant Social Share):**
    *   **Thư viện `share_plus`:** Mở trực tiếp hộp thoại chia sẻ của hệ điều hành.
    *   **Direct-to-Story API:** Gọi API chia sẻ trực tiếp lên Instagram Stories / Facebook Stories chỉ với 1 chạm duy nhất.
    *   **Firebase Dynamic Links (hoặc App Links):** Nhúng mã Deep-link vào QR Code đóng dấu ở chân ảnh. Khi bạn bè quét mã, app sẽ mở trực tiếp và kích hoạt popup tặng 5 Pate Coins cho cả hai người (Referral loop).
3.  **Watermark lan tỏa tự nhiên:** Đóng nhãn *"Capcat: Soul of Pet"* thanh mảnh góc dưới bên phải Polaroid theo thiết kế chữ viền mờ tối giản chữa lành, tăng độ nhận diện thương hiệu mà không gây phản cảm.
4.  **15 Mẫu Meme Chibi:** Quản lý danh mục qua Google Sheets Tab 5 `virtual_memes` để vận hành cập nhật OTA không cần đẩy store mới.
