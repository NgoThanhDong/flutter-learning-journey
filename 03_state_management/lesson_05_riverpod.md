# Bài 5: Riverpod

## 🎯 Mục tiêu bài học
- Hiểu tại sao dùng Riverpod thay Provider
- Học các loại Provider trong Riverpod
- Sử dụng **StateNotifier** và **AsyncNotifier**
- Hiểu **ref.watch**, **ref.read**, và **ref.listen**

---

## 1. Tại sao dùng Riverpod?

### 1.1. Vấn đề của Provider

| Vấn đề | Mô tả |
|--------|-------|
| **Cần BuildContext** | Không thể dùng trong business logic |
| **Runtime errors** | Lỗi chỉ phát hiện khi chạy app |
| **ProviderNotFoundException** | Quên đặt Provider ở trên |
| **Test khó** | Phải mock BuildContext |

### 1.2. Riverpod giải quyết

| Tính năng | Mô tả |
|-----------|-------|
| **Compile-safe** | Lỗi phát hiện ngay khi viết code |
| **Không cần BuildContext** | Có thể dùng ở bất kỳ đâu |
| **Tự động dispose** | Auto cleanup khi không còn dùng |
| **Dễ test** | Có ProviderContainer để test |
| **Không cần context** | Provider là global, truy cập từ mọi nơi |

### 1.3. Cài đặt

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
```

---

## 2. Setup Riverpod

### 2.1. Wrap app với ProviderScope

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // ProviderScope thay thế MultiProvider
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 2.2. Tạo Provider (Global)

```dart
// Providers được khai báo GLOBAL, bên ngoài class
final counterProvider = StateProvider<int>((ref) => 0);
```

### 2.3. Đọc Provider trong Widget

```dart
// Extend ConsumerWidget thay vì StatelessWidget
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dùng ref thay vì context
    final count = ref.watch(counterProvider);
    
    return Text('Count: $count');
  }
}
```

---

## 3. Các loại Provider

### 3.1. Provider - Read-only

```dart
// Giá trị không thay đổi được từ UI
final greetingProvider = Provider<String>((ref) => 'Hello, World!');

// Có thể depend on other providers (phụ thuộc vào providers khác)
final userGreetingProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider);
  return 'Hello, ${user.name}!';
});
```

### 3.2. StateProvider - Simple State

```dart
// State đơn giản (int, String, bool)
final counterProvider = StateProvider<int>((ref) => 0);
final isDarkProvider = StateProvider<bool>((ref) => false);

// Đọc
final count = ref.watch(counterProvider);

// Ghi
ref.read(counterProvider.notifier).state++;

// Hoặc update
ref.read(counterProvider.notifier).update((state) => state + 1);
```

### 3.3. StateNotifierProvider - Complex State (State phức tạp)

```dart
// 1️⃣ Tạo StateNotifier
class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]); // Super = initial state
  
  void addTodo(Todo todo) {
    // QUAN TRỌNG: Tạo list MỚI, không mutate list cũ
    state = [...state, todo];
  }
  
  void removeTodo(String id) {
    state = state.where((t) => t.id != id).toList();
  }
  
  void toggleTodo(String id) {
    state = state.map((t) {
      if (t.id == id) {
        return Todo(id: t.id, title: t.title, completed: !t.completed);
      }
      return t;
    }).toList();
  }
}

// 2️⃣ Tạo Provider
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

// 3️⃣ Sử dụng
class TodoScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(todos[i].title),
        onTap: () => ref.read(todoProvider.notifier).toggleTodo(todos[i].id),
      ),
    );
  }
}
```

### 3.4. FutureProvider - Async Data

```dart
// Fetch data từ API
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final response = await http.get(Uri.parse('api/products'));
  return parseProducts(response.body);
});

// Sử dụng với AsyncValue
class ProductList extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    
    return productsAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) => ProductTile(products[i]),
      ),
    );
  }
}
```

### 3.5. StreamProvider - Realtime

```dart
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return firestore.collection('messages').snapshots().map(...);
});
```

---

## 4. ref.watch vs ref.read vs ref.listen

### 4.1. ref.watch

```dart
// ✅ Dùng trong build()
// Widget rebuild khi provider thay đổi
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.watch(counterProvider);
  return Text('$count');
}
```

### 4.2. ref.read

```dart
// ✅ Dùng trong callbacks, onPressed
// KHÔNG rebuild widget
ElevatedButton(
  onPressed: () {
    ref.read(counterProvider.notifier).state++;
  },
  child: Text('+'),
)
```

### 4.3. ref.listen

```dart
// Thực hiện side effect (tạc dụng phụ) khi state thay đổi
// (show snackbar, navigate, etc.)
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen(authProvider, (previous, next) {
    if (next == null) {
      // User logged out, navigate to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  });
  
  return HomeScreen();
}
```

- [WidgetRef ref] là tham số bắt buộc của ConsumerWidget
- [ref] giống như [Provider.of(context)] nhưng có thêm các method tiện ích
- [ref.watch] Đọc VÀ lắng nghe thay đổi
- [ref.read] Chỉ đọc, KHÔNG lắng nghe
- [ref.invalidate] Reset provider về giá trị ban đầu
- [ref.keepAlive] Giữ provider sống khi không còn lắng nghe
- [ref.dispose] Dispose provider
- [ref.listen] Lắng nghe thay đổi và thực hiện hành động
- [ref.family] Tạo provider với tham số
- [ref.autoDispose] Tự động dispose khi không còn lắng nghe
- [ref.family.autoDispose] Tạo provider với tham số và tự động dispose
- [ref.overrideWithValue] Override giá trị của provider
- [ref.read(provider.notifier)] đọc notifier của provider
- [ref.read(provider.notifier).method()] gọi method của notifier

### 4.4. Bảng so sánh

| Phương thức | Rebuild? | Dùng ở đâu |
|-------------|----------|------------|
| `ref.watch` | ✅ Có | build() |
| `ref.read` | ❌ Không | callbacks, onPressed |
| `ref.listen` | ❌ Không | Side effects |

---

## 5. ConsumerWidget vs Consumer

### 5.1. ConsumerWidget (Toàn bộ widget)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}
```

### 5.2. Consumer (Một phần widget)

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Static text'), // Không rebuild
        
        Consumer(
          builder: (context, ref, child) {
            final value = ref.watch(myProvider);
            return Text('$value'); // Chỉ phần này rebuild
          },
        ),
      ],
    );
  }
}
```

---

## 6. Provider Modifiers (Các phần bổ trợ của Provider)

### 6.1. .family - Provider với parameter

```dart
// Provider nhận parameter
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final response = await http.get(Uri.parse('api/users/$userId'));
  return User.fromJson(response.body);
});

// Sử dụng
final user = ref.watch(userProvider('user_123'));
```

### 6.2. .autoDispose - Tự động cleanup

```dart
// Khi không còn widget nào watch, provider sẽ bị dispose
final searchProvider = StateProvider.autoDispose<String>((ref) => '');

// FutureProvider cũng có thể autoDispose
final productDetailProvider = FutureProvider.autoDispose.family<Product, String>(
  (ref, productId) async {
    return await fetchProduct(productId);
  },
);
```

---

## 7. Ví dụ hoàn chỉnh: Counter

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1️⃣ Khai báo provider global
final counterProvider = StateProvider<int>((ref) => 0);

void main() {
  runApp(
    // 2️⃣ Wrap với ProviderScope
    ProviderScope(
      child: MaterialApp(
        home: CounterScreen(),
      ),
    ),
  );
}

// 3️⃣ Dùng ConsumerWidget
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4️⃣ watch trong build
    final count = ref.watch(counterProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Counter')),
      body: Center(
        child: Text('Count: $count', style: TextStyle(fontSize: 48)),
      ),
      floatingActionButton: FloatingActionButton(
        // 5️⃣ read trong callback
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## 📝 Bài tập

### Ex11: Counter với Riverpod
File: `ex11_counter_riverpod.dart`
- Sử dụng StateProvider
- Buttons +, -, Reset
- ConsumerWidget pattern

### Ex12: Todo với StateNotifier
File: `ex12_todo_riverpod.dart`
- TodoNotifier extends StateNotifier
- Add, remove, toggle todos
- Immutable state updates

### Ex13: Async Data
File: `ex13_async_riverpod.dart`
- FutureProvider fake API call
- Handle loading, error, data với .when()
- Refresh button

---

## 🔑 Tóm tắt

1. **ProviderScope**: Wrap app, thay thế MultiProvider
2. **Providers global**: Khai báo bên ngoài widget class
3. **StateProvider**: State đơn giản
4. **StateNotifierProvider**: State phức tạp
5. **FutureProvider**: Async data with loading/error
6. **ref.watch**: Build, rebuild khi thay đổi
7. **ref.read**: Callbacks, không rebuild
8. **.autoDispose**: Cleanup khi không dùng
9. **.family**: Provider với parameters

---

## ➡️ Tiếp theo

[Bài 6: Practice Projects](lesson_06_practice.md)
