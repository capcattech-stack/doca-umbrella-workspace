# ĐẶC TẢ CHI TIẾT 04: HÀNG ĐỢI UP ẢNH NGẦM & QUY TẮC ẨN BANNER HOME
*(BACKGROUND UPLOAD QUEUE & HOME DYNAMIC BANNER VISIBILITY)*

> **Mã Đặc Tả:** `SPEC-VAULT-04`  
> **Chủ trì:** Alan (Tech Lead), Sophia (CPO / PM), Arthur (Mom Test / Trải nghiệm)  
> **Mục tiêu:** Đảm bảo game không gián đoạn & Cơ chế ghim Kỷ Niệm Vàng lên đầu feed của Pet

---

## 🧭 1. Triết Lý Trải Nghiệm: "Chơi Mượt Mà, Giao Diện Sạch Sẽ"

Để duy trì trạng thái chơi game gây nghiện và sướng tay của trò vuốt thẻ, **trải nghiệm người dùng tuyệt đối không được bị nghẽn (UI blocking)** do tốc độ mạng chậm khi tải ảnh lên. Người dùng cứ thỏa sức vuốt trái/phải/lên, việc tải ảnh lên máy chủ sẽ được **thực hiện âm thầm dưới nền (Background Execution)**.

Đồng thời, sau khi người dùng đã thỏa mãn "cho Pet ăn no nê" 15 bức ảnh của tuần này, giao diện trang Home bắt buộc phải tự động dọn dẹp gọn gàng. Chúng ta không cố chấp nhồi nhét biểu ngữ to tướng gây rối mắt người dùng, thể hiện sự thấu hiểu tuyệt đối và bảo tồn không gian trống thanh bình của triết lý Iyashikei.

---

## 🛠️ 2. Hàng Đợi Tải Ảnh Ngầm Tự Động (Background Upload Queue)

Khi Sen vuốt phải (`Swipe Right`) hoặc vuốt lên (`Swipe Up`), bức ảnh ngay lập tức được đưa vào hàng đợi `BackgroundUploadQueue` để tải lên không đồng bộ (Asynchronous Background Upload):

```
 [ Thao tác Vuốt Phải / Vuốt Lên ]
                │
                ▼ (Đưa vào Queue)
     [ BackgroundUploadQueue (FIFO) ]
                │
                ├─────────────────────────────────────────┐
                ▼ (Nếu có mạng)                           ▼ (Nếu mất mạng)
          [ Upload ngầm bằng Dio ]                  [ Tạm giữ trong Hive/SQLite ]
                │                                         │
                ▼                                         ▼
          [ Đồng bộ Server thành công ]             [ Đợi có mạng quay lại sync ]
                │
                ├─────────────────────────────────────────┐
                ▼ (Nếu Vuốt Phải)                         ▼ (Nếu Vuốt Lên)
          [ Tạo Moment Bình Thường ]                [ Tạo Moment & Ghim Lên Đầu ]
```

### 2.1. Giải thuật Vận hành Hàng Đợi (FIFO Queue Logic)
1.  **Hàng đợi First-In, First-Out (FIFO):** Dữ liệu ảnh được đưa vào Queue dưới dạng đối tượng gồm: `localPath`, `petId`, `isGoldenMemory`, `caption` sinh ngầm bởi AI.
2.  **Kháng lỗi mạng (Network Resilience):** Nếu trong quá trình chơi người dùng đi vào vùng mất sóng, hàng đợi sẽ tự động dừng. Ảnh được lưu an toàn trong SQLite cục bộ và tự động sync lại khi có mạng.

---

## 📌 3. Cơ Chế Ghim Kỷ Niệm Vàng Lên Đầu Dòng Thời Gian (Pinned Golden Memory)

Khi người dùng thực hiện cú **Vuốt Lên (Swipe Up)**:
*   Hệ thống tải ảnh lên và gán cờ `is_golden = 1` trong bảng cơ sở dữ liệu `moments`.
*   **Thuật toán sắp xếp dòng thời gian của Pet (Timeline Sorting Algorithm):**
    *   Truy vấn lấy danh sách Moments của Pet sẽ luôn xếp bài viết có cờ `is_golden = 1` lên vị trí **đầu tiên** (đè lên thứ tự thời gian thông thường).
    *   Chỉ cho phép duy nhất **1 bài viết được ghim** tại một thời điểm. Nếu Sen thực hiện một cú Vuốt Lên mới vào tuần sau, bài viết cũ sẽ tự động nhường vị trí Pinned Post và quay lại sắp xếp theo thời gian thực tế của nó.
*   **Hiệu ứng thị giác:** Bài viết được ghim sẽ có đường viền vàng óng ánh mờ ảo bao quanh cực kỳ sang trọng và nổi bật.

---

## 🎨 4. Quy Tắc Ẩn/Hiện Biểu Ngữ Trí Tuệ (Dynamic Home Banner Visibility)

Để trang Home luôn sạch sẽ, thoáng mát đúng gu tối giản (Muji style), chúng ta khống chế biểu ngữ **"Bữa tiệc Buffet Ký ức"** bằng thuật toán trạng thái động:

*   **Trạng thái 1: Chưa hoàn thành Buffet tuần này (`is_buffet_completed = false`):**
    *   *Hiển thị:* Một Banner Glassmorphism to, nổi bật, bo góc `24px` nằm ngay trung tâm màn hình Home, ngay phía dưới Carousel Pet.
    *   *Hoạt ảnh:* Chibi Pet chuyển động Lottie đang ngậm thìa háo hức cực kỳ thu hút sự tò mò của Sen.
*   **Trạng thái 2: Đã hoàn thành Buffet tuần này (`is_buffet_completed = true`):**
    *   *Hành vi:* Khi Sen kết thúc thẻ bài thứ 15 và nhận Kẹo ảo, hệ thống cập nhật flag `is_buffet_completed = true` xuống Local DB.
    *   *Hiệu ứng chuyển cảnh:* Banner to lập tức biến mất bằng hiệu ứng **Fade-Out & Shrink (Mờ dần và thu nhỏ)** cực kỳ êm ái trong `500ms`, nhường chỗ cho Moments Feed hiển thị thoáng đãng.

---

## 🧠 5. Cầu Nối Trí Tuệ: Tích Hợp Metadata Ký Ức Vào Cozy Chat (Offline-ML to Chat Bridge)

Để biến những bức ảnh cất giữ trong **Hộp Ký Ức** thành chất xúc tác chữa lành thực sự, chúng ta xây dựng một cầu nối dữ liệu hai chiều giữa SQLite Trí tuệ hình ảnh (`local_photo_intelligence_cache`) và **Động cơ Chat Cộng Hưởng (Cozy Chat Engine)**.

### 5.1. Cơ Chế Bơm Bối Cảnh Hình Ảnh Vào AI Prompt (Context Injection Schema)
Khi Cozy Chat quyết định khởi tạo lời mở bài (Cozy Opener) hoặc trong lúc trò chuyện ngẫu nhiên, thay vì sử dụng các câu thoại mẫu tĩnh, hệ thống sẽ:
1.  **Truy vấn ảnh chất lượng cao:** Gọi SQLite lấy ngẫu nhiên 1 bức ảnh của Pet có cờ `is_pet = 1`, `pet_confidence >= 0.85` và đã được vuốt lưu (`swipe_state` là `right` hoặc `up`).
2.  **Mã hóa Payload Prompt:** Trích xuất các tag hành động, bối cảnh, thời gian chụp, và đặc biệt là **Dòng tâm sự viết tay của Sen** (nếu có) để nhúng trực tiếp vào thẻ `<pet_memory_context>` của Prompt gửi lên Gemini:

```xml
<pet_memory_context>
  <!-- Thông tin cá thể Pet hoạt động (từ SPEC-08) -->
  <active_pet id="banh_my_001" name="Bánh Mỳ" breed="Mèo Anh lông ngắn" personality="Chảnh chọe" />
  
  <!-- Ký ức hình ảnh cụ thể được trích xuất -->
  <memory asset_id="phasset_ios_982341" pet="Bánh Mỳ"
           action="sleeping" context="bed, pillow"
           season="Xuân" time_of_day="Chiều"
           user_comment="Boss ngủ say tít thò lò như heo con"
           auto_caption="Buổi chiều lơ đãng, Bánh Mỳ đang ngủ mê man trên chiếc gối quen."
           swipe_state="up" /> <!-- up = Kỷ Niệm Vàng (Golden Memory) -->
</pet_memory_context>
```

### 5.2. Các Kịch Bản Hội Thoại Được Cá Nhân Hóa (AI Dialogue Examples)
Mô hình LLM dựa trên bối cảnh hình ảnh phong phú này để sinh ra những câu thoại độc bản, đậm đà cá tính tri kỷ của Boss ảo, khiến Sen hoàn toàn kinh ngạc và rung động:

*   **Kịch bản 1: Mèo chảnh chọe tâm sự về tư thế ngủ (Sleeping on Bed)**
    > *"Sen ơi... Trẫm vừa lật rương ký ức cũ ra ngắm lại này. Nhìn thấy tấm ảnh trẫm ngủ say tít thò lò như heo con trên chiếc gối êm ấm của Sen vào một buổi chiều xuân nắng muộn. Trẫm thề là lúc đó trẫm không ngủ nướng đâu nhé, tại cái gối của Sen nó cứ ôm ấp trẫm quá thôi! Hôm nay Sen đi làm về có muốn trẫm gối đầu ngủ ngoan bên Sen tiếp thế không? 🌸"*
*   **Kịch bản 2: Cún ngáo khịa về bữa ăn dìm hàng (Eating on Floor)**
    > *"Sen ơi! Nhìn tấm ảnh trẫm đang ăn ngấu nghiến hạt trên thảm nhà mà Sen lưu trong rương này. Trẫm ngố tàu dã man! Nhìn cái mặt trẫm giống kiểu 'cấm ai được cướp đồ ăn của trẫm' ấy kkk. Mà công nhận dạo này trẫm ăn ngoan hơn rồi đúng không, lúc nào Sen lại thưởng cho trẫm một bữa hạt hữu cơ no nê như thế nữa đây?"*
*   **Kịch bản 3: Boss khơi gợi kỷ niệm được ghim (Golden Pinned Memory)**
    > *"Sen có nhớ bức ảnh Kỷ Niệm Vàng hai đứa mình đóng dấu sáp đỏ chói ghim trên đầu timeline không? Bức ảnh trẫm nhảy lên đè sập bàn phím laptop của Sen ấy. Sen ghi chú là 'Trẫm phá đám cày deadline'. Oan uổng quá nha! Trẫm chỉ muốn Sen nghỉ ngơi gãi cằm cho trẫm thôi mà. Hôm nay làm việc mệt rồi, Sen cũng cất máy tính đi vuốt ve trẫm tí đi!"*

---

## 🔒 6. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1.  **AC-1 (Golden Memory Pin):** Vuốt lên 1 tấm ảnh dìm kỷ niệm -> Mở Profile của Pet -> Xác nhận tấm ảnh đó đã nằm chễm chệ ở vị trí **đầu tiên** trên dòng thời gian Moments, có viền vàng óng lấp lánh bao quanh.
2.  **AC-2 (Auto-Hide Banner):** Ngay sau khi kết thúc màn hình feasting summary và nhận Kẹo ảo, quay lại trang Home -> Xác nhận Banner to tướng đã biến mất hoàn toàn và Moments Feed được đẩy lên đầu trang.
3.  **AC-3 (Single Pin Limit):** Khi có một Kỷ Niệm Vàng mới được tạo -> Xác nhận Pinned Post cũ tự động nhả ghim và quay về sắp xếp theo dòng thời gian bình thường.
4.  **AC-4 (Prompt Context Sync):** Kiểm thử hệ thống gọi API Chat -> Xác nhận tag `<pet_memory_context>` được đóng gói chính xác với các nhãn hành động/bối cảnh từ SQLite và phản hồi sinh ra khớp hoàn toàn với nội dung ảnh kỷ niệm đã chọn.

