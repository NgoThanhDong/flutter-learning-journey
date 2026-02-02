/// ===========================================
/// EXERCISE 04: COUNTER VỚI PROVIDER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Học cách sử dụng Provider package
/// - Hiểu ChangeNotifier và ChangeNotifierProvider
/// - Phân biệt context.watch vs context.read
///
/// 📝 Yêu cầu:
/// - Counter với nút +, -, Reset
/// - Sử dụng ChangeNotifier để quản lý state
/// - Dùng watch trong build, read trong callbacks

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// BƯỚC 1: TẠO CHANGENOTIFIER
/// ===========================================
/// [ChangeNotifier] là class base để tạo state container.
/// Khi state thay đổi, gọi notifyListeners() để thông báo.
class CounterNotifier extends ChangeNotifier {
  /// [Private state] Dùng underscore để encapsulate
  int _count = 0;

  /// [Getter] Cho phép đọc state từ bên ngoài
  int get count => _count;

  /// [Methods] Thay đổi state và notify
  void increment() {
    _count++;
    notifyListeners(); // 🔔 BẮT BUỘC! Thông báo cho widgets rebuild
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

/// ===========================================
/// BƯỚC 2: CUNG CẤP PROVIDER
/// ===========================================
class Ex04CounterProvider extends StatelessWidget {
  const Ex04CounterProvider({super.key});

  @override
  Widget build(BuildContext context) {
    /// [ChangeNotifierProvider] Wrap widget tree để cung cấp state
    /// - create: Hàm tạo instance của ChangeNotifier
    /// - child: Widget tree có thể truy cập state
    return ChangeNotifierProvider(
      create: (context) => CounterNotifier(),
      child: const _CounterScreen(),
    );
  }
}

/// ===========================================
/// BƯỚC 3: SỬ DỤNG STATE
/// ===========================================
class _CounterScreen extends StatelessWidget {
  const _CounterScreen();

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 _CounterScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex04: Provider Counter'),
        backgroundColor: Colors.purple.shade100,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // [context.watch] Đọc VÀ lắng nghe thay đổi
            // Khi count thay đổi → widget này rebuild
            Consumer<CounterNotifier>( // Chỉ đọc, KHÔNG lắng nghe
              builder: (context, counter, child) {
                debugPrint('🔄 Consumer rebuild, count = ${counter.count}');
                return Text(
                  '${counter.count}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            const Text(
              'Provider Counter',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // [context.read] Chỉ đọc, KHÔNG lắng nghe
                // Dùng trong callbacks vì không cần rebuild
                ElevatedButton(
                  onPressed: () {
                    // Cách 1: context.read
                    context.read<CounterNotifier>().decrement(); // Chỉ đọc, KHÔNG lắng nghe
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.remove, size: 32),
                ),

                const SizedBox(width: 24),

                ElevatedButton(
                  onPressed: () {
                    context.read<CounterNotifier>().increment(); // Chỉ đọc, KHÔNG lắng nghe
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.add, size: 32),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextButton.icon(
              onPressed: () => context.read<CounterNotifier>().reset(), // Chỉ đọc, KHÔNG lắng nghe
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),

            const SizedBox(height: 40),

            // Widget riêng để demo watch vs read
            const _WatchReadDemo(),
          ],
        ),
      ),
    );
  }
}

/// Demo sự khác biệt giữa watch và read
class _WatchReadDemo extends StatelessWidget {
  const _WatchReadDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 Tip: watch vs read',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• context.watch<T>() → Dùng trong build(), cần rebuild'),
          const Text(
            '• context.read<T>() → Dùng trong callbacks, không rebuild',
          ),
          const SizedBox(height: 12),

          // Demo: Dùng watch trong build
          Builder( // Builder widget để tránh rebuild
            builder: (context) {
              // Không cần rebuild khi count thay đổi
              final count = context.watch<CounterNotifier>().count; // Lắng nghe thay đổi
              return Text(
                'Count hiện tại (watch): $count', // Chỉ đọc state
                style: const TextStyle(color: Colors.purple),
              );
            },
          ),
        ],
      ),
    );
  }
}
