# 03. DANH MỤC THÀNH PHẦN GIAO DIỆN CHUẨN MUJI (MUJI COMPONENT CATALOG)

---

## 🧭 1. Thanh Dock Điều Hướng Dưới Đáy (Bottom Navigation Dock)

Thanh Dock điều hướng là trung tâm định hướng toàn cục của ứng dụng, tuân thủ ngôn ngữ phẳng hoàn toàn của **MUJI Warm Minimalism**:

```
+---------------------------------------------------------------------------------+
|                                                                                 |
|      [🏠]             [💬]             [📸]             [🎧]             [👤]   |
|      ____                                                                       | <--- Thanh chỉ báo trượt (Muji Bar)
|                                                                                 |
+---------------------------------------------------------------------------------+
|   (Trang Chủ)      (Tri Kỷ)       (Ký ức)       (Thư giãn)       (Tài khoản)   |
|   Lucide: Home  MessageSquare  Lucide: Camera  Headphones      Lucide: User     |
+---------------------------------------------------------------------------------+
```

### 1.1. Quy chuẩn Thẩm mỹ & Hình khối (Aesthetic Specs)
*   **Chiều cao:** Cố định `56px` + vùng đệm an toàn của hệ điều hành (Safe Area bottom).
*   **Đường chỉ ngăn:** Một nét mảnh `1px solid #EAEAEA` phân tách dock với vùng hiển thị nội dung phía trên.
*   **Không nhãn chữ (No Labels):** Chỉ hiển thị Icon đơn nét tối giản của Lucide, **tuyệt đối không hiển thị nhãn chữ bên dưới** để tối giản tối đa giao diện.
*   **Màu sắc:** Nền màu yến mạch mờ `rgba(251, 251, 250, 0.95)` (Light Mode) hoặc `rgba(13, 13, 13, 0.95)` (Dark Mode).

### 1.2. Trạng thái Tương tác & Phản hồi (Interaction & Feedback States)
*   **Màu sắc Icon:** Màu xám tro `#8C8C8C` khi không được chọn (Inactive). Khi được chọn (Active), icon chuyển sang màu đen Obsidian `#262626` (Light Mode) hoặc Sakura Pink `#EAB0B2` (Dark Mode).
*   **Thanh Chỉ Báo Trượt (Floating Muji Bar):** Một thanh ngang phẳng mảnh (`width: 16px`, `height: 2px`, bo góc tròn `1px`) nằm sát mép dưới sẽ trượt ngang mượt mà (`AnimatedPositioned`) bên dưới icon đang active. Chạm chọn kích hoạt nhịp rung nhẹ (`HapticFeedback.selectionClick()`).
*   **Sóng Nhạc Thở Chậm (Breathing Lofi Waveform):** Khi nhạc lofi được phát ở background, icon Góc Thư Giãn (`Headphones`) tự động chuyển sang hoạt ảnh 3 vạch sóng dọc mảnh nhấp nhô cực chậm theo chu kỳ thở `3.0s - 4.0s` mô phỏng nhịp sinh học bình yên.
*   **Chỉ Báo Cánh Hoa Rơi (Cherry Blossom Silent Badge):** Khi có tin nhắn chưa đọc hoặc thư mới trong Thùng Sữa, một chấm tròn màu hồng Sakura nhạt `#EAB0B2` (độ rộng `6px`) sẽ xuất hiện thầm lặng ở góc trên bên phải icon. Tuyệt đối không hiển thị con số thông báo.

---

## 🎛️ 2. Ma Trận Nút Bấm (Buttons Specs)

Tất cả nút bấm đều sử dụng bo góc cố định `12px` (`Radius.cozyButton` token). Chiều cao tối thiểu đáp ứng chuẩn iOS (44px) và Android (48px) để triệt tiêu ma sát chạm.

```
                      MA TRẬN NÚT BẤM (BUTTONS MATRIX)
      
                     [ Primary ]      [ Secondary ]    [ Sensory Cat ]   [ Sensory Dog ]
      +-----------+ +---------------+ +---------------+ +---------------+ +---------------+
  L   | Height 56 | | Bắt đầu ngay  | |   Quay lại    | |   Vuốt ve 🐱  | |    Đi dạo 🐶  |
      +-----------+ +---------------+ +---------------+ +---------------+ +---------------+
  M   | Height 48 | |   Lưu lại     | |    Bỏ qua     | |   Vuốt ve 🐱  | |    Đi dạo 🐶  |
      +-----------+ +---------------+ +---------------+ +---------------+ +---------------+
  S   | Height 36 | |     Hủy       | |     Thêm      | |   Vuốt ve 🐱  | |    Đi dạo 🐶  |
      +-----------+ +---------------+ +---------------+ +---------------+ +---------------+
```

### 2.1. Trạng thái Nút Bấm Cozy Light (Nền Sáng)
*   **A. Nút Bấm Chính (Primary Button):**
    *   *Default State:* Nền `Charcoal` (`#15170F`), chữ `Cloud` (`#FBFAF6`), font `Inter Bold`.
    *   *Hover/Active:* Nền `Charcoal` (`#15170F` mờ nhẹ/sáng hơn).
    *   *Disabled:* Nền `#15170F` với `opacity: 30%` (không nhận tương tác), chữ `Cloud` (`opacity: 40%`).
*   **B. Nút Bấm Phụ (Secondary Button):**
    *   *Default State:* Nền `Sand` (`#E8E3D6`), viền `1px solid #D4CDBF`, chữ `Charcoal` (`#15170F` mờ 75%), font `Inter Medium`.
    *   *Hover/Active:* Nền `Paper` (`#F4F1E9`), viền `1px solid #C8C2B4`. Chữ `Charcoal` (mờ 90%).
    *   *Disabled:* Nền `#E8E3D6` mờ 40%, viền `#D4CDBF` mờ 30%, chữ mờ 30%.
*   **C. Nút Cảm Xúc Mèo (Sensory Cat):**
    *   *Default State:* Nền `Sakura Pink` (`#EAB0B2` mờ 20%), chữ `Charcoal` (`#15170F`), font `Inter SemiBold`.
    *   *Hover/Active:* Nền `Sakura Pink` mờ 35%.
*   **D. Nút Cảm Xúc Chó (Sensory Dog):**
    *   *Default State:* Nền `Matcha Green` (`#A3B892` mờ 15%), chữ `Charcoal` (`#15170F`), font `Inter SemiBold`.
    *   *Hover/Active:* Nền `Matcha Green` mờ 28%.

### 2.2. Trạng thái Nút Bấm Cozy Dark (Nền Tối)
*   **A. Nút Bấm Chính (Dark Primary):** Nền `Pure White` (`#FBFAF6`), chữ `Charcoal Black` (`#121212`), font `Inter Bold`.
*   **B. Nút Bấm Phụ (Dark Secondary):** Nền `Pure White` mờ kính (`opacity: 8%`), viền `1px solid` màu `#FBFAF6` mờ 12%, chữ `Soft Milk Beige` (`#F5F5F0` mờ 80%).
*   **C. Nút Phát Sáng Neon (Dark Neon Glowing):** Nền `Neon Healing Green` (`#76C123`), chữ `Charcoal Black`, font `Inter Bold`. `boxShadow: rgba(118, 193, 35, 0.2) blur 16px`.

---

## 📝 3. Ô Nhập Liệu Cảm Xúc Lai (Cozy Input Fields)

### 3.1. Muji Soft Block Input (Mặc định cho Cài Đặt, Profile, Chat)
*   **Default State:** Nền `Paper` nhạt (`#F4F1E9`), không viền, bo góc `16px`. Chữ gợi ý màu **xám trung tính đậm `#6E6E6A`** (`Inter Regular 13px`).
*   **Active / Focus State:** Nền Kem sáng (`#FFFDF9` trong Light Mode) hoặc đen thuần (`#0D0D0D` trong Dark Mode). Bắt buộc có viền màu **đen Charcoal sẫm** (`1px solid #121212` / `#FBFAF6`). Bóng đổ mịn `boxShadow: rgba(0, 0, 0, 0.03), blur: 12px, y: 4px`.

### 3.2. Vintage Lined Input (Chuyên dụng cho Thư Tay Namiya)
*   **Default State:** Nền trong suốt. Chỉ có đường kẻ đáy (border-bottom) `1px solid #D2D2CC` (Light Mode) hoặc `#4C4C44` (Dark Mode).
*   **Active / Focus State:** Đường kẻ đáy chuyển sang màu đen Charcoal `#121212` (Light Mode) hoặc trắng `#FBFAF6` (Dark Mode).
*   **Error State:** Đường kẻ đáy chuyển sang màu hồng anh đào sẫm `#FFCDD2` hoặc Sakura Pink `#EAB0B2`. Dòng chữ báo lỗi nhỏ màu đỏ sẫm (`#B71C1C`) hiển thị bên dưới.

### 3.3. Thanh Nhập Liệu Chat Tri Kỷ (Muji Chat Input Bar)
Bộ khung nhập liệu tích hợp dưới đáy của Phòng Chat, tự động co giãn chiều cao theo nội dung nhập (cơ bản `56px`, nở rộng tối đa `120px` kèm thanh cuộn):
*   **Nền chứa:** Nền yến mạch mờ `rgba(251, 251, 250, 0.95)` với `backdrop-filter: blur(10px)`. Đường viền đỉnh mảnh `1px solid #EAEAEA`.
*   **Nút đính kèm cảm xúc (Left Action Icon):** Nằm bên trái (`[+]` hoặc icon Hộp quà `[🎁]`). Kích thước `36x36px`, chạm vào trượt mở Bottom Sheet đính kèm.
*   **Khung gõ chữ (Text Input):** Sử dụng đặc tả **Muji Soft Block Input** không viền, nền `Paper` `#F4F1E9`, bo góc tròn thuốc nhộng `20px`.
*   **Nút gửi (Right Send Button):** Nút tròn nhỏ `36x36px` nền màu hồng Sakura `#EAB0B2` hoặc Matcha Green `#A3B892`, icon mũi tên đơn nét mảnh màu Charcoal `#121212`. Khi ô nhập rỗng, nút gửi tự động chuyển đổi sang icon micro ghi âm mờ `[🎤]`.

---

## 💬 4. Bong Bóng Chat Muji Cozy (Cozy Chat Bubbles)

Thiết kế bong bóng chat phẳng tuyệt đối, triệt tiêu hoàn toàn phần đuôi nhọn răng cưa để tạo sự ngăn nắp, cân đối:

```
  [ Cozy Light Mode - Ban ngày ]
  (Boss - Trái):  🐾 Lucky đã đi dạo được 15 phút rồi!   <--- Không khung, Space Mono Italic, #1C1C1E
  (Sen - Phải):   .- - - - - - - - - - - - - - - - - -.
                  :  Tốt quá, lát về nhớ uống nước      : <-- Nền #FDFBF7, viền nét đứt mờ #D2D2CC
                  :  nhé bé cưng 🦴                   :
                  '- - - - - - - - - - - - - - - - - -'
```

### 4.1. Đặc Tả Cozy Light Mode (Mặc Định Ban Ngày)
*   **Thoại của Sen (Bên phải):** Nền trắng kem Cloud `#FBFAF6`, viền nét đứt `1px dashed #D4CDBF`. Bo góc `12px` (riêng góc dưới bên phải chỉ bo `4px` để chỉ hướng). Chữ `Inter Regular 13px` màu Charcoal `#15170F`.
*   **Thoại của Boss (Bên trái):** Trong suốt hoàn toàn (Không sử dụng khung bong bóng). Bắt đầu bằng icon bàn chân nhỏ `🐾`. Chữ nằm trực tiếp trên nền màn hình chat, sử dụng font `Space Mono Italic 13px` màu Charcoal `#15170F`. Hiệu ứng typewriter chạy chữ chậm kèm tiếng gõ nhẹ.
 
### 4.2. Đặc Tả Cozy Dark Mode (Tự Động Ban Đêm)
*   **Thoại của Sen & Boss:** Nền mờ kính sương `rgba(255, 255, 255, 0.04)` kết hợp `backdrop-filter: blur(16px)`. Bo góc đều `12px` cả hai bên (không có đuôi nhọn).
*   **Viền phát sáng nhẹ:** Đường viền siêu mảnh `0.5px solid` màu hồng Sakura `#EAB0B2` mờ 30% (Sen) hoặc màu xanh Matcha `#A3B892` mờ 30% (Boss). Chữ `#FFFFFF` mờ 95%.

---

## 🎴 5. Thẻ Giao Diện (Cards Specs)

Các thẻ giao diện sắp xếp ngăn nắp, phẳng phiu, bo góc chuẩn `16px` (`Radius.cozyCard` token) hoặc `28px` cho thẻ Boarding Pass đặc biệt.

*   **A. Thẻ Sáng Tiêu Chuẩn (Light Card - Muji Flat):** Nền `Cloud` (`#FBFAF6`), viền `1px solid #EAEAEA`, bóng đổ cực loãng.
*   **B. Thẻ Ký Ức (Moments Card):** Nền màu sữa giấy thủ công `Paper` (`#F4F1E9`), viền `1px solid #D4CDBF`, bóng dẹt sát đáy.
*   **C. Thẻ Vé Tối Chuyên Biệt (Ticket Card - Cozy Dark):** Nền `Ticket Charcoal` (`#1E1F24`), viền `1px solid #2C2C2E`, bóng hào quang cam ấm loãng.
*   **D. Thẻ Vé Tàu Thượng Hạng (Boarding Pass Card - Premium):** Nền `Ticket Charcoal` (`#1E1F24`), viền `1px solid #2C2C2E`, bo góc cong lớn `28px`. Có nét đứt xé vé ở tọa độ 2/3 thẻ màu trắng sữa mờ 15%. Có chấm tròn xanh Matcha `Neon Healing Green` phát sáng chỉ thị Premium.
*   **E. Thẻ Kính Mờ Bình Minh (Glassmorphic Card):** Nền kính trắng sữa mỏng `rgba(255, 255, 255, 0.06)`, viền trắng mờ mảnh, lọc nhòe `backdrop-filter: blur(12px)`.

---

## 📋 6. Dòng Danh Sách Đặc Thù (List Items)

Chiều cao cố định `64px` (hoặc `72px` cho danh sách chat), đường viền ngăn cách dưới đáy mảnh `1px solid #EAEAEA` phẳng.

*   **A. Dòng Bài Hát (Song List Row):** Trái: Nút Play nhỏ / số thứ tự Space Mono 12px. Giữa: Tên bài hát (`Inter SemiBold 14px`) + Nghệ sĩ (`Inter Regular 12px` mờ). Phải: Thời lượng bài hát (`Space Mono 12px`).
*   **B. Dòng Sách (Book List Row):** Trái: Ảnh bìa sách nhỏ (`40x52px` bo góc 4px). Giữa: Tên sách + Tác giả. Phải: Tiến trình đọc phần trăm (`Space Mono 12px`) + Nút hành động nhanh "Đọc".
*   **C. Dòng Nhân Vật (Character List Row):** Trái: Avatar thú cưng (`diameter: 40px`). Giữa: Tên Boss + Trạng thái hoạt động. Phải: Nút hành động "Tương tác".
*   **D. Dòng Sản Phẩm (Product List Row):** Trái: Ảnh sản phẩm vuông (`48x48px` bo góc 8px). Giữa: Tên sản phẩm + Nhãn cảm xúc của Pet. **Tuyệt đối không hiển thị giá tiền**. Phải: Nút Hộp quà ước nguyện `[ 🎁 ]` để lưu vào Wishlist.
*   **E. Dòng Danh Sách Chat (Chat List Row):** Cao `72px`. Trái: Avatar Pet hoặc NPC bo góc 8px. Giữa: Tên thực thể + Tin nhắn cuối (rút gọn 1 dòng). Phải: Thời gian tin nhắn cuối + Chấm tròn hồng Sakura `6px` thầm lặng khi chưa đọc. Khi vuốt trái (Swipe Left) sẽ lộ ra nút Matcha **[Ký ức 📸]** để sang thẳng Album ảnh.

---

## 🏥 7. Hộp Thoại Trượt Từ Đáy (Bottom Sheets Specs)

Bo 2 góc trên cùng `24px` (`Radius.bottomSheetTop`). Nền màu trắng giấy tái chế `#FBFBFA`. Có thanh kéo vuốt dẹt `48x4px` màu xám nhạt ở trung tâm mép trên.

*   **A. Biến Thể Bài Hát / Nhạc (Song BS):** Bìa album vuông `64x64px` bên trái, tên bài hát & nghệ sĩ bên phải. Có thanh tiến trình 15s và đoạn mô tả ngắn dẫn dắt cảm xúc (Emotional Bio) thay vì lyric đầy đủ. Nút chính: **"Nghe Bản Đủ ➔"** (Spotify link). Nút phụ: **"Cất Thư Viện 💖"**.
*   **B. Biến Thể Cuốn Sách (Book BS):** Bìa sách đứng tỷ lệ 3:4 bên trái. Đoạn tóm tắt cảm xúc bên phải. Phía dưới có Quote Block nền kem ấm `#F5F5F0` dùng font Space Mono Italic chứa câu trích dẫn tâm đắc. Nút chính: **"Mua Sách ➔"** (Fahasa/Shopee link). Nút phụ: **"Kệ Sách Gỗ 📚"**.
*   **C. Biến Thể Sản Phẩm (Product BS):** Ảnh sản phẩm bên trái, tên sản phẩm & nhãn phản ứng/nhãn bối cảnh bên phải. Mô tả về giá trị gắn kết cảm xúc mang lại cho thú cưng. **Tuyệt đối không có giá tiền**. Nút chính: **"Ghé Cửa Hàng ➔"** (Affiliate link). Nút phụ: **"Ước Cho Boss 🎁"**.
*   **D. Biến Thể Nhân Vật / Pet (Pet BS):** Minh họa Pet ở giữa (`height: 120px`), tên Pet & nhãn Boss tương ứng. Bên dưới hiển thị bảng lưới 2x2 chỉ số tính cách bằng font `Space Mono 12px`. Lời thoại đặc trưng dạng Quote. Nút chính: **"Đón Boss Về 🏡"** (Màu `#121212`, full-width).

---

## 🕳️ 8. Trạng Thái Rỗng Hướng Dẫn (Cozy Empty States)

Tránh màn hình trống trơn gây hụt hẫng. Tích hợp minh họa tối giản và thông điệp thấu cảm:
*   **Empty Song:** Minh họa đĩa nhạc cổ bám bụi. *"Không gian im ắng quá"*. *"Hãy chọn một giai điệu để đánh thức căn phòng cảm xúc của bạn."* CTA: "Khám phá âm nhạc".
*   **Empty Book:** Minh họa kệ sách trống trải. *"Kệ sách trống trơn"*. *"Bạn chưa có cuốn nhật ký hay tác phẩm chữa lành nào trên kệ sách."* CTA: "Tìm sách đọc".
*   **Empty Character:** Minh họa lồng pet mở sẵn. *"Căn phòng đang vắng vẻ"*. *"Hãy đón một Boss về đồng hành cùng bạn trên hành trình này."* CTA: "Đón Boss về".
*   **Empty Wishlist:** Minh họa hộp quà rỗng mở nắp. *"Boss chưa có điều ước nào"*. *"Hãy thêm các vật phẩm thú vị để dành tặng Boss sau này nhé."* CTA: "Khám phá quà tặng".

---

## 🛡️ 9. Tiêu Chuẩn Tiếp Cận (Accessibility Standards)
*   **Độ tương phản tối thiểu:** Màu sắc text và nút bấm chính luôn đạt độ tương phản tối thiểu **4.5:1** theo chuẩn WCAG AA.
*   **Aria-Label:** Bắt buộc có thuộc tính mô tả tường minh cho các nút chỉ hiển thị biểu tượng (ví dụ: `aria-label="Đóng hộp thoại"` cho nút `✕`).
*   **Trạng thái báo lỗi động:** Các thông báo lỗi dưới ô input phải liên kết qua `aria-describedby` để Screen Reader đọc to ngay khi focus.
