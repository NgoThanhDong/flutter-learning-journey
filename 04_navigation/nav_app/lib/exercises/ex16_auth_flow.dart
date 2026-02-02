/// ===========================================
/// EXERCISE 16: COMPLETE AUTH FLOW
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xây dựng luồng Authentication hoàn chỉnh
/// - Splash -> Check Auth -> Login/Home
///
/// 📝 Logic:
/// 1. App khởi động -> hiện Splash Screen 2 giây.
/// 2. Kiểm tra trạng thái đăng nhập.
/// 3. Redirect về Login hoặc Home.
/// 4. Logout đá về Login.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [Mock Auth Controller]
class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isInitialized = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;

  AuthController() {
    _init();
  }

  // Giả lập check token từ local storage
  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2)); // Mock delay
    _isInitialized = true;
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

final authController = AuthController();

class Ex16AuthFlow extends StatelessWidget {
  const Ex16AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      refreshListenable: authController,
      initialLocation: '/',
      redirect: (context, state) {
        // 1. Nếu chưa khởi tạo xong -> Luôn ở Splash
        if (!authController.isInitialized) {
          return '/splash';
        }

        final isLoggedIn = authController.isLoggedIn;
        final isSplash = state.uri.toString() == '/splash';
        final isLogin = state.uri.toString() == '/login';

        // 2. Nếu vừa init xong và đang ở splash -> điều hướng
        if (isSplash) {
          return isLoggedIn ? '/' : '/login';
        }

        // 3. Nếu chưa login và không ở trang login -> đá về login
        if (!isLoggedIn && !isLogin) {
          return '/login';
        }

        // 4. Nếu đã login và cố vào login -> đá về home (opsional)
        if (isLoggedIn && isLogin) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flutter_dash, size: 80, color: Colors.white),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 10),
            Text('Đang tải...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Vui lòng đăng nhập', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: () {
                  authController.login();
                },
                child: const Text('LOGIN MOCK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text('Bạn đã đăng nhập thành công!'),
          ],
        ),
      ),
    );
  }
}
