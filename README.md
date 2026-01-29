# 🚀 Flutter Learning Journey

Lộ trình học Flutter từ **con số 0** đến **Mobile Frontend Developer**.

---
## 👋 Giới Thiệu

Đây là project học Flutter được thiết kế cho người mới bắt đầu:
- ✅ **Học từng bước** - Không nhảy cóc, tiến từ dễ đến khó
- ✅ **Hiểu bản chất** - Giải thích TẠI SAO, không học vẹt
- ✅ **Thực hành ngay** - Code chạy được, có bài tập kiểm tra

---

## 📚 Lộ Trình Học (8 Phase)

| Phase | Thời gian | Chủ đề | Nội dung chính | Trạng thái |
|-------|-----------|--------|----------------|------------|
| 1 | 1-2 tuần | **Dart Fundamentals** | 5 bài: Variables, OOP, Async, Collections, Enums | ✅ Hoàn thành |
| 2 | 2-3 tuần | **Flutter Basics** | 8 bài: Widget, Layout, Input, Styling | 🔄 Đang học |
| 3 | 2 tuần | State Management | setState, Provider | ⏳ Chờ |
| 4 | 1 tuần | Navigation | Routing, GoRouter | ⏳ Chờ |
| 5 | 2 tuần | API & Data | REST API, Local Storage | ⏳ Chờ |
| 6 | 2 tuần | Clean Architecture | SOLID, Layers | ⏳ Chờ |
| 7 | 2 tuần | BLoC Pattern | Cubit, BLoC | ⏳ Chờ |
| 8 | 4+ tuần | Real Projects | Portfolio Apps | ⏳ Chờ |

---

## 📁 Cấu Trúc Thư Mục

```
white-nebula/
│
├── 📄 README.md                    ← Bạn đang đọc file này
│
├── 📂 01_dart_fundamentals/        ← PHASE 1: Học Dart ✅
│   ├── 📄 README.md
│   ├── 📖 5 bài học (lesson_01 → lesson_05)
│   ├── 🖥️ 5 file code ví dụ
│   └── 📂 exercises/ (15 bài tập)
│
├── 📂 02_flutter_basics/           ← PHASE 2: Flutter Basics 🔄
│   ├── 📄 README.md
│   ├── 📖 8 bài học
│   │   ├── lesson_01_introduction.md   ← Project structure, Flutter overview
│   │   ├── lesson_02_widgets.md        ← Stateless vs Stateful
│   │   ├── lesson_03_basic_widgets.md  ← Text, Container, Image, Icon
│   │   ├── lesson_04_layout.md         ← Row, Column, Stack, Flex
│   │   ├── lesson_05_scrollable.md     ← ListView, GridView
│   │   ├── lesson_06_input.md          ← TextField, Button, Form
│   │   ├── lesson_07_styling.md        ← Theme, ColorScheme, Dark Mode
│   │   └── lesson_08_practice.md       ← Real UI Projects
│   │
│   └── 📂 flutter_basics/          ← Flutter Project
│       ├── lib/
│       │   ├── main.dart
│       │   └── exercises/          ← 22 bài tập
│       ├── pubspec.yaml
│       └── web/
│
├── 📂 03_state_management/         ← PHASE 3 (sắp tới)
└── ...
```

---

## 🎯 Cách Học Hiệu Quả

### Bước 1: Đọc lý thuyết (.md file)
```
Mở file lesson_XX_xxx.md trong thư mục tương ứng
Đọc kỹ, ghi chú những gì chưa hiểu
```

### Bước 2: Xem code ví dụ
```
Mỗi bài học đều có giải thích trong comment
Đọc từ trên xuống, hiểu từng dòng
```

### Bước 3: Làm bài tập (Phase 1 - Dart)
```bash
# Vào thư mục exercises
cd 01_dart_fundamentals/exercises

# Chạy bài tập
dart run exercise_07_future.dart
```

### Bước 4: Làm bài tập (Phase 2 - Flutter)
```bash
# Vào thư mục Flutter project
cd 02_flutter_basics/flutter_basics

# Chạy app trên Chrome
flutter run -d chrome
```

### Bước 5: Hỏi Antigravity
```
Chưa hiểu? Cứ hỏi! 
Tôi sẽ giải thích chi tiết hơn.
```

---

## ⚡ Lệnh Thường Dùng

### Dart

| Lệnh | Chức năng |
|------|-----------|
| `dart run file.dart` | Chạy file Dart |
| `dart analyze` | Kiểm tra lỗi code |
| `dart format file.dart` | Format code đẹp |

### Flutter

| Lệnh | Chức năng |
|------|-----------|
| `flutter create app_name` | Tạo project mới |
| `flutter run -d chrome` | Chạy app trên Chrome |
| `flutter pub get` | Cài dependencies |
| `flutter clean` | Xóa cache, build lại |
| Hot Reload: `r` | Reload nhanh khi chạy |
| Hot Restart: `R` | Restart hoàn toàn |

---

## 📊 Tiến Độ Học

### Phase 1: Dart Fundamentals ✅
- [x] Bài 1: Variables, Null Safety, Functions
- [x] Bài 2: OOP - Class, Inheritance, Interface
- [x] Bài 3: Async - Future, Stream
- [x] Bài 4: Collections & Generics
- [x] Bài 5: Enums & Error Handling

### Phase 2: Flutter Basics 🔄
- [ ] Bài 1: Introduction & Project Structure
- [ ] Bài 2: Widget Fundamentals (Stateless/Stateful)
- [ ] Bài 3: Basic Widgets (Text, Container, Image)
- [ ] Bài 4: Layout (Row, Column, Stack)
- [ ] Bài 5: Scrollable Widgets (ListView, GridView)
- [ ] Bài 6: Input Widgets (TextField, Button, Form)
- [ ] Bài 7: Styling & Theming
- [ ] Bài 8: Real UI Practice

---

## 🆘 Gặp Lỗi?

### 1. Đọc kỹ thông báo lỗi
Dart/Flutter thường báo rõ lỗi ở dòng nào, vấn đề gì.

### 2. Hỏi Antigravity
Copy lỗi và paste vào chat, tôi sẽ giúp bạn fix.

### 3. Google
Tìm: `[thông báo lỗi] flutter` hoặc `dart`

### 4. Path thư mục
Tất cả file tôi tạo đang nằm ở:
```
C:\Users\User\.gemini\antigravity\playground\white-nebula
```

---

## 📞 Thông Tin

- **GitHub**: [NgoThanhDong](https://github.com/NgoThanhDong)
- **Học cùng**: Antigravity AI
- **Môi trường**: Flutter Web (Chrome)

---

## ▶️ Bắt Đầu Phase 2!

1. Mở thư mục `02_flutter_basics`
2. Đọc file `README.md` trong đó
3. Chạy Flutter app:
```bash
cd 02_flutter_basics/flutter_basics
flutter run -d chrome
```

**Chúc bạn học tốt! 🎉**