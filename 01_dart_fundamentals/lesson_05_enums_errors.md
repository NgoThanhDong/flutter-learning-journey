# Phase 1: Dart Fundamentals - Bài 5: Enums & Error Handling

## Mục tiêu bài học
- Hiểu và sử dụng Enum
- Nắm vững try-catch-finally
- Biết cách tạo Custom Exception

---

## 1. Enum - Tập Hợp Các Giá Trị Cố Định

### 1.1 Tại sao cần Enum?

Thay vì dùng String hoặc int magic numbers:

```dart
// ❌ KHÔNG TỐT - Dễ gõ sai, khó maintain
String status = 'loading';
if (status == 'laoding') { } // Lỗi typo, không bắt được!

int statusCode = 1; // 1 là gì? Loading? Success?
```

Dùng Enum:

```dart
// ✅ TỐT - Type-safe, IDE hỗ trợ autocomplete
enum Status { initial, loading, success, error }

Status status = Status.loading;
if (status == Status.loading) { } // Không thể gõ sai!
```

### 1.2 Enum cơ bản

```dart
enum Color { red, green, blue }

void main() {
  var myColor = Color.green;
  
  // Lấy tên
  print(myColor.name);  // green
  
  // Lấy index
  print(myColor.index); // 1
  
  // Lấy tất cả giá trị
  print(Color.values);  // [Color.red, Color.green, Color.blue]
}
```

### 1.3 Enhanced Enum (Dart 2.17+)

Enum có thể có properties và methods!

```dart
enum Status {
  initial('Chưa bắt đầu'),
  loading('Đang tải...'),
  success('Thành công!'),
  error('Có lỗi xảy ra');
  
  // Property
  final String message;
  
  // Constructor
  const Status(this.message);
  
  // Method
  bool get isCompleted => this == success || this == error;
}

void main() {
  var status = Status.loading;
  print(status.message);      // Đang tải...
  print(status.isCompleted);  // false
}
```

### 1.4 Switch với Enum

```dart
enum OrderStatus { pending, processing, shipped, delivered, cancelled }

String getStatusMessage(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Đang chờ xác nhận';
    case OrderStatus.processing:
      return 'Đang xử lý';
    case OrderStatus.shipped:
      return 'Đang giao hàng';
    case OrderStatus.delivered:
      return 'Đã giao';
    case OrderStatus.cancelled:
      return 'Đã hủy';
  }
}
// Dart bắt buộc xử lý TẤT CẢ cases - không bỏ sót!
```

### 1.5 Enum trong Flutter

```dart
// State management với Enum
enum LoadingState { initial, loading, success, error }

class MyState {
  LoadingState status = LoadingState.initial;
  String? data;
  String? errorMessage;
}

// UI hiển thị theo state
Widget build(BuildContext context) {
  switch (state.status) {
    case LoadingState.initial:
      return Text('Nhấn để tải');
    case LoadingState.loading:
      return CircularProgressIndicator(); // Vòng tròn quay quay :D
    case LoadingState.success:
      return Text(state.data!);
    case LoadingState.error:
      return Text('Lỗi: ${state.errorMessage}');
  }
}
```

---

## 2. Error Handling - Xử Lý Lỗi

### 2.1 Tại sao cần xử lý lỗi?

```dart
// Không xử lý lỗi → App CRASH!
var response = await http.get('https://api.example.com');
var data = jsonDecode(response.body); // Nếu server lỗi???
```

### 2.2 try-catch-finally

```dart
try {
  // Code có thể gây lỗi
  var data = await fetchFromAPI();
  print(data);
} catch (e) {
  // Xử lý khi có lỗi
  print('Lỗi: $e');
} finally {
  // LUÔN chạy, dù có lỗi hay không
  print('Đã hoàn thành');
}
```

### 2.3 Catch cụ thể loại Exception

```dart
try {
  var result = int.parse('abc');
} on FormatException catch (e) {
  // Bắt lỗi format cụ thể
  print('Lỗi format: $e');
} on Exception catch (e) {
  // Bắt các Exception khác
  print('Exception: $e');
} catch (e) {
  // Bắt mọi thứ còn lại
  print('Lỗi không xác định: $e');
}
```

### 2.4 throw - Ném lỗi

```dart
void validateAge(int age) {
  if (age < 0) {
    throw ArgumentError('Tuổi không thể âm!');
  }
  if (age > 150) {
    throw ArgumentError('Tuổi không hợp lệ!');
  }
}

try {
  validateAge(-5);
} catch (e) {
  print(e); // ArgumentError: Tuổi không thể âm!
}
```

### 2.5 rethrow - Ném lại lỗi

```dart
void processData() {
  try {
    fetchData();
  } catch (e) {
    print('Log lỗi: $e');
    rethrow; // Ném lại để caller xử lý
  }
}
```

---

## 3. Custom Exception (Ngoại lệ tùy chỉnh)

### 3.1 Tạo Exception riêng

```dart
// Custom Exception class
// Giống class bình thường nhưng kế thừa Exception
class ApiException implements Exception {
  final int statusCode;
  final String message;
  
  ApiException(this.statusCode, this.message);
  
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Không có kết nối mạng']);
  
  @override
  String toString() => 'NetworkException: $message';
}
```

### 3.2 Sử dụng Custom Exception

```dart
// Giả sử có API
Future<String> fetchUser(int id) async {
  try {
    var response = await http.get('api/users/$id');
    
    if (response.statusCode == 404) { // Không tìm thấy user
      throw ApiException(404, 'Không tìm thấy user');
    }
    if (response.statusCode != 200) { // Server error
      throw ApiException(response.statusCode, 'Server error');
    }
    
    return response.body;
  } on SocketException { // Lỗi kết nối mạng
    throw NetworkException(); // Không có kết nối mạng
  }
}

// Sử dụng
try {
  var user = await fetchUser(999);
} on ApiException catch (e) {
  print('API Error: ${e.message}');
} on NetworkException catch (e) {
  print('Network Error: $e');
}
```

---

## 4. Pattern: Result Type (Kiểu kết quả)

Thay vì throw exception, trả về kết quả có cấu trúc:

```dart
// Sealed class cho Result (Dart 3)
// Sealed class là class chỉ có thể là Success hoặc Failure
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final String error;
  Failure(this.error);
}

// Sử dụng
Future<Result<User>> fetchUser(int id) async {
  try {
    var response = await http.get('api/users/$id');
    if (response.statusCode == 200) {
      return Success(User.fromJson(response.body));
    }
    return Failure('Error: ${response.statusCode}');
  } catch (e) {
    return Failure(e.toString());
  }
}

// Xử lý
var result = await fetchUser(1);
switch (result) {
  case Success(data: var user):
    print('User: ${user.name}');
  case Failure(error: var msg):
    print('Error: $msg');
}
```

---

## 5. Best Practices

### 5.1 Khi nào dùng Exception?

| Tình huống | Nên dùng |
|------------|----------|
| Lỗi không mong đợi (network, server) | Exception |
| Validation input (không hợp lệ) | Return null/false hoặc Result type |
| Business logic error (lỗi nghiệp vụ) | Custom Exception |
| Lỗi lập trình (bug) | Assert (chỉ dùng trong development) |

### 5.2 Không nên catch quá rộng

```dart
// ❌ KHÔNG TỐT - nuốt mọi lỗi
try {
  doSomething();
} catch (e) {
  // Bỏ qua lỗi
}

// ✅ TỐT - xử lý cụ thể
try {
  doSomething();
} on SpecificException catch (e) { // Bắt lỗi cụ thể
  handleSpecificError(e);
} catch (e) { // Bắt lỗi chung
  logError(e);
  rethrow; // Ném lại lỗi
}
```

---

## 6. Bài Tập Thực Hành

| Bài | File | Nội dung |
|-----|------|----------|
| 1 | `exercise_14_enum.dart` | Enum cơ bản và enhanced |
| 2 | `exercise_15_error_handling.dart` | try-catch và custom exception |

---

## 📝 Checklist Bài 5

- [ ] Hiểu tại sao dùng Enum thay vì String/int
- [ ] Tạo được Enhanced Enum với properties
- [ ] Dùng switch với Enum
- [ ] Sử dụng try-catch-finally
- [ ] Tạo Custom Exception
- [ ] Hoàn thành 2 bài tập

**Kết thúc Phase 1!** 🎉 Tiếp theo: Phase 2 - Flutter Basics & Widget System
