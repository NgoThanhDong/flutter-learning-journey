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

// Ex03ToggleTheme - Widget để thay đổi theme
class Ex03ToggleTheme extends StatefulWidget {
  // StatefulWidget là Widget không có state
  // Nó chỉ là một template để tạo ra State
  // Nó có thể thay đổi và sẽ được cập nhật lại UI
  const Ex03ToggleTheme({
    super.key,
  }); // key là một định danh duy nhất cho Widget

  // createState(): Hàm tạo State cho Widget
  // Hàm này sẽ được gọi khi Widget được tạo ra
  // Trả về một State object
  @override
  State<Ex03ToggleTheme> createState() => _Ex03ToggleThemeState();
}

// _Ex03ToggleThemeState: State của Ex03ToggleTheme
// State là nơi lưu trữ dữ liệu thay đổi của Widget
// State có thể thay đổi và sẽ được cập nhật lại UI
class _Ex03ToggleThemeState extends State<Ex03ToggleTheme> {
  // Biến boolean để lưu trạng thái: true = tối, false = sáng
  bool _isDark = false;

  // Hàm để thay đổi state
  void _toggleTheme() {
    // setState(): Hàm để cập nhật state
    // Hàm này sẽ được gọi khi state thay đổi
    // Trả về một State object
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
        // foregroundColor: màu nội dung phía trước, bao gồm: chữ title, icon (menu, back, action icons), icon leading
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

            SizedBox(height: 32), // Khoảng cách giữa 2 widget

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

            // Nút bấm để thay đổi state
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
