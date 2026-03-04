# Phase 1: Dart Fundamentals - Bài 3: Async Programming

## Mục tiêu bài học
- Hiểu tại sao cần lập trình bất đồng bộ (async)
- Thành thạo Future và async/await
- **Hiểu rõ Stream** (từ cơ bản đến nâng cao)
- Xử lý lỗi trong async code

---

## 1. Tại Sao Cần Async? (Lập trình bất đồng bộ)

### 1.1 Vấn đề: Blocking Code (Code chặn)

Hãy tưởng tượng bạn đang order coffee tại quán:

```
❌ CÁCH XẤU (Blocking):
1. Bạn order → Barista làm coffee (3 phút)
2. Bạn ĐỨNG ĐỢI, không làm gì được
3. Nhận coffee

✅ CÁCH TỐT (Non-blocking):
1. Bạn order → Nhận số thứ tự
2. Bạn NGỒI CHƠI, lướt điện thoại
3. Khi xong, barista gọi số → Nhận coffee
```

**Trong lập trình:**
- `Blocking` = App đóng băng khi chờ network
- `Non-blocking (Async)` = App vẫn chạy mượt, khi nào xong thì xử lý

### 💡 Trong Flutter: 
- UI chạy ở **main thread**
- Network calls, file I/O phải là async để **không đóng băng UI**

### 1.2 Ví dụ thực tế

```dart
// ❌ Blocking - UI đóng băng
String data = fetchFromNetwork(); // Chờ 3 giây
print(data); // Người dùng không thao tác được!

// ✅ Non-blocking - UI mượt mà
fetchFromNetwork().then((data) {
  print(data);
});
// Code tiếp tục chạy, không chờ
```

---

## 2. Future - "Hứa hẹn" trong tương lai

### 2.1 Future là gì?

**Future** giống như **phiếu hẹn lấy đồ**:
- Bạn đưa đồ đi giặt → Nhận phiếu hẹn (Future)
- Phiếu hẹn **chưa phải là quần áo**, nhưng **hứa sẽ có** quần áo sau
- Khi xong → Đổi phiếu lấy quần áo (data)

```dart
// Future<String> = "Hứa sẽ trả về String trong tương lai"
Future<String> fetchUsername() {
  return Future.delayed(Duration(seconds: 2), () {
    return 'NgoThanhDong'; // Sau 2 giây, trả về data
  });
}
```

### 2.2 Cách 1: Xử lý với then/catchError

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

### 2.3 Cách 2: async/await (KHUYÊN DÙNG!)

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

| Aspect (Khía cạnh) | then/catchError | async/await |
|--------|-----------------|-------------|
| Đọc | Khó theo dõi khi nhiều bước | Đọc như code đồng bộ |
| Debug | Khó debug | Dễ debug |
| Lỗi | catchError riêng | try/catch quen thuộc |
| Khuyên | Dùng cho case đơn giản | **Dùng cho hầu hết cases** |

---

## 3. Xử lý nhiều Future song song

### 3.1 Future.wait - Chờ tất cả hoàn thành

```dart
// ❌ Tuần tự - CHẬM (6 giây)
var user = await fetchUser();      // 2 giây
var products = await fetchProducts(); // 3 giây
var orders = await fetchOrders();  // 1 giây

// ✅ Song song - NHANH (3 giây, lấy max)
var results = await Future.wait([
  fetchUser(),      // 2 giây ─┐
  fetchProducts(),  // 3 giây ─┼─► Chạy cùng lúc!
  fetchOrders(),    // 1 giây ─┘
]);
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

## 4. Stream - Luồng dữ liệu liên tục - Giải thích SIÊU CHI TIẾT

### 4.1 Stream là gì? (Ví dụ đời thực)

Hãy tưởng tượng **lắng nghe radio**:

| Future | Stream |
|--------|--------|
| Mua 1 đĩa CD | Nghe radio |
| Có **1 bài hát** | Có **NHIỀU bài** phát liên tục |
| Mua xong là có ngay | Phải **đợi** bài tiếp theo |
| Dùng xong là hết | Có thể **tắt** bất cứ lúc nào |

```
Future  = 📦 Nhận 1 gói hàng
Stream  = 📬 Đăng ký nhận báo hàng ngày
```

| Future | Stream |
|--------|--------|
| **1 giá trị** trong tương lai | **Nhiều giá trị** theo thời gian |
| HTTP request | WebSocket, realtime data (dữ liệu thời gian thực) |
| Đọc 1 file | Đọc file lớn theo chunks (từng phần) |

### 4.2 Tạo Stream - Ví dụ trực quan

```dart
// FUTURE: Lấy 1 giá trị
Future<int> getOneNumber() async {
  return 42; // Trả về 1 số
}

// STREAM: Phát nhiều giá trị theo thời gian
Stream<int> getManyNumbers() async* {
  yield 1;  // Phát số 1
  yield 2;  // Phát số 2
  yield 3;  // Phát số 3
}
```

### 4.3 Tạo Stream với async* và yield

```dart
// async* = function trả về Stream
// yield = "phát ra" 1 giá trị vào Stream

Stream<int> countUp(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1)); // Đợi 1 giây
    yield i; // Phát ra số i
    print('Đã phát: $i');
  }
}

// Stream đơn giản với async*
Stream<int> countDown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // "yield" = emit giá trị ra stream
  }
}

// Stream từ List
Stream<String> fruitsStream() {
  return Stream.fromIterable(['Táo', 'Cam', 'Chuối']); // Tạo stream từ list
}
```

**Giải thích từng bước:**
1. `async*` = đánh dấu function này tạo Stream
2. Vòng for chạy từ 1 đến max
3. `await Future.delayed` = đợi 1 giây
4. `yield i` = "đẩy" số i ra Stream
5. Ai đang lắng nghe sẽ nhận được số i

### 4.4 Lắng nghe Stream

```dart
// Cách 1: listen
countUp(5).listen((number) {
  print('Nhận được: $number');
});

countDown(5).listen(
  (number) => print('Countdown: $number'), // Khi có giá trị
  onDone: () => print('Blast off!'), // Khi stream kết thúc
  onError: (error) => print('Error: $error'), // Khi có lỗi
);

// Cách 2: await for (trong async function)
Future<void> printCountdown() async {
  await for (var number in countDown(5)) {
    print('Countdown: $number');
  }
  print('Blast off!'); // Cất cánh!
}
```

### 4.5 Stream Transformations (Biến đổi Stream)

```dart
// Tạo stream từ list
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

### 4.6 Hình dung Stream như ống nước

```
┌────────────────────────────────────────────────┐
│                    STREAM                      │
│                                                │
│   [Nguồn phát]  ─────►  ─────►  [Người nghe]   │
│                                                │
│   yield 1  ──► 1 ──► 2 ──► 3 ──►  listen()     │
│   yield 2                                      │
│   yield 3                                      │
└────────────────────────────────────────────────┘
```

- **Nguồn phát (Source)**: Code có `yield`
- **Ống nước (Stream)**: Dòng dữ liệu chảy qua
- **Người nghe (Listener)**: Code có `listen()` hoặc `await for`

### 4.7 Stream trong thực tế Flutter

```dart
// 1. Lắng nghe input từ TextField (mỗi ký tự gõ vào)
// 2. Nhận tin nhắn chat realtime
// 3. Cập nhật vị trí GPS liên tục
// 4. Countdown timer
// 5. WebSocket nhận data từ server
```

---

## 5. StreamController - Tự tạo Stream

### 5.1 Khi nào cần StreamController?

Khi bạn muốn **tự kiểm soát** việc phát data vào Stream:

```dart
import 'dart:async';

class CounterService {
  // Tạo StreamController
  final _controller = StreamController<int>();
  
  // Expose stream ra ngoài
  Stream<int> get counterStream => _controller.stream;
  
  // Method để phát data
  void increment(int value) {
    _controller.add(value); // Phát value vào stream
  }
  
  // QUAN TRỌNG: Phải đóng khi không dùng nữa!
  void dispose() {
    _controller.close();
  }
}
```

### 5.2 Sử dụng

```dart
var service = CounterService();

// Lắng nghe
service.counterStream.listen((value) {
  print('Counter: $value');
});

// Phát data
service.increment(1); // In ra: Counter: 1
service.increment(2); // In ra: Counter: 2
service.increment(3); // In ra: Counter: 3

// Đóng khi xong
service.dispose();
```

### 5.3 Broadcast Stream (Nhiều người nghe)

```dart
class EventBus {
  // Broadcast = nhiều listeners
  final _controller = StreamController<String>.broadcast();
  
  // Expose stream ra ngoài
  Stream<String> get events => _controller.stream;
  
  // Phát data
  void emit(String event) {
    _controller.add(event);
  }
  
  // Đóng stream
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

// Giả lập network call
Future<String> fetchFromNetwork() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data from network';
}

// fetchSafely hàm fetch data an toàn
Future<Result<String>> fetchSafely() async {
  try {
    // Giả lập network call
    var data = await fetchFromNetwork();
    // Trả về kết quả thành công
    return Result.success(data);
  } catch (e) {
    // Trả về lỗi
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
File: `exercises/exercise_07_future.dart`
- Viết function `delayedHello(String name)` trả về Future<String> sau 2 giây.

### Bài 2: Xử lý nhiều Future
File: `exercises/exercise_08_multiple_futures.dart`
- Viết function `fetchAllUsers()` gọi đồng thời 3 API và trả về danh sách users.

### Bài 3: Stream
File: `exercises/exercise_09_stream.dart`
- Tạo Stream phát ra số từ 1 đến 10, mỗi giây 1 số.

### Bài 4: StreamController
File: `exercises/exercise_10_stream_controller.dart`
- Tạo class `NumberEmitter` với method `add(int n)` và stream `numbers`.

---

## 📝 Checklist Bài 3

- [ ] Hiểu tại sao cần async (không block UI)
- [ ] Viết được Future với async/await
- [ ] Biết dùng Future.wait để chạy song song
- [ ] **Hiểu Stream là gì** (dòng dữ liệu liên tục)
- [ ] Biết tạo Stream với async* và yield
- [ ] Biết lắng nghe Stream với listen() hoặc await for
- [ ] Biết dùng StreamController
- [ ] Hoàn thành 4 bài tập

**Tiếp theo:** Bài 4 - Collections: List, Map, Set, Generics
