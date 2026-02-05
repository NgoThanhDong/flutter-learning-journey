# Phase 8: Real Projects

> 🚀 Xây dựng **ứng dụng thực tế** từ đầu đến cuối - Tổng hợp tất cả kiến thức từ Phase 1-7

---

## 🎯 Mục Tiêu Phase Này

Phase 8 khác biệt với các phase trước - thay vì học từng khái niệm riêng lẻ, bạn sẽ **xây dựng các ứng dụng hoàn chỉnh** từ đầu đến cuối.

Sau khi hoàn thành Phase 8, bạn sẽ có:

- ✅ **4 ứng dụng hoàn chỉnh** trong portfolio
- ✅ Kinh nghiệm **thiết kế architecture** thực tế
- ✅ Hiểu cách **tổ chức code** cho dự án lớn
- ✅ Biết cách **kết hợp tất cả kiến thức** đã học
- ✅ Sẵn sàng **phỏng vấn** và làm việc thực tế

---

## 📚 Kiến Thức Tổng Hợp

Mỗi project trong Phase 8 sẽ sử dụng kiến thức từ tất cả các phase trước:

| Phase | Kiến thức | Áp dụng trong Phase 8 |
|-------|-----------|------------------------|
| 1 | **Dart** | Models, null safety, async/await |
| 2 | **Flutter Basics** | Widgets, Layout, Styling |
| 3 | **State Management** | Provider pattern trong apps |
| 4 | **Navigation** | go_router, deep linking |
| 5 | **API Integration** | HTTP calls, JSON parsing |
| 6 | **Clean Architecture** | Repository pattern, DI |
| 7 | **BLoC Pattern** | Cubit/BLoC cho state |

---

## 🏗️ 4 Projects

### 📝 Project 1: Notes App (Ex01-05)
**Ứng dụng ghi chú** với đầy đủ tính năng CRUD

| Tính năng | Kiến thức áp dụng |
|-----------|-------------------|
| Tạo/Sửa/Xóa note | CRUD operations |
| Tìm kiếm notes | Search & Filter |
| Phân loại màu sắc | UI/UX design |
| Lưu trữ local | Local Storage |
| State management | Cubit pattern |

**Bạn sẽ học:**
- Thiết kế data model
- Quản lý list state với Cubit
- Local storage với SharedPreferences
- Search và filter functionality
- Material Design 3 UI

---

### 🌦️ Project 2: Weather App (Ex06-10)
**Ứng dụng thời tiết** với API thực tế

| Tính năng | Kiến thức áp dụng |
|-----------|-------------------|
| Hiển thị thời tiết | API Integration |
| Tìm kiếm thành phố | Search functionality |
| Loading states | UX patterns |
| Error handling | Error states |
| Caching | Performance |

**Bạn sẽ học:**
- Repository pattern với API
- BLoC với loading/error states
- Dependency Injection với get_it
- Xử lý network errors
- Beautiful weather UI

---

### 🛒 Project 3: Shopping App (Ex11-15)
**Ứng dụng mua sắm** với giỏ hàng

| Tính năng | Kiến thức áp dụng |
|-----------|-------------------|
| Danh sách sản phẩm | GridView, Cards |
| Giỏ hàng | Cart state management |
| Tính tổng tiền | Computed values |
| Checkout flow | Multi-screen flow |
| Responsive UI | Adaptive layout |

**Bạn sẽ học:**
- Product listing với GridView
- Cart management với Cubit
- Price calculations
- Checkout UX patterns
- Badge notifications

---

### 💼 Project 4: Portfolio App (Ex16-20)
**Portfolio cá nhân** - Dự án cuối khóa

| Tính năng | Kiến thức áp dụng |
|-----------|-------------------|
| Trang giới thiệu | Hero sections |
| Skills showcase | Animations |
| Projects gallery | Image gallery |
| Contact form | Form validation |
| Responsive design | Web-ready UI |

**Bạn sẽ học:**
- Single-page app design
- Smooth scrolling & animations
- Responsive breakpoints
- Contact form với validation
- Deploy-ready portfolio

---

## 📖 Lessons (5 bài học chi tiết)

| # | Bài học | Nội dung |
|---|---------|----------|
| 1 | [Project Overview](./lesson_01_project_overview.md) | Cách tổ chức code, folder structure, project planning |
| 2 | [Notes App](./lesson_02_notes_app.md) | Xây dựng Notes App từ A-Z với Ex01-05 |
| 3 | [Weather App](./lesson_03_weather_app.md) | Xây dựng Weather App với API - Ex06-10 |
| 4 | [Shopping App](./lesson_04_shopping_app.md) | Xây dựng Shopping App - Ex11-15 |
| 5 | [Portfolio App](./lesson_05_portfolio_app.md) | Xây dựng Portfolio App - Ex16-20 |

---

## 💻 Exercises (20 bài tập)

Mỗi bài tập có **comments cực kỳ chi tiết** giải thích từng dòng code.

### 📝 Project 1: Notes App

| # | File | Mô tả |
|---|------|-------|
| 01 | `ex01_note_model.dart` | Data model cho Note |
| 02 | `ex02_notes_cubit.dart` | State management với Cubit |
| 03 | `ex03_notes_list_screen.dart` | Màn hình danh sách notes |
| 04 | `ex04_note_editor_screen.dart` | Màn hình tạo/sửa note |
| 05 | `ex05_notes_app_complete.dart` | App Notes hoàn chỉnh |

### 🌦️ Project 2: Weather App

| # | File | Mô tả |
|---|------|-------|
| 06 | `ex06_weather_model.dart` | Data models cho Weather |
| 07 | `ex07_weather_repository.dart` | Repository + API integration |
| 08 | `ex08_weather_bloc.dart` | BLoC với loading/error states |
| 09 | `ex09_weather_ui.dart` | UI components cho Weather |
| 10 | `ex10_weather_app_complete.dart` | App Weather hoàn chỉnh |

### 🛒 Project 3: Shopping App

| # | File | Mô tả |
|---|------|-------|
| 11 | `ex11_product_model.dart` | Data models cho Product/Cart |
| 12 | `ex12_cart_cubit.dart` | Cart state management |
| 13 | `ex13_product_list_screen.dart` | Màn hình danh sách sản phẩm |
| 14 | `ex14_cart_screen.dart` | Màn hình giỏ hàng |
| 15 | `ex15_shopping_app_complete.dart` | App Shopping hoàn chỉnh |

### 💼 Project 4: Portfolio App

| # | File | Mô tả |
|---|------|-------|
| 16 | `ex16_portfolio_models.dart` | Data models cho Portfolio |
| 17 | `ex17_portfolio_navigation.dart` | Navigation với go_router |
| 18 | `ex18_portfolio_home.dart` | Hero section + About |
| 19 | `ex19_portfolio_sections.dart` | Skills, Projects, Contact |
| 20 | `ex20_portfolio_app_complete.dart` | App Portfolio hoàn chỉnh |

---

## 🚀 Cách Chạy

### Bước 1: Vào thư mục project
```bash
cd 08_real_projects/projects_app
```

### Bước 2: Cài dependencies
```bash
flutter pub get
```

### Bước 3: Chạy app
```bash
flutter run -d chrome
```

### Bước 4: Chọn project từ menu

App sẽ hiển thị danh sách 4 projects, mỗi project có 5 exercises.

---

## 📦 Dependencies

| Package | Mô tả | Dùng cho |
|---------|-------|----------|
| `flutter_bloc` | BLoC/Cubit | State management |
| `equatable` | Object comparison | State comparison |
| `get_it` | Dependency Injection | Service locator |
| `http` | HTTP client | API calls |
| `shared_preferences` | Local storage | Notes storage |
| `go_router` | Navigation | Portfolio routing |
| `google_fonts` | Typography | Beautiful fonts |
| `cached_network_image` | Image caching | Product images |
| `shimmer` | Loading skeleton | UX loading states |
| `intl` | Formatting | Date/Currency format |
| `uuid` | Unique IDs | Generate note IDs |

---

## 🗂️ Cấu Trúc Thư Mục

```
08_real_projects/
│
├── 📄 README.md                      ← Bạn đang đọc file này
│
├── 📖 LESSONS (Lý thuyết chi tiết)
│   ├── lesson_01_project_overview.md
│   ├── lesson_02_notes_app.md
│   ├── lesson_03_weather_app.md
│   ├── lesson_04_shopping_app.md
│   └── lesson_05_portfolio_app.md
│
└── 📂 screenshots/
│        └── README.md
│
└── 📂 projects_app/                  ← Flutter Project
    ├── lib/
    │   ├── main.dart                 ← Menu navigation
    │   └── projects/                 ← 20 bài tập
    │       │
    │       ├── 📝 NOTES APP (Ex01-05)
    │       │   ├── ex01_note_model.dart
    │       │   ├── ex02_notes_cubit.dart
    │       │   ├── ex03_notes_list_screen.dart
    │       │   ├── ex04_note_editor_screen.dart
    │       │   └── ex05_notes_app_complete.dart
    │       │
    │       ├── 🌦️ WEATHER APP (Ex06-10)
    │       │   ├── ex06_weather_model.dart
    │       │   ├── ex07_weather_repository.dart
    │       │   ├── ex08_weather_bloc.dart
    │       │   ├── ex09_weather_ui.dart
    │       │   └── ex10_weather_app_complete.dart
    │       │
    │       ├── 🛒 SHOPPING APP (Ex11-15)
    │       │   ├── ex11_product_model.dart
    │       │   ├── ex12_cart_cubit.dart
    │       │   ├── ex13_product_list_screen.dart
    │       │   ├── ex14_cart_screen.dart
    │       │   └── ex15_shopping_app_complete.dart
    │       │
    │       └── 💼 PORTFOLIO APP (Ex16-20)
    │           ├── ex16_portfolio_models.dart
    │           ├── ex17_portfolio_navigation.dart
    │           ├── ex18_portfolio_home.dart
    │           ├── ex19_portfolio_sections.dart
    │           └── ex20_portfolio_app_complete.dart
    │
    └── pubspec.yaml
```

---

## 💡 Cách Học Hiệu Quả

### 1. Đọc lesson TRƯỚC, code SAU
```
lesson_02_notes_app.md → Ex01 → Ex02 → Ex03 → Ex04 → Ex05
```

### 2. Thực hành từng bước
Không copy toàn bộ code! Hãy:
- Đọc comments để hiểu
- Gõ code từng dòng
- Chạy thử từng phần

### 3. Hỏi khi không hiểu
Mỗi file có comments giải thích chi tiết. Nếu vẫn chưa rõ, hãy hỏi!

### 4. Customize projects
Sau khi hoàn thành mỗi project, thử thêm tính năng mới của riêng bạn.

---

## ❓ FAQ

### Q: Tôi nên bắt đầu từ project nào?
**A**: Notes App (Project 1) - đơn giản nhất, tập trung vào CRUD cơ bản.

### Q: Bao lâu để hoàn thành Phase 8?
**A**: 4-8 tuần tùy theo tốc độ học. Mỗi project khoảng 1-2 tuần.

### Q: Tôi có thể dùng các project này trong portfolio thực sự không?
**A**: Có! Đó chính là mục đích của Phase 8. Hãy customize và thêm tính năng riêng.

---

## ▶️ Bắt Đầu Ngay!

1. Mở file [lesson_01_project_overview.md](./lesson_01_project_overview.md)
2. Hiểu cách tổ chức project
3. Bắt đầu với Notes App (Ex01-05)

**Chúc bạn hoàn thành xuất sắc Phase cuối cùng! 🎉**
