# Phase 7: BLoC Pattern

> 📖 Học State Management **chuyên nghiệp** với BLoC/Cubit - Pattern được sử dụng nhiều nhất trong các dự án Flutter thực tế.

---

## 🎯 Mục Tiêu Phase Này

Sau khi hoàn thành Phase 7, bạn sẽ:

- ✅ Hiểu **Streams** - nền tảng của BLoC
- ✅ Biết cách dùng **Cubit** - phiên bản đơn giản của BLoC
- ✅ Thành thạo **BLoC Pattern** - Events, States, Handlers
- ✅ Sử dụng các **BLoC Widgets** - Builder, Listener, Consumer, Selector
- ✅ Áp dụng **Architecture** - Repository pattern, Dependency Injection

---

## 🤔 BLoC Là Gì?

**BLoC** = **B**usiness **Lo**gic **C**omponent

### Tại sao cần BLoC?

| Vấn đề với setState | Giải pháp với BLoC |
|---------------------|---------------------|
| Logic lẫn trong UI | Logic tách riêng trong BLoC class |
| Khó test | BLoC dễ unit test vì không phụ thuộc UI |
| State khó manage khi app lớn | State có cấu trúc rõ ràng |
| Rebuild toàn bộ widget | Chỉ rebuild widget cần thiết |

### BLoC vs Cubit

```
┌─────────────────────────────────────────────────────────┐
│                        CUBIT                            │
│  Đơn giản hơn, gọi method trực tiếp                     │
│  Button → cubit.increment() → emit(newState)            │
│  👉 Dùng khi: Logic đơn giản, ít trường hợp             │
├─────────────────────────────────────────────────────────┤
│                        BLOC                             │
│  Có Event làm trung gian                                │
│  Button → bloc.add(IncrementEvent) → Handler → emit()   │
│  👉 Dùng khi: Logic phức tạp, cần log/debug events      │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Lessons (5 Bài Học)

### Thứ tự học:

| # | Bài học | Nội dung | Bạn sẽ học được |
|---|---------|----------|-----------------|
| 1 | [Streams Foundation](./lesson_01_streams.md) | StreamController, Operators, StreamBuilder | Hiểu cách data "chảy" trong app |
| 2 | [Cubit Basics](./lesson_02_cubit.md) | Cubit, emit(), BlocProvider, BlocBuilder | Tạo state management đầu tiên |
| 3 | [BLoC Pattern](./lesson_03_bloc.md) | Events, States, Handlers, sealed classes | Xây dựng BLoC hoàn chỉnh |
| 4 | [BLoC Widgets](./lesson_04_widgets.md) | Builder, Listener, Consumer, Selector | Kết nối BLoC với UI |
| 5 | [Architecture & DI](./lesson_05_architecture.md) | Repository, get_it, Testing | Cấu trúc code chuyên nghiệp |

> 💡 **Tip**: Đọc bài học TRƯỚC, sau đó làm exercises tương ứng

---

## 💻 Exercises (17 Bài Tập)

Mỗi bài tập có **comments chi tiết** giải thích từng dòng code.

### 📘 Lesson 1: Streams (Ex01-03)

| # | Tên | Mô tả | Khái niệm chính |
|---|-----|-------|-----------------|
| 01 | Stream Controller | Tạo và sử dụng stream cơ bản | `StreamController`, `sink.add()`, `stream.listen()` |
| 02 | Stream Transformations | Biến đổi data trong stream | `map`, `where`, `distinct` |
| 03 | StreamBuilder Widget | Hiển thị stream data lên UI | `StreamBuilder`, `AsyncSnapshot` |

### 📗 Lesson 2: Cubit (Ex04-06)

| # | Tên | Mô tả | Khái niệm chính |
|---|-----|-------|-----------------|
| 04 | Counter Cubit | Counter đơn giản với Cubit | `Cubit<int>`, `emit()`, `BlocBuilder` |
| 05 | Theme Cubit | Quản lý ThemeMode toàn app | App-wide state, `context.watch` |
| 06 | Timer Cubit | Timer với nhiều trạng thái | `Equatable`, `copyWith`, complex state |

### 📙 Lesson 3: BLoC (Ex07-10)

| # | Tên | Mô tả | Khái niệm chính |
|---|-----|-------|-----------------|
| 07 | Counter BLoC | Counter với Events | `on<Event>`, `add(Event)`, handler |
| 08 | Auth BLoC | Login flow với nhiều states | `sealed class`, pattern matching |
| 09 | Form Validation | Validate form reactive | Real-time validation, multiple fields |
| 10 | BlocObserver | Debug và logging toàn app | Global observer, `onCreate`, `onChange` |

### 📕 Lesson 4: BLoC Widgets (Ex11-14)

| # | Tên | Mô tả | Khái niệm chính |
|---|-----|-------|-----------------|
| 11 | BlocBuilder | Rebuild UI khi state đổi | `buildWhen` optimization |
| 12 | BlocListener | Side effects (SnackBar, Navigate) | `listenWhen`, không rebuild UI |
| 13 | BlocConsumer | Builder + Listener kết hợp | Khi cần cả UI và side effects |
| 14 | BlocSelector | Chỉ rebuild khi 1 phần state đổi | `selector`, performance |

### 📓 Lesson 5: Architecture (Ex15-17)

| # | Tên | Mô tả | Khái niệm chính |
|---|-----|-------|-----------------|
| 15 | Todo App | CRUD hoàn chỉnh với Cubit | Thực hành tổng hợp |
| 16 | Weather App | Gọi API với Repository | Repository pattern, `RepositoryProvider` |
| 17 | User CRUD | Dependency Injection | `get_it`, `registerFactory`, `registerSingleton` |

---

## 🚀 Cách Chạy

### Bước 1: Vào thư mục project
```bash
cd 07_bloc_pattern/bloc_app
```

### Bước 2: Cài dependencies
```bash
flutter pub get
```

### Bước 3: Chạy app
```bash
flutter run -d chrome
```

### Bước 4: Chọn exercise từ menu

App sẽ hiển thị danh sách 17 exercises, nhấn vào để xem từng exercise.

---

## 📦 Dependencies

File `pubspec.yaml` sử dụng các packages:

| Package | Mô tả |
|---------|-------|
| `flutter_bloc` | Core package cho BLoC và Cubit |
| `equatable` | So sánh objects bằng props (cho States) |
| `get_it` | Dependency Injection container |

---

## 🗂️ Cấu Trúc Thư Mục

```
07_bloc_pattern/
│
├── 📄 README.md                      ← Bạn đang đọc file này
│
├── 📖 LESSONS (Lý thuyết)
│   ├── lesson_01_streams.md          ← Stream cơ bản
│   ├── lesson_02_cubit.md            ← Cubit
│   ├── lesson_03_bloc.md             ← BLoC pattern
│   ├── lesson_04_widgets.md          ← BLoC widgets
│   └── lesson_05_architecture.md     ← Architecture
│
└── 📂 bloc_app/                      ← Flutter Project
    ├── lib/
    │   ├── main.dart                 ← Menu navigation
    │   └── exercises/                ← 17 bài tập
    │       ├── ex01_stream_controller.dart
    │       ├── ex02_stream_transformations.dart
    │       ├── ex03_stream_builder_widget.dart
    │       ├── ex04_counter_cubit.dart
    │       ├── ex05_theme_cubit.dart
    │       ├── ex06_timer_cubit.dart
    │       ├── ex07_counter_bloc.dart
    │       ├── ex08_auth_bloc.dart
    │       ├── ex09_form_validation_bloc.dart
    │       ├── ex10_bloc_observer.dart
    │       ├── ex11_bloc_builder.dart
    │       ├── ex12_bloc_listener.dart
    │       ├── ex13_bloc_consumer.dart
    │       ├── ex14_bloc_selector.dart
    │       ├── ex15_todo_app.dart
    │       ├── ex16_weather_app.dart
    │       └── ex17_user_crud.dart
    │
    └── pubspec.yaml                  ← flutter_bloc, equatable, get_it
```

---

## 💡 Tips Cho Người Mới

### 1. Học theo thứ tự
```
Streams → Cubit → BLoC → Widgets → Architecture
```
Đừng nhảy cóc! Streams là nền tảng của BLoC.

### 2. Đọc comments trong code
Mỗi file exercise có comments chi tiết giải thích:
- Tại sao dùng cách này
- Ý nghĩa từng dòng code
- Best practices

### 3. Cubit trước, BLoC sau
Nếu bạn mới học, hãy dùng **Cubit** cho các use case đơn giản. Chỉ dùng BLoC khi cần Events để log/debug.

### 4. Context.read vs Context.watch
```dart
// Trong callback (onPressed, onTap) → dùng read
onPressed: () => context.read<CounterCubit>().increment()

// Trong build method để theo dõi → dùng watch
final state = context.watch<CounterCubit>().state;
```

---

## ❓ FAQ

### Q: BLoC có phức tạp không?
**A**: Ban đầu có vẻ phức tạp, nhưng khi quen rồi bạn sẽ thấy nó rất có cấu trúc. Hãy bắt đầu với Cubit trước!

### Q: Khi nào dùng Cubit, khi nào dùng BLoC?
**A**: 
- **Cubit**: Counter, Toggle, Form đơn giản
- **BLoC**: Auth flow, API calls phức tạp, cần log events

### Q: Tại sao cần Equatable?
**A**: Để so sánh 2 state objects. Không có Equatable, mỗi state emit sẽ được coi là khác nhau dù data giống nhau.

---

## ▶️ Bắt Đầu Ngay!

1. Mở file [lesson_01_streams.md](./lesson_01_streams.md)
2. Đọc hiểu lý thuyết về Streams
3. Chạy app và thử Exercise 01-03

**Chúc bạn học tốt! 🎉**
