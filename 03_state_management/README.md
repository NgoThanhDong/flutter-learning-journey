# Phase 3: State Management - README

## 🎯 Mục tiêu Phase 3

Sau khi hoàn thành, bạn sẽ:
- ✅ Hiểu State là gì, phân biệt Local vs Global State
- ✅ Thành thạo setState và biết giới hạn của nó
- ✅ Sử dụng Provider để quản lý state hiệu quả
- ✅ Áp dụng Riverpod - giải pháp hiện đại hơn
- ✅ Xây dựng app có state phức tạp (Shopping Cart, Notes App)

**Thời gian**: 2-3 tuần | **Môi trường**: Flutter Web (Chrome)

---

## 📚 Nội dung (6 bài học, 16 exercises)

| Bài | Chủ đề | File lý thuyết | Exercises |
|-----|--------|----------------|-----------|
| 1 | State Management Overview | [lesson_01_overview.md](lesson_01_overview.md) | 0 |
| 2 | setState & InheritedWidget | [lesson_02_setstate.md](lesson_02_setstate.md) | 3 |
| 3 | Provider Basics | [lesson_03_provider_basics.md](lesson_03_provider_basics.md) | 4 |
| 4 | Provider Advanced | [lesson_04_provider_advanced.md](lesson_04_provider_advanced.md) | 3 |
| 5 | Riverpod | [lesson_05_riverpod.md](lesson_05_riverpod.md) | 3 |
| 6 | Practice Projects | [lesson_06_practice.md](lesson_06_practice.md) | 3 |

---

## 🚀 Cách chạy Project

### 1. Cài dependencies
```bash
cd 03_state_management/state_app
flutter pub get
```

### 2. Chạy trên Chrome
```bash
flutter run -d chrome
```

### 3. Hot Reload
- Nhấn `r` để reload nhanh
- Nhấn `R` để restart hoàn toàn
- Nhấn `q` để thoát

---

## 📁 Cấu trúc

```
03_state_management/
├── 📄 README.md              ← Bạn đang đọc
│
├── 📖 Bài học (6 bài)
│   ├── lesson_01_overview.md
│   ├── lesson_02_setstate.md
│   ├── lesson_03_provider_basics.md
│   ├── lesson_04_provider_advanced.md
│   ├── lesson_05_riverpod.md
│   └── lesson_06_practice.md
│
├── 📂 state_app/             ← Flutter project
│   ├── lib/
│   │   ├── main.dart
│   │   └── exercises/        ← 16 bài tập
│   └── pubspec.yaml
│
└── 📂 screenshots/           ← Mô tả UI
```

---

## 📦 Dependencies sử dụng

| Package | Phiên bản | Mô tả |
|---------|-----------|-------|
| provider | ^6.1.5 | State management phổ biến nhất |
| flutter_riverpod | ^2.6.1 | Phiên bản cải tiến của Provider |

---

## ✅ Checklist hoàn thành

### Bài 1: Overview
- [ ] Hiểu State là gì (App State vs UI State)
- [ ] Biết vấn đề Prop Drilling
- [ ] So sánh được các giải pháp

### Bài 2: setState & InheritedWidget
- [ ] Ôn lại setState (từ Phase 2)
- [ ] Hiểu Lifting State Up
- [ ] Biết InheritedWidget là cơ sở của Provider

### Bài 3: Provider Basics
- [ ] Cài đặt và cấu hình Provider
- [ ] Tạo ChangeNotifier
- [ ] Sử dụng Consumer và context.watch/read

### Bài 4: Provider Advanced
- [ ] MultiProvider cho nhiều state
- [ ] Selector để tối ưu rebuild
- [ ] FutureProvider, StreamProvider

### Bài 5: Riverpod
- [ ] Hiểu tại sao dùng Riverpod
- [ ] StateProvider, StateNotifierProvider
- [ ] AsyncNotifier pattern

### Bài 6: Practice
- [ ] Xây dựng Shopping Cart
- [ ] Xây dựng Notes App
- [ ] Theme Switcher với persist

---

## ➡️ Tiếp theo

Sau Phase 3 → **Phase 4: Navigation & Routing** (GoRouter)
