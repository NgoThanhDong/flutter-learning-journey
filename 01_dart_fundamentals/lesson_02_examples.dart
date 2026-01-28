/// ===========================================
/// DART FUNDAMENTALS - BÀI 2: OOP
/// ===========================================
///
/// Chạy file:
/// ```
/// dart run lesson_02_examples.dart
/// ```

void main() {
  print('=== 1. CLASS CƠ BẢN ===\n');
  demonstrateBasicClass();

  print('\n=== 2. CONSTRUCTORS ===\n');
  demonstrateConstructors();

  print('\n=== 3. INHERITANCE ===\n');
  demonstrateInheritance();

  print('\n=== 4. ABSTRACT CLASS ===\n');
  demonstrateAbstractClass();

  print('\n=== 5. MIXINS ===\n');
  demonstrateMixins();

  print('\n=== 6. EXTENSIONS ===\n');
  demonstrateExtensions();
}

// ============================================
// 1. CLASS CƠ BẢN
// ============================================

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('Tôi là $name, $age tuổi');
  }
}

void demonstrateBasicClass() {
  var person = Person('Dong', 25);
  person.introduce();

  // Truy cập properties
  print('Tên: ${person.name}');
  print('Tuổi: ${person.age}');
}

// ============================================
// 2. CONSTRUCTORS
// ============================================

class User {
  String name;
  int age;
  String email;

  // Default Constructor
  User(this.name, this.age, this.email);

  // Named Constructor - Guest
  User.guest() : name = 'Guest', age = 0, email = 'guest@example.com';

  // Named Constructor với parameter
  User.withName(this.name)
    : age = 18,
      email = '$name@example.com'.toLowerCase();

  // Factory Constructor
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'] as String,
      json['age'] as int,
      json['email'] as String,
    );
  }

  void printInfo() {
    print('User: $name, $age, $email');
  }
}

void demonstrateConstructors() {
  print('--- Default Constructor ---');
  var user1 = User('Dong', 25, 'dong@email.com');
  user1.printInfo();

  print('\n--- Named Constructor: guest() ---');
  var guest = User.guest();
  guest.printInfo();

  print('\n--- Named Constructor: withName() ---');
  var user2 = User.withName('An');
  user2.printInfo();

  print('\n--- Factory Constructor: fromJson() ---');
  var user3 = User.fromJson({
    'name': 'Minh',
    'age': 30,
    'email': 'minh@test.com',
  });
  user3.printInfo();
}

// ============================================
// 3. INHERITANCE
// ============================================

class Animal {
  String name;

  Animal(this.name);

  void eat() {
    print('$name đang ăn');
  }

  void sleep() {
    print('$name đang ngủ');
  }
}

class Dog extends Animal {
  String breed;

  Dog(String name, this.breed) : super(name);

  @override
  void eat() {
    // Gọi method của parent
    super.eat();
    print('$name ăn xong rồi đi chơi!');
  }

  void bark() {
    print('$name: Gâu gâu!');
  }
}

class Cat extends Animal {
  Cat(String name) : super(name);

  void meow() {
    print('$name: Meo meo!');
  }
}

void demonstrateInheritance() {
  var dog = Dog('Lucky', 'Corgi');

  print('--- Dog methods ---');
  dog.eat(); // Override từ Animal
  dog.sleep(); // Kế thừa từ Animal
  dog.bark(); // Riêng của Dog

  print('\n--- Cat methods ---');
  var cat = Cat('Mimi');
  cat.eat(); // Kế thừa từ Animal
  cat.meow(); // Riêng của Cat

  // Polymorphism - Đa hình
  print('\n--- Polymorphism ---');
  List<Animal> animals = [dog, cat];
  for (var animal in animals) {
    animal.eat(); // Gọi đúng method của từng subclass
  }
}

// ============================================
// 4. ABSTRACT CLASS
// ============================================

abstract class Shape {
  // Abstract method - PHẢI implement
  double getArea();
  double getPerimeter();

  // Concrete method - dùng được luôn
  void printInfo() {
    print('Diện tích: ${getArea().toStringAsFixed(2)}');
    print('Chu vi: ${getPerimeter().toStringAsFixed(2)}');
  }
}

class Rectangle extends Shape {
  double width, height;

  Rectangle(this.width, this.height);

  @override
  double getArea() => width * height;

  @override
  double getPerimeter() => 2 * (width + height);
}

class Circle extends Shape {
  double radius;
  static const double pi = 3.14159;

  Circle(this.radius);

  @override
  double getArea() => pi * radius * radius;

  @override
  double getPerimeter() => 2 * pi * radius;
}

void demonstrateAbstractClass() {
  // var shape = Shape();  // ❌ LỖI! Không thể tạo instance của abstract class

  var rect = Rectangle(10, 5);
  var circle = Circle(7);

  print('--- Rectangle 10x5 ---');
  rect.printInfo();

  print('\n--- Circle r=7 ---');
  circle.printInfo();

  // Polymorphism với Abstract
  print('\n--- Danh sách hình ---');
  List<Shape> shapes = [rect, circle];
  for (var shape in shapes) {
    print('Area: ${shape.getArea().toStringAsFixed(2)}');
  }
}

// ============================================
// 5. MIXINS
// ============================================

mixin CanFly {
  void fly() {
    print('Đang bay trên bầu trời...');
  }
}

mixin CanSwim {
  void swim() {
    print('Đang bơi dưới nước...');
  }
}

mixin CanRun {
  int speed = 10;

  void run() {
    print('Đang chạy với tốc độ $speed km/h');
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

class Superhero with CanFly, CanSwim, CanRun {
  String name;
  Superhero(this.name);
}

void demonstrateMixins() {
  var bird = Bird('Chim sẻ');
  print('--- Bird ---');
  bird.fly();

  var duck = Duck('Vịt Donald');
  print('\n--- Duck (Bay + Bơi) ---');
  duck.fly();
  duck.swim();

  var hero = Superhero('Superman');
  print('\n--- Superhero (Bay + Bơi + Chạy) ---');
  hero.fly();
  hero.swim();
  hero.speed = 100;
  hero.run();
}

// ============================================
// 6. EXTENSIONS
// ============================================

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidEmail {
    return contains('@') && contains('.');
  }

  String repeat(int times) {
    return List.filled(times, this).join(' ');
  }
}

extension IntExtension on int {
  String toVietnameseCurrency() {
    return '${toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} VNĐ';
  }

  bool get isPositive => this > 0;
}

void demonstrateExtensions() {
  print('--- String Extensions ---');
  print('"hello".capitalize() = ${"hello".capitalize()}');
  print('"test@email.com".isValidEmail = ${"test@email.com".isValidEmail}');
  print('"invalid".isValidEmail = ${"invalid".isValidEmail}');
  print('"Hi".repeat(3) = ${"Hi".repeat(3)}');

  print('\n--- Int Extensions ---');
  print('1000000.toVietnameseCurrency() = ${1000000.toVietnameseCurrency()}');
  print('5.isPositive = ${5.isPositive}');
  print('(-3).isPositive = ${(-3).isPositive}');
}

// ============================================
// 💡 GHI NHỚ QUAN TRỌNG
// ============================================
//
// 1. Class = blueprint để tạo objects
// 2. Named Constructors = nhiều cách tạo object
// 3. Inheritance (extends) = tái sử dụng code
// 4. Abstract Class = bắt buộc subclass implement
// 5. Mixins (with) = chia sẻ code, thay multiple inheritance
// 6. Extensions = thêm method vào class có sẵn
