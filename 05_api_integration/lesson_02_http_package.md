# Lesson 2: http Package 📦

## Mục tiêu

- Cài đặt và sử dụng `http` package
- Thực hiện GET request
- Thực hiện POST request
- Xử lý response

---

## 1. Giới thiệu http Package

`http` là package chính thức từ Dart team, đơn giản và dễ sử dụng.

### Cài đặt:
```yaml
dependencies:
  http: ^1.2.0
```

### Import:
```dart
import 'package:http/http.dart' as http;
```

> **Lưu ý**: Dùng `as http` để tránh conflict với các tên khác.

---

## 2. GET Request

### Cú pháp cơ bản:
```dart
/// [http.get] - Gửi GET request
/// [Uri.parse] - Convert string URL thành Uri object
/// [await] - Chờ response từ server
final response = await http.get(
  Uri.parse('https://jsonplaceholder.typicode.com/users'),
);

/// [response.statusCode] - HTTP status code (200, 404, 500...)
/// [response.body] - Nội dung response (String JSON)
if (response.statusCode == 200) {
  print('Success!');
  print(response.body);
} else {
  print('Error: ${response.statusCode}');
}
```

### Giải thích từng phần:
| Phần | Mô tả |
|------|-------|
| `http.get()` | Hàm gửi GET request |
| `Uri.parse(url)` | Parse string thành Uri |
| `await` | Chờ Future hoàn thành |
| `response.statusCode` | Mã trạng thái (200 = OK) |
| `response.body` | Nội dung response (JSON string) |

---

## 3. GET với Headers

```dart
final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer your_token_here',
  },
);
```

---

## 4. POST Request

### Gửi POST với body:
```dart
final response = await http.post(
  Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode({
    'title': 'Hello World',
    'body': 'This is my first post',
    'userId': 1,
  }),
);

if (response.statusCode == 201) {
  print('Created successfully!');
  print(response.body);
}
```

### Giải thích:
| Phần | Mô tả |
|------|-------|
| `http.post()` | Hàm gửi POST request |
| `headers` | Metadata (bắt buộc `Content-Type` cho JSON) |
| `body` | Dữ liệu gửi đi (phải là String) |
| `jsonEncode()` | Convert Map → JSON String |

---

## 5. PUT và DELETE

### PUT (Update):
```dart
final response = await http.put(
  Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'id': 1,
    'title': 'Updated Title',
    'body': 'Updated body',
    'userId': 1,
  }),
);
```

### DELETE:
```dart
final response = await http.delete(
  Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
);

if (response.statusCode == 200) {
  print('Deleted!');
}
```

---

## 6. Query Parameters

```dart
/// Cách 1: String interpolation
final url = 'https://api.example.com/search?q=flutter&page=1';

/// Cách 2: Uri với queryParameters (recommended - tự encode)
final uri = Uri.https(
  'jsonplaceholder.typicode.com',
  '/posts',
  {'userId': '1'}, // Query params
);
// Kết quả: https://jsonplaceholder.typicode.com/posts?userId=1

final response = await http.get(uri);
```

---

## 7. Xử lý Response

### Parse JSON:
```dart
import 'dart:convert';

final response = await http.get(Uri.parse(url));

if (response.statusCode == 200) {
  /// [jsonDecode] - Convert JSON String → Dart object
  /// Trả về dynamic (Map hoặc List tùy JSON)
  final data = jsonDecode(response.body);
  
  if (data is List) {
    // JSON array: [...]
    for (var item in data) {
      print(item['name']);
    }
  } else if (data is Map) {
    // JSON object: {...}
    print(data['name']);
  }
}
```

---

## 8. Error Handling

```dart
try {
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    // Success
    final data = jsonDecode(response.body);
    return data;
  } else if (response.statusCode == 404) {
    throw Exception('Resource not found');
  } else if (response.statusCode == 401) {
    throw Exception('Unauthorized - please login');
  } else {
    throw Exception('Failed: ${response.statusCode}');
  }
} catch (e) {
  // Network error, timeout, etc.
  print('Error: $e');
  rethrow;
}
```

---

## 9. Timeout

```dart
final response = await http.get(
  Uri.parse(url),
).timeout(
  const Duration(seconds: 10),
  onTimeout: () {
    throw Exception('Request timed out');
  },
);
```

---

## 10. Complete Example

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';
  
  /// Lấy danh sách users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load users');
    }
  }
  
  /// Tạo user mới
  Future<Map<String, dynamic>> createUser(String name, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );
    
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }
}
```

---

## Tóm Tắt

| Hàm | Mục đích |
|-----|----------|
| `http.get()` | Lấy dữ liệu |
| `http.post()` | Tạo mới |
| `http.put()` | Cập nhật toàn bộ |
| `http.delete()` | Xóa |
| `jsonDecode()` | JSON String → Dart |
| `jsonEncode()` | Dart → JSON String |

---

## Bài Tập Liên Quan

- `ex01_simple_get.dart` - GET request cơ bản
- `ex02_json_parsing.dart` - Parse JSON
- `ex03_post_request.dart` - POST request

---

## Bài Tiếp Theo

➡️ [Lesson 3: JSON & Models](lesson_03_json_models.md)
