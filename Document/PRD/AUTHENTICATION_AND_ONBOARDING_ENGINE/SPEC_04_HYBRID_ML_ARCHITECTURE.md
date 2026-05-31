# ARCHITECTURE DECISION RECORD (ADR - SPEC 04)
## KIẾN TRÚC LAI HYBRID MACHINE LEARNING & ĐIỀU PHỐI DỮ LIỆU ĐỊNH DANH
*(Phiên bản: 3.0 - Giai đoạn: MVP - Người soạn: Tech Lead Alan)*

---

## 1. BỐI CẢNH & PHÂN TÍCH THƯƠNG THUYẾT (CONTEXT & COMPARATIVE ANALYSIS)

Chào anh! Sophia và em rất trân quý câu hỏi mang tính chiến lược hệ thống cực kỳ sâu sắc này của anh. 

Đúng như anh nhận định, việc "nhồi nhét" toàn bộ các mô hình học máy (ML Models) chạy offline trực tiếp dưới nền Flutter (Client-side) **không phải là giải pháp tốt nhất trong mọi trường hợp**. Đó là một giải pháp tình thế nhằm tiết kiệm tài nguyên backend cho các startup không có hạ tầng. Khi anh sẵn sàng đầu tư backend để đạt hiệu năng tối ưu, em xin thiết kế lại hệ thống theo **Chuẩn kiến trúc lai Hybrid ML** - chuẩn mực đang được các siêu ứng dụng trên thế giới áp dụng.

Dưới đây là bảng so sánh sòng phẳng giữa hai hướng tiếp cận:

| Tiêu chí | ML chạy trực tiếp trên Điện thoại (On-Device ML) | ML chạy trên Máy chủ (Backend-Side ML) |
| :--- | :--- | :--- |
| **Dung lượng App (App Binary Size)** | ❌ **Phồng to nặng nề:** Thêm từ 15MB - 35MB vào file `.apk`/`.ipa` do phải đóng gói kèm mô hình ML tĩnh. Giảm 30% tỷ lệ tải app. |  **Siêu nhẹ tinh gọn:** File cài đặt dưới 15MB, tải app nhanh chớp nhoáng giúp tăng tối đa tỷ lệ chuyển đổi onboard. |
| **Độ chính xác (Accuracy & Control)** | ❌ **Hạn chế và Cố định:** Mô hình bị đóng băng tại thời điểm build app. Muốn tinh chỉnh nhãn giống loài hay bộ lọc màu lông phải cập nhật phiên bản mới lên App Store/Google Play. |  **Tối ưu liên tục:** Deploy một mô hình Python (như YOLOv8 / ResNet) chuyên biệt ở backend. Có thể cập nhật, tinh chỉnh độ chính xác của mô hình hàng ngày mà không cần bắt người dùng cập nhật app. |
| **Tài nguyên thiết bị (Device Resource)** | ❌ **Nóng máy, tốn pin:** Phân tích ảnh trên điện thoại cấu hình thấp sẽ gây giật lag, tốn pin và quá nhiệt cục bộ. |  **Trơn tru tuyệt đối:** Điện thoại chỉ thực hiện tác vụ gửi ảnh (Upload), toàn bộ gánh nặng tính toán dồn lên server. |
| **Độ trễ Mạng (Network Latency)** |  **Tức thời ( Dưới 100ms):** Không tốn băng thông mạng tải ảnh lên. | ❌ **Trễ tải lên (1.5s - 3s):** Phụ thuộc vào tốc độ mạng di động (3G/4G) khi upload ảnh gốc lên server. |
| **Chi phí vận hành (Operational Cost)** |  **0đ vĩnh viễn:** Sử dụng CPU/GPU của chính người dùng. | ❌ **Phát sinh chi phí:** Tốn chi phí máy chủ chạy mô hình ML (CPU/GPU cloud). |

---

## 2. THIẾT KẾ KIẾN TRÚC HỆ THỐNG LAI CHUẨN CHỈNH (HYBRID ARCHITECTURE DESIGN)

Để kết hợp hoàn hảo ưu điểm của cả hai bên: **Giữ dung lượng app siêu nhẹ, mô hình có độ chính xác cao dễ cập nhật ở Backend, nhưng vẫn đảm bảo 0đ chi phí vận hành rườm rà**, em đề xuất cấu trúc **Kiến Trúc Lai (Hybrid ML Architecture)** như sau:

```
[ THIẾT BỊ CLIENT (FLUTTER) ]                         [ HẠ TẦNG BACKEND (SERVERLESS) ]
+----------------------------+                       +----------------------------------+
| - Tiny App Bundle (<15MB)  |                       | - Serverless Cloud Run / Lambda  |
| - Local Palette Extractor  |                       | - Python ML Engine (YOLO/ResNet) |
|   (Mã màu lông - Chạy 0đ)  |                       |   (Nhận diện Giống loài chuẩn)   |
+----------------------------+                       +----------------------------------+
              |                                                       ^
       (Upload Photo)                                                 |
              |-------------------------------------------------------+
              v
+----------------------------+
| - Polaroid UI Preview      |
| - Render Ghibli Avatar     |
+----------------------------+
```

### 2.1. Phân bổ Nhiệm vụ Thông Minh (Smart Task Division):

#### A. Tác vụ Client-Side (Xử lý 0đ trên thiết bị):
*   **Trích xuất bảng màu (Palette Generator):** Flutter tự chạy thư viện trích xuất mã màu lông RGB cục bộ. Tác vụ này cực nhẹ, tốn dưới `10ms` và **không cần đến mô hình ML**.
*   **Hiển thị hoạt ảnh phác thảo chì màu nước Ghibli (Watercolor Pencil Sketch Fade/Shimmer):** Khi ảnh đang được upload lên server, app chạy hoạt ảnh phác họa chì màu nước kiểu Studio Ghibli mịn màng vẽ nhạt và tô màu dần đầy thơ mộng để giấu đi độ trễ mạng `1 - 1.5 giây`, tạo cảm giác chữa lành chân thành.

#### B. Tác vụ Backend-Side (Xử lý thông minh trên Server):
*   Chúng ta xây dựng một **Dịch vụ Serverless siêu nhẹ (Google Cloud Run hoặc AWS Lambda)** chạy Python. Dịch vụ này **chỉ khởi chạy khi có yêu cầu (Scale-to-Zero)** $\rightarrow$ **Chi phí gần như bằng 0đ** khi không có người dùng, không cần tốn tiền duy trì server GPU đắt đỏ 24/7.
*   Dịch vụ backend đảm nhiệm:
    1.  Nhận ảnh $\rightarrow$ Chạy mô hình Python ML chuyên nghiệp để nhận diện Giống loài (`Breed`) với độ chính xác tuyệt đối.
    2.  Kết hợp gọi API LLM (Gemini Flash giá siêu rẻ) để sinh nhanh 1 câu "khía" (Funny trait) tương ứng với loài và cá tính.
    3.  Trả về JSON sạch sẽ cho client:
        ```json
        {
          "is_dog": true,
          "breed": "CORGI",
          "coat_color_name": "Cream Gold",
          "funny_trait": "Thân thiện thái quá, ai đi qua cũng vẫy đuôi làm quen."
        }
        ```

---

## 3. CƠ CHẾ DỌN DẸP & BẢO MẬT PHÒNG KHÁNH KIỆT (FAIL-SAFE ROUTING)

Nếu backend gặp sự cố hoặc mất mạng giữa chừng, Client sẽ tự động kích hoạt **luồng cứu sinh cục bộ (Local Fallback Flow)**:
1.  Nếu upload ảnh lên backend thất bại sau `5 giây` $\rightarrow$ App tự động bypass lỗi, hiển thị màn hình mô tả thủ công để Sen tự điền.
2.  Gán ngay **Ghibli Avatar cục bộ có sẵn** tương ứng với các lựa chọn điền tay của Sen.
3.  Đảm bảo app **tuyệt đối không bao giờ bị đơ hay crash**, trải nghiệm của Sen vẫn diễn ra trọn vẹn và liền mạch.

---

## 4. QUY QUYẾT ĐỊNH CỦA TECH LEAD (ALAN'S DIRECTIVE)

> [!IMPORTANT]
> **Định hướng triển khai chuẩn chỉnh:**
> *   Chúng ta sẽ **loại bỏ hoàn toàn thư viện Google ML Kit nặng nề ra khỏi file cài đặt Flutter client**. Điều này giữ cho Capcat luôn là một ứng dụng siêu nhẹ, tải nhanh chớp nhoáng trên App Store.
> *   Xây dựng 1 microservice Python đóng gói Docker deploy lên Google Cloud Run (chỉ tính tiền khi có request thực tế phát sinh, 2 triệu request đầu tiên/tháng hoàn toàn miễn phí $\rightarrow$ Đạt được tiêu chuẩn 0đ vận hành thực tế!).
