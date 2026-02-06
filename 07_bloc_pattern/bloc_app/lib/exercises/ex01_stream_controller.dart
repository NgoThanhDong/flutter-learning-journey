/// ============================================================================
/// EXERCISE 01: STREAM CONTROLLER CƠ BẢN
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu cách tạo và sử dụng StreamController
/// - Hiểu khái niệm Sink (input) và Stream (output)
/// - Kết nối StreamController với UI qua StreamBuilder
///
/// 📝 KIẾN THỨC CẦN NẮM:
/// - `StreamController<T>`: Quản lý một stream với kiểu dữ liệu T
/// - .sink.add(): Thêm data vào stream
/// - .stream: Lấy stream để listen
/// - StreamBuilder: Widget rebuild tự động khi stream emit giá trị mới
///
/// 🔧 LƯU Ý QUAN TRỌNG:
/// - Luôn close() controller trong dispose() để tránh memory leak
/// - Dùng .broadcast() nếu cần nhiều listeners
///
/// ============================================================================
library;

import 'dart:async';
import 'package:flutter/material.dart';

/// Widget chính của Exercise 01
class Ex01StreamController extends StatefulWidget {
  const Ex01StreamController({super.key});

  @override
  State<Ex01StreamController> createState() => _Ex01StreamControllerState();
}

class _Ex01StreamControllerState extends State<Ex01StreamController> {
  // ============================================================================
  // KHAI BÁO STREAM CONTROLLER (Khai báo stream controller)
  // ============================================================================
  //
  // StreamController<int>: Controller quản lý stream chứa giá trị int
  //
  // .broadcast(): Tạo broadcast stream - cho phép NHIỀU listeners
  // - Nếu không dùng .broadcast(), chỉ 1 listener được phép
  // - Trong Flutter, thường dùng broadcast vì có thể có nhiều StreamBuilder
  //
  // Ví dụ:
  //   final single = StreamController<int>();        // 1 listener
  //   final broadcast = StreamController<int>.broadcast(); // nhiều listeners
  // ============================================================================
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();

  // Biến lưu giá trị hiện tại
  // Lý do: StreamController không lưu trữ giá trị, chỉ truyền data qua
  int _currentValue = 0;

  // ============================================================================
  // LIFECYCLE: DISPOSE (Vòng đời: Hủy stream controller)
  // ============================================================================
  //
  // ⚠️ QUAN TRỌNG: Luôn đóng StreamController trong dispose()
  //
  // Tại sao?
  // - Tránh memory leak (rò rỉ bộ nhớ)
  // - Giải phóng resources
  // - Prevent "Bad state: Stream has already been listened to" error
  //
  // Thứ tự: đóng controller TRƯỚC super.dispose()
  // ============================================================================
  @override
  void dispose() {
    _counterController.close(); // Đóng stream controller
    super.dispose();
  }

  // ============================================================================
  // METHODS: THÊM DATA VÀO STREAM (Các phương thức để thêm dữ liệu vào stream)
  // ============================================================================
  //
  // .sink: Cổng vào của stream (input)
  // .sink.add(value): Thêm giá trị mới vào stream
  //
  // Khi add() được gọi:
  // 1. Giá trị được đẩy vào stream
  // 2. Tất cả listeners nhận được giá trị
  // 3. StreamBuilder rebuild UI
  // ============================================================================
  void _increment() {
    _currentValue++; // Tăng giá trị
    _counterController.sink.add(_currentValue); // Đẩy vào stream
  }

  void _decrement() {
    _currentValue--; // Giảm giá trị
    _counterController.sink.add(_currentValue); // Đẩy vào stream
  }

  void _reset() {
    _currentValue = 0; // Reset về 0
    _counterController.sink.add(_currentValue); // Đẩy vào stream
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex01: Stream Controller'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ================================================================
            // GIẢI THÍCH: STREAM FLOW (Luồng dữ liệu trong stream)
            // ================================================================
            const Text(
              'StreamController Flow:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Button → sink.add() → Stream → StreamBuilder → UI',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),

            const SizedBox(height: 40),

            // ================================================================
            // STREAM BUILDER
            // ================================================================
            //
            // StreamBuilder: Widget lắng nghe stream và rebuild khi có data mới
            //
            // Parameters:
            // - stream: Stream cần lắng nghe (.stream từ controller)
            // - initialData: Giá trị ban đầu trước khi stream emit
            // - builder: Hàm build UI, nhận (context, snapshot)
            //
            // AsyncSnapshot properties:
            // - snapshot.data: Giá trị hiện tại
            // - snapshot.hasData: Có data không?
            // - snapshot.hasError: Có lỗi không?
            // - snapshot.connectionState: Trạng thái kết nối
            //   - none: Chưa kết nối
            //   - waiting: Đang chờ
            //   - active: Đang nhận data
            //   - done: Stream đã đóng
            // ================================================================
            StreamBuilder<int>(
              stream: _counterController.stream, // Lắng nghe stream
              initialData: 0, // Giá trị ban đầu
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                // Lấy giá trị từ snapshot, mặc định là 0 nếu null
                final value = snapshot.data ?? 0;

                return Column(
                  children: [
                    // Hiển thị giá trị
                    Text(
                      '$value',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: value >= 0 ? Colors.blue : Colors.red,
                          ),
                    ),

                    const SizedBox(height: 8),

                    // Hiển thị connection state (để debug/học)
                    Text(
                      'Connection: ${snapshot.connectionState.name}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            // ================================================================
            // CONTROL BUTTONS (Các nút bấm để điều khiển stream)
            // ================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút giảm
                FloatingActionButton(
                  heroTag: 'decrement', // Unique tag cho mỗi FAB
                  onPressed: _decrement,
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.remove),
                ),

                const SizedBox(width: 16),

                // Nút reset
                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: _reset,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.refresh),
                ),

                const SizedBox(width: 16),

                // Nút tăng
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: _increment,
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ================================================================
            // CODE EXPLANATION (Giải thích code)
            // ================================================================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Điều gì xảy ra khi bấm nút?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. _increment() được gọi'),
                  Text('2. _currentValue++ tăng giá trị'),
                  Text('3. sink.add() đẩy value vào stream'),
                  Text('4. StreamBuilder nhận value mới'),
                  Text('5. builder() được gọi lại → UI update'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
