# Lesson 02: Basic Navigation (Navigator 1.0) 🏃‍♂️

## 1. MaterialPageRoute

Để chuyển màn hình, chúng ta cần gói Widget màn hình vào một `Route`. Phổ biến nhất là `MaterialPageRoute`.
Nó cung cấp transition animation chuẩn của Android/iOS (trượt từ dưới lên hoặc từ phải sang).

```dart
// Tạo một Route
final route = MaterialPageRoute(
  builder: (context) => SecondScreen(),
);
```

## 2. Push (Đi tới)

Dùng `Navigator.of(context).push(route)` hoặc `Navigator.push(context, route)`.

```dart
// Cách viết gọn
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DetailScreen()),
);
```

**Lưu ý:** `context` ở đây rất quan trọng. Nó giúp Navigator biết vị trí hiện tại trong Widget Tree.

## 3. Pop (Quay về)

Dùng `Navigator.of(context).pop()`.

```dart
// Quay lại màn hình trước đó
Navigator.pop(context);
```

## 4. Passing Data (Truyền dữ liệu)

### Truyền đi (Forward)
Dữ liệu được truyền đơn giản qua **Constructor** của Widget đích.

```dart
// Screen nhận data
class DetailScreen extends StatelessWidget {
  final String message; // Data cần nhận
  
  const DetailScreen({super.key, required this.message});
  
  // ...
}

// Khi Push
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(message: "Hello from Home!"),
  ),
);
```

### Trả về (Backward)
`Navigator.pop` có thể kèm theo một giá trị kết quả (`result`).
`Navigator.push` trả về một `Future`, chúng ta có thể `await` kết quả đó.

```dart
// Tại màn hình Detail (khi đóng)
Navigator.pop(context, "Kết quả xử lý");

// Tại màn hình Home (khi gọi)
final result = await Navigator.push(...);
print(result); // In ra "Kết quả xử lý"
```

## 5. Thay thế màn hình (PushReplacement)

Dùng khi bạn muốn chuyển màn hình và **không muốn quay lại** màn hình cũ (ví dụ: Splash Screen -> Login, hoặc Login -> Home).

```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);
```
Khi này, màn hình cũ bị hủy khỏi Stack. Nút Back sẽ thoát app (nếu stack rỗng).
