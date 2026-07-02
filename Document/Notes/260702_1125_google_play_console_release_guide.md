# Hướng dẫn và Thủ tục Đưa CapCat App lên Google Play Store

Tài liệu này ghi lại đánh giá mức độ sẵn sàng về mặt kỹ thuật của **CapCat App** và các thủ tục, quy trình hành chính bắt buộc cần chuẩn bị để phát hành ứng dụng lên cửa hàng Google Play Store thành công.

---

## 1. Đánh Giá Mức Độ Sẵn Sàng Kỹ Thuật (Technical Readiness)

Về mặt **kỹ thuật và mã nguồn**, ứng dụng hiện tại **ĐÃ ĐỦ ĐIỀU KIỆN (READY) 100%** để đưa lên Google Play Store.

*   **Bản build ổn định**: Đã chạy thử lệnh `flutter build appbundle --release` thành công.
*   **File đầu ra**: [app-release.aab](file:///Users/phuhoang/Development/capcat_project/capcat_app/build/app/outputs/bundle/release/app-release.aab) có dung lượng **74.6 MB** (chứa đầy đủ tài nguyên ảnh, font chữ Quicksand/Motterdam và Lottie animations).
*   **Cấu hình cốt lõi**:
    *   Package Name đã chuyển đổi đồng bộ sang **`com.capcat.doca`**.
    *   Quyền truy cập Internet và các quyền phần cứng (Camera, Photo Library) đã được cấu hình chuẩn trong file manifest.
    *   Đã cấu hình chữ ký Release chính thức với keystore `upload-keystore.jks`.
    *   Icon ứng dụng đã được render lại thành công ở mọi kích thước, không còn dùng icon mặc định của Flutter.
    *   Khai báo assets bị lặp lại đã được dọn sạch.

---

## 2. Quy Trình và Thủ Tục trên Google Play Console (Các bước tiếp theo)

Để ứng dụng được phát hành công khai cho người dùng tải về, bạn cần chuẩn bị và hoàn tất các bước phi kỹ thuật sau trên trang quản trị nhà phát triển của Google:

### Bước 1: Chuẩn bị Tài khoản Nhà phát triển (Developer Account)
*   Đăng ký tài khoản tại [Google Play Console](https://play.google.com/console).
*   Chi phí đăng ký: **25 USD** (đóng một lần duy nhất).
*   **⚠️ Lưu ý về Chính sách Thử nghiệm Đóng (Closed Testing) (Bắt buộc cho tài khoản cá nhân mới tạo sau 11/2023)**:
    *   Google yêu cầu bạn phải chạy thử nghiệm ứng dụng của mình trong nhánh **Closed Testing** với tối thiểu **20 người dùng thử (testers)**.
    *   Những người thử nghiệm này phải tham gia và sử dụng ứng dụng liên tục trong vòng ít nhất **14 ngày**.
    *   Sau khi hoàn thành điều kiện này, bạn mới có thể gửi yêu cầu phê duyệt để phát hành app lên nhánh chính thức (Production).

### Bước 2: Chuẩn bị trang Chính sách Bảo mật (Privacy Policy)
*   Ứng dụng có sử dụng camera, thư viện ảnh và chức năng xác thực qua Firebase nên bắt buộc phải có link Chính sách bảo mật.
*   **Cách làm**: Tạo một trang web tĩnh đơn giản (sử dụng GitHub Pages, Google Sites, Notion công khai, hoặc dùng các trang tạo privacy policy template miễn phí trực tuyến).
*   Copy đường link trang chính sách đó để điền vào phần khai báo thông tin ứng dụng trên Google Play Console.

### Bước 3: Thiết kế Tài nguyên hiển thị trên Cửa hàng (Store Listing)
Chuẩn bị sẵn các thông tin và hình ảnh quảng bá dưới đây trước khi đăng tải app:
*   **Tên ứng dụng chính thức**: Tối đa 30 ký tự (ví dụ: `CapCat - Trợ lý Thú cưng`).
*   **Mô tả ngắn**: Tối đa 80 ký tự.
*   **Mô tả chi tiết**: Tối đa 4000 ký tự.
*   **Icon ứng dụng trên store**: Ảnh PNG định dạng `512x512`, nền phẳng, không bo góc (Google sẽ tự động bo góc tròn cho icon trên thiết bị).
*   **Ảnh nổi bật (Feature Graphic)**: Kích thước PNG `1024x500` (đây là ảnh banner hiển thị ở đầu trang của app trên Play Store).
*   **Ảnh chụp màn hình (Screenshots)**:
    *   Tối thiểu 2 ảnh chụp màn hình điện thoại (tỷ lệ 16:9 hoặc 9:16).
    *   Nên chuẩn bị thêm ảnh màn hình cho máy tính bảng 7-inch và 10-inch nếu app hỗ trợ hiển thị trên tablet.

### Bước 4: Khai báo An toàn Dữ liệu (Data Safety) & Xếp hạng Nội dung (Content Rating)
*   Trả lời bảng câu hỏi về độ tuổi sử dụng app (Content Rating).
*   Khai báo An toàn Dữ liệu (Data Safety): Khai báo rõ các dữ liệu người dùng mà ứng dụng thu thập và chia sẻ (như địa chỉ email, tên hiển thị thu thập từ Google Sign-In, ảnh chụp từ camera tải lên hệ thống).

### Bước 5: Đồng bộ App Signing Key với Firebase Console (Bắt buộc sau khi tải file `.aab` lên lần đầu)
*   Khi bạn tải file `.aab` lên Google Play Console lần đầu tiên, Google sẽ tự động kích hoạt tính năng **Play App Signing** và tạo ra một **App signing key** mới để ký lại app trước khi gửi tới thiết bị người dùng.
*   **QUAN TRỌNG**: Bạn phải truy cập vào trang quản lý ứng dụng trên Play Console -> vào mục **Setup** -> **App Integrity** -> copy mã băm **SHA-1** của **App signing key** do Google quản lý.
*   Truy cập vào [Firebase Console](https://console.firebase.google.com/) -> Vào phần cài đặt dự án `capcat-doca` -> Thêm mã SHA-1 vừa copy này vào cấu hình Android App của bạn.
*   *Lý do*: Nếu thiếu bước này, khi người dùng tải ứng dụng chính thức từ Google Play Store về máy, tính năng đăng nhập bằng Google (Google Sign-In) sẽ bị lỗi kết nối (APIException 10) do không khớp chữ ký số giữa Google Store và Firebase.
