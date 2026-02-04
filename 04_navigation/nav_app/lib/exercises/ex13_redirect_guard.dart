/// ===========================================
/// EXERCISE 13: REDIRECT & GUARDS (BẢO VỆ ROUTE)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Sử dụng redirect để chặn truy cập trái phép
/// - Implement flow Login/Home đơn giản
///
/// 📝 Giải thích:
/// - [redirect]: Một hàm chạy TRƯỚC khi điều hướng.
/// - Trả về `String` (path mới) để chuyển hướng, hoặc `null` để cho phép đi tiếp.
/// - [refreshListenable]: Router tự động re-check redirect khi listenable này thay đổi.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 1. Mock Auth Service
/// AuthService là class giả lập để demo việc kiểm tra login/logout
class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false; // Trạng thái login/logout
  bool get isLoggedIn => _isLoggedIn; // Trả về trạng thái login/logout

  void login() {
    _isLoggedIn = true; // Đã login
    notifyListeners(); // Router sẽ lắng nghe event này
  }

  void logout() {
    _isLoggedIn = false; // Chưa login
    notifyListeners();
  }
}

// Global Auth Service (cho demo đơn giản)
/// authService là instance của AuthService
/// Router sẽ lắng nghe thay đổi từ authService để chạy lại redirect khi có thay đổi
final authService = AuthService();

/// Ex13RedirectGuard là widget để demo redirect & guards
class Ex13RedirectGuard extends StatelessWidget {
  const Ex13RedirectGuard({super.key});

  @override
  Widget build(BuildContext context) {
    /// GoRouter là class chính của go_router
    /// GoRouter chứa tất cả logic của router
    /// GoRouter có các tham số quan trọng:
    /// - initialLocation: path ban đầu khi mở app
    /// - refreshListenable: lắng nghe thay đổi từ listenable
    /// - redirect: logic redirect
    final router = GoRouter(
      /// initialLocation là path ban đầu khi mở app
      initialLocation: '/',

      /// [quan trọng] refreshListenable
      /// Router sẽ lắng nghe thay đổi từ authService để chạy lại redirect
      refreshListenable: authService,

      /// [Redirect Logic]
      /// redirect là hàm chạy TRƯỚC khi điều hướng
      /// Trả về `String` (path mới) để chuyển hướng, hoặc `null` để cho phép đi tiếp
      redirect: (context, state) {
        // Trạng thái login/logout
        final isLoggedIn = authService.isLoggedIn;
        // Kiểm tra path hiện tại có phải là /login không
        final isGoingToLogin = state.uri.toString() == '/login';

        // 1. Nếu chưa login và không phải đang ở trang login
        // -> Chuyển về login
        if (!isLoggedIn && !isGoingToLogin) {
          return '/login';
        }

        // 2. Nếu đã login mà cố vào trang login
        // -> Chuyển về home
        if (isLoggedIn && isGoingToLogin) {
          return '/';
        }

        // null = Cho phép đi tiếp
        return null;
      },

      /// [Routes]
      /// routes là danh sách các route có thể di chuyển đến
      /// Mỗi route có path và builder
      /// builder là hàm tạo widget cho route đó
      /// builder nhận 2 tham số: context và state
      /// state chứa thông tin về route hiện tại
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ProtectedHomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );

    /// [MaterialApp.router]
    /// MaterialApp.router là widget chính của go_router
    /// routerConfig là router đã định nghĩa
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// [LoginScreen]
/// LoginScreen là widget hiển thị trang login
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 64, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('Bạn chưa đăng nhập'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Login -> authService notify -> redirect check -> chuyển về Home
                // authService.login() sẽ thay đổi trạng thái login
                // refreshListenable sẽ lắng nghe thay đổi từ authService
                // redirect sẽ được gọi lại
                // Nếu isLoggedIn = true và isGoingToLogin = false -> return '/'
                authService.login();
              },
              child: const Text('Đăng nhập ngay'),
            ),
          ],
        ),
      ),
    );
  }
}

/// [ProtectedHomeScreen]
/// ProtectedHomeScreen là widget hiển thị trang home
/// Chỉ có người đã login mới có thể vào trang này
class ProtectedHomeScreen extends StatelessWidget {
  const ProtectedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(title: const Text('Protected Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Chào mừng! Bạn đã đăng nhập.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
              ),
              onPressed: () {
                // Logout -> authService notify -> redirect check -> chuyển về Login
                // authService.logout() sẽ thay đổi trạng thái login
                // refreshListenable sẽ lắng nghe thay đổi từ authService
                // redirect sẽ được gọi lại
                // Nếu isLoggedIn = false và isGoingToLogin = true -> return '/login'
                authService.logout();
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
