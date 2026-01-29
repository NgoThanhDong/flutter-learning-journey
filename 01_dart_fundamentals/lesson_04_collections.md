# Phase 1: Dart Fundamentals - Bài 4: Collections & Generics

## Mục tiêu bài học
- Thành thạo List, Map, Set
- Hiểu Generics và tại sao cần
- Sử dụng Higher-Order Functions (map, where, fold)

---

## 1. Tại Sao Collections Quan Trọng?

Trong Flutter, bạn sẽ gặp Collections **MỌI NƠI**:

```dart
// ListView cần List<Widget>
ListView(
  children: [Text('A'), Text('B'), Text('C')],
)

// Parse JSON trả về Map<String, dynamic>
Map<String, dynamic> user = {
  'name': 'Dong',
  'age': 25,
};

// Tập hợp tags không trùng lặp
Set<String> tags = {'flutter', 'dart', 'mobile'};
```

---

## 2. List - Danh Sách Có Thứ Tự

### 2.1 Tạo List

```dart
// Cách 1: Literal
var numbers = [1, 2, 3, 4, 5];
List<String> names = ['An', 'Bình', 'Cường'];

// Cách 2: Constructor
var emptyList = <int>[];
var filledList = List.filled(5, 0); // [0, 0, 0, 0, 0]
var generatedList = List.generate(5, (i) => i * 2); // [0, 2, 4, 6, 8]
```

### 2.2 Truy cập và thay đổi

```dart
var fruits = ['Táo', 'Cam', 'Chuối'];

// Truy cập
print(fruits[0]);        // Táo
print(fruits.first);     // Táo
print(fruits.last);      // Chuối
print(fruits.length);    // 3

// Thay đổi
fruits[1] = 'Xoài';      // ['Táo', 'Xoài', 'Chuối']
fruits.add('Nho');       // Thêm cuối
fruits.insert(0, 'Dưa'); // Thêm vào vị trí 0
fruits.remove('Táo');    // Xóa theo giá trị
fruits.removeAt(0);      // Xóa theo index
```

### 2.3 Kiểm tra

```dart
var numbers = [1, 2, 3, 4, 5];

print(numbers.isEmpty);      // false
print(numbers.isNotEmpty);   // true
print(numbers.contains(3));  // true
print(numbers.indexOf(3));   // 2 (vị trí của số 3)
```

---

## 3. Map - Cặp Key-Value

### 3.1 Tạo Map

```dart
// Cách 1: Literal
var user = {
  'name': 'Dong',
  'age': 25,
  'isStudent': true,
};

// Cách 2: Khai báo tường minh
Map<String, int> scores = {
  'math': 90,
  'english': 85,
};
```

### 3.2 Truy cập và thay đổi

```dart
var user = {'name': 'Dong', 'age': 25};

// Truy cập
print(user['name']);         // Dong
print(user['email']);        // null (không có key)

// Thay đổi
user['age'] = 26;            // Cập nhật
user['email'] = 'a@b.com';   // Thêm mới
user.remove('email');        // Xóa

// Lấy keys và values
print(user.keys);            // (name, age)
print(user.values);          // (Dong, 26)
```

### 3.3 Map trong Flutter - JSON

```dart
// Đây là cách data từ API trả về:
Map<String, dynamic> json = {
  'id': 1,
  'name': 'Product A',
  'price': 99.99,
  'inStock': true,
  'tags': ['new', 'sale'],
};

// dynamic vì value có thể là int, String, double, bool, List...
```

---

## 4. Set - Tập Hợp Không Trùng Lặp

### 4.1 Tạo và sử dụng

```dart
var tags = {'flutter', 'dart', 'mobile'};

// Thêm phần tử
tags.add('web');
tags.add('flutter');  // Không thêm vì đã có

// Kiểm tra
print(tags.contains('dart'));  // true

// Chuyển List có trùng lặp thành Set
var numbers = [1, 2, 2, 3, 3, 3];
var uniqueNumbers = numbers.toSet();  // {1, 2, 3}
```

### 4.2 Các phép toán tập hợp

```dart
var a = {1, 2, 3};
var b = {2, 3, 4};

print(a.union(b));        // {1, 2, 3, 4} - Hợp
print(a.intersection(b)); // {2, 3} - Giao
print(a.difference(b));   // {1} - Hiệu (a - b)
```

---

## 5. Generics - Kiểu Dữ Liệu Tổng Quát

### 5.1 Tại sao cần Generics?

```dart
// Không có Generics:
var numbers = [1, 2, 3];
numbers.add('hello');  // ❌ Runtime error!

// Có Generics:
List<int> numbers = [1, 2, 3];
numbers.add('hello');  // ❌ Compile error! Bắt lỗi sớm hơn
```

### 5.2 Các Generics phổ biến trong Flutter

```dart
// List với kiểu cụ thể
List<String> names = ['An', 'Bình'];
List<Widget> widgets = [Text('A'), Icon(Icons.star)];

// Map với key-value types
Map<String, int> scores = {'math': 90};
Map<String, dynamic> json = {'name': 'Dong', 'age': 25};

// Future với kiểu trả về
Future<String> fetchName() async => 'Dong';
Future<List<User>> fetchUsers() async => [];
```

### 5.3 Tạo Generic Class

```dart
// Box có thể chứa bất kỳ kiểu nào
class Box<T> {
  T content;
  
  Box(this.content);
  
  T getContent() => content;
}

// Sử dụng
var intBox = Box<int>(42);
var stringBox = Box<String>('Hello');

print(intBox.getContent());    // 42
print(stringBox.getContent()); // Hello
```

---

## 6. Higher-Order Functions

Đây là các function nhận function làm tham số. **Rất quan trọng!**

### 6.1 map() - Biến đổi mỗi phần tử

```dart
var numbers = [1, 2, 3, 4, 5];

// Nhân đôi mỗi số
var doubled = numbers.map((n) => n * 2).toList();
// [2, 4, 6, 8, 10]

// Chuyển thành String
var strings = numbers.map((n) => 'Số $n').toList();
// ['Số 1', 'Số 2', 'Số 3', 'Số 4', 'Số 5']
```

### 6.2 where() - Lọc phần tử

```dart
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Lọc số chẵn
var evens = numbers.where((n) => n % 2 == 0).toList();
// [2, 4, 6, 8, 10]

// Lọc số lớn hơn 5
var bigNumbers = numbers.where((n) => n > 5).toList();
// [6, 7, 8, 9, 10]
```

### 6.3 fold() - Gộp thành 1 giá trị

```dart
var numbers = [1, 2, 3, 4, 5];

// Tính tổng
var sum = numbers.fold(0, (total, n) => total + n);
// 15

// Tìm max
var max = numbers.fold(numbers[0], (m, n) => n > m ? n : m);
// 5
```

### 6.4 any() và every() - Kiểm tra điều kiện

```dart
var numbers = [1, 2, 3, 4, 5];

// any: Có BẤT KỲ phần tử nào thỏa mãn?
print(numbers.any((n) => n > 4));   // true (có số 5)

// every: TẤT CẢ phần tử có thỏa mãn?
print(numbers.every((n) => n > 0)); // true (tất cả > 0)
print(numbers.every((n) => n > 3)); // false
```

### 6.5 firstWhere() - Tìm phần tử đầu tiên

```dart
var users = [
  {'id': 1, 'name': 'An'},
  {'id': 2, 'name': 'Bình'},
  {'id': 3, 'name': 'Cường'},
];

var user = users.firstWhere(
  (u) => u['id'] == 2,
  orElse: () => {'id': 0, 'name': 'Not found'},
);
// {'id': 2, 'name': 'Bình'}
```

---

## 7. Spread Operator (...)

```dart
var list1 = [1, 2, 3];
var list2 = [4, 5, 6];

// Gộp 2 list
var combined = [...list1, ...list2];
// [1, 2, 3, 4, 5, 6]

// Trong Flutter
Row(
  children: [
    Text('Start'),
    ...otherWidgets,  // Spread danh sách widgets
    Text('End'),
  ],
)
```

---

## 8. Bài Tập Thực Hành

| Bài | File | Nội dung |
|-----|------|----------|
| 1 | `exercise_11_list.dart` | Thao tác với List |
| 2 | `exercise_12_map.dart` | Thao tác với Map (JSON) |
| 3 | `exercise_13_higher_order.dart` | map, where, fold |

---

## 📝 Checklist Bài 4

- [ ] Tạo và thao tác List
- [ ] Tạo và thao tác Map
- [ ] Hiểu Set và khi nào dùng
- [ ] Hiểu Generics (`List<T>`, `Map<K,V>`)
- [ ] Sử dụng map(), where(), fold()
- [ ] Hoàn thành 3 bài tập

**Tiếp theo:** Bài 5 - Enums & Error Handling
