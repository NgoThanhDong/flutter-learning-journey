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
| 2 | 2-3 tuần | **Flutter Basics** | 8 bài: Widget, Layout, Input, Styling | ✅ Hoàn thành |
| 3 | 2 tuần | **State Management** | 6 bài: setState, Provider, Riverpod | ✅ Hoàn thành |
| 4 | 1 tuần | **Navigation** | 7 bài: Navigator, go_router, Deep Link | ✅ Hoàn thành |
| 5 | 2 tuần | **API Integration** | 7 bài: HTTP, Dio, JSON, Storage | ✅ Hoàn thành |
| 6 | 2 tuần | **Clean Architecture** | 6 bài: SOLID, DI, Repository, Layers | 🔄 Đang học |
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
├── 📂 03_state_management/         ← PHASE 3: State Management 🔄
│   ├── 📄 README.md
│   ├── 📖 6 bài học
│   │   ├── lesson_01_overview.md        ← State types, Prop Drilling
│   │   ├── lesson_02_setstate.md        ← setState, InheritedWidget
│   │   ├── lesson_03_provider_basics.md ← ChangeNotifier, Provider
│   │   ├── lesson_04_provider_advanced.md ← MultiProvider, Selector
│   │   ├── lesson_05_riverpod.md        ← StateProvider, StateNotifier
│   │   └── lesson_06_practice.md        ← Practice Projects
│   │
│   └── 📂 state_app/              ← Flutter Project
│       ├── lib/
│       │   ├── main.dart
│       │   └── exercises/         ← 16 bài tập
│       └── pubspec.yaml           ← provider, flutter_riverpod
│
├── 📂 04_navigation/               ← PHASE 4: Navigation ✅
│   ├── 📄 README.md
│   ├── 📖 7 bài học (Navigator & go_router)
│   ├── 📂 nav_app/                 ← Flutter Project
│   │   ├── lib/exercises/          ← 18 bài tập
│   │   └── pubspec.yaml            ← go_router
│
├── 📂 05_api_integration/          ← PHASE 5: API ✅
│   ├── 📄 README.md
│   ├── 📖 7 bài học (HTTP, Dio, JSON, Storage)
│   ├── 📂 api_app/                 ← Flutter Project
│   │   ├── lib/exercises/          ← 16 bài tập
│   │   └── pubspec.yaml            ← http, dio, hive
│
├── 📂 06_clean_architecture/       ← PHASE 6: Clean Architecture 🔄
│   ├── 📄 README.md
│   ├── 📖 6 bài học (SOLID, DI, Repository, Layers)
│   ├── 📂 clean_app/               ← Flutter Project
│   │   ├── lib/exercises/          ← 18 bài tập
│   │   └── pubspec.yaml            ← get_it, fpdart, equatable
│
└── 📂 07_bloc_pattern/             ← PHASE 7 (sắp tới)
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

### Phase 2: Flutter Basics ✅
- [x] Bài 1: Introduction & Project Structure
- [x] Bài 2: Widget Fundamentals (Stateless/Stateful)
- [x] Bài 3: Basic Widgets (Text, Container, Image)
- [x] Bài 4: Layout (Row, Column, Stack)
- [x] Bài 5: Scrollable Widgets (ListView, GridView)
- [x] Bài 6: Input Widgets (TextField, Button, Form)
- [x] Bài 7: Styling & Theming
- [x] Bài 8: Real UI Practice

### Phase 3: State Management ✅
- [x] Bài 1: State Overview (Local vs Global)
- [x] Bài 2: setState & InheritedWidget
- [x] Bài 3: Provider Basics
- [x] Bài 4: Provider Advanced (MultiProvider, Selector)
- [x] Bài 5: Riverpod
- [x] Bài 6: Practice Projects

### Phase 4: Navigation ✅
- [x] Bài 1: Overview
- [x] Bài 2: Navigator Basics
- [x] Bài 3: Named Routes
- [x] Bài 4: go_router Intro
- [x] Bài 5: go_router Advanced
- [x] Bài 6: Deep Linking
- [x] Bài 7: Practice Projects

### Phase 5: API Integration ✅
- [x] Bài 1: API Overview
- [x] Bài 2: http Package
- [x] Bài 3: JSON & Models
- [x] Bài 4: Dio Advanced
- [x] Bài 5: Loading States
- [x] Bài 6: Local Storage
- [x] Bài 7: Practice Projects

### Phase 6: Clean Architecture 🔄
- [ ] Bài 1: SOLID Principles
- [ ] Bài 2: Dependency Injection
- [ ] Bài 3: Repository Pattern
- [ ] Bài 4: Layers Architecture
- [ ] Bài 5: Error Handling
- [ ] Bài 6: Practice Projects

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

## ▶️ Bắt Đầu Phase 6!

1. Mở thư mục `06_clean_architecture`
2. Đọc file `README.md` trong đó
3. Chạy Flutter app:
```bash
cd 06_clean_architecture/clean_app
flutter run -d chrome
```

**Chúc bạn học tốt! 🎉**