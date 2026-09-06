# 📦 Danh Mục Ứng Dụng & Dịch Vụ Hệ Sinh Thái DOCA (Apps Registry)

> **Chào mừng bạn đến với thư mục `apps/` của `doca-umbrella-workspace`!**  
> Thư mục này đóng vai trò là danh mục định danh (Service Registry) chứa toàn bộ các ứng dụng Frontend, Backend Microservices và Sub-repositories trong hệ sinh thái DOCA / Capcat.

---

## 🏛️ 1. Danh Sách Sub-Repositories & Nơi Triển Khai

Tất cả các ứng dụng con dưới đây được quản lý bằng các Repository độc lập trên tổ chức GitHub **[`capcattech-stack`](https://github.com/capcattech-stack)**:

| Tên Ứng Dụng / Dịch Vụ | Loại Ứng Dụng | Công Nghệ | Đường Dẫn Triển Khai (Live Domain) | Repository URL |
| :--- | :--- | :--- | :--- | :--- |
| **`doca-affiliate-web`** | Web Khách Hàng (Main Portal) | Astro, TypeScript, Muji CSS | [doca.capcat.vn](https://doca.capcat.vn) · [doca.pet](https://doca.pet) | `git@github.com:capcattech-stack/doca-affiliate-web.git` |
| **`doca-admin-web`** | Web Quản Trị & Đối Soát Ví Cá | Astro, Chart.js, Supabase | [admin.capcat.vn](https://admin.capcat.vn) | `git@github.com:capcattech-stack/doca-admin-web.git` |
| **`doca-kiosk-web`** | Cổng Kiosk Cá Nhân Creator | Astro SPA, Supabase | [kiosk.capcat.vn](https://kiosk.capcat.vn) | `git@github.com:capcattech-stack/doca-kiosk-web.git` |
| **`coin-hub`** | Virtual Economy & Ledger API | NestJS, TypeORM, BullMQ, Redis | `https://coin-hub-406a.onrender.com` | `git@github.com:capcattech-stack/coin-hub.git` |
| **`core-platforms`** | Nền Tảng Dịch Vụ Lõi Backend | NestJS, PostgreSQL | Internal Gateway | `git@github.com:capcattech-stack/core-platforms.git` |

---

## ⚡ 2. Cơ Chế Làm Việc On-Demand (Lazy Pull / Lazy Cloning)

Nhằm tối ưu hóa dung lượng ổ đĩa và phân lập mã nguồn rõ ràng:
* Thư mục `apps/` trên Git Umbrella mặc định **chỉ lưu file định danh này**.
* Khi bạn hoặc AI Agent cần phát triển, sửa lỗi hoặc kiểm thử trên bất kỳ ứng dụng nào, chỉ cần chạy lệnh `git clone` tương ứng để kéo mã nguồn của app đó về thư mục `apps/`.

### 🛠️ Lệnh Clone Từng Ứng Dụng Cụ Thể:

```bash
# 1. Kéo Web Người Dùng Chính (doca-affiliate-web)
git clone git@github.com:capcattech-stack/doca-affiliate-web.git apps/doca-affiliate-web

# 2. Kéo Web Quản Trị Admin & Đối Soát Tài Chính (doca-admin-web)
git clone git@github.com:capcattech-stack/doca-admin-web.git apps/doca-admin-web

# 3. Kéo Web Kiosk Cá Nhân (doca-kiosk-web)
git clone git@github.com:capcattech-stack/doca-kiosk-web.git apps/doca-kiosk-web

# 4. Kéo Doca Coin Hub Backend Microservice (coin-hub)
git clone git@github.com:capcattech-stack/coin-hub.git apps/coin-hub
```

---

## 📐 3. Quy Chuẩn Làm Việc Dành Cho Lập Trình Viên & AI Agents

1. **Độc lập mã nguồn:** Mọi commit và push của từng ứng dụng con chỉ thực hiện bên trong thư mục con tương ứng (ví dụ: `git -C apps/doca-affiliate-web push origin main`).
2. **Quy chuẩn Git:** Tuân thủ chiến lược phân nhánh `main` ➔ `staging` ➔ `dev` được quy định tại [.agents/rules/git_conventions.md](../.agents/rules/git_conventions.md).
3. **Môi trường & Biến Secret:** Mỗi ứng dụng con duy trì file `.env` và `.env.example` riêng biệt tại thư mục gốc của app đó.
