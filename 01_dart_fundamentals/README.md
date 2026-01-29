# Phase 1: Dart Fundamentals - README

## 📚 Nội dung

| Bài | Chủ đề | File lý thuyết | File code |
|-----|--------|----------------|-----------|
| 1 | Cơ bản: Variables, Null Safety, Functions | [lesson_01_basics.md](lesson_01_basics.md) | [lesson_01_examples.dart](lesson_01_examples.dart) |
| 2 | OOP: Class, Inheritance, Interface, Mixins | [lesson_02_oop.md](lesson_02_oop.md) | [lesson_02_examples.dart](lesson_02_examples.dart), [lesson_02b_interface.dart](lesson_02b_interface.dart) |
| 3 | Async: Future, Stream, async/await | [lesson_03_async.md](lesson_03_async.md) | [lesson_03_examples.dart](lesson_03_examples.dart) |
| 4 | Collections: List, Map, Set, Generics | [lesson_04_collections.md](lesson_04_collections.md) | [lesson_04_examples.dart](lesson_04_examples.dart) |
| 5 | Enums & Error Handling | [lesson_05_enums_errors.md](lesson_05_enums_errors.md) | [lesson_05_examples.dart](lesson_05_examples.dart) |

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
│   ├── exercise_04_product.dart        # Class Product
│   ├── exercise_05_employee.dart       # Inheritance
│   └── exercise_06_extension.dart      # Extension
│
├── 📝 Bài 3 (Async):
│   ├── exercise_07_future.dart         # Future cơ bản
│   ├── exercise_08_multiple_futures.dart # Future.wait
│   ├── exercise_09_stream.dart         # Stream
│   └── exercise_10_stream_controller.dart # StreamController
│
├── 📝 Bài 4 (Collections):
│   ├── exercise_11_list.dart           # Thao tác List
│   ├── exercise_12_map.dart            # Thao tác Map (JSON)
│   └── exercise_13_higher_order.dart   # map, where, fold
│
└── 📝 Bài 5 (Enums & Errors):
    ├── exercise_14_enum.dart           # Enum cơ bản & enhanced
    └── exercise_15_error_handling.dart # try-catch, custom exception
```

## 🚀 Cách học

### 1. Đọc lý thuyết
Mở file `.md` để đọc giải thích chi tiết.

### 2. Chạy ví dụ
```bash
dart run lesson_01_examples.dart
dart run lesson_02_examples.dart
dart run lesson_03_examples.dart
dart run lesson_04_examples.dart
dart run lesson_05_examples.dart
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
  - [ ] Hoàn thành exercise 01, 02, 03
  
- [ ] **Bài 2**: OOP
  - [ ] Hiểu các loại constructor
  - [ ] Hiểu inheritance và @override
  - [ ] Hiểu abstract class, interface, mixins
  - [ ] Hoàn thành exercise 04, 05, 06
  
- [ ] **Bài 3**: Async
  - [ ] Hiểu Future và async/await
  - [ ] Hiểu Future.wait
  - [ ] Hiểu Stream và yield
  - [ ] Hiểu StreamController
  - [ ] Hoàn thành exercise 07, 08, 09, 10
  
- [ ] **Bài 4**: Collections
  - [ ] Thao tác List, Map, Set
  - [ ] Hiểu Generics
  - [ ] Sử dụng map(), where(), fold()
  - [ ] Hoàn thành exercise 11, 12, 13
  
- [ ] **Bài 5**: Enums & Error Handling
  - [ ] Hiểu Enum và Enhanced Enum
  - [ ] Sử dụng try-catch-finally
  - [ ] Tạo Custom Exception
  - [ ] Hoàn thành exercise 14, 15

## ➡️ Tiếp theo

Sau khi hoàn thành Phase 1, chuyển sang **Phase 2: Flutter Basics & Widget System**!
