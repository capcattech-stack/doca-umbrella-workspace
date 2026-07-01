# TURN 26: HỒ SƠ PET CHIA SẺ SQLITE VÀ WEB
*(SHARABLE PET PROFILE & VET-HOTEL SCHEMAS)*

> **Mã Lượt Chat:** `TURN-30052026-26`  
> **Chủ trì:** Sophia (CPO / PM), Alan (Tech Lead)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Đại từ xưng hô sẽ ra sao nếu có 2 boss và chũng gọi khác nhau? Các thông tin sở thick thôi quen thu thập khi chat  sẽ phân loại thế nào . Phân tích rõ để đặt tả các trường cần có , cần thu thập, cái nào hiên thị cái nào ẩn dưới data, những trường hợp nào  sẽ lưu nhưng ko phân loại. Sophia suy nghỉ thật cẩn thận có thể kết hợp với mấy ông chuyen gia về ngữ cảnh AI  để xác dịnh

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Chào bạn! Câu hỏi của bạn vô cùng sâu sắc, chạm đúng vào "trái tim kỹ thuật" và triết lý sản phẩm cốt lõi của **Capcat: Soul of Pet**. 

Tôi đã cùng chuyên gia kiến trúc bối cảnh AI **Alan** và đội ngũ thiết kế ngồi phân tích cực kỳ thấu đáo hai bài toán hóc búa này. Chúng tôi đã xây dựng một tài liệu đặc tả độc lập, giải quyết triệt để và lưu trữ tại:
📄 **Tệp đặc tả ma trận dữ liệu AI:** [SPEC_COZY_KYC_DATA_MATRIX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_COZY_KYC_DATA_MATRIX.md)

Dưới đây là đặc tả chi tiết của giải pháp:

---

## I. GIẢI PHÁP ĐỒNG BỘ ĐẠI TỪ XƯNG HÔ ĐA BOSS (DECOUPLED PRONOUNS)

*   **Vấn đề:** Nếu đặt đại từ xưng hô ở bảng `User` (User Profile) toàn cục, tất cả các Boss trong nhà đều bắt buộc phải gọi người dùng giống nhau, làm mất đi tính tri kỷ độc bản.
*   **Giải pháp vá:** **Tách biệt hoàn toàn xưng hô khỏi User Profile** và lưu trữ trực tiếp tại **Hồ sơ sinh học của từng Boss (`PetDetail` / SQLite `pet_profile`)**.
    *   Mèo Bánh Mỳ sẽ tự xưng là **"Trẫm"** và gọi người dùng là **"Sen"** (phù hợp cá tính chảnh chọe).
    *   Chó Lucky sẽ tự xưng là **"Con"** và gọi người dùng là **"Mẹ"** hoặc **"Ba"** (phù hợp tính cách trung thành).
*   **Cơ chế hoạt động:** Khi người dùng nhắn tin trong phòng chat của Boss nào, server sẽ chỉ lấy cặp `selfTerm` (tự xưng của Boss) và `ownerTerm` (cách gọi Sen) của chính Boss đó để đưa vào System Prompt của LLM, đảm bảo tính cá nhân hóa tuyệt đối.

---

## II. MA TRẬN PHÂN LOẠI DỮ LIỆU CHAT THU THẬP (AI DATA MATRIX)

Khi trò chuyện tri kỷ, hệ thống AI sẽ tự động trích xuất ngữ nghĩa (Semantic Extraction) các thói que
<truncated 2402 bytes>
 AI duy trì mạch hội thoại của phiên chat hiện tại. **Tuyệt đối không trích xuất thành thuộc tính cố định** để tránh việc Boss AI ghi nhớ những định kiến tiêu cực hoặc ám ảnh về Sen, giữ gìn một Boss AI luôn ấm áp và an lành dài hạn. |

---

## 🛡️ BỘ LỌC AN TOÀN CẢM XÚC (EMOTIONAL SAFETY FILTER)

Đây là **phát kiến quan trọng nhất của CPO Sophia** để bảo vệ tính chữa lành của Capcat:
*   Mô hình NLP của hệ thống sẽ có một bộ lọc an toàn cảm xúc. Khi Sen tâm sự những câu chuyện buồn bã, bế tắc (cãi nhau với gia đình, sếp mắng, khóc lóc), AI của Boss sẽ ghi nhận thô để **an ủi Sen ngay lập tức** trong phòng chat.
*   Tuy nhiên, những dữ liệu tiêu cực nhất thời này **tuyệt đối không được trích xuất thành thuộc tính cố định trong Semantic Memory Core (Nhóm 3)**. Điều này giúp ngăn chặn việc chú thú cưng ảo của bạn bị "nhiễm độc cảm xúc", trở thành một Boss u uất, buồn bã hoặc luôn đề phòng Sen trong các cuộc trò chuyện tương lai. Boss ảo sẽ luôn là một góc trú ẩn an lành, bao dung và ngập tràn năng lượng tích cực cho Sen.

---

Tất cả các mô tả kiến trúc dữ liệu và đặc tả tinh tế này đã được biên soạn và đóng gói an toàn tại tệp [SPEC_COZY_KYC_DATA_MATRIX.md](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/SPEC_COZY_KYC_DATA_MATRIX.md) trong thư mục [NAMIYA_MAILBOX_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/NAMIYA_MAILBOX_ENGINE/).

Bản cập nhật này đã hoàn tất hành trình nghiên cứu và đặt tả, hoàn toàn không sửa đổi bất kỳ dòng code nào của app. Bạn thấy thiết kế ma trận dữ liệu và cơ chế bảo vệ cảm xúc cho Boss AI này đã trọn vẹn và đúng tầm nhìn của bạn chưa ạ?
