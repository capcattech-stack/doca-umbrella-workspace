# ĐẶC TẢ CHI TIẾT 07: NHẬT KÝ CHĂM SÓC BOSS (CARE DIARY ENGINE)
*(CARE EVENT LOG & TIMELINE INTEGRATION)*

> **Mã Đặc Tả:** `SPEC-VAULT-07`
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead), Arthur (Mom Test)
> **Phạm vi:** Ghi nhận các sự kiện chăm sóc định kỳ của thú cưng theo dòng thời gian, tích hợp liền mạch vào Hộp Ký Ức và Cozy Chat.
> **Ranh giới:** ⚠️ KHÔNG phải hồ sơ y tế. KHÔNG có chẩn đoán. KHÔNG có tư vấn thuốc. Chỉ là **nhật ký sự kiện cuộc sống** của Boss.

---

## 🧭 1. Triết Lý Thiết Kế (Design Philosophy)

### 1.1. Định Nghĩa Đúng Sản Phẩm

Đây **KHÔNG PHẢI** một tính năng y tế. Đây là một **cuốn sổ tay kỷ niệm** (life scrapbook) mà tình cờ có thể ghi nhớ ngày tắm, ngày tiêm.

```
❌ Hồ sơ y tế kỹ thuật số   →  Người dùng sợ, cảm giác bệnh viện
✅ Nhật Ký Chăm Sóc Boss    →  Người dùng thích, cảm giác viết diary cho con cưng
```

### 1.2. Nguyên Tắc Bất Di Bất Dịch (Non-Negotiable Rules)

| ✅ CAPCAT LÀM | ❌ CAPCAT KHÔNG BAO GIỜ LÀM |
| :--- | :--- |
| Ghi ngày tháng sự kiện | Ghi tên thuốc / liều lượng |
| Ghi tên sự kiện (tắm, tiêm ngừa) | Đưa ra chẩn đoán bệnh |
| Ghi ghi chú ngắn của Sen | Tư vấn y tế dựa trên lịch sử log |
| Nhắc nhở theo chu kỳ người dùng tự thiết lập | Cảnh báo y tế tự động từ dữ liệu log |
| Hiển thị dòng thời gian chăm sóc | Chia sẻ dữ liệu log với bên thứ ba |

> **Nguyên tắc "Ghi chú của Mẹ":** Chuẩn thiết kế tham chiếu là quyển sổ tay một người mẹ ghi cho con: *"Hôm nay bé đi tiêm rồi, tắm xong thấy bé vui hơn"* — không phải bệnh án bệnh viện.

---

## 📦 2. Danh Mục Sự Kiện (Care Event Taxonomy)

### 2.1. 16 Loại Sự Kiện Tiêu Biểu (Phân 4 Nhóm)

| Nhóm | Icon | Tên Sự Kiện | `event_type` Code | Chu Kỳ Gợi Ý |
| :--- | :---: | :--- | :--- | :--- |
| **🛁 Làm Đẹp** | 🛁 | Tắm | `BATH` | 1-4 tuần |
| | ✂️ | Cắt lông / Cạo lông | `GROOMING` | 4-8 tuần |
| | 💅 | Cắt móng | `NAIL_TRIM` | 2-4 tuần |
| | 🦷 | Vệ sinh răng | `TEETH_CLEAN` | 1-2 tuần |
| **💊 Sức Khỏe** | 💉 | Tiêm ngừa | `VACCINATION` | Theo lịch tiêm |
| | 💊 | Sổ giun / Uống thuốc | `DEWORMING` | 3-6 tháng |
| | 🏥 | Khám định kỳ | `VET_CHECKUP` | 6-12 tháng |
| | 🤒 | Hôm nay Boss không khỏe | `FEELING_UNWELL` | *(không áp dụng)* |
| **🍽️ Cuộc Sống** | 🍖 | Đổi thức ăn mới | `FOOD_CHANGE` | *(không áp dụng)* |
| | 🏠 | Chuyển nhà | `RELOCATION` | *(không áp dụng)* |
| | 😻 | Kết bạn Pet mới | `NEW_PET_FRIEND` | *(không áp dụng)* |
| | 🌿 | Ra ngoài / Dạo chơi | `OUTDOOR_TRIP` | *(không áp dụng)* |
| **🌟 Cột Mốc** | 🎂 | Sinh nhật Boss | `BIRTHDAY` | Hàng năm |
| | 🏆 | Lần đầu tiên... | `FIRST_TIME` | *(không áp dụng)* |
| | 💛 | Kỷ niệm ngày đón Boss về | `ADOPTION_ANNIVERSARY` | Hàng năm |
| | ✏️ | Sự kiện tùy chỉnh | `CUSTOM` | Tùy chỉnh |

> **Lưu ý thiết kế:** Danh mục `FEELING_UNWELL` (🤒 Hôm nay Boss không khỏe) chỉ là một nhãn cảm xúc. Khi Sen chọn nhãn này, app sẽ **KHÔNG** hiện ra form nhập triệu chứng y tế. Thay vào đó, Boss ảo sẽ hỏi thăm: *"Ôi trẫm không khỏe à... Sen có muốn trẫm giúp tìm phòng khám gần nhà không?"* — chuyển tiếp sang Safe-Vet AI nếu cần.

---

## 🎨 3. Giao Diện Người Dùng (UI/UX Design)

### 3.1. Entry Point — Cách Sen Thêm Sự Kiện

**Ba cách vào tính năng này:**

```
Cách 1: Nút FAB (+) trong Hộp Ký Ức
──────────────────────────────────────
Sen mở Hộp Ký Ức → Nhấn FAB màu pastel ở góc phải → Chọn
"📸 Thêm ảnh" hoặc "📋 Thêm sự kiện" → Mở Care Event Picker

Cách 2: Shortcut từ màn hình Home
──────────────────────────────────────
Widget "Hôm nay Boss..." có 4 icon sự kiện nhanh phổ biến nhất
(🛁 🚿 💊 ✂️) để log sự kiện trong 1 chạm

Cách 3: Cozy Chat Auto-Detection (MAGIC ✨)
──────────────────────────────────────────────
Sen nhắn: "Hôm nay Boss được tắm rồi~"
Boss ảo: "Ôi trẫm thơm lắm không ạ! 🛁 Sen muốn trẫm ghi
          nhớ ngày tắm hôm nay vào Nhật Ký không?"
Sen: "Có"
Boss ảo: "Xong rồi ạ! Đã lưu vào Nhật Ký Chăm Sóc ngày 29/05 💛"
```

### 3.2. Luồng Thêm Sự Kiện Thủ Công (Manual Add Flow)

```
Bước 1: Care Event Picker (Bottom Sheet)
──────────────────────────────────────────
┌────────────────────────────────────────┐
│  📋 Hôm nay Boss có gì đặc biệt?      │
│                                        │
│  🛁 Làm Đẹp          💊 Sức Khỏe     │
│  ┌──────┐ ┌──────┐   ┌──────┐ ┌──────┐│
│  │  🛁  │ │  ✂️  │   │  💉  │ │  💊  ││
│  │ Tắm  │ │Cắt   │   │Tiêm  │ │Sổ    ││
│  │      │ │lông  │   │ngừa  │ │giun  ││
│  └──────┘ └──────┘   └──────┘ └──────┘│
│                                        │
│  🍽️ Cuộc Sống        🌟 Cột Mốc      │
│  ┌──────┐ ┌──────┐   ┌──────┐ ┌──────┐│
│  │  🍖  │ │  🌿  │   │  🎂  │ │  ✏️  ││
│  │Đổi   │ │Dạo   │   │Sinh  │ │Tùy   ││
│  │thức  │ │chơi  │   │nhật  │ │chỉnh ││
│  └──────┘ └──────┘   └──────┘ └──────┘│
└────────────────────────────────────────┘

Bước 2: Confirm Card (Siêu nhanh — chỉ 2 trường)
──────────────────────────────────────────────────
┌────────────────────────────────────────┐
│  🛁 Tắm                               │
│                                        │
│  📅 Ngày: [Hôm nay — 29/05/2026]  🗓️  │
│  ✍️ Ghi chú: [Tắm bằng sữa tắm mới]  │
│            (tuỳ chọn, tối đa 80 ký tự)│
│                                        │
│         [ Lưu vào Nhật Ký 💛 ]        │
└────────────────────────────────────────┘

→ Tổng thời gian: dưới 5 giây
```

### 3.3. Hiển Thị Trong Hộp Ký Ức — Event Card

Sự kiện được hiển thị xen kẽ với ảnh Polaroid trên timeline, dưới dạng **Event Card** riêng biệt:

```
Thiết kế Event Card:
──────────────────────────────────────────────────
┌──────────────────────────────────────────────────┐
│  [Icon lớn]  [Tên sự kiện]           [Ngày] 🗓️  │
│     🛁         Tắm                    29/05       │
│                                                    │
│  "Tắm bằng sữa tắm mới, Boss vẫy đuôi suốt" ✍️  │
│                                                    │
│  [💬 Boss nói]                                   │
│  "Hôm đó trẫm thơm như hoa hồng ấy~" 🌸          │
└──────────────────────────────────────────────────┘

Màu nền card theo nhóm:
  🛁 Làm Đẹp   → Lavender nhạt  #EDE7F6
  💊 Sức Khỏe  → Mint nhạt      #E8F5E9
  🍽️ Cuộc Sống → Peach nhạt     #FFF3E0
  🌟 Cột Mốc   → Gold nhạt      #FFFDE7
```

### 3.4. Reminder System (Nhắc Nhở Thông Minh)

Với các sự kiện có chu kỳ (tắm, cắt móng, tiêm ngừa...), sau khi lưu Sen được hỏi:
```
"Sen có muốn trẫm nhắc lại sau X tuần không? 🔔"
  [Không cần]     [Nhắc sau 2 tuần]     [Tùy chỉnh...]
```
Notification text khi đến hạn (giọng Boss ảo):
> *"Sen ơi, đã X tuần rồi kể từ lần tắm của trẫm... Mùi trẫm đang hơi khác rồi đấy ạ 👃"*

---

## 🗄️ 4. Thiết Kế Cơ Sở Dữ Liệu (Database Schema)

### 4.1. Bảng SQLite: `care_diary_events`

```sql
CREATE TABLE care_diary_events (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    pet_id        VARCHAR(64) NOT NULL,             -- ID thú cưng
    event_type    VARCHAR(32) NOT NULL,             -- Mã loại sự kiện (BATH, VACCINATION...)
    event_icon    VARCHAR(8)  NOT NULL,             -- Emoji icon ('🛁', '💉'...)
    event_label   VARCHAR(64) NOT NULL,             -- Tên hiển thị ('Tắm', 'Tiêm ngừa'...)
    event_group   VARCHAR(16) NOT NULL,             -- Nhóm: 'GROOMING', 'HEALTH', 'LIFE', 'MILESTONE'
    user_note     TEXT,                             -- Ghi chú của Sen (tuỳ chọn, tối đa 200 ký tự)
    event_date    DATE NOT NULL,                    -- Ngày sự kiện xảy ra (YYYY-MM-DD)
    reminder_days INTEGER DEFAULT NULL,             -- Số ngày sau sẽ nhắc lại (NULL = không nhắc)
    reminder_sent INTEGER DEFAULT 0,               -- 0 = chưa gửi, 1 = đã gửi
    source        VARCHAR(16) DEFAULT 'manual',    -- Nguồn tạo: 'manual', 'chat_ai', 'reminder'
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    synced_at     TIMESTAMP DEFAULT NULL           -- Thời điểm sync lên cloud
);

-- Index để query nhanh theo pet và thời gian
CREATE INDEX idx_care_events_pet_date ON care_diary_events(pet_id, event_date DESC);
CREATE INDEX idx_care_events_reminder ON care_diary_events(reminder_days, reminder_sent, event_date);
```

### 4.2. Cấu Trúc JSON Cho Cozy Chat Bridge

Khi Boss ảo cần đề cập đến lịch sử chăm sóc trong cuộc trò chuyện, payload sau được inject vào LLM prompt:

```json
{
  "pet_care_timeline": {
    "recent_events": [
      {
        "event_type": "BATH",
        "event_label": "Tắm",
        "event_date": "2026-05-29",
        "days_ago": 0,
        "user_note": "Tắm bằng sữa tắm mới"
      },
      {
        "event_type": "VACCINATION",
        "event_label": "Tiêm ngừa",
        "event_date": "2026-04-15",
        "days_ago": 44,
        "user_note": null
      },
      {
        "event_type": "GROOMING",
        "event_label": "Cắt lông",
        "event_date": "2026-04-01",
        "days_ago": 58,
        "user_note": "Cắt kiểu mới trông cute lắm"
      }
    ],
    "upcoming_reminders": [
      {
        "event_type": "NAIL_TRIM",
        "event_label": "Cắt móng",
        "due_date": "2026-06-05",
        "days_until": 7
      }
    ]
  }
}
```

**Ví dụ Boss ảo dùng dữ liệu này:**
> Sen nhắn: *"Hôm nay Boss trông xinh ghê"*
> Boss ảo: *"Dạ! Trẫm mới được tắm bằng sữa tắm mới hôm qua mà~ Hơi thơm lắm đó Sen 🌸 À mà 7 ngày nữa là đến hạn cắt móng rồi đó ạ!"*

---

## 🤖 5. Tích Hợp Cozy Chat — Auto-Detection Intent

### 5.1. Từ Khóa Trigger Phát Hiện Tự Động

Hệ thống Cozy Chat phân tích tin nhắn của Sen để phát hiện **Care Event Intent** và đề nghị ghi nhật ký:

```dart
// Mapping từ khóa → Event Type (tiếng Việt + các biến thể)
const careEventKeywordMap = {
  EventType.BATH: [
    'tắm', 'tắm rồi', 'được tắm', 'vừa tắm', 'tắm xong',
    'mới tắm', 'tắm bằng', 'thơm rồi', 'sạch rồi',
  ],
  EventType.GROOMING: [
    'cắt lông', 'cạo lông', 'tỉa lông', 'cắt tóc',
    'grooming', 'đi cắt', 'mới cắt',
  ],
  EventType.VACCINATION: [
    'tiêm', 'tiêm ngừa', 'tiêm phòng', 'chích ngừa',
    'đi tiêm', 'vừa tiêm', 'tiêm rồi',
  ],
  EventType.DEWORMING: [
    'sổ giun', 'uống thuốc giun', 'tẩy giun',
    'giun', 'uống thuốc', 'cho uống thuốc',
  ],
  EventType.VET_CHECKUP: [
    'khám', 'đi khám', 'bác sĩ', 'thú y', 'phòng khám',
    'vừa khám', 'mới khám', 'khám xong',
  ],
  EventType.NAIL_TRIM: [
    'cắt móng', 'cắt vuốt', 'tỉa móng',
  ],
  EventType.OUTDOOR_TRIP: [
    'đi dạo', 'ra ngoài', 'đi chơi', 'dẫn đi',
    'đi công viên', 'đi siêu thị', 'đưa đi',
  ],
};
```

### 5.2. Luồng Xử Lý Chat Intent → Auto-Log

```
Sen nhắn: "Hôm nay Boss được tắm rồi nha 🛁"
                    │
                    ▼ (NLP Intent Detection)
         Phát hiện từ khóa "được tắm"
         → Intent: BATH | confidence: 0.95
                    │
                    ▼ (Boss ảo phản hồi)
    "Ôi trẫm thơm rồi ạ! 🛁 Sen muốn trẫm ghi
     vào Nhật Ký Chăm Sóc không? 💛"
                    │
         ┌──────────┴──────────┐
         │                     │
       Sen: "Có"            Sen: "Thôi"
         │                     │
         ▼                     ▼
  Tạo event BATH         Không làm gì
  date = TODAY           Boss: "Okk vậy Sen~"
         │
         ▼
  Boss: "Xong rồi ạ! Đã lưu ngày
  tắm hôm nay 29/05 vào Nhật Ký 💾"
```

---

## 🔔 6. Hệ Thống Nhắc Nhở (Smart Reminder Engine)

### 6.1. Reminder Push Notification Templates

Tất cả notification viết theo giọng Boss ảo, không bao giờ khô khan:

| Loại Sự Kiện | Template Notification |
| :--- | :--- |
| BATH | *"Sen ơi, đã {X} tuần rồi... trẫm đang hơi có mùi rồi đó ạ 👃 Tắm chưa Sen?"* |
| GROOMING | *"Lông của trẫm đang dài ra rồi~ ✂️ Đã {X} tuần kể từ lần cắt vừa rồi đó Sen!"* |
| NAIL_TRIM | *"Móng trẫm đang hơi dài, đi lại nghe lộp cộp lộp cộp~ 🐾 Cắt cho trẫm nha Sen!"* |
| VACCINATION | *"Sen nhớ không, đã {X} tháng rồi kể từ lần tiêm ngừa~ 💉 Lịch tiêm định kỳ sắp đến rồi đó!"* |
| DEWORMING | *"Trẫm nghe nói cần sổ giun định kỳ để khoẻ mạnh~ 💊 Đã {X} tháng rồi Sen ơi!"* |
| BIRTHDAY | *"🎂 HÔM NAY LÀ SINH NHẬT CỦA TRẪM ĐÓ SENNNN!!! Trẫm {age} tuổi rồi ạ~"* |

### 6.2. Chu Kỳ Mặc Định (Default Reminder Intervals)

```dart
const defaultReminderDays = {
  EventType.BATH:        14,   // 2 tuần
  EventType.GROOMING:    42,   // 6 tuần
  EventType.NAIL_TRIM:   21,   // 3 tuần
  EventType.TEETH_CLEAN: 7,    // 1 tuần
  EventType.VACCINATION: 365,  // 1 năm (nhắc Sen liên hệ bác sĩ)
  EventType.DEWORMING:   90,   // 3 tháng
  EventType.VET_CHECKUP: 180,  // 6 tháng
};
```

---

## 🗓️ 7. Màn Hình Tổng Quan Nhật Ký (Care Timeline View)

Ngoài việc hiển thị xen kẽ trong Hộp Ký Ức, người dùng có thể vào **chế độ xem Nhật Ký thuần** (chỉ sự kiện, không có ảnh):

```
┌─────────────────────────────────────────────┐
│  📋 Nhật Ký Chăm Sóc Boss                  │
│  Boss · Mèo Anh lông ngắn · 2 tuổi         │
│                                             │
│  ─── Tháng 5, 2026 ───────────────────────  │
│  29/05  🛁 Tắm                              │
│         "Tắm bằng sữa tắm mới"             │
│                                             │
│  15/05  💊 Sổ giun                          │
│         *(không có ghi chú)*               │
│                                             │
│  03/05  ✂️ Cắt lông                         │
│         "Cắt kiểu mới trông cute lắm"      │
│                                             │
│  ─── Tháng 4, 2026 ───────────────────────  │
│  15/04  💉 Tiêm ngừa                        │
│  01/04  🛁 Tắm                              │
│                                             │
│  [ 🔔 Nhắc nhở sắp tới ]                   │
│  ⏰ Cắt móng — còn 7 ngày (05/06)           │
└─────────────────────────────────────────────┘
```

---

## 🔗 8. Tích Hợp Với Hệ Thống Khác

### 8.1. Tích Hợp Safe-Vet AI (SPEC-03)
*   Khi Sen chọn sự kiện `FEELING_UNWELL` (🤒), app **không hiện form** mà chuyển thẳng sang Cozy Chat với context: *"Boss đang không khỏe"*, kích hoạt Safe-Vet AI phân loại đèn Vàng/Đỏ nếu cần.
*   Dữ liệu lịch sử tiêm ngừa từ `care_diary_events` được inject vào RAG context của Safe-Vet AI: *"Lần tiêm ngừa dại gần nhất cách đây 44 ngày"* → giúp AI tư vấn chính xác hơn.

### 8.2. Tích Hợp Auto Poetic Caption (SPEC-02, Section 6)
*   Khi có ảnh chụp cùng ngày với event, hệ thống biết context: ảnh chụp lúc 14:30 ngày 29/05 + event `BATH` ngày 29/05 → Auto Caption: *"Buổi chiều thơm tho, vừa được tắm xong nên lông mịn màng lắm~"*

### 8.3. Tích Hợp Hộp Ký Ức Timeline (SPEC-01)
*   Event Card hiển thị xen kẽ với Photo Polaroid trên timeline theo thứ tự thời gian ngược.
*   Khi tua timeline về ngày sinh nhật → Event Card `BIRTHDAY` được đặc biệt phình to, hiện hoạt ảnh confetti nhỏ.

### 8.4. Data Export (Minh Bạch Dữ Liệu)
*   Khi Sen xuất dữ liệu (.zip từ Data Sovereignty Panel), file `care_diary.csv` được đính kèm với đầy đủ cột: `date, event_type, event_label, user_note`.
*   Format CSV đơn giản, có thể mở bằng Excel — không phải định dạng độc quyền.

---

## 🔒 9. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1. **AC-1 (Speed):** Từ lúc nhấn FAB → Lưu sự kiện thành công ≤ 5 giây (3 bước: chọn loại → ngày & ghi chú → lưu).
2. **AC-2 (Chat Auto-Detection):** Sen nhắn *"hôm nay Boss được tắm"* → Boss ảo hỏi xác nhận trong vòng 1 lần phản hồi → Sen gật → Event được tạo tự động với `source = 'chat_ai'`.
3. **AC-3 (Timeline Integration):** Mở Hộp Ký Ức → Xác nhận Event Card xuất hiện đúng vị trí theo ngày xen kẽ với Polaroid Card.
4. **AC-4 (Reminder Trigger):** Lưu event BATH với reminder 14 ngày → Dùng device time-travel tăng 14 ngày → Xác nhận push notification xuất hiện đúng với template giọng Boss ảo.
5. **AC-5 (No Medical Data):** Kiểm tra toàn bộ form Add Event → Xác nhận không có bất kỳ field nào yêu cầu nhập tên thuốc, liều lượng, hay kết quả xét nghiệm.
6. **AC-6 (FEELING_UNWELL Redirect):** Sen chọn 🤒 Hôm nay Boss không khỏe → Xác nhận app KHÔNG hiện form nhập liệu → Tự động mở Cozy Chat với context đã được inject.

---

*Tài liệu được thiết lập bởi Team Capcat — Sophia (CPO), Alan (Tech Lead), Arthur (Mom Test)*
*Ranh giới y tế: Spec này hoàn toàn độc lập với Safe-Vet AI Engine (SPEC-03). Không có chẩn đoán, không có tư vấn thuốc.*
