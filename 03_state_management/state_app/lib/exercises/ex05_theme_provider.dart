/// ===========================================
/// EXERCISE 05: THEME VỚI PROVIDER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Áp dụng Provider cho Theme toàn app
/// - Đặt Provider ở level MaterialApp
/// - Hiểu cách theme apply cho tất cả widget
///
/// 📝 Yêu cầu:
/// - Toggle Dark/Light mode
/// - Theme được apply cho toàn bộ app
/// - Sử dụng ChangeNotifierProvider

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// THEME NOTIFIER
/// ===========================================
// Kế thừa ChangeNotifier để thông báo thay đổi
class ThemeNotifier extends ChangeNotifier {
  /// [State] Chế độ theme hiện tại
  ThemeMode _themeMode = ThemeMode.light;

  /// [Getters]
  ThemeMode get themeMode => _themeMode;
  // Kiểm tra xem có phải dark mode không
  bool get isDark => _themeMode == ThemeMode.dark;

  /// [Method] Toggle theme
  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  /// [Method] Set theme cụ thể
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// [Getter] Light theme data
  ThemeData get lightTheme => ThemeData(
    // Brightness là enum, có 2 giá trị: light và dark
    brightness: Brightness.light,
    // ColorScheme.fromSeed() là cách tạo ColorScheme từ một màu seed
    colorScheme: ColorScheme.fromSeed(
      // Màu seed là màu gốc, từ đó tạo ra các màu khác
      seedColor: Colors.indigo,
      // Màu sắc sẽ thay đổi tùy thuộc vào brightness
      brightness: Brightness.light,
    ),
    useMaterial3: true, // Sử dụng Material 3
    // Cấu hình AppBar
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    // Cấu hình Card
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  /// [Getter] Dark theme data
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

/// ===========================================
/// APP VỚI THEME PROVIDER
/// ===========================================
/// [Quan trọng] Provider phải wrap MaterialApp
/// để theme apply cho toàn bộ app
class Ex05ThemeProvider extends StatelessWidget {
  const Ex05ThemeProvider({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider là widget của thư viện provider
    // Nó quản lý state của ThemeNotifier
    // create: (_) => ThemeNotifier() là cách tạo instance của ThemeNotifier
    // (_) là tham số của hàm create, không sử dụng
    // _ThemedApp là widget con sẽ sử dụng state của ThemeNotifier
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const _ThemedApp(),
    );
  }
}

/// Vì cần rebuild MaterialApp khi theme thay đổi,
/// tách ra thành widget riêng với Consumer
class _ThemedApp extends StatelessWidget {
  const _ThemedApp(); // Constructor

  @override
  Widget build(BuildContext context) {
    /// [Consumer] Wrap MaterialApp để rebuild khi theme thay đổi
    return Consumer<ThemeNotifier>(
      // builder là hàm sẽ được gọi khi state thay đổi
      // context là context của widget
      // themeNotifier là instance của ThemeNotifier
      // child là child của widget
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          // MaterialApp là widget gốc của app
          title: 'Theme Provider Demo', // Tiêu đề app
          debugShowCheckedModeBanner: false, // Tắt banner debug
          /// [Theme properties]
          theme: themeNotifier.lightTheme, // Theme sáng
          darkTheme: themeNotifier.darkTheme, // Theme tối
          themeMode: themeNotifier.themeMode, // Chế độ theme
          home: const _ThemeScreen(), // Màn hình chính
        );
      },
    );
  }
}

/// ===========================================
/// THEME SCREEN
/// ===========================================
class _ThemeScreen extends StatelessWidget {
  const _ThemeScreen(); // Constructor

  @override
  Widget build(BuildContext context) {
    // context.watch<ThemeNotifier>() là cách lấy state từ ThemeNotifier
    final theme = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex05: Theme Provider'), // Tiêu đề
        actions: [
          // Toggle button trên app bar
          IconButton(
            // Icon thay đổi tùy thuộc vào chế độ theme
            icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
            // Khi nhấn nút, gọi hàm toggleTheme() của ThemeNotifier
            onPressed: () => theme.toggleTheme(),
          ),
        ],
      ),

      /// [Body] Scrollable content, có thể cuộn khi nội dung vượt quá màn hình
      body: SingleChildScrollView(
        // Widget cho phép cuộn nội dung
        padding: const EdgeInsets.all(16), // Padding cho toàn bộ body
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch column to full width
          children: [
            // Status card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20), // Padding cho card
                child: Column(
                  children: [
                    Icon(
                      // Icon thay đổi tùy thuộc vào chế độ theme
                      theme.isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      size: 64, // Kích thước icon
                      // Màu icon thay đổi tùy thuộc vào chế độ theme
                      color: theme.isDark ? Colors.yellow : Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      // Text thay đổi tùy thuộc vào chế độ theme
                      theme.isDark ? 'Chế độ Tối' : 'Chế độ Sáng',
                      // Style thay đổi tùy thuộc vào chế độ theme
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Theme được quản lý bởi Provider',
                      // Style thay đổi tùy thuộc vào chế độ theme
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Theme mode selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn Theme Mode:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // _ThemeModeOption widget là widget con của _ThemeScreen
                    // Nó hiển thị một option cho theme mode
                    _ThemeModeOption(
                      title: 'Light Mode', // Tiêu đề option
                      icon: Icons.light_mode, // Icon option
                      // isSelected là true nếu theme mode là light
                      isSelected: theme.themeMode == ThemeMode.light,
                      // onTap là hàm sẽ được gọi khi nhấn vào option
                      onTap: () => theme.setThemeMode(ThemeMode.light),
                    ),
                    _ThemeModeOption(
                      title: 'Dark Mode',
                      icon: Icons.dark_mode,
                      isSelected: theme.themeMode == ThemeMode.dark,
                      onTap: () => theme.setThemeMode(ThemeMode.dark),
                    ),
                    _ThemeModeOption(
                      title: 'System Default',
                      icon: Icons.settings_suggest,
                      isSelected: theme.themeMode == ThemeMode.system,
                      onTap: () => theme.setThemeMode(ThemeMode.system),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Demo components
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Demo Components:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Các button demo theme
                    // Wrap là widget hiển thị các widget con theo chiều ngang
                    Wrap(
                      // Khoảng cách giữa các widget con theo chiều ngang
                      spacing: 8,
                      // Khoảng cách giữa các widget con theo chiều dọc
                      runSpacing: 8,
                      children: [
                        // ElevatedButton là widget button có nền và bóng đổ
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Elevated'),
                        ),
                        // FilledButton là widget button có nền và màu sắc nổi bật
                        FilledButton(
                          onPressed: () {},
                          child: const Text('Filled'),
                        ),
                        // OutlinedButton là widget button có viền và không có nền
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Outlined'),
                        ),
                        // TextButton là widget button không có nền và viền
                        TextButton(onPressed: () {}, child: const Text('Text')),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Demo slider
                    // Slider là widget hiển thị thanh trượt
                    Slider(value: 0.5, onChanged: (v) {}),

                    // Demo switch
                    // SwitchListTile là widget hiển thị switch
                    SwitchListTile(
                      title: const Text('Demo Switch'),
                      // value là giá trị của switch
                      value: theme.isDark,
                      // onChanged là hàm sẽ được gọi khi switch được bật/tắt
                      onChanged: (_) => theme.toggleTheme(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tip box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // primaryContainer là màu của container khi background là primary
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Provider Tips',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // onPrimaryContainer là màu của text khi background là primaryContainer
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Provider wrap MaterialApp → theme apply toàn app\n'
                    '• Dùng Consumer để rebuild MaterialApp khi theme đổi\n'
                    '• ThemeData có thể customize rất nhiều',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget cho mỗi theme mode option
class _ThemeModeOption extends StatelessWidget {
  final String title; // Tiêu đề option
  final IconData icon; // Icon option
  final bool isSelected; // True nếu option được chọn
  final VoidCallback onTap; // Hàm được gọi khi nhấn vào option

  const _ThemeModeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // ListTile là widget hiển thị danh sách
      leading: Icon(icon), // Icon hiển thị ở đầu danh sách
      title: Text(title), // Tiêu đề danh sách
      trailing: // Icon hiển thị ở cuối danh sách
          isSelected // True nếu option được chọn
          ? Icon(
              Icons.check_circle,
              // Màu icon bằng màu primary của theme
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap, // Hàm được gọi khi nhấn vào option
      selected: isSelected, // True nếu option được chọn
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
