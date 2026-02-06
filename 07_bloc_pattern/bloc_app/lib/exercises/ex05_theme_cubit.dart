/// ============================================================================
/// EXERCISE 05: THEME CUBIT
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Quản lý ThemeMode toàn ứng dụng
/// - Hiểu cách đặt BlocProvider ở root (tức là ở trên cùng)
/// - Sử dụng BlocBuilder để wrap MaterialApp (tức là bao quanh MaterialApp)
///
/// 📝 USE CASE THỰC TẾ:
/// - Dark mode toggle là feature phổ biến
/// - State cần được share toàn app
/// - BlocProvider phải ở trên MaterialApp
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// THEME CUBIT (Cubit quản lý theme)
// ============================================================================
//
// State: ThemeMode enum (light, dark, system)
//
// Tại sao dùng ThemeMode thay vì bool?
// - Flutter có sẵn enum ThemeMode
// - Hỗ trợ 3 modes: light, dark, system
// - Dễ mở rộng (thêm custom themes)
// ============================================================================
class ThemeCubit extends Cubit<ThemeMode> {
  /// Initial state: System theme (theo setting của device)
  ThemeCubit() : super(ThemeMode.system);

  /// Toggle giữa light và dark
  /// Nếu đang system → chuyển sang light
  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  /// Set mode cụ thể
  void setTheme(ThemeMode mode) {
    emit(mode);
  }

  /// Set light mode
  void setLight() => emit(ThemeMode.light);

  /// Set dark mode
  void setDark() => emit(ThemeMode.dark);

  /// Set system mode
  void setSystem() => emit(ThemeMode.system);

  // ============================================================================
  // HELPER GETTER
  // ============================================================================
  //
  // Getter giúp UI dễ dàng check trạng thái
  // Thay vì: state == ThemeMode.dark
  // Có thể: cubit.isDark
  // ============================================================================
  bool get isDark => state == ThemeMode.dark;
  bool get isLight => state == ThemeMode.light;
  bool get isSystem => state == ThemeMode.system;
}

// ============================================================================
// MAIN WIDGET - ENTRY POINT (Widget chính - điểm bắt đầu)
// ============================================================================
//
// ⚠️ QUAN TRỌNG: BlocProvider PHẢI ở trên MaterialApp
//
// Tại sao?
// - MaterialApp là nơi define theme
// - BlocBuilder cần wrap MaterialApp để thay đổi themeMode
// - Nếu đặt trong MaterialApp, không thể thay đổi theme của chính nó
// ============================================================================
class Ex05ThemeCubit extends StatelessWidget {
  const Ex05ThemeCubit({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider ở trên MaterialApp (tức là ở trên cùng)
    return BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(),
      child: const _ThemedApp(),
    );
  }
}

// ============================================================================
// THEMED APP (Ứng dụng có theme)
// ============================================================================
//
// Widget này wrap MaterialApp với BlocBuilder
// Mỗi khi ThemeCubit emit state mới, MaterialApp rebuild với theme mới
// ============================================================================
class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    // BlocBuilder wrap MaterialApp
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Theme Cubit Demo',

          // ================================================================
          // THEME CONFIGURATION (Cấu hình theme)
          // ================================================================
          //
          // themeMode: Quyết định dùng theme nào
          // - ThemeMode.light: Dùng theme
          // - ThemeMode.dark: Dùng darkTheme
          // - ThemeMode.system: Theo setting của device
          //
          // theme: Light theme definition
          // darkTheme: Dark theme definition
          // ================================================================
          themeMode: themeMode,

          // Light theme
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),

          // Dark theme
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),

          home: const _ThemeHomePage(),
        );
      },
    );
  }
}

// ============================================================================
// HOME PAGE (Trang chủ)
// ============================================================================
class _ThemeHomePage extends StatelessWidget {
  const _ThemeHomePage();

  @override
  Widget build(BuildContext context) {
    // Lấy ThemeCubit để check state
    final themeCubit = context.watch<ThemeCubit>();
    // isDark: check theme hiện tại có phải là dark không
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex05: Theme Cubit'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ================================================================
              // THEME ICON
              // ================================================================
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                size: 100,
                color: isDark ? Colors.amber : Colors.orange,
              ),

              const SizedBox(height: 24),

              // Current mode
              Text(
                'Current: ${themeCubit.state.name.toUpperCase()}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 40),

              // ================================================================
              // TOGGLE BUTTON (Nút chuyển đổi theme)
              // ================================================================
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                label: Text(isDark ? 'Switch to Light' : 'Switch to Dark'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // MODE SELECTION (Chọn chế độ theme)
              // ================================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Theme Mode:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // ======================================================
                    // RADIO BUTTONS (Nút radio)
                    // ======================================================
                    // _ThemeModeRadio là widget con để hiển thị radio button
                    _ThemeModeRadio(
                      value: ThemeMode.light,
                      groupValue: themeCubit.state,
                      onChanged: (mode) =>
                          context.read<ThemeCubit>().setTheme(mode!),
                      icon: Icons.light_mode,
                      label: 'Light',
                    ),
                    _ThemeModeRadio(
                      value: ThemeMode.dark,
                      groupValue: themeCubit.state,
                      onChanged: (mode) =>
                          context.read<ThemeCubit>().setTheme(mode!),
                      icon: Icons.dark_mode,
                      label: 'Dark',
                    ),
                    _ThemeModeRadio(
                      value: ThemeMode.system,
                      groupValue: themeCubit.state,
                      onChanged: (mode) =>
                          context.read<ThemeCubit>().setTheme(mode!),
                      icon: Icons.settings_suggest,
                      label: 'System',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ================================================================
              // SAMPLE WIDGETS (Các widget mẫu)
              // ================================================================
              const Text(
                'Sample Widgets (auto-themed):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('John Doe'),
                        subtitle: const Text('john@example.com'),
                        // Switch để toggle theme
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) =>
                              context.read<ThemeCubit>().toggleTheme(),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {}, child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Save')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM RADIO WIDGET (Widget radio tùy chỉnh)
// ============================================================================
class _ThemeModeRadio extends StatelessWidget {
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode?> onChanged; // Hàm callback khi radio được chọn
  final IconData icon;
  final String label;

  const _ThemeModeRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem radio button này có được chọn không
    final isSelected = value == groupValue;
    // Lấy màu primary từ theme hiện tại
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      // Khi được tap, gọi hàm onChanged với giá trị hiện tại
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Custom radio indicator (avoids deprecated Radio properties)
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
            Icon(icon, color: isSelected ? primaryColor : null),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
