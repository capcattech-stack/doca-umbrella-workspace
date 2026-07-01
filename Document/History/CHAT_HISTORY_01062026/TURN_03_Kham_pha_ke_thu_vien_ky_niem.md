# TURN 03: KHÁM PHÁ CẬN CẢNH KỆ THƯ VIỆN KỶ NIỆM
*(CARE EVENT & COZY SHELF LIBRARY EXPLORATION)*

> **Mã Lượt Chat:** `TURN-01062026-03`  
> **Chủ trì:** Sophia (CPO / PM), Arthur (Mom Test Expert)

---

## 🙋‍♂️ **Người dùng hỏi:**
> tiếp tục làm rõ 1 phân hệ tinh năng trong mvp. đó là phần thư viện/kệ hàng, tôi chưua biết chọn cách tiếp cận noà cho phù hợp nhưng đây là phân hệ chứa những item mà chúng ta thảo luận ở phần chat. Nơi có danh sách các bài hát/nhân vật/sự kiện/sản phẩm  (Có trong dữ liẹu của capcat hoặc là được nhắc đế, bạn hãy phân tích với péona xem cái nào là hấp dẫn hơn). Đây là nơi đẻ người dùng có thể xem /xem lại các item dưới dạn bottomsheet và có link , align với SPEC_07_EXTERNAL_AMBIENT_SENSING

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã tiến hành phân tích sâu sắc các hướng tiếp cận thiết kế cho phân hệ **Thư viện / Kệ hàng (The Library / Shelving System)** dựa trên tâm lý học của nhóm đối tượng Early Adopters (người trẻ cô đơn đô thị, yêu thích Ghibli và lối sống chậm). 

Đồng thời, tôi đã biên soạn thành công tài liệu đặc tả PRD chính thức **[SPEC_11_COZY_SHELF_LIBRARY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_11_COZY_SHELF_LIBRARY.md)** nằm trong phân hệ Cozy Chat Resonance Engine để định hình dòng chảy tương tác này.

---

### 🏛️ SO SÁNH 3 TIẾP CẬN THIẾT KẾ CHO "KỆ HÀNG CẢM XÚC"

Để tìm ra hướng đi đắt giá nhất cho MVP, đội ngũ đã đặt lên bàn cân 3 hướng tiếp cận thiết kế:

#### 1. Tiếp cận A: "Kệ Gỗ Ký Ức Hoài Cổ" (The Cozy Memory Cabinet - CHỌN 🏆)
*   **Mô tả:** Thiết kế giả lập một chiếc tủ gỗ nhỏ trong phòng ngủ vẽ theo phong cách màu nước Studio Ghibli. Các vật phẩm đã thảo luận trong chat được nhân cách hoá thành các vật thể vật lý chạm được bày trên kệ: **Âm nhạc** là chiếc đĩa than cổ điển; **Văn học** là cuốn sách cũ; **Địa điểm** là tấm ảnh Polaroid ghim trên bảng nỉ.
*   **Trải nghiệm người dùng:** Khi nhấp vào đĩa than, đĩa trượt xoay ra khỏi vỏ bọc (micro-spring animation) phát thử 30s nhạc. Sách cũ trồi lên hiển thị câu trích dẫn chữa lành.
*   **Đánh giá của Persona:** 
    *   *Sophia (CPO) thích nhất:* Vì nó biến dữ liệu ảo thành các kỷ vật vật lý mang tính tích lũy cảm xúc cao (Cột trụ 4). Nó mang lại cảm giác sở hữu và ấm áp thực sự thay vì danh sách khô khan.
    *   *Arthur (Hành vi) đánh giá:* Cực kỳ hấp dẫn. Nó gắn chặt với triết lý Tamagotchi: người dù
<truncated 4480 bytes>
 thiết kế này vào tệp tài liệu mới **[SPEC_11_COZY_SHELF_LIBRARY.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_11_COZY_SHELF_LIBRARY.md)** với cấu trúc dữ liệu SQLite bảo đảm tính nhất quán cao:

```sql
CREATE TABLE unlocked_shelf_items (
    item_id VARCHAR(36) PRIMARY KEY,       -- ID duy nhất của vật phẩm
    category VARCHAR(32) NOT NULL,          -- 'music' (đĩa than), 'literature' (sách cổ), 'location' (địa điểm)
    title TEXT NOT NULL,                    -- Tên bài hát, cuốn sách, tiệm cafe
    subtitle TEXT,                          -- Tên ca sĩ, tác giả
    ghibli_art_asset TEXT NOT NULL,         -- Đường dẫn local của ảnh màu nước Ghibli
    boss_quote TEXT,                        -- Lời thoại thấu cảm cá nhân hoá của Boss tặng Sen
    poetic_content TEXT,                    -- Câu trích dẫn hoặc URL stream 30s nhạc
    external_url TEXT NOT NULL,             -- Link dẫn ngoài (Spotify, Shopee Nhã Nam, Google Maps)
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pet_id VARCHAR(64) NOT NULL,            -- ID Boss ảo đã mở khoá kỷ niệm
    FOREIGN KEY(pet_id) REFERENCES pet_details(id) ON DELETE CASCADE
);
```

### 🐾 BƯỚC TIẾP THEO

Tôi đã hoàn thành xuất sắc việc phân tích hướng tiếp cận và lập tài liệu đặc tả PRD đồng bộ cho phân hệ **Kệ Gỗ Ký Ức**. Bạn đánh giá thế nào về chiếc tủ kỷ niệm này? Chúng ta nên tiếp tục làm rõ phân hệ nào trong MVP tiếp theo:

1.  **Phân hệ Meme Card Generator (SPEC_03 - Memory Vault):** Cách cắt ghép mặt thú cưng tự động vào 15 khung hình meme Ghibli màu nước bằng Canvas ngay trên điện thoại (chi phí server = 0đ).
2.  **Hàng đợi nạp Moments ngầm (SPEC_04 - Memory Vault):** Thuật toán nạp ngầm FIFO và tự động ẩn/hiện banner tương tác Buffet Ký ức ở trang Home.
