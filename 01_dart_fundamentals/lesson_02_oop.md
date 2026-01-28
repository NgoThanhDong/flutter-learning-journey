# Phase 1: Dart Fundamentals - Bài 2: OOP Trong Dart

## Mục tiêu bài học
- Hiểu Class, Constructor, và Properties
- Nắm vững Inheritance và Abstract Classes
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
var user3 = User.fromJson({'name': 'Minh', 'age': 30, 'email': 'minh@test.com'});
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

var dog = Dog('Lucky', 'Corgi');
dog.eat();   // Lucky (giống Corgi) đang ăn
dog.bark();  // Lucky: Gâu gâu!
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

// Sử dụng
var rect = Rectangle(10, 5);
var circle = Circle(7);

rect.printInfo();    // Diện tích: 50.0
circle.printInfo();  // Diện tích: 153.93...
```

### 💡 Suy luận: Tại sao cần Abstract Class?

| Tình huống | Giải pháp |
|------------|-----------|
| Có một số method chung | Dùng normal class |
| **Bắt buộc** subclass phải implement method | Dùng **abstract class** |
| Chỉ cần "giao ước" không cần implementation | Dùng interface (abstract class không có code) |

**Trong Flutter, bạn sẽ thấy:**
- `StatelessWidget` và `StatefulWidget` là abstract classes
- Bạn phải override method `build()` - đây là bắt buộc!

---

## 5. Mixins - Chia sẻ code giữa các Class

### 5.1 Vấn đề: Dart không có Multiple Inheritance

```dart
// ❌ Dart không cho phép:
// class A extends B, C { }  // LỖI!
```

### 5.2 Giải pháp: Mixins

```dart
// Mixin - tập hợp các methods có thể "trộn" vào class
mixin CanFly {
  void fly() {
    print('Đang bay...');
  }
}

mixin CanSwim {
  void swim() {
    print('Đang bơi...');
  }
}

class Bird with CanFly {
  String name;
  Bird(this.name);
}

class Duck with CanFly, CanSwim {
  String name;
  Duck(this.name);
}

class Fish with CanSwim {
  String name;
  Fish(this.name);
}

// Sử dụng
var duck = Duck('Donald');
duck.fly();   // Đang bay...
duck.swim();  // Đang bơi...
```

### 💡 Thủ thuật: Mixin trong Flutter

Flutter dùng Mixins rất nhiều! Ví dụ:
```dart
class MyWidget extends StatefulWidget with TickerProviderStateMixin {
  // TickerProviderStateMixin cho animation
}
```

---

## 6. Extension Methods

### 6.1 Thêm method vào class có sẵn

```dart
// Thêm method cho String
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  bool get isValidEmail {
    return contains('@') && contains('.');
  }
}

// Thêm method cho int
extension IntExtension on int {
  bool get isEven => this % 2 == 0;
  
  String toVietnameseCurrency() {
    return '${toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )} VNĐ';
  }
}

// Sử dụng
print('hello'.capitalize());  // Hello
print('test@email.com'.isValidEmail);  // true
print(1000000.toVietnameseCurrency());  // 1.000.000 VNĐ
```

### 💡 Thủ thuật: Tổ chức Extensions

```dart
// Tạo file extensions.dart và import khi cần
// lib/core/extensions/string_extensions.dart
// lib/core/extensions/datetime_extensions.dart
```

---

## 7. Bài Tập Thực Hành

### Bài 1: Tạo Class Product
- Properties: `name`, `price`, `quantity`
- Method: `getTotalValue()` trả về `price * quantity`
- Named constructor: `Product.free(name)` với price = 0

### Bài 2: Inheritance - Hệ thống nhân viên
- Abstract class `Employee` với abstract method `calculateSalary()`
- `FullTimeEmployee` với lương cố định
- `PartTimeEmployee` với lương theo giờ

### Bài 3: Extension
- Tạo extension cho `DateTime` với method `toVietnameseFormat()` trả về "dd/MM/yyyy"

---

## 📝 Checklist Bài 2

- [ ] Hiểu các loại Constructor (default, named, factory)
- [ ] Hiểu Inheritance và khi nào dùng `@override`
- [ ] Biết dùng Abstract Class để bắt buộc implement
- [ ] Hiểu Mixins và cách chia sẻ code
- [ ] Biết viết Extension methods

**Tiếp theo:** Bài 3 - Async Programming (Future, Stream, async/await)
