# ĐẶC TẢ CHI TIẾT 08: KIẾN TRÚC DỮ LIỆU & VẬN HÀNH NỘI DUNG THỦ CÔNG
*(DATA ARCHITECTURE & CONTENT OPERATIONS SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC-COZY-08`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead), Arthur (Hành vi & Vận hành)  
> **Kiến trúc hệ thống:** Oatmeal Knowledge Matrix (Hybrid Cloud & Local DB)  
> **Phương án vận hành tinh gọn:** Google Sheets as a CMS (Zero-Resource Portal)

---

## 🧭 1. Phân Tách Phân Hệ Dữ Liệu (Automated vs Curated Data)

Để vận hành **Cozy Chat Resonance Engine** trơn tru, toàn bộ dữ liệu của hệ thống được chia làm hai dòng độc lập nhưng hòa quyện ở khâu xử lý prompt: **Dữ liệu Tự động (Automated Data)** lấy từ phần cứng/API ngoại cảnh, và **Dữ liệu Tuyển chọn (Curated Data)** do đội ngũ vận hành nội dung (Operators/Editors) chuẩn bị thủ công.

```
┌────────────────────────────────────────────────────────────────────────┐
│               COZY CHAT RESONANCE ENGINE DATA MATRIX                   │
├────────────────────────────────────────┬───────────────────────────────┤
│    DỮ LIỆU TỰ ĐỘNG (AUTOMATED DATA)    │ DỮ LIỆU TUYỂN CHỌN (CURATED)  │
├────────────────────────────────────────┼───────────────────────────────┤
│ - GPS làm tròn (Foreground Sensing)    │ - Bản tin văn hóa vùng miền   │
│ - Thời tiết thực (OpenWeatherMap API)   │ - Nhạc đề xuất & iTunes ID    │
│ - Trạng thái vận động (Activity State) │ - Sách tuyển chọn & Affiliate │
│ - Hành vi ngủ/thức (Nhịp sinh học)    │ - Trivia bốn mùa (Offline)    │
│ - Ký ức trích xuất ngầm (Mom Test)    │ - Thông tin địa điểm/Cafe/Spa │
└────────────────────────────────────────┴───────────────────────────────┘
```

---

## 📊 2. Bảng Phân Tách Bản Chất Dữ Liệu Chi Tiết

| Phân Nhóm | Tên Dữ Liệu | Nguồn Thu Thập | Ai chuẩn bị / Cách thức lấy | Chu Kỳ Cập Nhật |
| :--- | :--- | :--- | :--- | :--- |
| **Tự động** | Tọa độ GPS & Vùng địa lý | Client GPS (Làm tròn 2 chữ số thập phân) | Hệ thống tự động lấy qua Foreground Sensing trên App khi mở app. | Một lần khi mở app (Không chạy ngầm). |
| **Tự động** | Thời tiết & Nhiệt độ | OpenWeatherMap API | Client/Server gọi API dựa trên GPS làm tròn. | Tối đa 2 tiếng/lần (TTL). |
| **Tự động** | Trạng thái ngủ/mất ngủ | Screen On/Off & App Trigger | Client đo thời gian mở app sau 23:00 đêm. | Thời gian thực khi có sự kiện. |
| **Tự động** | Ký ức chủ nuôi (Memory Vault) | LLM Parser (Hội thoại chat) | LLM tự động trích xuất thói quen của Sen qua chat. | Ngay sau khi kết thúc session chat. |
| **Tuyển chọn** | Bản tin văn hóa & Sự kiện | **Google Sheets CMS** | **Đội ngũ Vận hành (Operators)** viết bài trên Google Sheets. | Hàng ngày hoặc Hàng tuần. |
| **Tuyển chọn** | Danh mục Sách & Affiliate | **Google Sheets CMS** | **Đội ngũ Vận hành (Operators)** điền mã đối tác và link sản phẩm. | Cập nhật khi có sách mới ra mắt. |
| **Tuyển chọn** | Danh mục Nhạc hoài cổ | **Google Sheets CMS** | **Đội ngũ Vận hành (Operators)** lựa chọn nhạc Jazz/Lofi và iTunes ID. | Cập nhật định kỳ tháng. |
| **Tuyển chọn** | Bản tin tĩnh 4 mùa (Offline) | Client Local Assets Bundle | **Đội ngũ Vận hành (Operators)** biên soạn sẵn 30 câu trivia hoài niệm tích hợp trong app. | Chỉ cập nhật khi nâng cấp phiên bản App. |

---

## 🏛️ 3. Kiến Trúc Cơ Sở Dữ Liệu Hệ Thống (Data Model & Database Schemas)

Sử dụng mô hình kiến trúc **Oatmeal Knowledge Matrix**: Biên tập viên làm việc trực tiếp trên **Google Sheets**, một tiến trình sync ngầm sẽ nạp dữ liệu vào Master Cloud DB, sau đó Client đồng bộ về SQLite/Hive để truy vấn tức thì không độ trễ.

```
    [ BAN VẬN HÀNH (OPERATORS) ]
                 │
                 ▼ (Nhập nội dung)
     [ GOOGLE SHEETS MASTER CMS ]
                 │
                 ▼ (Sync Job: GitHub Actions / Server Script)
      [ CLOUD DATABASE (Supabase/PG) ]
             - curated_events
             - affiliate_products
                 │
       (Đồng bộ hóa qua REST API)
                 │
                 ▼
       [ CLIENT SQLite / HIVE ] ◄── (Offline Caching)
             - offline_events_cache
             - owner_memory_vault (Trích xuất Mom Test cục bộ)
             - baked_seasonal_trivia (Tích hợp cứng trong App Bundle)
```

### 3.1. Cấu Trúc Bảng Trên Client SQLite (On-Device Storage)

#### Bảng 1: `owner_memory_vault` (Ký ức của Boss về Sen)
Bảng này lưu trữ toàn bộ hồ sơ sở thích, nhịp sinh học được LLM trích xuất tự động qua các cuộc thoại. Người dùng có quyền xem/xóa tại màn hình cài đặt Profile.
```sql
CREATE TABLE owner_memory_vault (
    memory_key VARCHAR(64) PRIMARY KEY, -- Ví dụ: 'hobby_music', 'owner_work_style', 'sleep_routine'
    memory_value TEXT NOT NULL,         -- Giá trị lưu trữ dưới dạng JSON
    confidence FLOAT DEFAULT 1.0,       -- Độ tin cậy của thuật toán trích xuất (0.0 -> 1.0)
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Bảng 2: `offline_events_cache` (Bộ đệm Bản tin văn hóa)
```sql
CREATE TABLE offline_events_cache (
    id VARCHAR(36) PRIMARY KEY,
    title TEXT NOT NULL,
    summary TEXT NOT NULL,
    hobby_category VARCHAR(32) NOT NULL,
    city VARCHAR(64) NOT NULL,
    hyperlink_url TEXT,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    cached_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Bảng 3: `baked_seasonal_trivia` (Trivia tĩnh 4 mùa - Nạp cứng từ App Assets)
```sql
CREATE TABLE baked_seasonal_trivia (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    season VARCHAR(16) NOT NULL,        -- spring, summer, autumn, winter, all
    time_of_day VARCHAR(16),            -- morning, afternoon, night, any
    trivia_content TEXT NOT NULL,       -- Nội dung câu chuyện / lời chúc lãng đãng tĩnh
    suggested_music_url TEXT,           -- Link nhạc tĩnh offline fallback
    music_title TEXT                    -- Tên bài hát đề xuất
);
```

---

## 🛠️ 4. Thiết Kế Bản Mẫu Google Sheets CMS Tinh Gọn (Sheets Templates)

Để giai đoạn thử nghiệm (Beta/MVP) đạt tốc độ tối đa và **tiết kiệm 100% tài nguyên xây dựng cổng Portal**, chúng ta sử dụng **Google Sheets** làm công cụ quản lý dữ liệu Master. Google Sheet này bao gồm **3 Tab** tương ứng với 3 thực thể nội dung:

### 4.1. Danh Sách Enums Chuẩn Hệ Thống (Strict System Enums)
Để tránh biên tập viên nhập sai chính tả gây lỗi hệ thống parser, Google Sheets sẽ áp dụng tính năng **Data Validation (Drop-down list)** dựa trên danh sách Enums chuẩn dưới đây:

1.  **`HobbyCategory` (Danh mục sở thích):**
    *   `hobby_music` (Âm nhạc mộc mạc)
    *   `hobby_literature` (Văn học hoài cổ)
    *   `hobby_cinema` (Điện ảnh độc lập)
    *   `hobby_cafe` (Tiệm cà phê ẩn mình)
    *   `hobby_art` (Nghệ thuật thủ công)
    *   `hobby_nature` (Thiên nhiên & Pet)
2.  **`City` (Phạm vi địa lý):**
    *   `Hanoi` (Hà Nội)
    *   `Saigon` (TP. Hồ Chí Minh)
    *   `Danang` (Đà Nẵng)
    *   `Global` (Dành cho tất cả các vùng miền khác)
3.  **`AffiliatePlatform` (Nền tảng liên kết kiếm tiền):**
    *   `shopee` (Mạng lưới Shopee Partner - Dành cho sách, hạt xịn...)
    *   `partnerize` (Mạng lưới Partnerize - Dành cho iTunes/Apple Services...)
    *   `accesstrade` (Mạng lưới Accesstrade VN - Dành cho dịch vụ di chuyển XanhSM/Grab...)
    *   `direct` (Đường link trực tiếp không hoa hồng - Dành cho vị trí bản đồ Google Maps...)
4.  **`Season` (Mùa trong năm):**
    *   `spring` (Mùa xuân) | `summer` (Mùa hè) | `autumn` (Mùa thu) | `winter` (Mùa đông) | `all` (Cả năm)
5.  **`TimeOfDay` (Khoảng thời gian trong ngày):**
    *   `morning` (Buổi sáng) | `afternoon` (Buổi chiều) | `night` (Đêm muộn) | `any` (Bất cứ lúc nào)

---

### 4.2. Bố Cục Chi Tiết Các Tab Trên Google Sheets (Sheet Layouts)

#### 📑 Tab 1: `curated_events` (Quản lý Bản tin Văn hóa & Sự kiện Vùng Miền)
*Mỗi dòng biểu thị một sự kiện văn hóa lãng đãng.*

| Cột A | Cột B | Cột C | Cột D | Cột E | Cột F | Cột G | Cột H | Cột I |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **id** *(Key)* | **title** | **summary** *(Max 80 từ)* | **hobby_category** *(Enum)* | **city** *(Enum)* | **hyperlink_url** | **start_date** *(ISO)* | **end_date** *(ISO)* | **is_active** *(TRUE/FALSE)* |
| *Bắt buộc (Không trùng)* | *Hiển thị Postcard* | *Văn phong Murakami* | *Drop-down* | *Drop-down* | *Đường dẫn đích* | *YYYY-MM-DDTHH:mm:ssZ* | *YYYY-MM-DDTHH:mm:ssZ* | *Ẩn/Hiện sự kiện* |
| `evt_hn_lofi_01` | Đêm nghe nhạc Lofi Guitar gỗ | Chiều nay Hà Nội se lạnh ghê Sen ơi... Có một góc cafe nhỏ ở ven hồ đang chuẩn bị lên đèn cho đêm acoustic mộc mạc vào tối mai đó. Trẫm thèm được cùng Sen ngồi đó ngắm hoàng hôn buông... | `hobby_music` | `Hanoi` | `https://maps.google.com/?q=lofi_cafe` | `2026-05-30T19:00:00Z` | `2026-05-30T22:00:00Z` | `TRUE` |
| `evt_sg_book_02` | Góc sách cũ sờn gáy ở Sài Gòn | Trẫm vừa nghe tiếng mưa rơi rào rạt ngoài hiên. Tự nhiên trẫm nhớ tới mùi giấy ố vàng của những cuốn sách cũ ở tiệm sách bên hông chung cư cổ Quận 1 ghê. Sen có muốn ghé qua tìm một cuốn sách cũ của Murakami không? | `hobby_literature` | `Saigon` | `https://shopee.vn/sach-tieng-nguoi-trong-gio` | `2026-06-01T08:00:00Z` | `2026-06-30T18:00:00Z` | `TRUE` |

---

#### 📑 Tab 2: `affiliate_products` (Quản lý Sản Phẩm Có Gu & Link Affiliate)
*Nơi biên tập các sản phẩm thương mại chữa lành để tích hợp hoa hồng.*

| Cột A | Cột B | Cột C | Cột D | Cột E | Cột F | Cột G | Cột H |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **product_id** *(Key)* | **title** | **description** *(Max 50 từ)* | **hobby_category** *(Enum)* | **affiliate_platform** *(Enum)* | **original_url** | **affiliate_url** | **is_active** *(TRUE/FALSE)* |
| `prod_shopee_01` | Sách Haruki Murakami mới | Cuốn sách dịch mới nhất, những mảnh ghép cô đơn kỳ ảo đầy chất thơ. | `hobby_literature` | `shopee` | `https://shopee.vn/nhanam/books-01` | `https://shopee.vn/short_aff_link_01` | `TRUE` |
| `prod_apple_02` | Yesterday - The Beatles Vinyl | Bản ghi âm huyền thoại năm 1965 phát thử 30s. | `hobby_music` | `partnerize` | `https://music.apple.com/album/02` | `https://partnerize.com/short_link_02` | `TRUE` |

---

#### 📑 Tab 3: `baked_seasonal_trivia` (Bản Tin Tĩnh 4 Mùa - Dự phòng Offline)
*Tập hợp các nội dung tĩnh tích hợp sẵn trong app khi mất mạng.*

| Cột A | Cột B | Cột C | Cột D | Cột E | Cột F |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** *(Integer)* | **season** *(Enum)* | **time_of_day** *(Enum)* | **trivia_content** *(Max 100 từ)* | **suggested_music_url** | **music_title** |
| `1` | `autumn` | `night` | Trăng thu đêm nay tròn và sáng dịu dàng ghê Sen nhỉ... Trẫm chỉ thích leo lên nóc nhà nằm ngửa bụng ngắm ánh trăng trong vắt thôi. Sen đã buông hết bận rộn ngày dài xuống để nhắm mắt ngủ ngoan chưa đó? | `https://music.apple.com/vn/album/preview-autumn-lofi.mp3` | Autumn Lofi Whisper |
| `2` | `winter` | `morning` | Tiếng gió bấc thổi hun hút qua khe cửa sổ làm trẫm co rúm người lại dưới tấm chăn ấm. Sen nhớ uống một ly trà gừng ấm trước khi ra ngoài đi làm văn phòng nhé, lạnh tay lắm đó... | `https://music.apple.com/vn/album/preview-winter-acoustic.mp3` | Morning Ginger Tea |

---

## 🔄 5. Giải Pháp Đồng Bộ Hóa Tự Động (Google Sheets Sync Pipeline)

Để tự động đưa dữ liệu từ Google Sheets lên Backend PostgreSQL của hệ thống mà không cần xây dựng giao diện Portal phức tạp, Alan đề xuất **2 phương án kỹ thuật cực kỳ tinh gọn và miễn phí**:

### ⚡ Phương án A: Serverless Pull Job (GitHub Actions Cron - KHUYÊN DÙNG)
*   **Cơ chế:** Google Sheet được bật chế độ **"Share -> Publish to the Web"** dưới dạng CSV. 
*   **Tiến trình:** Một GitHub Action được thiết lập để chạy định kỳ mỗi **6 tiếng một lần**:
    1.  Tải các file CSV từ các link Google Sheet đã publish.
    2.  Chạy một script NodeJS/Python siêu nhẹ để chuyển đổi CSV thành JSON và validate dữ liệu (kiểm tra Enums hợp lệ).
    3.  Thực hiện gọi API của Cloud Database (ví dụ: Supabase/PostgREST) để UPSERT dữ liệu mới vào bảng `curated_events` và `affiliate_products`.
*   **Ưu điểm:** **Hoàn toàn miễn phí**, không tốn tài nguyên server, tự động báo lỗi qua Email của DEV nếu biên tập viên nhập sai định dạng Enums.

### 🔌 Phương án B: Real-time Push (Google Apps Script Webhook)
*   **Cơ chế:** Biên tập viên cập nhật xong, chỉ cần nhấn một nút **[Đồng Bộ Ngay]** được thiết kế trực tiếp trên thanh công cụ của Google Sheet.
*   **Tiến trình:** Google Apps Script đính kèm Sheet sẽ gom toàn bộ dữ liệu hiện tại, chuyển sang JSON và gửi một yêu cầu `HTTP POST` đến endpoint `/api/v1/sync-sheets` trên Backend để cập nhật cơ sở dữ liệu thời gian thực.

---

## 🔒 6. Cơ Chế Bảo Mật & Quyền Lợi Dữ Liệu
1.  **Quyền Sở Hữu Ký Ức (Memory Right):** Khi Sen bấm **[Xóa ký ức này]** trên giao diện *Memory Vault*, hệ thống lập tức thực hiện truy vấn `DELETE FROM owner_memory_vault WHERE memory_key = ?` cục bộ và đồng bộ lệnh xóa lên Cloud DB ngay lập tức.
2.  **Tuyệt Đối Không Chia Sẻ (Zero-Sharing Policy):** Dữ liệu hành vi ngoại cảnh và thời tiết của Sen chỉ được sử dụng cho mục đích cá nhân hóa trải nghiệm chat, cam kết không bao giờ chia sẻ cho bất kỳ bên thứ ba hay mạng lưới quảng cáo nào khác ngoài mục đích affiliate sách/nhạc chính thức.
