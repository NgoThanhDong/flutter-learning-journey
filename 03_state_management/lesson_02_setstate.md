# Bài 2: setState & InheritedWidget

## 🎯 Mục tiêu bài học
- Ôn tập và hiểu sâu hơn về `setState`
- Học kỹ thuật **Lifting State Up** (nâng state lên)
- Hiểu **InheritedWidget** - nền tảng của Provider
- Sử dụng **ValueNotifier** & **ValueListenableBuilder**

---

## 1. Ôn tập setState

### 1.1. Cách hoạt động

```dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // 1️⃣ Khai báo state
  int _count = 0;
  
  void _increment() {
    // 2️⃣ Thay đổi state VÀ yêu cầu rebuild
    setState(() {
      _count++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // 3️⃣ Flutter gọi build() lại → UI cập nhật
    return Text('Count: $_count');
  }
}
```

### 1.2. Quy tắc quan trọng

| Quy tắc | Mô tả |
|---------|-------|
| **Luôn gọi setState** | Nếu chỉ thay đổi biến mà không gọi setState → UI không cập nhật |
| **Đừng gọi trong build()** | Gây vòng lặp vô hạn → Crash app |
| **Chỉ thay đổi trong setState** | Code ngoài callback không đảm bảo rebuild |

### 1.3. Giới hạn của setState

```
❌ Chỉ hoạt động trong 1 widget
❌ Không chia sẻ state cho widget khác
❌ Widget rebuild toàn bộ (không tối ưu)
```

---

## 2. Lifting State Up

### 2.1. Khái niệm

> **Lifting State Up** = Đưa state lên widget cha chung khi 2+ widget con cần dùng cùng một state.

### 2.2. Ví dụ: Counter với Display và Buttons tách biệt

**Trước (Không thể chia sẻ state):**
```dart
// Display widget cần đọc count
class CountDisplay extends StatelessWidget { ... }

// Button widget cần thay đổi count
class CountButtons extends StatelessWidget { ... }

// Làm sao cả 2 dùng chung 1 biến count?
```

**Sau (Lifting State Up):**
```dart
// Parent widget giữ state
class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // State đặt ở widget CHA
  int _count = 0;
  
  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Truyền state xuống con (đọc)
        CountDisplay(count: _count),
        
        // Truyền callback xuống con (ghi)
        CountButtons(
          onIncrement: _increment,
          onDecrement: _decrement,
        ),
      ],
    );
  }
}

// Widget con chỉ nhận props, không có state
class CountDisplay extends StatelessWidget {
  final int count;
  const CountDisplay({required this.count});
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CountButtons extends StatelessWidget {
  // onIncrement và onDecrement là các hàm được truyền từ widget cha xuống
  // VoidCallback là kiểu dữ liệu của hàm không nhận tham số và không trả về giá trị
  // Tương đương với: () => void
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  
  const CountButtons({
    required this.onIncrement,
    required this.onDecrement,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: onDecrement, child: Text('-')),
        ElevatedButton(onPressed: onIncrement, child: Text('+')),
      ],
    );
  }
}
```

### 2.3. Ưu nhược điểm

| Ưu điểm | Nhược điểm |
|---------|------------|
| ✅ Đơn giản, không cần package | ❌ Prop Drilling khi widget sâu |
| ✅ Dễ hiểu flow dữ liệu | ❌ Widget cha rebuild → tất cả con rebuild |
| ✅ Phù hợp 2-3 tầng | ❌ Không scale với app lớn |

---

## 3. InheritedWidget

### 3.1. Giới thiệu

> **InheritedWidget** là cách Flutter built-in để chia sẻ data xuống cây widget mà không cần truyền qua constructor.

**Đặc điểm:**
- Là base class mà Provider được xây dựng trên đó
- Widget con dùng `of(context)` để truy cập data
- Khi data thay đổi → widget con rebuild

### 3.2. Cách tạo InheritedWidget

```dart
// 1️⃣ Tạo InheritedWidget
class CounterInherited extends InheritedWidget {
  // Data cần chia sẻ
  final int count;
  final VoidCallback increment;
  
  const CounterInherited({
    super.key,
    required this.count,
    required this.increment,
    required super.child,
  });
  
  // 2️⃣ Phương thức static để lấy instance
  static CounterInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterInherited>()!;
  }
  
  // 3️⃣ Quyết định khi nào widget con cần rebuild
  @override
  bool updateShouldNotify(CounterInherited oldWidget) {
    return count != oldWidget.count;
  }
}
```

### 3.3. Cách sử dụng

```dart
// Widget cha cung cấp InheritedWidget
class CounterProvider extends StatefulWidget {
  final Widget child;
  const CounterProvider({required this.child});
  
  @override
  State<CounterProvider> createState() => _CounterProviderState();
}

class _CounterProviderState extends State<CounterProvider> {
  int _count = 0;
  
  void _increment() => setState(() => _count++);
  
  @override
  Widget build(BuildContext context) {
    return CounterInherited(
      count: _count,
      increment: _increment,
      child: widget.child,
    );
  }
}

// Widget con truy cập data
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy data từ InheritedWidget
    final counter = CounterInherited.of(context);
    
    return Column(
      children: [
        Text('Count: ${counter.count}'),
        ElevatedButton(
          onPressed: counter.increment,
          child: Text('+'),
        ),
      ],
    );
  }
}

// Sử dụng trong app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterProvider(
        child: Scaffold(
          body: CounterDisplay(),
        ),
      ),
    );
  }
}
```

### 3.4. Tại sao ít dùng trực tiếp?

| Vấn đề | Provider giải quyết |
|--------|---------------------|
| Boilerplate nhiều | Tự động generate code |
| Phải tự quản lý state | ChangeNotifier built-in |
| Cú pháp dài dòng | `context.watch/read` ngắn gọn |

> **Kết luận**: Hiểu InheritedWidget để biết Provider hoạt động thế nào, nhưng thực tế dùng Provider cho tiện.

---

## 4. ValueNotifier & ValueListenableBuilder

### 4.1. Giới thiệu

> **ValueNotifier** là class đơn giản để lưu 1 giá trị và notify khi thay đổi.
> Nhẹ hơn ChangeNotifier, phù hợp cho state đơn giản.

### 4.2. Cách sử dụng

```dart
class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // 1️⃣ Tạo ValueNotifier
  final ValueNotifier<int> _counter = ValueNotifier(0);
  
  @override
  void dispose() {
    _counter.dispose(); // Quan trọng: dispose khi widget bị hủy
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 2️⃣ Dùng ValueListenableBuilder để lắng nghe thay đổi
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, child) {
            // Chỉ phần này rebuild khi value thay đổi!
            return Text('Count: $value');
          },
        ),
        
        ElevatedButton(
          onPressed: () {
            // 3️⃣ Thay đổi giá trị → tự động notify
            _counter.value++;
          },
          child: Text('+'),
        ),
      ],
    );
  }
}
```

### 4.3. Ưu điểm của ValueNotifier

| Ưu điểm | Mô tả |
|---------|-------|
| **Tối ưu rebuild** | Chỉ widget trong builder rebuild, không phải toàn bộ |
| **Không cần setState** | ValueNotifier tự notify |
| **Đơn giản** | Không cần package, built-in Flutter |

### 4.4. Khi nào dùng?

| Tình huống | Dùng |
|------------|------|
| State đơn giản (1 giá trị) | ValueNotifier |
| State phức tạp (object, list) | ChangeNotifier / Provider |
| State toàn app | Provider / Riverpod |

---

## 📝 Bài tập

### Ex01: Counter với setState (Ôn tập)
File: `ex01_counter_setstate.dart`
- Tạo Counter với +, -, Reset buttons
- Sử dụng setState thuần

### Ex02: Theme Toggle với InheritedWidget
File: `ex02_theme_inherited.dart`
- Tạo ThemeInherited để chia sẻ isDarkMode
- Toggle button ở một nơi, theme apply toàn app

### Ex03: Todo List với Lifting State
File: `ex03_todo_lifting.dart`
- TodoInput widget để thêm task
- TodoList widget để hiển thị tasks
- State được lift lên widget cha

---

## 🔑 Tóm tắt

1. **setState**: Đơn giản nhưng chỉ local
2. **Lifting State Up**: Đưa state lên widget cha chung
3. **InheritedWidget**: Built-in, là nền tảng của Provider
4. **ValueNotifier**: Nhẹ, tối ưu rebuild cho state đơn giản
5. Thực tế: Dùng **Provider** thay vì InheritedWidget thuần

---

## ➡️ Tiếp theo

[Bài 3: Provider Basics](lesson_03_provider_basics.md)
