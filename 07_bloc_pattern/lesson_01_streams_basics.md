# Lesson 01: Streams Foundation (Nền tảng của BLoC)

## 1. Stream là gì?

Hãy tưởng tượng **Stream** giống như một "băng chuyền" hoặc một "ống nước":
- Dữ liệu (data) chảy qua ống từ đầu này sang đầu kia.
- Bạn đứng ở cuối ống để nhận dữ liệu khi nó đến.
- Nếu ống vỡ (error), bạn cũng nhận được thông báo lỗi.
- Khi không còn nước (done), bạn biết quá trình đã kết thúc.

Trong Dart/Flutter, Stream là nền tảng cốt lõi của BLoC:
- **BLoC Pattern** thực chất là việc quản lý Input (Events) và Output (States) thông qua Streams.

## 2. Các khái niệm chính

### StreamController
Là "người điều khiển" dòng chảy. Nó có 2 đầu:
1.  **Sink (Input)**: Nơi bạn bỏ dữ liệu vào (`controller.sink.add(data)`).
2.  **Stream (Output)**: Nơi dữ liệu đi ra để bạn lắng nghe (`controller.stream.listen(...)`).

### Subscription
Khi bạn `listen` một stream, bạn nhận được một `Subscription`.
- **Quan trọng**: Luôn phải `cancel` subscription khi không dùng nữa để tránh Memory Leak (tràn bộ nhớ).

### StreamBuilder
Widget trong Flutter giúp tự động xây dựng UI dựa trên dữ liệu từ Stream.
- Tự động `listen` khi init.
- Tự động `setState` khi có data mới.
- Tự động `cancel` khi widget bị dispose.
- Rất tiện lợi và an toàn!

## 3. Single Subscription vs Broadcast

### Single Subscription Stream (Mặc định)
- Chỉ cho phép **MỘT** người nghe (listener).
- Giống như hộp quà bí mật, chỉ một người mở được.
- Ví dụ: Đọc file, Request API.

### Broadcast Stream
- Cho phép **NHIỀU** người nghe cùng lúc.
- Giống như đài phát thanh (Radio), ai cũng có thể bật lên nghe.
- Ví dụ: Sự kiện click chuột, Webhook, Event Bus.

## 4. Các thao tác trên Stream (Transformations)

Giống như List, bạn có thể biến đổi Stream:
- `map`: Biến đổi từng phần tử (VD: Stream<int> -> Stream<String>).
- `where`: Lọc phần tử (VD: Chỉ lấy số chẵn).
- `distinct`: Bỏ qua các giá trị trùng lặp liên tiếp.
- `debounce` (cần `rxdart`): Chờ một lát mới phát ra (dùng cho Search).

---

## 5. Bài tập thực hành

### Ex01: Stream Controller Basics
- **File**: `exercises/ex01_stream_controller.dart`
- **Mục tiêu**: Tự tạo `StreamController`, thêm data vào `Sink`, và `listen` ở đầu ra. Hiểu cơ chế hoạt động cơ bản nhất.

### Ex02: Stream Transformations
- **File**: `exercises/ex02_stream_transformation.dart`
- **Mục tiêu**: Sử dụng `map`, `where` để xử lý dữ liệu *trước khi* nó đến UI.

### Ex03: StreamBuilder Widget
- **File**: `exercises/ex03_stream_builder.dart`
- **Mục tiêu**: Dùng `StreamBuilder` để update UI tự động. Đây là cách Flutter giao tiếp với Stream.

---

> [!TIP]
> **Stream** là "trái tim" của BLoC. Hãy nắm vững nó trước khi qua bài 2. BLoC/Cubit chỉ là lớp vỏ bọc (wrapper) giúp việc dùng Stream dễ dàng và có cấu trúc hơn mà thôi!
