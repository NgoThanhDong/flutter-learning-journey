# Phase 1: Dart Fundamentals - Bài 3: Async Programming

## Mục tiêu bài học
- Hiểu Future và async/await
- Nắm vững Stream (luồng dữ liệu)
- Xử lý lỗi trong async code

---

## 1. Tại Sao Cần Async?

### 1.1 Vấn đề: Blocking Code

```dart
// ❌ Code như này sẽ BLOCK UI
String data = fetchDataFromNetwork(); // Đợi 3 giây
print(data); // Người dùng không làm gì được trong 3 giây!
```

### 1.2 Giải pháp: Non-blocking với Async

```dart
// ✅ Code async không block UI
fetchDataFromNetwork().then((data) {
  print(data);
});
// UI vẫn responsive trong khi đợi network
```

### 💡 Trong Flutter: 
- UI chạy ở **main thread**
- Network calls, file I/O phải là async để **không đóng băng UI**

---

## 2. Future - Kết quả trong tương lai

### 2.1 Tạo Future

```dart
// Future đại diện cho giá trị sẽ có trong tương lai
Future<String> fetchUsername() {
  // Giả lập network delay
  return Future.delayed(Duration(seconds: 2), () {
    return 'NgoThanhDong';
  });
}

// Future có thể thành công hoặc thất bại
Future<String> fetchData() {
  return Future.delayed(Duration(seconds: 1), () {
    // Có thể throw exception
    // throw Exception('Network error');
    return 'Data loaded!';
  });
}
```

### 2.2 Xử lý Future với then/catchError

```dart
fetchUsername()
    .then((name) {
      print('Xin chào, $name');
    })
    .catchError((error) {
      print('Lỗi: $error');
    })
    .whenComplete(() {
      print('Hoàn thành (dù thành công hay thất bại)');
    });
```

### 2.3 Xử lý Future với async/await (Khuyên dùng!)

```dart
Future<void> greetUser() async {
  try {
    String name = await fetchUsername(); // Đợi kết quả
    print('Xin chào, $name');
  } catch (error) {
    print('Lỗi: $error');
  } finally {
    print('Hoàn thành');
  }
}
```

### 💡 Suy luận: async/await vs then

| Aspect | then/catchError | async/await |
|--------|-----------------|-------------|
| Đọc | Khó theo dõi khi nhiều bước | Đọc như code đồng bộ |
| Debug | Khó debug | Dễ debug |
| Lỗi | catchError riêng | try/catch quen thuộc |
| Khuyên | Dùng cho case đơn giản | **Dùng cho hầu hết cases** |

---

## 3. Xử lý nhiều Future

### 3.1 Future.wait - Chờ tất cả hoàn thành

```dart
Future<void> loadAllData() async {
  // Chạy song song, đợi TẤT CẢ hoàn thành
  var results = await Future.wait([
    fetchUser(),     // 2 giây
    fetchProducts(), // 3 giây
    fetchOrders(),   // 1 giây
  ]);
  // Tổng thời gian: 3 giây (max), không phải 6 giây!
  
  var user = results[0];
  var products = results[1];
  var orders = results[2];
}
```

### 3.2 Future.any - Lấy kết quả đầu tiên

```dart
Future<String> fetchFromFastestServer() async {
  return await Future.any([
    fetchFromServer1(), // 3 giây
    fetchFromServer2(), // 1 giây ← Trả về cái này
    fetchFromServer3(), // 2 giây
  ]);
}
```

---

## 4. Stream - Luồng dữ liệu liên tục

### 4.1 Future vs Stream

| Future | Stream |
|--------|--------|
| **1 giá trị** trong tương lai | **Nhiều giá trị** theo thời gian |
| HTTP request | WebSocket, realtime data |
| Đọc 1 file | Đọc file lớn theo chunks |

### 4.2 Tạo Stream

```dart
// Stream đơn giản với async*
Stream<int> countDown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // "yield" = emit giá trị ra stream
  }
}

// Stream từ List
Stream<String> fruitsStream() {
  return Stream.fromIterable(['Táo', 'Cam', 'Chuối']);
}
```

### 4.3 Lắng nghe Stream

```dart
// Cách 1: listen
countDown(5).listen(
  (number) => print('Countdown: $number'),
  onDone: () => print('Blast off!'),
  onError: (error) => print('Error: $error'),
);

// Cách 2: await for (trong async function)
Future<void> printCountdown() async {
  await for (var number in countDown(5)) {
    print('Countdown: $number');
  }
  print('Blast off!');
}
```

### 4.4 Stream Transformations

```dart
Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

// Map - biến đổi mỗi giá trị
numbers.map((n) => n * 2); // 2, 4, 6, 8, 10

// Where - lọc giá trị
numbers.where((n) => n > 2); // 3, 4, 5

// Take - lấy n giá trị đầu
numbers.take(3); // 1, 2, 3

// Skip - bỏ qua n giá trị đầu
numbers.skip(2); // 3, 4, 5
```

---

## 5. StreamController - Tạo Stream tùy chỉnh

### 5.1 Broadcast Stream (nhiều listeners)

```dart
class EventBus {
  // Broadcast = nhiều listeners
  final _controller = StreamController<String>.broadcast();
  
  Stream<String> get events => _controller.stream;
  
  void emit(String event) {
    _controller.add(event);
  }
  
  void dispose() {
    _controller.close();
  }
}

// Sử dụng
var eventBus = EventBus();

// Listener 1
eventBus.events.listen((event) {
  print('Listener 1: $event');
});

// Listener 2
eventBus.events.listen((event) {
  print('Listener 2: $event');
});

eventBus.emit('User logged in');
// Output:
// Listener 1: User logged in
// Listener 2: User logged in
```

### 💡 Trong Flutter:
- BLoC pattern sử dụng Stream/StreamController
- Riverpod sử dụng khái niệm tương tự

---

## 6. Xử lý lỗi Async

### 6.1 Pattern: Result Type

```dart
// Thay vì throw exception, return kết quả có cấu trúc
class Result<T> {
  final T? data;
  final String? error;
  
  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;
  
  bool get isSuccess => error == null;
}

Future<Result<String>> fetchSafely() async {
  try {
    var data = await fetchFromNetwork();
    return Result.success(data);
  } catch (e) {
    return Result.failure(e.toString());
  }
}

// Sử dụng
var result = await fetchSafely();
if (result.isSuccess) {
  print(result.data);
} else {
  print('Error: ${result.error}');
}
```

---

## 7. Bài Tập Thực Hành

### Bài 1: Future cơ bản
Viết function `delayedHello(String name)` trả về Future<String> sau 2 giây.

### Bài 2: Xử lý nhiều Future
Viết function `fetchAllUsers()` gọi đồng thời 3 API và trả về danh sách users.

### Bài 3: Stream
Tạo Stream phát ra số từ 1 đến 10, mỗi giây 1 số.

### Bài 4: StreamController
Tạo class `NumberEmitter` với method `add(int n)` và stream `numbers`.

---

## 📝 Checklist Bài 3

- [ ] Hiểu tại sao cần async (không block UI)
- [ ] Thành thạo Future với async/await
- [ ] Biết dùng Future.wait để chạy song song
- [ ] Hiểu Stream và async* / yield
- [ ] Biết dùng StreamController

**Kết thúc Phase 1!** Tiếp theo: Phase 2 - Flutter Basics & Widget System
