# Lesson 1: SOLID Principles 🧱

## Mục Tiêu

- Hiểu 5 nguyên tắc SOLID
- Áp dụng vào Flutter code
- Tránh các anti-patterns phổ biến

---

## SOLID là gì?

SOLID là 5 nguyên tắc thiết kế OOP giúp code:
- **Dễ bảo trì** (maintainable)
- **Dễ mở rộng** (extensible)
- **Dễ test** (testable)

| Chữ | Nguyên tắc | Ý nghĩa |
|-----|------------|---------|
| **S** | Single Responsibility | Mỗi class chỉ làm 1 việc |
| **O** | Open/Closed | Mở rộng được, không sửa đổi |
| **L** | Liskov Substitution | Subtype thay thế được base type |
| **I** | Interface Segregation | Interface nhỏ, chuyên biệt |
| **D** | Dependency Inversion | Phụ thuộc vào abstraction |

---

## 1. Single Responsibility Principle (SRP)

> **"Một class chỉ nên có một lý do để thay đổi"**

### ❌ Vi phạm SRP:
```dart
/// Class làm quá nhiều việc:
/// - Quản lý user data
/// - Validate email
/// - Gọi API
/// - Hiển thị UI
class UserManager {
  String name;
  String email;
  
  bool validateEmail() { ... }
  Future<void> saveToApi() { ... }
  Widget buildUserCard() { ... }
}
```

### ✅ Tuân thủ SRP:
```dart
/// [User] - Chỉ chứa data
class User {
  final String name;
  final String email;
}

/// [EmailValidator] - Chỉ validate
class EmailValidator {
  bool isValid(String email) { ... }
}

/// [UserRepository] - Chỉ xử lý API
class UserRepository {
  Future<void> save(User user) { ... }
}

/// [UserCard] - Chỉ hiển thị UI
class UserCard extends StatelessWidget { ... }
```

### Lợi ích:
- Dễ test từng phần
- Thay đổi 1 chỗ không ảnh hưởng chỗ khác
- Code dễ đọc, dễ hiểu

---

## 2. Open/Closed Principle (OCP)

> **"Mở để mở rộng, đóng để sửa đổi"**

Thêm tính năng mới bằng cách thêm code, không sửa code cũ.

### ❌ Vi phạm OCP:
```dart
class PaymentProcessor {
  void process(String type, double amount) {
    if (type == 'credit') {
      // Xử lý credit card
    } else if (type == 'paypal') {
      // Xử lý PayPal
    } else if (type == 'momo') {
      // Phải sửa class này mỗi khi thêm payment mới!
    }
  }
}
```

### ✅ Tuân thủ OCP:
```dart
/// [PaymentMethod] - Abstract interface
abstract class PaymentMethod {
  Future<bool> pay(double amount);
}

/// Thêm payment mới = thêm class mới
class CreditCardPayment implements PaymentMethod {
  @override
  Future<bool> pay(double amount) async { ... }
}

class PayPalPayment implements PaymentMethod {
  @override  
  Future<bool> pay(double amount) async { ... }
}

class MomoPayment implements PaymentMethod {
  @override
  Future<bool> pay(double amount) async { ... }
}

/// [PaymentProcessor] - Không cần sửa khi thêm payment mới
class PaymentProcessor {
  Future<bool> process(PaymentMethod method, double amount) {
    return method.pay(amount);
  }
}
```

---

## 3. Liskov Substitution Principle (LSP)

> **"Subtype phải thay thế được base type mà không làm hỏng chương trình"**

### ❌ Vi phạm LSP:
```dart
class Rectangle {
  double width;
  double height;
  
  double area() => width * height;
}

/// Square kế thừa Rectangle nhưng hành vi khác!
class Square extends Rectangle {
  @override
  set width(double value) {
    super.width = value;
    super.height = value; // Bắt buộc width = height
  }
}

// Vấn đề:
void resize(Rectangle rect) {
  rect.width = 10;
  rect.height = 5;
  print(rect.area()); // Rectangle: 50, Square: 25 (sai!)
}
```

### ✅ Tuân thủ LSP:
```dart
/// Abstract shape
abstract class Shape {
  double area();
}

class Rectangle implements Shape {
  final double width;
  final double height;
  
  Rectangle(this.width, this.height);
  
  @override
  double area() => width * height;
}

class Square implements Shape {
  final double side;
  
  Square(this.side);
  
  @override
  double area() => side * side;
}
```

---

## 4. Interface Segregation Principle (ISP)

> **"Client không nên bị ép implement interface không cần"**

### ❌ Vi phạm ISP:
```dart
/// Interface quá lớn
abstract class Animal {
  void eat();
  void fly();
  void swim();
}

/// Chó không biết bay!
class Dog implements Animal {
  @override
  void eat() { print('Eating'); }
  
  @override
  void fly() { throw UnimplementedError(); } // Vô nghĩa!
  
  @override
  void swim() { print('Swimming'); }
}
```

### ✅ Tuân thủ ISP:
```dart
/// Interfaces nhỏ, chuyên biệt
abstract class Eater {
  void eat();
}

abstract class Flyer {
  void fly();
}

abstract class Swimmer {
  void swim();
}

/// Chỉ implement cái cần
class Dog implements Eater, Swimmer {
  @override
  void eat() { print('Eating'); }
  
  @override
  void swim() { print('Swimming'); }
}

class Bird implements Eater, Flyer {
  @override
  void eat() { print('Eating'); }
  
  @override
  void fly() { print('Flying'); }
}
```

---

## 5. Dependency Inversion Principle (DIP)

> **"Depend on abstractions, not concretions"**

High-level modules không nên phụ thuộc vào low-level modules.

### ❌ Vi phạm DIP:
```dart
/// High-level phụ thuộc trực tiếp vào low-level
class UserRepository {
  final MySqlDatabase database; // Cụ thể!
  
  UserRepository() : database = MySqlDatabase();
  
  Future<User> getUser(int id) {
    return database.query('SELECT * FROM users WHERE id = $id');
  }
}
```

### ✅ Tuân thủ DIP:
```dart
/// [Database] - Abstraction
abstract class Database {
  Future<Map<String, dynamic>> query(String sql);
}

/// Low-level implementations
class MySqlDatabase implements Database { ... }
class PostgresDatabase implements Database { ... }
class MockDatabase implements Database { ... } // Dễ test!

/// High-level phụ thuộc abstraction
class UserRepository {
  final Database database; // Abstract!
  
  UserRepository(this.database); // Inject từ ngoài
  
  Future<User> getUser(int id) {
    return database.query('SELECT * FROM users WHERE id = $id');
  }
}
```

---

## Áp Dụng SOLID trong Flutter

| Nguyên tắc | Áp dụng Flutter | Ý nghĩa |
|------------|-----------------|---------|
| SRP (Single Responsibility Principle) | Tách Widget, Service, Repository | Một class chỉ nên có một lý do để thay đổi |
| OCP (Open/Closed Principle) | Dùng abstract class cho variations (biến thể) | Mở để mở rộng, đóng để sửa đổi |
| LSP (Liskov Substitution Principle) | Subclass phải tương thích | Subtype phải thay thế được base type mà không làm hỏng chương trình |
| ISP (Interface Segregation Principle) | Mixin thay vì interface lớn | Client không nên bị ép implement interface không cần |
| DIP (Dependency Inversion Principle) | Dependency Injection (get_it) | High-level modules không nên phụ thuộc vào low-level modules |

---

## Bài Tập Liên Quan

- `ex01_single_responsibility.dart` - Tách class theo SRP
- `ex02_open_closed.dart` - Mở rộng với Strategy pattern
- `ex03_liskov_substitution.dart` - Kế thừa đúng cách
- `ex04_interface_segregation.dart` - Chia nhỏ interfaces
- `ex05_dependency_inversion.dart` - Inject dependencies

---

## Bài Tiếp Theo

➡️ [Lesson 2: Dependency Injection](lesson_02_dependency_injection.md)
