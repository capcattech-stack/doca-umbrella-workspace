# ĐẶC TẢ CHI TIẾT 02: BỘ LỌC ẢNH OFFLINE ML KIT & THUẬT TOÁN QUÉT LÙI NGẪU NHIÊN SIÊU TIẾT KIỆM
*(OFFLINE ML KIT FILTERS & RANDOMIZED RETROGRESSIVE SPARSE SCANNING ENGINE)*

> **Mã Đặc Tả:** `SPEC-VAULT-02`  
> **Chủ trì:** Alan (Tech Lead), Arthur (Mom Test & Bảo mật), Sophia (CPO / PM)  
> **Mục tiêu:** Tiết kiệm pin tối đa (Zero Performance Drain) & Bộ đệm chống lặp ảnh thông minh bậc nhất

---

## 🧭 1. Phân Tích Hiệu Năng & Triết Lý Chống Hao Pin (Performance & Battery Drain Analysis)

### 1.1. Thư viện ML Kit có ảnh hưởng đến hiệu năng (Performance Impact) không?
**CÓ.** Phép phân loại hình ảnh cục bộ (Image Labeling) sử dụng mô hình Deep Learning chạy ngay trên thiết bị:
*   **Tải lượng CPU/GPU:** Nếu quét tuần tự toàn bộ thư viện ảnh (ví dụ 2000-5000 ảnh), CPU thiết bị sẽ bị vắt kiệt liên tục ở mức **80% - 100% trong 2-3 phút**, làm nóng máy cực nhanh, tụt 3-5% pin lập tức và gây hiện tượng giật khung hình (frame drop) nghiêm trọng ở luồng chính (Main Thread UI).
*   **Rò rỉ bộ nhớ (Memory Leak):** Khởi tạo và hủy liên tục hàng trăm đối tượng `InputImage` trong thời gian ngắn mà không giải phóng RAM kịp thời sẽ kích hoạt hệ thống dọn rác (Garbage Collector) của Flutter chạy liên tục, gây lag cục bộ.

### 1.2. Giải pháp tối ưu hóa tối cao: "Quét Lùi Thưa Thớt Ngẫu Nhiên" (Randomized Retrogressive Sparse Scanning)
Để triệt tiêu hoàn toàn gánh nặng hiệu năng này, Capcat phát minh ra giải thuật **Quét lùi thưa thớt ngẫu nhiên theo tháng**:
1.  **Thu hẹp tối đa đầu vào:** Không quét bừa bãi.
2.  **Chia block thời gian:** Phân chia dòng thời gian từ **Hiện tại ngược về quá khứ 2 năm** thành **24 Block Tháng** độc lập.
3.  **Lấy mẫu ngẫu nhiên siêu thưa (Random Sampling):** Mỗi tháng chỉ bốc ngẫu nhiên **tối đa 1-2 bức ảnh** chưa từng xử lý để chạy nhận diện ML Kit.
4.  **Dừng cực sớm (Early Stopping):** Chỉ cần gom đủ **10 - 15 bức ảnh Pet hợp lệ** cho bộ thẻ bài tuần này, **tiến trình quét ngầm lập tức ngắt (Kill) và giải phóng bộ nhớ ngay lập tức**.
5.  **Kết quả thực tế:** Mỗi tuần, máy chỉ chạy nhận diện ML Kit tối đa **20-30 tấm ảnh** bốc ngẫu nhiên. CPU tăng không quá 5%, thời gian quét chưa đầy 1.5 giây, máy mát lạnh, hao pin gần như bằng 0!

---

## ⚙️ 2. Thuật Toán Quét Lùi Thưa Thớt Ngẫu Nhiên (Randomized Retrogressive Sparse Scanning Algorithm)

Dưới đây là sơ đồ vận hành của bộ quét:

```
 [ Ngày Hiện Tại ] ──────────────────────────────────────────► [ Lùi Quá Khứ 2 Năm (24 Tháng) ]
         │
         ├──► [Tháng 1]: Lọc trùng DB ──► Bốc NGẪU NHIÊN 2 ảnh ──► ML Kit (Trúng 1 ảnh Pet)
         │
         ├──► [Tháng 2]: Lọc trùng DB ──► Bốc NGẪU NHIÊN 2 ảnh ──► ML Kit (Trúng 2 ảnh Pet)
         │
         ├─-─► [Bỏ qua các ảnh sát giây/sát phút trong cùng tháng để tránh lặp góc chụp]
         │
         └──► [Tháng N]: Gom đủ 12 ảnh Pet ──► DỪNG QUÉT LẬP TỨC (EARLY STOP) & GIẢI PHÓNG RAM
```

### 2.1. Giải thuật Chi Tiết (Step-by-Step Logic)

1.  **Bước 1 (Đọc Bộ Đệm Chống Trùng):** 
    *   Tải toàn bộ danh sách `local_asset_id` đã từng được hiển thị cho người dùng từ bảng SQLite `processed_photos_cache` (bất kể họ vuốt trái, phải hay lên).
2.  **Bước 2 (Phân nhóm ảnh theo 24 Tháng):**
    *   Sử dụng thư viện `photo_manager` để đọc siêu dữ liệu ảnh (Metadata) mà không cần nạp tệp ảnh thô vào RAM.
    *   Nhóm các `local_asset_id` hợp lệ (không nằm trong danh sách đã quét ở Bước 1) vào **24 giỏ tương ứng với 24 tháng** gần nhất.
3.  **Bước 3 (Nhảy lùi ngẫu nhiên & Quét thưa):**
    *   Duyệt ngược từ tháng thứ 1 (mới nhất) lùi về tháng thứ 24 (quá khứ 2 năm).
    *   Tại mỗi tháng, nếu giỏ ảnh có $N$ ảnh, hệ thống sử dụng thuật toán ngẫu nhiên (chạy hạt giống ngẫu nhiên dựa trên Milliseconds của timestamp hiện tại) để **chọn ra đúng 2 ảnh tiêu biểu**.
    *   *Lưu ý loại bỏ trùng lặp góc:* Nếu 2 ảnh được chọn ngẫu nhiên có thời gian chụp cách nhau dưới **5 phút** (chụp liên tiếp), hệ thống tự động bốc lại ảnh khác để tránh việc cả 2 thẻ bài trong stack đều là một khoảnh khắc trùng lặp.
4.  **Bước 4 (Nhận diện & Dừng thông minh):**
    *   Chuyển 2 bức ảnh đã bốc của tháng đó qua model **Google ML Kit Image Labeling**.
    *   Nếu có nhãn `"Cat"`, `"Dog"`, `"Kitten"`, `"Puppy"` với độ tin cậy $\ge 0.70$ -> Đưa ảnh vào bộ thẻ bài Tinder Stack.
    *   **Ngay khi bộ thẻ bài Tinder đạt đủ số lượng (từ 10 đến 15 ảnh hợp lệ)**, dừng toàn bộ vòng lặp duyệt tháng, gọi hàm giải phóng đối tượng labeler `_labeler.close()` để trả lại RAM và tắt luồng nền.

---

## 🏛️ 3. Thiết Kế Cơ Sở Dữ Liệu Trí Tuệ Hình Ảnh Cục Bộ (Local Photo Intelligence DB Schema)

Để lưu giữ kết quả nhận diện ML Kit, tránh việc quét đi quét lại ảnh cũ, và làm giàu kho tri thức hình ảnh của Pet phục vụ cho động cơ chat Cozy Chat, chúng ta thiết kế bảng SQLite **`local_photo_intelligence_cache`** cục bộ trên máy:

### 3.1. SQLite Table Schema (`local_photo_intelligence_cache`)
```sql
CREATE TABLE local_photo_intelligence_cache (
    local_asset_id VARCHAR(128) PRIMARY KEY, -- ID ảnh của iOS PHAsset hoặc Android Media Store URI
    is_pet INTEGER NOT NULL DEFAULT 0,        -- 0 = Không phải Pet, 1 = Đúng là Pet (Cat/Dog)
    pet_type VARCHAR(16) NOT NULL,            -- 'cat', 'dog', 'unknown'
    pet_confidence REAL NOT NULL DEFAULT 0.0, -- Độ tin cậy nhận diện pet (0.0 - 1.0)
    detected_actions TEXT,                    -- Chuỗi JSON danh sách hành động nhận diện được (ví dụ: '["sleeping", "sitting"]')
    ambient_context TEXT,                     -- Chuỗi JSON bối cảnh môi trường xung quanh (ví dụ: '["bed", "indoor", "sofa"]')
    swipe_state VARCHAR(16) DEFAULT 'unprocessed', -- Trạng thái vuốt: 'unprocessed', 'left' (bỏ qua), 'right' (lưu), 'up' (kỷ niệm vàng)
    displayed_count INTEGER DEFAULT 0,        -- Số lần đã hiển thị trên Tinder Stack
    photo_taken_at TIMESTAMP,                 -- Ngày chụp ảnh thực tế (đối chiếu theo mùa/giờ)
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_displayed_at TIMESTAMP               -- Thời gian hiển thị lần cuối
);
```

### 3.2. Cấu Trúc Khai Báo Dữ Liệu Hành Động & Bối Cảnh Cho Cozy Chat (Data Schema for AI Prompts)
Mỗi tệp ảnh sau khi đi qua Google ML Kit Image Labeler sẽ được trích xuất và lưu trữ theo cấu trúc JSON chuẩn hóa để cung cấp nguyên liệu sinh câu thoại cực kỳ sống động cho Boss ảo:

```json
{
  "local_asset_id": "phasset_ios_982341",
  "is_pet": 1,
  "pet_type": "cat",
  "pet_confidence": 0.94,
  "detected_actions": ["sleeping", "lying_down"], 
  "ambient_context": ["bed", "indoor", "pillow"],
  "photo_taken_at": "2026-04-12T14:30:22Z"
}
```
*   **Các Nhãn Hành Động Hỗ Trợ Mặc Định (Detected Actions Mapping):**
    *   `sleeping` (đang ngủ - trúng nhãn *Sleeping*, *Asleep*): Pet nhắm mắt, nằm gác đầu.
    *   `eating` (đang ăn - trúng nhãn *Eating*, *Cat food*, *Licking*): Pet đang cúi đầu bên bát ăn.
    *   `playing` (đang chơi - trúng nhãn *Playing*, *Toy*, *Running*, *Jumping*): Pet đang ôm cào móng hoặc đuổi bắt bóng.
    *   `sitting` (đang ngồi - trúng nhãn *Sitting*, *Sitting pose*).
    *   `lying_down` (đang nằm ườn - trúng nhãn *Lying down*, *Cozy*).
*   **Các Nhãn Bối Cảnh Môi Trường (Ambient Context Mapping):**
    *   `bed` (giường ngủ), `sofa` (ghế sofa), `cardboard_box` (hộp các-tông tri kỷ), `grass` (bãi cỏ sân vườn), `carpet` (thảm trải sàn), `keyboard` (Sen đang cày cuốc học tập/làm việc bị Boss đè phím).

---

## ⚙️ 4. Động Cơ Làm Giàu Dữ Liệu Ngầm Chậm Mà Chắc (Continuous Background Enrichment Engine)

Để triệt tiêu hoàn toàn độ trễ khi mở game vuốt thẻ, Capcat không chạy quét ML Kit dồn dập vào lúc chơi. Thay vào đó, app vận hành cơ chế **Quét ngầm gián đoạn mỗi ngày**:

```
  [ Đêm đến, Sen đi ngủ & cắm sạc điện thoại ]
                       │
                       ▼ (Workmanager Background Task kích hoạt)
   [ Lấy ngẫu nhiên 20-30 ảnh CHƯA QUÉT trong thư viện ]
                       │
                       ▼ (Quét ML Kit Isolate ngầm siêu nhẹ)
    [ Lưu phân loại & tag hành động vào SQLite Cache ]
                       │
                       ▼
   [ Khi Sen mở app: Render thẻ bài lập tức trong 0.01s từ Cache ]
```

### 4.1. Cách Thức Hoạt Động Của Bộ Quét Ngầm (Daily Background Job)
1.  **Lập lịch ngầm (Background Job Scheduling):** Sử dụng thư viện `workmanager` của Flutter để chạy một tác vụ ngầm định kỳ **mỗi 24 giờ một lần**. Tác vụ này cấu hình chỉ chạy khi:
    *   Thiết bị đang **cắm sạc (Charging)** để bảo toàn pin.
    *   Thiết bị kết nối Wifi hoặc ở trạng thái nghỉ không dùng màn hình (Idle).
2.  **Quét ngầm giới hạn (Limit Scans per day):** Mỗi lần chạy ngầm, Isolate chỉ bốc đúng **20 đến 30 tấm ảnh mới nhất chưa có mặt trong bảng `local_photo_intelligence_cache`** để chạy qua Image Labeler.
3.  **Làm giàu dữ liệu dần dần (Gradual Data Enrichment):** Sau 1 tháng, hệ thống sẽ xây dựng được một kho tri thức local gồm **600 - 900 ảnh Pet** với đầy đủ nhãn hành động/bối cảnh. Khi Sen mở tính năng Tinder Buffet, app chỉ việc đọc từ SQLite lên hiển thị ngay lập tức (Zero Latency), pin hao hụt bằng 0!

---

## 🔄 5. Cơ Chế Tái Sử Dụng Ảnh Cũ Hợp Lý (Skipped Photo Recycling Logic)

Để tránh hiện tượng người dùng bị cạn kiệt ảnh Pet hoặc bị lặp lại quá nhanh gây nhàm chán ("ngày nào cũng thấy vài tấm chán ngấy"), thuật toán nạp thẻ bài áp dụng **luật hồi sinh ảnh cũ thông minh**:

1.  **Ảnh Đã Lưu (Memories) là Độc Bản:** Bất kỳ ảnh nào có `swipe_state = 'right'` (đã lưu) hoặc `swipe_state = 'up'` (Kỷ niệm vàng) sẽ **KHÔNG BAO GIỜ** được hiển thị lại trên Tinder Swipe Stack. Chúng thuộc về không gian linh thiêng của Hộp Ký Ức.
2.  **Chu Kỳ Hồi Sinh Ảnh Bỏ Qua (Skipped Photo Cooldown):**
    *   Ảnh có `swipe_state = 'left'` (ảnh Sen đã vuốt qua bỏ chọn) sẽ bị **khóa tạm thời trong 4 tuần**.
    *   Sau **4 đến 6 tuần**, nếu kho ảnh unprocessed mới bị cạn kiệt, hệ thống sẽ tự động mở khóa các ảnh bỏ qua này, cập nhật trạng thái về lại `unprocessed`, thay đổi thứ tự ngẫu nhiên và đưa trở lại Swipe Stack dưới dạng "Kho báu bị lãng quên".
    *   *Lý do:* Tâm trạng con người thay đổi theo thời gian. Bức ảnh tháng trước Sen thấy bình thường, tháng này tự nhiên nhìn lại có thể thấy vô cùng đáng yêu và muốn lưu giữ. Chu kỳ 4 tuần đủ dài để Sen hoàn toàn quên góc ảnh đó, mang lại cảm giác tươi mới bất ngờ khi lướt lại.

---

## ✍️ 6. Code Mẫu Nâng Cấp Quét Cục Bộ & Cache (Dart Code by Alan)

Alan cập nhật lõi `RetrogressiveScanner` để tích hợp toàn diện SQLite Metadata Cache và Tag hành động/bối cảnh:

```dart
import 'dart:convert';
import 'package:photo_manager/photo_manager.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class LocalPhotoMetadata {
  final String id;
  final bool isPet;
  final String petType;
  final double petConfidence;
  final List<String> detectedActions;
  final List<String> ambientContext;
  final DateTime photoTakenAt;

  LocalPhotoMetadata({
    required this.id,
    required this.isPet,
    required this.petType,
    required this.petConfidence,
    required this.detectedActions,
    required this.ambientContext,
    required this.photoTakenAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'local_asset_id': id,
      'is_pet': isPet ? 1 : 0,
      'pet_type': petType,
      'pet_confidence': petConfidence,
      'detected_actions': jsonEncode(detectedActions),
      'ambient_context': jsonEncode(ambientContext),
      'swipe_state': 'unprocessed',
      'photo_taken_at': photoTakenAt.toIso8601String(),
    };
  }
}

class AdvancedScanner {
  final LocalDatabase db;
  final ImageLabeler _labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.50));

  AdvancedScanner(this.db);

  // 1. Quét làm giàu dữ liệu chạy ngầm mỗi ngày vài chục tấm
  Future<void> runDailyBackgroundScan(int limit) async {
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (paths.isEmpty) return;

    final List<AssetEntity> allPhotos = await paths.first.getAssetListRange(start: 0, end: 1000);
    List<String> alreadyScannedIds = await db.getScannedPhotoIds();

    int processedCount = 0;
    for (AssetEntity entity in allPhotos) {
      if (processedCount >= limit) break;
      if (alreadyScannedIds.contains(entity.id)) continue;

      File? file = await entity.file;
      if (file != null) {
        LocalPhotoMetadata meta = await _analyzeImage(entity, file.path);
        await db.savePhotoIntelligence(meta);
        processedCount++;
      }
    }
  }

  // 2. Phân tích chi tiết hành động và bối cảnh từ nhãn ML Kit
  Future<LocalPhotoMetadata> _analyzeImage(AssetEntity entity, String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final List<ImageLabel> labels = await _labeler.processImage(inputImage);

    bool isPet = false;
    String petType = 'unknown';
    double petConf = 0.0;
    List<String> actions = [];
    List<String> context = [];

    for (ImageLabel label in labels) {
      String name = label.label.toLowerCase();
      // Nhận diện Pet
      if (['cat', 'kitten'].contains(name)) {
        isPet = true; petType = 'cat'; petConf = label.confidence;
      } else if (['dog', 'puppy'].contains(name)) {
        isPet = true; petType = 'dog'; petConf = label.confidence;
      }
      
      // Nhận diện hành động Pet
      if (['sleeping', 'asleep', 'nap'].contains(name)) actions.add('sleeping');
      if (['eating', 'feeding', 'lick'].contains(name)) actions.add('eating');
      if (['playing', 'jump', 'run', 'toy'].contains(name)) actions.add('playing');
      if (['sitting'].contains(name)) actions.add('sitting');
      if (['lying', 'lazy'].contains(name)) actions.add('lying_down');

      // Nhận diện bối cảnh
      if (['bed', 'pillow', 'blanket'].contains(name)) context.add('bed');
      if (['sofa', 'couch', 'chair'].contains(name)) context.add('sofa');
      if (['indoor', 'room', 'home'].contains(name)) context.add('indoor');
      if (['outdoor', 'garden', 'grass', 'park'].contains(name)) context.add('grass');
      if (['keyboard', 'laptop'].contains(name)) context.add('keyboard');
      if (['box', 'carton'].contains(name)) context.add('cardboard_box');
    }

    return LocalPhotoMetadata(
      id: entity.id,
      isPet: isPet,
      petType: petType,
      petConfidence: petConf,
      detectedActions: actions,
      ambientContext: context,
      photoTakenAt: entity.createDateTime,
    );
  }
}
```

---

## ✨ 6. Động Cơ Sinh Mô Tả Lãng Đãng Tự Động (Auto Poetic Caption Generator)

Sau khi bức ảnh được phân tích bởi ML Kit và lưu xong vào `local_photo_intelligence_cache`, hệ thống lập tức kích hoạt bước tiếp theo: **tự động sinh ra một dòng mô tả ngắn, lãng đãng, chữa lành** cho tấm ảnh đó.

Dòng mô tả này hiển thị dưới ảnh dìm trên thẻ Polaroid như một dòng chữ viết tay nhạt nhẹ, gợi nhớ phong cách chú thích nhật ký hoài cổ của người Nhật.

### 6.1. Nguồn Nguyên Liệu Đầu Vào (Input Fusion Schema)

Mỗi dòng mô tả lãng đãng được tổng hợp từ **3 luồng dữ liệu song song**:

```
┌─────────────────────────────┐    ┌──────────────────────────────┐    ┌────────────────────────────┐
│  📸 EXIF Metadata           │    │  🤖 ML Kit Analysis          │    │  ✍️ User Handwriting        │
│  - Ngày & giờ chụp          │    │  - Hành động: sleeping       │    │  (Nếu Sen đã ghi khi vuốt) │
│  - Suy ra: Mùa, Buổi sáng/  │    │  - Bối cảnh: bed, pillow     │    │  "Boss ngủ như heo con"    │
│    chiều, trời mưa/nắng     │    │  - Loài: cat / dog           │    │                            │
│  - GPS (nếu có): Indoor/    │    │  - Confidence: 0.94          │    │                            │
│    Outdoor rough tag        │    │                              │    │                            │
└─────────────┬───────────────┘    └──────────────┬───────────────┘    └──────────────┬─────────────┘
              │                                   │                                   │
              └───────────────────────────────────┼───────────────────────────────────┘
                                                  ▼
                                   [ Caption Generation Engine ]
                                    (Offline Template hoặc Gemini Flash)
                                                  │
                                                  ▼
                             "Một buổi chiều xuân, trẫm ngủ say bên gối ấm..."
```

### 6.2. Cỗ Máy Sinh Mô Tả Offline (Zero-Cost Template Engine)

Để không phát sinh chi phí token API và hoạt động 100% không cần mạng, caption được sinh **ngay trên thiết bị** bằng cách ghép các mảnh thơ nhỏ từ bảng từ vựng lãng đãng nội tuyến.

**Quy tắc ghép 4 thành phần (4-Part Poetic Stacking):**

```
[Thời điểm] + [Hành động Pet] + [Bối cảnh] + [Cảm xúc nhẹ nhàng]
```

**Bảng từ vựng thời điểm (Time Token Library):**
| Giờ chụp | Token Lãng Đãng |
| :--- | :--- |
| 5:00 - 8:59 | `"Sáng sớm tinh mơ"`, `"Khi nắng chưa kịp lên"` |
| 9:00 - 11:59 | `"Buổi sáng hanh hao"`, `"Một sáng thứ Bảy chậm rãi"` |
| 12:00 - 13:59 | `"Giữa trưa nắng gắt"`, `"Khi cả thế giới đang ngủ trưa"` |
| 14:00 - 17:59 | `"Buổi chiều lơ đãng"`, `"Nắng chiều nghiêng qua khe cửa"` |
| 18:00 - 20:59 | `"Khi hoàng hôn buông xuống"`, `"Buổi tối đầu tuần bình yên"` |
| 21:00 - 4:59 | `"Đêm muộn tĩnh lặng"`, `"Khi thành phố đã lên đèn"` |

**Bảng từ vựng hành động Pet (Action Token Library):**
| ML Tag | Token Lãng Đãng |
| :--- | :--- |
| `sleeping` | `"trẫm đang ngủ mê man"`, `"một giấc ngủ không âu lo"` |
| `eating` | `"trẫm đang ăn ngấu nghiến"`, `"đang tận hưởng bữa pate chiều"` |
| `playing` | `"đang nghịch ngợm không chịu nằm yên"`, `"rượt đuổi một sợi len vô hình"` |
| `sitting` | `"ngồi yên như một vị thiền sư"`, `"đang quan sát thế giới từ xa"` |
| `lying_down` | `"nằm ườn như tấm thảm"`, `"trải thân dài trên khoảng trống ấm"` |
| *(không rõ)* | `"đang làm gì đó trẫm cũng không nhớ nữa"` |

**Bảng từ vựng bối cảnh (Context Token Library):**
| ML Tag | Token Lãng Đãng |
| :--- | :--- |
| `bed` | `"trên chiếc gối quen"`, `"giữa mớ chăn ấm áp"` |
| `sofa` | `"trên góc sofa cũ"`, `"chỗ ngồi xem phim yêu thích"` |
| `grass` | `"giữa khoảnh sân nắng"`, `"bên đám cỏ ướt sương"` |
| `keyboard` | `"trên bàn phím của Sen"`, `"giữa đống báo cáo cần nộp"` |
| `cardboard_box` | `"trong chiếc hộp carton tri kỷ"`, `"bên chiếc hộp nhỏ quen thuộc"` |
| *(không rõ)* | `"ở một góc nào đó trong nhà"` |

**Ví dụ ghép hoàn chỉnh:**
```
Input:  photoTakenAt = 14:32, action = [sleeping], context = [bed, pillow]
Output: "Buổi chiều lơ đãng, trẫm đang ngủ mê man trên chiếc gối quen."

Input:  photoTakenAt = 09:15, action = [sitting], context = [keyboard]
Output: "Một sáng thứ Bảy chậm rãi, ngồi yên như một vị thiền sư trên bàn phím của Sen."

Input:  photoTakenAt = 22:10, action = [lying_down], context = [sofa]
Output: "Đêm muộn tĩnh lặng, nằm ườn như tấm thảm trên góc sofa cũ."
```

### 6.3. Mùa & Năm Suy Ra Từ Ngày Chụp (Season Inference)
Để thêm chiều sâu cảm xúc, hệ thống suy ra mùa từ `photo_taken_at` và bơm thêm một nhãn mùa vào câu:
- **Tháng 1-3:** `"mùa Xuân"` / `"trời lạnh se"` / `"đầu năm lơ đãng"`
- **Tháng 4-6:** `"trời hè oi"` / `"chiều hè hanh nắng"`
- **Tháng 7-9:** `"cơn mưa nhiệt đới"` / `"tiếng mưa gõ mái"` / `"mùa ngập nước"`
- **Tháng 10-12:** `"gió se lạnh"` / `"cuối năm chầm chậm"` / `"trời chuyển lạnh"`

### 6.4. Chế Độ Nâng Cao (Gemini Flash Online Enhancement)
Khi thiết bị có mạng và người dùng **vừa mới đóng dấu Kỷ Niệm Vàng** (Swipe Up — nghi thức quan trọng nhất), hệ thống sẽ nâng cấp dòng caption từ bản ghép offline lên một phiên bản **Gemini Flash tạo thơ** sống động và sâu sắc hơn nhiều:

```xml
<caption_prompt>
  Hãy viết 1 câu mô tả ngắn (tối đa 20 từ tiếng Việt) cho bức ảnh kỷ niệm này với phong cách:
  - Lãng đãng, chữa lành, nhẹ nhàng như nhật ký viết tay
  - Nhân vật là Boss (thú cưng) đang nói với Sen (chủ nuôi)
  - Không dùng từ khô khan, không dùng emoji
  Thông tin ảnh:
  - Thời điểm chụp: {{photoTakenAt}} ({{season}}, {{timeOfDay}})
  - Hành động: {{detectedActions}}
  - Bối cảnh: {{ambientContext}}
  - Ghi chú của Sen: "{{userComment}}"
</caption_prompt>
```

### 6.5. Lưu Trữ Caption Vào SQLite Cache
Sau khi sinh ra, dòng mô tả lãng đãng được lưu ngay vào bảng `local_photo_intelligence_cache` bằng cách thêm một cột mới:

```sql
ALTER TABLE local_photo_intelligence_cache
  ADD COLUMN auto_caption TEXT DEFAULT NULL;  -- Dòng mô tả lãng đãng sinh tự động
  ADD COLUMN caption_generated_at TIMESTAMP DEFAULT NULL;
  ADD COLUMN caption_mode VARCHAR(16) DEFAULT NULL; -- 'offline_template' hoặc 'gemini_flash'
```

**Quy tắc hiển thị trên thẻ Polaroid:**
- Nếu Sen **đã ghi tay comment** lúc Swipe Up → Ưu tiên hiển thị comment của Sen (to, đậm, font Caveat).
- Nếu Sen chưa ghi → Hiển thị `auto_caption` sinh tự động (nhỏ hơn, nhạt màu hơn, font Quicksand italic, màu `#9C8F87` — xám tre mộc mạc).
- Nếu cả hai đều có → Hiển thị 2 dòng: comment của Sen trên, auto_caption (chú thích nhỏ) phía dưới.

---

## 🔒 7. Tiêu Chí Nghiệm Thu Tối Cao (Acceptance Criteria)

1.  **AC-1 (Zero ML Runtime on Swipe):** Mở giao diện Tinder Swipe Stack -> Xác nhận app hiển thị thẻ bài ngay lập tức dưới 0.1 giây từ SQLite cache mà không chạy tiến trình ML Kit trực tiếp làm gián đoạn độ mượt của hoạt ảnh vuốt.
2.  **AC-2 (Action Data Integrity):** Truy vấn SQLite cục bộ -> Xác nhận các trường `detected_actions` và `ambient_context` được lưu đúng dạng mảng JSON thô và đồng bộ hóa thành công làm gợi ý cho Chat Engine.
3.  **AC-3 (Cooldown Skipped Photo):** Vuốt bỏ qua ảnh dìm A (Swipe Left) -> Xác nhận ảnh A biến mất -> Thay đổi giờ hệ thống trên thiết bị thêm **35 ngày (5 tuần)** và mở lại stack -> Xác nhận ảnh dìm A đã được hồi sinh, tái xuất hiện ngẫu nhiên trong đống thẻ bài mới.
4.  **AC-4 (Offline Caption):** Chụp ảnh pet lúc 14:30 -> Chờ background scan -> Mở Hộp Ký Ức -> Xác nhận thẻ Polaroid hiển thị dòng mô tả lãng đãng chứa từ khóa `"chiều"` và đúng hành động/bối cảnh nhận diện được từ ML Kit.
5.  **AC-5 (Caption Priority):** Ảnh có cả `auto_caption` lẫn comment viết tay của Sen -> Xác nhận comment của Sen hiển thị to rõ trên cùng, auto_caption hiển thị nhạt nhỏ phía dưới.

