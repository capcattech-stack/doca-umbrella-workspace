# ĐẶC TẢ CHI TIẾT 03: ĐỘNG CƠ GHÉP KHUNG MEME VIRAL 0 ĐỒNG
*(OFFLINE MEME COMPOSITING ENGINE & VIRAL SHARE LOOP)*

> **Mã Đặc Tả:** `SPEC-VAULT-03`
> **Chủ trì:** Bella (Lead UI/UX & Animator), Alan (Tech Lead), Sophia (CPO/PM), Arthur (Mom Test)
> **Mục tiêu:** Tạo meme viral 0đ GPU Cloud + Kích hoạt Viral Growth Loop tự nhiên qua Social Share
> **Triết lý:** Meme là **vũ khí marketing chủ động** — một lớp sáng tạo tự nguyện của Sen, KHÔNG BAO GIỜ ô nhiễm Hộp Ký Ức thiêng liêng.

---

## 🧭 1. Triết Lý & Mom Test Validation

### 1.1. Kết Luận Mom Test: "Ký ức gốc và Meme phải tồn tại riêng biệt"

Arthur đã phỏng vấn Nam và Early Adopters theo Mom Test chuẩn (không hỏi hypothetical):

> *Nam (User):* "Tôi chỉ muốn ngắm lại cái mũi ướt sũng thật sự của nó... Những chi tiết đó rất thật. Nếu app tự chèn hình vẽ chibi lên đó — trông rất rẻ tiền và làm mất sự thiêng liêng."

**Quyết định kiến trúc không thay đổi:**
```
Hộp Ký Ức = Thiêng liêng, ảnh gốc 100%, không meme tự động
Meme Studio = Lớp sáng tạo TÁCH BIỆT, Sen chủ động vào, output dùng để SHARE
```

### 1.2. Vai Trò Meme Trong Product Strategy

Meme không chỉ là tính năng vui — đây là **Viral Growth Engine**:

```
Sen chế meme Boss → Share lên Story/Reels/TikTok
                           │
                           ▼ (Người lạ xem)
                   Logo "Capcat: Soul of Pet" ở góc
                           │
                           ▼
                  Tò mò → Tìm kiếm app → Tải xuống
                           │
                           ▼
                  CAC = 0đ  |  Viral coefficient > 1
```

**Mục tiêu KPI của tính năng Meme:**
- **Share rate:** ≥ 30% người dùng share ít nhất 1 meme trong 7 ngày đầu
- **K-factor:** Mỗi meme được share thu hút ≥ 0.3 người dùng mới (đo qua deep link)
- **Brand impression:** Watermark "Capcat" xuất hiện trong feed của ≥ 10,000 tài khoản/tháng

---

## 🛠️ 2. Kiến Trúc Kỹ Thuật Tổng Quan (Technical Architecture)

```
┌─────────────────────────────────────────────────────────────────┐
│                     MEME COMPOSITING PIPELINE                    │
│                                                                   │
│  ┌─────────────┐    ┌──────────────┐    ┌────────────────────┐  │
│  │ STAGE 1     │    │ STAGE 2      │    │ STAGE 3            │  │
│  │ Face Detect │───►│ Canvas Comp  │───►│ Export & Share     │  │
│  │             │    │              │    │                    │  │
│  │ Google ML   │    │ Flutter      │    │ share_plus         │  │
│  │ Kit Face    │    │ CustomPaint  │    │ image_gallery_saver│  │
│  │ Detection   │    │ +            │    │ deep_link tracking │  │
│  │ (On-device) │    │ RepaintBound │    │                    │  │
│  └─────────────┘    └──────────────┘    └────────────────────┘  │
│                                                                   │
│  ✅ 100% On-Device   ✅ Zero Cloud GPU   ✅ Zero API Cost        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 3. Stack Thư Viện Kỹ Thuật Chi Tiết (Full Tech Stack)

### 3.1. Nhận Diện Khuôn Mặt — Google ML Kit Face Detection

**Thư viện:** `google_mlkit_face_detection: ^0.9.0`
**Chạy:** 100% on-device, không cần internet, không tốn tiền

```yaml
# pubspec.yaml
dependencies:
  google_mlkit_face_detection: ^0.9.0
```

**Tại sao chọn ML Kit thay vì giải pháp khác?**
| Giải pháp | Chi phí | Offline | Tốc độ | Privacy |
| :--- | :--- | :--- | :--- | :--- |
| **Google ML Kit** ✅ | $0 | ✅ Yes | ~80ms | ✅ On-device |
| AWS Rekognition | ~$1/1000 req | ❌ No | ~300ms | ❌ Cloud |
| Azure Face API | ~$1/1000 req | ❌ No | ~250ms | ❌ Cloud |
| OpenCV local | $0 | ✅ Yes | ~200ms | ✅ On-device |

**Các thuộc tính Face Detection sử dụng:**

```dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

final FaceDetector _faceDetector = FaceDetector(
  options: FaceDetectorOptions(
    // Chế độ chính xác cao (ACCURATE) để khoanh vùng mặt pet đúng hơn
    performanceMode: FaceDetectorMode.accurate,
    // Bật landmark detection để lấy điểm mắt, mũi, miệng
    enableLandmarks: true,
    // Bật contour để vẽ đường viền khuôn mặt chính xác hơn
    enableContours: true,
    // Bật tracking để theo dõi khuôn mặt qua các frame preview
    enableTracking: false, // Tắt tracking vì chỉ xử lý ảnh tĩnh
    // Ngưỡng tối thiểu kích thước khuôn mặt (% chiều rộng ảnh)
    minFaceSize: 0.10,
  ),
);

// Hàm detect khuôn mặt từ local file
Future<Rect?> detectPetFaceBounds(String localImagePath) async {
  final inputImage = InputImage.fromFilePath(localImagePath);
  final List<Face> faces = await _faceDetector.processImage(inputImage);

  if (faces.isEmpty) return null;

  // Ưu tiên khuôn mặt lớn nhất (thường là mặt pet chính)
  final Face primaryFace = faces.reduce(
    (a, b) => a.boundingBox.width > b.boundingBox.width ? a : b,
  );

  return primaryFace.boundingBox; // Rect(left, top, right, bottom)
}
```

**Lưu ý quan trọng về Face Detection với ảnh Thú Cưng:**
- ML Kit Face Detection được train cho khuôn mặt người. Với mặt mèo/chó độ chính xác ~65%.
- **Giải pháp:** Dùng kết hợp ML Kit Face + `google_mlkit_image_labeling` để xác nhận có mặt Pet trong ảnh trước. Nếu face detection thất bại → Fallback: cho Sen tự khoanh vùng bằng tay.
- **Fallback UX:** *"Boss trẫm hơi khó nhận ra 😅 Sen khoanh vùng mặt trẫm giúp với!"* + hiện overlay draggable circle.

---

### 3.2. Image Processing & Cropping — `image` Package

**Thư viện:** `image: ^4.1.7`
**Mục đích:** Cắt, resize, xử lý pixel ảnh gốc trước khi đưa vào canvas

```yaml
# pubspec.yaml
dependencies:
  image: ^4.1.7
```

```dart
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:isolate';

// Chạy trong Isolate riêng để không block UI thread
Future<Uint8List> cropFaceRegionInIsolate(
  String imagePath,
  Rect faceBounds,
  double paddingFactor, // 1.4 = thêm 40% viền xung quanh mặt
) async {
  return await Isolate.run(() async {
    final bytes = File(imagePath).readAsBytesSync();
    final originalImage = img.decodeImage(bytes)!;

    // Tính vùng crop với padding
    final padX = faceBounds.width * (paddingFactor - 1) / 2;
    final padY = faceBounds.height * (paddingFactor - 1) / 2;

    final cropX = (faceBounds.left - padX).clamp(0, originalImage.width.toDouble()).toInt();
    final cropY = (faceBounds.top - padY).clamp(0, originalImage.height.toDouble()).toInt();
    final cropW = (faceBounds.width + 2 * padX).clamp(1, originalImage.width - cropX.toDouble()).toInt();
    final cropH = (faceBounds.height + 2 * padY).clamp(1, originalImage.height - cropY.toDouble()).toInt();

    final croppedFace = img.copyCrop(
      originalImage,
      x: cropX, y: cropY, width: cropW, height: cropH,
    );

    // Resize về kích thước chuẩn để render vào canvas
    final resized = img.copyResize(croppedFace, width: 400, height: 400);
    return Uint8List.fromList(img.encodePng(resized));
  });
}
```

---

### 3.3. Canvas Compositing Engine — Flutter CustomPaint + RepaintBoundary

**Không cần thư viện bên ngoài** — Flutter native đủ mạnh để xử lý layer compositing:

```dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MemeCanvasWidget extends StatefulWidget {
  final Uint8List petFaceBytes;    // Khuôn mặt pet đã crop
  final String memeTemplateAsset; // Asset path của khung meme
  final GlobalKey boundaryKey;    // Key để chụp canvas

  const MemeCanvasWidget({
    super.key,
    required this.petFaceBytes,
    required this.memeTemplateAsset,
    required this.boundaryKey,
  });

  @override
  State<MemeCanvasWidget> createState() => _MemeCanvasWidgetState();
}

class _MemeCanvasWidgetState extends State<MemeCanvasWidget> {
  // Trạng thái transform khuôn mặt (Sen kéo chỉnh)
  Offset _faceOffset = const Offset(0, 0);
  double _faceScale = 1.0;
  double _faceRotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.boundaryKey,
      child: SizedBox(
        width: 1080, // Kích thước export chuẩn Instagram Story (1080x1920)
        height: 1920,
        child: Stack(
          children: [
            // Layer 1: Background gradient (Iyashikei pastel)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF8F0), Color(0xFFFFE8D6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Layer 2: Khuôn mặt Pet (Draggable + Pinch-to-Zoom + Rotate)
            GestureDetector(
              onPanUpdate: (d) => setState(() => _faceOffset += d.delta),
              onScaleUpdate: (d) => setState(() {
                _faceScale = (_faceScale * d.scale).clamp(0.3, 3.0);
                _faceRotation += d.rotation;
              }),
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(_faceOffset.dx, _faceOffset.dy)
                  ..rotateZ(_faceRotation)
                  ..scale(_faceScale),
                alignment: Alignment.center,
                child: ClipOval( // Mask tròn mềm cho khuôn mặt
                  child: Image.memory(
                    widget.petFaceBytes,
                    width: 320,
                    height: 320,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Layer 3: Khung meme PNG trong suốt (luôn ở trên cùng)
            Positioned.fill(
              child: Image.asset(
                widget.memeTemplateAsset,
                fit: BoxFit.cover,
              ),
            ),

            // Layer 4: Watermark Capcat (viral brand mark)
            const Positioned(
              bottom: 48,
              right: 48,
              child: _CapcatWatermark(),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 3.4. Export Ảnh Chất Lượng Cao — `dart:ui` + `path_provider`

```yaml
# pubspec.yaml
dependencies:
  path_provider: ^2.1.3
```

```dart
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

/// Xuất canvas thành file PNG 1080x1920 chất lượng cực nét
Future<File> exportMemeToFile(GlobalKey boundaryKey) async {
  final RenderRepaintBoundary boundary =
      boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

  // pixelRatio: 1.0 vì canvas đã được thiết kế ở 1080x1920 native
  final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  // Lưu file tạm thời để share
  final tempDir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File('${tempDir.path}/capcat_meme_$timestamp.png');
  await file.writeAsBytes(pngBytes);

  return file;
}
```

---

### 3.5. Save To Gallery — `image_gallery_saver_plus`

```yaml
# pubspec.yaml
dependencies:
  image_gallery_saver_plus: ^3.0.1
```

```dart
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

Future<bool> saveMemeToGallery(File memeFile) async {
  final result = await ImageGallerySaverPlus.saveFile(
    memeFile.path,
    name: "Capcat_Meme_${DateTime.now().millisecondsSinceEpoch}",
  );
  return result['isSuccess'] == true;
}
```

---

### 3.6. Social Share Engine — `share_plus` + Deep Link Tracking

**Thư viện:** `share_plus: ^9.0.0`
**Mục đích:** Share Story/Feed/DM kèm tracking source để đo viral coefficient

```yaml
# pubspec.yaml
dependencies:
  share_plus: ^9.0.0
```

```dart
import 'package:share_plus/share_plus.dart';

class MemeShareService {
  /// Share lên bất kỳ app nào (Instagram, Facebook, TikTok, Zalo, etc.)
  static Future<void> shareToSocial({
    required File memeFile,
    required String petId,
    required String memeTemplateId,
  }) async {
    // Tạo deep link tracking để đo viral coefficient
    // Format: https://capcat.app/invite?ref=meme&pet={petId}&tmpl={memeTemplateId}
    final trackingUrl = _buildTrackingUrl(petId, memeTemplateId);

    await Share.shareXFiles(
      [XFile(memeFile.path, mimeType: 'image/png')],
      subject: 'Boss của tôi đang làm hoàng đế rồi này! 😹',
      text:
          'Nhìn Boss tôi mà xem 😂\n'
          'Chế meme miễn phí với Capcat ở đây nha: $trackingUrl',
      // sharePositionOrigin cho iPad (optional)
    );

    // Log analytics event
    _analytics.logEvent('meme_shared', {
      'pet_id': petId,
      'template_id': memeTemplateId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Share trực tiếp lên Instagram Story (iOS/Android native)
  static Future<void> shareToInstagramStory({
    required File memeFile,
    required String petId,
  }) async {
    // Instagram hỗ trợ share ảnh trực tiếp vào Story creator
    // via com.instagram.share.ADD_TO_STORY intent (Android)
    // hoặc instagram-stories:// URL scheme (iOS)
    final xFile = XFile(memeFile.path, mimeType: 'image/png');

    // Thử deep link vào Instagram Story trước
    final instagramUri = Uri.parse(
      'instagram-stories://share?source_application=${AppConfig.instagramAppId}',
    );

    if (await canLaunchUrl(instagramUri)) {
      // iOS: Launch Instagram Story intent trực tiếp
      await launchUrl(instagramUri);
      // Note: Truyền ảnh qua pasteboard trên iOS
      await _writeImageToPasteboard(memeFile);
    } else {
      // Fallback: Generic share sheet
      await shareToSocial(
        memeFile: memeFile,
        petId: petId,
        memeTemplateId: 'unknown',
      );
    }
  }

  static String _buildTrackingUrl(String petId, String templateId) {
    // Firebase Dynamic Links hoặc Branch.io để tracking
    return 'https://capcat.app/m?p=${petId.substring(0, 6)}&t=$templateId';
  }
}
```

---

### 3.7. Viral Tracking — Firebase Dynamic Links

```yaml
# pubspec.yaml
dependencies:
  firebase_dynamic_links: ^6.0.4
  # Hoặc Branch.io SDK nếu muốn analytics phong phú hơn
  # flutter_branch_sdk: ^7.0.0
```

**Schema Deep Link tracking:**
```
https://capcat.app/m?p={petId_prefix}&t={templateId}&v={version}
                          │                    │
                          ▼                    ▼
              Biết meme được share từ     Biết template nào
              pet nào → gamification      được ưa thích nhất
```

---

## 🎨 4. UX Flow Chi Tiết — Từ Polaroid Đến Story

### 4.1. Entry Point: Mặt Sau Tấm Polaroid

```
┌─────────────────────────────┐
│  [ Mặt trước Polaroid ]     │  ← Ảnh gốc thiêng liêng của Boss
│  ảnh thật, mộc mạc          │     (Sen vuốt lên để lật)
│                             │
│        ◯ ◉ ◯               │  ← Chỉ báo có thể lật
└─────────────────────────────┘
              │ Vuốt lên để xem mặt sau
              ▼
┌─────────────────────────────┐
│  [ Mặt sau Polaroid ]       │
│                             │
│  📅 29/05/2026              │
│  ✍️ "Buổi chiều lơ đãng..." │  ← Auto Caption
│                             │
│  ─────────────────────────  │
│  🎭 [ Chế Meme 0đ ]        │  ← Nút CTA chính (màu pastel tím nhạt)
│  📤 [ Chia sẻ ảnh gốc ]    │  ← Share ảnh gốc (không watermark)
│  💛 [ Lưu vào Kỷ Niệm ]    │  ← Nếu chưa Swipe Up
└─────────────────────────────┘
```

### 4.2. Màn Hình Meme Studio (Full Screen)

```
┌──────────────────────────────────────────────────────────────┐
│ ✕                      Chế Meme               [ Xong 💛 ]  │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │         [ Preview Canvas — Meme 1080x1920 ]         │    │
│  │                                                     │    │
│  │   Boss được đặt vào khung Hoàng Đế                 │    │
│  │   Sen kéo/zoom/xoay mặt Boss bằng 2 ngón tay       │    │
│  │                                                     │    │
│  │                        Capcat: Soul of Pet          │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ─── Chọn khung meme ─────────────────────────────────────  │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐   │
│  │  👨‍🚀  │ │  👑  │ │  💻  │ │  🤔  │ │  🌙  │ │  ☕  │   │
│  │Phi   │ │Hoàng │ │Hacker│ │Triết │ │Đêm   │ │Cafe  │   │
│  │Hành  │ │Đế    │ │Cyber │ │Gia   │ │Khuya │ │Sáng  │   │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘   │
│  (Cuộn ngang để xem thêm 9 khung...)                        │
│                                                              │
│  ─── Tuỳ chỉnh chú thích meme ────────────────────────────  │
│  [  Dưới gầm trời này, pate là tối cao...    ] ✏️           │
│  (Sen có thể sửa câu chữ tùy thích)                         │
│                                                              │
│  ─── Chia sẻ ─────────────────────────────────────────────  │
│  [ 📸 Lưu vào máy ] [ 📱 Story Instagram ] [ 🌐 Chia sẻ ]  │
└──────────────────────────────────────────────────────────────┘
```

### 4.3. Share Sheet — "Màn Hình Chia Sẻ Thần Tốc"

Sau khi nhấn **[ 🌐 Chia sẻ ]** hoặc **[ 📱 Story Instagram ]**:

```
┌──────────────────────────────────────┐
│  Chia sẻ meme của Boss 🐾           │
│                                      │
│  [ 📱 Instagram Story ]  ← Deep link │
│  [ 🎵 TikTok ]           ← Deep link │
│  [ 📘 Facebook Story ]   ← Deep link │
│  [ 💚 Zalo ]             ← Share     │
│  [ 💬 Messenger ]        ← Share     │
│  ──────────────────────────────────  │
│  [ ⬇️ Lưu vào Camera Roll ]          │
│  [ 📋 Copy link viral ]              │
└──────────────────────────────────────┘
```

**Khi nhấn "Instagram Story":**
1. App lưu ảnh meme vào `/tmp/capcat_meme.png`
2. Launch `instagram-stories://share` deep link (iOS) / `com.instagram.share.ADD_TO_STORY` intent (Android)
3. Instagram mở ngay Story Creator với ảnh meme đã được gán vào
4. Sen chỉ cần nhấn "Đăng" — **Total friction = 1 tap**

**Text mặc định đi kèm (có thể sửa):**
```
"Boss của mình đang làm Hoàng Đế rồi 😂👑
Chế meme miễn phí với Capcat 🐾
→ capcat.app/m?ref=boss_nguyen"
```

---

## 🎭 5. Thư Viện 15 Khung Meme Chibi (Template Library)

Tất cả template là file **PNG trong suốt 1080x1920** vẽ tay phong cách pastel Iyashikei, bundle sẵn trong app assets (không cần tải về):

| # | `template_id` | Tên | Bối Cảnh Chibi | Câu Meme Mặc Định | Nhóm |
| :---: | :--- | :--- | :--- | :--- | :--- |
| 1 | `astro` | 🚀 Phi Hành Gia | Mặc đồ phi hành gia ôm bình oxy nhỏ | *"Trẫm bay vào vũ trụ chỉ để tránh tiếng ồn của Sen..."* | Classic |
| 2 | `emperor` | 👑 Hoàng Đế Chảnh | Long bào tím, cầm đùi gà, ngồi ngai vàng | *"Dưới gầm trời này, pate là tối cao. Sen chỉ là người dâng đồ ăn!"* | Classic |
| 3 | `hacker` | 💻 Hacker Cyber | Đeo kính xanh neon, bên dàn PC cổ điển | *"Đang hack ngân hàng của Sen để tự đặt hạt hữu cơ giao nhà..."* | Classic |
| 4 | `philosopher` | 🤔 Triết Gia Buồn | Nằm gác cằm lên quả táo, mắt nhìn xa xăm | *"Sen đi làm muộn 5 phút. Đây có phải là phản bội không?"* | Classic |
| 5 | `late_night` | 🌙 Đêm Khuya Muộn | Ngồi ôm ly cà phê nhỏ, bao quanh bởi sao | *"3 giờ sáng. Trẫm vẫn chưa ngủ. Sen cũng vậy. Chúng ta không ổn."* | Mood |
| 6 | `morning_cafe` | ☕ Sáng Cà Phê | Đội beret, cầm tách espresso nhỏ xíu | *"Khi Sen chưa pha cà phê, trẫm không công nhận Sen là chủ."* | Mood |
| 7 | `gamer` | 🎮 Gamer Pro | Đội headphone lớn, tay cầm controller | *"GG easy. Sen nuôi trẫm là achievement to nhất cuộc đời Sen."* | Pop Culture |
| 8 | `investor` | 📈 Nhà Đầu Tư | Vest xịn, nhìn vào màn hình biểu đồ đỏ | *"Trẫm đã phân tích: Bữa sáng của Sen cần thêm 40% pate."* | Pop Culture |
| 9 | `tourist` | ✈️ Du Lịch Hè | Đội nón lá, cầm máy ảnh vintage | *"Đang vi vu Đà Lạt trong đầu trong khi nằm xem trần nhà."* | Seasonal |
| 10 | `tet_holiday` | 🧧 Tết Âm Lịch | Áo dài đỏ, cầm bao lì xì | *"Năm mới. Trẫm chúc Sen: Tiền nhiều đủ mua pate Royal Canin."* | Seasonal |
| 11 | `study` | 📚 Học Sinh Cúp | Ngồi bàn học, quyển sách che mặt ngủ gật | *"Ngủ 18 tiếng/ngày để chuẩn bị cho deadline không phải của trẫm."* | Life |
| 12 | `yoga` | 🧘 Thiền Sư | Ngồi xếp bằng, mắt nhắm, tay ấn mudra | *"Trẫm đang thiền. Đừng làm phiền. Nhất là lúc ăn trưa."* | Life |
| 13 | `chef` | 👨‍🍳 Đầu Bếp | Đội toque, tạp dề, cầm muỗng to | *"Hôm nay thực đơn của Sen: Pate. Ngày mai: Cũng pate."* | Life |
| 14 | `artist` | 🎨 Nghệ Sĩ | Đứng trước giá vẽ, pallete màu pastel | *"Tác phẩm hôm nay: Cào ghế sofa. Phong cách: Trừu tượng."* | Creative |
| 15 | `custom` | ✏️ Tùy Chỉnh | Khung trống, background gradient | *(Sen tự nhập câu meme)* | Custom |

**Kế hoạch mở rộng template:**
- **Season Pack:** Mỗi quý ra 3 template mới (Tết, Hè, Halloween)
- **Collab Pack:** Template kết hợp thương hiệu địa phương (Phúc Long, The Coffee House)
- **Premium Pack:** Ẩn sau Rewarded Ad — xem 15s quảng cáo để mở khóa 5 template độc quyền

---

## ⚡ 6. Pipeline Kỹ Thuật Đầu-Cuối (End-to-End Technical Pipeline)

```dart
// MemeGenerationPipeline — Orchestrator chính
class MemeGenerationPipeline {
  final FaceDetector _faceDetector;
  final MemeShareService _shareService;

  Future<MemeGenerationResult> generate({
    required String petImagePath,
    required String templateId,
    required String captionText,
  }) async {
    // ─── STAGE 1: Face Detection (~80ms, on-device) ───────────────
    final Rect? faceBounds = await detectPetFaceBounds(petImagePath);

    if (faceBounds == null) {
      // Fallback: Cho Sen tự chọn vùng mặt
      return MemeGenerationResult.needsManualCrop();
    }

    // ─── STAGE 2: Face Crop & Prepare (~50ms, Isolate) ──────────────
    final Uint8List faceBytes = await cropFaceRegionInIsolate(
      petImagePath,
      faceBounds,
      1.4, // 40% padding xung quanh mặt
    );

    // ─── STAGE 3: Canvas Compositing (UI thread, real-time) ─────────
    // → Được xử lý bởi MemeCanvasWidget trong UI tree
    // → Sen tương tác kéo/zoom/xoay trực tiếp trên canvas

    // ─── STAGE 4: Export (~100ms) ────────────────────────────────────
    final File memeFile = await exportMemeToFile(GlobalKey());

    // ─── STAGE 5: Share ──────────────────────────────────────────────
    return MemeGenerationResult.success(memeFile: memeFile);
  }
}

// Thời gian tổng: ~230ms từ tap vào "Chế Meme" → Canvas ready
```

**Performance Budget:**
| Stage | Thư Viện | Thời Gian | Thread |
| :--- | :--- | :--- | :--- |
| Face Detection | google_mlkit_face_detection | ~80ms | Background |
| Face Crop | image package (Isolate) | ~50ms | Isolate |
| Canvas Render | Flutter RepaintBoundary | Real-time | UI |
| Export PNG | dart:ui toImage() | ~100ms | UI |
| Save to Gallery | image_gallery_saver_plus | ~30ms | Background |
| **Tổng** | | **~260ms** | |

---

## 🔒 7. Watermark & Brand Identity

### 7.1. Thiết Kế Watermark Tối Ưu Viral

```dart
class _CapcatWatermark extends StatelessWidget {
  const _CapcatWatermark();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
        // Glassmorphism backdrop
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo Capcat nhỏ
          Image.asset('assets/logo_capcat_white.png', width: 20, height: 20),
          const SizedBox(width: 6),
          const Text(
            'Capcat: Soul of Pet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
              fontFamily: 'Quicksand',
            ),
          ),
        ],
      ),
    );
  }
}
```

**Nguyên tắc watermark:**
- **Vị trí:** Bottom-right, cách mép 48px — không che nội dung chính
- **Style:** Semi-transparent, không phô trương — người xem thấy nhưng không bị chói
- **Không thể bị xóa:** Watermark được render trực tiếp vào canvas trước khi export, không phải overlay UI

---

## 📊 8. Viral Analytics & Growth Loop

### 8.1. Events Cần Track

```dart
// Events Firebase Analytics
const memeEvents = {
  'meme_studio_opened':    'Số lần vào Meme Studio',
  'meme_template_changed': 'Template nào được dùng nhiều nhất',
  'meme_exported':         'Số meme xuất thành công',
  'meme_shared_instagram': 'Số share vào Instagram',
  'meme_shared_tiktok':    'Số share vào TikTok',
  'meme_shared_other':     'Share qua app khác',
  'meme_install_via_link': 'Số install đến từ meme viral link',
};
```

### 8.2. Viral Coefficient Dashboard (Internal)

```
K-factor = (Share Rate) × (Install Rate from Share)
         = (% người dùng share) × (% người xem link tải app)

Mục tiêu tháng 1: K-factor ≥ 0.3
Mục tiêu tháng 3: K-factor ≥ 0.5
```

---

## 🔒 9. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1. **AC-1 (Non-intrusive):** Mở Hộp Ký Ức → Xác nhận ảnh Polaroid hiển thị 100% ảnh gốc, không có bất kỳ chồng lấp meme nào khi chưa Sen chủ động vào Meme Studio.

2. **AC-2 (Face Detection Speed):** Mở ảnh pet → Giao diện Meme Studio hiển thị với khuôn mặt Boss đã được khoanh vùng tự động trong ≤ 300ms.

3. **AC-3 (Face Detection Fallback):** Mở ảnh không có mặt rõ ràng → App hiện hướng dẫn thân thiện và cho Sen tự khoanh vùng bằng overlay circle kéo được.

4. **AC-4 (Canvas Interaction):** Kéo rê / Pinch zoom / Xoay khuôn mặt Boss trên canvas → Hoạt ảnh phản hồi ngay lập tức ≥ 60fps, không giật lag.

5. **AC-5 (Export Quality):** Xuất meme → File PNG kích thước 1080x1920 (Instagram Story chuẩn), kích thước file ≤ 2MB, watermark Capcat sắc nét không bị mờ.

6. **AC-6 (Instagram Story Direct):** Nhấn "Story Instagram" → App launch Instagram Story Creator với ảnh meme đã gán sẵn trong ≤ 2 giây (không phải chỉ native share sheet chung).

7. **AC-7 (Viral Link):** Deep link trong caption meme hoạt động → Click từ thiết bị khác → Mở App Store/Play Store → Sau khi cài app, hiển thị màn hình onboarding có mention đến meme nguồn.

8. **AC-8 (Original Preserved):** Sau khi share meme → Mở Gallery điện thoại → Xác nhận ảnh gốc của Boss vẫn còn nguyên vẹn, chưa bị chỉnh sửa.

---

*Tài liệu được thiết lập bởi Team Capcat — Bella (UI/UX), Alan (Tech Lead), Sophia (CPO), Arthur (Mom Test)*
*Rev 2.0 — Cập nhật đầy đủ tech stack, viral UX, và social share deep link integration.*
