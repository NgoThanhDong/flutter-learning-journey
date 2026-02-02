/// ===========================================
/// EXERCISE 01: COUNTER VỚI SETSTATE (ÔN TẬP)
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Ôn lại kiến thức setState từ Phase 2
/// - Hiểu rõ flow: setState -> build() -> UI update
///
/// 📝 Yêu cầu:
/// - Counter với nút +, -, Reset
/// - Không cho count âm
/// - Hiển thị "Count: X" ở giữa màn hình

library;

import 'package:flutter/material.dart';

/// [Concept] StatefulWidget
/// Widget có thể thay đổi state (dữ liệu nội bộ) theo thời gian.
/// Gồm 2 class:
/// 1. Widget class (StatefulWidget) - Immutable, chỉ tạo State
/// 2. State class - Mutable, chứa data và logic
class Ex01CounterSetstate extends StatefulWidget {
  const Ex01CounterSetstate({super.key});

  @override
  State<Ex01CounterSetstate> createState() => _Ex01CounterSetstateState();
}

class _Ex01CounterSetstateState extends State<Ex01CounterSetstate> {
  /// [State Variable]
  /// Biến lưu trữ dữ liệu của widget.
  /// Khi biến này thay đổi VÀ gọi setState() -> Flutter sẽ gọi build() lại.
  int _count = 0;

  /// [Method để thay đổi state]
  /// Luôn dùng setState() khi muốn thay đổi UI.
  /// setState bao gồm 2 bước:
  /// 1. Thay đổi giá trị biến (bên trong callback)
  /// 2. Lên lịch để Flutter gọi build() lại
  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    // [Guard clause] Kiểm tra điều kiện trước khi thực hiện
    if (_count <= 0) {
      // Hiện thông báo nếu count đã là 0
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Counter không thể âm!'),
          duration: Duration(seconds: 1),
        ),
      );
      return; // Thoát sớm, không thực hiện gì thêm
    }
    setState(() {
      _count--;
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // [Debug] Print mỗi khi build được gọi
    // Để hiểu setState trigger build như thế nào
    debugPrint('🔄 Build được gọi, count = $_count');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex01: Counter setState'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị count
            Text(
              'Count: $_count',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Row chứa các nút
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút giảm
                ElevatedButton(
                  onPressed: _decrement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.remove, size: 32),
                ),

                const SizedBox(width: 24),

                // Nút tăng
                ElevatedButton(
                  onPressed: _increment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.add, size: 32),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Nút Reset
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
