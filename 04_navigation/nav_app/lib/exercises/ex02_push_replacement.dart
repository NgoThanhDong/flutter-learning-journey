/// ===========================================
/// EXERCISE 02: PUSH REPLACEMENT
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu sự khác biệt giữa Push và PushReplacement
/// - Ứng dụng: Splash Screen, Login -> Home
///
/// 📝 Giải thích:
/// - push: A -> B (Stack: A, B). Back từ B về A được.
/// - pushReplacement: A -> B (A bị hủy, Stack: B). Back từ B sẽ thoát app (hoặc về màn hình trước A).

library;

import 'package:flutter/material.dart';

class Ex02PushReplacement extends StatelessWidget {
  const Ex02PushReplacement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex02: Push Replacement')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login, size: 64, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Màn hình Login', style: TextStyle(fontSize: 24)),
            const Text('(Giả lập)'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                /// [Navigator.pushReplacement]
                /// Thay thế Login screen bằng Home screen.
                /// Người dùng không thể quay lại Login bằng nút Back.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('Đăng nhập (Replacement) ➡'),
            ),
          ],
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
        title: const Text('Home Screen'),
        backgroundColor: Colors.green.shade100,
        // Vì đã replace, stack chỉ còn Home, nên KHÔNG có nút Back tự động
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 64, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Chào mừng bạn đã đến Home!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Thử nhấn Back (nếu có) hoặc nút Logout dưới đây',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                // Logout thì lại replace về Login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Ex02PushReplacement(),
                  ),
                );
              },
              child: const Text('Đăng xuất ⬅'),
            ),
          ],
        ),
      ),
    );
  }
}
