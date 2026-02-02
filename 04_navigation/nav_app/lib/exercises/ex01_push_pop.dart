/// ===========================================
/// EXERCISE 01: PUSH & POP CƠ BẢN
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu cơ chế Stack (ngăn xếp) của Navigator
/// - Thực hành Navigator.push() để đi tới
/// - Thực hành Navigator.pop() để quay lại
///
/// 📝 Giải thích:
/// - Navigator quản lý các Route (màn hình) như một chồng đĩa.
/// - Push: Đặt thêm đĩa lên (Screen 1 -> Screen 2).
/// - Pop: Lấy đĩa ra (Screen 2 -> Screen 1).

library;

import 'package:flutter/material.dart';

class Ex01PushPop extends StatelessWidget {
  const Ex01PushPop({super.key});

  @override
  Widget build(BuildContext context) {
    // Đây là màn hình gốc (Screen A)
    return Scaffold(
      appBar: AppBar(title: const Text('Ex01: Push & Pop Basics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Screen A (Gốc)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // Sự kiện khi nhấn nút
              onPressed: () {
                /// [Navigator.push]
                /// Đẩy một Route mới vào stack.
                /// context: dùng để Navigator định vị vị trí hiện tại.
                /// MaterialPageRoute: tạo hiệu ứng chuyển cảnh chuẩn Android/iOS.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenB()),
                );
              },
              child: const Text('Đi tới Screen B 👉'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Màn hình thứ 2
class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Đổi màu để dễ phân biệt
      appBar: AppBar(
        title: const Text('Screen B'),
        backgroundColor: Colors.blue.shade100,
        // [Lưu ý] Flutter tự động thêm nút Back (Leading)
        // nếu Navigator stack có > 1 màn hình.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Screen B',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                /// [Navigator.pop]
                /// Gỡ bỏ Route hiện tại khỏi stack -> Quay về màn hình trước.
                Navigator.pop(context);
              },
              child: const Text('👈 Quay về Screen A'),
            ),
          ],
        ),
      ),
    );
  }
}
