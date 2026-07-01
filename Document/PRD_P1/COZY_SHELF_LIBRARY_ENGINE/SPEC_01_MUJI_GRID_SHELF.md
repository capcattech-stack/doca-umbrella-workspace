# ĐẶC TẢ CHI TIẾT 01: HỆ THỐNG LƯỚI PHẲNG & GIAO DIỆN TỐI GIẢN MUJI
*(MUJI FLAT GRID GRID SYSTEM & TYPOGRAPHY SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC-SHELF-01`  
> **Chủ trì:** Benny (Senior Mobile Dev) & Alan (Tech Lead)  
> **Định hướng thẩm mỹ:** **Tối giản Muji** — Không loè loẹt, cấu trúc grid vuông vắn, trực quan hoá bằng khoảng thở (padding) rộng lớn và viền chỉ mảnh 1px.

---

## 🎨 1. Bảng Thông Số Thiết Kế Hệ Thống Muji (Design Tokens)

Để hiện thực hóa giao diện Muji một cách dễ dàng nhất, tuyệt đối tránh các hiệu ứng vẽ chồng lấn phức tạp, chúng ta thiết lập bộ thông số Design Tokens chuẩn hóa bằng code Dart:

```dart
class MujiTheme {
  // Bảng màu Muji ấm áp tĩnh lặng
  static const Color background = Color(0xFFFBFBFA);     // Trắng kem giấy tái chế cực dịu mắt
  static const Color cardBg = Color(0xFFFFFFFF);         // Thẻ màu trắng tinh khiết tạo độ nổi tương phản nhẹ
  static const Color textMain = Color(0xFF262626);       // Đen Obsidian ấm (tránh dùng đen tuyệt đối #000)
  static const Color textMuted = Color(0xFF8C8C8C);      // Xám tro trung tính cho caption
  static const Color borderLight = Color(0xFFEAEAEA);    // Đường chỉ viền siêu mảnh ngăn nắp
  
  // Màu sắc phân hệ tối giản
  static const Color musicAccent = Color(0xFFE8F0FE);    // Xanh dương pastel nhạt dịu mát
  static const Color bookAccent = Color(0xFFFDF2E9);     // Cam đất pastel nhạt hoài niệm
  static const Color placeAccent = Color(0xFFE8F5E9);    // Xanh sage pastel nhạt yên bình
  static const Color charAccent = Color(0xFFFFF9C4);     // Vàng ấm nhạt cho nhân vật
  static const Color eventAccent = Color(0xFFF3E5F5);    // Tím pastel nhạt thanh nhã cho sự kiện hoài niệm

  // Typography Muji ngăn nắp
  static const TextStyle titleGrid = TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w600,
    fontSize: 15.0,
    color: textMain,
  );

  static const TextStyle captionGrid = TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    color: textMuted,
  );
}
```

---

## 📐 2. Bố Cục Lưới Phẳng Ngăn Nắp (Muji Grid & Tab System)

Giao diện Shelf Library được thiết lập phẳng 100% bằng cách kết hợp `NestedScrollView`, `TabBar` phẳng và `SliverGrid`:

```
+-------------------------------------------------------------------------+
|                           KỆ THƯ VIỆN KÝ ỨC                             | <--- Appbar phẳng không đổ bóng, nền #FBFBFA
+-------------------------------------------------------------------------+
|  Tất cả  |  Giai điệu  |  Trang sách  |  Điểm hẹn  |  Nhân vật  | Sự kiện   | <--- TabBar phẳng viền dưới mảnh 1px
+-------------------------------------------------------------------------+
|                                                                         |
|  +---------------------+        +---------------------+                 |
|  | [🎧]                 |        | [📚]                 |                 |
|  | Blue in Green       |        | Rừng Na Uy          |     | <--- Grid View 2 cột vuông vắn
|  | 31/05 • Bánh Mỳ     |        | 28/05 • Bánh Mỳ     |     |
|  +---------------------+        +---------------------+     |
|                                                             |
|  +---------------------+                                    |
|  | [📍]                 |                                    |
|  | Cafe Sách Gỗ        |                                    |
|  | Tan ca muộn         |                                    |
|  +---------------------+                                    |
+-------------------------------------------------------------+
```

### 2.1. Thanh điều hướng Tab phẳng (TabBar Spec):
*   **Background:** Trong suốt (`Colors.transparent`), nằm đè lên nền trắng kem `#FBFBFA`.
*   **Indicator:** Chỉ là một đường thẳng nằm phẳng dưới Tab được chọn, độ dày `2px`, màu đen Obsidian `#262626`. Không bo góc hay tô nền cho tab được chọn.
*   **Text Style:** Tab được chọn dùng màu đen Obsidian, Tab chưa được chọn dùng màu xám tro `#8C8C8C`.

### 2.2. Thẻ bài Flat Muji Card (Grid Items):
*   **Bố cục:** Lưới 2 cột song song (`SliverGridDelegateWithFixedCrossAxisCount` với `crossAxisCount: 2`).
*   **Padding & Spacing:** Khoảng cách giữa các thẻ (spacing) là `12px`, padding lề ngoài là `16px`.
*   **Cấu trúc một thẻ Card phẳng:**
    *   `Container` bo góc nhẹ (`BorderRadius.circular(8.0)`).
    *   `border: Border.all(color: MujiTheme.borderLight, width: 1.0)` -> Tạo đường viền mảnh tinh khiết.
    *   Không đổ bóng (`boxShadow: []` hoặc bóng cực mờ `black.withOpacity(0.02)`).
    *   **Phân vùng bên trong thẻ (Vertical Stack):**
        *   *Phía trên:* Một ô vuông biểu tượng tối giản, nền tô màu pastel nhạt tương ứng (`musicAccent`, `bookAccent`...), bên trong chứa Icon Vector đơn nét phẳng (Music Note, Book, Map Pin).
        *   *Phía dưới:* Tên vật phẩm, tên tác giả/ca sĩ, ngày mở khóa và biệt danh Boss tặng.

### 2.3. Giao diện trống Kệ Thư Viện (Muji Empty State):
*   **Điều kiện hiển thị:** Khi danh sách vật phẩm từ SQLite cục bộ trả về rỗng (`unlocked_shelf_items.isEmpty` là true).
*   **Bố cục giao diện:**
    *   Nền màu trắng kem `#FBFBFA` đồng nhất.
    *   Một hình vẽ nét đơn mảnh (Minimal Outline Illustration) phác họa chiếc kệ sách Muji trống trải có bóng bụi nắng xiên qua nằm ở trung tâm màn hình.
    *   Dưới hình vẽ là dòng mô tả Iyashikei ấm áp: 
        > *"Kệ ký ức đang đợi Boss lấp đầy... Khi trò chuyện, Boss sẽ thỉnh thoảng chia sẻ các bài hát hay, trang sách ý nghĩa hoặc điểm hẹn chữa lành. Hãy chạm vào chúng để lưu giữ tại đây nhé! 🐾"*
    *   Font chữ dòng mô tả: `Quicksand` (Medium, cỡ chữ `14sp`, màu xám tro nhạt `#8C8C8C`, line-height `1.5`, căn giữa).

### 2.4. Điều hướng Bottom Sheet qua Global Key (Global Navigation Context):
*   **Vấn đề:** Tránh điểm gãy context điều hướng lồng nhau khi người dùng nhấp vào link dotted màu hồng/xanh trong Cozy Chat box để mở Bottom Sheet chi tiết của Shelf.
*   **Giải pháp:** Ứng dụng cấu hình một `navigatorKey` toàn cục đặt tại `main.dart` truyền vào `MaterialApp`. Khi kích hoạt sự kiện mở Bottom Sheet chi tiết từ bất kỳ đâu (như Cozy Chat), hệ thống gọi context thông qua `navigatorKey.currentContext!` để đảm bảo Bottom Sheet được đẩy đè trơn tru lên tầng giao diện cao nhất mà không bị lỗi render widget cục bộ.

---

## ⚡ 3. Hiệu Ứng Phản Hồi Xúc Giác & Micro-Interaction Co Giãn Nhẹ

Để giao diện phẳng Muji không bị nhàm chán và tạo cảm giác cơ học tinh tế khi chạm:

1.  **Hiệu ứng thu nhỏ phản hồi (Micro Scale-down):**
    *   Khi người dùng chạm ngón tay vào một thẻ Card, app kích hoạt hiệu ứng scale nhẹ từ `1.0x` xuống `0.98x` ngay lập tức thông qua `GestureDetector` và `AnimatedContainer`.
    *   Khi thả ngón tay ra, thẻ nẩy nhẹ lại `1.0x` bằng đường cong chuyển động `Curves.easeOutCubic` mượt mà trong vòng `150ms`.
2.  **Rung hơi thở (Micro Haptic Feedback):**
    *   Khi thẻ co ngón tay bấm thành công, máy kích hoạt một nhịp rung cực nhẹ (`HapticFeedback.lightImpact()`) tạo phản hồi xúc giác tinh tế.

---

## 💾 4. Kiến Trúc Đồng Bộ SQLite Cục Bộ (SQLite & State Management)

### 4.1. Bảng SQLite `unlocked_shelf_items`
Bảng lưu trữ thông tin vật phẩm Muji được cấu hình phẳng hoàn toàn:

```sql
CREATE TABLE unlocked_shelf_items (
    item_id VARCHAR(36) PRIMARY KEY,       -- ID duy nhất của vật phẩm
    category VARCHAR(32) NOT NULL,          -- 'music' (nhạc), 'literature' (sách), 'location' (điểm hẹn), 'character' (nhân vật), 'event' (sự kiện)
    title TEXT NOT NULL,                    -- Tên vật phẩm (Blue in Green / Rừng Na Uy...)
    subtitle TEXT,                          -- Tác giả / Ca sĩ
    boss_quote TEXT,                        -- Lời thoại thấu cảm của Boss tặng Sen
    poetic_content TEXT,                    -- Trích dẫn sách hoặc link iTunes preview 30s
    external_url TEXT NOT NULL,             -- Link dẫn ngoài (Spotify, Shopee, Maps)
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Ngày mở khóa kỷ niệm
    pet_id VARCHAR(64) NOT NULL             -- ID Boss tặng kỷ niệm này
);
```

### 4.2. Riverpod State Management (`nanny_shelf_provider.dart`)
Chúng ta sử dụng Riverpod `AsyncNotifier` để theo dõi và đồng bộ danh sách vật phẩm từ SQLite tự động:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShelfCategoryFilter { all, music, literature, location, character, event }

class ShelfFilterState {
  final ShelfCategoryFilter category;
  final String? petId; // Lọc theo từng Pet cụ thể hoặc tất cả

  ShelfFilterState({required this.category, this.petId});
}

class NannyShelfNotifier extends FamilyAsyncNotifier<List<UnlockedShelfItem>, ShelfFilterState> {
  @override
  Future<List<UnlockedShelfItem>> build(ShelfFilterState arg) async {
    final database = ref.watch(sqliteDatabaseProvider);
    
    // Gọi SQLite lấy danh sách đã mở khóa khớp với bộ lọc
    return database.getUnlockedShelfItems(
      category: arg.category,
      petId: arg.petId,
    );
  }

  // Hàm mở khóa vật phẩm mới khi Sen nhấp vào link trong chat
  Future<void> unlockItem(UnlockedShelfItem item) async {
    final database = ref.watch(sqliteDatabaseProvider);
    await database.saveUnlockedShelfItem(item);
    
    // Tự động làm tươi (refresh) danh sách để UI cập nhật thẻ mới sáng lấp lánh
    ref.invalidateSelf();
  }
}
```

---

*Tài liệu đặc tả SPEC_01 này đã được đồng bộ hóa và phê chuẩn để sẵn sàng triển khai. Ký tên: Team Cố vấn Capcat (Sophia, Alan, Benny)*
