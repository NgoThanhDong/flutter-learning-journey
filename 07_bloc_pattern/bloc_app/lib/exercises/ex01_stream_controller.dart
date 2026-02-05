/// ===========================================
/// EXERCISE 01: STREAM CONTROLLER BASICS
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu cơ chế hoạt động của StreamController
/// - Phân biệt Sink (Input) và Stream (Output)
/// - Quản lý Subscription (lắng nghe và hủy)
///
/// 📝 Lưu ý:
/// - StreamController: Bộ điều khiển dòng dữ liệu
/// - Sink: Nơi NẠP dữ liệu vào (Add)
/// - Stream: Nơi LẤY dữ liệu ra (Listen)
/// - Subscription: Vé đăng ký nghe, cần cancel khi xong

library;

import 'dart:async';
import 'package:flutter/material.dart';

class Ex01StreamController extends StatefulWidget {
  const Ex01StreamController({super.key});

  @override
  State<Ex01StreamController> createState() => _Ex01StreamControllerState();
}

class _Ex01StreamControllerState extends State<Ex01StreamController> {
  /// 1. Khai báo StreamController
  /// Broadcast stream cho phép nhiều người nghe (listeners)
  /// Nếu không dùng .broadcast(), chỉ được 1 listener duy nhất (sẽ lỗi nếu nghe lần 2)
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  /// Biến để lưu trữ data nhận được từ stream để hiển thị lên UI
  String _streamData = "No data yet";

  /// Biến quản lý trạng thái subscription
  StreamSubscription? _subscription;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    // Chúng ta chưa listen ngay, để user tự bấm nút Listen
  }

  @override
  void dispose() {
    /// ⚠️ BẮT BUỘC: Close controller và Cancel subscription khi widget bị hủy
    /// Nếu quên -> Memory Leak (Tràn bộ nhớ)
    _subscription?.cancel();
    _controller.close();
    super.dispose();
  }

  /// Hàm gửi dữ liệu vào Stream (thông qua Sink)
  void _addData(String data) {
    if (_controller.isClosed) return;

    debugPrint("📥 Adding to Sink: $data");
    // Sink.add: Đẩy data vào ống nước
    _controller.sink.add(data);
  }

  /// Hàm gửi lỗi vào Stream
  void _addError() {
    if (_controller.isClosed) return;

    debugPrint("⚠️ Adding Error to Sink");
    _controller.sink.addError("Something went wrong!");
  }

  /// Bắt đầu lắng nghe (Subscribe)
  void _startListening() {
    if (_isListening) return;

    debugPrint("🎧 Subscribing to Stream...");

    // .listen trả về một Subscription
    _subscription = _controller.stream.listen(
      (data) {
        // onData: Xử lý khi có dữ liệu mới
        debugPrint("📤 Received from Stream: $data");
        setState(() {
          _streamData = data;
        });
      },
      onError: (error) {
        // onError: Xử lý khi có lỗi
        debugPrint("❌ Received Error: $error");
        setState(() {
          _streamData = "Error: $error";
        });
      },
      onDone: () {
        // onDone: Xử lý khi stream bị đóng
        debugPrint("🏁 Stream Closed (Done)");
        setState(() {
          _streamData = "Stream Closed";
          _isListening = false;
        });
      },
    );

    setState(() {
      _isListening = true;
    });
  }

  /// Ngừng lắng nghe (Unsubscribe)
  void _stopListening() {
    debugPrint("🛑 Unsubscribing...");
    _subscription?.cancel(); // Hủy đăng ký
    _subscription = null;
    setState(() {
      _isListening = false;
      _streamData = "Stopped Listening";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex01: Stream Controller')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARD HIỂN THỊ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _isListening
                    ? Colors.green.shade50
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isListening ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _isListening ? "Listening..." : "Not Listening",
                    style: TextStyle(
                      color: _isListening ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _streamData,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // CONTROLS LISTENER
            const Text(
              "Listener Controls:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isListening ? null : _startListening,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Subscribe"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade100,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : null,
                  icon: const Icon(Icons.stop),
                  label: const Text("Unsubscribe"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade100,
                  ),
                ),
              ],
            ),

            const Divider(height: 48),

            // CONTROLS SINK (INPUT)
            const Text(
              "Sink Controls (Send Data):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _addData("Hello 👋"),
                  child: const Text("Send 'Hello'"),
                ),
                ElevatedButton(
                  onPressed: () => _addData("Flutter 🦋"),
                  child: const Text("Send 'Flutter'"),
                ),
                ElevatedButton(
                  onPressed: () => _addData("BLoC 🧱"),
                  child: const Text("Send 'BLoC'"),
                ),
                ElevatedButton(
                  onPressed: () => _addData("Time: ${DateTime.now().second}s"),
                  child: const Text("Send Time"),
                ),
                ElevatedButton(
                  onPressed: _addError, // Thử gửi lỗi
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Send Error ⚠️"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // EXPLANATION CARD
            const Card(
              color: Colors.blueGrey,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "💡 Tip: Hãy thử bấm 'Subscribe', sau đó gửi vài data.\n"
                  "Thử bấm 'Unsubscribe' rồi gửi tiếp -> UI sẽ không cập nhật.\n"
                  "Thử gửi Error xem UI xử lý thế nào.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
