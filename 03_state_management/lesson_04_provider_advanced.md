# Bài 4: Provider Advanced

## 🎯 Mục tiêu bài học
- Sử dụng **MultiProvider** cho nhiều state
- Tối ưu rebuild với **Selector**
- Hiểu **ProxyProvider** để kết hợp providers
- Sử dụng **FutureProvider** và **StreamProvider**

---

## 1. MultiProvider - Nhiều State

### 1.1. Vấn đề: Nested Providers

Khi app có nhiều state, code sẽ rất xấu:

```dart
// ❌ Nested hell
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserNotifier(),
      child: ChangeNotifierProvider(
        create: (_) => CartNotifier(),
        child: ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
          child: ChangeNotifierProvider(
            create: (_) => SettingsNotifier(),
            child: MyApp(), // 😵 Quá sâu!
          ),
        ),
      ),
    ),
  );
}
```

### 1.2. Giải pháp: MultiProvider

```dart
// ✅ Phẳng và dễ đọc
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserNotifier()),
        ChangeNotifierProvider(create: (_) => CartNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => SettingsNotifier()),
      ],
      child: MyApp(),
    ),
  );
}
```

### 1.3. Thứ tự quan trọng

Nếu provider B phụ thuộc provider A, A phải đặt TRƯỚC B:

```dart
MultiProvider(
  providers: [
    // 1️⃣ Auth trước
    ChangeNotifierProvider(create: (_) => AuthNotifier()),
    
    // 2️⃣ User phụ thuộc Auth
    ChangeNotifierProxyProvider<AuthNotifier, UserNotifier>(
      create: (_) => UserNotifier(),
      update: (_, auth, user) => user!..updateAuth(auth),
    ),
  ],
  child: MyApp(),
)
```

---

## 2. Selector - Tối ưu Rebuild

### 2.1. Vấn đề: Rebuild không cần thiết

```dart
class UserNotifier extends ChangeNotifier {
  String name = 'John';
  int age = 25;
  String avatar = 'url';
  
  void updateName(String n) {
    name = n;
    notifyListeners(); // Notify TẤT CẢ listeners
  }
}

// Widget chỉ hiển thị name
class NameDisplay extends StatelessWidget {
  Widget build(BuildContext context) {
    // 😓 Rebuild khi age hoặc avatar thay đổi (không cần thiết!)
    final user = context.watch<UserNotifier>();
    return Text(user.name);
  }
}
```

### 2.2. Giải pháp: Selector

```dart
class NameDisplay extends StatelessWidget {
  Widget build(BuildContext context) {
    // ✅ Chỉ rebuild khi `name` thay đổi
    final name = context.select<UserNotifier, String>((u) => u.name);
    return Text(name);
  }
}
```

### 2.3. Selector với nhiều fields

```dart
// Cách 1: Tạo tuple/record
final (name, avatar) = context.select<UserNotifier, (String, String)>(
  (u) => (u.name, u.avatar),
);

// Cách 2: Dùng nhiều select (khuyến khích)
final name = context.select<UserNotifier, String>((u) => u.name);
final avatar = context.select<UserNotifier, String>((u) => u.avatar);
```

### 2.4. Selector Widget

```dart
Selector<UserNotifier, String>(
  selector: (_, user) => user.name,
  builder: (context, name, child) {
    return Text(name);
  },
)
```

---

## 3. Consumer vs Selector

| Tiêu chí | Consumer | Selector |
|----------|----------|----------|
| **Rebuild khi** | Bất kỳ thay đổi nào | Chỉ khi selected value thay đổi |
| **Performance** | Thấp hơn | Cao hơn |
| **Dùng khi** | Cần toàn bộ object | Chỉ cần 1-2 fields |
| **Code** | Ngắn hơn | Dài hơn một chút |

---

## 4. ProxyProvider - Kết hợp Providers

### 4.1. Tình huống

Cart cần biết user đang login để tính discount.

### 4.2. ChangeNotifierProxyProvider

```dart
class CartNotifier extends ChangeNotifier {
  List<CartItem> items = [];
  AuthNotifier? _auth;
  
  void updateAuth(AuthNotifier auth) {
    _auth = auth;
    // Có thể tính lại total với discount nếu user là VIP
    notifyListeners();
  }
  
  double get total {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.price);
    final discount = (_auth?.isVip ?? false) ? 0.1 : 0;
    return subtotal * (1 - discount);
  }
}

// Trong MultiProvider
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthNotifier()),
    
    ChangeNotifierProxyProvider<AuthNotifier, CartNotifier>(
      create: (_) => CartNotifier(),
      update: (context, auth, cart) {
        // Mỗi khi AuthNotifier thay đổi, update được gọi
        return cart!..updateAuth(auth);
      },
    ),
  ],
  child: MyApp(),
)
```

---

## 5. FutureProvider - Async Data

### 5.1. Tình huống

Load data từ API khi app start.

### 5.2. Cách dùng

```dart
// Provider
FutureProvider<List<Product>>(
  create: (_) async {
    // Gọi API
    final response = await http.get(Uri.parse('api/products'));
    return parseProducts(response.body);
  },
  initialData: [], // Data ban đầu khi đang loading
)

// Trong widget
class ProductList extends StatelessWidget {
  Widget build(BuildContext context) {
    final products = context.watch<List<Product>>();
    
    if (products.isEmpty) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, i) => ProductTile(products[i]),
    );
  }
}
```

### 5.3. Xử lý Loading/Error với AsyncValue

```dart
// Dùng với AsyncValue để handle states tốt hơn
FutureProvider<AsyncValue<List<Product>>>(...)
```

> **Ghi chú**: Riverpod xử lý async tốt hơn nhiều, xem Bài 5.

---

## 6. StreamProvider - Realtime Data

### 6.1. Tình huống

Lắng nghe data realtime (Firebase, WebSocket).

### 6.2. Cách dùng

```dart
// Provider
StreamProvider<List<Message>>(
  create: (_) => firestore
      .collection('messages')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((d) => Message.fromJson(d.data())).toList()),
  initialData: [],
)

// Widget tự động update khi có message mới
class MessageList extends StatelessWidget {
  Widget build(BuildContext context) {
    final messages = context.watch<List<Message>>();
    return ListView.builder(...);
  }
}
```

---

## 7. Consumer với child (Tối ưu)

### 7.1. Vấn đề

```dart
Consumer<CounterNotifier>(
  builder: (context, counter, child) {
    return Column(
      children: [
        Text('${counter.count}'), // Rebuild ✅
        HeavyWidget(), // CŨNG rebuild 😓 (không cần thiết)
      ],
    );
  },
)
```

### 7.2. Giải pháp: Dùng `child` parameter

```dart
Consumer<CounterNotifier>(
  // child được build 1 lần, không rebuild
  child: HeavyWidget(), 
  
  builder: (context, counter, child) {
    return Column(
      children: [
        Text('${counter.count}'), // Rebuild khi count thay đổi
        child!, // Không rebuild, tái sử dụng widget cũ
      ],
    );
  },
)
```

---

## 📝 Bài tập

### Ex08: MultiProvider Setup
File: `ex08_multi_provider.dart`
- Tạo 3 Notifiers: Counter, Theme, User
- Dùng MultiProvider
- Hiển thị data từ cả 3 trong 1 screen

### Ex09: Selector Optimization
File: `ex09_selector.dart`
- Tạo UserNotifier với name, age, email
- 3 widgets riêng hiển thị từng field
- Dùng Selector để chỉ rebuild widget cần thiết
- Thêm debug print để verify

### Ex10: Consumer with Child
File: `ex10_consumer_widget.dart`
- Counter với heavy animation widget
- Sử dụng Consumer child để tối ưu
- So sánh performance có/không có child

---

## 🔑 Tóm tắt

1. **MultiProvider**: Gộp nhiều provider phẳng, tránh nested
2. **Selector**: Chỉ rebuild khi field cụ thể thay đổi
3. **ProxyProvider**: Kết hợp providers phụ thuộc nhau
4. **FutureProvider**: Async data (API call)
5. **StreamProvider**: Realtime data (Firebase, WebSocket)
6. **Consumer child**: Widget không đổi, tránh rebuild

---

## ➡️ Tiếp theo

[Bài 5: Riverpod](lesson_05_riverpod.md)
