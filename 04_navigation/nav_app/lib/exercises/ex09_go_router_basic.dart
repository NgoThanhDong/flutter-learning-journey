/// ===========================================
/// EXERCISE 09: GO ROUTER BASIC
/// ===========================================
/// 🎯 Mục tiêu:
/// - Cài đặt GoRouter cơ bản
/// - Hiểu GoRoute và context.go()
///
/// 📝 Giải thích:
/// - [GoRouter]: Object quản lý toàn bộ routing.
/// - [GoRoute]: Định nghĩa từng đường dẫn (path) và builder.
/// - [MaterialApp.router]: Constructor đặc biệt để dùng Router API.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Ex09GoRouterBasic extends StatelessWidget {
  const Ex09GoRouterBasic({super.key});

  @override
  Widget build(BuildContext context) {
    /// [Cấu hình Router]
    /// Lưu ý: _router nên được khai báo ngoài build method hoặc dùng riverpod để cache
    /// nhưng để demo đơn giản thì ta khai báo ở đây.
    final router = GoRouter(
      initialLocation: '/', // Màn hình mặc định
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/details',
          builder: (context, state) => const DetailsScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GoRouter Basic',

      /// [Kết nối Router]
      routerConfig: router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home (/)')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /// [context.go]
            /// Chuyển đến path '/details'.
            /// Stack sẽ thay đổi để khớp với URL.
            context.go('/details');
          },
          child: const Text('Go to Details 👉'),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: const Text('Details (/details)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Đây là màn hình chi tiết'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                /// [context.go]
                /// Quay về Home.
                context.go('/');
              },
              child: const Text('Back to Home 🏠'),
            ),
          ],
        ),
      ),
    );
  }
}
