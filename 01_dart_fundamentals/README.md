# Phase 1: Dart Fundamentals - README

## 📚 Nội dung

| Bài | Chủ đề | File lý thuyết | File code |
|-----|--------|----------------|-----------|
| 1 | Cơ bản: Variables, Null Safety, Functions | [lesson_01_basics.md](lesson_01_basics.md) | [lesson_01_examples.dart](lesson_01_examples.dart) |
| 2 | OOP: Class, Inheritance, Interface, Mixins | [lesson_02_oop.md](lesson_02_oop.md) | [lesson_02_examples.dart](lesson_02_examples.dart), [lesson_02b_interface.dart](lesson_02b_interface.dart) |
| 3 | Async: Future, Stream, async/await | [lesson_03_async.md](lesson_03_async.md) | [lesson_03_examples.dart](lesson_03_examples.dart) |

## 🏋️ Bài tập

Folder `exercises/` chứa các bài tập có auto-check:

```
exercises/
│
├── 📝 Bài 1 (Cơ bản):
│   ├── exercise_01_variables.dart      # Khai báo biến
│   ├── exercise_02_null_safety.dart    # Null Safety
│   └── exercise_03_named_params.dart   # Named Parameters
│
├── 📝 Bài 2 (OOP):
│   ├── exercise_04_product.dart        # Class Product với named constructor
│   ├── exercise_05_employee.dart       # Inheritance hệ thống nhân viên
│   └── exercise_06_extension.dart      # Extension cho DateTime
│
└── 📝 Bài 3 (Async):
    ├── exercise_07_future.dart             # Future cơ bản
    ├── exercise_08_multiple_futures.dart   # Future.wait (chạy song song)
    ├── exercise_09_stream.dart             # Tạo Stream với async*/yield
    └── exercise_10_stream_controller.dart  # StreamController
```

## 🚀 Cách học

### 1. Đọc lý thuyết
Mở file `.md` để đọc giải thích chi tiết.

### 2. Chạy ví dụ
```bash
dart run lesson_01_examples.dart
dart run lesson_02_examples.dart
dart run lesson_03_examples.dart
```

### 3. Làm bài tập
```bash
cd exercises
dart run exercise_01_variables.dart
```

## ✅ Checklist hoàn thành Phase 1

- [ ] **Bài 1**: Biến, Null Safety, Functions
  - [ ] Hiểu var, final, const
  - [ ] Hiểu ?, !, ??
  - [ ] Viết được function với named params
  - [ ] Hoàn thành exercise_01, 02, 03
  
- [ ] **Bài 2**: OOP
  - [ ] Hiểu các loại constructor
  - [ ] Hiểu inheritance và @override
  - [ ] Hiểu abstract class và interface
  - [ ] Hiểu mixins và extension
  - [ ] Hoàn thành exercise_04, 05, 06
  
- [ ] **Bài 3**: Async
  - [ ] Hiểu Future và async/await
  - [ ] Hiểu Future.wait (chạy song song)
  - [ ] Hiểu Stream và yield
  - [ ] Hiểu StreamController
  - [ ] Hoàn thành exercise_07, 08, 09, 10

## ➡️ Tiếp theo

Sau khi hoàn thành Phase 1, chuyển sang **Phase 2: Flutter Basics & Widget System**!
