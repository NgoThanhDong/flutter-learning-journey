/// ===========================================
/// BÀI TẬP 13: HIGHER-ORDER FUNCTIONS
/// ===========================================
///
/// Mục tiêu: Thành thạo map, where, fold, any, every
///
/// Chạy file: 
///   dart run 01_dart_fundamentals/exercises/exercise_13_higher_order.dart

void main() {
  print('=== BÀI TẬP 13: HIGHER-ORDER FUNCTIONS ===\n');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 1: map() - Biến đổi phần tử       ║
  // ╚════════════════════════════════════════════╝

  print('--- Bài tập 1: map() ---');
  var prices = [100000, 250000, 500000, 750000, 1000000];
  print('Giá gốc: $prices');

  // -TODO 1.1: Giảm giá 10% cho tất cả sản phẩm
  var discounted = prices.map((p) => p * 0.9).toList();
  print('Giảm 10%: $discounted');

  // -TODO 1.2: Format thành chuỗi "xxx VNĐ"
  var formatted = prices.map((p) => '${p} VNĐ').toList();
  print('Formatted: $formatted');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 2: where() - Lọc phần tử          ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 2: where() ---');
  var students = [
    {'name': 'An', 'score': 85},
    {'name': 'Bình', 'score': 92},
    {'name': 'Cường', 'score': 78},
    {'name': 'Dũng', 'score': 95},
    {'name': 'Em', 'score': 65},
  ];

  // -TODO 2.1: Lọc sinh viên có điểm >= 80
  var passed = students.where((s) => s['score'] as int >= 80).toList();
  print('Điểm >= 80: $passed');

  // -TODO 2.2: Lọc sinh viên có tên bắt đầu bằng chữ cái trong ['A', 'B', 'C']
  var abcStudents = students
      .where((s) => ['A', 'B', 'C'].contains((s['name'] as String)[0]))
      .toList();
  print('Tên A/B/C: $abcStudents');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 3: fold() - Tính toán tổng hợp    ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 3: fold() ---');
  var cart = [
    {'name': 'Laptop', 'price': 15000000, 'qty': 1},
    {'name': 'Mouse', 'price': 500000, 'qty': 2},
    {'name': 'Keyboard', 'price': 1000000, 'qty': 1},
  ];

  // -TODO 3.1: Tính tổng tiền giỏ hàng (price * qty cho mỗi item)
  var total = cart.fold<int>(
    0,
    (sum, item) => sum + (item['price'] as int) * (item['qty'] as int),
  );
  print('Tổng giỏ hàng: $total VNĐ');

  // -TODO 3.2: Đếm tổng số lượng sản phẩm
  var totalQty = cart.fold<int>(0, (sum, item) => sum + (item['qty'] as int));
  print('Tổng số lượng: $totalQty');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 4: any() và every()               ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 4: any() và every() ---');
  var ages = [18, 22, 25, 30, 16, 35];
  print('Tuổi: $ages');

  // -TODO 4.1: Kiểm tra có ai dưới 18 tuổi không
  var hasMinor = ages.any((age) => age < 18);
  print('Có người dưới 18: $hasMinor');

  // -TODO 4.2: Kiểm tra tất cả có phải người lớn (>= 18) không
  var allAdults = ages.every((age) => age >= 18);
  print('Tất cả >= 18: $allAdults');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 5: Kết hợp nhiều operations       ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 5: Kết hợp ---');
  var products = [
    {'name': 'A', 'price': 100000, 'inStock': true},
    {'name': 'B', 'price': 200000, 'inStock': false},
    {'name': 'C', 'price': 150000, 'inStock': true},
    {'name': 'D', 'price': 300000, 'inStock': true},
    {'name': 'E', 'price': 250000, 'inStock': false},
  ];

  // -TODO 5.1: Tìm tổng giá của các sản phẩm CÒN HÀNG (inStock = true)
  // Gợi ý: where() -> map() -> fold()

  var inStockTotal = products
      .where((p) => p['inStock'] as bool) // Lọc còn hàng
      .map((p) => p['price']) // Lấy giá
      .fold<int>(0, (sum, price) => sum + (price as int)); // Tính tổng
  print('Tổng giá sản phẩm còn hàng: $inStockTotal VNĐ');

  print('\n--- KIỂM TRA ---');
  checkExercises();
}

void checkExercises() {
  int score = 0;

  // Test 1.1
  var prices = [100000, 250000, 500000];
  var discounted = prices.map((p) => (p * 0.9).round()).toList(); // round() làm tròn giá
  if (discounted[0] == 90000) {
    print('✅ Bài 1.1: PASSED');
    score++;
  }

  // Test 3.1
  var cart = [
    {'price': 100, 'qty': 2},
    {'price': 50, 'qty': 3},
  ];
  var total = cart.fold<int>(
    0,
    (sum, item) => sum + (item['price'] as int) * (item['qty'] as int),
  );
  if (total == 350) {
    print('✅ Bài 3.1: PASSED');
    score++;
  }

  print('\n🎯 Kết quả: $score/2 bài kiểm tra đúng');
}

// ============================================
// GỢI Ý
// ============================================
// 
// Bài 1.1: prices.map((p) => (p * 0.9).round()).toList()
// Bài 1.2: prices.map((p) => '$p VNĐ').toList()
// 
// Bài 2.1: students.where((s) => (s['score'] as int) >= 80)
// Bài 2.2: students.where((s) => ['A', 'B', 'C'].contains((s['name'] as String)[0]))
// 
// Bài 3.1: cart.fold<int>(0, (sum, item) => 
//              sum + (item['price'] as int) * (item['qty'] as int))
// Bài 3.2: cart.fold<int>(0, (sum, item) => sum + (item['qty'] as int))
// 
// Bài 4.1: ages.any((age) => age < 18)
// Bài 4.2: ages.every((age) => age >= 18)
// 
// Bài 5:
//   products
//     .where((p) => p['inStock'] == true)
//     .map((p) => p['price'] as int)
//     .fold<int>(0, (sum, price) => sum + price)
