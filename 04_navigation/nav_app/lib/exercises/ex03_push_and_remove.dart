/// ===========================================
/// EXERCISE 03: PUSH AND REMOVE UNTIL
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xóa sạch lịch sử navigation
/// - Ứng dụng: Logout hoàn toàn, đặt lại Order thành công
///
/// 📝 Giải thích:
/// - pushAndRemoveUntil: Đẩy route mới vào VÀ xóa các route cũ theo điều kiện.
/// - predicate: Hàm điều kiện, trả về false để xóa, true để dừng xóa.
/// - (route) => false: Xóa TẤT CẢ.

library;

import 'package:flutter/material.dart';

// Ex03PushAndRemove là widget để tạo màn hình đầu tiên, màn hình gốc
class Ex03PushAndRemove extends StatelessWidget {
  const Ex03PushAndRemove({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex03: Remove Until')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Đi sâu vào vài màn hình để tạo lịch sử
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Step1Screen()),
            );
          },
          child: const Text('Bắt đầu quy trình (Bước 1) 👉'),
        ),
      ),
    );
  }
}

// Step1Screen là widget để tạo màn hình thứ 2, màn hình Bước 1
class Step1Screen extends StatelessWidget {
  const Step1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bước 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /// [Navigator.push]
            /// Đẩy màn hình Bước 2 vào stack.
            /// Stack hiện tại: Gốc -> Bước 1 -> Bước 2
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Step2Screen()),
            );
          },
          child: const Text('Sang Bước 2 👉'),
        ),
      ),
    );
  }
}

// Step2Screen là widget để tạo màn hình thứ 3, màn hình Bước 2
class Step2Screen extends StatelessWidget {
  const Step2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bước 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /// [Navigator.push]
            /// Đẩy màn hình Cuối cùng vào stack.
            /// Stack hiện tại: Gốc -> Bước 1 -> Bước 2 -> Cuối cùng
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FinalScreen()),
            );
          },
          child: const Text('Hoàn tất (Sang màn cuối) 👉'),
        ),
      ),
    );
  }
}

// FinalScreen là widget để tạo màn hình thứ 4, màn hình Cuối cùng
class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(title: const Text('Hoàn Thành ✅')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quy trình hoàn tất!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Stack hiện tại: Gốc -> Bước 1 -> Bước 2 -> Final',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                /// [Navigator.pushAndRemoveUntil]
                /// Xóa hết các màn hình trước đó, chỉ giữ lại màn hình mới (Home).
                ///
                /// (route) => false : Xóa hết
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Ex03PushAndRemove(),
                  ),
                  (route) => false, // Xóa hết các màn hình trước đó
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                padding: const EdgeInsets.all(20),
              ),
              child: const Text('Về Home & Xóa Lịch Sử 🏠'),
            ),
          ],
        ),
      ),
    );
  }
}
