# Lesson 01: Streams - Nền Tảng Của BLoC

## 🎯 Mục Tiêu Bài Học
Sau bài này, bạn sẽ hiểu:
- Stream là gì và tại sao BLoC cần nó
- Cách tạo và sử dụng StreamController
- Các operators để transform stream data
- Cách kết nối Stream với UI qua StreamBuilder

## 📚 Lý Thuyết

### 1. Stream vs Future

| Future | Stream |
|--------|--------|
| Trả về **1 giá trị** | Trả về **nhiều giá trị** theo thời gian |
| `Future<int>` | `Stream<int>` |
| Dùng cho: API call đơn lẻ | Dùng cho: Real-time data, user events |

```dart
// Future: Lấy 1 user
Future<User> getUser() async {
  return await api.fetchUser();
}

// Stream: Lắng nghe tin nhắn mới liên tục
Stream<Message> onNewMessage() {
  return firestore.collection('messages').snapshots();
}
```

### 2. StreamController - Bộ Điều Khiển Stream

StreamController có 2 cổng:
- **Sink** (Cổng vào): Thêm data vào stream
- **Stream** (Cổng ra): Lắng nghe data

```dart
final controller = StreamController<int>();

// Thêm data qua Sink
controller.sink.add(1);
controller.sink.add(2);

// Đọc data qua Stream
controller.stream.listen((value) {
  print(value); // 1, 2
});

// QUAN TRỌNG: Luôn đóng controller
controller.close();
```

### 3. Single vs Broadcast Stream

| Single Subscription | Broadcast |
|---------------------|-----------|
| Chỉ 1 listener | Nhiều listeners |
| Mặc định | Phải tạo với `.broadcast()` |
| Dùng cho: File I/O | Dùng cho: UI events |

```dart
// Single (mặc định)
final single = StreamController<int>();

// Broadcast (nhiều listeners)
final broadcast = StreamController<int>.broadcast();
```

### 4. Stream Operators

```dart
final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

numbers
  .where((n) => n.isEven)       // Lọc: [2, 4]
  .map((n) => n * 10)           // Biến đổi: [20, 40]
  .distinct()                   // Loại bỏ trùng
  .listen(print);               // Output: 20, 40
```

### 5. StreamBuilder Widget

```dart
StreamBuilder<int>(
  stream: myStream,
  initialData: 0,         // Giá trị ban đầu
  builder: (context, snapshot) {
    // snapshot.connectionState: waiting, active, done
    // snapshot.hasData: có data không?
    // snapshot.data: lấy data
    // snapshot.hasError: có lỗi không?
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    return Text('Value: ${snapshot.data}');
  },
)
```

## 💻 Bài Tập Thực Hành

| Exercise | Tên | Mục tiêu |
|----------|-----|----------|
| Ex01 | Stream Controller | Tạo counter với StreamController |
| Ex02 | Stream Transformations | Sử dụng map, where, distinct |
| Ex03 | StreamBuilder Widget | Kết nối Stream với UI |

## 🔑 Key Takeaways
1. Stream = Sequence of async events
2. StreamController = Producer, Stream = Consumer
3. Broadcast stream cho nhiều listeners
4. Operators giúp transform data trước khi consume
5. StreamBuilder tự động rebuild khi stream emit

## ⚠️ Lưu Ý Quan Trọng
```dart
@override
void dispose() {
  controller.close(); // LUÔN đóng controller!
  super.dispose();
}
```

---
**Tiếp theo:** [Lesson 02 - Cubit](./lesson_02_cubit.md)
