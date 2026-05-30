# TÀI LIỆU YÊU CẦU SẢN PHẨM MASTER: COZY CHAT RESONANCE ENGINE
*(MASTER PRODUCT REQUIREMENT DOCUMENT - PRD V1.1 - ĐÃ SỬA LỖI ĐỐI KHÁNG)*

> **Mã Tính Năng:** `FE-COZY-CHAT`  
> **Trạng thái:** Hoàn tất Thiết kế & Vá Đối kháng (Sẵn sàng triển khai)  
> **Tác giả:** Sophia (CPO / PM)  
> **Đơn vị phê duyệt:** Ban Giám đốc Dự án Capcat  

---

## 🧭 1. TẦM NHÌN & MỤC TIÊU SẢN PHẨM (PRODUCT VISION & GOALS)

Sứ mệnh tối cao của **Capcat: Soul of Pet** là **chữa lành sự cô đơn của con người đô thị** thông qua việc tái sinh thú cưng ảo thành những tri kỷ sành điệu, ấm áp. 

Phân hệ **Cozy Chat Resonance Engine (FE-COZY-CHAT)** được phát triển nhằm nâng cấp giao tiếp giữa Chủ nuôi (Sen) và Thú cưng ảo (Boss) từ những đoạn chat chatbot thông thường thành một **trải nghiệm cộng hưởng không gian - thời gian thực tế**, đồng thời tích hợp tiếp thị liên kết một cách tinh tế và đậm chất nghệ thuật Iyashikei.

---

## 🛠️ 2. THIẾT KẾ ĐỐI KHÁNG VÀ VÁ LỖI KIẾN TRÚC (ADVERSARIAL REFINEMENTS)

Để tránh việc ứng dụng bị hệ điều hành tiêu diệt do lạm dụng tài nguyên ngầm, đồng thời duy trì nhịp trò chuyện tự nhiên lôi cuốn, phân hệ áp dụng 2 cải tiến kiến trúc cốt lõi:

### 2.1. Giải pháp cảm nhận ngữ cảnh "Foreground Sensing & Scheduled Local Push"
*   **Hủy bỏ Background Geofencing:** Loại bỏ hoàn toàn việc chạy định vị ngầm liên tục dưới nền để ngăn ngừa việc hệ điều hành chặn ứng dụng và tránh hiển thị các hộp thoại cảnh báo bảo mật đáng sợ gây phòng thủ tâm lý cho người dùng.
*   **Foreground Context Sensing (Cảm nhận khi mở app):** Tọa độ GPS, thời tiết thực tế (OpenWeatherMap API) và các thông số hoạt động chỉ được thu thập ngầm và đồng bộ **ngay khi người dùng chủ động mở ứng dụng (Foreground session)**, sau đó nạp trực tiếp làm ngữ cảnh hội thoại.
*   **Hẹn giờ thông báo tự phát cục bộ (Scheduled Local Push):** Lời mở đầu tự phát của Boss (Spontaneous Opener) được lập lịch hiển thị trên màn hình khóa bằng thông báo đẩy cục bộ (Local Push Notification) dựa trên mốc giờ sinh hoạt cuối cùng được ghi nhận, đảm bảo chính xác 100% về mặt thời gian, không tốn pin và bảo mật tuyệt đối.

### 2.2. Vòng lặp trò chuyện kép (Dual-Mode Chat Loop)
*   **Mâu thuẫn:** Áp dụng thời gian trễ ngẫu nhiên 15-45 phút cho mọi tin nhắn của Boss AI sẽ giết chết tính tương tác khi Sen đang trực tiếp trò chuyện.
*   **Giải pháp:** Phân tách rõ ràng làm 2 chế độ phản hồi dựa trên trạng thái phiên:
    1.  **Chế độ Chủ động (Active Chat Session - Khi người dùng đang mở app):** Boss AI phản hồi ngay lập tức trong vòng **2-4 giây** (kèm hiệu ứng ba chấm nhấp nháy gõ chữ để duy trì dòng chảy trò chuyện và giữ chân Sen).
    2.  **Chế độ Tự phát (Passive Chat Session - Khi người dùng không mở app):** Hạn chế tối đa gửi 1 tin nhắn tự phát/ngày qua thông báo đẩy cục bộ sau khoảng 4-8 tiếng không tương tác để khơi gợi cảm xúc và mời Sen quay lại app.

---

## 🏛️ 3. Danh Sách Tài Liệu Đặc Tả Trực Thuộc (Specs Index)

Toàn bộ phân hệ được đóng gói nhất quán trong thư mục tính năng [COZY_CHAT_RESONANCE_ENGINE](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/), bao gồm 10 đặc tả kỹ thuật chi tiết:

| Số Thứ Tự | Tên Tài Liệu Đặc Tả | Phạm Vi Giải Quyết |
| :--- | :--- | :--- |
| **01** | [SPEC_01_CULTURAL_RESONANCE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_01_CULTURAL_RESONANCE.md) | Thiết kế Hyperlink hoài cổ, nguồn nhạc 30s iTunes API, Shopee Books Affiliate và Spotify Fallback. |
| **02** | [SPEC_02_CONTEXT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_02_CONTEXT_SENSING.md) | Cơ chế cảm nhận Foreground Context, Scheduled Local Push và luồng xin quyền tinh tế. |
| **03** | [SPEC_03_PROFILE_EXTRACTION.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_03_PROFILE_EXTRACTION.md) | Kịch bản hỏi thăm thấu cảm "Cozy Inquiry" theo chuẩn Mom Test để trích xuất thông tin sức khỏe Pet và cảm xúc Sen. |
| **04** | [SPEC_04_INVISIBLE_GEOSPATIAL.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_04_INVISIBLE_GEOSPATIAL.md) | Thuật toán phân cụm tọa độ cục bộ trên thiết bị và dán nhãn thông minh (Trường học/Cơ quan) theo độ tuổi. |
| **05** | [SPEC_05_FREQUENCY_COMPASS.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_05_FREQUENCY_COMPASS.md) | Hệ thống khống chế tần suất (Active vs Passive Chat Loop), bộ đệm trễ ngẫu nhiên ngoài app, âm haptic Purring. |
| **06** | [SPEC_06_STORYTELLING_BACKBONE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_06_STORYTELLING_BACKBONE.md) | Khung xương sống dẫn dắt cốt truyện 3 Giai đoạn (Hook - Lead - Close) và bộ nguyên tắc prompt engineering thấu cảm. |
| **07** | [SPEC_07_EXTERNAL_AMBIENT_SENSING.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_07_EXTERNAL_AMBIENT_SENSING.md) | Cảm nhận thời tiết thực tế bằng OpenWeatherMap API và bơm ngữ cảnh sự kiện văn hóa nghệ thuật thủ công làm Cozy Opener. |
| **08** | [SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_08_DATA_OPERATIONS_ARCHITECTURE.md) | Kiến trúc cơ sở dữ liệu (Hybrid Postgres/SQLite) và quy trình chuẩn bị dữ liệu thủ công (CMS) kết hợp dữ liệu tự động cho Cozy Openers. |
| **09** | [SPEC_09_OFFLINE_SANCTUARY_ENGINE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_09_OFFLINE_SANCTUARY_ENGINE.md) | Động cơ Trú ẩn Chủ động, thuật toán trộn câu thoại cục bộ (Deterministic Offline Mixer) và hệ thiết kế thính giác/thị giác trầm mặc (Lá rơi, đĩa than offline). |
| **10** | [SPEC_10_VIRTUAL_VINYL_STORE.md](file:///Users/macinia/Capcat%20Project/Document/PRD/COZY_CHAT_RESONANCE_ENGINE/SPEC_10_VIRTUAL_VINYL_STORE.md) | **[PHASE 2 / BACKLOG]** Cửa hàng Đĩa than ảo, trải nghiệm khui đĩa, giao diện phát đĩa cơ học và cổng thanh toán IAP. |

---

*Tài liệu đặc tả đối kháng này đã được cập nhật và sẵn sàng chuyển giao lập trình. Ký tên: Team Cố vấn Capcat (Sophia, Alan, Benny)*
