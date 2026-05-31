# 📊 ĐẶC TẢ MA TRẬN DỮ LIỆU TRÍ TUỆ NHÂN TẠO & COZY KYC
*(SPEC_05_COZY_KYC_DATA_MATRIX - MULTI-BOSS PRONOUN & AI SEMANTIC MEMORY SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC_05_COZY_KYC_DATA_MATRIX`  
> **Phân hệ cha:** `AUTHENTICATION_AND_ONBOARDING_ENGINE`  
> **Chủ trì:** Sophia (CPO) & Alan (Tech Lead / AI Context Architect)  
> **Trạng thái:** Hoàn thành (Dev-Ready - Đã vá đối kháng & Tinh chỉnh triết lý)  

---

## I. TRIẾT LÝ THIẾT KẾ CỐT LÕI: "ẨN MÌNH CỦA SEN, TỎA SÁNG CỦA BOSS"
*(THE ANTI-PARANOIA & PET-CENTRIC EMOTIONAL PRINCIPLE)*

Để bảo vệ tuyệt đối không gian chữa lành **Iyashikei** và ngăn chặn cảm giác bị theo dõi, rình mò bởi trí tuệ nhân tạo (AI Paranoia), Capcat MVP áp dụng một triết lý thiết kế dữ liệu mang tính nhân văn sâu sắc:

> 🧭 **Triết lý "Ẩn mình của Sen, Tỏa sáng của Boss":**  
> 1.  **Tuyệt đối KHÔNG hiển thị cho Sen thấy AI biết những gì về mình:** Chúng ta không bao giờ trưng bày một danh sách các thói quen, sở thích hay lịch trình của Sen mà AI thu thập được lên trang Profile của Sen. Việc nhìn thấy một hệ thống "đọc vị" mình sẽ gây ra cảm giác bị giám sát vô cùng ngột ngạt.
> 2.  **Tập trung TỔNG HỢP và TRƯNG BÀY thế giới của Boss:** Toàn bộ sự thấu hiểu, dữ liệu thu thập được từ hội thoại sẽ được **dịch chuyển và phản chiếu hoàn toàn lên Hồ sơ của Boss (Pet Profile)** dưới dạng các thông số sinh học chuyên nghiệp, biểu đồ y khoa sắc nét và nhật ký thói quen/sở thích sinh động của chính Boss.
> 
> *Kết quả:* Sen cảm nhận được sự thấu hiểu kỳ diệu và chuyên nghiệp của ứng dụng thông qua sức khỏe, sự phát triển và những ghi chép tỉ mỉ về Boss, trong khi bản thân Sen hoàn toàn an toàn và tự do dưới bóng mát riêng tư.

---

## II. GIẢI PHÁP ĐỒNG BỘ ĐẠI TỪ XƯNG HÔ ĐA BOSS (DECOUPLED PRONOUNS)

Đại từ xưng hô sẽ được **tách biệt hoàn toàn khỏi User Profile** và được lưu trữ trực tiếp tại **Hồ sơ sinh học của từng Boss (`PetDetail` / CSDL cục bộ `pet_profile`)**.

```
+-------------------------------------------------------------+
|                     USER PROFILE (GỐC)                      |
|  - fullName: "Nguyễn Linh" (Chỉ hiển thị thông tin cơ bản)  |
|  - email: "linh@example.com"                                |
|  - dob: "25/12/2000"                                        |
+-------------------------------------------------------------+
                               |
            +------------------+------------------+
            |                                     |
            v                                     v
+-----------------------------+       +-----------------------------+
|      BOSS 1: MÈO BÁNH MỲ    |       |      BOSS 2: CHÓ LUCKY      |
|  - selfTerm: "Trẫm"         |       |  - selfTerm: "Con"          |
|  - ownerTerm: "Sen"         |       |  - ownerTerm: "Mẹ"          |
+-----------------------------+       +-----------------------------+
```

*   **Cơ chế hoạt động:** Khi người dùng mở phòng chat với Boss nào, server sẽ chỉ lấy cấu hình `selfTerm` và `ownerTerm` của chính Boss đó để nạp vào hệ thống System Prompt của LLM của Boss đó, duy trì tuyệt đối vibe cá tính riêng biệt.

---

## III. MA TRẬN PHÂN LOẠI DỮ LIỆU TRÍ TUỆ NHÂN TẠO (AI SEMANTIC DATA MATRIX)

Khi trò chuyện tri kỷ (Cozy Chat), hệ thống AI của Capcat sẽ **tự động trích xuất ngữ nghĩa (Semantic Extraction)** các thói quen, sở thích, trạng thái cảm xúc của Sen. Để đảm bảo tính minh bạch dữ liệu và kiểm soát quyền riêng tư, dữ liệu được phân cấp nghiêm ngặt thành **4 Nhóm rõ ràng**:

### 📊 MA TRẬN DỮ LIỆU COZY KYC

| Nhóm Dữ Liệu | Trạng thái hiển thị | Danh sách các trường cần thu thập | Cơ chế xử lý & Cập nhật ngầm (Backend NLP Logic) |
| :--- | :---: | :--- | :--- |
| **Nhóm 1: Hồ sơ Sen hiển thị công khai (Public User Profile)** | **HIỂN THỊ & CHO SỬA** | - `fullName` (Tên hiển thị)<br>- `email` (Email xác thực)<br>- `dob` (Ngày sinh của Sen)<br>- `avatarUrl` (Ảnh đại diện Sen) | **Tối giản tối đa:** Người dùng tự điền hoặc sync từ Google. Trang Profile của Sen cực kỳ sạch sẽ, cơ bản, tuyệt đối không chứa bất kỳ thuộc tính suy luận nào của AI về Sen. |
| **Nhóm 2: Hồ sơ Boss hiển thị công khai (Public Pet Profile)** | **HIỂN THỊ CHUYÊN NGHIỆP & CHO SỬA** | - `name` (Tên Boss)<br>- `breed` (Giống loài)<br>- `birthday` (Ngày sinh Boss)<br>- `selfTerm` (Tự xưng của Boss)<br>- `ownerTerm` (Cách Boss gọi Sen) | Người dùng thiết lập lúc đón Boss về nhà. Có thể cập nhật bất kỳ lúc nào tại màn hình Chỉnh sửa hồ sơ thú cưng. |
| **Nhóm 3: Hồ sơ sở thích & thói quen ẩn dưới dữ liệu (Hidden Semantic Memory Core)** | **ẨN HOÀN TOÀN TRÊN UI CỦA SEN** | - `likes` (Sở thích: thể loại nhạc Lofi, sách chữa lành...)<br>- `dislikes` (Những điều Sen ghét: ghét ăn hành tây, ghét trời mưa...)<br>- `sleeping_habit` (Giờ ngủ: thức khuya, ngủ sớm...)<br>- `work_schedule` (Giờ làm: làm hành chính, làm ca đêm...) | **Trích xuất tự động qua NLP Chat:** Khi Sen nhắn tin *"Tui ghét ăn hành tây cực"*, AI ngầm phân tích và ghi đè thuộc tính JSON cục bộ. **Tuyệt đối ẩn trên UI của Sen** để tránh cảm giác bị theo dõi, chỉ dùng để gợi ý Cozy Opener hoặc Spontaneous Push phù hợp theo nhịp sinh học của Sen. |
| **Nhóm 4: Dữ liệu thô lưu nhưng KHÔNG phân loại (Uncategorized Raw Data)** | **ẨN (Chỉ lưu thô làm lịch sử)** | - `raw_chat_history` (Toàn bộ tin nhắn chat thô)<br>- `unstructured_emotional_triggers` (Những cơn giận dỗi nhất thời, khóc lóc, cãi nhau với người yêu, áp lực sếp mắng...) | **Không phân loại (Uncategorized):** Những cảm xúc tiêu cực mang tính thời điểm chỉ lưu thô trong lịch sử chat để AI duy trì mạch hội thoại của phiên chat hiện tại. **Tuyệt đối không trích xuất thành thuộc tính cố định** để tránh việc Boss AI ghi nhớ những định kiến tiêu cực hoặc ám ảnh về Sen, giữ gìn một Boss AI luôn ấm áp và an lành dài hạn. |

---

## IV. BỘ LỌC AN TOÀN CẢM XÚC (EMOTIONAL SAFETY FILTER)

Chúng tôi thiết lập một bộ lọc an toàn cảm xúc (Emotional Safety Filter) trên mô hình NLP. Khi người dùng bày tỏ các thông tin mang tính chất **hoảng loạn, stress nặng hoặc giận dữ**, hệ thống sẽ:
*   Chỉ ghi nhận thô vào phiên chat để Boss AI vỗ về, an ủi Sen ngay lập tức.
*   Tuyệt đối **không đưa thông tin này vào cơ sở dữ liệu dài hạn (Semantic Memory Core)** để tránh việc Boss bị lập trình lại thành một chú thú cưng u uất, buồn bã hoặc luôn đề phòng Sen trong tương lai. Điều này đảm bảo tính năng ẩn chữa lành luôn giữ được tinh thần Iyashikei ban sơ.

---

*Tài liệu đặc tả ma trận dữ liệu trí tuệ nhân tạo đã hoàn thành, sẵn sàng chuyển giao kỹ thuật. Ký tên: Team Cố vấn Capcat (Sophia & Alan)*
