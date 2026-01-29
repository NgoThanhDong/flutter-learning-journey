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

import 'package:flutter/material.dart';

// TODO: Uncomment và hoàn thiện

/*
class Ex02Counter extends StatefulWidget {
  const Ex02Counter({super.key});

  @override
  State<Ex02Counter> createState() => _Ex02CounterState();
}

class _Ex02CounterState extends State<Ex02Counter> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_count',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrement,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                  child: Icon(Icons.remove, size: 30),
                ),
                SizedBox(width: 24),
                ElevatedButton(
                  onPressed: _increment,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                  child: Icon(Icons.add, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() { _count = 0; });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
*/
