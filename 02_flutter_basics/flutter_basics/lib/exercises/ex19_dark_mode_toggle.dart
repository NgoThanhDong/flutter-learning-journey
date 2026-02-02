/// ===========================================
/// EXERCISE 19: DARK MODE TOGGLE
/// ===========================================
///
/// Mục tiêu: Chuyển đổi Theme sáng/tối
///
/// Yêu cầu:
/// - Sử dụng switch để toggle
/// - Thay đổi toàn bộ giao diện app

library;

import 'package:flutter/material.dart';

// Ex19DarkModeToggle - Widget chuyển đổi Theme sáng/tối
class Ex19DarkModeToggle extends StatefulWidget {
  const Ex19DarkModeToggle({super.key});

  @override
  State<Ex19DarkModeToggle> createState() => _Ex19DarkModeToggleState();
}

class _Ex19DarkModeToggleState extends State<Ex19DarkModeToggle> {
  // Biến state lưu trạng thái Dark Mode
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    // Định nghĩa 2 theme riêng biệt
    final lightTheme = ThemeData(
      // ThemeData = Theme cho toàn bộ app
      brightness: Brightness.light, // Brightness.light = Chế độ sáng
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ), // ColorScheme = Hệ thống màu chuẩn của Material 3
      scaffoldBackgroundColor:
          Colors.white, // ScaffoldBackgroundColor = Màu nền của Scaffold
    );

    final darkTheme = ThemeData(
      // ThemeData = Theme cho toàn bộ app
      brightness: Brightness.dark, // Brightness.dark = Chế độ tối
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors
            .blue, // seedColor = Màu chủ đạo -> Flutter sẽ tự sinh ra các màu phụ khác
        brightness: Brightness.dark, // Brightness.dark = Chế độ tối
      ),
      scaffoldBackgroundColor: Colors.grey[900], // Màu nền tối
    );

    // MaterialApp là widget root có khả năng quản lý Theme
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // DebugShowCheckedModeBanner = Ẩn banner debug
      // [Logic] Chọn theme dựa vào state
      theme: _isDark ? darkTheme : lightTheme, // Theme = Theme cho toàn bộ app
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dark Mode Toggle'),
          actions: [
            // Switch để người dùng bật tắt
            Switch(
              value: _isDark,
              onChanged: (val) => setState(() => _isDark = val),
            ),
          ],
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.all(24),
            decoration: BoxDecoration(
              // Màu nền Container cũng phải đổi theo theme (hoặc code cứng logic như dưới đây)
              color: _isDark
                  ? Colors.grey[800]
                  : Colors
                        .grey[100], // Màu nền Container cũng phải đổi theo theme (hoặc code cứng logic như dưới đây)
              borderRadius: BorderRadius.circular(16), // Bo góc
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ], // Bóng đổ
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // MainAxisSize.min = Kích thước tối thiểu
              children: [
                Icon(
                  _isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny, // Icon đổi theo mode
                  size: 64, // Kích thước icon
                  // Màu icon đổi theo mode
                  color: _isDark
                      ? Colors.yellow
                      : Colors.orange, // Màu icon đổi theo mode
                ),
                SizedBox(height: 24),
                Text(
                  _isDark
                      ? 'Dark Mode Active'
                      : 'Light Mode Active', // Text đổi theo mode
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ), // Style text
                ),
                SizedBox(height: 16),
                Text(
                  'This card adapts to current theme.',
                ), // Text đổi theo mode
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('Button pressed');
                  },
                  child: Text('Click Me'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
