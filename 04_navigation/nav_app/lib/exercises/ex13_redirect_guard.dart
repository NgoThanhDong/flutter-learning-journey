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
class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners(); // Router sẽ lắng nghe event này
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

// Global Auth Service (cho demo đơn giản)
final authService = AuthService();

class Ex13RedirectGuard extends StatelessWidget {
  const Ex13RedirectGuard({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',

      /// [quan trọng] refreshListenable
      /// Router sẽ lắng nghe thay đổi từ authService để chạy lại redirect
      refreshListenable: authService,

      /// [Redirect Logic]
      redirect: (context, state) {
        final isLoggedIn = authService.isLoggedIn;
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

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

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
