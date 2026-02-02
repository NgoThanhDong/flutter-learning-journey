# Lesson 03: Named Routes 🏷️

## 1. Khái niệm

Thay vì hard-code `MaterialPageRoute` ở khắp nơi, chúng ta đặt tên cho các routes (ví dụ: `/`, `/login`, `/home`) và đăng ký chúng tập trung tại `MaterialApp`.

Cách này giúp code gọn gàng hơn, nhưng khó quản lý tham số (arguments) và deep linking hơn so với `go_router`.

## 2. Định nghĩa Routes

Trong `MaterialApp`:

```dart
MaterialApp(
  // Route mặc định (Home)
  initialRoute: '/',
  
  // Bản đồ các routes
  routes: {
    '/': (context) => const HomeScreen(),
    '/detail': (context) => const DetailScreen(),
    '/settings': (context) => const SettingsScreen(),
  },
);
```

## 3. Sử dụng

```dart
// Push
Navigator.pushNamed(context, '/detail');

// Push Replacement
Navigator.pushReplacementNamed(context, '/home');

// Pop
Navigator.pop(context);
```

## 4. Truyền Arguments (Phức tạp hơn Basic Nav)

Vì `routes` map chỉ nhận builder function, không nhận tham số, nên ta phải truyền tham số qua `arguments` object.

### Gửi
```dart
Navigator.pushNamed(
  context, 
  '/detail',
  arguments: {'id': 123, 'name': 'Flutter'}, // Object bất kỳ
);
```

### Nhận
Tại màn hình đích, ta lấy arguments từ `ModalRoute`.

```dart
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final id = args['id'];
    
    return Text('ID: $id');
  }
}
```

## 5. onGenerateRoute

Khi app lớn lên hoặc cần handle arguments động, `routes` map bị hạn chế. `onGenerateRoute` là giải pháp mạnh mẽ hơn.

```dart
MaterialApp(
  onGenerateRoute: (settings) {
    // settings.name: Tên route (vd: /detail)
    // settings.arguments: Data đi kèm
    
    if (settings.name == '/detail') {
      final args = settings.arguments as Product;
      return MaterialPageRoute(
        builder: (context) => DetailScreen(product: args),
      );
    }
    
    // Xử lý 404
    return MaterialPageRoute(builder: (_) => NotFoundPage());
  },
);
```

---
**Lưu ý:** Named Routes trong Navigator 1.0 vẫn bị hạn chế về Web URL (không thay đổi URL thanh địa chỉ một cách tự nhiên). Lesson sau chúng ta sẽ học giải pháp tối ưu: **go_router**.
