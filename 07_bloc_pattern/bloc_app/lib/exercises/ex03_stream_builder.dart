/// ===========================================
/// EXERCISE 03: STREAM BUILDER
/// ===========================================
/// 🎯 Mục tiêu:
/// - Sử dụng StreamBuilder để build UI
/// - Xử lý các trạng thái: waiting, active, done, error
/// - Không dùng setState thủ công nữa!
///
/// 📝 StreamBuilder:
/// - Là Widget lắng nghe Stream
/// - Tự rebuild mỗi khi có event mới
/// - snapshot.data: Dữ liệu hiện tại
/// - snapshot.connectionState: Trạng thái kết nối
/// - snapshot.hasError: Kiểm tra lỗi

library;

import 'dart:async';
import 'package:flutter/material.dart';

class Ex03StreamBuilder extends StatefulWidget {
  const Ex03StreamBuilder({super.key});

  @override
  State<Ex03StreamBuilder> createState() => _Ex03StreamBuilderState();
}

class _Ex03StreamBuilderState extends State<Ex03StreamBuilder> {
  final StreamController<int> _controller = StreamController<int>();
  int _count = 0;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _increment() {
    _count++;
    _controller.sink.add(_count);
  }

  void _addError() {
    _controller.sink.addError("Simulated Error!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex03: StreamBuilder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Counter using StreamBuilder:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            /// STREAM BUILDER
            /// Input: Stream<int>
            /// Builder: Trả về Widget dựa trên snapshot (dữ liệu tại thời điểm đó)
            StreamBuilder<int>(
              stream: _controller.stream,
              initialData: 0, // Giá trị khởi tạo khi stream chưa có gì
              builder: (context, snapshot) {
                /// 1. Kiểm tra trạng thái kết nối (Optional)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                /// 2. Kiểm tra lỗi
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.red.shade100,
                    child: Text(
                      "❌ Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                /// 3. Lấy dữ liệu và hiển thị
                final data = snapshot.data;

                return Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 4),
                  ),
                  child: Text(
                    '$data',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: _increment,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: Colors.red,
                  onPressed: _addError,
                  child: const Icon(Icons.error_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Blue = Add Data | Red = Add Error"),
          ],
        ),
      ),
    );
  }
}
