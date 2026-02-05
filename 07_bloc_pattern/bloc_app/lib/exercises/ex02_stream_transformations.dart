/// ============================================================================
/// EXERCISE 02: STREAM TRANSFORMATIONS
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu các operators để transform stream data
/// - Biết cách sử dụng map, where, distinct, expand
/// - Hiểu Stream pipeline (chuỗi xử lý)
///
/// 📝 CÁC OPERATORS PHỔ BIẾN:
/// - map(): Biến đổi mỗi giá trị
/// - where(): Lọc theo điều kiện
/// - distinct(): Loại bỏ giá trị trùng liên tiếp
/// - take(n): Lấy n giá trị đầu tiên
/// - skip(n): Bỏ qua n giá trị đầu tiên
/// - expand(): Biến 1 giá trị thành nhiều giá trị
///
/// ============================================================================
library;

import 'dart:async';
import 'package:flutter/material.dart';

class Ex02StreamTransformations extends StatefulWidget {
  const Ex02StreamTransformations({super.key});

  @override
  State<Ex02StreamTransformations> createState() =>
      _Ex02StreamTransformationsState();
}

class _Ex02StreamTransformationsState extends State<Ex02StreamTransformations> {
  // Controller gốc - emit các số nguyên
  final StreamController<int> _inputController =
      StreamController<int>.broadcast();

  // Danh sách log để hiển thị quá trình transform
  final List<String> _logs = [];

  // StreamSubscription để có thể cancel khi dispose
  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    super.initState();
    _setupTransformedStream();
  }

  // ============================================================================
  // STREAM TRANSFORMATION PIPELINE
  // ============================================================================
  //
  // Pipeline = Chuỗi các operators xử lý tuần tự
  //
  // Input: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
  //   ↓ where (chẵn)
  // Filtered: 2, 4, 6, 8, 10
  //   ↓ map (*10)
  // Mapped: 20, 40, 60, 80, 100
  //   ↓ distinct
  // Final: 20, 40, 60, 80, 100 (loại bỏ trùng)
  // ============================================================================
  void _setupTransformedStream() {
    _subscription = _inputController.stream
        // ================================================================
        // WHERE: Lọc theo điều kiện
        // ================================================================
        // Chỉ giữ lại các số chẵn
        // Tương tự: List.where() hoặc SQL WHERE
        .where((number) {
          final isEven = number.isEven;
          _addLog(
              '📥 Input: $number → ${isEven ? "✅ Chẵn (giữ)" : "❌ Lẻ (bỏ)"}');
          return isEven;
        })

        // ================================================================
        // MAP: Biến đổi giá trị
        // ================================================================
        // Nhân mỗi số với 10
        // Input: 2 → Output: 20
        .map((number) {
          final result = number * 10;
          _addLog('🔄 Map: $number × 10 = $result');
          return result;
        })

        // ================================================================
        // DISTINCT: Loại bỏ giá trị trùng liên tiếp
        // ================================================================
        // [10, 10, 20, 20, 20, 30] → [10, 20, 30]
        // Lưu ý: Chỉ loại bỏ LIÊN TIẾP, không phải tất cả
        .distinct()

        // ================================================================
        // LISTEN: Nhận kết quả cuối cùng
        // ================================================================
        .listen((value) {
          _addLog('✨ Output: $value');
          _addLog('─────────────────');
        });
  }

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
      // Giới hạn 50 logs để tránh overflow
      if (_logs.length > 50) {
        _logs.removeAt(0);
      }
    });
  }

  void _addNumber(int number) {
    _inputController.sink.add(number);
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _inputController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex02: Stream Transformations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _clearLogs,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // ================================================================
          // PIPELINE VISUALIZATION
          // ================================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: const Column(
              children: [
                Text(
                  'Stream Pipeline:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Input → .where(isEven) → .map(×10) → .distinct() → Output',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ],
            ),
          ),

          // ================================================================
          // NUMBER INPUT BUTTONS
          // ================================================================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Bấm số để thêm vào stream:'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(10, (index) {
                    final number = index + 1;
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        // Màu khác nhau cho chẵn/lẻ
                        style: ElevatedButton.styleFrom(
                          backgroundColor: number.isEven
                              ? Colors.green.shade100
                              : Colors.grey.shade200,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () => _addNumber(number),
                        child: Text(
                          '$number',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '🟢 Số chẵn sẽ được giữ lại',
                  style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                ),
              ],
            ),
          ),

          const Divider(),

          // ================================================================
          // LOGS DISPLAY
          // ================================================================
          Expanded(
            child: _logs.isEmpty
                ? const Center(
                    child: Text(
                      'Bấm các số ở trên để xem log',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          _logs[index],
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ================================================================
          // OPERATORS REFERENCE
          // ================================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📚 Các Operators khác:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• take(5): Lấy 5 giá trị đầu'),
                Text('• skip(3): Bỏ qua 3 giá trị đầu'),
                Text('• expand((x) => [x, x]): Nhân đôi mỗi giá trị'),
                Text('• asyncMap(): Map với async function'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
