/// ===========================================
/// EXERCISE 05: THEME CUBIT
/// ===========================================
/// 🎯 Mục tiêu:
/// - Quản lý ThemeMode (Light/Dark) bằng Cubit
/// - Sử dụng BlocBuilder để bao bọc MaterialApp
/// - Hiểu cách thay đổi Global State
///
/// 📝 Lưu ý:
/// - MaterialApp thường được rebuild khi theme thay đổi
/// - State ở đây là enum ThemeMode (system, light, dark)

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. DEFINE CUBIT
class ThemeCubit extends Cubit<ThemeMode> {
  /// Mặc định dùng System theme
  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme() {
    debugPrint("Current theme: $state");
    // Logic toggle đơn giản: Light <-> Dark
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  void setSystem() => emit(ThemeMode.system);
  void setLight() => emit(ThemeMode.light);
  void setDark() => emit(ThemeMode.dark);
}

/// 2. APP ROOT
/// Để thay đổi Theme của toàn bộ App, BlocProvider phải đặt TRÊN MaterialApp
class Ex05ThemeCubit extends StatelessWidget {
  const Ex05ThemeCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const _ThemedApp(),
    );
  }
}

/// Widget riêng để lắng nghe ThemeCubit
class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    // Lắng nghe state (ThemeMode) thay đổi
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: const ThemeHomePage(),
        );
      },
    );
  }
}

/// 3. UI PAGE
class ThemeHomePage extends StatelessWidget {
  const ThemeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy cubit (không listen vì chỉ cần gọi hàm)
    final themeCubit = context.read<ThemeCubit>();

    // Lấy state hiện tại (nếu cần hiển thị) - dùng watch để rebuild khi state đổi
    final currentTheme = context.select((ThemeCubit cubit) => cubit.state);

    return Scaffold(
      appBar: AppBar(title: const Text('Ex05: Theme Cubit')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              currentTheme == ThemeMode.light
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
              size: 100,
              color: currentTheme == ThemeMode.light
                  ? Colors.orange
                  : Colors.blueGrey,
            ),
            const SizedBox(height: 20),
            Text(
              'Current Mode: ${currentTheme.name.toUpperCase()}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Toggle Button
            ElevatedButton.icon(
              onPressed: () => themeCubit.toggleTheme(),
              icon: const Icon(Icons.change_circle),
              label: const Text('Toggle Light/Dark'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Specific Mode Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModeButton(
                    icon: Icons.brightness_auto,
                    label: 'System',
                    isSelected: currentTheme == ThemeMode.system,
                    onTap: themeCubit.setSystem),
                const SizedBox(width: 10),
                _ModeButton(
                    icon: Icons.wb_sunny,
                    label: 'Light',
                    isSelected: currentTheme == ThemeMode.light,
                    onTap: themeCubit.setLight),
                const SizedBox(width: 10),
                _ModeButton(
                    icon: Icons.nightlight_round,
                    label: 'Dark',
                    isSelected: currentTheme == ThemeMode.dark,
                    onTap: themeCubit.setDark),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
      ),
    );
  }
}
