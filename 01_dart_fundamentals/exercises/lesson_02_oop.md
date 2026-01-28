# Phase 1: Dart Fundamentals - Bài 2: OOP Trong Dart

## Mục tiêu bài học
- Hiểu Class, Constructor, và Properties
- Nắm vững Inheritance và Abstract Classes
- Hiểu Interface và cách sử dụng
- Thành thạo Mixins và Extensions

---

## 1. Class Cơ Bản

### 1.1 Định nghĩa Class

```dart
class Person {
  // Properties (thuộc tính)
  String name;
  int age;
  
  // Constructor
  Person(this.name, this.age);
  
  // Method (phương thức)
  void introduce() {
    print('Tôi là $name, $age tuổi');
  }
}

// Sử dụng
var person = Person('Dong', 25);
person.introduce();
```

### 💡 Suy luận: Tại sao cần Class?

Thay vì:
```dart
var name1 = 'Dong';
var age1 = 25;
var name2 = 'An';
var age2 = 30;
```

Dùng Class để **gom nhóm dữ liệu liên quan**:
```dart
var person1 = Person('Dong', 25);
var person2 = Person('An', 30);
```

---

## 2. Constructors (Hàm khởi tạo)

### 2.1 Các loại Constructor

```dart
class User {
  String name;
  int age;
  String email;
  
  // [1] Default Constructor
  User(this.name, this.age, this.email);
  
  // [2] Named Constructor - nhiều cách tạo object
  User.guest()
      : name = 'Guest',
        age = 0,
        email = 'guest@example.com';
  
  // [3] Named Constructor với parameter
  User.withName(this.name)
      : age = 18,
        email = '$name@example.com';
  
  // [4] Factory Constructor - logic phức tạp
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'] as String,
      json['age'] as int,
      json['email'] as String,
    );
  }
}

// Sử dụng
var user1 = User('Dong', 25, 'dong@email.com');
var guest = User.guest();
var user2 = User.withName('An');
```

### 💡 Thủ thuật: Khi nào dùng Factory?

- Khi cần **cache** objects (singleton pattern)
- Khi cần **return subclass** dựa trên input
- Khi cần **logic phức tạp** trước khi tạo object

---

## 3. Inheritance (Kế thừa)

### 3.1 Extends - Kế thừa Class

```dart
class Animal {
  String name;
  
  Animal(this.name);
  
  void eat() {
    print('$name đang ăn');
  }
}

class Dog extends Animal {
  String breed;
  
  // Gọi constructor của parent với super
  Dog(String name, this.breed) : super(name);
  
  // Override method
  @override
  void eat() {
    print('$name (giống $breed) đang ăn');
  }
  
  // Method riêng của Dog
  void bark() {
    print('$name: Gâu gâu!');
  }
}
```

### 💡 Suy luận: Tại sao cần Inheritance?

1. **Tái sử dụng code**: Dog tự động có method `eat()` từ Animal
2. **Đa hình (Polymorphism)**: Có thể override để thay đổi behavior
3. **Tổ chức code**: Nhóm các class liên quan với nhau

---

## 4. Abstract Class

### 4.1 Định nghĩa và sử dụng

```dart
// Abstract class - KHÔNG thể tạo instance trực tiếp
abstract class Shape {
  // Abstract method - PHẢI được implement bởi subclass
  double getArea();
  
  // Concrete method - có thể dùng trực tiếp
  void printInfo() {
    print('Diện tích: ${getArea()}');
  }
}

class Rectangle extends Shape {
  double width, height;
  
  Rectangle(this.width, this.height);
  
  @override
  double getArea() => width * height;
}

class Circle extends Shape {
  double radius;
  
  Circle(this.radius);
  
  @override
  double getArea() => 3.14159 * radius * radius;
}
```

### 💡 Suy luận: Tại sao cần Abstract Class?

| Tình huống | Giải pháp |
|------------|-----------|
| Có một số method chung | Dùng normal class |
| **Bắt buộc** subclass phải implement method | Dùng **abstract class** |
| Chỉ cần "giao ước" không cần implementation | Dùng interface |

---

## 5. Interface

### 5.1 Dart không có từ khóa "interface"

Trong Dart, **mọi class đều có thể dùng như interface!**

```dart
// Abstract class dùng làm interface
abstract class Printable {
  void printInfo();  // Chỉ khai báo, không có code
}

abstract class Exportable {
  String exportToJson();
}

// Implement interface bằng từ khóa "implements"
class Document implements Printable {
  String title;
  
  Document(this.title);
  
  // BẮT BUỘC phải implement tất cả methods
  @override
  void printInfo() {
    print('Document: $title');
  }
}
```

### 5.2 So sánh extends vs implements

```dart
// extends: Kế thừa code từ parent
class Dog extends Animal {
  // Có thể dùng methods của Animal luôn
}

// implements: Phải viết lại TẤT CẢ methods
class Cat implements Animal {
  // Phải implement mọi thứ từ đầu
}
```

| Từ khóa | Ý nghĩa | Số lượng |
|---------|---------|----------|
| `extends` | Kế thừa code | Chỉ 1 class |
| `implements` | Thực thi interface | Nhiều interfaces |
| `with` | Trộn mixin | Nhiều mixins |

### 5.3 Multiple Interfaces

```dart
abstract class Readable {
  String read();
}

abstract class Writable {
  void write(String data);
}

// Implement nhiều interface cùng lúc
class File implements Readable, Writable {
  String _content = '';
  
  @override
  String read() => _content;
  
  @override
  void write(String data) => _content = data;
}
```

### 5.4 Thực tế: Repository Pattern

Đây là pattern bạn sẽ dùng rất nhiều trong Flutter:

```dart
// Interface định nghĩa các operations
abstract class UserRepository {
  Future<User> getById(int id);
  Future<void> save(User user);
}

// Implementation 1: Từ API
class ApiUserRepository implements UserRepository {
  @override
  Future<User> getById(int id) async {
    // Gọi API...
  }
  
  @override
  Future<void> save(User user) async {
    // POST to API...
  }
}

// Implementation 2: Từ local database
class LocalUserRepository implements UserRepository {
  @override
  Future<User> getById(int id) async {
    // Đọc từ SQLite...
  }
  
  @override
  Future<void> save(User user) async {
    // Lưu vào SQLite...
  }
}
```

**Lợi ích**: Dễ dàng thay đổi giữa API và Local mà không sửa code service!

---

## 6. Mixins - Chia sẻ code giữa các Class

### 6.1 Vấn đề: Dart không có Multiple Inheritance

```dart
// ❌ Dart không cho phép:
// class A extends B, C { }  // LỖI!
```

### 6.2 Giải pháp: Mixins

```dart
mixin CanFly {
  void fly() => print('Đang bay...');
}

mixin CanSwim {
  void swim() => print('Đang bơi...');
}

class Duck with CanFly, CanSwim {
  String name;
  Duck(this.name);
}

// Sử dụng
var duck = Duck('Donald');
duck.fly();   // Đang bay...
duck.swim();  // Đang bơi...
```

---

## 7. Extension Methods

### 7.1 Thêm method vào class có sẵn

```dart
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  bool get isValidEmail {
    return contains('@') && contains('.');
  }
}

// Sử dụng
print('hello'.capitalize());  // Hello
print('test@email.com'.isValidEmail);  // true
```

---

## 8. Bài Tập Thực Hành

### Bài 1: Tạo Class Product
File: `exercises/exercise_04_product.dart`
- Properties: `name`, `price`, `quantity`
- Method: `getTotalValue()` trả về `price * quantity`
- Named constructor: `Product.free(name)` với price = 0

### Bài 2: Inheritance - Hệ thống nhân viên
File: `exercises/exercise_05_employee.dart`
- Abstract class `Employee` với abstract method `calculateSalary()`
- `FullTimeEmployee` với lương cố định
- `PartTimeEmployee` với lương theo giờ

### Bài 3: Extension
File: `exercises/exercise_06_extension.dart`
- Tạo extension cho `DateTime` với method `toVietnameseFormat()` trả về "dd/MM/yyyy"

---

## 📝 Checklist Bài 2

- [ ] Hiểu các loại Constructor (default, named, factory)
- [ ] Hiểu Inheritance và khi nào dùng `@override`
- [ ] Hiểu Abstract Class để bắt buộc implement
- [ ] Hiểu Interface và sự khác biệt với extends
- [ ] Hiểu Mixins và cách chia sẻ code
- [ ] Biết viết Extension methods
- [ ] Hoàn thành 3 bài tập

**Tiếp theo:** Bài 3 - Async Programming (Future, Stream, async/await)
