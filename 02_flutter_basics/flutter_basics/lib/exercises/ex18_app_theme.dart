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

// -TODO: Uncomment và hoàn thiện

class Ex18AppTheme extends StatelessWidget {
  const Ex18AppTheme({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom logic to show theme
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          bodyLarge: TextStyle(fontSize: 18),
        ),
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
              Text('Headline Large', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), // Sẽ dùng style mặc định nếu không set
              SizedBox(height: 16),
              // Builder để lấy context có Theme mới
              Builder(builder: (context) {
                return Column(
                  children: [
                    Text(
                      'Themed Headline',
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
              }),
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
