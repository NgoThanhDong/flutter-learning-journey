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

// [Giải thích concept]
// StatelessWidget: Widget tĩnh, không thay đổi nội dung khi người dùng tương tác.
// Dùng cho các màn hình chỉ hiển thị thông tin.

// Ex01HelloFlutter - Widget để tạo màn hình chào mừng
class Ex01HelloFlutter extends StatelessWidget {
  const Ex01HelloFlutter({super.key});

  // Hàm build: Nơi vẽ UI. Hàm này trả về 1 Widget tree.
  @override
  Widget build(BuildContext context) {
    // Scaffold: Khung sườn chuẩn của Material Design (gồm AppBar, Body, FAB...)
    return Scaffold(
      // AppBar: Thanh tiêu đề phía trên
      appBar: AppBar(
        title: Text('My First App'),
        // actions: Nơi chứa các nút bấm ở góc phải AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // [Thủ thuật]
              // ScaffoldMessenger dùng để hiển thị thông báo SnackBar (popup nhỏ bên dưới)
              // context giúp Flutter biết vị trí của widget trong tree
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Settings clicked!')));
            },
          ),
        ],
      ),

      // Body: Phần nội dung chính của màn hình
      // Center: Widget giúp căn giữa con của nó theo cả dọc và ngang
      body: Center(
        child: Text(
          'Hello, Dong!', // Thay tên của bạn
          // TextStyle: Định dạng font chữ, màu sắc, size...
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold, // Chữ đậm
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
