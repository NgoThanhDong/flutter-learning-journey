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
/// AuthController là một ChangeNotifier để quản lý trạng thái đăng nhập
class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false; // Trạng thái đăng nhập
  bool _isInitialized = false; // Trạng thái khởi tạo

  bool get isLoggedIn => _isLoggedIn; // Lấy trạng thái đăng nhập
  bool get isInitialized => _isInitialized; // Lấy trạng thái khởi tạo

  // Khởi tạo AuthController
  AuthController() {
    _init();
  }

  // Giả lập check token từ local storage
  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2)); // Mock delay
    _isInitialized = true; // Đã khởi tạo xong
    notifyListeners(); // Thông báo cho các widget lắng nghe
  }

  // Đăng nhập
  void login() {
    _isLoggedIn = true; // Đã đăng nhập
    notifyListeners(); // Thông báo cho các widget lắng nghe
  }

  // Đăng xuất
  void logout() {
    _isLoggedIn = false; // Chưa đăng nhập
    notifyListeners();
  }
}

// Tạo một instance của AuthController
// Sử dụng final để đảm bảo chỉ có một instance duy nhất
// AuthController là một ChangeNotifier để quản lý trạng thái đăng nhập
final authController = AuthController();

// [Main App]
// Ex16AuthFlow là widget chính của ứng dụng
// Nó sử dụng GoRouter để quản lý các route
class Ex16AuthFlow extends StatelessWidget {
  const Ex16AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo một GoRouter để quản lý các route
    // refreshListenable: authController -> Khi authController thay đổi -> GoRouter sẽ tự động redirect
    // initialLocation: '/' -> Vị trí ban đầu
    // redirect: (context, state) -> Hàm redirect được gọi khi người dùng cố gắng truy cập một route
    final router = GoRouter(
      refreshListenable: authController,
      initialLocation: '/',
      redirect: (context, state) {
        // 1. Nếu chưa khởi tạo xong -> Luôn ở Splash
        if (!authController.isInitialized) {
          return '/splash';
        }

        // Lấy trạng thái đăng nhập
        final isLoggedIn = authController.isLoggedIn;
        // Lấy trạng thái splash
        final isSplash = state.uri.toString() == '/splash';
        // Lấy trạng thái login
        final isLogin = state.uri.toString() == '/login';

        // 2. Nếu vừa init xong và đang ở splash -> điều hướng
        // Nếu đang ở splash và đã init xong -> điều hướng về home nếu đã login, ngược lại về login
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

      // Các route
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

    // MaterialApp.router: Widget để hiển thị ứng dụng với GoRouter
    // routerConfig: router -> Cấu hình router
    // debugShowCheckedModeBanner: false -> Ẩn debug banner
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// [Splash Screen]
// SplashScreen là widget hiển thị khi ứng dụng khởi động
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
            // CircularProgressIndicator: Widget hiển thị tiến trình tải
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 10),
            Text('Đang tải...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// [Login Screen]
// LoginScreen là widget hiển thị khi người dùng chưa đăng nhập
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
                  // Gọi hàm login để thay đổi trạng thái đăng nhập
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

// [Home Screen]
// HomeScreen là widget hiển thị khi người dùng đã đăng nhập
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
            // Gọi hàm logout để thay đổi trạng thái đăng nhập
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
