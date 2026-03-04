/// ===========================================
/// DART FUNDAMENTALS - BÀI 5: ENUMS & ERROR HANDLING
/// ===========================================
///
/// Chạy file:
///   dart run 01_dart_fundamentals/lesson_05_examples.dart

void main() {
  print('=== 1. ENUM CƠ BẢN ===\n');
  demonstrateBasicEnum();

  print('\n=== 2. ENHANCED ENUM ===\n');
  demonstrateEnhancedEnum();

  print('\n=== 3. SWITCH VỚI ENUM ===\n');
  demonstrateSwitchEnum();

  print('\n=== 4. TRY-CATCH-FINALLY ===\n');
  demonstrateTryCatch();

  print('\n=== 5. CUSTOM EXCEPTION ===\n');
  demonstrateCustomException();

  print('\n=== 6. THỰC TẾ: API ERROR HANDLING ===\n');
  demonstrateApiErrorHandling();
}

// ============================================
// 1. ENUM CƠ BẢN
// ============================================

enum Color { red, green, blue }

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

void demonstrateBasicEnum() {
  var myColor = Color.green;

  print('Color: $myColor');
  print('Name: ${myColor.name}');
  print('Index: ${myColor.index}');
  print('All values: ${Color.values}');

  // So sánh enum
  print('\nmyColor == Color.green: ${myColor == Color.green}');

  // WeekDay
  var today = WeekDay.friday;
  print('\nToday is ${today.name}');
  print('Is weekend: ${today == WeekDay.saturday || today == WeekDay.sunday}');
}

// ============================================
// 2. ENHANCED ENUM (Dart 2.17+)
// ============================================

enum Status {
  initial('Chưa bắt đầu', '⚪'),
  loading('Đang tải...', '🔄'),
  success('Thành công!', '✅'),
  error('Có lỗi!', '❌');

  // Properties
  final String message;
  final String icon;

  // Constructor (phải là const)
  const Status(this.message, this.icon);

  // Computed property
  bool get isCompleted => this == success || this == error;

  // Method
  void display() {
    print('$icon $message');
  }
}

void demonstrateEnhancedEnum() {
  for (var status in Status.values) {
    print('${status.name}: ${status.icon} ${status.message}');
  }

  print('\n--- Sử dụng ---');
  var current = Status.loading;
  current.display();
  print('isCompleted: ${current.isCompleted}');

  current = Status.success;
  current.display();
  print('isCompleted: ${current.isCompleted}');
}

// ============================================
// 3. SWITCH VỚI ENUM
// ============================================

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

/// Hàm trả về message của OrderStatus
String getStatusMessage(OrderStatus status) {
  // Dart bắt buộc xử lý TẤT CẢ cases!
  switch (status) {
    case OrderStatus.pending:
      return '⏳ Đang chờ xác nhận';
    case OrderStatus.processing:
      return '📦 Đang xử lý';
    case OrderStatus.shipped:
      return '🚚 Đang giao hàng';
    case OrderStatus.delivered:
      return '✅ Đã giao thành công';
    case OrderStatus.cancelled:
      return '❌ Đã hủy';
  }
}

/// Hàm demo switch với enum
void demonstrateSwitchEnum() {
  for (var status in OrderStatus.values) {
    print('${status.name}: ${getStatusMessage(status)}');
  }
}

// ============================================
// 4. TRY-CATCH-FINALLY
// ============================================

void demonstrateTryCatch() {
  // Ví dụ 1: Parse số
  print('--- Parse số ---');
  try {
    var number = int.parse('abc');
    print('Số: $number');
  } on FormatException catch (e) {
    print('❌ Lỗi format: $e');
  }

  // Ví dụ 2: Chia cho 0
  print('\n--- Chia số ---');
  try {
    var result = divide(10, 0);
    print('Kết quả: $result');
  } catch (e) {
    print('❌ Lỗi: $e');
  }

  // Ví dụ 3: finally luôn chạy
  print('\n--- Finally ---');
  try {
    print('Đang thực hiện...');
    throw Exception('Có lỗi!');
  } catch (e) {
    print('❌ Caught: $e');
  } finally {
    print('✅ Finally: Luôn chạy!');
  }
}

int divide(int a, int b) {
  if (b == 0) {
    throw ArgumentError('Không thể chia cho 0!');
  }
  return a ~/ b;
}

// ============================================
// 5. CUSTOM EXCEPTION
// ============================================

// Custom Exception classes
/// Tạo custom exception để xử lý lỗi validation, phải implement Exception
class ValidationException implements Exception {
  final String field;
  final String message;

  ValidationException(this.field, this.message);

  @override
  String toString() => 'ValidationException: $field - $message';
}

/// Tạo custom exception kế thừa từ ValidationException
class AgeValidationException extends ValidationException {
  final int invalidAge;

  AgeValidationException(this.invalidAge)
    : super('age', 'Tuổi $invalidAge không hợp lệ');
}

// Validation function
void validateUser(String name, int age) {
  if (name.isEmpty) {
    throw ValidationException('name', 'Tên không được rỗng');
  }
  if (age < 0 || age > 150) {
    throw AgeValidationException(age);
  }
}

void demonstrateCustomException() {
  // Test với tên rỗng
  print('--- Test tên rỗng ---');
  try {
    validateUser('', 25);
  } on ValidationException catch (e) {
    print('❌ $e');
  }

  // Test với tuổi sai
  print('\n--- Test tuổi sai ---');
  try {
    validateUser('Dong', -5);
  } on AgeValidationException catch (e) {
    print('❌ $e');
  }

  // Test thành công
  print('\n--- Test thành công ---');
  try {
    validateUser('Dong', 25);
    print('✅ Validation passed!');
  } catch (e) {
    print('❌ $e');
  }
}

// ============================================
// 6. THỰC TẾ: API ERROR HANDLING
// ============================================

// Giả lập API response
enum ApiStatus { ok, notFound, serverError, networkError }

class ApiResponse {
  final ApiStatus status;
  final String? data;

  ApiResponse(this.status, [this.data]);
}

// Custom API Exceptions
class ApiException implements Exception {
  final int code;
  final String message;

  ApiException(this.code, this.message);

  @override
  String toString() => 'ApiException($code): $message';
}

class NotFoundException extends ApiException {
  NotFoundException(String resource) : super(404, '$resource không tìm thấy');
}

class ServerException extends ApiException {
  ServerException() : super(500, 'Lỗi server');
}

// Giả lập API call
Future<String> fetchUser(int id) async {
  // Giả lập network delay
  await Future.delayed(Duration(milliseconds: 100));

  // Giả lập các response khác nhau
  if (id == 0) {
    throw NotFoundException('User');
  }
  if (id < 0) {
    throw ServerException();
  }

  return 'User $id';
}

void demonstrateApiErrorHandling() async {
  var testIds = [1, 0, -1];

  for (var id in testIds) {
    print('--- Fetch user $id ---');
    try {
      var user = await fetchUser(id);
      print('✅ Success: $user');
    } on NotFoundException catch (e) {
      print('❌ Not Found: ${e.message}');
    } on ServerException catch (e) {
      print('❌ Server Error: ${e.message}');
    } on ApiException catch (e) {
      print('❌ API Error: $e');
    } catch (e) {
      print('❌ Unknown Error: $e');
    }
    print('');
  }
}

// ============================================
// 💡 GHI NHỚ QUAN TRỌNG
// ============================================
// 
// ENUM:
// 1. Dùng thay String/int để type-safe
// 2. Enhanced Enum có thể có properties và methods
// 3. Switch với Enum phải handle TẤT CẢ cases
// 
// ERROR HANDLING:
// 1. try-catch-finally cho xử lý lỗi
// 2. Catch cụ thể exception type trước
// 3. Custom Exception cho lỗi business logic
// 4. finally luôn chạy (cleanup resources)
