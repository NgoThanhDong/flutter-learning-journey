/// ===========================================
/// EXERCISE 11: COUNTER VỚI RIVERPOD
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Làm quen với Riverpod
/// - Hiểu sự khác biệt với Provider
/// - Sử dụng StateProvider và ConsumerWidget
///
/// 📝 Yêu cầu:
/// - Counter với StateProvider
/// - Buttons +, -, Reset
/// - ConsumerWidget pattern

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===========================================
/// PROVIDER (GLOBAL)
/// ===========================================
/// [StateProvider] cho state đơn giản (int, String, bool...)
/// Khai báo GLOBAL, bên ngoài class
final counterProvider = StateProvider<int>((ref) => 0);

/// ===========================================
/// MAIN WIDGET
/// ===========================================
/// Vì cần ProviderScope riêng cho exercise này,
/// ta wrap nó trong một MaterialApp riêng
class Ex11CounterRiverpod extends StatelessWidget {
  const Ex11CounterRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    /// [ProviderScope] Thay thế MultiProvider của Provider
    /// Phải wrap ở trên cùng của widget tree
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const _CounterScreen(),
      ),
    );
  }
}

/// ===========================================
/// COUNTER SCREEN
/// ===========================================
/// [ConsumerWidget] Thay thế StatelessWidget khi cần đọc provider
/// - Có thêm parameter `ref` trong build
/// - ref.watch() = lắng nghe + rebuild
/// - ref.read() = chỉ đọc, không rebuild
class _CounterScreen extends ConsumerWidget {
  const _CounterScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🔄 _CounterScreen build');

    /// [ref.watch] Đọc VÀ lắng nghe thay đổi
    /// Widget rebuild khi counter thay đổi
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex11: Riverpod Counter'),
        backgroundColor: Colors.deepPurple.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              /// [ref.invalidate] Reset provider về giá trị ban đầu
              ref.invalidate(counterProvider);
            },
            tooltip: 'Reset (invalidate)',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display count
            Text(
              '$count',
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),
            const Text(
              'Riverpod Counter',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: () {
                    /// [ref.read] Chỉ đọc, KHÔNG lắng nghe
                    /// Dùng trong callbacks
                    final currentCount = ref.read(counterProvider);
                    if (currentCount > 0) {
                      /// [.notifier.state] Cách thay đổi StateProvider
                      ref.read(counterProvider.notifier).state--;
                    }
                  },
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.remove),
                ),

                const SizedBox(width: 24),

                // Increment
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
                  },
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Reset button
            TextButton.icon(
              onPressed: () {
                ref.read(counterProvider.notifier).state = 0;
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),

            const SizedBox(height: 40),

            // Comparison info
            const _RiverpodInfo(),
          ],
        ),
      ),
    );
  }
}

/// ===========================================
/// INFO WIDGET
/// ===========================================
class _RiverpodInfo extends StatelessWidget {
  const _RiverpodInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🆚 Riverpod vs Provider',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Providers là GLOBAL, không cần BuildContext\n'
            '• Dùng ref thay vì context\n'
            '• ConsumerWidget thay StatelessWidget\n'
            '• ref.watch vs ref.read (như watch vs read)',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '// Khai báo provider\n'
              'final counterProvider = StateProvider<int>((ref) => 0);\n\n'
              '// Đọc và lắng nghe\n'
              'final count = ref.watch(counterProvider);\n\n'
              '// Thay đổi\n'
              'ref.read(counterProvider.notifier).state++;',
              style: TextStyle(fontFamily: 'monospace', fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
