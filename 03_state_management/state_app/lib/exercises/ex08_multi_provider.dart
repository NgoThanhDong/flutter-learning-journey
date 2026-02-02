/// ===========================================
/// EXERCISE 08: MULTI PROVIDER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Sử dụng MultiProvider để quản lý nhiều state
/// - Hiểu cách tổ chức providers trong app thực tế
/// - Kết hợp nhiều notifiers
///
/// 📝 Yêu cầu:
/// - 3 Notifiers: Counter, Theme, User
/// - Dùng MultiProvider gom lại
/// - Hiển thị data từ cả 3 trong 1 screen

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// NOTIFIER 1: COUNTER
/// ===========================================
class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) _count--;
    notifyListeners();
  }
}

/// ===========================================
/// NOTIFIER 2: THEME
/// ===========================================
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

/// ===========================================
/// NOTIFIER 3: USER
/// ===========================================
class User {
  final String name;
  final String email;
  final String avatar;

  const User({required this.name, required this.email, required this.avatar});
}

class UserNotifier extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void login(String name, String email) {
    _user = User(
      name: name,
      email: email,
      avatar: name.isNotEmpty ? name[0].toUpperCase() : '?',
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

/// ===========================================
/// APP VỚI MULTI PROVIDER
/// ===========================================
class Ex08MultiProvider extends StatelessWidget {
  const Ex08MultiProvider({super.key});

  @override
  Widget build(BuildContext context) {
    /// [MultiProvider] Gom nhiều providers lại thành list phẳng
    /// Thay vì nested ChangeNotifierProvider
    ///
    /// ❌ Cách xấu (nested):
    /// ChangeNotifierProvider(
    ///   create: (_) => CounterNotifier(),
    ///   child: ChangeNotifierProvider(
    ///     create: (_) => ThemeNotifier(),
    ///     child: ChangeNotifierProvider(
    ///       create: (_) => UserNotifier(),
    ///       child: MyApp(),
    ///     ),
    ///   ),
    /// )
    ///
    /// ✅ Cách tốt (MultiProvider):
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => UserNotifier()),
      ],
      child: const _ThemedApp(),
    );
  }
}

/// App wrapper để apply theme
class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: const _MultiProviderScreen(),
    );
  }
}

/// ===========================================
/// MAIN SCREEN
/// ===========================================
class _MultiProviderScreen extends StatelessWidget {
  const _MultiProviderScreen();

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterNotifier>();
    final theme = context.watch<ThemeNotifier>();
    final user = context.watch<UserNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex08: MultiProvider'),
        actions: [
          // Theme toggle
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
            // Section 1: User
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(
                          'User State',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (user.isLoggedIn) ...[
                      Row(
                        children: [
                          CircleAvatar(child: Text(user.user!.avatar)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.user!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.user!.email,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => user.logout(),
                        child: const Text('Logout'),
                      ),
                    ] else ...[
                      const Text('Chưa đăng nhập'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _showLoginDialog(context),
                        child: const Text('Login'),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section 2: Counter
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pin),
                        const SizedBox(width: 8),
                        Text(
                          'Counter State',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: () => counter.decrement(),
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '${counter.count}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () => counter.increment(),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section 3: Theme
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.palette),
                        const SizedBox(width: 8),
                        Text(
                          'Theme State',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: theme.isDark,
                      onChanged: (_) => theme.toggleTheme(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 MultiProvider Tips',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Gộp nhiều providers vào 1 list phẳng\n'
                    '• Mỗi provider độc lập, không phụ thuộc\n'
                    '• Thứ tự quan trọng nếu có dependency\n'
                    '• Truy cập bằng context.watch<T>() hoặc context.read<T>()',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserNotifier>().login(
                nameController.text.isEmpty ? 'Demo User' : nameController.text,
                emailController.text.isEmpty
                    ? 'demo@example.com'
                    : emailController.text,
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
