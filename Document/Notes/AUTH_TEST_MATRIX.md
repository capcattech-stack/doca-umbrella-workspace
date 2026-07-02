# Auth Test Matrix

Checklist test thủ công cho các luồng xác thực trước release.

## A. Cold Start / Bootstrap

- [ ] Mở app khi chưa đăng nhập
  Kỳ vọng: vào màn `Splash/Login`, không vào `MainScreen`.
- [ ] Mở app khi đã login bằng số điện thoại trước đó
  Kỳ vọng: vào `MainScreen`.
- [ ] Mở app khi đã login bằng Google trước đó
  Kỳ vọng: vào `MainScreen`.
- [ ] Logout xong, đóng app, mở lại app
  Kỳ vọng: ở màn `Splash/Login`, không tự vào app.
- [ ] Đăng nhập Google xong, giả lập mất Firebase session nhưng còn token nội bộ
  Kỳ vọng: app không vào `MainScreen`, bị đưa về login sạch.
- [ ] Giả lập còn Firebase session nhưng không còn token nội bộ
  Kỳ vọng: app không vào `MainScreen`, về login sạch.

## B. Phone Login

- [ ] Nhập số điện thoại hợp lệ, nhận OTP, nhập OTP đúng
  Kỳ vọng: login thành công, vào `MainScreen`.
- [ ] Nhập OTP sai
  Kỳ vọng: hiện lỗi rõ ràng, không vào app.
- [ ] Bấm gửi lại OTP
  Kỳ vọng: request resend chạy thật, countdown reset đúng.
- [ ] Đăng nhập thành công, logout
  Kỳ vọng: quay về login, cache/session bị xóa đúng.
- [ ] Sau khi logout phone B, màn login còn hiển thị đúng số phone gần nhất là B
  Kỳ vọng: không quay về số cũ của user A.

## C. Phone Register

- [ ] Đăng ký bằng số điện thoại mới
  Kỳ vọng: đăng ký thành công, được login luôn, vào `MainScreen`.
- [ ] OTP register sai
  Kỳ vọng: hiện lỗi rõ ràng.
- [ ] Resend OTP ở register
  Kỳ vọng: hoạt động thật, không chỉ reset UI.
- [ ] Register thành công rồi logout
  Kỳ vọng: màn login nhớ đúng số vừa đăng ký thành công gần nhất.

## D. Forgot Password

- [ ] Nhập số điện thoại hợp lệ để quên mật khẩu
  Kỳ vọng: gửi OTP thành công.
- [ ] Nhập OTP sai ở quên mật khẩu
  Kỳ vọng: hiện lỗi rõ ràng, không đứng im.
- [ ] Resend OTP ở quên mật khẩu
  Kỳ vọng: request resend chạy thật.
- [ ] Đặt mật khẩu mới thành công
  Kỳ vọng: hiện thành công, quay về flow phù hợp.
- [ ] Dùng mật khẩu mới để login
  Kỳ vọng: login thành công.

## E. Google Login / Register

- [ ] Login Google với account đã có backend account
  Kỳ vọng: vào `MainScreen`, session được lưu.
- [ ] Login Google với account chưa có backend account
  Kỳ vọng: đi đúng flow social register.
- [ ] Hoàn tất social register
  Kỳ vọng: vào `MainScreen`, session/profile được lưu.
- [ ] Back ra giữa chừng trong social register
  Kỳ vọng: không bị treo session Google/Firebase bất thường.
- [ ] Logout sau social login
  Kỳ vọng: logout sạch, mở lại app không tự vào.

## F. Session / Cross-Account

- [ ] Login user A, logout, login user B
  Kỳ vọng: dữ liệu auth là của B, không còn session của A.
- [ ] Logout A, register/login B, logout B
  Kỳ vọng: màn login hiển thị phone gần nhất là B.
- [ ] Login A, tạo dữ liệu cục bộ, logout, login B
  Kỳ vọng: không còn thấy data auth/profile của A.
- [ ] Login xong vào `Home/Profile/MyPets/Chat`
  Kỳ vọng: dữ liệu user mới được refresh đúng, không giữ cache user cũ.

## G. Basic Stability

- [ ] Mở app khi mạng chậm
  Kỳ vọng: không treo spinner vô hạn trước splash/login.
- [ ] Mở app khi offline
  Kỳ vọng: không crash; nếu chưa có session hợp lệ thì ở login.
- [ ] Logout trong lúc đang ở screen profile/chat
  Kỳ vọng: app về login sạch, không lỗi navigator.

## Ưu tiên chạy tối thiểu nếu gấp

- [ ] Cold start chưa login
- [ ] Cold start đã login phone
- [ ] Cold start đã login Google
- [ ] Phone login success
- [ ] Phone register success
- [ ] Forgot password success
- [ ] Google login success
- [ ] Social register success
- [ ] Logout
- [ ] Cross-account A -> logout -> B
- [ ] Bootstrap mismatch token/Firebase
