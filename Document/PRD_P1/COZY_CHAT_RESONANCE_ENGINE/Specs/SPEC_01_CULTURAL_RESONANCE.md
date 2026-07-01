# ĐẶC TẢ CHI TIẾT 01: COZY CULTURAL RESONANCE ENGINE
*(CỘNG HƯỞNG VĂN HÓA & TIẾP THỊ LIÊN KẾT)*

> **Mã Đặc Tả:** `SPEC-COZY-01`  
> **Chủ trì:** Sophia (CPO / PM)  

---

## 🧭 1. Thiết Kế Trải Nghiệm Hyperlink Hoài Cổ & Postcard Trivia

Để giữ đúng tinh thần chữa lành Iyashikei mộc mạc và hoài niệm, Hyperlink trong khung chat sẽ không sử dụng màu xanh lam gắt công nghiệp.

### 1.1. Visual Hyperlink Design
*   **Màu sắc theo giống loài (Species Theming):**
    *   *Mèo (Cat) - Sakura Pink Theme:* Link có màu hồng sậm ấm áp `#D37A7A` kèm đường gạch chân chấm mảnh (dotted underline) thanh nhã.
    *   *Chó (Dog) - Matcha Green Theme:* Link có màu xanh Matcha sậm tinh tế `#5E7353` kèm đường gạch chân tương tự.
*   **Tương tác (Interaction):** Nhấp vào link sẽ không mở trình duyệt ngoài làm đứt gãy luồng cảm xúc, mà trượt nhẹ một Bottom Sheet kính mờ `Glassmorphic` (bo góc `28px`) hiển thị thông tin dạng một tấm Postcard hoài niệm.

---

## 🛠️ 2. Apple Music / iTunes API & Spotify Fallback

Để giải quyết triệt để vấn đề stream nhạc 30s preview và affiliate một cách tinh gọn nhất:

```
                  LUỒNG DỮ LIỆU NHẠC PREVIEW & AFFILIATE
    
    [ iTunes Search API ] ──► (Kéo direct MP3 previewUrl) ──► [ just_audio Flutter Library ]
                                                                      │
                                                           (Phát ngầm trong 30 giây)
```

1.  **Nguồn nhạc 30s Preview miễn phí:** 
    *   Sử dụng **iTunes Search API** (Ví dụ: `https://itunes.apple.com/search?term=beatles+yesterday&limit=1`).
    *   API trả về trực tiếp trường `previewUrl` chứa đường dẫn trực tiếp đến file âm thanh `.m4a` hoặc `.mp3` 30s chất lượng cao. Không cần đăng nhập OAuth phức tạp của Spotify.
2.  **Tiếp thị liên kết Nhạc (Affiliate):**
    *   Đăng ký **Apple Services Affiliate Program** (quản lý qua **Partnerize**) – Duyệt tự động cho thị trường Việt Nam.
    *   Trên Bottom Sheet Postcard hiển thị:
        *   Nút chính: **[Nghe trên Apple Music]** -> Gắn Link Affiliate Apple (để nhận hoa hồng trực tiếp).
        *   Nút phụ: **[Nghe trên Spotify]** -> Deep-link mở thẳng app Spotify của người dùng (tăng trải nghiệm, thu affiliate sau khi được Spotify Impact duyệt).

---

## 🛍️ 3. Tiếp Thị Liên Kết Sách & Văn Hóa Phẩm (Shopee Mall)

Tập trung 100% tỷ lệ chuyển đổi checkout thực tế tại thị trường Việt Nam:
*   **Đối tác chính:** **Shopee Partner / Affiliate Program** – Đăng ký duyệt tự động trong 5 phút.
*   **Nguồn sách:** Gắn Link Affiliate đến các gian hàng Shopee Mall uy tín của các nhà xuất bản sách chữa lành hoài cổ tại Việt Nam như **Nhã Nam**, **Bloom Books**, **Phục Hưng Books** (nơi dịch độc quyền Murakami, Keigo Higashino, v.v.).
*   **Tỷ lệ checkout:** Gần như 100% vì người dùng Việt Nam đều đã cài sẵn Shopee, có sẵn địa chỉ giao hàng và liên kết ví thanh toán. Hoa hồng nhận được từ **4% - 8%** giá trị cuốn sách.
