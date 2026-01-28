// ignore_for_file: dead_code, unnecessary_null_aware_operator_on_extension_on_nullable, dead_null_aware_expression, invalid_null_aware_operator, unnecessary_null_aware_access

/// ===========================================
/// DART FUNDAMENTALS - BÀI 1: CƠ BẢN
/// ===========================================
///
/// File này chứa các ví dụ minh họa cho Bài 1.
/// Chạy file này để xem kết quả:
///
/// ```
/// dart run lesson_01_examples.dart
/// ```

void main() {
  print('=== 1. VARIABLES & TYPES ===\n');
  demonstrateVariables();

  print('\n=== 2. NULL SAFETY ===\n');
  demonstrateNullSafety();

  print('\n=== 3. FUNCTIONS ===\n');
  demonstrateFunctions();
}

// ============================================
// 1. VARIABLES & TYPES
// ============================================

void demonstrateVariables() {
  // var - Type Inference (Dart tự suy luận kiểu)
  var name = 'Dong';
  var age = 25;
  print('var name = $name (type: ${name.runtimeType})');
  print('var age = $age (type: ${age.runtimeType})');

  // Khai báo tường minh
  String city = 'Hanoi';
  int year = 2024;
  double price = 99.99;
  bool isActive = true;

  print('\nKhai báo tường minh:');
  print('String city = $city');
  print('int year = $year');
  print('double price = $price');
  print('bool isActive = $isActive');

  // final vs const
  final currentTime = DateTime.now(); // Runtime value
  const PI = 3.14159; // Compile-time constant

  print('\nfinal vs const:');
  print('final currentTime = $currentTime');
  print('const PI = $PI');

  // 💡 ĐIỂM QUAN TRỌNG:
  // - final: Gán 1 lần, giá trị được xác định lúc runtime
  // - const: Giá trị phải biết lúc compile
  //
  // Ví dụ: const time = DateTime.now(); // ❌ LỖI!
  // Vì DateTime.now() chỉ biết lúc runtime
}

// ============================================
// 2. NULL SAFETY
// ============================================

void demonstrateNullSafety() {
  // Non-nullable: KHÔNG được null
  String name = 'Dong';
  print('Non-nullable: name = $name');
  // name = null; // ❌ Lỗi compile!

  // Nullable: Có thể null (thêm ?)
  String? nickname;
  print('Nullable: nickname = $nickname'); // null

  nickname = 'D';
  print('Sau khi gán: nickname = $nickname');

  // Truy cập an toàn với ?.
  print('\nSử dụng ?. để truy cập an toàn:');
  String? maybeNull;
  print('maybeNull?.length = ${maybeNull?.length}'); // null, không crash

  maybeNull = 'Hello';
  print('maybeNull?.length = ${maybeNull?.length}'); // 5

  // Default value với ??
  print('\nSử dụng ?? cho giá trị mặc định:');
  String? username;
  String displayName = username ?? 'Guest';
  print('displayName = $displayName'); // Guest

  username = 'Dong';
  displayName = username ?? 'Guest';
  print('displayName = $displayName'); // Dong
}

// ============================================
// 3. FUNCTIONS
// ============================================

void demonstrateFunctions() {
  // Function thông thường
  print('add(5, 3) = ${add(5, 3)}');
  print('multiply(4, 7) = ${multiply(4, 7)}');

  // Positional parameters
  print('\n--- Positional Parameters ---');
  sayHello('Dong', 25);

  // Named parameters
  print('\n--- Named Parameters ---');
  createUser(name: 'Dong');
  createUser(name: 'An', age: 30);

  // Optional positional parameters
  print('\n--- Optional Positional Parameters ---');
  log('Hello');
  log('Hello', 'DEBUG');
}

// Function với return type
int add(int a, int b) {
  return a + b;
}

// Arrow function (khi chỉ có 1 expression)
int multiply(int a, int b) => a * b;

// Positional parameters (theo thứ tự)
void sayHello(String name, int age) {
  print('$name is $age years old');
}

// Named parameters (linh hoạt, dễ đọc)
void createUser({required String name, int age = 18}) {
  print('Created user: $name, age: $age');
}

// Optional positional parameters
void log(String message, [String? prefix]) {
  print('${prefix ?? 'INFO'}: $message');
}

// ============================================
// 💡 GHI NHỚ QUAN TRỌNG
// ============================================
//
// 1. Dùng `var` khi kiểu rõ ràng từ giá trị
// 2. Dùng `final` cho giá trị gán 1 lần
// 3. Dùng `const` cho hằng số compile-time
// 4. Luôn xử lý null với ?, ??, ?.
// 5. Flutter dùng named parameters rất nhiều!
