/// ===========================================
/// DART FUNDAMENTALS - BÀI 4: COLLECTIONS & GENERICS
/// ===========================================
///
/// Chạy file:
///   dart run 01_dart_fundamentals/lesson_04_examples.dart

void main() {
  print('=== 1. LIST ===\n');
  demonstrateList();

  print('\n=== 2. MAP ===\n');
  demonstrateMap();

  print('\n=== 3. SET ===\n');
  demonstrateSet();

  print('\n=== 4. GENERICS ===\n');
  demonstrateGenerics();

  print('\n=== 5. HIGHER-ORDER FUNCTIONS ===\n');
  demonstrateHigherOrderFunctions();

  print('\n=== 6. SPREAD OPERATOR ===\n');
  demonstrateSpread();
}

// ============================================
// 1. LIST
// ============================================

void demonstrateList() {
  // Tạo List
  var fruits = ['Táo', 'Cam', 'Chuối'];
  print('Danh sách trái cây: $fruits');

  // Truy cập
  print('Phần tử đầu: ${fruits.first}');
  print('Phần tử cuối: ${fruits.last}');
  print('Phần tử thứ 2: ${fruits[1]}');
  print('Số lượng: ${fruits.length}');

  // Thêm
  fruits.add('Nho');
  print('\nSau khi add("Nho"): $fruits');

  fruits.insert(0, 'Dưa');
  print('Sau khi insert(0, "Dưa"): $fruits');

  // Xóa
  fruits.remove('Cam');
  print('Sau khi remove("Cam"): $fruits');

  // Kiểm tra
  print('\ncontains("Táo"): ${fruits.contains("Táo")}');
  print('indexOf("Chuối"): ${fruits.indexOf("Chuối")}');

  // Tạo List với List.generate
  var squares = List.generate(5, (i) => (i + 1) * (i + 1));
  print('\nList.generate (bình phương): $squares');
}

// ============================================
// 2. MAP
// ============================================

void demonstrateMap() {
  // Tạo Map
  var user = {'name': 'Dong', 'age': 25, 'isStudent': true};
  print('User: $user');

  // Truy cập
  print('\nuser["name"]: ${user["name"]}');
  print('user["email"]: ${user["email"]}'); // null

  // Thêm/sửa
  user['email'] = 'dong@example.com';
  user['age'] = 26;
  print('\nSau khi thêm email và sửa age: $user');

  // Keys và Values
  print('\nKeys: ${user.keys}');
  print('Values: ${user.values}');

  // Kiểm tra
  print('\ncontainsKey("name"): ${user.containsKey("name")}');
  print('containsValue(26): ${user.containsValue(26)}');

  // Map<String, dynamic> - Giống JSON
  print('\n--- Map<String, dynamic> (JSON) ---');
  Map<String, dynamic> product = {
    'id': 1,
    'name': 'Laptop',
    'price': 15000000.0,
    'inStock': true,
    'tags': ['electronics', 'computer'],
  };
  print('Product: $product');
  print('Price: ${product["price"]} VNĐ');
  print('Tags: ${product["tags"]}');
}

// ============================================
// 3. SET
// ============================================

void demonstrateSet() {
  var colors = {'red', 'green', 'blue'};
  print('Colors: $colors');

  // Thêm
  colors.add('yellow');
  colors.add('red'); // Không thêm vì đã có
  print('Sau khi add yellow và red: $colors');

  // Loại bỏ trùng lặp từ List
  var numbers = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4];
  var uniqueNumbers = numbers.toSet();
  print('\nList gốc: $numbers');
  print('Set (loại trùng): $uniqueNumbers');

  // Phép toán tập hợp
  var a = {1, 2, 3, 4};
  var b = {3, 4, 5, 6};
  print('\na = $a, b = $b');
  print('Hợp (union): ${a.union(b)}');
  print('Giao (intersection): ${a.intersection(b)}');
  print('Hiệu (difference a-b): ${a.difference(b)}');
}

// ============================================
// 4. GENERICS
// ============================================

void demonstrateGenerics() {
  // List với Generic
  List<int> numbers = [1, 2, 3];
  List<String> names = ['An', 'Bình'];
  // numbers.add('hello'); // ❌ Compile error!
  print('List<int>: $numbers');
  print('List<String>: $names');

  // Map với Generic
  Map<String, int> scores = {'math': 90, 'english': 85};
  print('\nMap<String, int>: $scores');

  // Generic Class
  var intBox = Box<int>(42);
  var stringBox = Box<String>('Hello');

  print('\nBox<int>.content: ${intBox.content}');
  print('Box<String>.content: ${stringBox.content}');

  // Generic với constraints
  var numberBox = NumberBox<int>(100);
  print('NumberBox doubled: ${numberBox.doubled()}');
}

// Generic Class đơn giản
class Box<T> {
  T content;
  Box(this.content);
}

// Generic với constraints (T phải là num)
class NumberBox<T extends num> {
  T value;
  NumberBox(this.value);

  num doubled() => value * 2;
}

// ============================================
// 5. HIGHER-ORDER FUNCTIONS
// ============================================

void demonstrateHigherOrderFunctions() {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  print('Original: $numbers');

  // map() - Biến đổi mỗi phần tử
  // toList() - Chuyển về List
  var doubled = numbers.map((n) => n * 2).toList();
  print('\nmap (x2): $doubled');

  // take() - Lấy số phần tử đầu tiên
  var strings = numbers.map((n) => 'Số $n').toList();
  print('map (to string): ${strings.take(3).toList()}...');

  // where() - Lọc
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print('\nwhere (số chẵn): $evens');

  var bigNumbers = numbers.where((n) => n > 5).toList();
  print('where (> 5): $bigNumbers');

  // fold() - Gộp thành 1 giá trị
  var sum = numbers.fold(0, (total, n) => total + n);
  print('\nfold (tổng): $sum');

  var product = numbers.take(5).fold(1, (prod, n) => prod * n);
  print('fold (tích 1-5): $product');

  // any() và every()
  print('\nany (có số > 8): ${numbers.any((n) => n > 8)}');
  print('every (tất cả > 0): ${numbers.every((n) => n > 0)}');

  // firstWhere() - Tìm phần tử đầu tiên thỏa mãn điều kiện
  var firstEven = numbers.firstWhere((n) => n % 2 == 0);
  print('\nfirstWhere (số chẵn đầu tiên): $firstEven');

  // Kết hợp nhiều operations
  print('\n--- Kết hợp ---');
  var result = numbers
      .where((n) => n % 2 == 0) // Lọc số chẵn
      .map((n) => n * 10) // Nhân 10
      .toList();
  print('Số chẵn x 10: $result');
}

// ============================================
// 6. SPREAD OPERATOR
// ============================================

void demonstrateSpread() {
  var list1 = [1, 2, 3];
  var list2 = [4, 5, 6];

  // Gộp 2 list
  var combined = [...list1, ...list2];
  print('Spread: [...list1, ...list2] = $combined');

  // Thêm phần tử khi gộp
  var withExtra = [0, ...list1, 100];
  print('Với extra: $withExtra');

  // Null-aware spread (...?)
  // Nếu maybeNull là null thì không thêm gì cả
  List<int>? maybeNull;
  var safe = [...list1, ...?maybeNull];
  print('\nNull-aware spread: $safe');

  // Trong Flutter, bạn sẽ dùng như này:
  print('\n💡 Trong Flutter:');
  print('''
  Row(
    children: [
      Icon(Icons.star),
      ...listOfWidgets,  // Spread widgets
      Text('End'),
    ],
  )
  ''');
}

// ============================================
// 💡 GHI NHỚ QUAN TRỌNG
// ============================================
//
// 1. List = danh sách có thứ tự, có thể trùng
// 2. Map = cặp key-value, key không trùng
// 3. Set = tập hợp không trùng lặp
// 4. Generics = chỉ định kiểu để bắt lỗi sớm
// 5. map(), where(), fold() = xử lý collection linh hoạt
// 6. Spread (...) = gộp collections
