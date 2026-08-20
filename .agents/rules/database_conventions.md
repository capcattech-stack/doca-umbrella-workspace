# Universal Database & Schema Conventions

## 🗄️ Quy chuẩn Kỹ thuật CSDL (Database Conventions)

*   **Phạm vi & Nguyên tắc Cốt lõi (Universal Scope):** Áp dụng bắt buộc 100% cho **Mọi Backend Services**, Web Supabase của PO, và Mobile Apps.
    *   **Mọi Backend Services:** Bắt buộc áp dụng cơ chế Versioned Migration CLI (`up()` / `down()`), cấm tuyệt đối chế độ tự đồng bộ schema (`synchronize: true`).
    *   **Web & PO (Astro / Supabase):** Bắt buộc lưu trữ Versioned SQL DDL Scripts (`.sql`) trực tiếp vào Git (`Document/Website/db/` hoặc `db/supabase/migrations/`).
    *   **Mobile & Client Apps:** Quản lý cấu trúc SQLite/Local Storage thông qua migration hoặc versioned schema scripts.

*   **Cơ chế Quản trị Đa Môi trường (DEV, UAT, PROD) Cho Web & PO:**
    *   **Lưu trữ SQL DDL vào Git (Versioned Artifacts):** Mọi thay đổi bảng, cột, chính sách bảo mật RLS bắt buộc phải xuất ra file `.sql` có đánh số thứ tự phiên bản (ví dụ: `01_init_schema.sql`, `02_seed_data.sql`, `03_add_product_clicks.sql`).
    *   **Viết lệnh an toàn (Idempotent Scripts):** Bắt buộc sử dụng `CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`.
    *   **Quy trình đồng bộ 3 bước:**
        *   **DEV:** Chạy file `.sql` vào Supabase DEV để PO/Dev kiểm thử tính năng và giao diện.
        *   **UAT:** Nạp lần lượt các file `.sql` theo đúng thứ tự version vào Supabase UAT khi nghiệm thu.
        *   **PRODUCTION:** Nạp các file `.sql` mới vào Supabase PROD khi release sản phẩm thật.

*   **Quy chuẩn Đặt tên (Naming Conventions):**
    *   **Tên Bảng (Table Names):** Bắt buộc là danh từ số nhiều (plural), viết thường dạng `snake_case` (ví dụ: `products`, `product_clicks`, `waitlist_users`, `coin_transactions`).
    *   **Tên Cột (Column Names):** Bắt buộc là `snake_case` (ví dụ: `product_id`, `created_at`, `is_active`, `wholesale_price`).
    *   **Khóa ngoại (Foreign Keys):** Bắt buộc có cấu trúc `<tên_bảng_cha_ở_dạng_số_ít>_id` (ví dụ: `product_id` trỏ tới `products`, `user_id` trỏ tới `users`).
    *   **Ràng buộc & Chỉ mục (Indexes & Constraints):**
        *   Khóa chính: `pk_<table_name>`
        *   Khóa ngoại: `fk_<table_name>_<referenced_table>_<column>`
        *   Unique Constraint: `uq_<table_name>_<column>`
        *   Index tìm kiếm: `idx_<table_name>_<column1>_<column2>`

*   **Bốn Cột Kiểm toán Bắt buộc (Mandatory Audit Columns):**
    *   **Cột id (Khóa chính):** Tên cột luôn thống nhất là `id`. Kiểu dữ liệu linh hoạt theo đặc thù nghiệp vụ:
        *   Kiểu `UUID`: Dùng cho bảng người dùng, tài khoản, đơn hàng, giao dịch, chat/message, hoặc các bảng cần bảo mật ID / phân tán / sync offline.
        *   Kiểu `BIGINT` hoặc `INT` tự tăng: Dùng cho bảng danh mục, Master Data, đơn vị hành chính, bảng tra cứu.
    *   **Cột created_at:** Kiểu `timestamptz` (`timestamp with time zone`), mặc định `CURRENT_TIMESTAMP` hoặc `timezone('utc'::text, now())`.
    *   **Cột updated_at:** Kiểu `timestamptz`, tự động cập nhật thời gian mỗi khi bản ghi có chỉnh sửa.
    *   **Cột deleted_at:** Kiểu `timestamptz` (cho phép `NULL`), dùng cho cơ chế Soft Delete. Mặc định `NULL`.

*   **Kiểu Dữ Liệu & Bảo Toàn Tài Chính (Financial Precision & Security):**
    *   **Cấm dùng float / double:** Tuyệt đối không dùng `float`, `double`, `real` cho tiền tệ, coin, điểm thưởng để tránh lỗi làm tròn số thực.
    *   **Kiểu số dư bắt buộc:** Dùng `numeric(12, 2)`, `numeric(18, 4)` hoặc `bigint` (đơn vị nguyên nhỏ nhất).
    *   **Bảo toàn dữ liệu (Zero Destructive DDL):** Cấm chạy lệnh hủy diệt (`DROP TABLE`, `DROP COLUMN`) trên môi trường UAT / PROD. Dữ liệu log và giao dịch là **Append-Only** (chỉ ghi thêm, không sửa/xóa).
    *   **Bảo mật RLS:** Bắt buộc bật Row Level Security (`ENABLE ROW LEVEL SECURITY`) trên Supabase để kiểm soát quyền đọc/ghi dữ liệu của người dùng.

*   **Checklist Kiểm tra khi Code hoặc Yêu cầu Agent:**
    *   Kiểm tra bảng đã có đủ 4 cột kiểm toán (`id`, `created_at`, `updated_at`, `deleted_at`).
    *   Kiểm tra tên bảng là số nhiều `snake_case`, tên cột `snake_case`.
    *   Kiểm tra kiểu tiền tệ / giá bán là `numeric` hoặc `bigint` (không dùng `float`).
    *   Đã tạo file migration (cho Backend) hoặc file `.sql` có version trong Git (cho Web/PO).
