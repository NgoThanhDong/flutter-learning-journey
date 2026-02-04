# Phase 5: API Integration 🌐

Học cách **gọi API** và **lưu trữ dữ liệu** trong Flutter.

---

## 🎯 Mục Tiêu

Sau phase này, bạn sẽ biết:
- ✅ Gọi REST API với `http` và `dio`
- ✅ Parse JSON thành Dart objects
- ✅ Xử lý Loading/Error/Success states
- ✅ Lưu dữ liệu với SharedPreferences và Hive
- ✅ Implement caching và offline support

---

## 📚 Nội Dung (7 Lessons)

| # | Lesson | Chủ đề |
|---|--------|--------|
| 1 | [Overview](lesson_01_overview.md) | REST API, HTTP methods, JSON |
| 2 | [http Package](lesson_02_http_package.md) | GET, POST requests |
| 3 | [JSON & Models](lesson_03_json_models.md) | fromJson/toJson pattern |
| 4 | [Dio Advanced](lesson_04_dio_advanced.md) | Interceptors, error handling |
| 5 | [Loading States](lesson_05_loading_states.md) | FutureBuilder, UI states |
| 6 | [Local Storage](lesson_06_local_storage.md) | SharedPreferences, Hive |
| 7 | [Practice](lesson_07_practice.md) | Real projects |

---

## 🛠️ Bài Tập (16 Exercises)

### HTTP Basics
| # | File | Mô tả |
|---|------|-------|
| 01 | `ex01_simple_get.dart` | GET request cơ bản |
| 02 | `ex02_json_parsing.dart` | Parse JSON response |
| 03 | `ex03_post_request.dart` | POST với body |
| 04 | `ex04_loading_states.dart` | FutureBuilder pattern |

### Models & Serialization
| # | File | Mô tả |
|---|------|-------|
| 05 | `ex05_model_class.dart` | Model với fromJson/toJson |
| 06 | `ex06_nested_json.dart` | Nested objects |
| 07 | `ex07_list_parsing.dart` | Parse list of objects |

### Dio & Advanced
| # | File | Mô tả |
|---|------|-------|
| 08 | `ex08_dio_basic.dart` | Dio setup |
| 09 | `ex09_dio_interceptors.dart` | Logging, auth interceptors |
| 10 | `ex10_error_handling.dart` | Error types & handling |
| 11 | `ex11_api_service.dart` | Repository pattern |

### Local Storage
| # | File | Mô tả |
|---|------|-------|
| 12 | `ex12_shared_prefs.dart` | SharedPreferences CRUD |
| 13 | `ex13_hive_basic.dart` | Hive operations |
| 14 | `ex14_offline_cache.dart` | Cache API responses |

### Practice Projects
| # | File | Mô tả |
|---|------|-------|
| 15 | `ex15_weather_app.dart` | Weather với Open-Meteo API |
| 16 | `ex16_todo_api.dart` | CRUD với JSONPlaceholder |

---

## 📦 Dependencies

```yaml
dependencies:
  http: ^1.2.0
  dio: ^5.4.0
  shared_preferences: ^2.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

---

## 🌐 Free APIs (Không cần API Key)

| API | URL | Mục đích |
|-----|-----|----------|
| JSONPlaceholder | `jsonplaceholder.typicode.com` | CRUD testing |
| Open-Meteo | `open-meteo.com` | Weather data |

---

## ▶️ Cách Chạy

```bash
cd 05_api_integration/api_app
flutter pub get
flutter run -d chrome
```

---

## 📁 Cấu Trúc

```
05_api_integration/
├── README.md
├── lesson_01_overview.md
├── lesson_02_http_package.md
├── lesson_03_json_models.md
├── lesson_04_dio_advanced.md
├── lesson_05_loading_states.md
├── lesson_06_local_storage.md
├── lesson_07_practice.md
└── api_app/
    ├── lib/
    │   ├── main.dart
    │   └── exercises/
    │       ├── ex01_simple_get.dart
    │       ├── ... (16 files)
    │       └── ex16_todo_api.dart
    ├── screenshots/
    └── pubspec.yaml
```
