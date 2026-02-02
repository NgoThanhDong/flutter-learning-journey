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
class ThemeNotifier extends ChangeNotifier {
  /// [State] Chế độ theme hiện tại
  ThemeMode _themeMode = ThemeMode.light;

  /// [Getters]
  ThemeMode get themeMode => _themeMode;
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
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
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
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const _ThemedApp(),
    );
  }
}

/// Vì cần rebuild MaterialApp khi theme thay đổi,
/// tách ra thành widget riêng với Consumer
class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    /// [Consumer] Wrap MaterialApp để rebuild khi theme thay đổi
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Theme Provider Demo',
          debugShowCheckedModeBanner: false,

          /// [Theme properties]
          theme: themeNotifier.lightTheme,
          darkTheme: themeNotifier.darkTheme,
          themeMode: themeNotifier.themeMode,
          home: const _ThemeScreen(),
        );
      },
    );
  }
}

/// ===========================================
/// THEME SCREEN
/// ===========================================
class _ThemeScreen extends StatelessWidget {
  const _ThemeScreen();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex05: Theme Provider'),
        actions: [
          // Toggle button trên app bar
          IconButton(
            icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => theme.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      theme.isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      size: 64,
                      color: theme.isDark ? Colors.yellow : Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      theme.isDark ? 'Chế độ Tối' : 'Chế độ Sáng',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Theme được quản lý bởi Provider',
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
                    _ThemeModeOption(
                      title: 'Light Mode',
                      icon: Icons.light_mode,
                      isSelected: theme.themeMode == ThemeMode.light,
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Elevated'),
                        ),
                        FilledButton(
                          onPressed: () {},
                          child: const Text('Filled'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Outlined'),
                        ),
                        TextButton(onPressed: () {}, child: const Text('Text')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Demo slider
                    Slider(value: 0.5, onChanged: (v) {}),
                    // Demo switch
                    SwitchListTile(
                      title: const Text('Demo Switch'),
                      value: theme.isDark,
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
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
      selected: isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
