# ĐẶC TẢ CHI TIẾT 10: CỬA HÀNG ĐĨA THAN ẢO & NGHI THỨC PHÁT NHẠC HOÀI CỔ
*(VIRTUAL VINYL STORE & ANALOG RECORD RITUALS)*

> **Mã Đặc Tả:** `SPEC-COZY-10`  
> **Trạng thái:** [HOÃN - TRIỂN KHAI PHASE 2 / BACKLOG]  
> **Chủ trì:** Sophia (CPO / PM), Bella (Aesthetic UX), Alan (Tech Lead), Leo (Tài chính)  
> **Phong cách nghệ thuật:** Âm thanh hoài niệm (Lo-Fi Analog Aesthetics)

---

## 🧭 1. Triết Lý Sản Phẩm: "Nghi Thức Trầm Lặng Giữa Thế Giới Số"

Trong thế giới thực, việc sưu tầm đĩa than (Vinyl Records) không chỉ là để nghe nhạc, mà là một **nghi thức văn hóa (ritual)** chứa đựng gu thẩm mỹ, sự chậm rãi, và tính sở hữu vật lý quý giá. 

Tại Capcat, chúng tôi biến đĩa than thành **Vật phẩm sưu tầm cảm xúc số (Digital Emotional Collectible)**. Thay vì chỉ nghe nhạc qua nút bấm vô hồn, Sen có thể mở bán và sưu tầm những đĩa nhạc ảo tuyệt đẹp để mở khóa nhạc nền chất lượng cao cho Boss ảo phát trong khung chat hoặc trong **Chế độ Trú ẩn Offline (`SPEC-COZY-09`)**.

### 🌸 Ba Mục Tiêu Trải Nghiệm Cốt Lõi:
1.  **Nghi thức khui đĩa (The Unboxing Ritual):** Tái tạo chân thực cảm xúc sờ chạm vật lý: bóc lớp màng bọc plastic bóng bẩy, rút đĩa than đen nặng tay ra khỏi vỏ bìa giấy (sleeve) vẽ tay đậm tính nghệ thuật.
2.  **Trải nghiệm bàn xoay cơ học (Analog Turntable Interaction):** Sen phải chủ động kéo cần kim (tonearm) đặt lên đĩa than xoay để nhạc vang lên cùng tiếng nổ lép bép đặc trưng của đầu kim đĩa than cổ điển.
3.  **Mô hình doanh thu chia sẻ (Licensing & Win-Win):** Bán các đĩa nhạc Indie Việt Nam độc quyền để chia sẻ doanh thu 50% cho các nghệ sĩ trẻ hướng nội, biến Capcat thành một bệ phóng văn hóa tử tế.

---

## 🎨 2. Thiết Kế Trải Nghiệm Người Dùng (Aesthetic UX/UI by Bella)

Phân hệ Đĩa than ảo được tích hợp tại màn hình **Cửa hàng Ký ức (Memory Shop)** của Pet, bao gồm 2 nghi thức tương tác độc bản:

### 2.1. Nghi Thức Khui Đĩa Than Mới Mua (The Unboxing Animation Flow)
Khi Sen mua thành công một đĩa than, giao diện sẽ kích hoạt luồng tương tác 3 bước bằng micro-animations mượt mà:
1.  **Bước 1 (Bóc màng co):** Một bao đĩa than bọc trong màng nylon bóng bẩy xuất hiện. Sen vuốt dọc màn hình từ trên xuống để làm hiệu ứng "xé màng nylon" (Plastic tear effect kèm tiếng rẹt nhẹ và độ rung haptic mảnh).
2.  **Bước 2 (Rút đĩa):** Vỏ bìa giấy cũ sờn gáy hiện ra dưới ánh sáng ấm. Sen vuốt ngang để trượt chiếc đĩa than đen bóng lấp lánh các đường rãnh đồng tâm ra khỏi vỏ bìa.
3.  **Bước 3 (Trưng bày):** Đĩa than được lưu trữ vĩnh viễn vào **Kệ Đĩa Than Của Sen (Cozy Vinyl Shelf)**.

```
+------------------------------------------------------+
│ [Back]            KỆ ĐĨA THAN CỦA SEN                │
├──────────────────────────────────────────────────────┤
│                                                      │
│    [🍁 Mùa Thu Hà Nội]      [🎷 Midnight Jazz]       │
│      +------------+          +------------+          │
│      |   ( Bìa )  |          |   ( Bìa )  |          │
│      |  Vũ. / Lofi|          | Miles Davis|          │
│      +------------+          +------------+          │
│                                                      │
│    [☕ Lofi Quán Gỗ]        [🌸 Sakura Whisper]      │
│      +------------+          +------------+          │
│      |   ( Bìa )  |          |   ( Bìa )  |          │
│      |  Artisan   |          |  Acoustic  |          │
│      +------------+          +------------+          │
│                                                      │
│   🎵 [ Nhấp đúp vào bìa đĩa để mang lên Bàn Xoay ]   │
+------------------------------------------------------+
```

### 2.2. Giao Diện Máy Phát Đĩa Cơ Học (The Turntable Player UI)
Khi Sen chuyển sang chế độ phát nhạc nền, giao diện chat hoặc góc trú ẩn offline sẽ trượt lên một máy phát đĩa hoài cổ:
*   **Thao tác cơ học:** Sen chạm giữ cần kim (`Tonearm`), kéo nhẹ và thả vào rìa đĩa than đang nằm trên mâm xoay (`Platter`).
*   **Hiệu ứng âm thanh:** Ngay khi đầu kim chạm đĩa, hệ thống phát ra một file âm thanh nền 1.5 giây mô phỏng tiếng lép bép lép bép hoài cổ của đĩa than thật (`vinyl_crackle.mp3`), sau đó nhạc nền chính mới bắt đầu vang lên và đĩa than bắt đầu xoay tròn chậm rãi ở tốc độ `33 RPM`.

---

## 🛠️ 3. Kiến Trúc Kỹ Thuật Đa Nền Tảng (by Alan)

Để giảm thiểu tối đa gánh nặng cho hệ thống server, toàn bộ logic mua bán và phân phối file nhạc đĩa than được Alan thiết kế theo chuẩn tối giản và bảo mật.

### 3.1. Database Schema cục bộ SQLite (`owner_vinyl_collection`)
Khi người dùng mua hoặc mở khóa đĩa than, client sẽ lưu trữ thông tin sở hữu xuống Local DB để truy vấn tức thì khi offline:
```sql
CREATE TABLE owner_vinyl_collection (
    vinyl_id VARCHAR(64) PRIMARY KEY,     -- Ví dụ: 'vinyl_vu_dong_2026'
    title TEXT NOT NULL,                  -- Tên đĩa nhạc
    artist_name TEXT NOT NULL,            -- Tên nghệ sĩ (Vũ, Thịnh Suy, Miles Davis...)
    cover_art_asset TEXT NOT NULL,        -- Đường dẫn ảnh bìa cục bộ hoặc URL cache
    local_audio_path TEXT,                -- Đường dẫn file nhạc đã tải về máy (phục vụ offline)
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    purchase_type VARCHAR(16) NOT NULL    -- 'iap' (Mua tiền thật) hoặc 'pate_coin' (Tiền trong game)
);
```

### 3.2. Quản Lý File Nhạc Ngoại Tuyến Độc Quyền & Mã Hóa (Offline Encryption)
*   **Chống vi phạm bản quyền (Anti-Piracy):** Để tránh việc người dùng bẻ khóa hệ điều hành (Root/Jailbreak) và trích xuất trái phép các file nhạc độc quyền của các nghệ sĩ đối tác ra ngoài, toàn bộ file âm thanh tải về máy sẽ được mã hóa bằng thuật toán **AES-128** trước khi lưu vào thư mục ứng dụng cục bộ (`ApplicationDocumentsDirectory`).
*   **Cơ chế phát nhạc:** Khi người dùng kéo cần kim phát đĩa, lớp mã hóa được giải mã ngầm trực tiếp trong RAM thông qua luồng Stream Bytes (`just_audio` custom stream source), tuyệt đối không ghi file nhạc thô đã giải mã xuống ổ cứng thiết bị.

### 3.3. Tích Hợp Cổng Thanh Toán In-App Purchase (IAP)
Chúng ta sử dụng thư viện [purchases_flutter](https://pub.dev/packages/purchases_flutter) (RevenueCat) làm cổng quản lý Subscription và In-App Purchases vì:
*   Hỗ trợ đồng nhất hóa cổng thanh toán App Store (Apple IAP) và Google Play Billing trong một bộ API duy nhất.
*   Quản lý hoàn tiền (Refunds), khôi phục giao dịch (Restore purchases) hoàn toàn tự động phía server của RevenueCat, giúp tiết kiệm 2 tháng code Backend cho team.

---

## 📊 4. Chiến Lược Nội Dung & Doanh Thu (by Sophia & Leo)

Chúng ta chia đĩa than ảo thành 3 phân khúc sản phẩm rõ rệt để tối đa hóa doanh thu:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        PHÂN KHÚC ĐĨA THAN CAPCAT                       │
├───────────────────┬───────────────────────────┬────────────────────────┤
│     PHÂN KHÚC     │     PHƯƠNG THỨC MUA       │        ĐỐI TƯỢNG       │
├───────────────────┼───────────────────────────┼────────────────────────┤
│ 🟢 Classic Jazz   │ Mở khóa bằng Pate Coins   │ Nhạc Jazz cổ điển      │
│    (Public Domain)│ (Tích lũy qua game chat)  │ (Chopin, Miles Davis)  │
├───────────────────┼───────────────────────────┼────────────────────────┤
│ 🔵 Cozy Indie     │ IAP trực tiếp $0.99       │ Hợp tác nghệ sĩ Indie  │
│    (Exclusive)    │ (Mua đứt vĩnh viễn)       │ Việt Nam (Vũ, Thịnh Suy)│
├───────────────────┼───────────────────────────┼────────────────────────┤
│ 🔴 Seasonal Gold  │ IAP giới hạn $1.99        │ Đĩa nhạc theo mùa      │
│    (Limited)      │ (Chỉ bán trong 15 ngày)   │ (Hà Nội Đêm Gió Mùa)   │
└───────────────────┴───────────────────────────┴────────────────────────┘
```

### 🤝 Kế hoạch Hợp tác Nghệ sĩ (Indie Creator Program):
*   Capcat sẽ đặt hàng riêng các nghệ sĩ Indie thu âm các bản **Acoustic / Lofi Guitar độc quyền** có thời lượng vòng lặp (loop) từ 1 - 2 phút (phù hợp cho nhạc nền chữa lành).
*   **Doanh thu chia sẻ 50/50:** Trừ đi 30% phí kho ứng dụng Apple/Google, 70% doanh thu thực nhận sẽ được chia đều 50% cho nghệ sĩ và 50% cho Capcat. Đây là mô hình kinh doanh bền vững và đầy tính nhân văn, tạo thiện cảm lớn với cộng đồng người dùng trẻ hướng nội.

---

## 📑 5. Bảng Nhập Liệu Google Sheets CMS Bổ Sung (Tab 4: `virtual_vinyls`)

Để phục vụ cho phương án vận hành tinh gọn qua **Google Sheets CMS (`SPEC-COZY-08`)**, chúng ta thêm **Tab thứ 4** trên Google Sheet Master CMS như sau:

#### 📑 Tab 4: `virtual_vinyls` (Quản lý Danh mục Đĩa than ảo)

| Cột A | Cột B | Cột C | Cột D | Cột E | Cột F | Cột G | Cột H |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **vinyl_id** *(Key)* | **title** | **artist_name** | **price_iap_usd** | **price_pate_coins** | **audio_stream_url** | **cover_art_asset** | **is_exclusive** *(T/F)* |
| `vinyl_vu_01` | Lạ Lùng (Acoustic Solo) | Vũ. | `0.99` | `0` | `https://cdn.capcat.com/music/la_lung.mp3` | `assets/images/vinyls/vu_la_lung.png` | `TRUE` |
| `vinyl_classic_jazz` | Blue in Green (Classic) | Miles Davis | `0` | `500` | `https://cdn.capcat.com/music/blue_in_green.mp3` | `assets/images/vinyls/miles_blue.png` | `FALSE` |

---

## 🔒 6. Kiểm Thử Chất Lượng (QA Acceptance Criteria)
1.  **Kiểm thử IAP:** Sử dụng sandbox Apple/Google Play mua đĩa than Vũ. -> Mở khóa thành công, đĩa được đưa vào `Cozy Vinyl Shelf` cục bộ.
2.  **Kiểm thử Thao tác máy đĩa:** Kéo cần kim thả vào đĩa -> Tiếng nổ lép bép `vinyl_crackle.mp3` phải phát trước trong đúng 1.5 giây, sau đó đĩa bắt đầu quay tròn mượt mà và nhạc nền phát đúng nhịp.
3.  **Kiểm thử Tiết kiệm điện năng:** Nhạc đĩa than tắt ngay lập tức và mâm xoay ngừng render khi khóa màn hình điện thoại.
