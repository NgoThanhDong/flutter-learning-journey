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
class AppThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.blue;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  // Available colors
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

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
  );

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
class Ex16ThemeSwitcher extends StatelessWidget {
  const Ex16ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppThemeNotifier(),
      child: const _ThemedApp(),
    );
  }
}

class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Theme Switcher',
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.themeMode,
          home: const _SettingsScreen(),
        );
      },
    );
  }
}

/// ===========================================
/// SETTINGS SCREEN
/// ===========================================
class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppThemeNotifier>();
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
                  Wrap(
                    spacing: 8,
                    children: [
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
            child: RadioGroup<ThemeMode>(
              groupValue: theme.themeMode,
              onChanged: (value) => theme.setThemeMode(value!),
              child: Column(
                children: [
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
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: AppThemeNotifier.availableColors.map((color) {
                  final isSelected = theme.seedColor == color;
                  return GestureDetector(
                    onTap: () => theme.setSeedColor(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: colorScheme.onSurface, width: 3)
                            : null,
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
                  SwitchListTile(
                    title: const Text('Demo Switch'),
                    value: true,
                    onChanged: (_) {},
                    contentPadding: EdgeInsets.zero,
                  ),
                  Slider(value: 0.5, onChanged: (_) {}),
                  LinearProgressIndicator(value: 0.7),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
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
