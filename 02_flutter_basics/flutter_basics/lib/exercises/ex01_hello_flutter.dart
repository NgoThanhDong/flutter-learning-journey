/// ===========================================
/// EXERCISE 01: HELLO FLUTTER
/// ===========================================
///
/// Mục tiêu: Tạo app Flutter đầu tiên
///
/// Yêu cầu:
/// - AppBar với title "My First App"
/// - Body hiển thị "Hello, [Tên của bạn]!" ở giữa màn hình
/// - Thêm Icon ở góc phải AppBar
///
/// Hướng dẫn:
/// 1. Uncomment code bên dưới
/// 2. Điền vào chỗ ???
/// 3. Import file này trong main.dart
/// 4. Chạy: flutter run -d chrome
library;

import 'package:flutter/material.dart';

// -TODO: Uncomment và hoàn thiện code bên dưới

class Ex01HelloFlutter extends StatelessWidget {
  const Ex01HelloFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My First App'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Hiện snackbar khi click
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings clicked!')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Hello, Dong!', // Thay tên của bạn
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// ============================================
// GỢI Ý
// ============================================
//
// 1. AppBar title: Text('My First App')
// 2. Icon: Icons.settings hoặc Icons.info
// 3. Text trong body: Text('Hello, Dong!')
// 4. Dùng Center widget để căn giữa
