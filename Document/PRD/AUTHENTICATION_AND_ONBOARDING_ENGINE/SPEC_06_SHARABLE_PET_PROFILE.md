# 🐾 ĐẶC TẢ PRD: HỒ SƠ PET ĐA HƯỚNG & CHIA SẺ PHÂN QUYỀN
*(SPEC_06_SHARABLE_PET_PROFILE - SHARABLE MULTI-DIMENSIONAL PET PROFILE SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC_06_SHARABLE_PET_PROFILE`  
> **Phân hệ cha:** `AUTHENTICATION_AND_ONBOARDING_ENGINE`  
> **Chủ trì:** Sophia (CPO) & Alan (Tech Lead / AI Architect)  
> **Trạng thái:** Hoành thành (Dev-Ready - Đã sửa đổi theo triết lý tối giản mới)  

---

## I. TẦM NHÌN SẢN PHẨM: "ẨN MÌNH CỦA SEN, TỎA SÁNG CỦA BOSS"

Để đảm bảo người dùng (Sen) luôn cảm thấy an toàn, riêng tư tuyệt đối và không có cảm giác bị "rình mò/theo dõi" bởi AI (Anti-Paranoia Principle), **Capcat** áp dụng triết lý:
*   **Hồ sơ của Sen (User Profile):** Cực kỳ tối giản, sạch sẽ và phẳng, tuyệt đối không trưng bày hay hiển thị bất kỳ suy luận nào của AI về thói quen, lịch trình hay sở thích của Sen.
*   **Hồ sơ của Boss (Pet Profile / Shareable Dashboard):** Là nơi **tập trung hiển thị toàn bộ sự thấu hiểu, dữ liệu chăm sóc và thông tin chuyên nghiệp**. Mọi phân tích về thói quen, nhịp sinh học, sở thích động và hồ sơ y khoa đều được dịch chuyển và phản chiếu lên Boss một cách chuyên nghiệp, khoa học và giàu chiều sâu cảm xúc.

Trang hồ sơ thú cưng (`PetProfileScreen`) được thiết kế để **tái cấu trúc dữ liệu** theo hướng **phân quyền chia sẻ thông minh (Sharable Phased Access)** nhắm đến 3 nhu cầu thực tế ngoài đời sống của chủ nuôi:
1.  **Khoe Pet (Social Share):** Giao diện hoạt ảnh màu nước Ghibli, sở thích động của Boss.
2.  **Gửi Khách Sạn Chó Mèo (Pet Boarding):** Lịch trình ăn ngủ, dị ứng thức ăn, thói quen sinh hoạt chi tiết của Boss.
3.  **Gửi Thú Y (Vet Clinic):** Hồ sơ y sinh, vaccine biểu đồ, lịch sử cân nặng chuyên nghiệp.

---

## II. ĐẶC TẢ DASHBOARD THẤU HIỂU & CHUYÊN NGHIỆP CỦA BOSS (PET DASHBOARD SPEC)

Trang hồ sơ chi tiết của Boss trên ứng dụng sẽ là một **bảng điều khiển thấu hiểu (Insights Dashboard)** cực kỳ chuyên nghiệp và trực quan:

```
+---------------------------------------------------+
|  [<]               Hồ sơ của Bánh Mỳ       [Share]  |  <-- Standard Flat Header
+---------------------------------------------------+
|  [ Ảnh đại diện ]    BÁNH MỲ                      |  <-- Identity Section
|  Mèo Anh Lông Ngắn - 2 tuổi - 4.5 kg              |
|  -----------------------------------------------  |
|                                                   |
|  📊 BIỂU ĐỒ SỨC KHỎE (VET DASHBOARD)              |
|  * Lịch sử Cân nặng:                              |
|    [ Biểu đồ Line Chart phẳng, mịn tăng trưởng ]  |  <-- Trực quan hóa y tế chuyên nghiệp
|  * Mũi tiêm phòng gần nhất:                       |
|    - 3 Mèo (Tiêm ngày 15/05, Nhắc lại 15/05 năm sau)|
|                                                   |
|  🍱 DINH DƯỠNG & LỐI SỐNG (HOTEL DASHBOARD)       |
|  * Khẩu phần ăn:                                  |
|    - 08:00 : 50g Hạt Royal Canin                  |  <-- Trực quan hóa chăm sóc chi tiết
|    - 19:00 : 1 lon Pate 80g                       |
|  * Dị ứng thức ăn: [Dị ứng thịt gà ⚠️]             |
|  * Thói quen ngủ: Thích ngủ cuộn tròn cuối giường |
|                                                   |
|  🎨 TỪ ĐIỂN SỞ THÍCH ĐỘNG (PET INSIGHTS)          |
|  - Thích vuốt cằm, ghét tắm nước lạnh.            |  <-- Sở thích động trích xuất từ chat
|  - Rất sợ tiếng sấm dông.                         |
+---------------------------------------------------+
```

### 1. Phân hệ Biểu đồ Sức khỏe Thú y (Vet Dashboard Component)
*   **Lịch sử Cân nặng (Weight Trajectory):** Một biểu đồ đường (`LineChart` phẳng tối giản, màu xanh lá cây dịu mắt `AppColors.greenStrong1`) hiển thị xu hướng cân nặng của Boss qua các tháng. Rất chuyên nghiệp khi xuất trình cho Bác sĩ thú y để chẩn đoán tăng/giảm cân đột ngột.
*   **Trình quản lý tiêm phòng (Vaccine Timeline):** Hiển thị danh sách các mũi tiêm đã thực hiện dưới dạng trục thời gian phẳng (Timeline), kèm cảnh báo ngày cần tiêm nhắc lại.

### 2. Phân hệ Dinh dưỡng & Lối sống (Hotel Dashboard Component)
*   **Lịch trình ăn uống chi tiết (Feeding Schedule):** Hiển thị thời gian và định lượng hạt/pate. Giúp nhân viên khách sạn thú cưng có thể áp dụng chính xác lịch ăn hàng ngày của Boss ngoài đời thực.
*   **Thói quen sinh hoạt (Quirks & Habits):** Hiển thị các dặn dò đặc biệt (ví dụ: *"Thích uống nước chảy từ vòi, không thích uống nước bát tĩnh"*, *"Sợ tiếng máy sấy"*).

### 3. Phân hệ Từ điển Sở thích Động (Dynamic Pet Insights)
*   Hiển thị các thói quen, sở thích của Boss được **hệ thống AI trích xuất tự động từ các cuộc Cozy Chat** với Sen (Nhóm 3 trong ma trận dữ liệu). 
*   *Ý nghĩa cảm xúc:* Trực quan hóa sự thấu hiểu sâu sắc của Boss đối với môi trường xung quanh, tạo cảm giác Boss thực sự có linh hồn và cá tính riêng biệt đang thay đổi mỗi ngày.

---

## III. TÁI CẤU TRÚC DỮ LIỆU PET (RESTRUCTURED PET DATA SCHEMA)

Để phục vụ chia sẻ phân quyền, cơ sở dữ liệu `PetDetail` được bẻ nhỏ thành **3 Phân nhóm Dữ liệu (Modular Data Blocks)** độc lập:

### 1. Phân nhóm A: Sinh Học & Y Khoa (Biological & Medical Block)
*   *Mục đích:* Dành cho Thú y.
*   *Trường dữ liệu:* Tên, loài, giống, giới tính, ngày sinh, `weight_logs`, `vaccine_records`, `medical_warnings`, `microchip_id` / `collar_code`.

### 2. Phân nhóm B: Chăm Sóc & Lối Sống (Care & Lifestyle Block)
*   *Mục đích:* Dành cho Khách sạn thú cưng / Người trông hộ.
*   *Trường dữ liệu:* `diet_schedule`, `allergies`, `sleeping_habits`, `care_instructions`, `hobbies` (Sở thích động).

### 3. Phân nhóm C: Tâm Hồn AI (AI Soul Block - Private 100%)
*   *Mục đích:* Chỉ dùng riêng tư giữa Chủ nuôi và Boss ảo trong app.
*   *Trường dữ liệu:* `selfTerm` (Bé tự xưng), `ownerTerm` (Bé gọi bạn), `personaTemplateId`, `ai_memory_core` (Bộ nhớ dài hạn AI).
*   **Bảo mật:** Nhóm dữ liệu này **tuyệt đối không bao giờ được xuất hiện** trên bất kỳ liên kết chia sẻ ngoài app để bảo tồn thế giới riêng tư của Sen và Boss.

---

## IV. ĐẶC TẢ LƯỢC ĐỒ DỮ LIỆU SQLite CỤC BỘ (DATABASE SCHEMA)

Để đảm bảo khả năng đáp ứng dữ liệu đa chiều này, bảng `pet_profile` được tái cấu trúc mở rộng:

```sql
-- 1. Bảng lưu trữ thông tin sinh học cốt lõi & xưng hô AI
CREATE TABLE pet_profile (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  species TEXT NOT NULL,
  breed TEXT,
  gender TEXT,
  birthday TEXT,
  microchip_id TEXT,
  self_term TEXT,            -- Phân nhóm C (Private)
  owner_term TEXT,           -- Phân nhóm C (Private)
  persona_template_id INT,   -- Phân nhóm C (Private)
  created_at TIMESTAMP
);

-- 2. Bảng lưu trữ lịch sử cân nặng (Vet Block)
CREATE TABLE pet_weight_logs (
  id TEXT PRIMARY KEY,
  pet_id TEXT NOT NULL,
  weight REAL NOT NULL,
  recorded_date TEXT NOT NULL,
  FOREIGN KEY(pet_id) REFERENCES pet_profile(id)
);

-- 3. Bảng lưu trữ lịch sử tiêm phòng (Vet Block)
CREATE TABLE pet_vaccine_records (
  id TEXT PRIMARY KEY,
  pet_id TEXT NOT NULL,
  vaccine_name TEXT NOT NULL,
  injected_date TEXT NOT NULL,
  next_due_date TEXT,
  notes TEXT,
  FOREIGN KEY(pet_id) REFERENCES pet_profile(id)
);

-- 4. Bảng lưu trữ thói quen sinh hoạt & Dị ứng (Hotel Block)
CREATE TABLE pet_lifestyle_habits (
  pet_id TEXT PRIMARY KEY,
  diet_schedule TEXT,        -- Lưu chuỗi JSON (giờ ăn, khối lượng, loại hạt)
  food_allergies TEXT,       -- Lưu chuỗi JSON các chất gây dị ứng
  sleeping_habits TEXT,      -- Ghi chú thói quen ngủ
  care_instructions TEXT,    -- Dặn dò chăm sóc đặc biệt
  hobbies TEXT,              -- Sở thích động lưu chuỗi JSON
  FOREIGN KEY(pet_id) REFERENCES pet_profile(id)
);
```

---

*Tài liệu đặc tả hồ sơ Pet chia sẻ phân quyền đã hoàn thành chỉn chu. Ký tên: PM Sophia & Tech Lead Alan*
