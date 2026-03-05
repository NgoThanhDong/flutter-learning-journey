# Bài 2: Widget Fundamentals - StatelessWidget vs StatefulWidget

## 🎯 Mục tiêu
- Hiểu sự khác nhau giữa StatelessWidget và StatefulWidget
- Biết khi nào dùng loại nào
- Thành thạo setState() để cập nhật UI

---

## 1. Widget Là Gì?

### 1.1 Định nghĩa

**Widget** = Thành phần UI trong Flutter

Mọi thứ bạn thấy trên màn hình đều là Widget:
- `Text` → hiển thị chữ
- `Button` → nút bấm
- `Image` → hình ảnh
- `Container` → hộp chứa
- `Row`, `Column` → layout
- Thậm chí `Padding`, `Center` cũng là Widget!

### 1.2 Hai loại Widget chính

```
┌─────────────────────────────────────────────────────────┐
│                        WIDGET                           │
├────────────────────────┬────────────────────────────────┤
│    StatelessWidget     │      StatefulWidget            │
├────────────────────────┼────────────────────────────────┤
│ Không thay đổi         │ Có thể thay đổi                │
│ Không có state         │ Có state riêng                 │
│ build() gọi 1 lần      │ build() gọi nhiều lần          │
│ Ví dụ: Text, Icon      │ Ví dụ: TextField, Checkbox     │
└────────────────────────┴────────────────────────────────┘
```

---

## 2. StatelessWidget - Widget Tĩnh

### 2.1 Đặc điểm
- **Không có trạng thái (state)** thay đổi
- Sau khi tạo, không thể tự thay đổi UI
- Phù hợp cho UI tĩnh

### 2.2 Cấu trúc

```dart
class MyWidget extends StatelessWidget {
  // Constructor
  const MyWidget({super.key});
  
  // Phương thức build() - trả về Widget
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello'),
    );
  }
}
```

### 2.3 Ví dụ: Card thông tin sản phẩm

```dart
class ProductCard extends StatelessWidget {
  // Properties (final - không thay đổi)
  final String name;
  final double price;
  final String imageUrl;
  
  // Constructor
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
  
  // build() - Phương thức để build UI
  @override
  Widget build(BuildContext context) {
    return Card( // Card - Widget để hiển thị thông tin sản phẩm
      child: Column( // Column - Widget để hiển thị các widget theo chiều dọc
        children: [
          Image.network(imageUrl), // Image.network - Widget để hiển thị hình ảnh
          Text(name), // Text - Widget để hiển thị chữ
          Text('\$${price.toStringAsFixed(2)}'), // Text - Widget để hiển thị chữ
        ],
      ),
    );
  }
}

// Sử dụng
ProductCard(
  name: 'iPhone 15',
  price: 999.99,
  imageUrl: 'https://...',
)
```

### 2.4 Khi nào dùng StatelessWidget?

✅ Dùng khi:
- UI không thay đổi sau khi render
- Chỉ hiển thị dữ liệu, không tương tác
- Card, Label, Icon, Avatar...

---

## 3. StatefulWidget - Widget Có Trạng Thái

### 3.1 Đặc điểm
- **Có trạng thái (state)** có thể thay đổi
- Có thể tự cập nhật UI khi state thay đổi
- Phù hợp cho UI động, có tương tác

```dart
// Class 1: Widget (immutable)
// Widget - Lớp cha của StatefulWidget
class CounterWidget extends StatefulWidget {
  // Constructor
  const CounterWidget({super.key});
  
  // createState() - Phương thức để tạo state
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

// Class 2: State (mutable)
class _CounterWidgetState extends State<CounterWidget> {
  // State variables
  int _count = 0;
  
  // Methods
  void _increment() {
    setState(() {
      _count++;
    });
  }
  
  // build() - Phương thức để build UI
  @override
  Widget build(BuildContext context) {
    return Column( // Column - Widget để hiển thị các widget theo chiều dọc
      children: [
        Text('Count: $_count'), // Text - Widget để hiển thị chữ
        ElevatedButton( // Nút bấm
          onPressed: _increment, // Khi bấm nút thì gọi hàm _increment
          child: Text('Increment'), // Nội dung nút bấm
        ),
      ],
    );
  }
}
```

### 3.3 Giải thích setState()

```dart
// ❌ SAI - UI không cập nhật!
void _increment() {
  _count++;  // Chỉ thay đổi biến, không rebuild
}

// ✅ ĐÚNG - UI cập nhật!
void _increment() {
  setState(() {
    _count++;  // Thay đổi biến VÀ trigger rebuild
  });
}
```

**setState()** làm 2 việc:
1. Chạy code bên trong `() { }`
2. Gọi lại `build()` để vẽ lại UI

```dart
// ToggleButton - Widget để hiển thị nút bấm
class ToggleButton extends StatefulWidget {
  // Constructor
  const ToggleButton({super.key});
  
  // createState() - Phương thức để tạo state
  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

// _ToggleButtonState - State của ToggleButton
class _ToggleButtonState extends State<ToggleButton> {
  // State variables
  bool _isOn = false;
  
  // Methods
  void _toggle() {
    setState(() {
      _isOn = !_isOn;
    });
  }
  
  // build() - Phương thức để build UI
  @override
  Widget build(BuildContext context) {
    // GestureDetector - Widget để xử lý sự kiện chạm
    return GestureDetector(
      onTap: _toggle, // Khi chạm vào thì gọi hàm _toggle
      child: Container( // Container - Widget để hiển thị hình ảnh
        width: 100,
        height: 50,
        decoration: BoxDecoration( // BoxDecoration - Widget để hiển thị hình ảnh
          color: _isOn ? Colors.green : Colors.grey, // Màu sắc của container
          borderRadius: BorderRadius.circular(25), // Bo góc của container
        ),
        child: Center( // Center - Widget để hiển thị widget ở giữa
          child: Text( // Text - Widget để hiển thị chữ
            _isOn ? 'ON' : 'OFF', // Hiển thị chữ ON hoặc OFF
            style: TextStyle(color: Colors.white), // Màu chữ
          ),
        ),
      ),
    );
  }
}
```

### 3.5 Khi nào dùng StatefulWidget?

✅ Dùng khi:
- UI cần thay đổi khi user tương tác
- Có animation
- Có form input
- Counter, Toggle, TextField, Checkbox...

---

## 4. Lifecycle của StatefulWidget

```dart
// MyWidget - Widget có trạng thái
class MyWidget extends StatefulWidget {
  // createState() - Phương thức để tạo state
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

// _MyWidgetState - State của MyWidget
class _MyWidgetState extends State<MyWidget> {

  @override
  void initState() {
    super.initState();
    // Gọi 1 lần khi widget được tạo
    // Dùng để: khởi tạo data, subscribe stream
    print('1. initState');
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Gọi sau initState và khi dependencies thay đổi
    print('2. didChangeDependencies');
  }
  
  @override
  Widget build(BuildContext context) {
    // Gọi mỗi khi cần vẽ UI
    print('3. build');
    return Container();
  }
  
  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Gọi khi parent rebuild với config mới
    print('4. didUpdateWidget');
  }
  
  @override
  void dispose() {
    // Gọi khi widget bị remove khỏi tree
    // Dùng để: hủy subscription, close controller
    print('5. dispose');
    super.dispose();
  }
}
```

### Lifecycle Flow

```
createState() → initState() → didChangeDependencies() → build()
                                                           ↓
                         setState() ───────────────── → build()
                                                           ↓
parent rebuild ──── → didUpdateWidget() ───────────── → build()
                                                           ↓
                        remove from tree ──────────── → dispose()
```

---

## 5. const Constructor - Constructor Hằng Số

### 5.1 Tại sao dùng const?

```dart
// ❌ Không có const - tạo mới mỗi lần build
Text('Hello')

// ✅ Có const - tái sử dụng instance
const Text('Hello')
```

**Lợi ích**:
- Cải thiện performance - Tái sử dụng widget
- Widget không rebuild nếu không cần
- Dart cho phép compile-time (thời gian biên dịch) constants (hằng số)

### 5.2 Quy tắc

```dart
class MyWidget extends StatelessWidget {
  final String title;
  
  // Thêm const vào constructor
  const MyWidget({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

// Sử dụng
const MyWidget(title: 'Hello')  // Nếu title là constant
MyWidget(title: variableTitle)   // Nếu title là biến
```

---

## 6. So Sánh Tổng Kết

| Tiêu chí | StatelessWidget | StatefulWidget |
|----------|-----------------|----------------|
| State (Trạng thái) | Không có | Có |
| Mutable (Có thể thay đổi) | Không | Có (trong State class) |
| Rebuild (Vẽ lại) | Chỉ khi parent rebuild | Khi setState() |
| Cấu trúc | 1 class | 2 class |
| Use case (Trường hợp sử dụng) | UI tĩnh | UI động |
| Performance (Hiệu năng) | Tốt hơn | Cần quản lý |

---

## 7. Bài Tập

### Exercise 02: Counter App
Tạo app đếm số:
- Hiển thị số đếm ở giữa màn hình
- Nút (+) để tăng
- Nút (-) để giảm
- Số không được âm

### Exercise 03: Toggle Theme
Tạo nút chuyển Dark/Light mode:
- Hiển thị icon sun/moon
- Click để toggle
- Background color thay đổi theo mode

### Exercise 04: Like Button
Tạo nút Like giống Facebook:
- Icon heart
- Số lượng like
- Click để toggle like (thay đổi màu và số)

---

## 📝 Checklist Bài 2

- [ ] Hiểu StatelessWidget là gì
- [ ] Hiểu StatefulWidget là gì
- [ ] Biết khi nào dùng loại nào
- [ ] Thành thạo setState()
- [ ] Hiểu Lifecycle của StatefulWidget
- [ ] Hoàn thành 3 exercises
