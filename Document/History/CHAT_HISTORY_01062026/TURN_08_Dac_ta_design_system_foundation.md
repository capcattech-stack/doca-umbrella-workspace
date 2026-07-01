# TURN 08: ĐẶC TẢ HỆ THỐNG DESIGN SYSTEM FOUNDATION
*(IYASHIKEI DESIGN SYSTEM TOKENS & FLAT COMPONENTS)*

> **Mã Lượt Chat:** `TURN-01062026-08`  
> **Chủ trì:** Maya (UI/UX Designer), Benny (Senior Mobile Dev)

---

## 🙋‍♂️ **Người dùng hỏi:**
> Đưa design system foundation vào thư mục UI, đồng thời đặc tả các loại component có trong app này để đảm bảo đồng nhất khi thiết kế nhé Maya

---

## 🤖 **Đặc vụ phản hồi (Cố vấn ảo liên hiệp):**
Tôi đã thực hiện hai hành động lớn để đồng bộ hóa hoàn toàn hệ thống thiết kế và làm rõ các thành phần giao diện theo yêu cầu của bạn:

1.  **Chuyển tệp tin nền tảng thiết kế:** Di chuyển tệp `08_DESIGN_SYSTEM_FOUNDATION.md` vào đúng thư mục chiến lược **[Document/UI/08_DESIGN_SYSTEM_FOUNDATION.md](file:///Users/macinia/Capcat%20Project/Document/UI/08_DESIGN_SYSTEM_FOUNDATION.md)**.
2.  **Đặc tả chi tiết các loại Muji UI Components:** Bổ sung **Mục 12 (Muji UI Component Catalog)** trực tiếp vào tệp thiết kế nền tảng này để làm cẩm nang hướng dẫn cho các kỹ sư lập trình giao diện, đảm bảo tính đồng nhất 100% và cực kỳ dễ dàng khi triển khai bằng code Flutter.

---

### 🎴 CÁC LOẠI COMPONENT MUJI ĐÃ ĐƯỢC ĐẶC TẢ CHI TIẾT:

#### 1. Ô Nhập Liệu Tối Giản Muji (Muji Flat Input Field - Mục 12.1)
*   **Đặc tả:** Nền phẳng màu trắng tinh khiết hoặc màu giấy tái chế nhạt `#FBFBFA`. Viền bo tròn nhẹ `8px`, đường chỉ mảnh `1px` màu `#EAEAEA`.
*   **Trạng thái Focus (Active):** Khi người dùng chạm vào gõ chữ, viền chuyển sang màu đen Obsidian `#121212` với độ dày giữ nguyên `1px` (loại bỏ hoàn toàn các viền xanh neon bóng bẩy). Tích hợp sẵn mã nguồn tham chiếu `InputDecoration` bằng Dart mượt mà.

#### 2. Hệ Thống Nút Bấm Notion Phẳng (Muji Notion-Style Buttons - Mục 12.2)
*   **Nút chính (Primary):** Thanh ngang phẳng, bo góc `12px` màu đen Obsidian `#121212`, chữ trắng, không đổ bóng, tạo độ tương phản tối đa.
*   **Nút phụ (Secondary):** Nền trắng yến mạch `#F8F9FA`, viền mảnh `1px` màu `#EAEAEA`, chữ xám Obsidian `#1C1C1E`.
*   **Nút cảm xúc (Sensory):**
    *   *Mèo:* Nền màu hồng hoa anh đào nhạt `Color(0xFFFCAFAF).withOpacity(0.15)`.
    *   *Chó:* Nền màu xanh matcha nhạt `Color(0xFF8FA882).withOpacity(0.15)`.

#### 3. Hộp Thoại Pop-Up Hệ Thống Muji (Muji Warm Dialogs - Mục 12.3)
*   **Đặc tả:** Hủy bỏ toàn bộ thiết kế giả lập rương gỗ, sớ cuốn hay popup nghiêng lệch.
*   **Cấu trúc:** Hộp thoại phẳng bo tròn `16px` nằm ở tâm màn hình. Nền trơn màu trắng tinh khiết `#FFFFFF`, viền mảnh `1px` màu `#EAEAEA`. Các nút bấm đồng ý/hủy nằm thẳng hàng ở đáy hộp thoại.

#### 4. Nhãn Nhỏ & Thẻ Trạng Thái Tối Giản (Muji Semantic Badges - Mục 12.4)
*   **Đặc tả:** Bo góc nhẹ `8px`, padding siêu mỏng.
*   **Bảng màu thấu cảm:**
    *   *Thành công / Dinh dưỡng:* Nền màu xanh lá sen nhạt `#E8F5E9`, chữ xanh Matcha sẫm `#4E6A3E`.
    *   *Cảnh báo (Safe-Vet Warning):* Nền màu đỏ anh đào úa `#FFCDD2`, chữ đỏ sẫm `#B71C1C` nhấp nháy mờ nhẹ.
    *   *Thời tiết / Mùa:* Nền màu cam quả chín `#FFE0B2` hoặc xanh trời ban mai `#E1F5FE`.

---

### 📅 TRẠNG THÁI HỆ THỐNG SAU KHI CẬP NHẬT

*   **Đường dẫn mới:** [Document/UI/08_DESIGN_SYSTEM_FOUNDATION.md](file:///Users/macinia/Capcat%20Project/Document/UI/08_DESIGN_SYSTEM_FOUNDATION.md)
*   **Trạng thái phiên bản:** `v1.2.0-MujiUnifiedComponents` (Đã phê duyệt toàn bộ - Đầy đủ bản mẫu Dart tham chiếu cho kỹ sư dev).

Toàn bộ ngôn ngữ thiết kế và danh mục component của chúng ta hiện nay đã ở trạng thái **Đồng nhất - Tinh khiết - Thực tế**. Bạn muốn Maya tiếp tục làm rõ phân hệ tính năng MVP nào tiếp theo:

1.  **Phân hệ Meme Card Generator (SPEC_03 - Memory Vault):** Đặc tả Canvas phẳng Muji tự động cắt ghép mặt Boss.
2.  **Động cơ Safe-Vet AI Engine (SPEC_01):** Quy chuẩn giao diện Đèn Đỏ Cảnh báo Cấp cứu phẳng đỏ anh đào úa và Stepper sơ cứu mộc mạc.
