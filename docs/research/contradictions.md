# Planning Contradictions Register

| ID | Topic | Source A | Source B | Conflict | Decision | Owner |
| --- | --- | --- | --- | --- | --- | --- |
| K001 | HKD vs. Doanh nghiệp | S001 (ZaloPay) / S002 (MoMo) | S003 (Nghị định 72) | Cổng thanh toán MoMo/ZaloPay cho phép HKD đăng ký, nhưng các dịch vụ game hoặc sàn giao dịch TMĐT bắt buộc phải là Doanh nghiệp. | Sử dụng Hộ kinh doanh hoặc tài khoản cá nhân (PayOS) ở Phase 1 để chạy thử nghiệm ví xu bán nội dung số. Chuyển đổi sang Doanh nghiệp khi scale up hoặc xin giấy phép Game/Sàn TMĐT. | cyrus-research-critic |
| K002 | Đồng bộ vs. Bất đồng bộ | S001 (ZaloPay SDK) | Khuyến nghị hệ thống chịu tải lớn | ZaloPay yêu cầu phản hồi 200 OK nhanh dưới 1s, nhưng việc cộng xu + gửi thông báo + ghi hóa đơn có thể tốn thời gian hơn 1s nếu DB bị khóa dòng. | Áp dụng Queue bất đồng bộ (Message Queue) cho việc cộng xu/gửi thông báo hoặc chạy DB transaction tối giản để phản hồi tức thì cho ZaloPay, tránh nghẽn. | orion-orchestration-engineer |
