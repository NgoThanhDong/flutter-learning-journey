# Lesson 05: go_router Advanced 🛠️

## 1. Nested Routes (Routes lồng nhau)

Bạn có thể định nghĩa routes con (`routes: [...]` bên trong `GoRoute`). Điều này giúp tổ chức URL logic hơn (vd: `/shop` và `/shop/details`).

```dart
GoRoute(
  path: '/shop',
  builder: (context, state) => ShopScreen(),
  routes: [ // Sub-routes
    GoRoute(
      path: 'details', // Lưu ý: KHÔNG có dấu / ở đầu
      builder: (context, state) => DetailsScreen(),
    ),
  ],
)
```
URL sẽ là `/shop/details`.

## 2. ShellRoute (Persistent UI / Bottom Navigation)

Để làm layout cố định (như Bottom Navigation Bar) mà nội dung bên trong thay đổi, ta dùng `ShellRoute` hoặc `StatefulShellRoute`.

```dart
ShellRoute(
  // Builder cho cái "vỏ" (Shell) - chứa BottomNav
  builder: (context, state, child) {
    return ScaffoldWithBottomNav(child: child);
  },
  // Các routes con sẽ hiển thị vào vị trí 'child'
  routes: [
    GoRoute(path: '/home', ...),
    GoRoute(path: '/profile', ...),
  ],
)
```

## 3. Redirects & Guards (Bảo vệ Routes)

Đây là tính năng cực mạnh để xử lý Authentication. `redirect` là hàm chạy trước khi navigation xảy ra.

```dart
GoRouter(
  redirect: (context, state) {
    final isLoggedIn = // Check login status (từ Provider/Riverpod);
    final isGoingToLogin = state.uri.toString() == '/login';

    // Nếu chưa login và không phải đang ở trang login -> Đá về login
    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }

    // Nếu đã login mà cố vào trang login -> Đá về home
    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }

    // null = Cho phép đi tiếp
    return null;
  },
  routes: [...],
);
```

## 4. Error Handling (404)

Tùy chỉnh trang lỗi khi người dùng gõ URL không tồn tại.

```dart
GoRouter(
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
  // ...
);
```

## 5. Refresh Listenable

Để `go_router` tự động chạy lại logic `redirect` khi state thay đổi (vd: user đăng nhập thành công), ta cần cung cấp `refreshListenable`.

```dart
GoRouter(
  refreshListenable: authNotifier, // ChangeNotifier
  // ...
);
```
Ngay khi `authNotifier` notify, router sẽ check lại redirect.
