/// ===========================================
/// EXERCISE 15: BOTTOM NAVIGATION VỚI GO ROUTER
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xây dựng app có Bottom Navigation Bar giữ trạng thái (Stateful)
/// - Sử dụng [StatefulShellRoute.indexedStack]
///
/// 📝 Giải thích:
/// - Khác với ShellRoute thông thường (reset state khi chuyển tab),
/// - StatefulShellRoute dùng IndexedStack để giữ nguyên hiện trạng của từng tab.
/// - Đây là pattern chuẩn cho App có Bottom Bar xịn.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Ex15BottomNavRouter extends StatelessWidget {
  const Ex15BottomNavRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        /// [StatefulShellRoute.indexedStack]
        /// Loại route đặc biệt để quản lý các branches (nhánh) tabs
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            // Branch 1: Home
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomeTab(),
                ),
              ],
            ),
            // Branch 2: Search
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/search',
                  builder: (context, state) => const SearchTab(),
                ),
              ],
            ),
            // Branch 3: Profile
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfileTab(),
                  routes: [
                    // Sub-route vẫn hoạt động trong tab Profile
                    GoRoute(
                      path: 'settings',
                      builder: (context, state) => const SettingsScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    );
  }
}

/// [Scaffold chứa BottomNavigationBar]
/// Nhận vào navigationShell để điều khiển việc chuyển tab
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when clicking the bottom bar item:
      // if already in the tab, go to the initial location of that branch
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Search', icon: Icon(Icons.search)),
          NavigationDestination(label: 'Profile', icon: Icon(Icons.person)),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

/// [Các màn hình Tabs]
/// Thử scroll list ở Home, sau đó chuyển tab và quay lại -> Vị trí scroll vẫn còn!
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Tab')),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) => ListTile(
          title: Text('Home Item $index'),
          leading: const Icon(Icons.article),
        ),
      ),
    );
  }
}

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  int _counter = 0; // State nội tại được giữ nguyên

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Search Counter (State Preserved):'),
            Text('$_counter', style: Theme.of(context).textTheme.displayLarge),
            ElevatedButton(
              onPressed: () => setState(() => _counter++),
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/profile/settings'),
              child: const Text('Open Settings (Nested Push)'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen (Inside Profile Tab)')),
    );
  }
}
