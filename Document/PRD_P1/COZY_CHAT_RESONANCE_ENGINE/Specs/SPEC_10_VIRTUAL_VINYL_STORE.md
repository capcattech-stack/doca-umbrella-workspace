# ĐẶC TẢ CHI TIẾT 10: TRẢI NGHIỆM ĐĨA THAN CẢM XÚC & TIẾP THỊ LIÊN KẾT ÂM NHẠC
*(CONTEXTUAL MUSIC AFFILIATE & ANALOG PLAYBACK ESTHETICS)*

> **Mã Đặc Tả:** `SPEC-COZY-10`  
> **Trạng thái:** [MVP - TRIỂN KHAI PHƯƠNG ÁN AFFILIATE]  
> **Chủ trì:** Alan (Tech Lead), Benny (Senior Mobile Dev), Sophia (CPO / PM)  
> **Phong cách nghệ thuật:** Âm thanh hoài niệm (Lo-Fi Analog & MUJI Minimalism)

---

## 🧭 1. Triết Lý Sản Phẩm: "Cộng Hưởng Âm Nhạc & Không Gian Cảm Xúc"

Thay vì thương mại hóa thô bạo bằng cách bán các đĩa nhạc ảo qua hệ thống tiền ảo (CatCoins) hay cổng thanh toán In-App Purchase (IAP) phức tạp, **DOCA** lựa chọn giải pháp **Tiếp thị Liên kết Âm nhạc (Music Affiliate & Referral)** kết hợp với giao diện **Bàn Xoay Đĩa Than Cơ Học (Analog Turntable)** để vừa giữ vững triết lý tối giản MUJI, vừa tạo ra nguồn doanh thu thụ động lành mạnh.

### 🌸 Ba Mục Tiêu Trải Nghiệm Cốt Lõi:
1.  **Mở khóa tự nhiên qua hội thoại (Cozy Unlock):** Người dùng không thể "nạp tiền" để mua đĩa. Đĩa nhạc chỉ được mở khóa và lưu vào bộ sưu tập khi Boss gợi ý bản nhạc đó trong luồng chat Cozy Chat dựa trên tâm trạng thực tế của Sen.
2.  **Trải nghiệm bàn xoay cơ học (Analog Turntable Interaction):** Tái hiện chân thực nghi thức nghe nhạc: chọn đĩa từ kệ, đặt lên mâm xoay, và kéo cần kim (tonearm) để nghe bản nhạc preview 30s với tiếng nổ lép bép đặc trưng.
3.  **Cầu nối đến các nền tảng Streaming (Affiliate Deep Link):** Tích hợp liên kết tiếp thị liên kết (Spotify Affiliate, Apple Music Partnerize) để khuyến khích người dùng nhấn nút chuyển tiếp nghe trọn vẹn bài hát trên ứng dụng stream nhạc chính thức của họ.

---

## 🎨 2. Thiết Kế Trải Nghiệm Người Dùng (Turntable Player & Collection)

Đĩa nhạc khi được mở khóa từ chat sẽ lưu vào **Kệ Đĩa Than Của Sen (DOCA Corner - Tab Đĩa nhạc)**. Khi nhấp chọn đĩa, một Bottom Sheet chi tiết sẽ mở ra tích hợp trình nghe nhạc:

### 2.1. Giao Diện Máy Phát Đĩa Cơ Học (The Turntable Player UI)
*   **Thao tác cơ học:** Sen chạm giữ cần kim (`Tonearm`), kéo nhẹ và thả vào rìa đĩa than đang nằm trên mâm xoay (`Platter`).
*   **Hiệu ứng âm thanh:** Ngay khi đầu kim chạm đĩa, hệ thống phát ra một file âm thanh nền 1.5 giây mô phỏng tiếng lép bép lép bép hoài cổ của đĩa than thật (`vinyl_crackle.mp3`), sau đó bản nhạc preview 30s mới bắt đầu phát và đĩa than bắt đầu xoay tròn chậm rãi ở tốc độ `33 RPM`.
*   **Dừng nhạc:** Nhấc cần kim ra khỏi đĩa than hoặc nhấn nút Stop.

### 2.2. Giao Diện Nút Hành Động Tiếp Thị Liên Kết (Affiliate Button Style)
Dưới trình phát 30s, hai nút hành động được thiết kế chuẩn MUJI (Không màu mè, phẳng, viền 1px):

```
+-------------------------------------------------------------+
|  [====================== PLAYBAR ========================]  |
|                                                             |
|  +-------------------------------------------------------+  |
|  |      [🎧] NGHE BẢN FULL TRÊN SPOTIFY (Referral)       |  | <--- Nút viền đen Obsidian
|  +-------------------------------------------------------+  |
|  |      [🍏] MỞ TRÊN APPLE MUSIC (Affiliate ID)            |  | <--- Nút viền xám tro
|  +-------------------------------------------------------+  |
+-------------------------------------------------------------+
```

---

## 🛠️ 3. Kiến Trúc Kỹ Thuật Tinh Gọn (by Alan & Benny)

### 3.1. Database Schema cục bộ SQLite (`owner_vinyl_collection`)
Loại bỏ hoàn toàn các trường dữ liệu liên quan đến tiền ảo hay giao dịch thanh toán IAP. Bảng chỉ lưu giữ thông tin thực thể âm nhạc và link affiliate:

```sql
CREATE TABLE owner_vinyl_collection (
    vinyl_id VARCHAR(64) PRIMARY KEY,     -- ID từ hệ thống (Ví dụ: 'vinyl_miles_blue')
    title TEXT NOT NULL,                  -- Tên bản nhạc
    artist_name TEXT NOT NULL,            -- Tên nghệ sĩ (Vũ, Thịnh Suy, Miles Davis...)
    cover_art_asset TEXT NOT NULL,        -- Đường dẫn ảnh bìa cục bộ hoặc URL cache
    preview_url TEXT NOT NULL,            -- Link audio 30s lấy từ iTunes API
    affiliate_url_spotify TEXT,           -- URL chuyển hướng Spotify với mã giới thiệu
    affiliate_url_apple TEXT,             -- URL Apple Music kèm Campaign/Affiliate Token
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pet_id VARCHAR(64) NOT NULL           -- ID Boss đã tặng đĩa này
);
```

### 3.2. Quản Lý Phát Audio & Hủy Bộ Nhớ (Singleton Audio Manager)
*   Sử dụng provider duy nhất `nanny_audio_player_provider` của Riverpod.
*   Khi đóng Bottom Sheet hoặc rời màn hình DOCA Corner, bắt buộc gọi `audioPlayer.stop()` và `audioPlayer.dispose()` để tránh rò rỉ âm thanh ngầm.

---

## 📊 4. Mô Hình Doanh Thu Tiếp Thị Liên Kết (Affiliate Business Model)

Chúng ta tích hợp 2 chương trình liên kết lớn dễ dàng đăng ký và triển khai:

1.  **Apple Services Affiliate Program (Partnerize):**
    *   *Cơ chế:* Cung cấp link deep-link chứa mã affiliate. Khi người dùng nhấp vào link và đăng ký gói Apple Music Premium (hoặc mua bài hát lẻ), nhà phát triển nhận được **100% giá trị tháng cước đầu tiên** (referral commission) hoặc **7%** giá trị bài hát lẻ.
    *   *Tích hợp:* Sử dụng định dạng link: `https://geo.music.apple.com/vn/album/[album-id]?itsct=[affiliate-token]&itscg=30200`.
2.  **Spotify Partner & Impact Affiliate:**
    *   *Cơ chế:* Trả hoa hồng dựa trên số lượt đăng ký mới gói Premium được chuyển hướng từ ứng dụng.
    *   *Tích hợp:* Sử dụng deep-link Scheme: `spotify:track:[track_id]` hoặc web fallback `open.spotify.com/track/[track_id]?si=[ref-token]`.

### 📈 Đánh giá Hiệu quả so với Bán Vật Phẩm Ảo (BizDev Review):
*   **Chi phí phát triển:** Giảm từ **12 ngày dev** xuống còn **2 ngày dev** (Không cần thiết lập cổng thanh toán Apple IAP/Google Billing, không cần hệ thống ví tiền tệ, đối soát ví, xử lý hoàn tiền).
*   **Legal Compliance:** Tránh hoàn toàn các quy định thuế quan khắt khe của kho ứng dụng đối với việc bán tiền ảo, không bị giữ tiền 30 ngày từ store.
*   **Trải nghiệm người dùng:** Nhận được sự ủng hộ tuyệt đối của nhóm khách hàng hướng nội yêu thích phong cách Muji do không có các banner kích cầu mua sắm ảo.

---

## 🔒 5. Tiêu Chí Nghiệm Thu (Acceptance Criteria)
1.  **Mở khóa đĩa:** Boss giới thiệu nhạc trong chat -> Thẻ đĩa than tự động được tạo trong SQLite và xuất hiện trên Kệ đĩa nhạc DOCA Corner.
2.  **Chuyển hướng an toàn:** Bấm nút Spotify/Apple Music -> Kiểm tra xem app đã cài trên máy chưa. Nếu đã cài, mở thẳng app ngoài qua deep link. Nếu chưa cài, mở qua trình duyệt hệ thống với URL Affiliate.
3.  **Tự động dọn dẹp:** Tắt Bottom Sheet phát đĩa -> Nhạc dừng ngay lập tức, giải phóng RAM.
