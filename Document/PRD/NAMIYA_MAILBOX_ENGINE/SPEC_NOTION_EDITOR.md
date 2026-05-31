# 📝 ĐẶC TẢ GIAO DIỆN & TRẢI NGHIỆM SOẠN THẢO NOTION-GRADE
*(SPEC_NOTION_EDITOR - TECHNICAL & UI/UX SPECIFICATION)*

> **Mã Đặc Tả:** `SPEC_NOTION_EDITOR`  
> **Phân hệ cha:** `NAMIYA_MAILBOX_ENGINE`  
> **Người biên soạn:** Benny (Senior Mobile Developer)  
> **Trạng thái:** Hoàn thành (Dev-Ready - Đã sửa lỗi đối kháng)  

---

## I. TRIẾT LÝ THIẾT KẾ (DESIGN PHILOSOPHY)

Trình soạn thảo văn bản được phát triển trên triết lý **"Vô hình" (Distraction-Free)** và tối giản phẳng của ứng dụng Notion: Mọi đường viền, nút bấm thừa thãi đều bị loại bỏ, nhường chỗ cho chữ viết và khoảng trắng tinh khiết trên nền trắng phẳng. 

Đồng thời, cấu trúc mã nguồn được thiết kế theo mô hình **Mô-đun hóa (Modularity)** và tách biệt (Decoupled) để tái sử dụng làm lõi soạn thảo chung cho:
1.  **Tiệm tạp hóa Namiya - Gỡ rối tơ lòng** (Gửi thư tơ lòng ẩn danh).
2.  **Nhận nuôi thú cưng thật** (Ẩn ý nhận nuôi từ màn hình rỗng).
3.  **Trình viết Nhật ký / Moments** trong tương lai.

---

## II. ĐẶC TẢ GIAO DIỆN NGƯỜI DÙNG (UI SPECIFICATION)

```
+---------------------------------------------------+
|  [<]            Thư gửi Capcat             [Gửi]  |  <-- Minimal Header (Cao: 56dp)
+---------------------------------------------------+
|                                                   |
|  Tiêu đề bức thư...                               |  <-- H1 Title (Bold, 26sp, Borderless)
|                                                   |
|  -----------------------------------------------  |  <-- Thin Divider (Cao: 1dp, #E2E8F0)
|                                                   |
|  Hãy viết những chia sẻ chân thành nhất của bạn   |
|  ở đây...                                         |  <-- Multiline Canvas (16sp, height: 1.5)
|                                                   |
+---------------------------------------------------+
| [ B ]  [ I ]  [ U ]  [List]  [ ] To-Do   150 từ   |  <-- Notion Toolbar (Dính liền trên bàn phím)
+---------------------------------------------------+
```

### 1. Bố cục không gian (Spatial Layout)
*   **Màu nền:** Trắng phẳng tuyệt đối (`Color(0xFFFFFFFF)`).
*   **Padding chuẩn:** `padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0)`.
*   **Đường chia cắt (Divider):** Đường kẻ mỏng `1px` màu xám nhạt (`Color(0xFFE2E8F0)`), tạo ranh giới tinh tế giữa Tiêu đề và Thân bài.

### 2. Thiết kế Chữ (Typography Grid)
*   **Tiêu đề thư (H1 Title):**
    *   Font chữ: `Quicksand` (Bold, `FontWeight.w700`).
    *   Cỡ chữ: `26sp` (Line height: `1.2`).
    *   Decoration: `InputBorder.none` (Không có bất kỳ đường viền nào khi trỏ vào).
*   **Nội dung bức thư (Body Canvas):**
    *   Font chữ: `Quicksand` (Regular/Medium, `FontWeight.w500`).
    *   Cỡ chữ: `16sp` (Line height thoáng: `1.5` để gõ chữ không bị dí sát vào nhau).
    *   Màu chữ: `Color(0xFF1E293B)` (Đen phiến đá, dễ đọc, không chói).
    *   Decoration: `InputBorder.none`.

---

## III. ĐẶC TẢ TƯƠNG TÁC & TRẢI NGHIỆM (UX & KINETICS)

### 1. Thanh công cụ thông minh bám bàn phím (Notion Toolbar Overlay)
*   **Hành vi:** Khi người dùng nhấn vào khu vực soạn thảo, bàn phím nổi lên và kéo theo một **Thanh công cụ phụ trợ (Accessory Bar)** nằm ngay phía trên bàn phím.
*   **Giao diện:**
    *   Chiều cao: `44dp`.
    *   Nền: Màu xám nhạt phẳng cực kỳ sang xịn (`Color(0xFFF8FAFC)`).
    *   Chứa các icon công cụ phẳng: `[B] (Bold)`, `[I] (Italic)`, `[List] (Bulleted)`, `[ ] To-Do`.
    *   Góc phải hiển thị số từ thời gian thực: `150 từ` (Màu xám nhạt, font chữ siêu nhỏ `11sp`).
*   **Haptic Feedback:** Mỗi lần người dùng bấm vào một icon công cụ trên thanh, hệ thống sẽ rung nhẹ một nhịp siêu ngắn (Light Haptic) bằng `HapticFeedback.lightImpact()`.

### 2. Logic chuyển Focus thông minh
*   Khi người dùng đang ở ô Tiêu đề và nhấn nút "Tiếp tục" (Next/Enter) trên bàn phím: con trỏ tự động nhảy xuống dòng đầu tiên của ô Thân bài viết và hiển thị hiệu ứng nhấp nháy êm dịu, bàn phím giữ nguyên trạng thái nổi.

### 3. Hiệu ứng cuộn chống che khuất (Keyboard-Aware Physics)
*   Sử dụng `MediaQuery.of(context).viewInsets.bottom` để tính toán chính xác chiều cao bàn phím và tự động chèn khoảng trống (`SizedBox(height: keyboardHeight)`) dưới đáy trang.
*   Trang soạn thảo tự động cuộn lên một khoảng vừa đủ (`ScrollController.animateTo`) để dòng chữ đang gõ luôn nằm ở tầm mắt (ở khoảng 40% tính từ cạnh dưới màn hình), không bị bàn phím che mất.

### 4. Cơ chế thu nhỏ Tiêu đề khi tập trung viết (Notion Focus Zoom)
Để giải quyết triệt để **điểm gãy không gian màn hình nhỏ** (khi bàn phím chiếm 50% diện tích làm ô nhập liệu bị bóp nghẹt):
*   **Hành vi:** Khi ô soạn thảo Thân bài nhận tiêu điểm (`_bodyFocusNode.hasFocus` là true):
    1.  Khu vực Tiêu đề thư (H1 Title) và thanh Divider sẽ tự động co lại và trượt mờ dần (Slide & Fade Out) lên trên.
    2.  Tiêu đề lớn sẽ biến mất để nhường toàn bộ 100% diện tích hiển thị còn lại cho Thân bài gõ chữ rộng rãi.
    3.  Trên thanh Header nhỏ (AppBar) lúc này, tiêu đề nhỏ "Soạn thư" sẽ tự động chuyển thành tiêu đề bức thư người dùng đang gõ dưới dạng text rút gọn (ví dụ: *"Thư gửi Lucky..."*) để người dùng vẫn ghi nhớ bối cảnh đang viết.
*   **Trở lại ban đầu:** Khi nhấn nút Back hoặc nhấn thoát tiêu điểm, tiêu đề H1 sẽ trượt hiển thị lại đầy đủ như cũ.

---

## IV. ĐẶC TẢ MÃ NGUỒN SOẠN THẢO CHI TIẾT (SOURCE IMPLEMENTATION SPEC)

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CapcatNotionEditor extends StatefulWidget {
  final String initialTitle;
  final String initialBody;
  final String titleHint;
  final String bodyHint;
  final int minWordCount;
  final Function(String title, String body) onSend;

  const CapcatNotionEditor({
    super.key,
    this.initialTitle = '',
    this.initialBody = '',
    this.titleHint = 'Tiêu đề...',
    this.bodyHint = 'Hãy chia sẻ chân thành ở đây...',
    this.minWordCount = 10,
    required this.onSend,
  });

  @override
  State<CapcatNotionEditor> createState() => _CapcatNotionEditorState();
}

class _CapcatNotionEditorState extends State<CapcatNotionEditor> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();
  int _wordCount = 0;
  bool _isWritingBody = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _bodyController = TextEditingController(text: widget.initialBody);
    _bodyController.addListener(_updateWordCount);
    
    // Lắng nghe tiêu điểm thân bài viết để kích hoạt cơ chế thu nhỏ tiêu đề
    _bodyFocusNode.addListener(() {
      setState(() {
        _isWritingBody = _bodyFocusNode.hasFocus;
      });
    });
  }

  void _updateWordCount() {
    final text = _bodyController.text.trim();
    if (text.isEmpty) {
      setState(() => _wordCount = 0);
      return;
    }
    final words = text.split(RegExp(r'\s+'));
    setState(() => _wordCount = words.length);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Thu nhỏ tiêu đề động lên thanh AppBar khi đang gõ thân bài viết
        title: Text(
          _isWritingBody && _titleController.text.isNotEmpty
              ? _titleController.text
              : 'Soạn thư',
          style: const TextStyle(
            fontFamily: 'Quicksand', 
            color: Colors.black87, 
            fontSize: 16, 
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_wordCount < widget.minWordCount) {
                HapticFeedback.vibrate();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hãy viết thêm một chút chia sẻ chân thành nhé! ❤️')),
                );
                return;
              }
              widget.onSend(_titleController.text.trim(), _bodyController.text.trim());
            },
            child: const Text(
              'Gửi',
              style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF388C70)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Co giãn động tiêu đề lớn tùy thuộc tiêu điểm soạn thảo
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      height: _isWritingBody ? 0 : 64,
                      opacity: _isWritingBody ? 0 : 1,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: TextField(
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => FocusScope.of(context).requestFocus(_bodyFocusNode),
                          style: const TextStyle(fontFamily: 'Quicksand', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: widget.titleHint,
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      height: _isWritingBody ? 0 : 24,
                      child: const Divider(thickness: 1, color: Color(0xFFE2E8F0)),
                    ),
                    TextField(
                      controller: _bodyController,
                      focusNode: _bodyFocusNode,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16, height: 1.5, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        hintText: widget.bodyHint,
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Custom Keyboard Accessory Bar (Notion Toolbar)
            Container(
              height: 44,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.format_bold_rounded, size: 20),
                    onPressed: () => HapticFeedback.lightImpact(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_italic_rounded, size: 20),
                    onPressed: () => HapticFeedback.lightImpact(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
                    onPressed: () => HapticFeedback.lightImpact(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_box_outlined, size: 20),
                    onPressed: () => HapticFeedback.lightImpact(),
                  ),
                  const Spacer(),
                  Text(
                    '$_wordCount từ',
                    style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
