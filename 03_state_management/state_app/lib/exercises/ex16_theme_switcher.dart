/// ===========================================
/// EXERCISE 16: THEME SWITCHER (Practice)
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Theme management đầy đủ
/// - Toggle Dark/Light + Primary color
/// - Provider áp dụng vào MaterialApp

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// THEME NOTIFIER
/// ===========================================
/// [AppThemeNotifier] là class để quản lý state của theme
class AppThemeNotifier extends ChangeNotifier {
  /// [themeMode] là mode của theme (system, light, dark)
  ThemeMode _themeMode = ThemeMode.system;

  /// [seedColor] là màu sắc của theme
  Color _seedColor = Colors.blue;

  /// [themeMode] là getter của [themeMode]
  ThemeMode get themeMode => _themeMode;

  /// [seedColor] là getter của [seedColor]
  Color get seedColor => _seedColor;

  // Available colors
  /// [availableColors] là list các màu sắc có sẵn
  static final List<Color> availableColors = [
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.cyan,
  ];

  /// [setThemeMode] là setter của [themeMode]
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// [setSeedColor] là setter của [seedColor]
  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }

  /// [lightTheme] là theme của mode light
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
  );

  /// [darkTheme] là theme của mode dark
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );
}

/// ===========================================
/// APP
/// ===========================================
/// [Ex16ThemeSwitcher] là widget chính của app
class Ex16ThemeSwitcher extends StatelessWidget {
  const Ex16ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    /// [ChangeNotifierProvider] là widget để cung cấp [AppThemeNotifier] cho toàn app
    /// - [create] là callback để tạo instance của [AppThemeNotifier]
    /// - [child] là widget con để cung cấp [AppThemeNotifier]
    return ChangeNotifierProvider(
      create: (_) => AppThemeNotifier(),
      child: const _ThemedApp(),
    );
  }
}

/// [ThemedApp] là widget để hiển thị app
class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    /// [Consumer] là widget để consume [AppThemeNotifier]
    /// - [builder] là callback để build UI dựa trên state của [AppThemeNotifier]
    return Consumer<AppThemeNotifier>(
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Theme Switcher',
          theme: theme.lightTheme,

          /// [lightTheme] là theme của mode light
          darkTheme: theme.darkTheme,

          /// [darkTheme] là theme của mode dark
          themeMode: theme.themeMode,

          /// [themeMode] là mode của theme
          home: const _SettingsScreen(),
        );
      },
    );
  }
}

/// ===========================================
/// SETTINGS SCREEN
/// ===========================================
/// [SettingsScreen] là widget để hiển thị settings
class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    /// [context.watch<AppThemeNotifier>()] là callback để build UI dựa trên state của [AppThemeNotifier]
    final theme = context.watch<AppThemeNotifier>();

    /// [Theme.of(context).colorScheme] là color scheme của theme
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('🎨 Theme Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// [colorScheme.primary] là màu primary của theme
                  Icon(Icons.palette, size: 64, color: colorScheme.primary),

                  const SizedBox(height: 12),
                  Text(
                    'Theme Preview',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'This card shows your current theme settings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),

                  const SizedBox(height: 16),

                  /// [Wrap] là widget để wrap các widget con theo chiều ngang
                  Wrap(
                    spacing: 8, // Khoảng cách giữa các widget con
                    children: [
                      /// [FilledButton] là button được tô màu
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Filled'),
                      ),

                      /// [OutlinedButton] là button có viền
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Outlined'),
                      ),

                      /// [TextButton] là button không có viền và không được tô màu
                      TextButton(onPressed: () {}, child: const Text('Text')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Theme Mode Section
          Text(
            'Theme Mode',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            // [RadioGroup] là widget để chọn giá trị từ các giá trị có sẵn
            child: RadioGroup<ThemeMode>(
              groupValue: theme.themeMode, // Giá trị hiện tại
              // Callback khi thay đổi giá trị
              onChanged: (value) => theme.setThemeMode(value!),
              child: Column(
                children: [
                  // [RadioListTile] là widget để chọn giá trị từ các giá trị có sẵn
                  RadioListTile<ThemeMode>(
                    title: const Text('System'),
                    subtitle: const Text('Follow system settings'),
                    value: ThemeMode.system,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    subtitle: const Text('Always use light theme'),
                    value: ThemeMode.light,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    subtitle: const Text('Always use dark theme'),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Color Section
          Text(
            'Primary Color',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              // [Wrap] là widget để wrap các widget con theo chiều ngang
              child: Wrap(
                spacing:
                    12, // khoảng cách ngang giữa các item trong cùng 1 hàng
                runSpacing: 12, // khoảng cách dọc giữa các hàng (run)
                // [AppThemeNotifier.availableColors] là list các màu có sẵn
                children: AppThemeNotifier.availableColors.map((color) {
                  // [theme.seedColor] là màu primary của theme
                  final isSelected = theme.seedColor == color;

                  // [GestureDetector] là widget để detect các gesture
                  // [onTap] là callback khi người dùng tap vào widget
                  // [AnimatedContainer] là widget để animate các thay đổi trong widget
                  return GestureDetector(
                    onTap: () => theme.setSeedColor(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        // [Border] là widget để add border cho widget
                        // [Border.all] là widget để add border cho widget
                        // colorScheme.onSurface là màu của theme
                        border: isSelected
                            ? Border.all(color: colorScheme.onSurface, width: 3)
                            : null,
                        // [BoxShadow] là widget để add shadow cho widget
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Demo Components
          Text(
            'Demo Components',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Text Field',
                      hintText: 'Enter something...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // [SwitchListTile] là widget để tạo công tắc
                  SwitchListTile(
                    title: const Text('Demo Switch'),
                    value: true,
                    onChanged: (_) {},
                    contentPadding: EdgeInsets.zero,
                  ),

                  // [Slider] là widget để tạo thanh trượt
                  Slider(value: 0.5, onChanged: (_) {}),

                  // [LinearProgressIndicator] là widget để tạo thanh tiến trình
                  LinearProgressIndicator(value: 0.7),

                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      // Chip, ActionChip, FilterChip đều là Material widget nhỏ gọn dùng để hiển thị thông tin dạng (tag)
                      // Chip – chỉ để hiển thị
                      // ActionChip – hiển thị + có thể bấm để thực hiện hành động
                      // FilterChip – hiển thị + có thể bấm để chọn/bỏ chọn (giống checkbox/radio)
                      Chip(label: const Text('Chip')),
                      ActionChip(label: const Text('Action'), onPressed: () {}),
                      FilterChip(
                        label: const Text('Filter'),
                        selected: true,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
