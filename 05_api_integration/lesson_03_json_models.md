# Lesson 3: JSON & Models 📋

## Mục tiêu

- Tạo Model class cho JSON
- Implement fromJson/toJson
- Handle nested objects
- Parse List of objects

---

## 1. Tại sao cần Model class?

### Không dùng Model (Bad):
```dart
// Dùng Map - dễ sai tên key, không có autocomplete
final name = data['name']; // Nếu typo 'nmae' → runtime error!
final age = data['age'] as int; // Phải cast thủ công
```

### Dùng Model (Good):
```dart
// Dùng class - có autocomplete, compile-time check
final user = User.fromJson(data);
final name = user.name; // IDE gợi ý, không thể sai
```

---

## 2. Model Class cơ bản

### JSON:
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com"
}
```

### Dart Model:
```dart
/// [Model class] - Đại diện cho 1 entity từ API
class User {
  /// Các field tương ứng với JSON keys
  final int id;
  final String name;
  final String email;
  
  /// [Constructor] - Khởi tạo object
  User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  /// [Factory constructor] - Tạo object từ JSON Map
  /// - `json` là Map<String, dynamic> từ jsonDecode
  /// - Trả về instance User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
  
  /// [toJson] - Convert object thành Map để gửi lên server
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

### Sử dụng:
```dart
// Parse JSON → Object
final jsonString = '{"id": 1, "name": "John", "email": "john@example.com"}';
final map = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(map);

// Object → JSON
final jsonMap = user.toJson();
final jsonStr = jsonEncode(jsonMap);
```

---

## 3. Xử lý Nullable fields

### JSON có thể thiếu field:
```json
{
  "id": 1,
  "name": "John"
  // email bị thiếu!
}
```

### Dart Model:
```dart
class User {
  final int id;
  final String name;
  final String? email; // Nullable
  
  User({
    required this.id,
    required this.name,
    this.email, // Optional
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      // Dùng as String? hoặc null nếu không có
      email: json['email'] as String?,
    );
  }
}
```

---

## 4. Default values

```dart
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    name: json['name'] as String? ?? 'Unknown', // Default nếu null
    isActive: json['isActive'] as bool? ?? true,
  );
}
```

---

## 5. Nested Objects

### JSON:
```json
{
  "id": 1,
  "name": "John",
  "address": {
    "city": "Hanoi",
    "country": "Vietnam"
  }
}
```

### Dart Models:
```dart
// Model cho Address
class Address {
  final String city;
  final String country;
  
  Address({required this.city, required this.country});
  
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'city': city,
    'country': country,
  };
}

// Model cho User với nested Address
class User {
  final int id;
  final String name;
  final Address address; // Nested object
  
  User({
    required this.id,
    required this.name,
    required this.address,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      // Parse nested object
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address.toJson(), // Nested toJson
  };
}
```

---

## 6. List of Objects

### JSON:
```json
{
  "users": [
    {"id": 1, "name": "John"},
    {"id": 2, "name": "Jane"}
  ]
}
```

### Parse List:
```dart
factory ApiResponse.fromJson(Map<String, dynamic> json) {
  // json['users'] là List<dynamic>
  final usersList = json['users'] as List<dynamic>;
  
  return ApiResponse(
    users: usersList
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}
```

### Shortcut cho top-level array:
```dart
// Nếu JSON là array trực tiếp: [{...}, {...}]
final jsonList = jsonDecode(response.body) as List<dynamic>;
final users = jsonList
    .map((json) => User.fromJson(json as Map<String, dynamic>))
    .toList();
```

---

## 7. Enums trong JSON

### JSON:
```json
{
  "id": 1,
  "status": "active"
}
```

### Dart:
```dart
enum UserStatus { active, inactive, pending }

class User {
  final int id;
  final UserStatus status;
  
  User({required this.id, required this.status});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      // Parse string → enum
      status: UserStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => UserStatus.pending, // Default
      ),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status.name, // enum → string
  };
}
```

---

## 8. DateTime parsing

### JSON thường có ISO 8601 string:
```json
{
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### Parse:
```dart
class Post {
  final DateTime createdAt;
  
  Post({required this.createdAt});
  
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'createdAt': createdAt.toIso8601String(),
  };
}
```

---

## 9. Complete Example

```dart
import 'dart:convert';

/// Model đầy đủ với tất cả patterns
class Post {
  final int id;
  final String title;
  final String? body;
  final User author;
  final List<String> tags;
  final DateTime createdAt;
  final bool isPublished;
  
  Post({
    required this.id,
    required this.title,
    this.body,
    required this.author,
    required this.tags,
    required this.createdAt,
    this.isPublished = false,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPublished: json['isPublished'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'author': author.toJson(),
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
    'isPublished': isPublished,
  };
  
  /// [copyWith] - Tạo bản sao với một số field thay đổi
  Post copyWith({
    int? id,
    String? title,
    String? body,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      author: author,
      tags: tags,
      createdAt: createdAt,
      isPublished: isPublished,
    );
  }
}
```

---

## 10. Best Practices

| Practice | Mô tả |
|----------|-------|
| `final` fields | Immutable objects |
| `required` | Bắt buộc có giá trị |
| Nullable `?` | Cho optional fields |
| `factory` | Cho fromJson |
| `copyWith` | Clone với modifications |
| Separate files | 1 model = 1 file |

---

## Tóm Tắt

1. **Model class** = Typed representation của JSON
2. **fromJson** = Factory constructor parse JSON → Object
3. **toJson** = Method convert Object → JSON Map
4. **Nested** = Parse từng level, lồng nhau
5. **List** = `.map().toList()` pattern

---

---

## Bài Tập Liên Quan

- `ex05_model_class.dart` - Tạo Model và fromJson/toJson
- `ex06_nested_json.dart` - Xử lý JSON lồng nhau (Nested Objects)
- `ex07_list_parsing.dart` - Parse danh sách Objects (JSON Array)

---

## Bài Tiếp Theo

➡️ [Lesson 4: Dio Advanced](lesson_04_dio_advanced.md)
