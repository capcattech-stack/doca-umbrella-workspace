# ĐẶC TẢ CHI TIẾT 01: ĐỘNG CƠ VUỐT THẺ BÀI TINDER DOPAMINE
*(CARD SWIPER STACK & GESTURE PHYSICS ENGINE)*

> **Mã Đặc Tả:** `SPEC-VAULT-01`  
> **Chủ trì:** Sophia (CPO / PM), Bella (Lead UI/UX & Animator), Alan (Tech Lead)  
> **Mục tiêu:** Tạo trải nghiệm nạp ảnh gây nghiện dưới 5 giây (Gamified Dopamine)  
> **Tính năng thăng hoa:** Vuốt Lên (Swipe Up - Golden Memory)

---

## 🧭 1. Triết Lý Thiết Kế: "Nạp Kỷ Ức Bằng Cảm Xúc Phối Trộn"

Để phá vỡ sự lười biếng của người nuôi thú cưng trong việc upload ảnh, chúng ta hoàn toàn cắt bỏ luồng chọn ảnh truyền thống (Photo Picker) khô khan và tẻ nhạt. 

Ứng dụng tái tạo lại trải nghiệm **vuốt thẻ bài Tinder (Card Swiper)** đầy gây nghiện. Người dùng có thể vuốt hàng chục bức ảnh dìm hàng của Boss trong nháy mắt. Đặc biệt, bên cạnh hai cử chỉ vuốt trái (Bỏ qua) và vuốt phải (Lưu thông thường), chúng ta tích hợp thêm cử chỉ **Vuốt Lên (Swipe Up - Kỷ Niệm Vàng)** để tạo nên điểm chạm thăng hoa cảm xúc sâu sắc giữa người và thú cưng ảo.

---

## 🛠️ 2. Thiết Kế Vật Lý Vuốt Thẻ Bài 3 Hướng (3-Way Swipe Stack Physics)

Chúng ta thiết kế Custom Card Swiper Stack sử dụng các API cử chỉ và chuyển đổi ma sát tích hợp của Flutter để xử lý mượt mà chuyển động kéo vuốt 3 hướng:

```
                            [ VUỐT LÊN: KỶ NIỆM VÀNG ]
                                   ▲ (Swipe Up)
                                   │
                     👈 Vuốt Trái  │  Vuốt Phải 👉
                  (Bỏ qua - Private)│(Lưu - Feed Boss)
                                   │
                                 /■■■■■■■\
                                /         \
                               /  [ ẢNH ]  \
                              /             \
```

### 2.1. Các Thông Số Vật Lý Cốt Lõi (Core Physics Parameters)
*   **Friction Coefficient (Hệ số ma sát kéo):** `0.8` (Tạo cảm giác thẻ bài bám sát đầu ngón tay kéo, không bị trượt quá nhanh).
*   **Maximum Rotation Angle (Góc xoay tối đa khi vuốt ngang):** `15 độ` (Thẻ bài tự động nghiêng góc tối đa 15 độ tùy thuộc vào khoảng cách kéo ngón tay sang trái hoặc phải).
*   **Swipe Up Behavior (Cử chỉ vuốt lên thẳng đứng):** Khi vuốt lên, góc xoay nghiêng bằng `0 độ` (thẻ giữ thẳng) nhưng tỷ lệ thu nhỏ (`scale`) tăng nhẹ để tạo cảm giác thẻ đang được kéo vút bay lên bầu trời.
*   **Swipe Threshold (Ngưỡng kích hoạt):** `35%` chiều rộng hoặc chiều cao màn hình. Kéo vượt quá 35% -> thẻ bay đi. Thả tay trước 35% -> thẻ tự động đàn hồi về tâm bằng **Spring Animation (Độ nẩy lò xo)**.

---

## 🎭 3. Luồng Tương Tác 3 Hướng Cử Chỉ (3-Way Swipe Gestures Flow)

### 3.1. 👉 VUỐT PHẢI (FEED BOSS / ĐỒNG Ý LƯU)
*   **Ý nghĩa:** Đồng ý tải ảnh lên máy chủ và công khai vào nhật ký *Moments Feed*.
*   **Hiệu ứng thị giác:** Nhãn mác viền hồng sẫm chữ **"MĂM MĂM"** mờ dần hiện lên.
*   **Phản hồi xúc giác (Haptic):** Rung nhẹ `HapticFeedback.lightImpact()` khi thẻ bay đi.
*   **Hành động hệ thống:**
    1. Cộng **+5 Điểm Thân Mật (Intimacy Points)** cho Pet.
    2. Đưa ảnh vào hàng đợi tải lên ngầm (`Background Upload Queue`).
    3. Boss ảo nháy mắt và hiện bóng thoại khịa hài hước chuẩn cá tính.

### 3.2. 👈 VUỐT TRÁI (KEEP PRIVATE / BỎ QUA)
*   **Ý nghĩa:** Bỏ qua bức ảnh, giữ nguyên tính riêng tư tuyệt đối cục bộ trên máy.
*   **Hiệu ứng thị giác:** Nhãn mác viền xám chữ **"BỎ QUA"** hiện lên.
*   **Phản hồi xúc giác (Haptic):** Rung nhẹ biên độ nhỏ hơn.
*   **Hành động hệ thống:**
    1. Thẻ bài bay ra ngoài và không có bất kỳ dữ liệu nào được tải lên máy chủ.
    2. Boss ảo xị mặt nhẹ: *"Món này khó nuốt quá Sen ơi!"*.

### 3.3. 👆 VUỐT LÊN: NGHI THỨC KỶ NIỆM VÀNG (HEART, COMMENT & WAX SEAL STAMPING RITUAL)
*   **Ý nghĩa:** Đánh dấu bức ảnh dìm thành một "Kỷ Niệm Vàng" thiêng liêng nhất, tích hợp đồng thời ba tác vụ cảm xúc: **Thả tim đỏ, Ghi bình luận viết tay, và Đóng dấu chứng nhận kỷ niệm**.
*   **Hạn mức (Cap):** Giới hạn nghiêm ngặt **tối đa 1 lần/tuần** để bảo toàn tính quý hiếm của cảm xúc.
*   **Kịch bản Vi hoạt ảnh Chữa lành (Choreographed Emotional Ritual):**
    1.  **Bước 1: Kéo & Khựng (The Pause):** Khi Sen vuốt ngón tay lên trên qua ngưỡng 35%, thẻ Polaroid không biến mất ngay mà bay chậm lại rồi **khựng lại nhẹ nhàng giữa màn hình**, xung quanh mờ tối đi (Dim overlay 60%), làm nổi bật tấm ảnh như đang lơ lửng trong nắng chiều.
    2.  **Bước 2: Bùng nở & Thả Tim (Golden Particles & Heart Glow):** Kích hoạt xung rung ba nhịp liên tiếp (`HapticFeedback.mediumImpact()`) mô phỏng nhịp tim đập. Đồng thời, một loạt **pháo hoa hạt vàng (Golden Particles Burst)** bung tỏa rực rỡ lấp lánh xung quanh thẻ bài, và một biểu tượng **Trái tim vàng rực rỡ** hiện lên chính giữa ảnh, phát ra ánh sáng lung linh ấm áp.
    3.  **Bước 3: Ô Bình Luận Viết Tay & Gợi ý AI (Handwritten Comment & AI Cozy Whispers):**
        *   Một ô nhập liệu giả vân giấy thô mịn màng từ từ trượt lên từ phía dưới. 
        *   Sen có thể tự gõ dòng tâm sự viết tay ngắn cho tấm ảnh, HOẶC lướt chọn nhanh một trong **3 gợi ý bình luận chữa lành của Pet** được sinh ra bởi AI dựa trên bối cảnh ảnh (ví dụ: *"Ngày mưa này ấm áp lắm nhờ có Sen..."*, *"Trẫm thích cách Sen chụp lén trẫm ngủ thế này"*).
    4.  **Bước 4: Đóng Dấu Kỷ Niệm (Red Cat-Paw Wax Seal Stamp):**
        *   Sau khi viết/chọn bình luận, Sen nhấn nút **[Ghi dấu Kỷ Niệm]**. 
        *   Một chiếc con dấu sáp cổ điển dập mạnh xuống góc thẻ Polaroid, để lại một **Dấu chân mèo sáp đỏ (Red Cat-Paw Wax Seal)** cực kỳ retro và dễ thương.
        *   Phát ra âm thanh dập dấu ấm, chắc nịch (`stamp_press.mp3`) kết hợp rung haptic giật mạnh nhẹ (`HapticFeedback.heavyImpact()`).
*   **Hành động hệ thống:**
    1.  Cộng đột phá **+15 Điểm Thân Mật (Intimacy Points)** và **+1 Trái Tim Vàng (Golden Heart)** vào siêu dữ liệu của ký ức.
    2.  Đưa ảnh vào hàng đợi tải lên ngầm và **tự động ghim lên đầu dòng thời gian cá nhân của Pet (Pinned Post)** trong mục Moments Feed.
    3.  Thẻ Polaroid vút bay lên góc trên màn hình và biến mất chậm rãi. Boss ảo hiện bóng thoại tâm sự tri kỷ sâu sắc (Ví dụ: *"Cảm ơn Sen đã ghi dấu ngày hôm ấy, ngày trẫm hạnh phúc nhất bên Sen..."*).


---

## 🛠️ 4. Thư Viện Flutter Khuyên Dùng & Code Mẫu (by Alan)

Alan cập nhật lõi package `flutter_card_swiper` để hỗ trợ cử chỉ vuốt lên (Swipe Up):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/services.dart';

class CozyCardSwiper extends StatelessWidget {
  final List<String> petPhotos;
  final CardSwiperController controller = CardSwiperController();

  CozyCardSwiper({Key? key, required this.petPhotos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardSwiper(
      controller: controller,
      cardsCount: petPhotos.length,
      allowedSwipeDirections: const AllowedSwipeDirections.only(
        left: true,
        right: true,
        up: true, // Cho phép vuốt lên
      ),
      onSwipe: (previousIndex, currentIndex, direction) {
        if (direction == CardSwiperDirection.right) {
          HapticFeedback.lightImpact();
          _handleFeedBoss(petPhotos[previousIndex]);
        } else if (direction == CardSwiperDirection.left) {
          HapticFeedback.selectionClick();
          _handlePassPhoto(petPhotos[previousIndex]);
        } else if (direction == CardSwiperDirection.top) {
          // Vuốt lên: Kỷ Niệm Vàng
          HapticFeedback.mediumImpact();
          _handleGoldenMemory(petPhotos[previousIndex]);
        }
        return true;
      },
    );
  }

  void _handleFeedBoss(String path) {
    // Logic Background Upload Queue (SPEC-VAULT-04)
  }

  void _handlePassPhoto(String path) {
    // Giữ ảnh ở local
  }

  void _handleGoldenMemory(String path) {
    // Logic Pinned Post & Golden Particles & +15 Intimacy
  }
}
```

---

## 🔒 5. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1.  **AC-1 (Swipe Up Physics):** Kéo thẻ bài thẳng đứng hướng lên trên -> Thẻ bài bay thẳng đứng mượt mà ở 60 FPS, kích hoạt đúng hoạt ảnh hạt pháo hoa vàng lấp lánh khi bay qua ngưỡng 35%.
2.  **AC-2 (Swipe Up Limit):** Nếu người dùng đã dùng hết 1 lượt Kỷ Niệm Vàng trong tuần, khi cố tình vuốt lên lần thứ 2 -> Hệ thống tự động đẩy nhẹ thẻ bài lò xo hồi về vị trí cũ và hiển thị thông báo nhẹ nhàng của Boss: *"Kỷ niệm vàng tuần này trẫm đã ghi dấu rồi Sen ơi, hãy để dành bức ảnh tuyệt vời này cho tuần sau nhé!"*.
