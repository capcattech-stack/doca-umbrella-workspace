# Báo cáo Phản biện & Kiểm thử Đối kháng (Adversarial Review) - ECO Mobile App

**Mục tiêu:** Phân tích ứng dụng ECO Mobile App (điểm chạm của Merchant) dưới góc độ kiểm thử đối kháng (stress-test / edge-case analysis). Các hệ thống backend (Portal ECOM, ERP, v.v.) được xem như một *Blackbox*. Trọng tâm là tìm ra những **điểm gãy (breaking points)**, **lỗ hổng logic (logical flaws)** và **thiếu sót nghiệp vụ (missing flows)** có thể xảy ra trong thực tế vận hành.

---

## 1. Điểm gãy trong luồng Bán hàng (Mini POS) & Offline Sync

Dù hệ thống cấm bán âm thực tế và yêu cầu đồng bộ, môi trường di động luôn ẩn chứa rủi ro về kết nối và trạng thái cục bộ:

*   **Xung đột đồng hồ thiết bị (Device Time Manipulation):** 
    *   *Rủi ro:* Khi hoạt động offline, POS sử dụng `timestamp` của thiết bị điện thoại để ghi nhận giao dịch. Nếu Merchant cố tình chỉnh lùi ngày/giờ trên điện thoại để trốn thuế hoặc thay đổi ca làm việc, khi app online và gọi `POST /sales`, server blackbox sẽ ghi nhận sai lệch thời gian thực.
    *   *Hậu quả:* Sai lệch bảng kê thuế (Nghị định 70), đối soát gian lận.
*   **Mất JWT Token & Session khi Offline:**
    *   *Rủi ro:* App hỗ trợ bán offline. Nhưng nếu `access_token` (JWT) hết hạn trong lúc app đang mất mạng thì sao? App không thể gọi API refresh token. Khi có mạng lại, hàng loạt request `POST /sales` đẩy lên sẽ nhận lỗi `401 Unauthorized`. 
    *   *Hậu quả:* Nếu app không có cơ chế lưu trữ queue an toàn và tự động retry sau khi re-login, toàn bộ dữ liệu bán hàng offline sẽ bị mất.
*   **Race Condition đa thiết bị (Multi-device Concurrency):**
    *   *Rủi ro:* Cửa hàng có 2 nhân viên dùng 2 điện thoại khác nhau. Tồn kho mặt hàng A chỉ còn 1. Do mạng chập chờn, cả 2 app đều hiển thị tồn kho là 1. Cả 2 cùng bán item A (offline hoặc lag). Khi đồng bộ, 1 thiết bị thành công, thiết bị kia thất bại (do backend cấm bán âm). 
    *   *Hậu quả:* Nhân viên thứ 2 bị lỗi trên app *sau khi* khách hàng đã thanh toán và cầm món hàng A ra khỏi cửa hàng. App không có quy trình "Xử lý lỗi đồng bộ muộn".
*   **Xóa App / Xóa Cache đột ngột:**
    *   *Rủi ro:* Khi đang có giao dịch offline chưa được đồng bộ (unsynced queue), nhân viên lỡ tay gỡ cài đặt app hoặc clear data/cache của điện thoại.
    *   *Hậu quả:* Mất vĩnh viễn dữ liệu bán hàng. Không có cơ sở để đối soát tồn kho và doanh thu.

## 2. Lỗ hổng trong luồng Thanh toán (VietQR / Cổng thanh toán)

*   **Blackhole trạng thái thanh toán (Payment State Limbo):**
    *   *Rủi ro:* Khách hàng quét mã VietQR và thanh toán thành công (tiền đã trừ). Server Finviet nhận được webhook từ Bank. **NHƯNG** điện thoại của nhân viên tại thời điểm đó bị mất mạng (hoặc WebSocket bị đứt). App vẫn xoay vòng hiển thị "Đang chờ thanh toán".
    *   *Hậu quả:* Nhân viên không giao hàng, yêu cầu khách trả lại. Khách bực bội vì đã bị trừ tiền. App đang **thiếu nút "Kiểm tra lại trạng thái giao dịch"** (Manual Sync/Polling) để chủ động chọc gọi API hỏi server blackbox xem giao dịch này đã xong chưa.
*   **App Crash trong quá trình Thanh toán:**
    *   *Rủi ro:* Hệ điều hành di động (Android/iOS) có thể kill app (OOM) nếu thiếu RAM. Nếu app bị văng ngay khoảnh khắc chuyển sang màn hình "Thanh toán thành công" nhưng chưa kịp lưu lịch sử.
    *   *Hậu quả:* Merchant mở lại app, giỏ hàng trống rỗng, không biết đơn vừa rồi đã được ghi nhận hay chưa.

## 3. Rủi ro ở luồng Nhập hàng (Inbound / Fulfillment)

*   **Fatal Misclick (Lỗi bấm nhầm không thể hoàn tác):**
    *   *Rủi ro:* Khi NPP giao hàng, Merchant thao tác trên app. App hiển thị nút "Nhận đủ" và "Nhận thiếu". Nếu Merchant do màn hình cảm ứng lỗi hoặc vội vàng ấn nhầm "Nhận đủ". Lệnh `PUT /orders/{id}/receive` được gọi.
    *   *Hậu quả:* Hệ thống ghi nhận đã nhận đủ hàng, trừ Fund/Loan tương ứng và cộng tồn kho. Tài liệu BA xác nhận **Hệ thống không có luồng Hủy/Đổi trả (Return/Modify) cho đơn đã hoàn tất**. Lỗi bấm nhầm này trở thành "cửa tử" không có đường lùi cho Merchant. 
    *   *Đề xuất:* App bắt buộc phải có bước xác nhận kép (Double-confirmation) hoặc yêu cầu nhập mã PIN/Chụp ảnh chứng từ trước khi chốt "Nhận đủ".
*   **Thiếu bằng chứng (Evidence Tracking):**
    *   *Rủi ro:* App không yêu cầu chụp ảnh biên bản giao hàng hoặc kiện hàng khi nhận. 
    *   *Hậu quả:* Khi đối soát (Reconciliation - BIZ-16) phát sinh tranh chấp giữa Merchant và Shipper (ví dụ: NPP báo giao rồi, Merchant báo chưa nhận), Finviet Admin không có bất kỳ bằng chứng hình ảnh nào từ hệ thống để làm trọng tài.

## 4. Các rủi ro UI/UX, Hardware & Performance

*   **Barcode Scanner UX (Phần cứng vs Camera):**
    *   *Rủi ro:* App phụ thuộc vào việc quét mã vạch để bán hàng nhanh. Nếu dùng camera điện thoại, trong môi trường tạp hóa thiếu sáng hoặc mã vạch bị mờ/nhăn, tốc độ quét rất chậm. Nếu cắm máy quét Bluetooth ngoài (hoạt động như bàn phím vật lý), app có tự động focus vào ô Input ẩn không hay nhân viên phải bấm chạm vào ô tìm kiếm liên tục?
*   **Overload bộ nhớ cục bộ (Local Storage Limit):**
    *   *Rủi ro:* Để bán offline, app phải cache (tải sẵn) danh mục hàng nghìn sản phẩm, kèm hình ảnh, giá bán, tồn kho. Các thiết bị Android giá rẻ của tiểu thương có thể bị tràn bộ nhớ hoặc giật lag trầm trọng nếu không tối ưu hóa SQLite/Room database và Lazy Loading hình ảnh.
*   **Phân quyền lỏng lẻo (Client-side bypass):**
    *   *Rủi ro:* Nếu việc ẩn/hiện tính năng (VD: duyệt khoản Loan, xem doanh thu tổng) chỉ được chặn bằng giao diện (UI) dựa trên Role (Staff/Owner) lưu ở Local Storage. Một nhân viên rành công nghệ có thể dùng máy đã root chỉnh sửa file preference của app để nâng quyền thành Owner trên client. 
    *   *Khuyến nghị:* Mọi API nhạy cảm gọi đến Blackbox phải được Server validate quyền nghiêm ngặt theo Token, bất chấp UI hiển thị gì.

## 5. Tổng hợp các Tính năng bị thiếu (Missing Flows) trên App

Dựa trên phân tích, ECO Mobile App hiện đang thiếu hụt nghiêm trọng các tính năng/luồng sau để đảm bảo vận hành thực tế trơn tru:
1.  **Manual Sync / Refresh Status Button:** Nút chủ động đồng bộ / kiểm tra lại trạng thái giao dịch thanh toán hoặc đơn hàng (chữa cháy khi mạng chập chờn).
2.  **Conflict Resolution UI:** Màn hình chuyên biệt để Merchant giải quyết các đơn hàng offline bị server từ chối (do tồn kho hết, lỗi giá, lỗi token).
3.  **Undo / Grace Period cho thao tác Nhận hàng:** Chờ 5-10 phút trước khi chốt sổ cứng vào backend, cho phép Merchant thu hồi thao tác nếu bấm nhầm.
4.  **Chụp ảnh & Upload bằng chứng:** Trong quá trình nhận/giao hàng hoặc báo cáo sự cố (Dispute).
5.  **Shift Management (Quản lý ca làm việc):** Để phân tách doanh thu/tiền mặt giữa nhân viên ca sáng và ca tối, app cần flow Bàn giao ca. (Tài liệu hiện chưa nhắc đến việc chốt ca).

---
*Báo cáo được thực hiện dựa trên nguyên tắc adversarial testing, đặt ứng dụng ECO TSH vào các kịch bản tồi tệ nhất ngoài thực địa.*
