/// ===========================================
/// EXERCISE 14: ERROR HANDLING (404)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tùy chỉnh trang lỗi (Page Not Found)
///
/// 📝 Giải thích:
/// - [errorBuilder]: Builder trả về Widget hiển thị khi người dùng vào path không tồn tại trên web.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Ex14ErrorHandling extends StatelessWidget {
  const Ex14ErrorHandling({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',

      /// [errorBuilder] Custom trang lỗi
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  '404 - Không tìm thấy trang!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('Path: ${state.error}'), // Lỗi chi tiết
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Về trang chủ'),
                ),
              ],
            ),
          ),
        );
      },

      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thử nhập một URL linh tinh trên thanh địa chỉ browser.',
            ),
            const Text('Ví dụ: .../#/abcxyz'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Cố tình go tới path không tồn tại
                context.go('/this-path-does-not-exist');
              },
              child: const Text('Đi tới trang lỗi (Demo) 👉'),
            ),
          ],
        ),
      ),
    );
  }
}
