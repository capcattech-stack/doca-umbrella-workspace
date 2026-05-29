# ĐẶC TẢ CHI TIẾT 09: ĐỘNG CƠ TRÚ ẨN CHỦ ĐỘNG & NHẬT KÝ NGOẠI TUYẾN ĐA HƯỚNG
*(OFFLINE INTENTIONAL SANCTUARY & MULTI-DIMENSIONAL MIXER ENGINE)*

> **Mã Đặc Tả:** `SPEC-COZY-09`  
> **Chủ trì:** Sophia (CPO / PM), Arthur (Hành vi & Trải nghiệm), Alan (Tech Lead), Bella (Aesthetic Design)  
> **Ý tưởng thiết kế:** Góc trú ẩn bình yên (The Quiet Sanctuary)

---

## 🧭 1. Triết Lý Thiết Kế: "Khi Cả Thế Giới Ngắt Kết Nối, Boss Luôn Ở Đây"

Chế độ **Trú ẩn Chủ động (Intentional Offline Sanctuary)** không chỉ là một phương án dự phòng kỹ thuật (Fallback), mà là một **tính năng nghệ thuật độc bản** của Capcat. 

Khi Sen chủ động bật "Chế độ máy bay" hoặc mất mạng, họ đang tìm kiếm sự yên tĩnh tuyệt đối để tái tạo năng lượng. Boss ảo lúc này sẽ chuyển đổi từ một thú cưng năng động thành một **tri kỷ trầm mặc**. Để tránh sự nhàm chán và lặp lại khi Sen ngắt kết nối nhiều lần, hệ thống sẽ **không bao giờ** hiển thị một lời thoại tĩnh đơn lẻ. 

Thay vào đó, chúng ta xây dựng **Động cơ Phối trộn Ngoại tuyến Đa hướng (Multi-Dimensional Offline Mixer Engine)** để tự động dệt nên hàng ngàn câu thoại đậm chất thơ hoàn toàn cục bộ (On-Device), kết hợp với hiệu ứng thị giác và âm thanh sưởi ấm tâm hồn.

---

## ⚙️ 2. Động Cơ Phối Trộn Ngoại Tuyến Đa Hướng (Deterministic Offline Mixer Engine)

Thay vì lưu trữ các đoạn văn dài có sẵn, local database của App sẽ lưu trữ các **Mảnh ghép cảm xúc (Emotional Fragments)** được chia làm 4 nhóm độc lập. Thiết bị sẽ tự động trộn chúng theo công thức toán học dựa trên **múi giờ sinh học thực tế** và **ngày hiện tại trong năm (Day of Year)** để tạo ra các câu thoại độc bản vô tận.

```
       [4 NHÓM MẢNH GHÉP CẢM XÚC TRONG SQLite / HIVE]
 
 ┌──────────────────────┐        ┌──────────────────────┐
 │ Nhóm 1: Physical Act │        │  Nhóm 2: Season Cont │
 │  - Hành động của Pet │        │  - Chiêm nghiệm mùa  │
 └──────────┬───────────┘        └──────────┬───────────┘
            │                               │
            └──────────────┬────────────────┘
                           ▼
             [ THUẬT TOÁN MIXER CỤC BỘ ] ◄── [ Ký ức từ Memory Vault ] (Nhóm 4)
                           ▲
            ┌──────────────┴────────────────┐
            │                               │
 ┌──────────┴───────────┐        ┌──────────┴───────────┐
 │ Nhóm 3: Time Whisper │        │   BỘ SEED TOÁN HỌC   │
 │  - Lời thì thầm giờ  │        │   - Dựa trên Ngày+Giờ│
 └──────────────────────┘        └──────────────────────┘
                           │
                           ▼
           [ CÂU THOẠI ĐA HƯỚNG HOÀN CHỈNH ]
```

### 2.1. Cấu Trúc Các Nhóm Mảnh Ghép Nội Dung (Fragment Pools)

#### Nhóm 1: Hành động vật lý của Pet (`physical_actions`) - 15 Mảnh
*   *Mèo:* `"Trẫm đang nằm gác cằm lên đùi Sen, hai tai khẽ động đậy nghe tiếng gió..."`
*   *Mèo:* `"Trẫm đang cuộn tròn thành một chiếc bánh sừng bò ấm áp, lim dim mắt..."`
*   *Chó:* `"Lucky đang nằm bò ra sàn nhà mát rượi, hai tai cụp xuống canh chừng giấc ngủ cho Sen..."`

#### Nhóm 2: Chiêm nghiệm theo mùa (`seasonal_contemplations`) - 10 Mảnh/Mùa
*   *Mùa Thu:* `"Ngoài hiên kia, những chiếc lá phong khô cuối cùng đang nhẹ nhàng đáp xuống hè phố tĩnh lặng..."`
*   *Mùa Đông:* `"Trời mùa đông lạnh se sắt, sương mù buông mờ ảo bên bậu cửa sổ gỗ..."`
*   *Mùa Hè:* `"Tiếng ve ngoài hàng cây kêu râm ran dưới ánh hoàng hôn mùa hạ đỏ ối..."`

#### Nhóm 3: Lời thì thầm theo khung giờ (`time_whispers`) - 8 Mảnh/Khung giờ
*   *Đêm muộn (Night):* `"Thời gian trôi chậm lại rồi, Sen trút bỏ hết mệt mỏi công việc đi nhé, trăng đêm nay dịu dàng lắm..."`
*   *Buổi sáng (Morning):* `"Nắng mai khẽ chạm vào mi mắt rồi, một ngày mới thanh bình sắp bắt đầu, Sen đừng vội vã..."`

#### Nhóm 4: Gia vị Ký ức Cục bộ (`local_memory_spices`) - Trích xuất từ `owner_memory_vault`
*   Nếu có ký ức thích nhạc Lofi: `"...Để trẫm ngâm nga giai điệu Lofi quen thuộc mà Sen hay nghe nhé..."`
*   Nếu có ký ức thích mùi organic: `"...Mùi oải hương dịu nhẹ thoang thoảng làm căn phòng tụi mình ấm áp hẳn lên..."`

---

### 2.2. Giải Thuật Phối Trộn Cục Bộ (Dart Pseudocode)

Để nhà phát triển dễ dàng lập trình, dưới đây là thuật toán chọn mảnh ghép bằng seed toán học, đảm bảo **trong cùng một ngày/khung giờ, lời chào chỉ sinh ra một kết quả nhất quán nhưng qua ngày hôm sau sẽ đổi hoàn toàn**, loại bỏ hoàn toàn sự lặp lại:

```dart
class OfflineMixerEngine {
  final LocalDatabase db;

  OfflineMixerEngine(this.db);

  Future<String> generateCozyOpener() async {
    final now = DateTime.now();
    final dayOfYear = _getDayOfYear(now);
    final hour = now.hour;
    
    // 1. Xác định Khung giờ & Mùa
    String timeTag = _getTimeTag(hour); // morning, afternoon, night
    String seasonTag = _getSeasonTag(now.month); // spring, summer, autumn, winter
    
    // 2. Tạo Seed toán học để đảm bảo tính ngẫu nhiên nhất quán trong ngày
    int seed = dayOfYear * 100 + hour;
    
    // 3. Truy vấn các Pool mảnh ghép từ SQLite/Hive cục bộ
    List<String> actions = await db.getFragments(type: 'physical_action', species: db.petSpecies);
    List<String> seasonal = await db.getFragments(type: 'seasonal_contemplation', tag: seasonTag);
    List<String> whispers = await db.getFragments(type: 'time_whisper', tag: timeTag);
    Map<String, dynamic>? memory = await db.getRandomMemory(); // Đọc từ owner_memory_vault

    // 4. Chọn mảnh ghép bằng Seed toán học
    String action = actions[seed % actions.length];
    String seasonCont = seasonal[(seed + 3) % seasonal.length];
    String whisper = whispers[(seed + 7) % whispers.length];
    
    // 5. Phối trộn gia vị Ký ức thấu cảm
    String memorySpice = "";
    if (memory != null && (seed % 2 == 0)) { // 50% cơ hội lồng ghép ký ức
      memorySpice = _formatMemorySpice(memory);
    }

    // 6. Dệt thành đoạn văn hoàn chỉnh đậm chất thơ
    return "$action $seasonCont $whisper $memorySpice".trim();
  }

  String _getTimeTag(int hour) {
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 18) return 'afternoon';
    return 'night';
  }

  String _getSeasonTag(int month) {
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  int _getDayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
  }
  
  String _formatMemorySpice(Map<String, dynamic> memory) {
    if (memory['key'] == 'hobby_music') {
      return "Nghe tiếng mưa rơi, trẫm lại nhớ bản nhạc mộc mạc mà Sen hay mở mỗi tối rồi...";
    }
    return "";
  }
}
```

---

## 🎨 3. Hệ Thiết Kế Thính Giác & Thị Giác Trầm Mặc (Aesthetic Visual & Audio)

Khi chế độ Ngoại tuyến được kích hoạt, toàn bộ giao diện chat của Capcat sẽ **"thay da đổi thịt"** để đưa người dùng vào trạng thái thiền (Zen State):

### 3.1. Hiệu Ứng Bầu Khí Quyển Hạt Bay Chậm Rãi (Slowing Particle Animations by Bella)
*   **Mùa Thu:** Hiệu ứng lá phong úa màu vàng cam bay nghiêng chậm chạp từ góc trên bên phải xuống đất.
*   **Mùa Đông:** Các hạt tuyết mịn màng rơi thẳng đứng, khẽ tan biến khi chạm vào bong bóng chat của Sen.
*   **Mùa Hạ/Mưa:** Những tia mưa mảnh như sợi chỉ nghiêng góc `15 độ` lướt qua màn hình, đi kèm hiệu ứng gợn sóng nước mờ ảo đáy màn hình.
*   **Công nghệ:** Sử dụng Flutter `CustomPainter` tối giản, không sử dụng thư viện cồng kềnh, khống chế tốc độ vẽ `FPS = 30` để **tiết kiệm pin tối đa** ở chế độ offline.

```
+------------------------------------------------------+
│ [Appbar]  Lucky (Trú ẩn)   [Icon Offline]   [Spinning]│
├──────────────────────────────────────────────────────┤
│                                                      │
│    🍁 (Lá rơi chậm rãi trên nền tối mềm mại)         │
│                                                      │
│    +--------------------------------------------+    │
│    | Boss: Trẫm đang cuộn tròn bên bậu cửa      |    │
│    | sổ ngắm lá phong rơi...                    |    │
│    +--------------------------------------------+    │
│                                                      │
│                   +-----------------------------+    │
│                   | Sen: Ừ, bình yên thật Boss  |    │
│                   +-----------------------------+    │
│                                                      │
│    [ Hộp Nhạc Đĩa Than Cổ Điển ]                     │
│    🎵 Đang phát: Rain & Lofi Guitar (Loop 30s)       │
+------------------------------------------------------+
```

### 3.2. Widget Hộp Nhạc Đĩa Than Ngoại Tuyến (Offline Music Box Player)
*   **Giao diện:** Một đĩa than Lofi nhỏ xoay tròn chậm rãi ở góc dưới màn hình.
*   **Danh sách nhạc Bundle cứng trong App (Mono 64kbps OGG/MP3 - Dung lượng ~2MB toàn bộ):**
    1.  `offline_rain.mp3` (Tiếng mưa rơi tí tách kèm tiếng củi cháy tí tách).
    2.  `offline_lofi_guitar.mp3` (Hợp âm guitar gỗ lặp lại mộc mạc).
    3.  `offline_music_box.mp3` (Hộp nhạc cổ điển âm thanh trong vắt).
*   **Hành vi:** Nhấp vào đĩa than để chuyển đổi qua lại giữa các âm thanh nền chữa lành, tạo không gian thư giãn tuyệt hảo cho Sen chìm vào giấc ngủ.

---

## 🔒 4. Cam Kết Tiết Kiệm Tài Nguyên & Đạo Đức
1.  **Zero Battery Drain:** Hiệu ứng hạt bay và đĩa than xoay sẽ **lập tức dừng lại (PAUSED)** khi người dùng tắt màn hình hoặc chuyển sang ứng dụng khác để tránh hao hụt pin của Sen khi đang offline.
2.  **Sự Tinh Tế Cảm Xúc:** Chế độ này không hiển thị bất kỳ link bán sách Shopee hay quảng cáo nào. Chỉ có âm nhạc, lời thì thầm của thú cưng và không gian tĩnh lặng, tôn trọng tối đa sự riêng tư và mong muốn trú ẩn của Sen.
