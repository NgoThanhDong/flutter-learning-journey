/// ===========================================
/// BÀI TẬP 1: TẠO CLASS PRODUCT
/// ===========================================
///
/// Yêu cầu:
/// 1. Tạo class Product với properties: name, price, quantity
/// 2. Tạo method getTotalValue() trả về price * quantity
/// 3. Tạo named constructor Product.free(name) với price = 0
///
/// Chạy file để kiểm tra: 
///   dart run 01_dart_fundamentals/exercises/exercise_04_product.dart

void main() {
  print('=== BÀI TẬP 1: CLASS PRODUCT ===\n');

  // Uncomment các dòng dưới sau khi implement xong

  // Test 1: Tạo product thông thường
  var laptop = Product('Laptop', 15000000, 2);
  print('Sản phẩm: ${laptop.name}');
  print('Giá: ${laptop.price} VNĐ');
  print('Số lượng: ${laptop.quantity}');
  print('Tổng giá trị: ${laptop.getTotalValue()} VNĐ');

  // Test 2: Tạo product miễn phí
  var freeGift = Product.free('Túi tặng kèm');
  print('\nQuà tặng: ${freeGift.name}');
  print('Giá: ${freeGift.price} VNĐ (miễn phí!)');

  // Chạy kiểm tra tự động
  print('\n--- KIỂM TRA ---');
  checkExercise();

  print('👆 Hãy implement class Product rồi uncomment code trên!');
}

// ============================================
// -TODO: VIẾT CODE CỦA BẠN Ở ĐÂY
// ============================================

class Product {
  // Properties
  String name;
  double price;
  int quantity;

  // Constructor
  Product(this.name, this.price, this.quantity);

  // Named constructor Product.free(name)
  Product.free(this.name) : price = 0, quantity = 1;

  // Method getTotalValue()
  double getTotalValue() => price * quantity;
}

// ============================================
// GỢI Ý (xem nếu cần)
// ============================================
//
// 1. Properties:
//    String name;
//    double price;
//    int quantity;
//
// 2. Constructor:
//    Product(this.name, this.price, this.quantity);
//
// 3. Named constructor:
//    Product.free(this.name) : price = 0, quantity = 1;
//
// 4. Method:
//    double getTotalValue() => price * quantity;

// ============================================
// HÀM KIỂM TRA (không cần sửa)
// ============================================

void checkExercise() {
  int score = 0;

  try {
    // Test 1: Constructor thông thường
    var p1 = Product('Test', 100.0, 5);
    if (p1.name == 'Test' && p1.price == 100.0 && p1.quantity == 5) {
      print('✅ Constructor thông thường: PASSED');
      score++;
    }

    // Test 2: getTotalValue()
    if (p1.getTotalValue() == 500.0) {
      print('✅ getTotalValue(): PASSED');
      score++;
    }

    // Test 3: Named constructor Product.free()
    var p2 = Product.free('Gift');
    if (p2.name == 'Gift' && p2.price == 0) {
      print('✅ Product.free(): PASSED');
      score++;
    }

    print('\n🎯 Kết quả: $score/3 điểm');
    if (score == 3) {
      print('🎉 Xuất sắc! Bạn đã hoàn thành bài tập!');
    }
  } catch (e) {
    print('❌ Lỗi: $e');
    print('💡 Hãy implement class Product trước!');
  }
}
