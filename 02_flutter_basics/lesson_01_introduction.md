# Bài 1: Flutter Introduction & Project Structure

## 🎯 Mục tiêu
- Hiểu Flutter là gì và tại sao nên học Flutter
- Nắm vững cấu trúc project Flutter
- Chạy được app đầu tiên trên Chrome
- Hiểu luồng chạy của ứng dụng Flutter

---

## 1. Flutter Là Gì?

### 1.1 Định nghĩa

**Flutter** là UI toolkit của Google để xây dựng ứng dụng:
- 📱 Mobile (iOS, Android)
- 🖥️ Desktop (Windows, macOS, Linux)
- 🌐 Web
- 📺 Embedded devices

Từ **1 codebase duy nhất**!

### 1.2 Tại sao chọn Flutter?

| Ưu điểm | Giải thích |
|---------|------------|
| **Hot Reload** | Thay đổi code → thấy kết quả ngay lập tức |
| **Cross-platform** | 1 code chạy được nhiều nền tảng |
| **Beautiful UI** | Widget phong phú, dễ customize |
| **Performance** | Compile native, không qua bridge |
| **Growing community** | Hỗ trợ mạnh từ Google và cộng đồng |

### 1.3 Flutter vs React Native

```
Flutter:
- Ngôn ngữ: Dart
- UI: Widget (tự vẽ)
- Performance: Cao (render riêng)

React Native:
- Ngôn ngữ: JavaScript
- UI: Native components
- Performance: Tốt (qua bridge)
```

---

## 2. Cấu Trúc Project Flutter

```
flutter_basics/
│
├── 📂 lib/                    ← CODE CHÍNH Ở ĐÂY
│   └── main.dart              ← Entry point
│
├── 📂 web/                    ← Web-specific files
│   ├── index.html
│   └── manifest.json
│
├── 📂 test/                   ← Unit tests
│
├── 📄 pubspec.yaml            ← Dependencies & assets
├── 📄 pubspec.lock            ← Lock versions
├── 📄 analysis_options.yaml   ← Linter rules
└── 📄 README.md
```

### 2.1 lib/main.dart - Entry Point

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Hello Flutter')),
        body: Center(child: Text('Hello World!')),
      ),
    );
  }
}
```

### 2.2 Giải thích từng phần

```dart
// 1. Import thư viện Material Design
import 'package:flutter/material.dart';

// 2. main() - Entry point của app
void main() {
  runApp(const MyApp()); // Khởi chạy app
}

// 3. MyApp - Root widget của app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 4. MaterialApp - Wrapper cho Material Design
    return MaterialApp(
      // 5. Scaffold - Cấu trúc màn hình chuẩn
      home: Scaffold(
        appBar: AppBar(...),  // Thanh tiêu đề
        body: Center(...),    // Nội dung chính
      ),
    );
  }
}
```

---

## 3. pubspec.yaml - Quản Lý Dependencies

```yaml
name: flutter_basics
description: Learning Flutter basics

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  # Thêm package bên ngoài ở đây
  # http: ^1.1.0
  # provider: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  
  # Khai báo assets
  # assets:
  #   - assets/images/
  #   - assets/icons/
  
  # Khai báo fonts
  # fonts:
  #   - family: Roboto
  #     fonts:
  #       - asset: assets/fonts/Roboto-Regular.ttf
```

---

## 4. Các Lệnh Flutter Quan Trọng

| Lệnh | Chức năng |
|------|-----------|
| `flutter create app_name` | Tạo project mới |
| `flutter run` | Chạy app |
| `flutter run -d chrome` | Chạy trên Chrome |
| `flutter devices` | Xem danh sách thiết bị |
| `flutter pub get` | Cài dependencies |
| `flutter pub add package_name` | Thêm package |
| `flutter clean` | Xóa cache |
| `flutter doctor` | Kiểm tra môi trường |

---

## 5. Widget Tree - Cây Widget

Mọi thứ trong Flutter đều là **Widget**!

```
MaterialApp
    └── Scaffold
            ├── AppBar
            │       └── Text
            └── body: Center
                        └── Column
                                ├── Text
                                ├── Image
                                └── ElevatedButton
```

### 5.1 Quy tắc Widget Tree

1. **Mọi UI đều là Widget** - Text, Button, Padding, Row...
2. **Widget lồng Widget** - Tạo thành tree
3. **Immutable** - Widget không thể thay đổi sau khi tạo
4. **Rebuild** - Thay đổi → tạo Widget mới

---

## 6. MaterialApp vs CupertinoApp

```dart
// Material Design (Android style)
MaterialApp(
  theme: ThemeData(...),
  home: Scaffold(...),
)

// Cupertino (iOS style)
CupertinoApp(
  theme: CupertinoThemeData(...),
  home: CupertinoPageScaffold(...),
)
```

> 💡 **Tip**: Chúng ta sẽ dùng **MaterialApp** vì phổ biến hơn và dễ học hơn.

---

## 7. Scaffold - Cấu Trúc Màn Hình

```dart
Scaffold(
  // Thanh tiêu đề
  appBar: AppBar(
    title: Text('Title'),
    actions: [...],
  ),
  
  // Nội dung chính
  body: Container(...),
  
  // Nút floating
  floatingActionButton: FloatingActionButton(...),
  
  // Bottom navigation
  bottomNavigationBar: BottomNavigationBar(...),
  
  // Drawer (menu bên)
  drawer: Drawer(...),
)
```

---

## 8. Bài Tập

### Exercise 01: Hello Flutter
File: `lib/exercises/ex01_hello_flutter.dart`

Tạo app hiển thị:
- AppBar với title "My First App"
- Body hiển thị "Hello, [Tên của bạn]!"
- Thêm Icon ở góc phải AppBar

---

## 📝 Checklist Bài 1

- [ ] Hiểu Flutter là gì
- [ ] Hiểu cấu trúc project
- [ ] Chạy được app trên Chrome
- [ ] Hiểu MaterialApp và Scaffold
- [ ] Hoàn thành Exercise 01
