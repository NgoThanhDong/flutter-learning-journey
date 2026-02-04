/// ===========================================
/// EXERCISE 12: NESTED ROUTES & SHELL ROUTE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tạo cấu trúc routes lồng nhau
/// - Hiểu khái niệm ShellRoute (hiển thị UI bao bọc)
///
/// 📝 Giải thích:
/// - [routes bên trong GoRoute]: Tạo URL con (vd: /settings/profile).
/// - [ShellRoute]: Giữ một UI cố định (như Scaffold bao ngoài) trong khi nội dung bên trong thay đổi.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Ex12NestedRoutes là widget để demo Nested Routes & ShellRoute
class Ex12NestedRoutes extends StatelessWidget {
  const Ex12NestedRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    /// [GoRouter]: Tạo router chính với cấu trúc routes.
    /// [initialLocation]: URL ban đầu khi mở app.
    /// [routes]: Danh sách các routes.
    /// [ShellRoute]: Tạo layout bao bọc (Wrapper) cho các routes con.
    /// [builder]: Tạo UI bao bọc (Wrapper) cho các routes con.
    /// [routes bên trong ShellRoute]: Tạo URL con (vd: /settings/profile).
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        /// [ShellRoute]
        /// Tạo một layout bao bọc (Wrapper) cho các routes con.
        /// Thường dùng cho Navigation Bar, Drawer, hoặc layout chung.
        ShellRoute(
          builder: (context, state, child) {
            // Wrapper UI: Scaffold với Bottom chung
            // child: Widget con hiện tại (Home hoặc Settings)
            return MyShellLayout(child: child);
          },
          routes: [
            /// [GoRoute]: Tạo route con.
            /// [path]: URL con.
            /// [builder]: Tạo UI cho route con.
            /// [routes bên trong GoRoute]: Tạo sub-routes (routes con).
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              // Sub-routes của Settings
              routes: [
                GoRoute(
                  path:
                      'profile', // URL thành: /settings/profile (không có / ở đầu sub-route)
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    /// [MaterialApp.router]: Tạo app với router.
    /// [routerConfig]: Tạo router.
    /// [debugShowCheckedModeBanner]: Hiển thị banner debug.
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Layout bao bọc
class MyShellLayout extends StatelessWidget {
  final Widget child; // Widget con hiện tại (Home hoặc Settings)

  const MyShellLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex12: Shell Route')),
      body: child, // Nội dung thay đổi ở đây
      /// [bottomNavigationBar]: Tạo bottom navigation bar.
      /// [items]: Danh sách các item trong bottom navigation bar.
      /// [onTap]: Logic khi click vào item.
      /// [context.go]: Chuyển đến route con.
      /// [index]: Chỉ số của item được click.
      /// [context]: Context của widget.
      /// [state]: State của widget.
      /// [child]: Widget con hiện tại (Home hoặc Settings).
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          // Item Home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // Item Settings
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        // Logic navigation đơn giản để demo
        onTap: (index) {
          // Chuyển đến route con
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/settings');
        },
      ),
    );
  }
}

/// HomeScreen là widget hiển thị màn hình Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen 🏠', style: TextStyle(fontSize: 24)),
    );
  }
}

/// SettingsScreen là widget hiển thị màn hình Settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Settings Screen ⚙️', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            // Chuyển đến ProfileScreen (nested route)
            onPressed: () => context.go('/settings/profile'),
            child: const Text('Go to Profile (Nested) 👉'),
          ),
        ],
      ),
    );
  }
}

/// ProfileScreen là widget hiển thị màn hình Profile
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 80, color: Colors.blue),
          const SizedBox(height: 10),
          const Text('My Profile', style: TextStyle(fontSize: 24)),
          const Text('Path: /settings/profile'),
          const SizedBox(height: 20),
          OutlinedButton(
            // Chuyển đến SettingsScreen
            onPressed: () => context.go('/settings'),
            child: const Text('Back to Settings'),
          ),
        ],
      ),
    );
  }
}
