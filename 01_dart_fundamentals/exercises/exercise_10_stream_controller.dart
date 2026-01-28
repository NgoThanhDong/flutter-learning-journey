/// ===========================================
/// BÀI TẬP 10: STREAM CONTROLLER
/// ===========================================
///
/// Mục tiêu: Hiểu cách tự tạo và điều khiển Stream
///
/// Yêu cầu:
/// Tạo class NumberEmitter với:
/// - Stream<int> numbers (để người khác lắng nghe)
/// - void add(int n) (để phát số vào stream)
/// - void dispose() (để đóng stream)
///
/// Chạy file: dart run exercise_10_stream_controller.dart

import 'dart:async';

void main() async {
  print('=== BÀI TẬP 10: STREAM CONTROLLER ===\n');

  // ╔════════════════════════════════════════════╗
  // ║  STREAMCONTROLLER LÀ GÌ?                   ║
  // ╚════════════════════════════════════════════╝

  print('''
📚 STREAMCONTROLLER - TỰ ĐIỀU KHIỂN STREAM

Bài trước, bạn dùng async* để tạo Stream.
Nhưng nếu bạn muốn TỰ QUYẾT ĐỊNH khi nào phát data?

→ Dùng StreamController!

─────────────────────────────────────────────────

🎮 VÍ DỤ: Như một đài phát thanh

  StreamController = Đài phát thanh
  .stream = Sóng radio (người nghe tune vào đây)
  .add(data) = DJ phát nhạc
  .close() = Tắt đài

─────────────────────────────────────────────────

📝 CÁCH DÙNG CƠ BẢN:

  // 1. Tạo controller
  var controller = StreamController<int>();
  
  // 2. Lấy stream để người khác lắng nghe
  controller.stream.listen((data) {
    print('Nhận: \$data');
  });
  
  // 3. Phát data bất cứ lúc nào
  controller.add(1);  // In ra: Nhận: 1
  controller.add(2);  // In ra: Nhận: 2
  
  // 4. Đóng khi xong (QUAN TRỌNG!)
  controller.close();

─────────────────────────────────────────────────

⚠️ QUAN TRỌNG: Luôn gọi close() khi không dùng nữa!
   Nếu không → Memory leak!

''');

  // Uncomment sau khi implement
  // var emitter = NumberEmitter();
  //
  // // Lắng nghe stream
  // emitter.numbers.listen((n) {
  //   print('Nhận được số: $n');
  // });
  //
  // // Phát các số
  // emitter.add(10);
  // emitter.add(20);
  // emitter.add(30);
  //
  // // Đợi một chút để stream xử lý
  // await Future.delayed(Duration(milliseconds: 100));
  //
  // // Đóng stream
  // emitter.dispose();
  // print('\n✅ Stream đã đóng!');

  print('👆 Hãy implement class NumberEmitter rồi uncomment code trên!');
}

// ============================================
// TODO: VIẾT CODE CỦA BẠN Ở ĐÂY
// ============================================

// class NumberEmitter {
//   // TODO: Tạo StreamController<int>
//   
//   // TODO: Getter để expose stream ra ngoài
//   // Stream<int> get numbers => ...
//   
//   // TODO: Method để phát số vào stream
//   // void add(int n) { ... }
//   
//   // TODO: Method để đóng stream
//   // void dispose() { ... }
// }

// ============================================
// GỢI Ý TỪNG BƯỚC
// ============================================
// 
// class NumberEmitter {
//   // 1. Tạo StreamController
//   //    (dùng _ để đánh dấu private)
//   final _controller = StreamController<int>();
//   
//   // 2. Expose stream ra ngoài qua getter
//   //    (người dùng chỉ có thể listen, không add trực tiếp)
//   Stream<int> get numbers => _controller.stream;
//   
//   // 3. Method để phát số
//   void add(int n) {
//     _controller.add(n);  // Phát n vào stream
//   }
//   
//   // 4. Method để đóng stream
//   void dispose() {
//     _controller.close();  // Đóng stream
//   }
// }
// 
// ─────────────────────────────────────────────
// 
// TẠI SAO DÙNG GETTER CHO STREAM?
// 
// ✅ Đúng: emitter.numbers.listen(...)  // Chỉ lắng nghe
// ❌ Sai:  emitter._controller.add(...)  // Không cho add trực tiếp
// 
// Điều này giúp kiểm soát ai được phép làm gì với stream.
// 
// ─────────────────────────────────────────────
// 
// STREAMCONTROLLER TRONG FLUTTER:
// 
// Đây là nền tảng của BLoC pattern mà bạn sẽ học sau!
// 
// class CounterBloc {
//   final _counterController = StreamController<int>();
//   Stream<int> get counter => _counterController.stream;
//   
//   void increment() {
//     _count++;
//     _counterController.add(_count);
//   }
// }

// ============================================
// BONUS: Broadcast Stream
// ============================================
// 
// Mặc định, 1 stream chỉ có 1 listener.
// Muốn nhiều listeners? Dùng .broadcast()
// 
// final _controller = StreamController<int>.broadcast();
// 
// // Bây giờ nhiều nơi có thể listen:
// _controller.stream.listen(...); // Listener 1
// _controller.stream.listen(...); // Listener 2
// 
// Khi add(10), CẢ HAI listeners đều nhận được 10!
