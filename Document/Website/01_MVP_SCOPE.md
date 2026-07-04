# 🏛️ ĐẶC TẢ PHẠM VI MVP WEBSITE AFFILIATE (DOCA VALIDATION)
*(DOCA Affiliate & Validation Web MVP - PRD & Scope Document)*

> **Mã Tài Liệu:** `PRD-WEBSITE-MVP-SCOPE`  
> **Phiên bản:** `V1.3 (Tối giản Fake Door)`  
> **Chủ trì:** Sophia (CPO / PM)  
> **Mục tiêu:** Định hình phạm vi tối giản nhất cho Website Affiliate. Tính năng Mua chung được thiết kế ở dạng **Fake Door siêu tối giản** (Chỉ hiện nút + Popup thông báo cute + Ghi nhận số liệu click) để đo lường nhu cầu mà không bắt người dùng nhập email, giảm friction tối đa.

---

## 🎯 1. Mục Tiêu & Định Vị MVP (Product Goals & Niche)

Website này **không phải** là một trang tin tức khổng lồ, cũng **không phải** là một trang thương mại điện tử phức tạp. Đây là một **phễu hứng và đo lường cảm xúc của người dùng**. 

*   **Ngách (Niche):** Lối sống chữa lành (Iyashikei) kết hợp với tình yêu thú cưng sâu sắc.
*   **Trọng tâm cốt lõi:** Đo lường 2 chỉ số sống còn:
    1.  **Ý định mua sắm (Commercial Intent):** Người nuôi pet có sẵn sàng click vào link để mua các sản phẩm chữa lành (sách, nến thơm, đĩa nhạc, phụ kiện tốt) mà chúng ta gợi ý hay không? (Đo bằng CTR của Affiliate Link).
    2.  **Đo lường ý định mua sỉ (Group Buy Intent):** Tỷ lệ người dùng nhấp vào nút gom mua chung giá rẻ là bao nhiêu? (Đo bằng số click vào nút Fake Door Mua Chung).
    3.  **Ý định gắn kết lâu dài (Loyalty & Waitlist):** Người dùng có sẵn sàng để lại email để nhận bản Beta sớm của App di động hay không? (Đo bằng Conversion Rate của form đăng ký).

---

## 🧭 2. Nguyên Tắc Thiết Kế Trải Nghiệm (UX Design Principles)

Để hòa hợp với định vị của App DOCA sau này, Web MVP phải tuân thủ:
1.  **MUJI & Ghibli Aesthetics:** Giao diện tối giản, sử dụng các gam màu ấm của đất (Warm Earthy), màu gỗ, và màu trắng ngà. Font chữ header có chân (Serif) mềm mại, gợi cảm giác mộc mạc của trang sách cũ.
2.  **Mobile-First Absolute:** 90% lượng traffic sẽ từ Facebook Reels/TikTok/Instagram chuyển hướng sang thông qua thiết bị di động. Giao diện mobile bắt buộc phải load cực kỳ nhanh (dưới 1.5 giây) và không bị lỗi vỡ layout.
3.  **Giảm thiểu Friction (Rào cản):** Cho phép người dùng tương tác trực tiếp bằng 1-click. Việc đo lường mua chung chỉ cần ghi nhận hành động click chuột chứ không bắt buộc điền form dài dòng.

---

## ⚔️ 3. Phân Rã Tính Năng Bằng MoSCoW (The Scope Guillotine)

Sophia (CPO) áp dụng nguyên tắc tối giản hóa kỹ thuật để tối ưu hóa thời gian phát triển và hạn chế nợ kỹ thuật tối đa:

```
                  ┌────────────────────────────────────────┐
                  │          PHẠM VI WEBSITE MVP           │
                  └───────────────────┬────────────────────┘
                                      │
        ┌──────────────────┬──────────┴──────────┬──────────────────┐
        ▼                  ▼                     ▼                  ▼
   [MUST-HAVE]       [SHOULD-HAVE]         [COULD-HAVE]        [WON'T-HAVE]
  (Bắt buộc có)      (Nên có sớm)         (Có thể có sau)     (Cắt bỏ 100%)
  - Home tối giản   - Giao diện Polaroid  - Lưu trữ thư cũ    - Hệ thống Login
  - Blog & 4 Niche    Bottom Sheet         của Namiya          - Giỏ hàng & Thanh toán
  - Hòm thư Namiya  - Trang About App                         - Mua chung thực tế
    (Tối giản)        định vị DOCA                             - Form nhập mail sỉ
  - Email Waitlist                                             - CMS Admin tự code
  - Nút Mua Chung
    (Fake Door Click)
  - GA4/DB Click Log
```

### 🌟 3.1. MUST-HAVE (Bắt buộc phải có)
1.  **Trang chủ & Danh sách sản phẩm tối giản (Cozy Home & Curated Shelf):**
    *   Hiển thị danh mục sản phẩm Affiliate chia làm 4 nhóm rõ rệt: **Thức ăn cho mèo**, **Vật phẩm chăm sóc mèo**, **Sách chữa lành**, và **Phụ kiện nhà ở chữa lành** (Nguồn link dẫn từ Shopee & Fahasa).
2.  **Trang bài viết chi tiết (Minimalist Blog Post):**
    *   Đọc nội dung và các bài review chia sẻ. Chèn link Affiliate dạng **Gạch chân chấm mảnh (Cozy Dotted Underline)**. Nhấp vào sẽ mở trực tiếp link Shopee/Fahasa của lập trình viên.
3.  **Nút Mua Chung Fake Door (Group Buy Fake Door):**
    *   Hiển thị nút `[Gom mua chung giá sỉ 🐾]` ngay cạnh nút mua lẻ.
    *   **Trải nghiệm người dùng:** Khi nhấp vào, hiện ngay thông báo cute kiểu chữa lành: *"Tính năng này đang được tụi con chuẩn bị, hoặc tụi con chưa thương lượng xong với bên bán hàng đâu ạ... Cô/chú chờ tụi con tí nhé! 🐾"*
    *   **Ghi nhận số liệu:** Tự động tăng biến đếm click (Click Count Event) lưu lên Supabase/GA4 để ghi nhận thị hiếu mà không bắt người dùng nhập email.
4.  **Hộp thư gỡ rối tơ lòng Namiya (Minimalist Mamiya Mailbox):**
    *   *Mục đích:* Đo lường mức độ tin tưởng của khách truy cập (họ có sẵn sàng chia sẻ tâm sự thầm kín không).
    *   *Giải pháp MVP:* Nhúng một Form tối giản phong cách gỗ ấm (dùng Tally Form, Google Form được CSS lại hoặc API gửi email thẳng về Admin). Người dùng chỉ cần để lại **Email + Lời tâm sự**. Không cần tạo mật khẩu hay đăng ký tài khoản.
5.  **Form đăng ký nhận thư từ Boss (Cozy Lead Capture):**
    *   Đăng ký nhận Weekly Newsletter và slot chạy Beta App DOCA qua email.
6.  **Hệ thống đo lường chuyển đổi (Conversion Tracking):**
    *   Cài đặt GA4 theo dõi traffic và ghi nhận sự kiện click link Affiliate của từng danh mục sản phẩm cũng như số lượt click nút Mua chung Fake Door.

### 💫 3.2. SHOULD-HAVE (Nên có nếu phát triển nhanh)
1.  **Cozy Polaroid Bottom Sheet (Giao diện gợi ý sản phẩm):**
    *   Khi người dùng nhấp vào link sản phẩm, một bảng Polaroid mượt mà trượt lên hiển thị ảnh bìa, trích dẫn ngắn, nút mua lẻ Shopee/Fahasa và nút gom mua chung.
2.  **Trang giới thiệu về App DOCA (Pre-launch Landing Page):**
    *   Giải thích ngắn gọn cho độc giả biết "DOCA là gì?" để tăng tỷ lệ để lại email đăng ký Waitlist.

### ✨ 3.3. COULD-HAVE (Có thể bổ sung ở bản V1.1)
1.  **Góc cảm xúc / Tiệm sách Namiya tập trung (Cozy Curated Library):**
    *   Một trang danh mục tổng hợp các món đồ chữa lành đã được giới thiệu để người dùng lướt nhanh thay vì phải đọc từng bài viết.
2.  **Lưu trữ thư cũ của Namiya (Namiya Letters Archive):**
    *   Hiển thị một số bức thư ẩn danh tiêu biểu đã được Boss hồi đáp (sau khi xin phép chủ nhân) để tăng tính tương tác.

### 🚫 3.4. WON'T-HAVE (Cắt bỏ hoàn toàn để tránh Scope Creep)
1.  **❌ Hệ thống Đăng ký / Đăng nhập thành viên (Login System).**
2.  **❌ Vận hành Mua chung thực tế (Pre-order Logistics).**
3.  **❌ Form nhập email mua chung (Group Buy Email Capture):** Thay thế bằng cơ chế ghi nhận click ẩn danh trực tiếp để tối ưu trải nghiệm và giảm friction.
4.  **❌ Trang quản trị tự viết (CMS Backend).**
5.  **❌ Hệ thống Thanh toán & Giỏ hàng trực tiếp.**
6.  **❌ Khung bình luận (Comment Section) phức tạp.**

---

## 📈 4. Chỉ Số Đo Lường Thành Công (Success Metrics)

Để đánh giá mức độ thành công của MVP và đưa ra quyết định có nên bấm nút khởi động phát triển App di động DOCA hay không, chúng ta sẽ dựa vào bảng chỉ số sau:

| Chỉ số | Cách đo lường | Mục tiêu tối thiểu (Benchmark) | Ý nghĩa validation |
| :--- | :--- | :--- | :--- |
| **Lượt truy cập (Traffic)** | Lượt xem trang độc nhất (Unique Visitors) từ nguồn Social. | **> 1,000 khách truy cập/tháng** | Đánh giá mức độ hiệu quả của kênh Social Reels/TikTok dẫn về. |
| **Độ giữ chân đọc (Retention)** | Thời gian đọc trung bình (Average Time on Page). | **> 1.5 phút/bài viết** | Xác định độc giả thực sự đọc và đồng cảm với nội dung Iyashikei hay chỉ click nhầm. |
| **Tỷ lệ Click Affiliate (CTR)** | Lượt click link Affiliate / Tổng lượt xem bài viết. | **> 3%** | Xác nhận tệp người dùng này có hành vi mua sắm các sản phẩm tinh thần/vật phẩm thú cưng thực tế. |
| **Tỷ lệ click Mua chung** | Lượt click nút "Gom sỉ Mua chung" / Tổng lượt xem. | **> 4%** | Xác định nhu cầu mua sắm tiết kiệm theo nhóm đối với sản phẩm đề xuất. |
| **Tỷ lệ đăng ký Waitlist** | Lượng Email đăng ký mới / Tổng số lượt truy cập. | **> 5%** | Xác định mong muốn sở hữu một ứng dụng di động lưu trữ ký ức và kết nối với AI Pet (App DOCA). |

---

## 🏁 5. Định Nghĩa Hoàn Thành (Definition of Done - DoD)

Trang web MVP được coi là hoàn thành và sẵn sàng chạy thử nghiệm khi:
*   [ ] Đã xuất bản tối thiểu **3 bài viết chất lượng cao** đại diện cho 3 cột trụ nội dung.
*   [ ] Các bài viết đều được chèn ít nhất 2 link Affiliate hoạt động chính xác.
*   [ ] Nút Mua Chung hiển thị đúng thông báo cute chỉ định và tự động tăng biến đếm số liệu click thành công.
*   [ ] Form đăng ký Waitlist hoạt động mượt mà, lưu trữ email thành công vào cơ sở dữ liệu Supabase.
*   [ ] Trình duyệt trên thiết bị di động hiển thị đúng chuẩn thẩm mỹ chữa lành (Responsive & Fast Loading < 1.5s).
*   [ ] Mã theo dõi GA4/Supabase đã được cài đặt và ghi nhận sự kiện nhấp link chính xác.
