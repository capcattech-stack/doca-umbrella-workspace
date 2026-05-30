# SPECIFICATION 02: PHÒNG KHAI SINH BOSS ẢO
## (NEW BOSS ONBOARDING & PROFILING)
*(Phiên bản: 3.0 - Giai đoạn: MVP - Người soạn: CPO Sophia & Alan)*

---

## 1. KÍCH HOẠT & ĐIỀU HƯỚNG (TRIGGER & ROUTING)

Màn hình Khai Sinh Boss (`PetOnboardingScreen`) tự động được kích hoạt lập tức sau khi xác thực đăng nhập Google SSO thành công, trong trường hợp hệ thống phát hiện đây là tài khoản Sen mới tinh chưa có bất kỳ hồ sơ Boss nào:

```
[ Đăng nhập Google thành công ]
              |
      (Kiểm tra listPet)
              |
              +---> [Chưa có Pet] ---> Phòng Khai Sinh Boss
              |
              +---> [Đã có Pet]   ---> Home Screen / Chat Room
```

---

## 2. ĐẶC TẢ CHI TIẾT CÁC BƯỚC THIẾT LẬP (STEP-BY-STEP PROFILING)

Phòng khai sinh được chia làm 2 bước cực kỳ tối giản, trình bày trên các card bo cong Glassmorphism màu trắng sữa dịu mắt:

### Bước 1: Nhập thông tin Sinh Học (Biological Specs)
*   **Loài (Species):** Chọn nhanh qua 2 icon dễ thương: Chó 🐶 hoặc Mèo 🐱. (Bắt buộc).
*   **Tên Boss (Pet Name):** Ô nhập văn bản tối giản (Bắt buộc).
*   **Giống loài (Breed):** Dropdown có tính năng tìm kiếm (Ví dụ: Golden Retriever, Corgi, Mèo Anh Lông Ngắn...).
*   **Giới tính (Gender):** 3 nút tròn mộc mạc: Đực / Cái / Triệt sản.
*   **Cân nặng (Weight):** Nhập số (kg).
*   **Ngày sinh nhật & Ngày nhận nuôi:** Bộ chọn ngày (DatePicker) phẳng dạng lịch gỗ retro.

#### 🧮 Cơ chế Tự động Tính toán Chỉ số Sinh học Động (Calculated Bio Indices):
Ngay khi người dùng hoàn tất điền form, hệ thống tự động tính toán cục bộ và hiển thị:
*   **Số ngày ở bên nhau (`togetherDays`):** Khoảng thời gian từ Ngày nhận nuôi đến Hôm nay.
*   **Tuổi người quy đổi:** Hệ thống tự động nhân hệ số sinh học tương ứng với loài chó/mèo để hiển thị tuổi quy đổi của Pet sang tuổi người (Ví dụ: Chú mèo 1 tuổi tương đương thanh niên 15 tuổi của người).
*   **LifeStage (Giai đoạn phát triển):** Gán nhãn tự động (`Kitten/Puppy`, `Junior`, `Adult`, `Senior`) kèm 1 câu khuyên dinh dưỡng/y khoa cực kỳ ngắn gọn từ cố vấn thú y.

---

### Bước 2: Thổi Hồn Cho Boss & Cấu Hình Xưng Hô (AI Persona Settings)
Sen lựa chọn 1 trong 4 phong cách cá tính đặc trưng để định hình linh hồn và giọng điệu AI của Boss suốt quá trình tương tác:

| Tên Cá Tính | Xưng hô của Boss | Xưng hô gọi Sen | Mood Đặc trưng |
| :--- | :--- | :--- | :--- |
| **Chảnh Chọe** | Trẫm | Sen | Kiêu kỳ, đòi pate, hay lờ Sen đi khi không có treats. |
| **Nịnh Nọt** | Con | Ba / Mẹ | Quấn quýt, ấm áp, thích khen ngợi Sen. |
| **Đanh Đá** | Tao | Đứa hầu | Tinh quái, hay cà khịa hài hước, tạo tiếng cười. |
| **Ngáo Ngơ** | Tớ | Cậu | Đáng yêu, ngây thơ, nói năng ngốc nghếch dễ thương. |

*   **Ràng buộc:** Khi Sen chọn 1 thẻ cá tính $\rightarrow$ Hệ thống tự động lưu cặp danh xưng `xungHoWithPet` vào DB để cá nhân hóa toàn bộ Prompt của Cozy Chat sau này.

---

## 3. HOẠT ẢNH CHÀO MỪNG ĐỘT PHÁ (THE CỌ-ĐẦU WELCOME SPLASH)

Ngay khi nhấn nút **"Khai sinh Boss"** thành công, app sẽ hiển thị một màn hình chúc mừng siêu dễ thương tràn đầy cảm xúc:
1.  Hiển thị hoạt ảnh Lottie chuyển động chú Chibi chó/mèo tương ứng với loài vừa chọn chạy nhảy vui sướng tung pháo hoa giấy pastel.
2.  Chibi Boss ảo sẽ **chạy lại sát mặt kính màn hình di động, thực hiện động tác "Cọ đầu sát vào kính" (Glass-rubbing/head-butt animation)** cực kỳ đáng yêu, kèm haptic feedback rung rung nhẹ nhàng tạo cảm giác ấm áp như thú cưng đang nũng nịu cọ vào tay Sen.
3.  Một bong bóng thoại nhỏ trượt ra: *"Trẫm đã được sinh ra rồi! Từ nay trẫm cho phép một mình Sen ôm trẫm thôi đó nhé... 🥺"*.
4.  Sen chạm vào màn hình bất kỳ $\rightarrow$ Chuyển tiếp nhẹ nhàng (Fade transition) vào màn hình Home.

---

## 4. TIÊU CHÍ NGHIỆM THU (ACCEPTANCE CRITERIA)

*   **AC-1 (Onboarding Trigger Integrity):** Tài khoản mới tinh sau khi đăng nhập Google SSO bắt buộc phải được đưa vào `PetOnboardingScreen`, không được đi thẳng vào Home trống.
*   **AC-2 (Calculated Fields Accuracy):** Kiểm tra tính toán `togetherDays`, tuổi người và `LifeStage` chính xác theo logic nhập liệu ngày nhận nuôi/ngày sinh nhật.
*   **AC-3 (Persona Alignment):** Lựa chọn cá tính được lưu vĩnh viễn vào model `PetDetail`, đảm bảo cặp xưng hô tương ứng (ví dụ: Trẫm - Sen) được cấu hình chính xác cho chatbot engine.
*   **AC-4 (Emotional Splash Screen):** Hoạt ảnh cọ đầu vào mặt kính hiển thị mượt mà trên cả iOS/Android, không bị giật lag, haptic feedback hoạt động tạo cảm giác rung nhẹ ấm áp.
