# ĐẶC TẢ CHI TIẾT 08: NHẬN DIỆN CÁ THỂ PET — AI PHÂN BIỆT TỪNG BÉ
*(PET VISUAL FINGERPRINT ENGINE — INDIVIDUAL PET RECOGNITION)*

> **Mã Đặc Tả:** `SPEC-VAULT-08`
> **Chủ trì:** Alan (Tech Lead), Arthur (Mom Test), Sophia (CPO/PM)
> **Bài toán:** Khi Sen nuôi 2+ boss (VD: mèo Bánh Mỳ + mèo Bánh Cam), hệ thống quét ảnh offline phải tự nhận ra ảnh nào là bé nào để gắn tag đúng pet, phục vụ Hộp Ký Ức riêng biệt và Cozy Chat cá nhân hóa.
> **Ràng buộc:** 100% on-device, 0 đồng API, không gửi ảnh lên cloud

---

## 🧭 1. Phân Tích Vấn Đề (Problem Statement)

### 1.1. Tại Sao ML Kit Không Đủ?

Google ML Kit Image Labeling là bộ phân loại chung (generic classifier). Nó trả nhãn **loài** chứ không trả nhãn **cá thể**:

```
┌──────────────────────────────────────────────────────────────┐
│  ML Kit Image Labeling — Những gì nó LÀM ĐƯỢC              │
│  ✅ "Đây là con mèo" (Cat: 0.94)                           │
│  ✅ "Đây là con chó" (Dog: 0.91)                           │
│  ✅ "Con pet này đang ngủ" (Sleeping: 0.87)                │
│  ✅ "Xung quanh có giường" (Bed: 0.79)                     │
├──────────────────────────────────────────────────────────────┤
│  ML Kit Image Labeling — Những gì nó KHÔNG LÀM ĐƯỢC        │
│  ❌ "Đây là Bánh Mỳ, con mèo Anh lông ngắn tabby cam"     │
│  ❌ "Đây là Bánh Cam, con mèo Anh lông ngắn tabby xám"    │
│  ❌ Phân biệt 2 con mèo cùng giống, cùng màu              │
└──────────────────────────────────────────────────────────────┘
```

### 1.2. Tại Sao Phải Giải Quyết?

| Scenario | Nếu KHÔNG phân biệt | Nếu CÓ phân biệt |
| :--- | :--- | :--- |
| Hộp Ký Ức | Ảnh Bánh Mỳ + Bánh Cam trộn lẫn | Mỗi bé có album riêng |
| Cozy Chat | Boss ảo nói "trẫm" nhưng không biết bé nào | Boss Bánh Mỳ nói khác Boss Bánh Cam |
| Care Diary | Nhật ký chung lẫn lộn | Log chăm sóc riêng từng bé |
| Auto Caption | "Buổi chiều, một bé ngủ..." | "Buổi chiều, Bánh Mỳ ngủ mê man..." |

---

## 🏗️ 2. Chiến Lược Giải Quyết 3 Tầng (3-Tier Recognition Strategy)

Capcat giải bài toán này bằng **3 tầng bổ trợ lẫn nhau**, tầng sau chỉ kích hoạt khi tầng trước thất bại:

```
┌─────────────────────────────────────────────────────────────────────┐
│  TẦNG 1: SEN DẠY BÉ — "Bootstrap" Phase (5-10 ảnh đầu tiên)       │
│  Sen tag thủ công ảnh tham chiếu (reference photos) cho mỗi bé     │
│  → Hệ thống trích xuất "Visual Fingerprint" cho từng bé            │
│  → Chỉ cần 5 ảnh/bé, làm 1 lần duy nhất lúc onboarding           │
├─────────────────────────────────────────────────────────────────────┤
│  TẦNG 2: VISUAL FINGERPRINT — "Auto-Tag" Phase (quét ngầm hàng    │
│  ngày)                                                              │
│  So sánh ảnh mới với fingerprint đã học → gán tag pet_id tự động   │
│  → Confidence ≥ 0.75 → tự gắn tag                                 │
│  → Confidence 0.50 - 0.74 → "Trẫm hơi nghi... Đây là Bánh Mỳ    │
│    phải không Sen?" → Sen confirm 1 tap                             │
│  → Confidence < 0.50 → "Sen ơi, ảnh này là bé nào ạ?" → Sen chọn │
├─────────────────────────────────────────────────────────────────────┤
│  TẦNG 3: CÀI THIỆN LIÊN TỤC — "Self-Learning" Phase               │
│  Mỗi lần Sen confirm/sửa tag → feedback loop bổ sung ảnh tham     │
│  chiếu mới → fingerprint chính xác hơn theo thời gian              │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📸 3. Tầng 1: Sen Dạy Bé — Onboarding "Ảnh Tham Chiếu" (Reference Photo Bootstrap)

### 3.1. UX Flow — Tích Hợp Vào Onboarding Hiện Tại (US-1.1)

Khi Sen đăng ký Boss thứ 2+ trong app, onboarding sẽ thêm 1 bước nhỏ:

```
┌────────────────────────────────────────────┐
│  👑 Thêm Boss mới                          │
│                                            │
│  Tên: [ Bánh Cam ]                         │
│  Loài: 🐱 Mèo                              │
│  Giống: [ Mèo Anh lông ngắn ]              │
│                                            │
│  ─── BƯỚC MỚI ────────────────────────     │
│  📸 Cho trẫm xem mặt Bánh Cam đi Sen!      │
│                                            │
│  Chọn 3-5 ảnh rõ mặt của Bánh Cam          │
│  (góc chụp khác nhau càng tốt 📐)          │
│                                            │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐  │
│  │  📷  │ │  📷  │ │  📷  │ │  +  │ │  +  │  │
│  │  ✅  │ │  ✅  │ │  ✅  │ │     │ │     │  │
│  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘  │
│    3/5 ảnh — Đủ để trẫm nhớ mặt! 🧠       │
│                                            │
│           [ Tiếp tục ▶ ]                   │
└────────────────────────────────────────────┘
```

**Nguyên tắc UX:**
- Tối thiểu **3 ảnh** (đủ tin cậy), lý tưởng **5 ảnh** (chính xác hơn)
- Ảnh chụp ở **góc khác nhau**: mặt trước, mặt nghiêng, toàn thân
- Gợi ý: *"Ảnh nào thấy rõ mặt và lông của Bánh Cam nhất thì chọn nha Sen!"*
- **Bé đầu tiên (Boss 1):** Không cần bootstrap vì chỉ có 1 bé → mọi ảnh pet đều là bé đó

### 3.2. Khi Nào Bước Này Được Kích Hoạt?

```
Số lượng Pet đăng ký:
  1 bé  → KHÔNG CẦN bootstrap (mọi ảnh pet = bé đó, 100% chính xác)
  2 bé  → Kích hoạt bootstrap cho BÉ THỨ 2 + hồi tố lấy ảnh cho BÉ 1
  3+ bé → Mỗi bé mới phải qua bootstrap
```

---

## 🧬 4. Tầng 2: Visual Fingerprint Engine — Giải Pháp Kỹ Thuật Cốt Lõi

### 4.1. Công Nghệ: TFLite MobileNetV3 Feature Extraction (On-Device)

**Thư viện:** `tflite_flutter: ^0.10.4`
**Model:** MobileNetV3-Small (pre-trained ImageNet) — chỉ 2.5MB
**Chạy:** 100% trên thiết bị, không cần internet

```yaml
# pubspec.yaml
dependencies:
  tflite_flutter: ^0.10.4
```

**Tại sao MobileNetV3?**
| Tiêu chí | MobileNetV3 ✅ | MobileNetV2 | EfficientNet |
| :--- | :--- | :--- | :--- |
| Model size | **2.5 MB** | 6.9 MB | 20+ MB |
| Inference time (mobile) | **~12ms** | ~25ms | ~60ms |
| Feature vector quality | Tốt | Tốt | Rất tốt |
| Battery impact | **Cực nhỏ** | Nhỏ | Trung bình |
| Phù hợp Capcat | ✅ **Tối ưu** | Chấp nhận | Quá nặng |

### 4.2. Pipeline Trích Xuất "Dấu Vân Pháp" (Fingerprint Extraction Pipeline)

```dart
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class PetFingerprintExtractor {
  late Interpreter _interpreter;
  static const int _inputSize = 224;        // MobileNetV3 input: 224x224
  static const int _embeddingDim = 1024;     // Feature vector dimension

  /// Khởi tạo model từ asset (chỉ load 1 lần)
  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/mobilenet_v3_small.tflite',
    );
  }

  /// Trích xuất embedding vector từ 1 ảnh pet
  /// Output: Float32List[1024] — "dấu vân pháp thị giác" của bé
  Future<Float32List> extractFingerprint(Uint8List imageBytes) async {
    // Resize ảnh về 224x224
    final inputTensor = _preprocessImage(imageBytes, _inputSize);

    // Chạy inference — chỉ mất ~12ms trên thiết bị trung bình
    final output = List.filled(1 * _embeddingDim, 0.0).reshape([1, _embeddingDim]);
    _interpreter.run(inputTensor, output);

    // Normalize vector (L2 norm) để cosine similarity chính xác
    final embedding = Float32List.fromList(output[0].cast<double>().map((e) => e.toDouble()).toList());
    return _l2Normalize(embedding);
  }

  /// So sánh 2 fingerprint bằng Cosine Similarity
  /// Kết quả: 0.0 (khác hoàn toàn) → 1.0 (giống hệt)
  static double cosineSimilarity(Float32List a, Float32List b) {
    double dotProduct = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
    }
    return dotProduct; // Đã L2-normalize nên dot product = cosine sim
  }

  /// L2 Normalize — chuẩn hóa vector để magnitude = 1
  Float32List _l2Normalize(Float32List vector) {
    double norm = 0.0;
    for (final v in vector) {
      norm += v * v;
    }
    norm = sqrt(norm);
    if (norm == 0) return vector;
    return Float32List.fromList(vector.map((v) => v / norm).toList());
  }
}
```

### 4.3. Cách "Dạy" App Nhận Diện Từng Bé

**Giai đoạn Bootstrap (1 lần khi thêm pet mới):**

```
Sen chọn 5 ảnh tham chiếu của Bánh Mỳ
          │
          ▼ (Chạy MobileNetV3 trên từng ảnh)
  embedding_1 = [0.12, 0.87, -0.34, ...]  // Ảnh 1
  embedding_2 = [0.15, 0.82, -0.31, ...]  // Ảnh 2
  embedding_3 = [0.11, 0.89, -0.36, ...]  // Ảnh 3
  embedding_4 = [0.13, 0.85, -0.33, ...]  // Ảnh 4
  embedding_5 = [0.14, 0.86, -0.35, ...]  // Ảnh 5
          │
          ▼ (Tính trung bình)
  centroid_banh_my = MEAN(embedding_1..5)
                   = [0.13, 0.858, -0.338, ...]
          │
          ▼ (Lưu vào SQLite)
  INSERT INTO pet_visual_fingerprints (pet_id, centroid_vector, reference_count)
  VALUES ('banh_my_001', '[0.13, 0.858, ...]', 5);
```

**Giai đoạn Auto-Tag (quét ngầm hàng ngày):**

```
Ảnh mới chụp hôm nay
          │
          ▼ (ML Kit: Đây có phải pet? → CÓ, Cat: 0.92)
          │
          ▼ (MobileNetV3 Extract Fingerprint)
  new_embedding = [0.11, 0.86, -0.35, ...]
          │
          ▼ (So sánh với CENTROID của từng bé)
  cosine_sim(new, centroid_banh_my)  = 0.94  ← CAO → Đây là Bánh Mỳ!
  cosine_sim(new, centroid_banh_cam) = 0.41  ← THẤP → Không phải Bánh Cam
          │
          ▼
  GẮN TAG: pet_id = 'banh_my_001'
```

---

## 🗄️ 5. Thiết Kế Cơ Sở Dữ Liệu (Database Schema)

### 5.1. Bảng `pet_visual_fingerprints` — Lưu Dấu Vân Pháp Của Mỗi Bé

```sql
CREATE TABLE pet_visual_fingerprints (
    pet_id          VARCHAR(64) PRIMARY KEY,        -- ID pet liên kết với PetDetail
    pet_name        VARCHAR(64) NOT NULL,            -- Tên hiển thị (Bánh Mỳ, Bánh Cam)
    pet_type        VARCHAR(16) NOT NULL,            -- 'cat', 'dog'
    centroid_vector BLOB NOT NULL,                   -- Float32 vector trung bình [1024 dims]
    reference_count INTEGER DEFAULT 0,               -- Số ảnh tham chiếu đã dùng để tính centroid
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recognition_accuracy REAL DEFAULT 0.0            -- Độ chính xác tích lũy (auto-updated)
);
```

### 5.2. Bảng `pet_reference_photos` — Lưu Ảnh Tham Chiếu Gốc

```sql
CREATE TABLE pet_reference_photos (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    pet_id          VARCHAR(64) NOT NULL,            -- FK → pet_visual_fingerprints.pet_id
    local_asset_id  VARCHAR(128) NOT NULL,           -- ID ảnh gốc
    embedding_vector BLOB NOT NULL,                  -- Float32 vector của ảnh này [1024 dims]
    source          VARCHAR(16) DEFAULT 'bootstrap', -- 'bootstrap' (lúc onboarding), 'confirmed' (Sen xác nhận lúc dùng)
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pet_id) REFERENCES pet_visual_fingerprints(pet_id)
);
```

### 5.3. Cập Nhật Bảng `local_photo_intelligence_cache` — Thêm Cột `matched_pet_id`

```sql
ALTER TABLE local_photo_intelligence_cache
  ADD COLUMN matched_pet_id VARCHAR(64) DEFAULT NULL;     -- Pet nào được nhận diện
  ADD COLUMN match_confidence REAL DEFAULT NULL;           -- Độ tin cậy matching (0.0 - 1.0)
  ADD COLUMN match_source VARCHAR(16) DEFAULT NULL;        -- 'auto' (máy đoán), 'user_confirmed' (Sen tag)
```

---

## 🎭 6. UX "Hỏi Sen" Khi Không Chắc (Gentle Confirmation UX)

### 6.1. Ba Mức Confidence & Hành Vi Tương Ứng

```
Confidence ≥ 0.75 — TỰ TIN → Auto-tag không hỏi
──────────────────────────────────────────────────
  Gắn pet_id ngay, match_source = 'auto'
  Hiển thị trên thẻ Polaroid: "📸 Bánh Mỳ — 29/05"

Confidence 0.50 – 0.74 — HƠI NGHI → Hỏi nhẹ nhàng
──────────────────────────────────────────────────
  ┌──────────────────────────────────────┐
  │  [Ảnh preview nhỏ]                  │
  │  Đây là Bánh Mỳ phải không Sen? 🤔  │
  │                                      │
  │  [ ✅ Đúng rồi ]  [ ❌ Không phải ] │
  └──────────────────────────────────────┘
  → 1 tap xác nhận, tối đa 2 giây
  → Nếu sai: "Vậy đây là bé nào ạ?" → Hiện danh sách pet

Confidence < 0.50 — KHÔNG BIẾT → Hỏi thẳng
──────────────────────────────────────────────────
  ┌──────────────────────────────────────┐
  │  [Ảnh preview nhỏ]                  │
  │  Sen ơi, ảnh này là bé nào ạ? 🐾    │
  │                                      │
  │  [ 🐱 Bánh Mỳ ]  [ 🐱 Bánh Cam ]   │
  │  [ 🐶 Lucky ]    [ ❓ Bé khác ]     │
  └──────────────────────────────────────┘
```

### 6.2. Khi Nào Hiện Hỏi? (Timing)

**KHÔNG BAO GIỜ** gián đoạn trải nghiệm vuốt Tinder Stack. Các câu hỏi xác nhận chỉ hiện trong 2 trường hợp:
1. **Khi Sen lật mặt sau Polaroid** → Thấy tag pet không đúng → nhấn sửa
2. **Trong phiên quét ngầm → queue lại → hỏi gom khi Sen mở Hộp Ký Ức lần tới** (batch confirmation)

```
Sen mở Hộp Ký Ức
          │
          ▼ (Có 3 ảnh chờ xác nhận từ quét ngầm đêm qua)
  ┌──────────────────────────────────────┐
  │  Trẫm tìm được 3 ảnh mới! 🐾       │
  │  Giúp trẫm phân biệt nha Sen~       │
  │                                      │
  │  [Ảnh 1] → Bánh Mỳ ✅  Bánh Cam     │
  │  [Ảnh 2] → Bánh Mỳ     Bánh Cam ✅  │
  │  [Ảnh 3] → Bánh Mỳ ✅  Bánh Cam     │
  │                                      │
  │          [ Xong! 💛 ]               │
  └──────────────────────────────────────┘

→ Swipe qua nhanh, 3 ảnh chỉ mất ~5 giây
→ Sau khi xong, ảnh được gắn tag đúng + bổ sung vào reference photos
```

---

## 🔄 7. Tầng 3: Vòng Lặp Tự Cải Thiện (Self-Learning Feedback Loop)

### 7.1. Feedback Loop — Càng Dùng Càng Chính Xác

```
Sen xác nhận "Đây là Bánh Mỳ" (ảnh mới)
          │
          ▼
  Thêm embedding ảnh mới vào pet_reference_photos
  reference_count: 5 → 6
          │
          ▼
  Tính lại centroid_vector = MEAN(embedding_1..6)
  (Trung bình cộng mới chính xác hơn trung bình cũ)
          │
          ▼
  Lần quét sau → match_confidence tăng lên
```

### 7.2. Giới Hạn Reference Photos (Tránh Quá Tải)

```dart
const maxReferencePhotosPerPet = 30;

// Khi đạt 30 ảnh tham chiếu → Áp dụng "Sliding Window"
// Giữ 15 ảnh gần nhất + 15 ảnh có embedding đa dạng nhất (diverse sampling)
// → Centroid luôn đại diện tốt nhất cho ngoại hình hiện tại của bé
//   (lông mọc dài hơn, lớn hơn, béo/gầy hơn theo thời gian)
```

### 7.3. Accuracy Tracking

```sql
-- Cập nhật sau mỗi lần Sen confirm/sửa tag
UPDATE pet_visual_fingerprints SET
  recognition_accuracy = (
    SELECT CAST(
      SUM(CASE WHEN match_source = 'auto' AND matched_pet_id = :pet_id THEN 1 ELSE 0 END)
      AS REAL
    ) / COUNT(*)
    FROM local_photo_intelligence_cache
    WHERE matched_pet_id = :pet_id
  )
WHERE pet_id = :pet_id;
```

---

## 🔬 8. Kịch Bản Phức Tạp & Edge Cases

### 8.1. Hai Bé Cùng Giống, Cùng Màu (Worst Case)

**VD:** 2 con mèo Anh lông ngắn tabby cam giống nhau 90%.

**Giải pháp:** MobileNetV3 trích xuất đặc trưng chi tiết hơn mắt người: pattern vằn lông, hình dạng tai, tỷ lệ khuôn mặt, vệt đốm trên mũi. Với 10+ ảnh tham chiếu, cosine similarity phân biệt được ở mức:
- **Hai bé khác giống:** Accuracy > 95%
- **Hai bé cùng giống, khác màu:** Accuracy > 90%
- **Hai bé cùng giống, cùng màu:** Accuracy ~75-80% → **cần Sen confirm nhiều hơn** lúc đầu, sẽ cải thiện theo thời gian khi tích lũy đủ reference photos

### 8.2. Ảnh Có 2+ Bé Trong Cùng 1 Khung Hình

```
  [Ảnh: Bánh Mỳ + Bánh Cam đang ngủ chung]
          │
          ▼ (ML Kit detect 2 khu vực pet trong ảnh)
  Region 1: crop vùng trái → fingerprint → Bánh Mỳ (0.89)
  Region 2: crop vùng phải → fingerprint → Bánh Cam (0.82)
          │
          ▼
  GẮN MULTI-TAG: matched_pet_ids = ['banh_my_001', 'banh_cam_002']
  Auto Caption: "Buổi chiều bình yên, Bánh Mỳ và Bánh Cam
                 cùng nhau ngủ trên góc sofa cũ..."
```

### 8.3. Boss Mới Thêm Vào (Nhận Nuôi Bé Mới)

```
Sen thêm pet thứ 3: "Lucky" (chó Golden)
          │
          ▼ (Bootstrap: chọn 5 ảnh Lucky)
          │
          ▼ (Hệ thống tự động quét lại ảnh CŨ trong cache)
  Những ảnh cũ đã tag pet_type = 'dog' mà chưa có pet_id
  → So sánh fingerprint với centroid Lucky mới
  → Gắn tag hồi tố cho ảnh cũ nếu match
```

### 8.4. Bé Thay Đổi Ngoại Hình Theo Thời Gian

Pet con lớn lên, lông đổi màu, béo/gầy hơn. Centroid cần cập nhật liên tục:

```dart
// Sliding Window: Chỉ dùng 30 ảnh reference gần nhất
// → Centroid tự "trôi" theo ngoại hình hiện tại
// → Ảnh lúc bé 2 tháng tuổi vẫn khớp nhờ overlap gradual
//
// Timeline:  [2 tháng] → [4 tháng] → [6 tháng] → [12 tháng]
//            centroid_v1  centroid_v2  centroid_v3  centroid_v4
//            (lông ngắn)  (lông dài)   (béo hơn)   (trưởng thành)
//
// Mỗi phiên bản centroid overlap embedding với phiên bản trước
// → Chuỗi liên tục, không bao giờ "quên" bé mình
```

---

## ⚡ 9. Performance Budget

| Tác vụ | Thời gian | Tần suất | Battery Impact |
| :--- | :--- | :--- | :--- |
| Load MobileNetV3 model (1 lần) | ~200ms | Khởi động app | Không đáng kể |
| Extract 1 embedding | ~12ms | Mỗi ảnh quét ngầm | Cực nhỏ |
| Cosine similarity (1 so sánh) | < 0.1ms | Mỗi ảnh × số pet | Bằng 0 |
| Tính lại centroid (30 vectors) | < 1ms | Khi có feedback | Bằng 0 |
| **Tổng per ảnh** | **~15ms** | | **Không cảm nhận được** |

**So sánh:** ML Kit Image Labeling hiện tại mất ~80ms/ảnh. Thêm fingerprint chỉ mất thêm ~15ms → **tổng ~95ms/ảnh** — vẫn cực nhanh.

---

## 🔗 10. Tích Hợp Với Hệ Thống Hiện Tại

### 10.1. Cập Nhật Pipeline Quét Ngầm (SPEC-02, Section 4)

Pipeline quét ngầm hiện tại sẽ thêm 1 bước mới:

```
[ Background Scan — Đêm khuya, Sen đi ngủ ]
          │
   Bước 1: ML Kit Image Labeling — "Đây có phải pet?" (hiện tại)
          │
   Bước 2: ML Kit Action/Context — "Đang làm gì? Ở đâu?" (hiện tại)
          │
   Bước 3: ★ MỚI ★ Pet Fingerprint — "Đây là bé nào?" (SPEC-08)
          │
   Bước 4: Auto Poetic Caption — kèm tên bé (SPEC-02 Section 6)
          │
          ▼
  [ Lưu vào local_photo_intelligence_cache với matched_pet_id ]
```

### 10.2. Auto Caption Nâng Cấp — Gọi Tên Bé

**Trước (không có SPEC-08):**
> *"Buổi chiều lơ đãng, trẫm đang ngủ mê man trên chiếc gối quen."*

**Sau (có SPEC-08):**
> *"Buổi chiều lơ đãng, Bánh Mỳ đang ngủ mê man trên chiếc gối quen."*

### 10.3. Hộp Ký Ức Multi-Pet Filter (SPEC-01, SPEC-05)

```
┌──────────────────────────────────────────────────────────┐
│  📦 Hộp Ký Ức                                            │
│                                                          │
│  [ Tất cả 🐾 ] | [ 🐱 Bánh Mỳ ] | [ 🐱 Bánh Cam ]      │
│                                                          │
│  (Khi chọn "Bánh Mỳ" → chỉ hiện ảnh có matched_pet_id   │
│   = 'banh_my_001')                                       │
└──────────────────────────────────────────────────────────┘
```

### 10.4. Cozy Chat — Mỗi Bé Một Cuộc Hội Thoại

Khi inject `<pet_memory_context>` vào Cozy Chat prompt, giờ có thêm pet identity:

```xml
<pet_memory_context>
  <active_pet id="banh_my_001" name="Bánh Mỳ" />
  <memory asset_id="abc123" pet="Bánh Mỳ"
    action="sleeping" context="bed" time="14:30" season="hè" />
  <memory asset_id="def456" pet="Bánh Cam"
    action="playing" context="sofa" time="09:15" season="xuân" />
</pet_memory_context>
```

→ Boss Bánh Mỳ nói: *"Nhớ hôm đó trẫm ngủ ngon lắm luôn ấy Sen..."*
→ Boss Bánh Cam nói (nếu chat riêng): *"Bánh Mỳ nó toàn ngủ, chứ trẫm thì chơi nhiều hơn!"*

---

## 🔒 11. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1. **AC-1 (Bootstrap UX):** Thêm Boss thứ 2 → Onboarding hiện bước chọn ảnh tham chiếu → Chọn 3 ảnh → Hệ thống xác nhận "Trẫm đã nhớ mặt Bánh Cam rồi!" trong ≤ 3 giây.

2. **AC-2 (Auto-Tag Accurate):** Quét ngầm ảnh có 1 bé → Gắn đúng pet_id với confidence ≥ 0.75 cho ≥ 85% ảnh (đo trên tập test 50 ảnh, 2 bé khác giống).

3. **AC-3 (Gentle Confirm):** Ảnh có confidence 0.50-0.74 → Hiện prompt xác nhận nhẹ nhàng khi Sen mở Hộp Ký Ức → Sen confirm bằng 1 tap → Tag được gắn và feedback loop cập nhật centroid.

4. **AC-4 (Multi-Pet Photo):** Ảnh có 2 bé trong cùng khung hình → Cả 2 pet_id đều được gắn → Ảnh hiện trong album của cả 2 bé.

5. **AC-5 (Performance):** Thêm bước fingerprint extraction vào pipeline quét ngầm → Xác nhận tổng thời gian quét 1 ảnh ≤ 100ms (ML Kit 80ms + Fingerprint 15ms + overhead).

6. **AC-6 (Single Pet Bypass):** Chỉ có 1 Boss đăng ký → Xác nhận app KHÔNG hiện bước bootstrap, KHÔNG chạy fingerprint matching → Tất cả ảnh pet tự động gắn pet_id duy nhất.

7. **AC-7 (Self-Learning):** Sen sửa tag sai 5 lần → Xác nhận centroid được cập nhật → Các ảnh tiếp theo có cùng bé đạt confidence cao hơn trước khi sửa.

---

*Tài liệu được thiết lập bởi Team Capcat — Alan (Tech Lead), Arthur (Mom Test), Sophia (CPO)*
*Kết luận: ML Kit alone KHÔNG ĐỦ để phân biệt cá thể. Cần tích hợp TFLite MobileNetV3 Feature Extraction + Cosine Similarity + Human-in-the-Loop bootstrap.*
