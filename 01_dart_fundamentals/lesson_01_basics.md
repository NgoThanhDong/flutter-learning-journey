# Phase 1: Dart Fundamentals - Bài 1: Cơ Bản Về Dart

## Mục tiêu bài học
- Hiểu cách Dart hoạt động
- Nắm vững biến, kiểu dữ liệu, và Null Safety
- Thành thạo Functions và Parameters

---

## 1. Tại Sao Học Dart?

Dart là ngôn ngữ được Google tạo ra cho Flutter. Hiểu Dart là nền tảng để viết Flutter.

**Đặc điểm quan trọng:**
- **Strongly typed**: Mỗi biến có kiểu xác định → ít lỗi hơn
- **Null Safety**: Ngăn lỗi null pointer crash
- **JIT & AOT compilation**: Dev nhanh, release performance cao

---

## 2. Variables & Types (Biến và Kiểu dữ liệu)

### 2.1 Khai báo biến

```dart
// [1] var - Dart tự suy luận kiểu (Type Inference)
var name = 'Dong';  // Dart biết đây là String
var age = 25;       // Dart biết đây là int

// [2] Khai báo tường minh
String city = 'Hanoi';
int year = 2024;
double price = 99.99;
bool isActive = true;

// [3] dynamic - Có thể thay đổi kiểu (TRÁNH dùng)
dynamic anything = 'Hello';
anything = 123;  // Cho phép, nhưng nguy hiểm!

// [4] final vs const
final currentTime = DateTime.now();  // Gán 1 lần, runtime
const PI = 3.14159;  // Compile-time constant
```

### 💡 Suy luận: Khi nào dùng gì?

| Từ khóa | Khi nào dùng |
|---------|-------------|
| `var` | Biến thay đổi được, kiểu rõ ràng từ giá trị |
| `final` | Gán 1 lần, giá trị biết lúc runtime |
| `const` | Giá trị biết lúc compile (hằng số) |
| `dynamic` | Tránh dùng! Chỉ khi thực sự cần linh hoạt |

---

## 3. Null Safety (An toàn với giá trị null) - Phải Hiểu!

```dart
// [1] Non-nullable: KHÔNG được null
String name = 'Dong';
// name = null;  // ❌ LỖI COMPILE!

// [2] Nullable: Có thể null (thêm ?)
String? nickname;  // Mặc định = null
nickname = 'D';    // OK

// [3] Truy cập an toàn với ?.
print(nickname?.length);  // Nếu null → print null, không crash

// [4] Null assertion ! (cẩn thận!)
String forcedValue = nickname!;  // Đảm bảo không null, nếu null → crash

// [5] Default value với ??
String displayName = nickname ?? 'Anonymous';
```

### 💡 Tại sao Null Safety quan trọng?

Trước Null Safety, đây là lỗi phổ biến nhất:
```dart
String name;
print(name.length);  // 💥 Runtime crash: Null pointer exception
```

Với Null Safety, Dart **bắt lỗi này lúc compile**, không phải lúc app chạy!

---

## 4. Functions (Hàm)

### 4.1 Cú pháp cơ bản

```dart
// Function với return type
int add(int a, int b) {
  return a + b;
}

// Arrow function (1 expression)
int multiply(int a, int b) => a * b;

// Void function (không return)
void greet(String name) {
  print('Hello, $name!');
}
```

### 4.2 Parameters (Tham số) - QUAN TRỌNG!

```dart
// [1] Positional parameters (bắt buộc, theo thứ tự)
void sayHello(String name, int age) {
  print('$name is $age years old');
}
sayHello('Dong', 25);  // Phải đủ 2 tham số, đúng thứ tự

// [2] Named parameters (tên rõ ràng, linh hoạt)
void createUser({required String name, int age = 18}) {
  print('$name, $age');
}
createUser(name: 'Dong');  // age mặc định = 18
createUser(name: 'An', age: 30);

// [3] Optional positional parameters
void log(String message, [String? prefix]) {
  print('${prefix ?? 'INFO'}: $message');
}
log('Hello');           // INFO: Hello
log('Hello', 'DEBUG');  // DEBUG: Hello
```

### 💡 Thủ thuật: Flutter dùng Named Parameters rất nhiều

```dart
// Trong Flutter, bạn sẽ thấy pattern này:
Container(
  width: 100,      // Named parameter
  height: 200,     // Named parameter
  color: Colors.red,
)
```

Đây là lý do **named parameters** quan trọng - code dễ đọc hơn!

---

## 5. Bài Tập Thực Hành

### Bài 1: Khai báo biến
File: `exercises/exercise_01_variables.dart`
- Tạo file bài tập và khai báo:
1. Tên của bạn (String)
2. Tuổi (int)
3. Có phải sinh viên không (bool)
4. Điểm trung bình (double, nullable)

### Bài 2: Null Safety
File: `exercises/exercise_02_null_safety.dart`
- Viết function `getDisplayName` nhận `String? nickname` và trả về nickname nếu có, hoặc "Guest" nếu null.

### Bài 3: Named Parameters
File: `exercises/exercise_03_named_params.dart`
- Viết function `createProfile` với:
1. `name` (required)
2. `age` (optional, default 18)
3. `email` (optional, nullable)

---

## 📝 Checklist Bài 1

- [ ] Hiểu sự khác nhau giữa `var`, `final`, `const`
- [ ] Hiểu Null Safety và các operators: `?`, `!`, `??`
- [ ] Viết được function với named parameters
- [ ] Hoàn thành 3 bài tập

**Tiếp theo:** Bài 2 - OOP trong Dart (Class, Inheritance, Abstract)
