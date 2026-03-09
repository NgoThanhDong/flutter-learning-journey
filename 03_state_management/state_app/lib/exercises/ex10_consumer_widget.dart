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
/// CounterNotifier kế thừa ChangeNotifier để có thể thông báo cho các widget lắng nghe
class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  /// Method để tăng giá trị counter
  /// Khi gọi method này, state sẽ thay đổi và các widget lắng nghe sẽ được thông báo để rebuild
  void increment() {
    _count++;
    notifyListeners(); // Thông báo cho các widget lắng nghe biết state đã thay đổi
  }
}

/// ===========================================
/// APP VỚI PROVIDER
/// ===========================================
/// Ex10ConsumerWidget là widget chính của ứng dụng
/// Nó sử dụng ChangeNotifierProvider để cung cấp CounterNotifier cho các widget con
class Ex10ConsumerWidget extends StatelessWidget {
  const Ex10ConsumerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider là một widget provider
    // Nó cung cấp CounterNotifier cho các widget con
    return ChangeNotifierProvider(
      create: (_) => CounterNotifier(), // Tạo CounterNotifier
      child: const _ConsumerScreen(), // Widget con lắng nghe CounterNotifier
    );
  }
}

/// ===========================================
/// MAIN SCREEN
/// ===========================================
/// _ConsumerScreen là widget con lắng nghe CounterNotifier
class _ConsumerScreen extends StatelessWidget {
  const _ConsumerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex10: Consumer Child'),
        backgroundColor: Colors.cyan.shade100,
      ),

      // SingleChildScrollView để cuộn khi nội dung quá dài
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
            const _BadExample(), // Widget không tối ưu

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
            const _GoodExample(), // Widget tối ưu

            const SizedBox(height: 24),

            // Increment button
            // Consumer<CounterNotifier> là widget lắng nghe CounterNotifier
            Consumer<CounterNotifier>(
              builder: (context, counter, _) {
                // ElevatedButton.icon là widget lắng nghe CounterNotifier
                // Nó sẽ rebuild khi state thay đổi
                return ElevatedButton.icon(
                  // Khi nhấn nút, state sẽ thay đổi và các widget lắng nghe sẽ được thông báo để rebuild
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
/// _BadExample là widget không tối ưu
/// Nó sử dụng [Consumer<CounterNotifier>] để lắng nghe CounterNotifier
/// Nhưng nó không sử dụng child parameter
/// Do đó, mọi thứ trong builder đều rebuild khi state thay đổi
class _BadExample extends StatelessWidget {
  const _BadExample();

  @override
  Widget build(BuildContext context) {
    return Card(
      // Consumer<CounterNotifier> là widget lắng nghe CounterNotifier
      child: Consumer<CounterNotifier>(
        /// [builder CHO TẤT CẢ]
        /// Mọi thứ trong builder đều rebuild khi state thay đổi
        builder: (context, counter, child) {
          debugPrint('❌ BadExample Consumer rebuild');

          return Column(
            children: [
              // Heavy widget NẰM TRONG builder → REBUILD mỗi lần
              // Sử dụng const để tối ưu, không dùng const thì sẽ rebuild mỗi lần
              // const _HeavyWidget(label: 'Bad'),
              _HeavyWidget(label: 'Bad'),

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
/// _GoodExample là widget tối ưu
/// Nó sử dụng [Consumer<CounterNotifier>] để lắng nghe CounterNotifier
/// Nhưng nó sử dụng child parameter
/// Do đó, [child] KHÔNG rebuild khi state thay đổi
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
        // Sử dụng gradient để tăng độ phức tạp
        // LinearGradient dùng để tạo hiệu ứng chuyển màu
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.purple.shade300],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Animated icon (expensive to rebuild)
          // TweenAnimationBuilder dùng để tạo hiệu ứng chuyển động
          TweenAnimationBuilder<double>(
            // Tạo hiệu ứng chuyển động từ 0 đến 1
            tween: Tween(begin: 0, end: 1),
            // Thời gian chuyển động
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              // Transform.rotate dùng để tạo hiệu ứng xoay
              return Transform.rotate(
                angle: value * 2 * 3.14159, // angle là góc xoay
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
/// _CodeComparison là widget so sánh code
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

          Row(
            children: [
              // Expanded là widget để chia sẻ không gian cho các widget con
              Expanded(
                child: Container(
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
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Container(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
