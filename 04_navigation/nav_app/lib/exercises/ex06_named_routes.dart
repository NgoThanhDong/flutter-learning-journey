/// ===========================================
/// EXERCISE 06: NAMED ROUTES CƠ BẢN
/// ===========================================
/// 🎯 Mục tiêu:
/// - Định nghĩa bảng routes
/// - Sử dụng Navigator.pushNamed
///
/// 📝 Giải thích:
/// - Named Routes giúp code gọn hơn ("/" thay vì MaterialPageRoute(...)).
/// - routes được định nghĩa trong MaterialApp.
/// - initialRoute xác định màn hình đầu tiên.

library;

import 'package:flutter/material.dart';

// Ex06NamedRoutes là widget màn hình chính của bài tập 6
class Ex06NamedRoutes extends StatelessWidget {
  const Ex06NamedRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    /// [MaterialApp] được cấu hình Named Routes
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Named Routes Demo',

      // [1] Màn hình khởi chạy
      initialRoute: '/',

      // [2] Bảng định nghĩa Routes
      // Map<String, WidgetBuilder>
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
        '/third': (context) => const ThirdScreen(),
      },
    );
  }
}

// HomeScreen là màn hình đầu tiên
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen (/ )')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /// [Navigator.pushNamed]
            /// Sử dụng tên route đã định nghĩa
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('Go to Second Screen 👉'),
        ),
      ),
    );
  }
}

// SecondScreen là màn hình thứ hai
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: const Text('Second Screen (/second)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // [Navigator.pushNamed]
                // Sử dụng tên route đã định nghĩa
                Navigator.pushNamed(context, '/third');
              },
              child: const Text('Go to Third Screen 👉'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              // [Navigator.pop]
              // Quay lại màn hình trước đó
              onPressed: () => Navigator.pop(context),
              child: const Text('Quay lại 👈'),
            ),
          ],
        ),
      ),
    );
  }
}

// ThirdScreen là màn hình thứ ba
class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(title: const Text('Third Screen (/third)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Đây là màn hình cuối cùng'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // [Navigator.popUntil]
                // Quay về màn hình đầu tiên (xóa hết stack trừ màn hình '/')
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Về thẳng Home 🏠'),
            ),
          ],
        ),
      ),
    );
  }
}
