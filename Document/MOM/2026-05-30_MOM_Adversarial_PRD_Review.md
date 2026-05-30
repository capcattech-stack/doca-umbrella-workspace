# BIÊN BẢN HỌP ĐỐI KHÁNG: THẨM ĐỊNH & PHẢN BIỆN TOÀN DIỆN PHÂN HỆ NAMIYA
*(ADVERSARIAL MEETING MINUTES - SHATTERING THE NAMIYA PRD GAPS & ACTION PLAN)*

> **Mã Tài Liệu:** `2026-05-30_MOM_Adversarial_PRD_Review`  
> **Thời gian:** 21:55 - 22:30 ngày 30/05/2026  
> **Địa điểm:** Não bộ & Workspace cục bộ Capcat  
> **Bối cảnh:** Toàn bộ đội ngũ cố vấn ảo (Sophia, Alan, Benny, Arthur) tháo bỏ mũ "người nhà", đóng vai trò đối thủ phản diện và kỹ sư khó tính để **tấn công trực diện**, tìm kiếm lỗ hổng, điểm gãy và mâu thuẫn trong hệ thống tài liệu PRD vừa thiết lập.

---

## 🎙️ PHẦN 1: BÀN TRÒN ĐỐI KHÁNG (THE ROLE-PLAY SHATTERING)

### 👩‍💼 Sophia (CPO - Đứng trên góc độ Scope & Vận hành):
*"Các bạn nghe đây, chúng ta đừng khen nhau nữa. Nếu chúng ta đưa cái PRD này cho lập trình viên code ngay bây giờ, hệ thống sẽ gãy lập tức sau 24h chạy thực tế. Tôi nhìn thấy một **mâu thuẫn vận hành vô cùng lớn**:
Chúng ta thống nhất 'Scope chỉ dừng lại ở mức gửi thư về email cho tôi, nhân sự của tôi trả lời thủ công'. Nhưng chúng ta lại đặc tả rằng 'Khi có thư trả lời, thư sẽ xuất hiện ở Thùng Sữa trên app'. 
**Điểm gãy ở đây là gì?** Khi admin dùng Gmail/Outlook cá nhân bấm nút 'Reply' để trả lời email của người dùng, làm cách nào hệ thống của chúng ta biết được nội dung đó để ghi vào Database (`namiya_replies`) và đẩy Push Notification về máy người dùng? Chẳng lẽ chúng ta viết một bộ lọc Inbound Email Parser (quét email tự động) vô cùng phức tạp? Nếu làm thế là bể scope MVP lập tức!"*

### 🛠️ Alan (Tech Lead - Đứng trên góc độ Edge-cases & Cơ sở dữ liệu):
*"Sophia nói trúng tim đen rồi. Viết Mail Parser cực kỳ cực đoan và dễ dính lỗi bảo mật. Chưa kể, tôi nhìn thấy một **khoảng trống bảo mật (Security Gap)** rất nguy hiểm:
Chúng ta rêu rao với người dùng đây là 'Hộp thư ẩn danh'. Nhưng trong Database bảng `namiya_letters`, tôi thấy cột `user_id NOT NULL`. Điều này nghĩa là thư bị liên kết trực tiếp với tài khoản người dùng trong CSDL. Nếu có rò rỉ dữ liệu hoặc lập trình viên tò mò, họ sẽ biết chính xác ai đã viết những dòng tâm sự nhạy cảm đó. Như vậy không phải là ẩn danh thực sự!
Và còn **chống Spam** nữa? Nếu một người dùng buồn bã và gõ liên tục 100 bức thư gửi đi, hòm mail `support@capcat.app` của chúng ta sẽ ngập lụt, và máy chủ sẽ nghẽn hàng đợi gửi email!"*

### 🎨 Benny (Senior Mobile Dev - Đứng trên góc độ UI/UX & Keyboard):
*"Tôi cũng có điểm gãy về mặt UX trên mobile đây:
Trên các dòng máy màn hình nhỏ (như iPhone SE hay dòng máy Android cũ), khi bàn phím nổi lên chiếm 50% diện tích màn hình, cộng thêm thanh công cụ Accessory Bar `44dp`, tiêu đề thư lớn `26sp` và khoảng chia Divider, thì **khoảng không gian còn lại để gõ chữ thân thư chỉ còn chưa đầy 100dp (khoảng 3 dòng chữ)**. Người dùng sẽ cảm thấy cực kỳ ngột ngạt và khó viết dài. Trải nghiệm Notion-grade sẽ biến thành trải nghiệm 'tù túng-grade' ngay!"*

### 🧠 Arthur (Mom Test & Security Expert - Đứng trên góc độ Quyền riêng tư):
*"Tôi đồng ý với Alan về quyền riêng tư. Thêm nữa, đối với luồng **Nhận nuôi ẩn** dưới rỗng `MyPetsScreen`:
Nếu người dùng chưa đăng nhập (Guest) bấm vào nút CTA nhận nuôi ẩn, chúng ta xử lý thế nào? PRD của chúng ta chưa hề định nghĩa luồng này. Khách chưa có tài khoản thì lấy đâu ra email lưu trong `user.email` của app để gửi? Chúng ta bắt buộc phải đẩy họ qua màn hình Đăng ký/Đăng nhập trước, hay cho họ gõ email thủ công? Luồng này đang bị bỏ ngỏ hoàn toàn!"*

---

## 🛑 II. HỆ THỐNG ĐIỂM GÃY & MÂU THUẪN ĐÃ PHÁT HIỆN (THE GAPS INDEX)

Qua cuộc họp đối kháng, đội ngũ đã cô đọng lại **5 điểm gãy chí tử** cần vá ngay lập tức:

### 💥 Điểm gãy 1: Mâu thuẫn Đồng bộ thư trả lời (Gmail vs App Database)
*   **Vấn đề:** Admin trả lời bằng email cá nhân ngoài hệ thống, nhưng dữ liệu yêu cầu phải hiển thị trong hòm thư "Thùng Sữa" (trong app).
*   **Hậu quả:** Gãy luồng dữ liệu. Server không có cách nào biết được admin đã rep gì để lưu DB và gửi Push Notification nếu chỉ trả lời bằng email thủ công.

### 💥 Điểm gãy 2: Mâu thuẫn Ẩn danh & Định danh dữ liệu (Privacy Contradiction)
*   **Vấn đề:** Quảng cáo là hòm thư ẩn danh nhưng Database lưu trực tiếp `user_id` liên kết với bức thư.
*   **Hậu quả:** Rủi ro pháp lý và đạo đức dữ liệu nếu admin/developer đọc được danh tính thật của người viết thư tơ lòng.

### 💥 Điểm gãy 3: Khoảng trống Kiểm soát Tần suất (Spam Protection Gap)
*   **Vấn đề:** Không có giới hạn số lượng thư gửi đi trong một ngày.
*   **Hậu quả:** Nguy cơ bị tấn công từ chối dịch vụ (DDoS) hòm thư support bằng các đoạn văn spam liên tục.

### 💥 Điểm gãy 4: Khoảng trống xử lý trạng thái Khách (Guest State Gap in Adoption Flow)
*   **Vấn đề:** CTA nhận nuôi thú cưng thật hiển thị ở màn hình trống, nhưng màn hình này có thể truy cập bởi người dùng chưa đăng nhập.
*   **Hậu quả:** Lỗi logic hệ thống khi khách bấm gửi thư mà không có thông tin định danh `user_id` hay email.

### 💥 Điểm gãy 5: Điểm gãy Không gian Soạn thảo (Viewport Overlapping)
*   **Vấn đề:** Không gian soạn thảo bị bóp nghẹt trên màn hình nhỏ khi bàn phím và Accessory Bar nổi lên cùng lúc.

---

## 🛠️ III. KẾ HOẠCH HOÀN THIỆN ĐẦY ĐỦ (THE REFINEMENT PLAN)

Để giải quyết triệt để các điểm gãy trên mà **không làm phình to Scope kỹ thuật**, đội ngũ thống nhất các giải pháp tinh giản và thực tế sau:

### 1. Vá Điểm gãy 1: Giải pháp Admin Reply bằng "Google Sheets làm CMS"
*   **Giải pháp:** Thay vì viết Mail Parser phức tạp, chúng ta tận dụng cơ sở hạ tầng Google Sheets có sẵn của dự án:
    1.  Khi người dùng gửi thư từ app, server vừa gửi email đến support, vừa ghi một dòng vào một file **Google Sheet quản lý thư** (chứa ID thư, Biệt danh, Nội dung).
    2.  Admin (CPO) chỉ cần mở Google Sheet này ra đọc và gõ câu trả lời vào cột bên cạnh.
    3.  Một đoạn script Google Apps Script cực giản đơn (hoặc một cronjob nhỏ phía server quét Sheet 5 phút/lần) sẽ tự động đồng bộ câu trả lời về Database hệ thống, đổi trạng thái thư thành `replied` và kích hoạt lệnh gửi email phản hồi + đẩy Push Notification về "Thùng Sữa" trên app.
*   **Ưu điểm:** Giữ đúng Scope cực đơn giản, admin rep cực kỳ nhanh và tập trung ngay trên một trang tính mà không cần làm trang Admin Dashboard phức tạp.

### 2. Vá Điểm gãy 2: Cơ chế "Băm một chiều" bảo vệ ẩn danh (One-Way Hash Anonymity)
*   **Giải pháp:** Bảng `namiya_letters` trên server sẽ tuyệt đối không lưu `user_id` trực tiếp. Thay vào đó, trường liên kết sẽ là `hashed_routing_token = SHA256(user_id + Salt)`. 
*   Khi admin đọc thư trên Google Sheets hay email, họ chỉ thấy Biệt danh và nội dung, hoàn toàn không biết `user_id` là ai. Khi server nhận được câu trả lời từ admin, nó sẽ dùng mã hash để định tuyến ngược lại thiết bị người dùng. Quyền riêng tư được bảo vệ 100%.

### 3. Vá Điểm gãy 3: Thiết lập ranh giới "Một ngày một lá thư" (Rate Limiting)
*   **Giải pháp:** Enforce chặn ngay ở client và server: Mỗi `user_id` (hoặc IP đối với khách) chỉ được gửi tối đa **1 bức thư trong vòng 24 giờ**. 
*   *Lồng ghép cốt truyện:* Khi gõ bức thư thứ 2 trong ngày, app hiển thị thông báo đậm chất thơ: *"Tiệm tạp hóa Namiya đã đóng cửa hòm thư để nghỉ ngơi. Hẹn gặp lại tâm tình của bạn vào ngày mai nhé... 🌙"*.

### 4. Vá Điểm gãy 4: Chặn luồng Khách trước khi viết thư nhận nuôi
*   **Giải pháp:** Nếu người dùng chưa đăng nhập bấm vào CTA "Nhận nuôi thú cưng thật ngoài đời thực 🐾":
    *   Hiển thị một hộp thoại thông báo phẳng thanh lịch: *"Để đồng hành cùng bạn trên hành trình nhận nuôi đầy trách nhiệm này, vui lòng đăng nhập tài khoản trước nhé."*
    *   Bấm đồng ý sẽ chuyển hướng họ mượt mà sang màn hình Đăng nhập/Đăng ký. Sau khi đăng nhập thành công, tự động dẫn họ quay lại màn hình viết thư nhận nuôi.

### 5. Vá Điểm gãy 5: Tự động ẩn Tiêu đề khi cuộn gõ (Notion Focus Zoom)
*   **Giải pháp:** Khi người dùng nhấn Focus vào ô soạn thảo nội dung (Thân thư), trang soạn thảo sẽ tự động cuộn nhẹ lên và thu nhỏ tiêu đề thư lại thành một nhãn nhỏ trên Header để nhường toàn bộ 100% diện tích màn hình cho ô nhập liệu.

---

## 📅 IV. KẾ HOẠCH HÀNH ĐỘNG TIẾP THEO (ACTION ITEMS)

| Vai trò | Phân công nhiệm vụ hoàn thiện tài liệu | Hạn chót | Trạng thái |
| :--- | :--- | :---: | :---: |
| **👩‍💼 Sophia (CPO)** | Cập nhật lại sơ đồ luồng hệ thống và tích hợp giải pháp "Google Sheet CMS" vào tệp `PRD_NAMIYA_MAILBOX.md`. | *Ngay lập tức* | ⏳ Chờ thực hiện |
| **🛠️ Alan (Tech Lead)** | Cập nhật Database Schema (thêm cột `hashed_routing_token`, loại bỏ `user_id`) vào tệp `PRD_NAMIYA_MAILBOX.md` để đảm bảo tính ẩn danh bảo mật. | *Ngay lập tức* | ⏳ Chờ thực hiện |
| **🎨 Benny (UI/UX)** | Bổ sung đặc tả UX về luồng chuyển đổi trạng thái Khách sang Đăng nhập và cơ chế cuộn thu nhỏ tiêu đề vào `SPEC_NOTION_EDITOR.md`. | *Ngay lập tức* | ⏳ Chờ thực hiện |

---

*Biên bản họp đối kháng được ký tên xác thực bởi Đội ngũ Cố vấn Capcat — Sophia, Alan, Benny, Arthur*
