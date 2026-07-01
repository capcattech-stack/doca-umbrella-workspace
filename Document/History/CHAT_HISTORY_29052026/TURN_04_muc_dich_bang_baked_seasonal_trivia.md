#### 🙋‍♂️ **Người dùng hỏi:**
> baked_seasonal_trivia (Bản Tin Tĩnh 4 Mùa - Dự phòng Offline) Mục đích của bảng này để làm gì

#### 🤖 **Đặc vụ phản hồi (Sophia & Arthur):**
Giải thích mục đích cốt lõi của bảng dữ liệu nạp cứng này dưới 3 khía cạnh:
1.  **Duy trì trải nghiệm chữa lành mọi lúc mọi nơi:** Khi người dùng tắt mạng ngủ hoặc đi máy bay, Pet vẫn "sống", biết mùa và giờ để trò chuyện, duy trì tuyệt đối tính tri kỷ Iyashikei.
2.  **Kỹ thuật Graceful Degradation:** Tải lời chào trong 0.01 giây từ SQLite offline trước khi gọi API thời tiết, tránh spinning wheel vô hồn.
3.  **Phục vụ trạng thái "Ngắt kết nối chủ động":** Hỗ trợ nhu cầu tắt mạng để trú ẩn ban đêm của người trẻ cô đơn đô thị.
