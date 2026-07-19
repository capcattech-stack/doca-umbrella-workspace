# Planning Contradictions Register

| ID | Topic | Source A | Source B | Conflict | Decision | Owner |
| --- | --- | --- | --- | --- | --- | --- |
| K001 | SSG vs Dynamic Quiz Updates | Tải trang tĩnh SSG (siêu nhanh, tốt cho SEO và CTR) | Truy vấn DB động ở trang Admin (chỉnh sửa câu đố thấy tác dụng ngay) | Trang tĩnh không tự động cập nhật khi Admin sửa bảng Supabase. | Truy vấn Supabase tại thời điểm build trong getStaticPaths(). Admin sửa câu hỏi sẽ kích hoạt webhook build lại web. | cyrus-research-critic |
| K002 | Google SSO vs Email/Password Auth | Google SSO (Dễ dàng, bảo mật cao) | Email & Mật khẩu truyền thống | Email/password cần quản trị giao diện khôi phục và mã hóa, SSO cần cấu hình redirect URI phức tạp hơn ở local. | Sử dụng hoàn toàn Google SSO thông qua Supabase Auth để tối ưu bảo mật và tiện lợi cho đội ngũ Capcat. | cyrus-research-critic |
