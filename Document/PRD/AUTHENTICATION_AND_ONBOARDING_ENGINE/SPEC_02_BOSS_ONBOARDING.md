# SPECIFICATION 02: ĐÓN BOSS VỀ NHÀ
## (NEW BOSS ONBOARDING & PROFILING)
*(Phiên bản: 3.0 - Giai đoạn: MVP - Người soạn: CPO Sophia & Alan)*

---

## 1. KÍCH HOẠT & ĐIỀU HƯỚNG (TRIGGER & ROUTING)

Màn hình Đón Boss Về Nhà (`PetOnboardingScreen`) **không** ép buộc hiển thị ngay lập tức sau khi đăng nhập. Thay vào đó, nó được kích hoạt tự nguyện thông qua các hành vi khám phá tự nhiên của Sen mới:

```
[ Đăng nhập Google thành công ]
              |
     (Vào thẳng Trang Chủ)
              |
      (Kiểm tra listPet)
              |
              +---> [Chưa có Pet] ---> Hiện Trang chủ tĩnh lặng + Card gỗ CTA "Đón Boss Về Nhà"
              |                        |
              |                        +---> (Bấm CTA trang Home / Bấm Tab Chat) ---> Mở Giao diện Đón Boss
              |
              +---> [Đã có Pet]   ---> Hiện Trang chủ bình thường (Chibi Carousel) & Mở Chat tự do
```

---

## 2. ĐẶC TẢ CHI TIẾT CÁC BƯỚC THIẾT LẬP (STEP-BY-STEP PROFILING)

Giao diện Đón Boss Về Nhà được thiết kế tối giản ma sát, chia thành 2 bước trình bày trên các card bo cong Glassmorphism màu xám nhạt mộc mạc:

### Bước 1: Thông tin Sinh học của Boss & Cấu hình Danh xưng của Sen
*   **Gương Soi Linh Hồn Boss (Soul Mirror Scan):** Sen chụp/chọn 1 bức ảnh của Boss. App chạy offline 100% trong 200ms để tự động trích xuất:
    *   *Loài:* Chó 🐶 hoặc Mèo 🐱.
    *   *Nhãn màu lông trích xuất:* (Ví dụ: Cam Gừng, Đen mun, Xám xanh...).
    *   *Siêu năng lực linh hồn vui vẻ:* (Ví dụ: *"Phàm ăn pate vũ trụ"*).
*   **Tên Boss (Pet Name):** Sen nhập tên cho Boss (Bắt buộc).
*   **Giống loài (Breed):** Dropdown searchable (Gợi ý tự động từ ML Kit hoặc chọn thủ công).
*   **Danh xưng của Sen (Owner Persona - BẮT BUỘC):** Một dropdown tối giản cho phép Sen tự chọn cách gọi chính mình:
    *   *Lựa chọn:* **Ba / Mẹ / Anh / Chị / Em / Cậu / Sen**
    *   *Mục tiêu:* Đây là **thông tin nền móng** dùng để kết hợp với Cá tính AI của Boss ở Bước 2 nhằm tính toán ra đại từ xưng hô chính xác.
*   **Cân nặng (Weight):** Nhập số (kg).
*   **Ngày sinh nhật & Ngày nhận nuôi:** Bộ chọn ngày gỗ phẳng retro.

#### 🧮 Cơ chế Tự động Tính toán Chỉ số Sinh học Động (Calculated Bio Indices):
Hệ thống tự động tính toán cục bộ dựa trên dữ liệu Sen nhập:
*   `togetherDays` (Số ngày bên nhau) = `Hôm nay` - `Ngày nhận nuôi`.
*   `Tuổi người quy đổi` = Hệ số sinh học của Chó/Mèo tương ứng.
*   `LifeStage` (Giai đoạn phát triển) kèm lời khuyên dinh dưỡng vắn tắt.

---

### Bước 2: Chọn Cá Tính AI & Trực Quan Hóa Xưng Hô (AI Persona & Dynamic Pronoun Mapping)
Cơ chế đại từ xưng hô (`xungHoWithPet` - cách Boss tự xưng và gọi Sen) **TUYỆT ĐỐI KHÔNG bắt người dùng chọn thủ công cản địa**, mà sẽ được **hệ thống tự động ánh xạ (Mapping) thông minh** dựa trên sự kết hợp giữa **Danh xưng của Sen (đã chọn ở Bước 1)** và **Cá tính AI của Boss (chọn ở Bước 2)**. 

Khi Sen bấm chọn 1 thẻ cá tính, một bong bóng thoại (Speech Bubble) demo câu thoại của Boss sẽ xuất hiện trực quan tương ứng:

| Tên Cá Tính | Quy tắc Ánh xạ Xưng Hô (Mapping Matrix) | Demo Bong Bóng Thoại trực quan (Wow preview) |
| :--- | :--- | :--- |
| **Nịnh Nọt** | Boss tự xưng là **"Con"**.<br>Gọi Sen bằng **Danh xưng của Sen đã chọn** (Ba/Mẹ/Anh/Chị/Cậu). | *(Nếu Sen chọn Ba)*:<br>**"Con thương Ba nhất quả đất luôn á! 💖"** |
| **Chảnh Chọe** | **Đè (Override) toàn bộ danh xưng:**<br>Boss tự xưng là **"Trẫm"**.<br>Bất kể Sen chọn gì ở Bước 1, Boss gọi Sen là **"Sen"**. | **"Hừm... Tuy Sen ngốc nghếch nhưng trẫm chỉ cho phép một mình Sen ôm trẫm thôi nhé! 😒"** |
| **Đanh Đá** | **Đè (Override) danh xưng:**<br>Boss tự xưng là **"Tao"**.<br>Boss gọi Sen là **"Đứa hầu"** hoặc **"Sen"**. | **"Này đứa hầu kia, trẫm đói rồi, dọn pate nhanh lên không tao cào cho phát!"** |
| **Ngáo Ngơ** | Boss tự xưng là **"Tớ"**.<br>Boss gọi Sen là **"Cậu"** (mặc định cho bạn bè đồng trang lứa). | **"Sen ơi, tớ đói bụng quá đi à... Tớ muốn ăn cá mập cơ! 🦈"** |

*   *Lợi ích:* Trực quan hóa xưng hô theo cá tính giúp tạo ra sự bất ngờ, cá nhân hóa sâu sắc và đẩy cao cảm xúc kết nối của Sen đối với Boss ảo ngay từ bước khởi tạo.

---

## 3. HOẠT ẢNH CHÀO MỪNG ĐỘT PHÁ (THE CỌ-ĐẦU WELCOME SPLASH)

Ngay khi nhấn nút **"Đón Boss Về Nhà"** thành công, app sẽ hiển thị một màn hình chúc mừng siêu dễ thương tràn đầy cảm xúc:
1.  Hiển thị hoạt ảnh Lottie chuyển động chú Chibi chó/mèo tương ứng với loài vừa chọn chạy nhảy vui sướng tung pháo hoa giấy pastel.
2.  Chibi Boss ảo sẽ **chạy lại sát mặt kính màn hình di động, thực hiện động tác "Cọ đầu sát vào kính" (Glass-rubbing/head-butt animation)** cực kỳ đáng yêu, kèm haptic feedback rung rung nhẹ nhàng tạo cảm giác ấm áp như thú cưng đang nũng nịu cọ vào tay Sen.
3.  Một bong bóng thoại nhỏ trượt ra: *"Trẫm đã được sinh ra rồi! Từ nay trẫm cho phép một mình Sen ôm trẫm thôi đó nhé... 🥺"*.
4.  Sen chạm vào màn hình bất kỳ $\rightarrow$ Chuyển tiếp nhẹ nhàng (Fade transition) vào màn hình Home.

---

## 4. TIÊU CHÍ NGHIỆM THU (ACCEPTANCE CRITERIA)

*   **AC-1 (Contextual Trigger Integrity):** Tài khoản mới tinh sau khi đăng nhập Google SSO bắt buộc phải được đưa thẳng vào Trang chủ Empty State tĩnh lặng. Xác minh rằng Phòng Khai Sinh chỉ trượt mở khi người dùng bấm nút CTA gỗ trên trang Home hoặc bấm truy cập tab Phòng Chat.
*   **AC-2 (Calculated Fields Accuracy):** Kiểm tra tính toán `togetherDays`, tuổi người và `LifeStage` chính xác theo logic nhập liệu ngày nhận nuôi/ngày sinh nhật.
*   **AC-3 (Persona Alignment):** Lựa chọn cá tính được lưu vĩnh viễn vào model `PetDetail`, đảm bảo cặp xưng hô tương ứng (ví dụ: Trẫm - Sen) được cấu hình chính xác cho chatbot engine.
*   **AC-4 (Emotional Splash Screen):** Hoạt ảnh cọ đầu vào mặt kính hiển thị mượt mà trên cả iOS/Android, không bị giật lag, haptic feedback hoạt động tạo cảm giác rung nhẹ ấm áp.
