# ĐẶC TẢ CHI TIẾT 05: HỘP KÝ ỨC VIẾT TAY POLAROID & CẢM QUAN NGHỆ THUẬT IYASHIKEI
*(MEMORY VAULT POLAROID GALLERY & JAPANDI IYASHIKEI AESTHETICS)*

> **Mã Đặc Tả:** `SPEC-VAULT-05`  
> **Chủ trì:** Maya (UI/UX Designer), Bella (Frontend Animator), Arthur (Mom Test), Alan (Tech Lead)  
> **Mục tiêu:** Tạo trải nghiệm lưu giữ hoài niệm, tối ưu hóa sự minh bạch, sắp xếp thông minh & Đậm chất thơ Wabi-Sabi Nhật Bản tối cao.

---

## 🧭 1. Triết Lý Thiết Kế: "Góc Nhỏ Tĩnh Lặng Giữa Thành Phố Ồn Ào"

Để Hộp Ký Ức (Memory Vault) đạt đến cảnh giới chữa lành cao nhất, chúng ta tuyệt đối không đi theo lối mòn thiết kế UI phẳng công nghiệp khô cứng. 

Giao diện Hộp Ký Ức của Capcat mang đậm phong cách **Japandi (Wabi-Sabi Nhật Bản kết hợp Scandinavian)** mộc mạc. Mọi tấm ảnh Polaroid đều có hồn, mọi chuyển động đều có nhịp thở chậm rãi, mọi âm thanh đều gợi nhớ những ký ức thủ công của thời đại cũ.

---

## 🎨 2. Maya Tư Vấn: Thiết Kế Layout Nhật Bản Chữa Lành (Iyashikei Gallery Layout)

Maya đề xuất hướng tiếp cận thị giác mang đậm tinh thần **Wabi-Sabi (Vẻ đẹp từ sự không hoàn hảo và tự nhiên)**, thay thế cho lưới ảnh vuông vức cơ học:

### 2.1. Bố Cục Lưới So Le Tự Nhiên (Wabi-Sabi Masonry Grid)
*   **Bố cục lưới:** Lưới so le hai cột (Vertical Masonry Grid) với các chiều cao thẻ không đồng đều. 
*   *Lý do:* Thẻ Polaroid (ảnh) có độ cao lớn hơn, thẻ Sự Kiện Chăm Sóc (chỉ có chữ và icon) có chiều cao ngắn gọn. Thiết kế Masonry tạo cảm giác như một cuốn **Sổ tay Scrapbook cắt dán thủ công bằng tay**, vô cùng mộc mạc và hoài niệm, xóa tan tính công nghiệp của màn hình di động.
*   **Khoảng cách rộng rãi (Breathable Spacing):** `Padding: 16px` ở các cạnh, khoảng cách giữa các thẻ là `12px` để giao diện có không gian "thở" nhẹ nhàng.
*   **Bảng màu trầm lặng (Muted Japandi Palette):**
    *   *Nền thư viện:* Màu beige giấy thô nhám tự nhiên (`#F9F6F0`).
    *   *Nền thẻ ảnh Polaroid:* Trắng ngà ngả sương mù hoài cổ (`#FDFBF7`) với viền mỏng `#F2EFE9`.
    *   *Màu đổ bóng mềm mại (Organic Shadows):* Sử dụng các bóng mờ, siêu loãng (`color: rgba(139, 126, 116, 0.06)`, `blurRadius: 15`, `offset: y=6`) để thẻ như đang đặt nhẹ trên mặt giấy thô.
    *   *Font chữ viết tay:* Font Google Font **`Caveat`** màu xám than củi ấm (`#3C3C3C`) vẽ chì nhẹ nhàng cho chú thích viết tay.

### 2.2. Vi hoạt ảnh Hạt Bụi Nắng Cảm Ứng Con Quay Hồi Chuyển (Gyroscope Floating Dust Motes)
*   Một hệ thống hạt mờ (Particle System) chạy ngầm dưới nền. Các hạt sáng màu vàng ấm li ti (`opacity: 0.15 - 0.25`) trôi nổi chậm rãi.
*   **Tích hợp cảm biến Gyroscope:** Khi người dùng nghiêng nhẹ điện thoại, các hạt bụi nắng sẽ tự động trôi xiên nhẹ theo chiều nghiêng của thiết bị. Bóng đổ của tấm Polaroid cũng hơi dịch chuyển vi mô ngược hướng nghiêng.
*   *Cảm xúc mang lại:* Tạo chiều sâu 3D chân thực như một hộp gỗ ký ức bằng vật lý thực, tái tạo hoàn hảo hình ảnh một chiều nắng muộn rọi qua khe cửa sổ gỗ vào căn phòng tĩnh lặng, mang lại cảm giác bình yên và thư thái tối đa.

### 2.3. Hệ Âm Thanh Thủ Công (Tactile Sounds Bundle)
Khi tương tác trong Hộp Ký Ức, app phát ra các âm thanh nền nhỏ, mộc mạc:
*   **Tiếng Lật Thẻ (`paper_shuffle.mp3`):** Tiếng sột soạt nhẹ của hai tờ giấy cọ vào nhau khi Sen kéo vuốt, lật thẻ Polaroid (được biến thiên cao độ ngẫu nhiên mỗi lần lật để tạo cảm giác tự nhiên).
*   **Tiếng Bút Chì Viết (`pencil_write.mp3`):** Tiếng ngòi bút chì sột soạt viết trên giấy ráp khi Sen nhấp sửa ký ức, tăng cảm giác tương tác vật lý.
*   **Tiếng Dập Dấu Sáp Cổ Điển (`stamp_press.mp3`):** Tiếng đóng dấu sáp chắc nịch, nẩy nhẹ khi thực hiện nghi thức vuốt lên (Golden Memory).

---

## 📋 3. Luồng Thêm Ký Ức Thủ Công Bằng Tay (Warm & Simple Manual Post Flow)

Để đáp ứng nhu cầu ghi chép chủ động và thể hiện **Chủ quyền Dữ liệu Tuyệt đối** của Sen, Hộp Ký Ức cung cấp một nút bấm nổi màu pastel **[Thêm Kỷ Niệm 📋]** ở góc dưới màn hình. 

### 3.1. Thiết kế UX Đơn Giản & Ấm Áp (Cozy Minimalist UX):
*   **Visual Aesthetics:** Khi Sen nhấn nút, Bottom Sheet trượt lên có các góc bo tròn lớn (`borderRadius: 24`), nền giả lập giấy ráp mịn màu beige ấm áp.
*   **Giao diện Tối Giản:** Tối giản tối đa các nút cấu hình phức tạp hay thuật ngữ cơ sở dữ liệu. Sử dụng các Icon vẽ tay cỡ lớn dễ thương, trực quan và nút bấm pastel ấm cúng.
*   **Tự Do Nội Dung Tuyệt Đối (No Pet Classification Constraints):** Khác với bộ quét tự động (Swipe Game) chỉ lọc ảnh thú cưng, **quy trình nạp thủ công chấp nhận bất kỳ hình ảnh nào Sen muốn lưu giữ** làm kỷ niệm đồng hành trên cuộc đời (Ví dụ: ảnh Sen đi du lịch, ảnh gia đình, bạn bè, món ăn ngon, hay một góc phố chiều mưa). Hệ thống không áp đặt bộ lọc chó mèo cho luồng nạp thủ công.

### 3.2. Ba chế độ nạp phối trộn đa dạng:
```
                  ┌────────────────────────────────────────┐
                  │ 📋 Tạo Kỷ Niệm Mới Cho Bánh Mỳ         │
                  │                                        │
                  │ [📸 Chọn hình ảnh (Bất kỳ ảnh nào)]    │
                  │ (Cho phép crop, căn chỉnh xoay nhẹ)     │
                  │                                        │
                  │ [🛁 Chọn sự kiện chăm sóc (Optional)]   │
                  │ (Tắm, tiêm ngừa, sổ giun...)            │
                  │                                        │
                  │ ✍️ Dòng tâm sự viết tay:                │
                  │ [Hôm nay Boss ngoan ngoan cực kỳ... ]  │
                  │                                        │
                  │           [ Ghi lại nha 💛 ]           │
                  └────────────────────────────────────────┘
```

*   **Phương án 1: Chỉ chọn Hình ảnh (Photo Only):**
    *   *Visual Style:* Thẻ hiển thị dưới dạng **Polaroid Card truyền thống**. Bức ảnh chiếm 80% diện tích, 20% phía dưới là dòng chú thích viết tay (nếu Sen ghi chú) hoặc tự động sinh thơ lãng đãng (auto_caption).
*   **Phương án 2: Chỉ chọn Sự kiện (Event Only):**
    *   *Visual Style:* Không có khung ảnh. Thẻ hiển thị dưới dạng **Event Card đặc trưng**. Màu nền pastel nhẹ nhàng phân theo nhóm sự kiện (Lavender cho Làm đẹp, Mint cho Sức khỏe, Peach cho Cuộc sống, Gold cho Cột mốc) với một **Icon lớn nổi bật** ở bên trái (Ví dụ: `🛁`, `💉`, `🏥`), tên sự kiện to đậm và ghi chú viết tay của Sen ở bên phải kèm bóng thoại AI đùa cợt dễ thương.
*   **Phương án 3: Chọn cả Hai (Photo + Event Hybrid Card):**
    *   *Visual Style:* Thẻ hiển thị dưới dạng **Polaroid Hybrid Card đặc biệt cực kỳ ấn tượng**. Bức ảnh vẫn là tâm điểm của thẻ Polaroid, nhưng có thêm một chiếc **Huy hiệu Sự kiện (Care Event Badge)** nhỏ xinh đè nhẹ lên góc trên cùng bên trái của ảnh Polaroid (Ví dụ một tag giấy nhỏ nhô ra có icon `💉` và chữ `Tiêm ngừa`).

---

## 🔄 4. Thuật Toán Sắp Xếp & Lọc Trí Tuệ (Intellectual Sorting & Filters)

Để Sen dễ dàng lục lại những hoài niệm cũ theo ý muốn, Hộp Ký Ức cung cấp bộ công cụ **Sắp xếp Đa chiều (Dual Sorting)** và **Bộ lọc nhanh (Quick Filter Tab)** ở đầu màn hình:

### 4.1. Bộ đôi Tiêu chí Sắp xếp (Dual Sorting System)
Sen có thể chuyển đổi 1 chạm giữa hai chế độ sắp xếp:

1.  **Chế độ A: Sắp xếp theo Ngày Chụp (EXIF Photo Taken Date - Mặc định):**
    *   *Nguyên lý:* Hệ thống trích xuất siêu dữ liệu EXIF chụp thực tế của bức ảnh (hoặc ngày diễn ra sự kiện do Sen chọn) để sắp xếp dòng thời gian ngược.
    *   *Giá trị chữa lành:* Phản ánh chính xác lịch sử sinh học và chặng đường lớn lên thực tế của Boss ảo.
    *   *Tích hợp Lọc Theo Mùa (Seasonal Solstice):* EXIF metadata được dùng để trích xuất tháng chụp thực tế và nhóm vào 4 mùa của năm:
        *   `SPRING` (Mùa Xuân): Tháng 2 - Tháng 4.
        *   `SUMMER` (Mùa Hè): Tháng 5 - Tháng 7.
        *   `AUTUMN` (Mùa Mưa/Thu): Tháng 8 - Tháng 10.
        *   `WINTER` (Mùa Đông): Tháng 11 - Tháng 1.
2.  **Chế độ B: Sắp xếp theo Ngày Tải Lên / Ngày Thêm Vào (Upload / Added Date):**
    *   *Nguyên lý:* Sắp xếp theo timestamp thực tế khi ảnh được Sen vuốt đồng ý (Right Swipe) hoặc ngày Sen tự bấm log sự kiện thủ công.
    *   *Giá trị sử dụng:* Giúp Sen tìm kiếm cực nhanh những bức ảnh kỷ niệm mình vừa mới chơi vuốt thẻ hoặc vừa ghi chép chiều hôm nay mà không bị chìm sâu vào quá khứ.

### 4.2. Bộ lọc nhanh theo Tag Cá Thể và Sự Kiện (Multi-Pet & Event Filtering)
*   **Filter 1 (Tag cá thể pet - SPEC-08):** Hiển thị các tab tròn thô nhẹ: `[ Tất cả 🐾 ]`, `[ 🐱 Bánh Mỳ ]`, `[ 🐱 Bánh Cam ]`. Nhấp vào đâu chỉ hiện ký ức của Boss đó.
*   **Filter 2 (Loại ký ức):** Lọc nhanh `[ 📸 Ảnh đẹp ]` hoặc `[ 📋 Chăm sóc ]`.
*   **Filter 3 (Filter giao mùa cảm xúc - MỚI):** Tab tròn thô pastel `[ 📅 Mùa cũ ]`. Nhấp vào sẽ lập tức lọc ra các kỷ niệm đã lưu được chụp vào đúng mùa hiện tại ở các năm trước để Sen ngắm hoài niệm.

---

## ✉️ 5. Phân Hệ Recall Flashback — Trải Nghiệm Hoài Niệm Chữa Lành

Để thể hiện những ký ức đang có trong Hộp Ký Ức ra bên ngoài một cách đầy cảm xúc ("sexy") nhưng an toàn và tối ưu chi phí tuyệt đối cho MVP, hệ thống được phân bổ như sau:

> 🔒 **Ràng buộc Dữ liệu Recall (Recall Database Rule):** Toàn bộ các phân hệ ôn lại kỷ niệm (Recap tháng/mùa, Hộp Thư Cổ Kính MVP, Bưu Thiếp NTH) **chỉ được phép trích xuất các bức ảnh kỷ niệm ĐÃ ĐƯỢC LƯU TRỮ thành công trong Hộp Ký Ức** (SQLite `moments` hoặc CSDL đã xác nhận). Tuyệt đối KHÔNG tự ý lấy các hình ảnh thô chưa phân loại từ thư viện ảnh điện thoại của Sen để tránh tạo cảm giác bị phần mềm theo dõi ngầm.

### 5.1. LÕI MVP: Hộp Thư Cổ Kính (Retro Letter Popup)
Tránh các hoạt ảnh 3D Origami/Gấp thư phức tạp dễ gây cảm giác thô cứng, app thiết kế một giao diện đọc thư phẳng (Retro Letter Sheet) cực kỳ nghệ thuật dưới dạng Popup:

*   **Tương tác mở phong thư (Scale Dialog):** Khi chạm phong thư trượt ra trên Home, app gọi `showDialog` mở một Popup toàn màn hình mờ tối (Dim overlay 70%). Một trang giấy thư ráp hoài cổ ngả vàng (`#FDFBF7`) trượt nhẹ và phóng to êm ái (Scale animation).
*   **Bố cục Trang thư:**
    *   *Tiêu đề thư:* Dòng mực mờ *"Một bức thư cũ gửi từ mùa đông năm ngoái..."*.
    *   *Nội dung lá thư:* Lời tâm sự tay đầy tri kỷ từ Boss viết bằng font `Caveat` đậm nét mực chì ấm (`#3C3C3C`). Văn phong biến thiên 100% theo tính cách Boss (Chảnh chọe, nũng nịu...).
    *   *Kỷ niệm đính kèm (Polaroid Thumbnail):* Chân trang thư hiển thị một **ảnh Polaroid nhỏ xinh** - chính là bức ảnh kỷ niệm đã lưu trong SQLite, viền trắng ngà mỏng, xoay nghiêng nhẹ 2 độ tạo cảm giác đặt thủ công.
    *   *Nút hành động (CTA Stamp):* Một nút đóng dấu sáp đỏ tròn retro nổi bật: **[🕯️ Ủ ấm kỷ niệm này]**.
*   **Cozy Chat Hook (Inject Context):** Khi chạm nút "Ủ ấm", app mở Cozy Chat và inject context âm thầm:
    `<system_trigger_flashback memory_id="moment_123" caption="..." />`
    Gemini Flash nhận context và tự động mở đầu bằng cuộc hội thoại tri kỷ liên quan mà không tốn chi phí hạ tầng.

### 5.2. [NICE-TO-HAVE] Bưu Thiếp Hoài Niệm (Wabi-Sabi Postcard Flip Y-Axis)
*Đây là phân hệ nâng cấp trực quan cho các giai đoạn sau MVP (Nice-To-Have):*
*   **Postcard Front Side:** Tấm bưu thiếp nghệ thuật ghép collage (1 ảnh lớn làm nền + 1-2 ảnh nhỏ dán đè chéo).
*   **Y-Axis Flip Animation:** Tấm bưu thiếp lật xoay 180 độ theo trục dọc Y-axis sống động (sử dụng Matrix4 phối cảnh 3D) để hiển thị mặt sau chứa lá thư tay, tem thư chân mèo vẽ tay, dấu bưu điện và nút đóng dấu sáp đỏ.

---

## 🔒 6. Quyền Tối Cao & Bảng Minh Bạch Dữ Liệu Tối Cao (Supreme Data Sovereignty Panel)

### 6.1. Nút Trưng Bày [Minh Bạch Dữ Liệu 🔒]
*   Ở góc trên cùng của Hộp Ký Ức, có một biểu tượng khóa đồng cổ kính thanh nhã kèm chữ nhỏ **"Minh Bạch"**.
*   Khi Sen chạm vào, một **Tấm Sớ Giấy Da (Parchment Paper Drawer)** sẽ nhẹ nhàng trượt từ bên phải ra, trình bày thông tin chi tiết bằng sơ đồ vẽ tay dễ thương:
    *   **Cột Bên Trái:** Chú mèo Chibi ôm chiếc rương gỗ dán nhãn: *"NHỮNG THỨ TRẪM GIỮ TRONG MÁY"* (SQLite cục bộ `local_photo_intelligence_cache`, ảnh dìm gốc trong máy, lịch sử vuốt cục bộ).
    *   **Cột Bên Phải:** Chú mèo Chibi dang tay che bầu trời mây dán nhãn: *"NHỮNG THỨ TRẪM ĐỒNG BỘ LÊN MÂY"* (Chỉ lưu đường dẫn liên kết được mã hóa đầu-cuối để đồng bộ thiết bị, **tuyệt đối không tải ảnh thô lên bất kỳ máy chủ quảng cáo nào**, không theo dõi hành vi ngoài Capcat).

### 6.2. Bộ Đôi Nút Quyền Lực Tối Cao (Sovereignty Action Buttons)
Nằm ở cuối Tấm Sớ Giấy Da là bộ đôi nút bấm đặc quyền giúp người dùng làm chủ hoàn toàn vận mệnh dữ liệu của mình:

1.  **📥 Nút [Tải Bản Sao Lưu Kỷ Niệm .zip]:**
    *   Hệ thống tự động nén tất cả hình ảnh Polaroid gốc đã lưu trong hộp, các bình luận viết tay tương ứng và chỉ số Intimacy vào một tệp tin nén **`.zip`** duy nhất.
    *   Trong tệp zip, bên cạnh ảnh gốc, hệ thống tự sinh một tệp **`index.html`** được thiết kế Japandi siêu đẹp. Khi mở tệp này trên máy tính, người dùng có thể xem lại toàn bộ album kỷ niệm viết tay offline của pet giống hệt giao diện trong app.
2.  **🗑️ Nút [Xóa Sạch Dữ Liệu & Quên Đi Vĩnh Viễn]:**
    *   Khi bấm vào, Boss ảo xuất hiện với hoạt ảnh chibi ôm chầm lấy chân Sen rơm rớm nước mắt: *"Sen thực sự muốn xóa bỏ tất cả kỷ niệm ngọt ngào giữa hai chúng ta để bắt đầu lại sao?"*.
    *   Nếu Sen gõ đúng chữ **"QUÊN ĐI"** để xác nhận -> Hệ thống thực hiện lệnh thanh trừng triệt để: Xóa toàn bộ cơ sở dữ liệu cục bộ, dọn sạch bộ nhớ đệm, hủy hàng đợi tải ngầm, gọi API đồng bộ để xóa vĩnh viễn dữ liệu trên máy chủ. Màn hình tan rã thành các hạt cát bụi lơ lửng và bay biến mất, đưa app về trạng thái sơ khai hoàn toàn mới.

---

## ✍️ 7. Code Mẫu Quay Lật Thẻ Polaroid 3D Trục Y (by Alan)

Alan sử dụng Custom AnimationController kết hợp widget `Transform` để thực hiện phép quay 3D trục Y không gián đoạn:

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class PolaroidFlipCard extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;

  const PolaroidFlipCard({Key? key, required this.frontWidget, required this.backWidget}) : super(key: key);

  @override
  _PolaroidFlipCardState createState() => _PolaroidFlipCardState();
}

class _PolaroidFlipCardState extends State<PolaroidFlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: pi).animate(_controller);
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value;
          final transformWidget = angle < pi / 2
              ? widget.frontWidget
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: widget.backWidget,
                );
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Hiệu ứng phối cảnh 3D
              ..rotateY(angle),
            child: transformWidget,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 🔒 8. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1.  **AC-1 (Wabi-Sabi Spacing):** Thư viện hiển thị dưới dạng lưới Masonry so le 2 cột mượt mà, chiều cao thẻ ảnh Polaroid và thẻ sự kiện co giãn tự nhiên theo nội dung.
2.  **AC-2 (Manual Add Bottom Sheet):** Nhấp FAB "Thêm Kỷ Niệm" trượt Bottom Sheet lên -> Cho phép chọn ảnh riêng lẻ (Polaroid), chọn sự kiện riêng lẻ (Event Card), hoặc chọn cả hai (Polaroid Hybrid Card với Care Event Badge ở góc).
3.  **AC-3 (Dual Sorting Toggle):** Nhấn nút chuyển đổi Sắp xếp -> Cập nhật vị trí thẻ bài ngay lập tức: sắp xếp theo Ngày Chụp (EXIF) hoặc Ngày Tải Lên (Added date) chuẩn xác.
4.  **AC-4 (Tactile Sound):** Phát đúng âm thanh `pencil_write.mp3` sột soạt khi nhấn sửa ký ức và `paper_shuffle.mp3` khi kéo lật thẻ.
5.  **AC-5 (Data Deletion):** Khi người dùng xác nhận **[Quên đi]** -> Dữ liệu biến mất lập tức khỏi SQLite và đồng bộ lên server. Thẻ Polaroid co nhỏ mờ dần biến mất đẹp mắt.
6.  **AC-6 (MVP Letter Popup Render):** Kích hoạt lá thư MVP -> Hiển thị đúng giao diện popup đọc thư dạng sớ giấy ngả vàng, font Caveat hiển thị sắc nét chân thực, Polaroid thumbnail đính kèm ngay chân trang thư và click "Ủ ấm" nhảy Cozy Chat mượt mà.
7.  **AC-7 (NTH Postcard Flip - Nice-to-Have):** Khi kích hoạt bưu thiếp hoài niệm nâng cao -> Lật thẻ 3D trục Y đạt 60 FPS, hiển thị tem thư và postmark mờ hoài cổ sắc nét.
