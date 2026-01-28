# Phase 1: Dart Fundamentals - Bài 3: Async Programming

## Mục tiêu bài học
- Hiểu tại sao cần lập trình bất đồng bộ (async)
- Thành thạo Future và async/await
- **Hiểu rõ Stream** (từ cơ bản đến nâng cao)

---

## 1. Tại Sao Cần Async?

### 1.1 Vấn đề: Blocking Code

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
  }
}
```

**Tại sao async/await tốt hơn?**
- Đọc như code bình thường (từ trên xuống)
- Dễ debug hơn
- try/catch quen thuộc

---

## 3. Xử lý nhiều Future song song

### 3.1 Tuần tự vs Song song

```dart
// ❌ Tuần tự - CHẬM (6 giây)
var user = await fetchUser();      // 2 giây
var products = await fetchProducts(); // 2 giây
var orders = await fetchOrders();  // 2 giây

// ✅ Song song - NHANH (2 giây, lấy max)
var results = await Future.wait([
  fetchUser(),      // 2 giây ─┐
  fetchProducts(),  // 2 giây ─┼─► Chạy cùng lúc!
  fetchOrders(),    // 2 giây ─┘
]);
```

---

## 4. Stream - Giải thích SIÊU CHI TIẾT

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

### 4.2 Ví dụ trực quan

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
```

**Giải thích từng bước:**
1. `async*` = đánh dấu function này tạo Stream
2. Vòng for chạy từ 1 đến max
3. `await Future.delayed` = đợi 1 giây
4. `yield i` = "đẩy" số i ra Stream
5. Ai đang lắng nghe sẽ nhận được số i

### 4.4 Lắng nghe Stream

```dart
// Cách 1: listen()
countUp(5).listen((number) {
  print('Nhận được: $number');
});

// Cách 2: await for (trong async function)
Future<void> printNumbers() async {
  await for (var number in countUp(5)) {
    print('Nhận được: $number');
  }
  print('Stream kết thúc!');
}
```

### 4.5 Hình dung Stream như ống nước

```
┌────────────────────────────────────────────────┐
│                    STREAM                       │
│                                                │
│   [Nguồn phát]  ─────►  ─────►  [Người nghe]   │
│                                                │
│   yield 1  ──► 1 ──► 2 ──► 3 ──►  listen()    │
│   yield 2                                      │
│   yield 3                                      │
└────────────────────────────────────────────────┘
```

- **Nguồn phát (Source)**: Code có `yield`
- **Ống nước (Stream)**: Dòng dữ liệu chảy qua
- **Người nghe (Listener)**: Code có `listen()` hoặc `await for`

### 4.6 Stream trong thực tế Flutter

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
// Mặc định: Chỉ 1 listener
final _controller = StreamController<int>();

// Broadcast: Nhiều listeners
final _controller = StreamController<int>.broadcast();
```

---

## 6. Bài Tập Thực Hành

| Bài | File | Nội dung |
|-----|------|----------|
| 1 | `exercises/exercise_07_future.dart` | Future cơ bản |
| 2 | `exercises/exercise_08_multiple_futures.dart` | Future.wait |
| 3 | `exercises/exercise_09_stream.dart` | Tạo Stream với async*/yield |
| 4 | `exercises/exercise_10_stream_controller.dart` | StreamController |

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

**Kết thúc Phase 1!** Tiếp theo: Phase 2 - Flutter Basics & Widget System
