# **Chuỗi cung ứng M2C thông qua Hệ sinh thái ECO Tiệm Số Hóa**
Finviet đã định vị là một đơn vị tiên phong khi xây dựng hệ sinh thái M2C, lấy ứng dụng ECO Tiệm Số Hóa (ECO TSH) làm hạt nhân để kết nối các thực thể trong chuỗi cung ứng.
## **Phân tích Bối cảnh và Mô hình Vận hành Hệ thống**
Nền tảng M2C của Finviet không đơn thuần là một ứng dụng bán hàng mà là một hạ tầng công nghệ toàn diện tích hợp chuỗi cung ứng, thanh toán, tài chính và tiếp thị. Đối tượng trọng tâm của hệ thống là các điểm bán lẻ truyền thống (General Trade - GT), vốn chiếm tỷ trọng lớn trong thị trường bán lẻ Việt Nam nhưng lại đang đối mặt với sự thiếu hụt về công cụ quản lý và khả năng tiếp cận nguồn vốn. ECO TSH đóng vai trò là "điểm chạm số" (digital touchpoint) cho phép các chủ tiệm tạp hóa thực hiện quá trình chuyển đổi số từ khâu nhập hàng cho đến khi hàng hóa tới tay người tiêu dùng cuối cùng.

Hệ thống được thiết kế dựa trên kiến trúc tích hợp chặt chẽ giữa ứng dụng di động (ECO TSH) và hệ thống quản trị trung tâm Portal ECOM. Trong cấu trúc này, ECOM Portal đóng vai trò song hành: vừa là hệ thống Admin Portal phục vụ quản trị trung tâm, vừa là nền tảng cung cấp API kết nối trực tiếp cho các tác vụ trên ứng dụng mobile ECO TSH. Sự phân tách này đảm bảo tính linh hoạt cho người dùng cuối (Merchant) trong khi vẫn duy trì khả năng kiểm soát dữ liệu tập trung cho nhà vận hành hệ thống.

|**Thành phần hệ sinh thái**|**Chức năng chiến lược**|**Tác động đến chuỗi giá trị**|
| :- | :- | :- |
|**ECO Merchant (ECO TSH)**|Điểm chạm cho các hộ kinh doanh|Số hóa hoạt động vận hành hàng ngày của tiệm tạp hóa|
|**Portal ECOM**|Admin Portal & API Gateway|Quản trị hệ thống và cung cấp hạ tầng kết nối mobile|
|**Finviet Supply Chain**|Mạng lưới cung ứng được Finviet xây dựng|Đảm bảo nguồn hàng đa dạng cho các điểm bán tự do|
|**Hệ thống Tài chính**|Cung cấp vốn lưu động và BNPL|Giải quyết bài toán dòng tiền cho tiểu thương và người tiêu dùng|
## **Phân tích Chi tiết các Phân hệ Nghiệp vụ chính**
### **Phân hệ Nhập hàng và Quản trị Nguồn cung ứng**
Nghiệp vụ nhập hàng là khởi đầu của dòng chảy hàng hóa trong hệ thống. Khác với các ứng dụng thương mại điện tử thông thường, ECO TSH áp dụng các quy tắc kinh doanh nghiêm rặt về phân vùng và đối tượng để bảo vệ cấu trúc kênh phân phối của các nhãn hàng.

Một trong những quy tắc cốt lõi là nguyên tắc cấm bán chéo (Non-cross-selling). Đối với các nhà cung cấp thuộc Brand (như Thọ Phát, Acecook), hệ thống chỉ cho phép các điểm bán thuộc danh sách quản lý của Brand đó nhìn thấy và đặt hàng sản phẩm của chính họ. Bên cạnh đó, hệ thống còn áp dụng nguyên tắc quản lý theo khu vực phân phối. Mỗi Merchant sẽ được gắn với một địa chỉ cửa hàng cụ thể, từ đó hệ thống sẽ tự động xác định đơn vị phân phối phụ trách khu vực đó để điều hướng đơn hàng. Quy trình hiển thị hàng hóa còn được tối ưu hóa thông qua việc ánh xạ danh mục hàng hóa với loại hình kinh doanh. Ví dụ, một cửa hàng tạp hóa sẽ được ưu tiên hiển thị các mặt hàng tiêu dùng nhanh (FMCG).
### **Phân hệ Bán hàng và Quản trị Bán lẻ (Mini POS)**
Phân hệ bán hàng biến ứng dụng ECO TSH thành một máy POS cầm tay thông minh, hỗ trợ quản lý đơn hàng bán ra cho khách lẻ. Hệ thống Mini POS này cung cấp cơ chế quản lý tồn kho linh hoạt, cho phép liên thông dữ liệu tự động hoặc điều chỉnh thủ công tùy theo nhu cầu của chủ tiệm. Đặc biệt, POS hỗ trợ chế độ bán hàng tự do (cho phép bán âm) để đảm bảo giao dịch không bị gián đoạn ngay cả khi dữ liệu tồn kho trên hệ thống chưa kịp cập nhật so với thực tế tại quầy.

Về mặt tuân thủ pháp lý, phân hệ này tích hợp sâu với các quy định về thuế (như Nghị định 70/2025/NĐ-CP). Hệ thống cho phép Merchant xuất hóa đơn điện tử theo tùy chỉnh cho từng giao dịch. Dữ liệu bán hàng được tự động tổng hợp và lập thành các bảng kê chi tiết, đồng thời hỗ trợ xuất file định dạng chuẩn để Merchant dễ dàng thực hiện kê khai với cơ quan thuế.
### **Phân hệ Dịch vụ Giá trị Gia tăng (VAS) và Tài chính**
Hệ thống thanh toán của Finviet được bảo chứng bởi đầy đủ các giấy phép trung gian thanh toán từ Ngân hàng Nhà nước, bao gồm: Ví điện tử, Cổng thanh toán điện tử và dịch vụ Hỗ trợ thu hộ, chi hộ. Điều này cho phép ECO TSH triển khai đa dạng phương thức thanh toán từ quét mã VietQR, sử dụng số dư ví ECO, đến liên kết ngân hàng.

Cơ chế hỗ trợ tài chính cho Merchant được phân định rõ rệt qua hai loại hình:

- **Fund**: Là hạn mức số dư được xét duyệt và cấp trước cho Merchant (Pre-approved balance) để chủ động sử dụng trong các giao dịch.
- **Loan**: Là khoản vay được phê duyệt sau. Cụ thể, khi Merchant phát sinh đơn hàng nhập hàng mới, hệ thống mới tiến hành các bước xét duyệt giải ngân dựa trên giá trị đơn hàng đó (Order-based approval).

|**Loại hình dịch vụ**|**Cơ chế vận hành**|**Đối tượng thụ hưởng**|
| :- | :- | :- |
|**Hỗ trợ Tài chính**|Cấp Fund (duyệt trước) hoặc Loan (duyệt theo đơn)|Merchant có vốn nhập hàng linh hoạt|
|**Thanh toán & Thu hộ**|Qua Ví điện tử và Cổng thanh toán Finviet|Merchant và đối tác tài chính/dịch vụ|
|**Bán lẻ qua POS**|Quản lý kho (cho phép bán âm) và xuất hóa đơn|Merchant và khách hàng lẻ|
## **Phân tích Hệ thống Portal ECOM (Back-office)**
Portal ECOM phối hợp các mô hình quản trị dữ liệu để vận hành toàn bộ hệ sinh thái.
### **Hệ thống Quản lý Sản phẩm và Giá (PMS)**
PMS chịu trách nhiệm quản lý danh mục hàng hóa đa tầng và thiết lập chính sách giá khác biệt cho từng nhóm Merchant hoặc từng khu vực địa lý. Hệ thống này cũng thực hiện logic kiểm soát hiển thị sản phẩm (Listing logic) để đảm bảo tuân thủ quy tắc cấm bán chéo của các Brand.
### **Hệ thống Quản lý Đơn hàng (OMS) và Đồng bộ ERP**
OMS tiếp nhận đơn hàng từ ECO TSH và thực hiện đồng bộ với hệ thống của các bên cung ứng. Đối với hàng hóa từ các Brand, hệ thống hỗ trợ cơ chế đồng bộ 2 chiều (Bi-directional sync).<sup>8</sup> Tuy nhiên, trong vận hành thực tế, một thách thức lớn là hệ thống ERP của các Brand đối tác thường không phản hồi trạng thái xử lý chi tiết (ví dụ: đang đóng gói, đã xuất kho) về lại phía ECO TSH.

Sự thiếu hụt phản hồi trạng thái từ ERP làm cho việc kiểm soát các chỉ số như GMV (Gross Merchandise Value) trở nên phức tạp. OMS cần cơ chế ghi nhận mọi thay đổi số lượng hoặc hủy đơn từ ERP để đối soát chính xác giá trị đơn hàng thực tế sau cùng.
### **Quản lý Tồn kho (Inventory) và Phân quyền (USCR)**
Hệ thống Inventory tại Portal ECOM quản lý tồn kho tại kho nhà cung cấp và hỗ trợ liên thông với kho tại điểm bán của Merchant. USCR (Quản lý tài khoản) cung cấp đầy đủ các cấp độ phân quyền (Roles), cho phép cấu hình chi tiết quyền hạn từ cấp Chủ cửa hàng (Store Owner), Quản lý đến Nhân viên bán hàng, đảm bảo tính bảo mật và chuyên môn hóa trong vận hành.
## **Phân tích Đối tượng và Luồng nghiệp vụ chính**
### **Các Đối tượng tham gia (Actors)**

|**Tác nhân**|**Vai trò trong hệ thống**|**Quyền hạn và Trách nhiệm**|
| :- | :- | :- |
|**Merchant (Chủ tiệm)**|Người dùng chính của ECO TSH|Đặt hàng nhập, bán lẻ, quản lý tài chính, xuất hóa đơn thuế|
|**Nhà cung cấp Brand**|Các nhãn hàng đối tác|Quản lý sản phẩm riêng, đồng bộ đơn hàng qua ERP 2 chiều|
|**Finviet Admin**|Quản trị hệ thống|Vận hành Portal ECOM, cấu hình API và phân quyền USCR|
|**Hệ thống ERP Brand**|Hệ thống bên thứ ba|Tiếp nhận đơn hàng từ OMS nhưng hạn chế báo trạng thái về|
### **Luồng nghiệp vụ Nhập hàng và Xử lý đơn hàng (Inbound Flow)**
1. **Khởi tạo**: Merchant truy cập mục Nhập hàng. Hệ thống gọi API từ Portal ECOM để lọc sản phẩm theo quy tắc khu vực.
1. **Thanh toán**: Merchant chọn thanh toán bằng số dư ví, bằng công thanh toán, bằng số dư Fund (số dư có sẵn), hoặc đăng ký Loan (chờ duyệt theo đơn hàng).
1. **Đồng bộ OMS**: Đơn hàng được sync sang ERP của Brand. Do ERP thường không báo trạng thái về, OMS sẽ theo dõi qua các kênh đối soát định kỳ để cập nhật cho Merchant.
1. **Giao hàng & Nhận hàng**: Đơn vị phân phối giao hàng. Merchant xác nhận nhận hàng để hệ thống tự động cập nhật tồn kho tại POS (liên thông tự động).
### **Luồng nghiệp vụ Bán hàng lẻ (Outbound Flow)**
1. **Quét mã & Lên đơn**: Nhân viên dùng Mini POS quét mã vạch. Nếu hàng không có sẵn trong kho hệ thống, POS vẫn cho phép "bán âm" để phục vụ khách kịp thời.
1. **Tất toán & Hóa đơn**: Hệ thống tính tiền. Merchant chọn xuất hóa đơn điện tử nếu khách yêu cầu.<sup>6</sup>
1. **Báo cáo Thuế**: Cuối kỳ, Merchant sử dụng tính năng trên Portal/App để xuất bảng kê và file dữ liệu bán hàng để thực hiện nghĩa vụ thuế.<sup>6</sup>
## **Các vấn đề cần làm rõ và Câu hỏi đặt ra cho Nghiệp vụ**
1. **Cơ chế phản hồi trạng thái ERP**: Làm thế nào để cải thiện việc nhận diện trạng thái đơn hàng từ Brand khi ERP không báo về? Có nên bổ sung bước xác nhận thủ công từ nhân viên kho của Brand trên Portal ECOM không?
1. **Quản lý rủi ro bán âm**: Khi Merchant bán âm quá mức, hệ thống có cơ chế cảnh báo hoặc tự động tạo đơn hàng nhập gợi ý để bù đắp tồn kho không?
1. **Đối soát Fund & Loan**: Trong trường hợp đơn hàng bị Brand điều chỉnh giảm giá trị, phần chênh lệch sẽ được hoàn trả vào Fund hay giảm trừ vào nghĩa vụ nợ của Loan ngay lập tức?
1. **Tính nhất quán của Bảng kê Thuế**: Bảng kê thuế sẽ dựa trên dữ liệu POS thực tế hay dữ liệu hóa đơn đã xuất? (Trường hợp Merchant bán hàng nhưng không xuất hóa đơn điện tử cho khách lẻ).


---

> 📎 **BA Review đầy đủ** (Gap Analysis, Edge Cases, Risk Matrix, Câu hỏi phản biện): [00_ba_review.md](00_ba_review.md)
> 🎭 **Phân tích Actor Role-Play:** Hành trình và điểm gãy của các tác nhân (Store Owner, Staff, Brand, v.v.): Xem tại [README.md](README.md#phân-tích-actor-role-play)
> 📚 **Chỉ mục toàn bộ tài liệu:** [README.md](README.md)
