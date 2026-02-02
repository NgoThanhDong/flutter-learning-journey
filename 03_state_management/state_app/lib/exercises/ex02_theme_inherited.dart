/// ===========================================
/// EXERCISE 02: THEME TOGGLE VỚI INHERITEDWIDGET
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Hiểu InheritedWidget - nền tảng của Provider
/// - Chia sẻ state xuống widget tree mà không cần truyền qua constructor
///
/// 📝 Yêu cầu:
/// - Toggle Dark/Light theme
/// - Theme apply cho toàn bộ widget tree bên dưới
/// - Dùng InheritedWidget thuần (không dùng Provider)

library;

import 'package:flutter/material.dart';

/// ===========================================
/// BƯỚC 1: TẠO INHERITED WIDGET
/// ===========================================
/// InheritedWidget là widget cho phép các widget con truy cập
/// data của nó mà không cần truyền qua constructor.
///
/// [Cách hoạt động]
/// 1. InheritedWidget wrap widget tree
/// 2. Widget con dùng .of(context) để lấy data
/// 3. Khi data thay đổi, Flutter tự động rebuild widget con
class ThemeInherited extends InheritedWidget {
  /// Data cần chia sẻ
  final bool isDarkMode;

  /// Callback để thay đổi theme (vì InheritedWidget immutable)
  final VoidCallback toggleTheme;

  const ThemeInherited({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required super.child,
  });

  /// [Static method] Để widget con lấy instance
  /// Pattern: WidgetName.of(context)
  ///
  /// dependOnInheritedWidgetOfExactType:
  /// - Tìm InheritedWidget gần nhất có type ThemeInherited
  /// - Đăng ký widget gọi là "dependent" (sự phụ thuộc) -> sẽ rebuild khi ThemeInherited thay đổi
  static ThemeInherited of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeInherited>();
    assert(
      result != null,
      'ThemeInherited not found in widget tree!',
    ); // <--- Assert chỉ chạy khi debug
    return result!;
  }

  /// [updateShouldNotify] Quyết định việc rebuild
  /// Trả về true = widget con cần rebuild
  /// Trả về false = widget con không cần rebuild
  @override
  bool updateShouldNotify(ThemeInherited oldWidget) {
    // Chỉ rebuild nếu isDarkMode thay đổi
    return isDarkMode != oldWidget.isDarkMode;
  }
}

/// ===========================================
/// BƯỚC 2: TẠO STATEFUL WRAPPER
/// ===========================================
/// Vì InheritedWidget là immutable (bất biến), ta cần StatefulWidget bao ngoài
/// để quản lý state (isDarkMode) và rebuild khi thay đổi.
class ThemeProvider extends StatefulWidget {
  final Widget child; // <--- Child widget là widget con của ThemeProvider
  const ThemeProvider({super.key, required this.child});

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap child với InheritedWidget
    return ThemeInherited(
      isDarkMode: _isDarkMode,
      toggleTheme: _toggleTheme,
      child: widget.child, // <--- widget.child là widget con của ThemeProvider
    );
  }
}

/// ===========================================
/// BƯỚC 3: SỬ DỤNG TRONG APP
/// ===========================================
class Ex02ThemeInherited extends StatelessWidget {
  const Ex02ThemeInherited({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap toàn bộ UI với ThemeProvider
    return ThemeProvider(child: const _ThemeScreen());
  }
}

/// Widget con sử dụng ThemeInherited
class _ThemeScreen extends StatelessWidget {
  const _ThemeScreen();

  @override
  Widget build(BuildContext context) {
    // Lấy theme từ InheritedWidget
    // Không cần truyền qua constructor!
    final theme = ThemeInherited.of(
      context,
    ); // <--- Lấy theme từ InheritedWidget

    return Scaffold(
      backgroundColor: theme.isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        // Title thay đổi theo theme
        title: Text(
          'Ex02: InheritedWidget Theme',
          style: TextStyle(
            color: theme.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        // Icon thay đổi theo theme
        iconTheme: IconThemeData(
          color: theme.isDarkMode ? Colors.white : Colors.black,
        ),
        // Background color thay đổi theo theme
        backgroundColor: theme.isDarkMode ? Colors.grey[800] : Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon thay đổi theo theme
            Icon(
              theme.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              size: 80,
              color: theme.isDarkMode ? Colors.yellow : Colors.orange,
            ),

            const SizedBox(height: 24),

            // Text thay đổi theo theme
            Text(
              theme.isDarkMode ? 'Chế độ Tối' : 'Chế độ Sáng',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.isDarkMode ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 40),

            // Thẻ Card demo
            const _ThemeCard(),

            const SizedBox(height: 40),

            // Toggle button
            ElevatedButton.icon(
              // Gọi hàm toggleTheme từ InheritedWidget
              onPressed: theme.toggleTheme,
              // Icon thay đổi theo theme
              icon: Icon(theme.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              // Text thay đổi theo theme
              label: Text(
                theme.isDarkMode ? 'Bật Light Mode' : 'Bật Dark Mode',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget con khác cũng có thể truy cập theme
/// KHÔNG CẦN truyền isDarkMode qua constructor!
class _ThemeCard extends StatelessWidget {
  const _ThemeCard();

  @override
  Widget build(BuildContext context) {
    // Lấy theme - chứng minh InheritedWidget hoạt động ở mọi level
    final theme = ThemeInherited.of(context);

    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Demo Card',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // <--- Lấy theme.isDarkMode từ InheritedWidget để thay đổi màu chữ
              color: theme.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Card này tự động đổi màu theo theme vì nó lấy isDarkMode từ ThemeInherited.of(context)',
            textAlign: TextAlign.center,
            // <--- Lấy theme.isDarkMode từ InheritedWidget để thay đổi màu nền
            style: TextStyle(
              color: theme.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
