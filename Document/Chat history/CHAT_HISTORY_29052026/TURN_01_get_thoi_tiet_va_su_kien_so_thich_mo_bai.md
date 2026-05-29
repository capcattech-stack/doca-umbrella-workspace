#### 🙋‍♂️ **Người dùng hỏi:**
> ak, để phục vụ cho đoạn chat thì những thông tin bên ngoài cũng cần ghi nhận, ví dụ thời tiết, sự kiện liên quan sở thick, tin tức liên quan sở thích, ... cũng cần được get khi cần để làm mở bài

#### 🤖 **Đặc vụ phản hồi (Sophia & Alan):**
Chào bạn, tôi đã cập nhật và viết lại hoàn toàn tài liệu đặc tả đặc biệt **[SPEC_07_EXTERNAL_AMBIENT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_07_EXTERNAL_AMBIENT_SENSING.md)**:
1. **6 nhóm sở thích:** Music, Literature, Cinema, Cafe, Art, Nature.
2. **Cơ sở dữ liệu tin văn hóa:** Chống tin tức độc hại (Anti-Toxic News), biên soạn thủ công sự kiện văn hóa lãng đãng dưới 80 từ.
3. **Kiến trúc cảm biến:** GPS làm tròn 2 chữ số thập phân gửi lên OpenWeatherMap API để lấy thời tiết, kết hợp sở thích lưu trong Memory Vault làm chất xúc tác mở bài (Cozy Opener).
4. **Bản tin tĩnh 4 mùa:** Fallback offline-first khi thiết bị hoàn toàn ngắt kết nối mạng.
