# 🎨 HƯỚNG DẪN BIÊN SOẠN BÀI VIẾT BLOG (BLOG CONTENT GUIDELINE) - DOCA
*(Định hình cấu trúc bố cục, phong cách Iyashikei và cách lồng ghép Co-marketing)*

Tài liệu này đóng vai trò làm khung sườn hướng dẫn cách biên soạn và trình bày các bài viết Blog cho website **doca.capcat.vn**. Mục tiêu là đảm bảo sự cân bằng: **Không quá chặt chẽ** để giữ gìn sự sáng tạo riêng của từng bài viết, nhưng **không quá lỏng lẻo** để tránh bài viết bị đơn điệu và vô hồn.

---

## ⚙️ 0. CƠ CHẾ HIỂN THỊ ĐỘNG & TỰ ĐỘNG (DYNAMISM RULES)

Để tăng tính chân thật và sinh động cho blog, website tự động áp dụng các quy tắc kỹ thuật sau:
*   **Nhãn danh mục (Category Label):** Toàn bộ nhãn hiển thị ở góc trên bên trái của Card bài viết ngoài trang chủ và trang chi tiết sẽ hiển thị theo **tên tiếng Việt của Pillar** tương ứng (`Nhịp Thở Đồng Diệu`, `Lăng Kính Của Pet`, `Hộp Ký Ức Bình Yên`) để đồng bộ nhận diện thương hiệu.
*   **Chỉ số sinh động tự động (Deterministic Metrics):** Không sử dụng số liệu tĩnh (như 3 phút đọc, xoa dịu 95% lặp lại cho tất cả các bài).
    *   *Thời gian đọc:* Tự động tính toán dựa trên độ dài bài viết (cứ 500 ký tự tiếng Việt tương ứng 1 phút đọc, tối thiểu 2 phút).
    *   *Mức độ xoa dịu (%):* Được tính toán dựa trên thuật toán băm (hash) cố định từ tiêu đề bài viết để tạo ra chỉ số dao động tự nhiên từ `88%` đến `98%` nhưng nhất quán ở mỗi lần reload.
*   **Vị trí ảnh bìa tự động (Inline Cover Image):** Ảnh bìa (`coverImage`) không hiển thị to đính kèm ở đầu trang cạnh bong bóng khuyên đọc của Tina nữa. Hệ thống tự động di chuyển ảnh này chèn xen kẽ vào thân bài viết (sau đoạn văn thứ 2) bọc trong khung thẻ `figure` kèm dòng chú thích in nghiêng tinh tế.

---

## 🍃 1. TÔNG GIỌNG CHỦ ĐẠO (VOICE & TONE)
Tông giọng của Blog DOCA được định hình theo phong cách **MUJI Warm Minimalism & Iyashikei** (chữa lành mộc mạc kiểu Nhật):

*   **Đồng cảm & Trực diện:** Nhìn thẳng vào những áp lực, nỗi lo lắng thực tế của người trẻ đô thị (cảm giác tội lỗi khi để pet cô đơn, áp lực đồng trang lứa, mệt mỏi công sở).
*   **Thủ thỉ & Thân mật:** Viết như một lời tâm sự nhẹ nhàng từ chú mèo gửi tới cô/chú chủ nuôi. Xưng hô khuyên dùng: *"Tụi con"*, *"Bé cưng"*, *"Cô/chú"*.
*   **Mộc mạc & Gần gũi:** Tôn vinh cuộc sống giản dị dưới mái nhà nhỏ, không dùng các từ ngữ đắt đỏ, xa hoa hay mang tính phán xét, giáo điều.

---

## 📐 2. CẤU TRÚC BỐ CỤC LINH HOẠT (5 PHẦN)

Mỗi bài viết Blog của DOCA nên tuân thủ khung cấu trúc dưới đây để đảm bảo tính nhận diện thương hiệu nhất quán:

```
[Nhãn Pillar đầu trang] (ví dụ: Nhịp Thở Đồng Diệu)
      │
      ├─► [Curator Speech Bubble] (Bong bóng thoại của Tina/Latte/Muối khuyên đọc)
      │
      ├─► [Dẫn nhập - Intro] (Đặt vấn đề, đồng cảm với áp lực đô thị)
      │
      ├─► [Nội dung chính - Body] (Các mẹo nhỏ thực tế + Trích dẫn triết lý blockquote)
      │      └─► [Inline Polaroid Card] (Nhúng card sản phẩm liên kết thông minh)
      │
      └─► [Kết bài - Outro & Co-marketing CTA] (Gom mua chung / Hòm thư Namiya)
```

### Phần 1: Tiêu đề & Nhãn Pillar (Pillar Label)
*   **Tiêu đề:** Gợi mở, mang tính chất sống chậm, thiền định (ví dụ: *"Trăng đêm nay thật đẹp"*, *"Hoàng hôn buông và 10 phút chải lông"*).
*   **Pillar Label:** Mỗi bài viết bắt buộc được gán nhãn thuộc 1 trong 3 Trụ cột nội dung:
    *   **Nhịp Thở Đồng Diệu** (`pillar: nhip_tho`): Giải tỏa cảm giác tội lỗi khi pet cô đơn và đồng bộ nhịp sinh học tự nhiên.
    *   **Lăng Kính Của Pet** (`pillar: lang_kinh`): Xoa dịu áp lực thành công và áp lực làm chủ nuôi hoàn hảo.
    *   **Hộp Ký Ức Bình Yên** (`pillar: hop_ky_uc`): Xoa dịu kiệt sức đô thị và lưu trữ những khoảnh khắc vụn vặt nhất.

### Phần 2: Bong bóng thoại Boss khuyên đọc (Curator Speech Bubble)
*   Đặt ngay dưới tiêu đề. Hiển thị avatar tròn của chú mèo đại diện tuyển chọn (**Tina** chữa lành/thông thái, **Latte** tinh nghịch/ăn vặt, **Muối** sưởi ấm/nhút nhát) kèm câu trích dẫn ngắn khơi gợi sự tò mò của người đọc.

### Phần 3: Lời dẫn nhập đồng cảm (Intro)
*   Gọi tên một khủng hoảng tâm lý đô thị cụ thể (Owner's Guilt, Urban Burnout, Quarter-life Crisis) để kéo người đọc vào thế giới của bài viết.

### Phần 4: Thân bài & Nhúng thẻ Polaroid (Body & Inline Card)
*   **Triển khai nội dung:** Sử dụng danh sách các bước (Step 1, Step 2...) hoặc gạch đầu dòng trực quan để người đọc dễ theo dõi kể cả khi cuộn nhanh bằng di động.
*   **Trích dẫn triết lý:** Sử dụng thẻ blockquote (`> *“...”*`) in nghiêng để tạo điểm nhấn sâu lắng về sợi dây liên kết giữa người và pet.
*   **Nhúng sản phẩm:** Chèn thẻ `<div class="inline-product-card" data-slug="[slug]"></div>` sau phần giải thích công dụng của vật phẩm. Lồng ghép tự nhiên như một lời khuyên chân thành từ thú cưng, tuyệt đối không chê bai đồ dùng cũ hay ép buộc người nuôi phải mua sắm.

### Phần 5: Kết bài & Kêu gọi Co-marketing (Outro & Co-marketing CTA)
*   Khơi gợi tương tác tinh thần bằng cách hướng dẫn người dùng click nút nhảy nhanh xuống chân trang gửi gắm tâm sự vào **Hòm thư Namiya**.
*   Kêu gọi **Gom mua chung** sản phẩm liên kết để Boss đo lường số lượng và đàm phán mức giá sỉ cực rẻ từ các nhà sản xuất đối tác, giúp giảm áp lực chi tiêu.

---

## 🤝 3. CHIẾN LƯỢC CO-MARKETING (ĐỒNG SÁNG TẠO & ĐỐI TÁC)
Để tối ưu hóa sức lan tỏa và mang lại giá trị thiết thực nhất cho người nuôi pet, các bài viết nên tích hợp các chiến dịch co-marketing:

1.  **Hợp tác Nội dung (Guest Posts & Swaps):**
    *   Đồng tác giả với các nhà sách (sách chữa lành), shop đồ gỗ decor tối giản (setup góc làm việc), hoặc các local brand thảm vải linen mộc mạc.
2.  **Chiến dịch Gom Mua Chung (Group Buying):**
    *   Mỗi thẻ sản phẩm nhúng đều có cơ chế kích hoạt gom mua chung. Bài viết đóng vai trò giải thích vì sao khi gộp đơn mua cùng nhau, chúng ta sẽ được đối tác chiết khấu lên đến 35-40%, giúp tiết kiệm chi phí nuôi pet.

---

## 🚨 4. RANH GIỚI ĐỎ MANIFESTO (BẤT BIẾN)
*   **Không tạo mặc cảm:** Không bao giờ đăng tải hoặc đánh giá phương pháp nuôi pet theo chuẩn mực đắt đỏ, không chê bai khẩu phần ăn bình dân của người nuôi.
*   **Không dọa dẫm:** Không dùng các video hay bài viết mang tính tiêu cực về tác hại của việc thức khuya hay cảnh báo y tế tiêu cực để dọa dẫm hay ép buộc thay đổi hành vi.
*   **Không thương mại hóa nỗi đau:** Không dùng nỗi đau mất mát thú cưng để giật tít hay cố gắng bán các dịch vụ lưu trữ đám mây/tâm linh thiếu tế nhị.

---

## 📝 5. KHUNG MẪU MARKDOWN CHUẨN (TEMPLATE COPY-PASTE)

Dưới đây là khung mã nguồn Markdown chuẩn cấu trúc phân cấp để các tác giả sao chép trực tiếp khi tạo bài viết mới:

```markdown
---
title: "Tiêu đề bài viết gợi cảm xúc (Dưới 70 ký tự)"
description: "Mô tả ngắn gọn nội dung bài viết, thu hút người đọc (Dưới 150 ký tự)"
publishDate: "YYYY-MM-DD"
coverImage: "https://images.unsplash.com/... (Link ảnh Unsplash chất lượng cao)"
category: "sach" # Một trong các danh mục: thuc_an, vat_pham, sach, phu_kien
tags: ["Tag 1", "Tag 2", "Tag 3"]
relatedProducts: ["slug-san-pham-chinh"] # Ví dụ: ["sach-tam-ly-meo"]
pillar: "nhip_tho" # Một trong các pillar: nhip_tho, lang_kinh, hop_ky_uc
---

[Lời dẫn nhập 1: Nêu vấn đề hoặc khơi gợi sự đồng cảm, khoảng 2-3 câu ngắn]

[Lời dẫn nhập 2: Hướng đến nội dung sẽ chia sẻ giải quyết vấn đề, khoảng 1-2 câu]

---

## [Emoji tương ứng] Tiêu đề mục lớn H2 đầu tiên (Ví dụ: 🐾 Câu chuyện về Boss)

[Đoạn văn phân tích nội dung mộc mạc, khoảng 3-4 câu]

[Đoạn văn mở rộng ý kiến hoặc đưa ra lời giải thích chi tiết hơn]

> *“Một câu trích dẫn in nghiêng đúc kết triết lý cốt lõi đầy sâu lắng của mục này.”*

---

## [Emoji tương ứng] Tiêu đề mục lớn H2 thứ hai (Ví dụ: 🧬 Giải mã hành vi)

[Đoạn văn ngắn dẫn dắt vào danh sách chi tiết]

*   **Ý chính 1 (Bôi đậm):** Mô tả chi tiết ý thứ nhất.
*   **Ý chính 2 (Bôi đậm):** Mô tả chi tiết ý thứ hai.
*   **Ý chính 3 (Bôi đậm):** Mô tả chi tiết ý thứ ba.

[Đoạn văn kết nối nội dung với tính năng tương lai của app di động DOCA hoặc định vị sản phẩm]

---

## [Emoji tương ứng] Tiêu đề mục gợi ý sản phẩm H2 (Ví dụ: 📚 Gợi ý từ Boss)

[Lời nhắn gửi của Boss khuyên dùng sản phẩm một cách chân thành, khoảng 1-2 câu]

<div class="inline-product-card" data-slug="slug-san-pham-chinh"></div>

[Lời rủ rê gom mua chung hoặc hướng dẫn nhấp nút để gửi tâm sự ẩn danh xuống Hòm thư Namiya]
```
