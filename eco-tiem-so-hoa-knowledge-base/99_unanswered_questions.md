# Tổng hợp Câu hỏi & Vấn đề Chưa được trả lời (Needs Clarification)

Dưới đây là danh sách tổng hợp toàn bộ các câu hỏi phản biện, các Gaps chưa có hướng giải quyết và những điểm còn mơ hồ trong tài liệu phân tích nghiệp vụ của dự án **ECO Tiệm Số Hóa**. Các câu hỏi được chia thành 4 nhóm chính.

---

## 1. Nhóm Kinh doanh & Vận hành (Business & Operations)

*   **Q1. SLA duyệt Onboarding & KYC:** Thời gian chờ duyệt hồ sơ Merchant là bao lâu? Việc duyệt này sẽ diễn ra hoàn toàn tự động bằng AI/Third-party hay cần Admin duyệt thủ công?
*   **Q2. Merchant không đủ giấy tờ pháp lý:** Nếu cửa hàng không có Giấy phép Kinh doanh (HKD) hoặc Mã số Thuế (MST), hệ thống sẽ giới hạn những tính năng nào của họ? (Đặc biệt liên quan đến hóa đơn điện tử).
*   **Q3. Giới hạn bán trước (Pre-order / Bán âm tạm thời):** Mặc dù chốt không cho bán âm kho thực tế, nhưng việc giới hạn số lượng khách được đặt trước (pre-order) sẽ do ai cấu hình? Merchant tự set hay mặc định từ hệ thống Finviet?
*   **Q4. Quản lý đa cửa hàng (Multi-store):** Một tài khoản Merchant có được phép quản lý nhiều cửa hàng ở nhiều địa điểm khác nhau không?
*   **Q5. Giao hàng từng phần (Partial Delivery):** Khi nhà cung cấp (Brand/NPP) chỉ giao được một phần đơn hàng, phần còn lại sẽ tiếp tục giao sau hay hệ thống sẽ tự động hủy? Khoản vay/Fund tương ứng sẽ được điều chỉnh ngay lập tức hay phải chờ đối soát?
*   **Q6. Nhà Phân Phối (NPP) có nhiều kho:** Có bổ sung logic phân tách đơn hàng theo từng kho cụ thể của cùng một NPP để tối ưu fulfillment không?

## 2. Nhóm Thanh toán & Tài chính (Payment, Fund & Loan)

*   **Q7. Luồng Nạp tiền Ví ECO:** Merchant sẽ nạp tiền vào Ví ECO qua kênh nào (Chuyển khoản ngân hàng, thẻ, cổng thanh toán)? Tiền trong Ví có phân chia "Ví nhập hàng" và "Ví bán hàng" hay dùng chung?
*   **Q8. Cơ chế hoàn trả Fund:** Sau khi Merchant sử dụng hạn mức Fund được duyệt trước, cơ chế hoàn trả tiền là gì? Fund có tính lãi suất không? Nó được cấp lại (Replenish) tự động hay Merchant phải yêu cầu?
*   **Q9. SLA phê duyệt Loan:** Việc duyệt khoản vay (Loan) theo đơn hàng là thời gian thực (Real-time scoring) hay phải chờ duyệt thủ công (T+1)? Nếu chờ, đơn hàng có bị treo lại không?
*   **Q10. QR Code cho Khách lẻ (VietQR):** Sử dụng QR tĩnh (Static QR - in sẵn tại quầy) hay QR động (Dynamic QR - tạo riêng trên app cho từng giao dịch)? (QR tĩnh dễ gây sai sót đối soát, QR động phức tạp về webhook).

## 3. Nhóm Pháp lý & Thuế (Legal & Tax)

*   **Q11. Nguồn dữ liệu (Source of Truth) cho Bảng kê Thuế:** Bảng kê khai thuế cuối kỳ sẽ dựa trên lịch sử xuất Hóa đơn điện tử hay dựa trên Log bán hàng của POS? (Theo NĐ70, cần lấy theo doanh thu thực tế từ POS Log, nhưng hệ thống đang có Gap về mặt này).
*   **Q12. Hóa đơn điều chỉnh/thay thế:** Hệ thống có hỗ trợ luồng xuất Hóa đơn điều chỉnh hoặc Hủy hóa đơn đã phát hành (khi khách trả hàng) không?
*   **Q13. Series Hóa đơn:** Mỗi Merchant sẽ có một series hóa đơn riêng đăng ký với Thuế, hay sử dụng chung series của Finviet?
*   **Q14. Quản lý Thuế suất VAT:** Hệ thống PMS có gắn mức thuế suất (0%, 5%, 8%, 10%) cố định cho từng SKU để POS tính toán thuế chuẩn xác lúc xuất bảng kê không?

## 4. Nhóm Kỹ thuật & Kiến trúc Hệ thống (Tech & Architecture)

*   **Q15. Chiến lược Offline POS (Cực kỳ quan trọng):** Ứng dụng ECO TSH có được phép bán hàng khi mất mạng không? Nếu có, chiến lược đồng bộ dữ liệu (Sync Strategy) khi có mạng lại là gì? Giải quyết xung đột tồn kho ra sao?
*   **Q16. Giao thức Tích hợp ERP của Brand:** Việc kết nối với hệ thống nội bộ của các Brand đối tác sử dụng giao thức nào (REST, SOAP, EDI, File FTP)? Tần suất đồng bộ là Real-time Push hay Batch Pull?
*   **Q17. Return / Refund Flow V1:** Quy trình Đổi trả/Hoàn tiền đã được chốt là "Không làm, thay bằng Hủy + Tạo đơn mới". Vậy tính năng Hủy đơn hàng có được đưa vào Scope của Phase V1 không?
*   **Q18. Xác định Kiến trúc Portal ECOM:** Portal ECOM vừa đóng vai trò là Admin UI cho nội bộ Finviet thao tác, vừa làm API Gateway cho Mobile App? Có nên tách bạch hai thành phần này để đảm bảo an ninh hệ thống?
