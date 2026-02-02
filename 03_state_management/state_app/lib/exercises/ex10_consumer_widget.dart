/// ===========================================
/// EXERCISE 10: CONSUMER VỚI CHILD
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Hiểu cách tối ưu với Consumer child parameter
/// - Widget không đổi tái sử dụng, không rebuild
/// - So sánh performance có/không có child
///
/// 📝 Yêu cầu:
/// - Counter với heavy animation widget
/// - Sử dụng Consumer child để tối ưu
/// - Verify bằng debug print

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// COUNTER NOTIFIER
/// ===========================================
class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

/// ===========================================
/// APP VỚI PROVIDER
/// ===========================================
class Ex10ConsumerWidget extends StatelessWidget {
  const Ex10ConsumerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterNotifier(),
      child: const _ConsumerScreen(),
    );
  }
}

/// ===========================================
/// MAIN SCREEN
/// ===========================================
class _ConsumerScreen extends StatelessWidget {
  const _ConsumerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex10: Consumer Child'),
        backgroundColor: Colors.cyan.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Explanation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.cyan.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 Consumer với child parameter'),
                  SizedBox(height: 8),
                  Text(
                    'Parameter "child" trong Consumer là widget KHÔNG rebuild.\n'
                    'Chỉ phần trong builder mới rebuild khi state thay đổi.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // BAD Example
            const Text(
              '❌ Cách KHÔNG tối ưu:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),
            const _BadExample(),

            const SizedBox(height: 24),

            // GOOD Example
            const Text(
              '✅ Cách tối ưu (dùng child):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const _GoodExample(),

            const SizedBox(height: 24),

            // Increment button
            Consumer<CounterNotifier>(
              builder: (context, counter, _) {
                return ElevatedButton.icon(
                  onPressed: () => counter.increment(),
                  icon: const Icon(Icons.add),
                  label: Text('Increment (Count: ${counter.count})'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Code comparison
            const _CodeComparison(),
          ],
        ),
      ),
    );
  }
}

/// ===========================================
/// BAD EXAMPLE - KHÔNG DÙNG CHILD
/// ===========================================
class _BadExample extends StatelessWidget {
  const _BadExample();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<CounterNotifier>(
        /// [builder CHO TẤT CẢ]
        /// Mọi thứ trong builder đều rebuild khi state thay đổi
        builder: (context, counter, child) {
          debugPrint('❌ BadExample Consumer rebuild');

          return Column(
            children: [
              // Heavy widget NẰM TRONG builder → REBUILD mỗi lần
              const _HeavyWidget(label: 'Bad'),

              const SizedBox(height: 8),

              Text(
                'Count: ${counter.count}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ===========================================
/// GOOD EXAMPLE - DÙNG CHILD
/// ===========================================
class _GoodExample extends StatelessWidget {
  const _GoodExample();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<CounterNotifier>(
        /// [child] Widget này được build MỘT LẦN DUY NHẤT
        /// Khi state thay đổi, child KHÔNG rebuild
        child: const _HeavyWidget(label: 'Good'),

        builder: (context, counter, child) {
          debugPrint('✅ GoodExample Consumer rebuild');

          return Column(
            children: [
              // Heavy widget KHÔNG NẰM TRONG builder
              // Nó được truyền vào qua parameter child
              child!, // Tái sử dụng widget đã build

              const SizedBox(height: 8),

              Text(
                'Count: ${counter.count}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ===========================================
/// HEAVY WIDGET (Simulated)
/// ===========================================
/// Widget giả lập việc build phức tạp/tốn kém
class _HeavyWidget extends StatelessWidget {
  final String label;

  const _HeavyWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    debugPrint('🏋️ _HeavyWidget ($label) build - This is expensive!');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.purple.shade300],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Animated icon (expensive to rebuild)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * 3.14159,
                child: const Icon(Icons.star, color: Colors.white, size: 32),
              );
            },
          ),
          const SizedBox(width: 16),
          Text(
            'Heavy Widget ($label)',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// CODE COMPARISON
/// ===========================================
class _CodeComparison extends StatelessWidget {
  const _CodeComparison();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 Code Comparison:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '❌ BAD:\nConsumer(\n  builder: (ctx, state, child) {\n    return Column(\n      children: [\n        HeavyWidget(), // Rebuild mỗi lần!\n        Text(state.value),\n      ],\n    );\n  },\n)',
              style: TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '✅ GOOD:\nConsumer(\n  child: HeavyWidget(), // Build 1 lần!\n  builder: (ctx, state, child) {\n    return Column(\n      children: [\n        child!, // Tái sử dụng\n        Text(state.value),\n      ],\n    );\n  },\n)',
              style: TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
