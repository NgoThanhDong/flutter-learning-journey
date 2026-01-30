/// ===========================================
/// EXERCISE 02: COUNTER APP
/// ===========================================
///
/// Mục tiêu: Hiểu StatefulWidget và setState()
///
/// Yêu cầu:
/// - Hiển thị số đếm ở giữa màn hình
/// - Nút (+) để tăng
/// - Nút (-) để giảm
/// - Số không được âm (minimum = 0)

library;

import 'package:flutter/material.dart';

// [Giải thích concept]
// StatefulWidget: Widget có thể thay đổi trạng thái (state) khi chạy (dynamic).
// Cần 2 class: 1 cái extends StatefulWidget, 1 cái extends State.
class Ex02Counter extends StatefulWidget {
  const Ex02Counter({super.key});

  @override
  State<Ex02Counter> createState() => _Ex02CounterState();
}

// Class này chứa biến state (_count) và logic cập nhật UI
class _Ex02CounterState extends State<Ex02Counter> {
  // Đây là biến state. Khi biến này đổi -> UI cần vẽ lại.
  int _count = 0;

  void _increment() {
    // [Quan trọng]
    // setState(): Hàm báo cho Flutter biết "Data đã đổi rồi, hãy vẽ lại màn hình đi!"
    // Nếu không gọi setState, biến _count vẫn tăng nhưng UI không thay đổi.
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    setState(() {
      // Logic kiểm tra số âm
      if (_count > 0) {
        _count--;
      } else {
        // [Thủ thuật] Hiển thị thông báo nếu người dùng cố giảm dưới 0
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Counter is not negative!')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      // Center -> Column: Căn giữa theo trục dọc và ngang
      body: Center(
        child: Column(
          // mainAxisAlignment: Căn giữa các con theo trục chính (trục dọc của Column)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị giá trị biến state
            Text(
              '$_count',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 32), // Khoảng cách giữa số và hàng nút bấm
            // Row: Xếp các nút nằm ngang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút giảm (-)
                ElevatedButton(
                  onPressed: _decrement, // Gọi hàm giảm
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                  child: Icon(Icons.remove, size: 30),
                ),
                SizedBox(width: 24), // Khoảng cách giữa 2 nút
                // Nút tăng (+)
                ElevatedButton(
                  onPressed: _increment, // Gọi hàm tăng
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                  child: Icon(Icons.add, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),

      // FloatingActionButton: Nút nổi đặc trưng của Material Design (thường dùng cho hành động chính)
      floatingActionButton: FloatingActionButton(
        // Reset counter về 0
        onPressed: () {
          setState(() {
            _count = 0;
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
