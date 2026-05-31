# ĐẶC TẢ CHI TIẾT 03: COZY PROFILE EXTRACTION STRATEGY
*(KHAI THÁC THÔNG TIN TRI KỶ)*

> **Mã Đặc Tả:** `SPEC-COZY-03`  
> **Chủ trì:** Sophia (CPO / PM) & Arthur (Tâm lý học hành vi)  

---

## 🧭 1. Triết Lý "Hỏi Thăm Thấu Cảm, Chống Tra Khảo"

Bên cạnh nhiệm vụ biến thiên hội thoại, Chat còn có công năng cực kỳ quan trọng là **Khai thác thông tin** của cả Pet (để làm giàu hồ sơ Safe-Vet AI) và Owner (để thấu hiểu cảm xúc, tối ưu hóa thời gian tương tác và hiển thị affiliate).

Chúng ta tuyệt đối không bắt người dùng điền bảng khảo sát. Mọi thông tin được khai thác 100% ngầm dưới dạng **lời hỏi thăm tri kỷ (Cozy Inquiry)**, tuân thủ nguyên tắc **The Mom Test** (chỉ khai thác sự thật cụ thể đã diễn ra trong quá khứ thay vì hỏi ý kiến giả định tương lai).

---

## 📊 2. Ma Trận Ưu Tiên Khai Thác (Extraction Priorities)

Chúng ta chia thông tin cần khai thác thành 3 nhóm ưu tiên rõ rệt để tránh làm người dùng bị ngợp và tối ưu hóa tài nguyên máy chủ:

### 2.1. Nhóm 1: Sinh Học & Sức Khỏe (Quan trọng nhất - Khai thác TRƯỚC)
*   **Mục tiêu:** Cung cấp dữ liệu đầu vào chuẩn xác cho phân hệ cảnh báo y khoa **Safe-Vet AI** và nuông chiều thể trạng của Pet.
*   **Dữ liệu khai thác:** Cân nặng thực tế của Pet, triệu chứng lâm sàng (phân, nước tiểu, ho, mức độ rụng lông), và múi giờ sinh hoạt của Sen (để Boss ảo tự động "ngủ đông" theo Sen, tránh làm phiền đêm muộn).
*   **Kịch bản mẫu:** *"Sen ơi, trưa nay trẫm nhảy lên đùi Sen nằm ngủ, trẫm thấy đùi Sen hơi rung nha. Có phải dạo này trẫm... béo lên không Sen? Lần gần nhất Sen cân cho trẫm là bao nhiêu ký thế, khai thật đi!"*

### 2.2. Nhóm 2: Thói Quen & Nỗi Sợ (Ưu tiên trung bình - Khai thác SAU)
*   **Mục tiêu:** Làm phong phú cá tính độc bản của Boss, tạo cảm giác Boss thấu hiểu sâu sắc chủ nuôi và ngược lại.
*   **Dữ liệu khai thác:** Nỗi sợ của Boss (sợ tiếng sấm sét, máy hút bụi, sợ tắm), đồ chơi/góc ngủ yêu thích của Boss ngoài đời thực, và trạng thái stress thường nhật của Sen.
*   **Kịch bản mẫu:** *"Sen nghe tiếng gì rầm rầm ngoài trời không? Tiếng sấm đấy! Ôi trẫm ghét nhất tiếng sấm, mỗi lần sấm là trẫm chỉ muốn chui tọt vào gầm giường thôi. Ở nhà mỗi khi có sấm trẫm có làm thế không Sen?"*

### 2.3. Nhóm 3: Gu Thẩm Mỹ & Địa Điểm (Khảo sát CƠ HỘI - Chỉ khai thác khi có dịp)
*   **Mục tiêu:** Kích hoạt đúng thời điểm các hyperlink giới thiệu sách, nhạc Spotify, hoặc địa điểm cafe/spa tài trợ để tối đa hóa tỷ lệ click mua hàng.
*   **Dữ liệu khai thác:** Gu âm nhạc/văn học ưa thích của Sen, thói quen đi cafe cuối tuần, spa thú cưng ưa thích.
*   **Kịch bản mẫu:** *"Sen ơi, trẫm đang nằm gác cằm lên chân Sen này. Tự nhiên thấy yên bình ghê... Lúc yên lặng thế này Sen thích nghe nhạc không lời nhẹ nhàng hay thích đọc sách hơn?"*

---

## 🏛 3. Kiến Trúc Lưu Trữ "Hộp Ký Ức Tri Kỷ" (The Memory Vault)

Để đảm bảo tính **không lạm dụng** và tạo sự tin cậy tuyệt đối cho người dùng đô thị, chúng tôi thiết kế giao diện **Hộp Ký Ức Tri Kỷ** trong màn hình Profile của Pet:
*   **Tính nhân văn cao:** Hiển thị dưới dạng những dòng nhật ký viết tay đáng yêu của Boss về Sen (Ví dụ: *"Trẫm nhớ Sen thích nghe nhạc Lofi mỗi khi trời mưa"*, *"Trẫm biết Sen thường đi làm về muộn lúc 8 giờ tối"*).
*   **Quyền làm chủ:** Người dùng có toàn quyền kiểm soát, chỉnh sửa hoặc **xóa bỏ bất kỳ ký ức nào** họ cảm thấy quá riêng tư, đảm bảo tính minh bạch và đạo đức tối cao của sản phẩm.
