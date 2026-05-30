# TURN 27: TRIẾT LÝ ẨN USER HIỆN PET THẤU HIỂU
*(HIDE USER SHINE PET DESIGN PHILOSOPHY)*

> **Mã Lượt Chat:** `TURN-30052026-27`  
> **Chủ trì:** Sophia (CPO / PM), Arthur (Mom Test Expert)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Vay trang Pet Profile sẽ thế nào? đặt tả giúp tôi. Lưu ý: Chủ pét có thể xem và chỉnh sữa các thong tin. Chủ pet có thể share thong tin này cho người khác xem trong tương lai (khoe pet và gửi khách sạn chó mèo, thoặc thú ý, cần chia sẽ thông tin chăm sóc thói quen. Dựa vào nhu cầu nây de phi lại cấu trúc dữ liệu

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chào bạn! Là **Sophia (CPO)** và **Alan (Tech Lead)**, chúng tôi vô cùng trân trọng yêu cầu mở rộng mang tính thực tiễn cao này của bạn. 

Ý tưởng cho phép chủ nuôi **chia sẻ hồ sơ Boss** cho bên thứ ba ngoài hệ thống (khoe pet với bạn bè, gửi khách sạn trông hộ, hoặc đưa bác sĩ thú y chữa bệnh) là một nhu cầu cực kỳ bức thiết ngoài đời thực. 

Để đáp ứng xuất sắc nhu cầu này mà vẫn giữ vững triết lý **bảo mật cảm xúc riêng tư**, tôi đã tiến hành **tái cấu trúc cơ sở dữ liệu hồ sơ Pet** thành các khối thông tin độc lập và đặc tả chi tiết tại tệp:
📄 **Tệp đặc tả hồ sơ chia sẻ phân quyền:** [SPEC_SHARABLE_PET_PROFILE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_SHARABLE_PET_PROFILE.md)

---

## I. TÁI CẤU TRÚC CƠ SỞ DỮ LIỆU PET (THREE-BLOCK PROFILE SCHEMA)

Để phục vụ tính năng chia sẻ ngoài app mà không làm lộ các dữ liệu nhạy cảm hay cuộc trò chuyện cá nhân của Sen, thực thể `PetDetail` được tái cấu trúc bẻ nhỏ thành **3 phân nhóm dữ liệu độc lập**:

### 1. Phân nhóm A: Sinh Học & Y Khoa (Vet Block)
*   *Mục đích:* Dành cho Bác sĩ Thú y.
*   *Dữ liệu:* Tên, loài, giống, giới tính, ngày sinh, lịch sử biểu đồ cân nặng (`weight_logs`), lịch sử tiêm phòng đầy đủ (`vaccine_records`), dị ứng thuốc và cảnh báo y tế đặc biệt.

### 2. Phân nhóm B: Chăm Sóc & Lối Sống (Hotel Block)
*   *Mục đích:* Dành cho Khách sạn chó mèo / Người trông hộ.
*   *Dữ liệu:* Thói quen ăn uống (`diet_schedule` JSON: giờ ăn, định lượng, loại hạt pate yêu thích), dị ứng thức ăn (`allergies`), thói quen ngủ (`sleeping_habits` - ngủ chuồng hay ngủ chung giường), các dặn dò chăm sóc đặc biệt (`care_instructions`) v
<truncated 1523 bytes>
: `https://pet.capcat.app/share/<shareable_token>`
*   Bác sĩ thú y hoặc chủ khách sạn chỉ cần quét mã QR hoặc mở link trên trình duyệt điện thoại để xem ngay một giao diện Web phẳng tối giản (Web View) cực kỳ đẹp mắt và dễ đọc mà không cần cài đặt ứng dụng Capcat.

---

## III. THIẾT LẬP LƯỢC ĐỒ CSDL SQLite CỤC BỘ MỚI (DATABASE DRAFT)

Tôi đã thiết lập chi tiết lược đồ CSDL SQLite mở rộng gồm 4 bảng để hỗ trợ lưu trữ cấu trúc đa diện này:
*   `pet_profile` (lưu định danh sinh học gốc & xưng hô AI riêng tư).
*   `pet_weight_logs` (lưu lịch sử cân nặng phục vụ thú y).
*   `pet_vaccine_records` (lưu lịch sử tiêm phòng phục vụ thú y).
*   `pet_lifestyle_habits` (lưu thói quen ăn uống, ngủ nghỉ, dị ứng, dặn dò phục vụ khách sạn).

*(Chi tiết mã lệnh SQL khởi tạo bảng đã được đặc tả hoàn chỉnh trong tệp [SPEC_SHARABLE_PET_PROFILE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_SHARABLE_PET_PROFILE.md#iv-%C4%90%E1%BA%B7c-t%E1%BA%A3-l%C6%B0%E1%BB%A3c-%C4%91%E1%BB%93-d%E1%BB%AF-li%E1%BB%87u-sqlite-c%E1%BB%A5c-b%E1%BB%99-database-schema)).*

---

Toàn bộ tài liệu đặc tả hồ sơ Pet đa chiều đã được tích hợp hoàn tất vào thư mục [NAMIYA_MAILBOX_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/) và đồng bộ hóa vào tệp [walkthrough.md](file:///Users/macinia/.gemini/antigravity-ide/brain/4c94a7f9-32cc-41bb-9780-dd6ec8bd05d1/walkthrough.md). Mọi hành động của tôi vẫn nằm ở **giai đoạn nghiên cứu và đặc tả tài liệu, hoàn toàn không sửa đổi bất kỳ dòng code nào của app**.

Bạn thấy bản tái cấu trúc dữ liệu hồ sơ Pet và cơ chế chia sẻ phân quyền ngoài hệ thống này đã đáp ứng trọn vẹn và đúng tầm nhìn của bạn chưa ạ?
