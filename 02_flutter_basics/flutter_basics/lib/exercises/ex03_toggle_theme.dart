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

// -TODO: Uncomment và hoàn thiện code

class Ex03ToggleTheme extends StatefulWidget {
  const Ex03ToggleTheme({super.key});

  @override
  State<Ex03ToggleTheme> createState() => _Ex03ToggleThemeState();
}

class _Ex03ToggleThemeState extends State<Ex03ToggleTheme> {
  // -TODO: Tạo biến state _isDark
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -TODO: Đổi màu background dựa vào _isDark
      backgroundColor: _isDark ? Colors.black : Colors.white,
      
      appBar: AppBar(
        title: Text('Toggle Theme'),
        backgroundColor: _isDark ? Colors.grey[900] : Colors.blue,
        foregroundColor: Colors.white,
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // -TODO: Icon thay đổi dựa vào _isDark
            Icon(
              _isDark ? Icons.nightlight_round : Icons.wb_sunny,
              size: 100,
              color: _isDark ? Colors.yellow : Colors.orange,
            ),
            
            SizedBox(height: 32),
            
            Text(
              _isDark ? 'Dark Mode' : 'Light Mode',
              style: TextStyle(
                fontSize: 24,
                // -TODO: Màu chữ thay đổi
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
            
            SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _toggleTheme,
              child: Text('Toggle'),
            ),
          ],
        ),
      ),
    );
  }
}
