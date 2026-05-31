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
              +---> [Đã có Pet]   ---> Hiện Trang chủ bình thường (Ghibli Watercolor Carousel) & Mở Chat tự do
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
*   **Ngày sinh nhật & Ngày nhận nuôi:** Bộ chọn ngày tối giản hiện đại (Minimalist Modern Classic Calendar/Date Picker). Giao diện là một Card phủ kính mờ hoặc nền trắng sữa bo góc tròn lớn (R=28px) cực kỳ sạch sẽ, các chữ số và tên tháng màu đen đậm độ tương phản cao, ô chọn ngày hiện tại hiển thị tinh tế (như phong cách modern classic tối giản trong hình minh họa của 26s AI), hoàn toàn không sử dụng chất liệu giả gỗ hay trang trí rườm rà.

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

## 3. GIẢI PHÁP AN TOÀN & ĐỘT PHÁ CẢM XÚC: HIỆU ỨNG TRÁNG ẢNH POLAROID GHIBLI
*(Không cần chuyên gia thiết kế Lottie - Khả thi 100% cho MVP & Đạt hiệu quả thẩm mỹ Classic cực cao)*

Để giải quyết bài toán thiếu nhân sự thiết kế Lottie custom mà vẫn đảm bảo trải nghiệm chào đón tràn đầy cảm xúc và tinh tế theo đúng tinh thần **Modern Classic Minimalism**, hệ thống áp dụng **Hiệu Ứng Tráng Ảnh Polaroid (Polaroid Photo Development)** kết hợp xúc giác và âm thanh. Giải pháp này sử dụng 100% asset tranh tĩnh Ghibli watercolor sẵn có nhưng mang lại cảm giác cực kỳ thơ và cao cấp.

### 🎥 3.1. Kịch Bản Trải Nghiệm (The Visual Flow)
```
[ Nút "Đón Boss Về Nhà" được nhấn ]
              |
              v (Màn hình tối lại thành #0D0D0D sâu lắng)
              |
  [ Card Polaroid hiện ra: scale 0.95 -> 1.0, opacity 0 -> 1 ]
              |
  [ Ảnh Boss "Tráng Dần" (Sepia/Mờ -> Màu nước rực rỡ trong 1.8s) ]
              |
  [ Xúc giác: Rung nhẹ 2 nhịp (Mô phỏng Nhịp tim / Tiếng khẽ cọ đầu) ]
              |
  [ Bong bóng thoại tri kỷ hiện lên bằng font Caveat mộc mạc ]
              |
              v
     (Chạm bất kỳ -> Fade vào Home)
```

1.  **Nền Tối Vô Cực sâu lắng (#0D0D0D):** Khi nhấn "Đón Boss Về Nhà", toàn màn hình chuyển sang nền tối tĩnh mịch của phòng ngủ, tạo khoảng lặng cảm xúc trước khi Boss xuất hiện.
2.  **Khung Polaroid Hiện Diện (The Polaroid Card):**
    *   Một khung ảnh Polaroid phẳng, tối giản (nền trắng sữa `#FFFFFF`, viền mảnh `1px solid Colors.black.withOpacity(0.04)`, bo góc mềm mại `16px`) nhẹ nhàng trượt lên từ trung tâm.
    *   Card sử dụng hiệu ứng chuyển động mượt mà: Scale từ `0.95` lên `1.0` kết hợp Fade-in trong `800ms` (`Curves.easeOutCubic`).
3.  **Hiệu Ứng "Tráng Ảnh" (Ghibli Photo Development - 100% Flutter):**
    *   Sử dụng hình vẽ Ghibli watercolor tĩnh của Boss vừa chọn.
    *   Ban đầu, vùng ảnh hiển thị dưới dạng một lớp bóng mờ màu xám/sepia mộc mạc (`ColorFilter.mode(Colors.grey, BlendMode.saturation)` hoặc `sepia`).
    *   Trong **1.8 giây tiếp theo**, ảnh Boss từ từ "tráng màu" sắc nét và ấm áp dần lên (Opacity của bộ lọc màu giảm dần từ `1.0` về `0.0`, chuyển hóa thành bức tranh màu nước rực rỡ, chân thực).
4.  **Nhịp Tim Xúc Giác & Âm Thanh Khẽ (The Sensory Connection):**
    *   Ngay khi bức ảnh "tráng màu" hoàn tất (tại giây thứ 1.8), điện thoại phát ra **2 nhịp rung nhẹ liên tiếp (Double-pulse Haptic)** bằng cách gọi `HapticFeedback.lightImpact()` hai lần cách nhau `150ms`.
    *   Hiệu ứng rung này mô phỏng nhịp tim đập nhẹ nhàng hoặc tiếng thú cưng cọ đầu vào mặt kính, tạo ra sự xúc động vật lý chân thật ngay trên lòng bàn tay của Sen.
5.  **Lời Thì Thầm Của Boss (Bong Bong Thoại Tri Kỷ):**
    *   Một bong bóng thoại nhỏ, tối giản trượt nhẹ ra ngay dưới khung ảnh Polaroid với font chữ viết tay ấm áp (`Caveat` hoặc `Quicksand` nghiêng):
    *   *Nội dung bong bóng thoại* được lấy trực tiếp từ bảng ánh xạ Cá Tính AI ở Bước 2. Ví dụ với cá tính **Chảnh Chọe**: *"Trẫm đã được sinh ra rồi! Từ nay trẫm cho phép một mình Sen ôm trẫm thôi đó nhé... 🥺"*.
6.  **Chuyển Tiếp Nhẹ Nhàng:**
    *   Sen chạm vào bất kỳ điểm nào trên màn hình $\rightarrow$ Khung Polaroid khẽ nén xuống một chút (Scale down nhẹ về `0.98` để phản hồi tương tác), sau đó toàn bộ màn hình thực hiện Fade-out nhẹ nhàng (`800ms`) để chuyển tiếp mượt mà vào màn hình Home.

### 🛠️ 3.2. Code Cấu Trúc Flutter Tham Khảo (Developer-Friendly Blueprint)
Nhà phát triển có thể dễ dàng hiện thực hóa hiệu ứng cao cấp này bằng các widget tích hợp sẵn của Flutter mà không cần cài thêm thư viện phức tạp:
```dart
// Code gợi ý cho hiệu ứng tráng ảnh Polaroid không cần Lottie
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 1.0, end: 0.0), // Giảm độ bão hòa xám về 0
  duration: const Duration(milliseconds: 1800),
  curve: Curves.easeIn,
  builder: (context, saturationValue, child) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        // Ma trận chuyển đổi màu sắc từ đơn sắc (monochrome) sang màu nước rực rỡ
        0.2126 + 0.7874 * (1 - saturationValue), 0.7152 - 0.7152 * (1 - saturationValue), 0.0722 - 0.0722 * (1 - saturationValue), 0, 0,
        0.2126 - 0.2126 * (1 - saturationValue), 0.7152 + 0.2848 * (1 - saturationValue), 0.0722 - 0.0722 * (1 - saturationValue), 0, 0,
        0.2126 - 0.2126 * (1 - saturationValue), 0.7152 - 0.7152 * (1 - saturationValue), 0.0722 + 0.9278 * (1 - saturationValue), 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: Image.asset(selectedPetGhibliAssetPath),
    );
  },
  onEnd: () {
    // Kích hoạt rung nhịp tim kép ấm áp khi tráng ảnh xong
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 150), () {
      HapticFeedback.lightImpact();
    });
    // Kích hoạt hiển thị Bong bóng thoại tri kỷ
    setState(() { showSpeechBubble = true; });
  },
);
```

---

## 4. TIÊU CHÍ NGHIỆM THU (ACCEPTANCE CRITERIA)

*   **AC-1 (Contextual Trigger Integrity):** Tài khoản mới tinh sau khi đăng nhập Google SSO bắt buộc phải được đưa thẳng vào Trang chủ Empty State tĩnh lặng. Xác minh rằng Phòng Đón Boss Về Nhà chỉ trượt mở khi người dùng bấm nút CTA gỗ trên trang Home hoặc bấm truy cập tab Phòng Chat.
*   **AC-2 (Calculated Fields Accuracy):** Kiểm tra tính toán `togetherDays`, tuổi người và `LifeStage` chính xác theo logic nhập liệu ngày nhận nuôi/ngày sinh nhật.
*   **AC-3 (Persona Alignment):** Lựa chọn cá tính được lưu vĩnh viễn vào model `PetDetail`, đảm bảo cặp xưng hô tương ứng (ví dụ: Trẫm - Sen) được cấu hình chính xác cho chatbot engine.
*   **AC-4 (Premium Polaroid Splash Screen):** 
    *   Khung ảnh Polaroid xuất hiện mượt mà với hiệu ứng scale và fade-in không giật lag.
    *   Hiệu ứng tráng ảnh từ đơn sắc sang màu nước rực rỡ hoạt động đúng trong 1.8s.
    *   Hệ thống phát ra đúng 2 nhịp rung haptic nhẹ liên tiếp ngay khi quá trình tráng ảnh kết thúc để mang lại xúc giác chữa lành ấm áp.
    *   Bong bóng thoại xuất hiện đúng font viết tay mộc mạc và hiển thị đúng câu xưng hô cá tính đã chọn.
