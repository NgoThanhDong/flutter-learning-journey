# Phase 6: Clean Architecture 🏗️

## Mục Tiêu

Học cách tổ chức code Flutter theo Clean Architecture:
- **SOLID Principles** - 5 nguyên tắc thiết kế code
- **Dependency Injection** - Quản lý dependencies với get_it
- **Repository Pattern** - Tách biệt data sources
- **Layer Separation** - Data, Domain, Presentation
- **Error Handling** - Either pattern, Failure classes

---

## Nội Dung Học

### 📚 Lessons (6 bài)

| # | Bài học | Nội dung | Exercises |
|---|---------|----------|-----------|
| 1 | [SOLID Principles](lesson_01_solid_principles.md) | 5 nguyên tắc thiết kế OOP | ex01-ex05 |
| 2 | [Dependency Injection](lesson_02_dependency_injection.md) | get_it, Service Locator | ex06-ex08 |
| 3 | [Repository Pattern](lesson_03_repository_pattern.md) | Abstract repo, Data sources | ex09-ex11 |
| 4 | [Layers](lesson_04_layers.md) | Data/Domain/Presentation | ex12-ex14 |
| 5 | [Error Handling](lesson_05_error_handling.md) | Either, Failure classes | ex15-ex16 |
| 6 | [Practice](lesson_06_practice.md) | Mini projects tổng hợp | ex17-ex18 |

### 💻 Exercises (18 bài)

#### SOLID Principles
- `ex01_single_responsibility.dart` - Mỗi class chỉ làm 1 việc
- `ex02_open_closed.dart` - Mở rộng, không sửa đổi
- `ex03_liskov_substitution.dart` - Subtype thay thế được
- `ex04_interface_segregation.dart` - Interface nhỏ gọn
- `ex05_dependency_inversion.dart` - Phụ thuộc abstraction

#### Dependency Injection
- `ex06_manual_di.dart` - Constructor Injection thủ công
- `ex07_get_it_basic.dart` - get_it cơ bản
- `ex08_get_it_lazy.dart` - Lazy registration

#### Repository Pattern
- `ex09_repository_interface.dart` - Abstract repository
- `ex10_local_remote_source.dart` - Multiple data sources
- `ex11_repository_impl.dart` - Repository implementation

#### Layer Architecture
- `ex12_domain_entities.dart` - Entities và Value Objects
- `ex13_use_cases.dart` - Use Cases
- `ex14_presentation_viewmodel.dart` - ViewModel pattern

#### Error Handling
- `ex15_either_result.dart` - Either pattern
- `ex16_failure_classes.dart` - Custom Failure classes

#### Practice Projects
- `ex17_notes_app_clean.dart` - Notes App
- `ex18_user_profile_clean.dart` - User Profile CRUD

---

## Dependencies

```yaml
dependencies:
  get_it: ^8.0.0        # Dependency Injection
  fpdart: ^1.1.0        # Functional programming (Either)
  equatable: ^2.0.5     # Value equality
  dio: ^5.4.0           # HTTP client
  shared_preferences: ^2.2.0
```

---

## Chạy App

```bash
cd 06_clean_architecture/clean_app
flutter pub get
flutter run -d chrome
```

---

## Clean Architecture Overview

```
┌─────────────────────────────────────────────┐
│            PRESENTATION LAYER               │
│  • Widgets (UI)                             │
│  • ViewModels / Controllers                 │
│  • BLoC / Provider / Riverpod               │
├─────────────────────────────────────────────┤
│              DOMAIN LAYER                   │
│  • Entities (Business objects)              │
│  • Use Cases (Business logic)               │
│  • Repository Interfaces                    │
├─────────────────────────────────────────────┤
│               DATA LAYER                    │
│  • Models (JSON mapping)                    │
│  • Data Sources (API, Local DB)             │
│  • Repository Implementations               │
└─────────────────────────────────────────────┘
```

**Dependency Rule**: Outer layers depend on inner layers, never the reverse!

---

## Cấu Trúc Thư Mục

```
06_clean_architecture/
├── README.md                      ← Bạn đang đọc
├── lesson_01_solid_principles.md
├── lesson_02_dependency_injection.md
├── lesson_03_repository_pattern.md
├── lesson_04_layers.md
├── lesson_05_error_handling.md
├── lesson_06_practice.md
│
├── screenshots/
│   └── README.md
│
└── clean_app/
    ├── lib/
    │   ├── main.dart
    │   └── exercises/
    │       └── (18 exercise files)
    └── pubspec.yaml
```

---

## Tại Sao Cần Clean Architecture?

| Vấn đề | Giải pháp Clean Architecture |
|--------|------------------------------|
| Code khó test | Tách biệt layers, dùng interfaces |
| Thay đổi 1 chỗ vỡ nhiều chỗ | SOLID principles |
| Khó thay đổi database/API | Repository pattern |
| Business logic rải rác | Use Cases tập trung |
| Error handling lộn xộn | Either/Result pattern |

---

## Bài Tiếp Theo

➡️ [Lesson 1: SOLID Principles](lesson_01_solid_principles.md)
