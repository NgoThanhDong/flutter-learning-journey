# Bài 3: Provider Basics

## 🎯 Mục tiêu bài học
- Cài đặt và cấu hình **Provider**
- Hiểu **ChangeNotifier** - class lưu state
- Sử dụng **ChangeNotifierProvider** - cung cấp state
- Phân biệt **Consumer** vs **context.watch/read/select**

---

## 1. Provider là gì?

### 1.1. Định nghĩa

> **Provider** là package State Management phổ biến nhất trong Flutter.
> Được Google recommend, dễ học, đủ mạnh cho hầu hết ứng dụng.

### 1.2. Tại sao dùng Provider?

| Vấn đề | Provider giải quyết |
|--------|---------------------|
| Prop Drilling | Widget con lấy state trực tiếp |
| Boilerplate InheritedWidget | Cung cấp API đơn giản |
| Widget rebuild không cần thiết | Chỉ rebuild widget lắng nghe |
| Test khó | Dễ dàng mock (mô phỏng) và test |

### 1.3. Cài đặt

Trong `pubspec.yaml`:
```yaml
dependencies:
  provider: ^6.1.5
```

Chạy:
```bash
flutter pub get
```

---

## 2. ChangeNotifier - Class lưu State

### 2.1. Khái niệm

> **ChangeNotifier** là class có khả năng notify (thông báo) khi data thay đổi.
> Các widget đang lắng nghe sẽ được rebuild.

### 2.2. Cách tạo

```dart
import 'package:flutter/foundation.dart';

// 1️⃣ Extend ChangeNotifier
class CounterNotifier extends ChangeNotifier {
  // 2️⃣ Khai báo state (private với underscore)
  int _count = 0;
  
  // 3️⃣ Getter để đọc state
  int get count => _count;
  
  // 4️⃣ Methods để thay đổi state
  void increment() {
    _count++;
    notifyListeners(); // 🔔 BẮT BUỘC: Thông báo cho listeners
  }
  
  void decrement() {
    _count--;
    notifyListeners();
  }
  
  void reset() {
    _count = 0;
    notifyListeners();
  }
}
```

### 2.3. Quy tắc quan trọng

| Quy tắc | Mô tả |
|---------|-------|
| **Luôn gọi notifyListeners()** | Sau khi thay đổi state, PHẢI gọi để UI cập nhật |
| **State nên private** | Dùng `_` prefix (tiền tố), expose (phơi ra) qua getter |
| **Immutable (bất biến) khi cần** | Với List/Map, tạo bản copy mới thay vì mutate |

### 2.4. Ví dụ với List

```dart
class TodoNotifier extends ChangeNotifier {
  // List state
  final List<String> _todos = [];
  
  // Getter trả về bản copy (immutable)
  List<String> get todos => List.unmodifiable(_todos);
  
  void addTodo(String todo) {
    _todos.add(todo);
    notifyListeners();
  }
  
  void removeTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }
  
  void toggleTodo(int index) {
    // Nếu todo là object có isCompleted
    // _todos[index].isCompleted = !_todos[index].isCompleted;
    notifyListeners();
  }
}
```

---

## 3. ChangeNotifierProvider - Cung cấp State

### 3.1. Đặt Provider ở đâu?

Đặt **TRÊN** tất cả widget cần dùng state đó.

```dart
void main() {
  runApp(
    // Provider bao bọc MaterialApp = toàn app có thể truy cập
    ChangeNotifierProvider(
      create: (context) => CounterNotifier(),
      child: MyApp(),
    ),
  );
}
```

### 3.2. Giải thích code

```dart
ChangeNotifierProvider(
  // `create`: Hàm tạo instance của ChangeNotifier
  // Chỉ chạy 1 lần khi Provider được mount
  create: (context) => CounterNotifier(),
  
  // `child`: Widget tree bên dưới có thể truy cập state
  child: MyApp(),
)
```

### 3.3. Đặt ở cấp thấp hơn

Nếu state chỉ cần cho 1 màn hình:

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterNotifier(),
      child: Scaffold(
        body: CounterBody(),
      ),
    );
  }
}
```

---

## 4. Đọc State trong Widget

### 4.1. Cách 1: Consumer Widget

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterNotifier>(
      // builder được gọi lại mỗi khi state thay đổi
      builder: (context, counter, child) {
        return Text('Count: ${counter.count}');
      },
    );
  }
}
```

**Giải thích tham số builder:**
| Tham số | Mô tả |
|---------|-------|
| `context` | BuildContext hiện tại |
| `counter` | Instance của CounterNotifier |
| `child` | Widget không cần rebuild (tối ưu) |

### 4.2. Cách 2: context.watch (Recommended)

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 👀 watch = lắng nghe + rebuild khi thay đổi
    final counter = context.watch<CounterNotifier>();
    
    return Text('Count: ${counter.count}');
  }
}
```

### 4.3. Cách 3: context.read (Không rebuild)

```dart
class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 📖 read = chỉ đọc, KHÔNG lắng nghe thay đổi
        // Dùng trong callback, onPressed, initState
        context.read<CounterNotifier>().increment();
      },
      child: Text('+'),
    );
  }
}
```

### 4.4. So sánh watch vs read

| Phương thức | Khi nào dùng | Rebuild? |
|-------------|--------------|----------|
| `context.watch<T>()` | Trong build(), cần hiển thị data | ✅ Có |
| `context.read<T>()` | Trong callback, onPressed, không cần hiển thị | ❌ Không |

### 4.5. Cách 4: context.select (Chỉ lắng nghe 1 phần)

```dart
class UserNameDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Chỉ rebuild khi `name` thay đổi, không quan tâm các field khác
    final name = context.select<UserNotifier, String>((user) => user.name);
    
    return Text('Hello, $name');
  }
}
```

---

## 5. Ví dụ hoàn chỉnh

### 5.1. File: counter_notifier.dart

```dart
import 'package:flutter/foundation.dart';

class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
  
  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }
  
  void reset() {
    _count = 0;
    notifyListeners();
  }
}
```

### 5.2. File: main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display: dùng watch để rebuild khi count thay đổi
            Consumer<CounterNotifier>(
              builder: (context, counter, _) {
                return Text(
                  '${counter.count}',
                  style: TextStyle(fontSize: 48),
                );
              },
            ),
            
            SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Buttons: dùng read vì không cần rebuild
                ElevatedButton(
                  onPressed: () => context.read<CounterNotifier>().decrement(),
                  child: Text('-'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<CounterNotifier>().increment(),
                  child: Text('+'),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            TextButton(
              onPressed: () => context.read<CounterNotifier>().reset(),
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Các lỗi thường gặp

### 6.1. ProviderNotFoundException

```
Error: Could not find the correct Provider<CounterNotifier>
```

**Nguyên nhân**: Widget truy cập Provider nhưng Provider không tồn tại phía trên.

**Fix**: Đảm bảo ChangeNotifierProvider bao bọc widget cần dùng.

### 6.2. Quên notifyListeners()

**Triệu chứng**: State thay đổi nhưng UI không update.

**Fix**: Kiểm tra tất cả methods thay đổi state đã gọi `notifyListeners()` chưa.

### 6.3. Dùng read thay vì watch trong build()

```dart
// ❌ SAI: dùng read trong build → UI không update
Widget build(BuildContext context) {
  final counter = context.read<CounterNotifier>(); // WRONG!
  return Text('${counter.count}');
}

// ✅ ĐÚNG: dùng watch trong build
Widget build(BuildContext context) {
  final counter = context.watch<CounterNotifier>(); // CORRECT!
  return Text('${counter.count}');
}
```

---

## 📝 Bài tập

### Ex04: Counter với Provider
File: `ex04_counter_provider.dart`
- Tạo CounterNotifier
- Hiển thị count, buttons +/-/Reset
- Sử dụng watch và read đúng cách

### Ex05: Theme Provider
File: `ex05_theme_provider.dart`
- Tạo ThemeNotifier với isDarkMode
- Toggle button thay đổi theme toàn app
- Sử dụng Provider ở level MaterialApp

### Ex06: Todo với Provider
File: `ex06_todo_provider.dart`
- Tạo TodoNotifier với List<Todo>
- Thêm, xóa, toggle complete
- Input field + ListView hiển thị

### Ex07: Shopping Cart Provider
File: `ex07_cart_provider.dart`
- Tạo CartNotifier (List<CartItem>, total)
- Add to cart, remove, update quantity
- Hiển thị cart badge và cart screen

---

## 🔑 Tóm tắt

1. **ChangeNotifier**: Class lưu state, gọi `notifyListeners()` khi thay đổi
2. **ChangeNotifierProvider**: Cung cấp state cho widget tree
3. **context.watch**: Đọc VÀ lắng nghe → dùng trong build()
4. **context.read**: Chỉ đọc → dùng trong callbacks
5. **Consumer**: Widget wrapper, tương đương watch
6. **select**: Chỉ lắng nghe 1 phần của state

---

## ➡️ Tiếp theo

[Bài 4: Provider Advanced](lesson_04_provider_advanced.md)
