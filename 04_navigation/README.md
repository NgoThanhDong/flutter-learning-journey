# Phase 4: Navigation 🧭

Học cách điều hướng (navigation) trong Flutter - từ cơ bản đến nâng cao với go_router.

---

## 🎯 Mục tiêu

Sau phase này, bạn sẽ:
- ✅ Hiểu Navigator stack và cách push/pop screens
- ✅ Sử dụng Named Routes và truyền arguments
- ✅ Thành thạo **go_router** - thư viện routing được khuyến nghị
- ✅ Implement Deep Linking cho Flutter Web
- ✅ Xây dựng Authentication flow với Route Guards

---

## 📚 Nội dung (7 Lessons + 18 Exercises)

### Lessons

| # | Bài học | Nội dung chính |
|---|---------|----------------|
| 1 | [Overview](lesson_01_overview.md) | Navigation stack, push/pop concept |
| 2 | [Basic Navigation](lesson_02_basic_navigation.md) | MaterialPageRoute, passing data |
| 3 | [Named Routes](lesson_03_named_routes.md) | Routes map, onGenerateRoute |
| 4 | [go_router Intro](lesson_04_go_router_intro.md) | GoRouter setup, path parameters |
| 5 | [go_router Advanced](lesson_05_go_router_advanced.md) | Nested routes, ShellRoute, redirects |
| 6 | [Deep Linking](lesson_06_deep_linking.md) | URL handling, pathUrlStrategy |
| 7 | [Practice Projects](lesson_07_practice.md) | Complete app navigation |

### Exercises

#### 📦 Phần 1: Navigator Basics (Ex01-05)
| # | File | Mô tả |
|---|------|-------|
| 1 | `ex01_push_pop.dart` | Cơ bản push/pop giữa 2 screens |
| 2 | `ex02_push_replacement.dart` | pushReplacement - thay thế screen |
| 3 | `ex03_push_and_remove.dart` | pushAndRemoveUntil - clear stack |
| 4 | `ex04_pass_data.dart` | Truyền data qua constructor |
| 5 | `ex05_return_data.dart` | Pop với kết quả về |

#### 🏷️ Phần 2: Named Routes (Ex06-08)
| # | File | Mô tả |
|---|------|-------|
| 6 | `ex06_named_routes.dart` | Định nghĩa named routes |
| 7 | `ex07_route_arguments.dart` | Truyền arguments với ModalRoute |
| 8 | `ex08_on_generate_route.dart` | Dynamic route generation |

#### 🚀 Phần 3: go_router (Ex09-14)
| # | File | Mô tả |
|---|------|-------|
| 9 | `ex09_go_router_basic.dart` | GoRouter setup cơ bản |
| 10 | `ex10_path_parameters.dart` | Path params (/user/:id) |
| 11 | `ex11_query_parameters.dart` | Query params (?search=abc) |
| 12 | `ex12_nested_routes.dart` | Sub-routes và ShellRoute |
| 13 | `ex13_redirect_guard.dart` | Auth guard, redirect logic |
| 14 | `ex14_error_handling.dart` | 404 page, error routes |

#### 🎯 Phần 4: Practice Projects (Ex15-18)
| # | File | Mô tả |
|---|------|-------|
| 15 | `ex15_bottom_nav_router.dart` | Bottom Navigation với go_router |
| 16 | `ex16_auth_flow.dart` | Login/Logout flow với guards |
| 17 | `ex17_ecommerce_routes.dart` | E-commerce navigation |
| 18 | `ex18_deep_link_demo.dart` | Deep linking demo |

---

## 🚀 Chạy Project

```bash
cd 04_navigation/nav_app
flutter pub get
flutter run -d chrome
```

---

## 📦 Dependencies

```yaml
dependencies:
  go_router: ^14.3.0
```

---

## 📂 Cấu trúc thư mục

```
04_navigation/
├── README.md                    ← Bạn đang đọc file này
├── lesson_01_overview.md
├── lesson_02_basic_navigation.md
├── lesson_03_named_routes.md
├── lesson_04_go_router_intro.md
├── lesson_05_go_router_advanced.md
├── lesson_06_deep_linking.md
├── lesson_07_practice.md
├── screenshots/                ← ảnh chụp UI của 18 bài tập
│   └── README.md
└── nav_app/
    ├── lib/
    │   ├── main.dart
    │   └── exercises/           ← 18 bài tập
    └── pubspec.yaml
```

---

## ✅ Checklist hoàn thành

### Lessons
- [ ] Đọc lesson_01: Navigation Overview
- [ ] Đọc lesson_02: Basic Navigation
- [ ] Đọc lesson_03: Named Routes
- [ ] Đọc lesson_04: go_router Intro
- [ ] Đọc lesson_05: go_router Advanced
- [ ] Đọc lesson_06: Deep Linking
- [ ] Đọc lesson_07: Practice Projects

### Exercises
- [ ] Ex01-05: Navigator Basics
- [ ] Ex06-08: Named Routes
- [ ] Ex09-14: go_router
- [ ] Ex15-18: Practice Projects

---

## ▶️ Bước tiếp theo

Sau khi hoàn thành Phase 4, bạn sẽ chuyển sang:
- **Phase 5: API & Data** - REST API, Local Storage, HTTP requests
