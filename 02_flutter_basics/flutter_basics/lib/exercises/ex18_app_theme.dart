/// ===========================================
/// EXERCISE 18: APP THEME
/// ===========================================
///
/// Mục tiêu: Hiểu về ThemeData và TextTheme
///
/// Yêu cầu:
/// - Định nghĩa custom theme
/// - Áp dụng màu primary, secondary
/// - Áp dụng custom font styles

library;

import 'package:flutter/material.dart';

class Ex18AppTheme extends StatelessWidget {
  const Ex18AppTheme({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom logic to show theme
    return Theme(
      // [Concept] ThemeData: Nơi định nghĩa toàn bộ giao diện của App (Màu sắc, Font chữ, Style nút bấm...)
      data: ThemeData(
        // ColorScheme: Hệ thống màu chuẩn của Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors
              .deepPurple, // Màu chủ đạo -> Flutter sẽ tự sinh ra các màu phụ khác
          brightness: Brightness.light,
        ),
        // TextTheme: Quy định font chữ cho toàn bộ Text trong app
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          bodyLarge: TextStyle(fontSize: 18),
        ),
        // Custom style cho các component cụ thể (cục bộ)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('App Theme')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Headline Large',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ), // Sẽ dùng style mặc định nếu không set
              SizedBox(height: 16),

              // [Quan trọng] Builder: Để tạo một context MỚI nằm bên dưới Theme widget.
              // Nếu không dùng Builder, Theme.of(context) có thể lấy context của widget cha (chưa có theme mới).
              Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text(
                        'Themed Headline',
                        // Truy cập style đã định nghĩa trong Theme
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'This is body text using app theme.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Primary Button'),
                      ),
                      SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {},
                        child: Text('Filled Button'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
