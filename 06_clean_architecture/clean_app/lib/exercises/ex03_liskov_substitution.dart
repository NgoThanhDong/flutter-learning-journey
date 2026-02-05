/// ===========================================
/// EXERCISE 03: LISKOV SUBSTITUTION PRINCIPLE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu LSP: Subtype phải thay thế được base type
/// - Tránh kế thừa sai cách
/// - Composition over inheritance
///
/// 📝 LSP nói gì?
/// "Subtypes must be substitutable for their base types"
/// = Ở đâu dùng được parent, ở đó phải dùng được child

library;

import 'package:flutter/material.dart';

/// ===========================================
/// ❌ VI PHẠM LSP - Kế thừa sai logic
/// ===========================================
/// Ví dụ kinh điển: Rectangle và Square

class BadRectangle {
  double width;
  double height;

  BadRectangle(this.width, this.height);

  double area() => width * height;
}

/// Square kế thừa Rectangle nhưng vi phạm LSP
/// vì Square bắt buộc width == height
class BadSquare extends BadRectangle {
  BadSquare(double side) : super(side, side);

  @override
  set width(double value) {
    super.width = value;
    super.height = value; // Phải đồng bộ -> hành vi khác parent!
  }

  @override
  set height(double value) {
    super.width = value;
    super.height = value;
  }
}

/// Vấn đề: Code dùng Rectangle không work với Square
void badExample(BadRectangle rect) {
  rect.width = 10;
  rect.height = 5;
  // Với Rectangle: area = 50
  // Với BadSquare: area = 25 (vì height set width = 5)
  // => Không thể substitute! (thay thế)
}

/// ===========================================
/// ✅ TUÂN THỦ LSP - Dùng interface chung
/// ===========================================

/// [Shape] - Abstract interface cho tất cả shapes
abstract class Shape {
  String get name; // tên của shape
  double area(); // diện tích
  double perimeter(); // chu vi
}

/// [Rectangle] - Hình chữ nhật
class Rectangle implements Shape {
  final double width;
  final double height;

  const Rectangle({required this.width, required this.height});

  @override
  String get name => 'Rectangle';

  @override
  double area() => width * height;

  @override
  double perimeter() => 2 * (width + height);
}

/// [Square] - Hình vuông (KHÔNG kế thừa Rectangle)
/// mà implement Shape interface
class Square implements Shape {
  final double side; // cạnh

  const Square(this.side);

  @override
  String get name => 'Square';

  @override
  double area() => side * side;

  @override
  double perimeter() => 4 * side;
}

/// [Circle] - Hình tròn
class Circle implements Shape {
  final double radius; // bán kính

  const Circle(this.radius);

  @override
  String get name => 'Circle';

  @override
  double area() => 3.14159 * radius * radius;

  @override
  double perimeter() => 2 * 3.14159 * radius;
}

/// ===========================================
/// [ShapeCalculator] - Hoạt động với MỌI Shape
/// Đây là LSP compliant - bất kỳ Shape nào cũng substitute được
/// ===========================================
class ShapeCalculator {
  /// [totalArea] - Tính tổng diện tích
  /// Works với `List<Shape>` bất kể shape nào
  double totalArea(List<Shape> shapes) {
    // fold là hàm có sẵn trong Dart
    // nó sẽ duyệt qua list và tính tổng
    // 0 là giá trị ban đầu
    // sum là tổng hiện tại
    // shape là phần tử hiện tại
    // shape.area() là diện tích của phần tử hiện tại
    return shapes.fold(0, (sum, shape) => sum + shape.area());
  }

  /// [largestShape] - Tìm shape lớn nhất
  Shape? largestShape(List<Shape> shapes) {
    if (shapes.isEmpty) return null;
    // reduce là hàm có sẵn trong Dart
    // nó sẽ duyệt qua list và so sánh từng phần tử
    // để tìm ra phần tử lớn nhất
    // a là phần tử hiện tại
    // b là phần tử tiếp theo
    // nếu a.area() > b.area() thì a sẽ được giữ lại
    // ngược lại b sẽ được giữ lại
    return shapes.reduce((a, b) => a.area() > b.area() ? a : b);
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex03LiskovSubstitution extends StatefulWidget {
  const Ex03LiskovSubstitution({super.key});

  @override
  State<Ex03LiskovSubstitution> createState() => _Ex03LiskovSubstitutionState();
}

class _Ex03LiskovSubstitutionState extends State<Ex03LiskovSubstitution> {
  // tạo một instance của ShapeCalculator
  final _calculator = ShapeCalculator();

  /// [Danh sách shapes] - Tất cả đều implement Shape interface
  final List<Shape> _shapes = [
    Rectangle(width: 10, height: 5),
    Square(7),
    Circle(4),
    Rectangle(width: 8, height: 3),
    Square(5),
  ];

  @override
  Widget build(BuildContext context) {
    // tính tổng diện tích
    final totalArea = _calculator.totalArea(_shapes);
    // tìm shape lớn nhất
    final largest = _calculator.largestShape(_shapes);

    return Scaffold(
      appBar: AppBar(title: const Text('Ex03: Liskov Substitution')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          // sắp xếp các widget theo chiều dọc
          // CrossAxisAlignment.stretch: kéo dài các widget theo chiều ngang
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            const Card(
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 LSP = Liskov Substitution Principle',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tất cả shapes (Rectangle, Square, Circle)\n'
                      'đều thay thế được cho Shape interface.\n'
                      'ShapeCalculator hoạt động với MỌI loại shape.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Shapes list
            const Text(
              'Các shapes:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // List.generate là hàm có sẵn trong Dart
            // nó sẽ duyệt qua list và tạo ra các widget
            ...List.generate(_shapes.length, (index) {
              // lấy shape tại index hiện tại
              final shape = _shapes[index];

              // tạo card cho shape
              return Card(
                child: ListTile(
                  // lấy icon tương ứng với shape
                  leading: _getShapeIcon(shape),
                  // tên của shape
                  title: Text(shape.name),
                  // diện tích và chu vi của shape
                  subtitle: Text(
                    'Area: ${shape.area().toStringAsFixed(2)} | '
                    'Perimeter: ${shape.perimeter().toStringAsFixed(2)}',
                  ),
                  // nếu shape là shape lớn nhất thì hiển thị chip
                  // shape == largest: so sánh shape với shape lớn nhất
                  // ? const Chip(label: Text('Largest')): nếu đúng thì hiển thị chip
                  // : null: nếu sai thì không hiển thị gì cả
                  trailing: shape == largest
                      ? const Chip(label: Text('Largest'))
                      : null,
                ),
              );
            }),

            const SizedBox(height: 16),

            // Summary
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // hiển thị tổng diện tích
                        const Text('Total Area:'),
                        Text(
                          totalArea.toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // hiển thị shape lớn nhất
                        const Text('Largest Shape:'),
                        Text(
                          largest?.name ?? 'None',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Code explanation
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '💻 ShapeCalculator.totalArea(List<Shape>)\n\n'
                  'Method này nhận List<Shape>, có thể chứa:\n'
                  '• Rectangle\n'
                  '• Square\n'
                  '• Circle\n'
                  '• BẤT KỲ class nào implements Shape\n\n'
                  '→ Đây là LSP compliance!',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getShapeIcon(Shape shape) {
    if (shape is Rectangle) {
      return Container(width: 40, height: 30, color: Colors.blue);
    } else if (shape is Square) {
      return Container(width: 35, height: 35, color: Colors.green);
    } else if (shape is Circle) {
      return Container(
        width: 35,
        height: 35,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      );
    }
    return const Icon(Icons.shape_line);
  }
}
