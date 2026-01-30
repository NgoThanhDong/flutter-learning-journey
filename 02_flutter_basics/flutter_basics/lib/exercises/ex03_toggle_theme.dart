/// ===========================================
/// EXERCISE 03: TOGGLE THEME
/// ===========================================
///
/// Mục tiêu: Sử dụng StatefulWidget để thay đổi state đơn giản
///
/// Yêu cầu:
/// - Tạo màn hình có background thay đổi màu được
/// - Một nút ở giữa màn hình
/// - Khi bấm nút:
///   + Icon đổi từ Mặt trời (Sun) sang Mặt trăng (Moon)
///   + Background đổi từ Trắng sang Đen
///   + Text đổi màu tương phản (Đen <-> Trắng)

library;

import 'package:flutter/material.dart';

class Ex03ToggleTheme extends StatefulWidget {
  const Ex03ToggleTheme({super.key});

  @override
  State<Ex03ToggleTheme> createState() => _Ex03ToggleThemeState();
}

class _Ex03ToggleThemeState extends State<Ex03ToggleTheme> {
  // Biến boolean để lưu trạng thái: true = tối, false = sáng
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      // Đảo ngược giá trị true/false mỗi khi bấm
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [Thủ thuật] Toán tử 3 ngôi (condition ? value_if_true : value_if_false)
      // Rất hữu ích để thay đổi giao diện dựa trên state
      backgroundColor: _isDark ? Colors.black : Colors.white,

      appBar: AppBar(
        title: Text('Toggle Theme'),
        // AppBar cũng đổi màu theo theme
        backgroundColor: _isDark ? Colors.grey[900] : Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon thay đổi hình mặt trăng/mặt trời
            Icon(
              _isDark ? Icons.nightlight_round : Icons.wb_sunny,
              size: 100,
              // Màu icon cũng đổi
              color: _isDark ? Colors.yellow : Colors.orange,
            ),

            SizedBox(height: 32),

            Text(
              // Text hiển thị trạng thái hiện tại
              _isDark ? 'Dark Mode' : 'Light Mode',
              style: TextStyle(
                fontSize: 24,
                // Màu chữ phải tương phản với màu nền (nền đen -> chữ trắng)
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),

            SizedBox(height: 32),

            ElevatedButton(
              onPressed: _toggleTheme, // Gọi hàm đổi theme
              child: Text('Toggle'),
            ),
          ],
        ),
      ),
    );
  }
}
