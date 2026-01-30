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

// -TODO: Uncomment và hoàn thiện
class Ex19DarkModeToggle extends StatefulWidget {
  const Ex19DarkModeToggle({super.key});

  @override
  State<Ex19DarkModeToggle> createState() => _Ex19DarkModeToggleState();
}

class _Ex19DarkModeToggleState extends State<Ex19DarkModeToggle> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    // Theme data
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      scaffoldBackgroundColor: Colors.white,
    );
    
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, 
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDark ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dark Mode Toggle'),
          actions: [
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
              color: _isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isDark ? Icons.nightlight_round : Icons.wb_sunny,
                  size: 64,
                  color: _isDark ? Colors.yellow : Colors.orange,
                ),
                SizedBox(height: 24),
                Text(
                  _isDark ? 'Dark Mode Active' : 'Light Mode Active',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'This card adapts to current theme.',
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
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
