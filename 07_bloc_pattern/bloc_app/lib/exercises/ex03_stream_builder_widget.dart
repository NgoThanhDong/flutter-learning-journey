/// ============================================================================
/// EXERCISE 03: STREAM BUILDER WIDGET
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu sâu về StreamBuilder và AsyncSnapshot
/// - Xử lý các ConnectionState khác nhau
/// - Xử lý error trong stream
/// - Best practices khi dùng StreamBuilder
///
/// 📝 ASYNCSNAPSHOT PROPERTIES:
/// - connectionState: none, waiting, active, done
/// - hasData: true nếu có data
/// - data: giá trị hiện tại
/// - hasError: true nếu có lỗi
/// - error: object lỗi
///
/// ============================================================================
library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Ex03StreamBuilderWidget extends StatefulWidget {
  const Ex03StreamBuilderWidget({super.key});

  @override
  State<Ex03StreamBuilderWidget> createState() =>
      _Ex03StreamBuilderWidgetState();
}

class _Ex03StreamBuilderWidgetState extends State<Ex03StreamBuilderWidget> {
  // Controller cho stream timer
  StreamController<int>? _timerController;
  Timer? _timer;
  bool _isRunning = false;
  int _seconds = 0;

  // ============================================================================
  // TẠO PERIODIC STREAM
  // ============================================================================
  //
  // Stream.periodic: Tạo stream emit giá trị theo interval
  //
  // Tuy nhiên, ở đây ta dùng Timer + StreamController để có control tốt hơn:
  // - Có thể pause/resume
  // - Có thể add error
  // - Có thể close bất cứ lúc nào
  // ============================================================================
  void _startTimer() {
    // Tạo controller mới (nếu chưa có hoặc đã đóng)
    _timerController?.close();
    _timerController = StreamController<int>.broadcast();
    _seconds = 0;
    _isRunning = true;

    // Timer.periodic: Chạy callback mỗi 1 giây
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;

      // ================================================================
      // SIMULATE ERROR (để demo error handling)
      // ================================================================
      // Mỗi giây có 5% chance bị lỗi (chỉ để demo)
      if (Random().nextInt(100) < 5) {
        _timerController?.addError(
          Exception('Random error at second $_seconds!'),
        );
        _stopTimer();
        return;
      }

      // Emit giá trị mới vào stream
      _timerController?.sink.add(_seconds);
    });

    setState(() {});
  }

  void _stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    setState(() {});
  }

  void _resetTimer() {
    _stopTimer();
    _timerController?.close();
    _timerController = null;
    _seconds = 0;
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex03: StreamBuilder Widget'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================================================================
            // STREAM BUILDER VỚI ĐẦY ĐỦ STATES
            // ================================================================
            StreamBuilder<int>(
              // Stream để lắng nghe (có thể null)
              stream: _timerController?.stream,

              // initialData: Giá trị ban đầu trước khi stream emit
              // Nếu không có, snapshot.data sẽ là null ban đầu
              initialData: 0,

              // ================================================================
              // BUILDER FUNCTION
              // ================================================================
              // Được gọi mỗi khi:
              // - Stream emit giá trị mới
              // - Stream emit error
              // - Stream đóng (done)
              // - Widget được rebuild
              // ================================================================
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                // ============================================================
                // XỬ LÝ THEO CONNECTION STATE
                // ============================================================
                //
                // ConnectionState.none: Stream là null
                // ConnectionState.waiting: Stream chưa emit gì
                // ConnectionState.active: Stream đang emit (đây là trạng thái chính)
                // ConnectionState.done: Stream đã đóng
                // ============================================================

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(snapshot),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getBorderColor(snapshot),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Hiển thị Connection State
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'State: ${snapshot.connectionState.name.toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ======================================================
                      // LOGIC HIỂN THỊ THEO STATE
                      // ======================================================
                      if (snapshot.hasError) ...[
                        // XỬ LÝ LỖI
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ] else if (snapshot.connectionState ==
                          ConnectionState.none) ...[
                        // CHƯA CÓ STREAM
                        const Icon(Icons.hourglass_empty,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text(
                          'Stream chưa được tạo\nBấm Start để bắt đầu',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ] else if (snapshot.connectionState ==
                          ConnectionState.waiting) ...[
                        // ĐANG CHỜ
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        const Text('Waiting for first value...'),
                      ] else if (snapshot.connectionState ==
                          ConnectionState.done) ...[
                        // STREAM ĐÃ ĐÓNG
                        const Icon(Icons.check_circle,
                            size: 60, color: Colors.green),
                        const SizedBox(height: 12),
                        Text(
                          'Stream closed\nFinal value: ${snapshot.data}',
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        // ACTIVE - ĐANG NHẬN DATA
                        Text(
                          '${snapshot.data}',
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          'seconds',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ================================================================
            // CONTROL BUTTONS
            // ================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _startTimer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isRunning ? _stopTimer : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade100,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ================================================================
            // ASYNCSNAPSHOT REFERENCE
            // ================================================================
            Container(
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
                    '📚 AsyncSnapshot Properties:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text('• connectionState: Trạng thái kết nối'),
                  Text('  - none: Stream null'),
                  Text('  - waiting: Chờ data đầu tiên'),
                  Text('  - active: Đang nhận data'),
                  Text('  - done: Stream đã đóng'),
                  SizedBox(height: 8),
                  Text('• hasData: true nếu có data'),
                  Text('• data: Giá trị hiện tại'),
                  Text('• hasError: true nếu có lỗi'),
                  Text('• error: Object lỗi'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================================================================
            // WARNING NOTE
            // ================================================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '⚠️ Stream có 5% chance bị error mỗi giây để demo error handling!',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods cho UI
  Color _getBackgroundColor(AsyncSnapshot<int> snapshot) {
    if (snapshot.hasError) return Colors.red.shade50;
    if (snapshot.connectionState == ConnectionState.none) {
      return Colors.grey.shade100;
    }
    if (snapshot.connectionState == ConnectionState.done) {
      return Colors.green.shade50;
    }
    return Colors.blue.shade50;
  }

  Color _getBorderColor(AsyncSnapshot<int> snapshot) {
    if (snapshot.hasError) return Colors.red.shade300;
    if (snapshot.connectionState == ConnectionState.none) {
      return Colors.grey.shade300;
    }
    if (snapshot.connectionState == ConnectionState.done) {
      return Colors.green.shade300;
    }
    return Colors.blue.shade300;
  }
}
