/// ===========================================
/// DART FUNDAMENTALS - BÀI 3: ASYNC PROGRAMMING
/// ===========================================
///
/// Chạy file:
///   dart run 01_dart_fundamentals/lesson_03_examples.dart

import 'dart:async';

void main() async {
  print('=== 1. FUTURE BASICS ===\n');
  await demonstrateFuture();

  print('\n=== 2. ASYNC/AWAIT ===\n');
  await demonstrateAsyncAwait();

  print('\n=== 3. MULTIPLE FUTURES ===\n');
  await demonstrateMultipleFutures();

  print('\n=== 4. STREAM BASICS ===\n');
  await demonstrateStream();

  print('\n=== 5. STREAM CONTROLLER ===\n');
  await demonstrateStreamController();

  print('\n=== HOÀN THÀNH! ===');
}

// ============================================
// 1. FUTURE BASICS
// ============================================

// Giả lập network call
Future<String> fetchUsername() {
  return Future.delayed(Duration(milliseconds: 500), () {
    return 'NgoThanhDong';
  });
}

Future<int> fetchAge() {
  return Future.delayed(Duration(milliseconds: 300), () {
    return 25;
  });
}

Future<void> demonstrateFuture() async {
  print('Bắt đầu fetch username...');

  // Cách 1: then/catchError
  fetchUsername()
      .then((name) => print('[then] Username: $name'))
      .catchError((error) => print('Error: $error'));

  // Đợi một chút để then hoàn thành
  await Future.delayed(Duration(milliseconds: 600));
}

// ============================================
// 2. ASYNC/AWAIT (Khuyên dùng!)
// ============================================

Future<void> demonstrateAsyncAwait() async {
  try {
    print('Fetching user info...');

    // await = đợi Future hoàn thành
    String name = await fetchUsername();
    print('Username: $name');

    int age = await fetchAge();
    print('Age: $age');
  } catch (error) {
    print('Error: $error');
  }
}

// ============================================
// 3. MULTIPLE FUTURES
// ============================================

Future<String> fetchProduct(int id) async {
  await Future.delayed(Duration(milliseconds: 200));
  return 'Product $id';
}

Future<void> demonstrateMultipleFutures() async {
  print('--- Tuần tự (chậm) ---');
  var start = DateTime.now();

  var p1 = await fetchProduct(1);
  var p2 = await fetchProduct(2);
  var p3 = await fetchProduct(3);

  var sequential = DateTime.now().difference(start).inMilliseconds;
  print('Kết quả: $p1, $p2, $p3');
  print('Thời gian tuần tự: ${sequential}ms');

  print('\n--- Song song (nhanh) ---');
  start = DateTime.now();

  // Future.wait chạy song song tất cả
  var products = await Future.wait([
    fetchProduct(1),
    fetchProduct(2),
    fetchProduct(3),
  ]);

  var parallel = DateTime.now().difference(start).inMilliseconds;
  print('Kết quả: ${products.join(", ")}');
  print('Thời gian song song: ${parallel}ms');

  print(
    '\n💡 Song song nhanh hơn ~${(sequential / parallel).toStringAsFixed(1)}x!',
  );
}

// ============================================
// 4. STREAM
// ============================================

// async* và yield tạo Stream
Stream<int> countDown(int from) async* {
  for (int i = from; i >= 1; i--) {
    await Future.delayed(Duration(milliseconds: 200));
    yield i; // Phát ra giá trị
  }
}

Future<void> demonstrateStream() async {
  print('Countdown từ 5:');

  // await for - lắng nghe từng giá trị
  await for (var number in countDown(5)) {
    print('  $number...');
  }
  print('  🚀 Blast off!');

  // Stream transformations
  print('\nStream transformations:');
  var numbers = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  // Chỉ lấy số chẵn
  var evenNumbers = await numbers.where((n) => n % 2 == 0).toList();
  print('Số chẵn: $evenNumbers');
}

// ============================================
// 5. STREAM CONTROLLER
// ============================================

class MessageService {
  // broadcast() cho phép nhiều listeners
  final _controller = StreamController<String>.broadcast();

  Stream<String> get messages => _controller.stream;

  void sendMessage(String message) {
    _controller.add(message);
  }

  void sendError(String error) {
    _controller.addError(error);
  }

  void dispose() {
    _controller.close();
  }
}

Future<void> demonstrateStreamController() async {
  var service = MessageService();

  // Listener 1
  var subscription1 = service.messages.listen(
    (msg) => print('📱 Phone: $msg'),
    onError: (e) => print('📱 Phone Error: $e'),
  );

  // Listener 2
  var subscription2 = service.messages.listen(
    (msg) => print('💻 Laptop: $msg'),
    onError: (e) => print('💻 Laptop Error: $e'),
  );

  // Gửi messages
  service.sendMessage('Hello!');
  await Future.delayed(Duration(milliseconds: 100));

  service.sendMessage('How are you?');
  await Future.delayed(Duration(milliseconds: 100));

  // Cleanup
  await subscription1.cancel();
  await subscription2.cancel();
  service.dispose();

  print('\n💡 Cả 2 devices đều nhận được message (broadcast)');
}

// ============================================
// 💡 GHI NHỚ QUAN TRỌNG
// ============================================
//
// 1. Future = 1 giá trị trong tương lai
// 2. Stream = nhiều giá trị theo thời gian
// 3. async/await = cách viết async dễ đọc
// 4. Future.wait = chạy nhiều Future song song
// 5. StreamController = tạo Stream tùy chỉnh
// 6. Luôn dispose StreamController để tránh memory leak!
