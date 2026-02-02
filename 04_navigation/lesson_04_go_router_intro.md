# Lesson 04: go_router Intro 🚀

## 1. Tại sao cần go_router?

`go_router` là package chính thức được Flutter team hỗ trợ để giải quyết các vấn đề của Navigator 1.0:
- ✅ **Web URL Support**: URL thay đổi khi chuyển trang, user có thể gõ URL để vào thẳng trang con.
- ✅ **Deep Linking**: Hỗ trợ mở app từ link (vd: `myapp://product/123`).
- ✅ **Nested Navigation**: Dễ dàng làm BottomNavigationBar vẫn giữ trạng thái.
- ✅ **Guards & Redirects**: Kiểm tra đăng nhập (Auth Guard) dễ dàng.

## 2. Setup

Thêm vào `pubspec.yaml` (đã làm ở đầu phase):
```yaml
dependencies:
  go_router: ^14.3.0
```

## 3. Configuration

Chúng ta cần tạo một object `GoRouter` và cấu hình cho `MaterialApp.router`.

```dart
// 1. Định nghĩa Router config
final _router = GoRouter(
  initialLocation: '/', // Mặc định vào đây
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => const DetailScreen(),
    ),
  ],
);

// 2. Sử dụng trong MaterialApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // Dùng constructor .router
      routerConfig: _router,
    );
  }
}
```

## 4. Navigation với go_router

API của go_router rất trực quan (declarative):

- **`context.go('/details')`**: Chuyển trang và **thay đổi stack** để khớp với URL. (Khuyên dùng cho Web/App flow chính). Ví dụ đang ở `/a/b` mà `go('/d')` thì stack sẽ reset thành `/d`.
- **`context.push('/details')`**: Đẩy trang mới vào stack (giống Navigator.push). Giữ nút Back để quay lại.

## 5. Path Parameters & Query Parameters

### Path Parameters (/:id)
Dùng cho URL dạng `/product/123`.

*Config:*
```dart
GoRoute(
  path: '/product/:id', // :id là placeholder
  builder: (context, state) {
    // Lấy id từ URL
    final id = state.pathParameters['id']!;
    return ProductScreen(id: id);
  },
)
```

*Sử dụng:* (Lưu ý: truyền giá trị thực tế vào path)
```dart
context.go('/product/123');
```

### Query Parameters (?filter=abc)
Dùng cho URL dạng `/search?q=flutter`.

*Sử dụng:*
```dart
context.go(Uri(path: '/search', queryParameters: {'q': 'flutter'}).toString());
// Hoặc đơn giản: context.go('/search?q=flutter');
```

*Lấy giá trị:*
```dart
builder: (context, state) {
  final query = state.urlParameters['q']; // 'flutter'
  return SearchScreen(query: query);
}
```
