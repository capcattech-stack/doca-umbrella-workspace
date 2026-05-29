# ĐẶC TẢ CHI TIẾT 05: HỘP KÝ ỨC VIẾT TAY POLAROID & CẢM QUAN NGHỆ THUẬT IYASHIKEI
*(MEMORY VAULT POLAROID GALLERY & JAPANDI IYASHIKEI AESTHETICS)*

> **Mã Đặc Tả:** `SPEC-VAULT-05`  
> **Chủ trì:** Bella (Lead UI/UX & Animator), Arthur (Mom Test / Đạo đức AI), Alan (Tech Lead)  
> **Mục tiêu:** Tạo trải nghiệm lưu giữ hoài niệm & Đậm chất thơ Wabi-Sabi Nhật Bản tối cao

---

## 🧭 1. Triết Lý Thiết Kế: "Góc Nhỏ Tĩnh Lặng Giữa Thành Phố Ồn Ào"

Để Hộp Ký Ức (Memory Vault) đạt đến cảnh giới chữa lành cao nhất, chúng ta tuyệt đối không đi theo lối mòn thiết kế UI phẳng công nghiệp khô cứng. 

Giao diện Hộp Ký Ức của Capcat mang đậm phong cách **Japandi (Wabi-Sabi Nhật Bản kết hợp Scandinavian)** mộc mạc. Mọi tấm ảnh Polaroid đều có hồn, mọi chuyển động đều có nhịp thở chậm rãi, mọi âm thanh đều gợi nhớ những ký ức thủ công của thời đại cũ.

Đồng thời, để triệt tiêu hoàn toàn cảm giác đề phòng bị AI theo dõi của người trẻ đô thị, chúng ta trao cho Sen **Quyền tối cao của chủ nuôi (User Data Sovereignty)**. Sen có toàn quyền chỉnh sửa thông tin hoặc xóa bỏ vĩnh viễn bất kỳ ký ức nào họ cảm thấy quá riêng tư. Việc tự do kiểm soát này nghịch lý thay lại khiến người dùng tin tưởng và yêu quý app hơn gấp nhiều lần.

---

## 🎨 2. Cảm Quan Nghệ Thuật Chữa Lành Chi Tiết (Aesthetic Specifications)

Bella thiết lập các token thiết kế và tài nguyên nghệ thuật độc quyền dành riêng cho Hộp Ký Ức:

```
+--------------------------------------------------------------+
│  [🔒 Minh Bạch]        HỘP KÝ ỨC CỦA BÁNH MỲ       [📥 Sao Lưu]│
│                                                              │
│       ✨ (Các hạt bụi nắng trôi nổi xiên theo góc nghiêng)   │
│                                                              │
│      +-------------------+       +-------------------+       │
│      |   📷 (ẢNH GỐC)    |       |   📷 (ẢNH GỐC)    |       │
│      |   🔴 (Dấu Wax Sáp)|       |                   |       │
│      | 🌸 Trẫm nhớ Sen  |       | 🌸 Trẫm nhớ Sen  |       │
│      |    thích uống trà  |       |    thích nghe Lofi|       │
│      |    nhài ấm áp...  |       |    khi trời mưa...|       │
│      +-------------------+       +-------------------+       │
│                                                              │
│   ✏️ [Chế Meme 0đ]   🗑️ [Xóa]   ✏️ [Chế Meme 0đ]   🗑️ [Xóa]  │
+--------------------------------------------------------------+
```

### 2.1. Bảng Màu Trầm Lặng (Muted Wabi-Sabi Palette)
*   **Màu nền chủ đạo:** Màu beige giấy thô tự nhiên (`#F9F6F0`), tạo cảm giác ấm áp và dịu mắt khi xem trong bóng tối.
*   **Màu thẻ Polaroid:** Trắng ngà ngả sương mù hoài cổ (`#FDFBF7`) với hiệu ứng nhiễu nhám vân giấy gai dầu sợi mộc.
*   **Màu đổ bóng mềm mại (Organic Shadows):** Sử dụng các bóng mờ, siêu loãng (`color: rgba(139, 126, 116, 0.08)`, `blurRadius: 20`) thay vì đổ bóng xám thô đục của UI phẳng thông thường.
*   **Font chữ viết tay:** Font chữ viết tay tiếng Việt có dấu mềm mại, thanh thoát (Google Font **`Caveat`** hoặc **`Quicksand`** có trọng lượng nhẹ). Màu chữ là xám than củi ấm (`#3C3C3C`) tạo cảm giác vẽ chì nhẹ nhàng thay vì màu đen đặc `#000000` công nghiệp.

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

## 🔒 3. Quyền Tối Cao & Bảng Minh Bạch Dữ Liệu Tối Cao (Supreme Data Sovereignty & Transparency Panel)

Để tạo lập niềm tin tuyệt đối nơi người nuôi thú cưng nhạy cảm với bảo mật, chúng ta thiết kế một giao diện **Minh Bạch Dữ Liệu & Quyền Tối Cao Của Chủ Nuôi (Data Sovereignty Drawer)**:

### 3.1. Nút Trưng Bày [Minh Bạch Dữ Liệu 🔒]
*   Ở góc trên cùng của Hộp Ký Ức, có một biểu tượng khóa đồng cổ kính thanh nhã kèm chữ nhỏ **"Minh Bạch"**.
*   Khi Sen chạm vào, một **Tấm Sớ Giấy Da (Parchment Paper Drawer)** sẽ nhẹ nhàng trượt từ bên phải ra, trình bày thông tin chi tiết bằng sơ đồ vẽ tay dễ thương:
    *   **Cột Bên Trái:** Chú mèo Chibi ôm chiếc rương gỗ dán nhãn: *"NHỮNG THỨ TRẪM GIỮ TRONG MÁY"* (SQLite cục bộ `processed_photos_cache`, ảnh dìm gốc trong máy, lịch sử vuốt cục bộ).
    *   **Cột Bên Phải:** Chú mèo Chibi dang tay che bầu trời mây dán nhãn: *"NHỮNG THỨ TRẪM ĐỒNG BỘ LÊN MÂY"* (Chỉ lưu đường dẫn liên kết được mã hóa đầu-cuối để đồng bộ thiết bị, **tuyệt đối không tải ảnh thô lên bất kỳ máy chủ quảng cáo nào**, không theo dõi hành vi ngoài Capcat).

### 3.2. Bộ Đôi Nút Quyền Lực Tối Cao (Sovereignty Action Buttons)
Nằm ở cuối Tấm Sớ Giấy Da là bộ đôi nút bấm đặc quyền giúp người dùng làm chủ hoàn toàn vận mệnh dữ liệu của mình:

1.  **📥 Nút [Tải Bản Sao Lưu Kỷ Niệm .zip]:**
    *   Hệ thống tự động nén tất cả hình ảnh Polaroid gốc đã lưu trong hộp, các bình luận viết tay tương ứng và chỉ số Intimacy vào một tệp tin nén **`.zip`** duy nhất.
    *   Trong tệp zip, bên cạnh ảnh gốc, hệ thống tự sinh một tệp **`index.html`** được thiết kế Japandi siêu đẹp. Khi mở tệp này trên máy tính, người dùng có thể xem lại toàn bộ album kỷ niệm viết tay offline của pet giống hệt giao diện trong app.
    *   *Giá trị mang lại:* Người dùng cảm thấy dữ liệu là của họ vĩnh viễn, không bị app "bắt cóc con tin" ép dùng app trọn đời.
2.  **🗑️ Nút [Xóa Sạch Dữ Liệu & Quên Đi Vĩnh Viễn]:**
    *   Khi bấm vào, Boss ảo xuất hiện với hoạt ảnh chibi ôm chầm lấy chân Sen rơm rớm nước mắt: *"Sen thực sự muốn xóa bỏ tất cả kỷ niệm ngọt ngào giữa hai chúng ta để bắt đầu lại sao?"*.
    *   Nếu Sen gõ đúng chữ **"QUÊN ĐI"** để xác nhận -> Hệ thống thực hiện lệnh thanh trừng triệt để: Xóa toàn bộ cơ sở dữ liệu cục bộ, dọn sạch bộ nhớ đệm, hủy hàng đợi tải ngầm, gọi API đồng bộ để xóa vĩnh viễn dữ liệu trên máy chủ.
    *   Màn hình tan rã thành các hạt cát bụi lơ lửng và bay biến mất, đưa app về trạng thái sơ khai hoàn toàn mới.


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

## 🔒 5. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1.  **AC-1 (Iyashikei Look):** Nền Hộp Ký Ức hiển thị đúng màu beige tự nhiên nhám giấy, các hạt bụi nắng lơ lửng chuyển động chậm không gây lag (giữ vững 60 FPS).
2.  **AC-2 (Tactile Sound):** Phát đúng âm thanh `pencil_write.mp3` sột soạt khi nhấn sửa ký ức và `paper_shuffle.mp3` khi kéo lật thẻ.
3.  **AC-3 (Data Deletion):** Khi người dùng xác nhận **[Quên đi]** -> Dữ liệu biến mất lập tức khỏi SQLite và đồng bộ lên server. Thẻ Polaroid co nhỏ mờ dần biến mất đẹp mắt.
