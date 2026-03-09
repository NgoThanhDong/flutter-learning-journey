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
/// CounterNotifier dùng để quản lý state của counter
class CounterNotifier extends ChangeNotifier {
  int _count = 0; // Private variable to store the count
  int get count => _count; // Getter to access the count

  // Hàm tăng counter
  void increment() {
    _count++;
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
  }

  // Hàm giảm counter
  void decrement() {
    if (_count > 0) _count--;
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
  }
}

/// ===========================================
/// NOTIFIER 2: THEME
/// ===========================================
/// ThemeNotifier dùng để quản lý state của theme
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false; // Private variable to store the theme state
  bool get isDark => _isDark; // Getter to access the theme state

  // Hàm toggle theme
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
  }
}

/// ===========================================
/// NOTIFIER 3: USER
/// ===========================================
/// User dùng để lưu thông tin user
class User {
  final String name; // Tên user
  final String email; // Email user
  final String avatar; // Avatar user

  const User({required this.name, required this.email, required this.avatar});
}

/// UserNotifier dùng để quản lý state của user
class UserNotifier extends ChangeNotifier {
  User? _user; // Private variable to store the user
  User? get user => _user; // Getter to access the user
  bool get isLoggedIn => _user != null; // Getter to check if user is logged in

  // Hàm login
  void login(String name, String email) {
    _user = User(
      name: name,
      email: email,
      // Lấy ký tự đầu tiên của tên làm avatar
      avatar: name.isNotEmpty ? name[0].toUpperCase() : '?',
    );
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
  }

  // Hàm logout
  void logout() {
    _user = null;
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
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
      // List các providers được gom lại
      providers: [
        // Provider cho counter
        ChangeNotifierProvider(create: (_) => CounterNotifier()),
        // Provider cho theme
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        // Provider cho user
        ChangeNotifierProvider(create: (_) => UserNotifier()),
      ],
      child: const _ThemedApp(), // Child widget có thể access tất cả providers
    );
  }
}

/// App wrapper để apply theme
class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    // Lấy state từ ThemeNotifier
    // context.watch<T>() sẽ lắng nghe thay đổi của provider T
    // và rebuild widget khi có thay đổi
    final isDark = context.watch<ThemeNotifier>().isDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      // Màn hình chính
      home: const _MultiProviderScreen(),
    );
  }
}

/// ===========================================
/// MAIN SCREEN
/// ===========================================
/// Màn hình chính hiển thị state từ 3 providers
class _MultiProviderScreen extends StatelessWidget {
  const _MultiProviderScreen();

  @override
  Widget build(BuildContext context) {
    // Lấy state từ các providers
    // context.watch<T>() sẽ lắng nghe thay đổi của provider T
    // và rebuild widget khi có thay đổi
    final counter = context.watch<CounterNotifier>();
    final theme = context.watch<ThemeNotifier>();
    final user = context.watch<UserNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex08: MultiProvider'),
        actions: [
          // Theme toggle
          IconButton(
            // Icon thay đổi tùy theo theme
            icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
            // Khi nhấn nút, gọi hàm toggleTheme của ThemeNotifier
            onPressed: () => theme.toggleTheme(),
          ),
        ],
      ),

      // Body hiển thị state từ 3 providers
      // SingleChildScrollView để cho phép cuộn khi nội dung quá dài
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          // CrossAxisAlignment.stretch: stretch các widget con theo chiều ngang
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

                    // Kiểm tra trạng thái đăng nhập
                    // Nếu đã đăng nhập thì hiển thị thông tin user
                    // Nếu chưa đăng nhập thì hiển thị nút login
                    if (user.isLoggedIn) ...[
                      Row(
                        children: [
                          // Avatar của user
                          CircleAvatar(child: Text(user.user!.avatar)),
                          const SizedBox(width: 12),
                          // Thông tin user
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hiển thị tên user
                              Text(
                                user.user!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Hiển thị email user
                              Text(
                                user.user!.email,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Nút logout
                      // Khi nhấn nút, gọi hàm logout của UserNotifier
                      OutlinedButton(
                        onPressed: () => user.logout(),
                        child: const Text('Logout'),
                      ),

                      // Nếu chưa đăng nhập thì hiển thị thông báo và nút login
                    ] else ...[
                      const Text('Chưa đăng nhập'),
                      const SizedBox(height: 12),

                      // Nút login
                      // Khi nhấn nút, gọi hàm _showLoginDialog để hiển thị dialog login
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
                        // Nút giảm
                        // IconButton.filled là một widget button có viền và nền
                        IconButton.filled(
                          // Gọi hàm decrement từ CounterNotifier
                          onPressed: () => counter.decrement(),
                          icon: const Icon(Icons.remove, color: Colors.red),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            side: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            // Hiển thị giá trị count từ CounterNotifier
                            '${counter.count}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Nút tăng
                        // IconButton.filled là một widget button có viền và nền
                        IconButton.filled(
                          // Gọi hàm increment từ CounterNotifier
                          onPressed: () => counter.increment(),
                          icon: const Icon(Icons.add, color: Colors.green),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            side: BorderSide(color: Colors.green, width: 2),
                          ),
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
                    // SwitchListTile là một widget button có viền và nền
                    SwitchListTile(
                      // Đổi icon của thumb theo state
                      thumbIcon: WidgetStatePropertyAll(
                        Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
                      ),
                      title: const Text('Dark Mode'),
                      value: theme.isDark,
                      // Gọi hàm toggleTheme từ ThemeNotifier
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

  /// ===========================================
  /// LOGIN DIALOG
  /// ===========================================
  /// Dialog để nhập thông tin user
  void _showLoginDialog(BuildContext context) {
    // Tạo TextEditingController để lấy dữ liệu từ TextField
    // Controller này sẽ được dispose sau khi dialog đóng
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    // Hiển thị dialog
    showDialog(
      context: context,
      // builder là một callback function nhận dialogContext và trả về Widget dialog
      // dialogContext là context của dialog, khác với context của widget cha
      // dialogContext chỉ tồn tại trong phạm vi của dialog
      // Khi dialog đóng, dialogContext sẽ bị dispose
      builder: (dialogContext) => AlertDialog(
        title: const Text('Login'), // Tiêu đề dialog
        // content là Widget hiển thị nội dung dialog
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController, // Gán controller cho TextField
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController, // Gán controller cho TextField
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),

        // actions là danh sách các button trong dialog
        actions: [
          // Button Cancel
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), // Đóng dialog
            child: const Text('Cancel'),
          ),

          // Button Login
          ElevatedButton(
            onPressed: () {
              // Gọi login method từ UserNotifier
              context.read<UserNotifier>().login(
                // Nếu nameController rỗng thì dùng 'Demo User', ngược lại dùng nameController.text
                nameController.text.isEmpty ? 'Demo User' : nameController.text,
                // Nếu emailController rỗng thì dùng 'demo@example.com', ngược lại dùng emailController.text
                emailController.text.isEmpty
                    ? 'demo@example.com'
                    : emailController.text,
              );
              Navigator.pop(dialogContext); // Đóng dialog
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
