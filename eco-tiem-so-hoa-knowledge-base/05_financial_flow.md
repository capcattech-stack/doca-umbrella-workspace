# 05 — Luồng Tài chính: Fund & Loan

> **Scope:** BIZ-10 Yêu cầu Loan · BIZ-11 Giải ngân & Hoàn trả

---

## BIZ-10: Yêu cầu Khoản Loan theo Đơn hàng

### Happy Path
```
1. Merchant tạo đơn nhập hàng (BIZ-02)
2. Chọn paymentMethod = "loan"
3. [Portal ECOM API] POST /loans/request
   Input:  { merchantId, orderId, requestedAmount }
   Output: { loanId, status: "pending", estimatedDecisionTime }
4. ECO TSH hiển thị: "Đang chờ duyệt khoản vay"
5. [Portal ECOM] Credit engine xét duyệt (blackbox):
   - Kiểm tra lịch sử tín dụng Merchant
   - Kiểm tra giá trị đơn hàng
   - Kiểm tra dư nợ hiện tại
6. Kết quả → ECO TSH nhận notification:
   - Approved: loanId, approvedAmount, repaymentSchedule
   - Rejected: rejectionReason (nếu có)
7. Nếu Approved → OMS sync sang ERP Brand → đơn hàng tiến hành
```

### Loan Lifecycle State Machine
```
[Requested] → [Under Review] → [Approved | Rejected]
                                      ↓ (Approved)
                               [Disbursed]
                                      ↓
                    [Partially Repaid] → [Fully Repaid]
                                      ↓ (missed)
                               [Overdue] → [Bad Debt]
```

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| L-01 | **SLA phê duyệt**: Loan approved trong bao lâu? Real-time (AI scoring) hay T+1 (manual review)? Merchant bị treo đơn hàng trong thời gian đó | 🔴 Cao |
| L-02 | **Rejection reason**: Merchant có nhận được lý do từ chối không? Hay chỉ "Không được duyệt"? Không có reason → Merchant không biết cải thiện gì | 🟠 TB |
| L-03 | **Loan partial approval**: Merchant xin 100M, được duyệt 60M. Đơn hàng có điều chỉnh tự động xuống giá trị phù hợp không? Hay Merchant phải tự chỉnh? | 🟠 TB |
| L-04 | **Concurrent loans**: Merchant có thể có nhiều Loan đang active cùng lúc (cho nhiều đơn) không? Giới hạn là bao nhiêu? | 🟠 TB |
| L-05 | **CRITICAL — Timing risk**: Nếu OMS push sang ERP TRƯỚC khi Loan approved → Brand xử lý đơn → Loan bị reject → hàng đã xuất kho. Quy tắc bắt buộc: chỉ sync ERP SAU KHI Loan disbursed | 🔴 Cao |

---

## BIZ-11: Giải ngân & Hoàn trả Loan

### Giải ngân (Disbursement)
```
1. Loan approved → Portal ECOM giải ngân (blackbox)
2. Tiền chuyển đến: nhà phân phối / Brand (không qua Merchant)
3. ECO TSH nhận: { loanId, disbursedAmount, disbursedTo, repaymentDueDate }
4. Đơn hàng chuyển sang "Confirmed" → tiến hành giao hàng
```

### Hoàn trả (Repayment)
```
1. Merchant có nghĩa vụ trả theo lịch (repaymentSchedule)
2. Phương thức trả: tự động deduct từ Ví ECO / thu hộ từ doanh thu bán hàng
3. ECO TSH hiển thị: danh sách khoản vay + hạn trả + số tiền còn lại
4. [Portal ECOM API] POST /loans/{id}/repay { amount, method }
5. Output: { remainingDebt, nextDueDate, status }
```

### Gaps
| # | Vấn đề | Mức độ |
|---|---|---|
| L-06 | **Điều chỉnh đơn hàng sau giải ngân**: Brand giao thiếu 20% → giá trị đơn giảm → phần loan dư được xử lý thế nào? Tự động điều chỉnh dư nợ hay Merchant phải request? | 🔴 Cao |
| L-07 | **Repayment auto-deduct**: Nếu tự động trừ từ Ví ECO nhưng số dư không đủ → hệ thống làm gì? Alert? Chờ? Overdue ngay? | 🔴 Cao |
| L-08 | **Doanh thu bán hàng dùng để trả nợ**: Thu hộ từ doanh thu POS → merchant bán hàng nhưng tiền không về tài khoản riêng của họ mà trả nợ trước → UX phải cực kỳ rõ ràng | 🔴 Cao |
| L-09 | **Lịch sử tín dụng**: Merchant trả nợ đúng hạn → credit score tăng → hạn mức Loan tăng. Cơ chế này có không? Merchant biết credit score của mình không? | 🟠 TB |
| L-10 | **Bad debt xử lý**: Merchant không trả → Finviet làm gì? Block tài khoản? Thu hồi Fund? Ảnh hưởng đến whitelist Brand? | 🔴 Cao |

---

## Fund vs Loan — So sánh nghiệp vụ

| Tiêu chí | Fund | Loan |
|---|---|---|
| Phê duyệt | Trước (pre-approved limit) | Theo đơn hàng |
| Thời điểm có tiền | Ngay lập tức | Sau khi duyệt |
| Lãi suất | Chưa rõ | Chưa rõ |
| Hạn mức | Cố định (limit được cấp) | Theo giá trị đơn |
| Hoàn trả | Chưa mô tả | Theo lịch |
| Sử dụng cho | Mọi giao dịch | Đơn nhập hàng cụ thể |

### Gaps Fund
| # | Vấn đề | Mức độ |
|---|---|---|
| F-01 | Fund hoàn trả theo cơ chế nào? Merchant "trả lại" Fund hay Fund chỉ là credit line dùng xong tái cấp? | 🔴 Cao |
| F-02 | Fund có tính lãi không? Nếu có, lãi suất là bao nhiêu và cách tính như thế nào? | 🔴 Cao |
| F-03 | Fund cấp bởi Finviet hay đối tác tài chính thứ 3? Ảnh hưởng đến regulatory compliance | 🔴 Cao |


---
> 🔙 **Quay lại Chỉ mục chính:** [README.md](README.md)
