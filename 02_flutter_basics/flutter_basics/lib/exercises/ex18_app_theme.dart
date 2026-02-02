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

// Ex18AppTheme - Widget định nghĩa custom theme cho toàn bộ app
class Ex18AppTheme extends StatelessWidget {
  const Ex18AppTheme({super.key}); // Key là tham số bắt buộc của Widget

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
            // headlineLarge = Tiêu đề lớn
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          bodyLarge: TextStyle(fontSize: 18), // bodyLarge = Thân bài
        ),

        // Custom style cho các component cụ thể (cục bộ)
        elevatedButtonTheme: ElevatedButtonThemeData(
          // ElevatedButtonThemeData = Theme cho nút bấm ElevatedButton
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Màu nền
            foregroundColor: Colors.white, // Màu chữ
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ), // Khoảng cách bên trong
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Bo góc
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
                        // ElevatedButton = Nút bấm có viền
                        onPressed: () {
                          debugPrint('Primary Button pressed');
                        },
                        child: Text('Primary Button'),
                      ),
                      SizedBox(height: 16),
                      FilledButton(
                        // FilledButton = Nút bấm filled
                        onPressed: () {
                          debugPrint('Filled Button pressed');
                        },
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
          // FloatingActionButton = Nút bấm nổi
          onPressed: () {
            debugPrint('Floating Action Button pressed');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
