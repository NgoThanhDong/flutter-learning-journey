# Lesson 6: Local Storage 💾

## Mục tiêu

- Lưu trữ key-value với SharedPreferences
- Sử dụng Hive cho complex data
- Implement caching pattern

---

## 1. SharedPreferences

Lưu trữ key-value đơn giản (settings, tokens, preferences).

### Cài đặt:
```yaml
dependencies:
  shared_preferences: ^2.2.0
```

### Các kiểu dữ liệu:
| Kiểu | Method |
|------|--------|
| String | `setString` / `getString` |
| int | `setInt` / `getInt` |
| double | `setDouble` / `getDouble` |
| bool | `setBool` / `getBool` |
| List<String> | `setStringList` / `getStringList` |

---

## 2. SharedPreferences - CRUD

```dart
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyUsername = 'username';
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyTheme = 'theme_mode';
  
  /// [CREATE/UPDATE] - Lưu giá trị
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }
  
  /// [READ] - Đọc giá trị
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
  
  /// [DELETE] - Xóa một key
  static Future<void> removeUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }
  
  /// [CLEAR] - Xóa tất cả
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  /// [CHECK] - Kiểm tra key tồn tại
  static Future<bool> hasUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUsername);
  }
}
```

---

## 3. SharedPreferences - Use Cases

### Login State:
```dart
class AuthPrefs {
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  
  static Future<void> saveLogin(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyUserId, userId);
  }
  
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyToken);
  }
  
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
  }
}
```

### Theme Preference:
```dart
enum ThemePreference { light, dark, system }

class ThemePrefs {
  static const _key = 'theme';
  
  static Future<void> save(ThemePreference theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, theme.name);
  }
  
  static Future<ThemePreference> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    
    return ThemePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemePreference.system,
    );
  }
}
```

---

## 4. Hive - NoSQL Database

Hive nhanh hơn SharedPreferences, hỗ trợ **custom objects**.

### Cài đặt:
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

### Khởi tạo (trong main):
```dart
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  /// [Hive.initFlutter] - Khởi tạo Hive cho Flutter
  await Hive.initFlutter();
  
  runApp(const MyApp());
}
```

---

## 5. Hive Box

Box là "container" lưu trữ data trong Hive.

```dart
/// [Mở Box] - Phải mở trước khi dùng
final box = await Hive.openBox('settings');

/// [Đọc] - Không cần await
final username = box.get('username');
final theme = box.get('theme', defaultValue: 'light');

/// [Ghi] - Có thể await hoặc không
await box.put('username', 'John');
box.put('theme', 'dark'); // Fire and forget

/// [Xóa]
await box.delete('username');

/// [Clear]
await box.clear();

/// [Đóng Box] - Khi không cần nữa
await box.close();
```

---

## 6. Hive với Custom Objects

### Model:
```dart
import 'package:hive/hive.dart';

/// [HiveType] - Đăng ký type với ID duy nhất
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String email;
  
  User({required this.id, required this.name, required this.email});
}
```

### Đăng ký Adapter:
```dart
void main() async {
  await Hive.initFlutter();
  
  /// [Đăng ký adapter] - Phải làm trước khi dùng type
  Hive.registerAdapter(UserAdapter());
  
  runApp(const MyApp());
}
```

### Sử dụng:
```dart
final userBox = await Hive.openBox<User>('users');

// Thêm
final user = User(id: 1, name: 'John', email: 'john@example.com');
await userBox.add(user);

// Đọc
final firstUser = userBox.getAt(0);

// Cập nhật
firstUser?.name = 'Jane';
await firstUser?.save();

// Xóa
await userBox.deleteAt(0);
```

---

## 7. Caching API Responses

```dart
class CachedApiService {
  static const _cacheKey = 'users_cache';
  static const _cacheTimeKey = 'users_cache_time';
  static const _cacheDuration = Duration(minutes: 5);
  
  /// Lấy users với cache
  Future<List<User>> getUsers() async {
    // 1. Check cache
    final cached = await _getCachedUsers();
    if (cached != null) {
      return cached;
    }
    
    // 2. Fetch from API
    final users = await _fetchFromApi();
    
    // 3. Save to cache
    await _cacheUsers(users);
    
    return users;
  }
  
  Future<List<User>?> _getCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if cache exists
    final cachedJson = prefs.getString(_cacheKey);
    if (cachedJson == null) return null;
    
    // Check if cache expired
    final cacheTime = prefs.getInt(_cacheTimeKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - cacheTime > _cacheDuration.inMilliseconds) {
      // Cache expired
      return null;
    }
    
    // Parse cache
    final list = jsonDecode(cachedJson) as List;
    return list.map((json) => User.fromJson(json)).toList();
  }
  
  Future<void> _cacheUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    
    final json = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_cacheKey, json);
    await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  Future<List<User>> _fetchFromApi() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch users');
  }
}
```

---

## 8. Offline First Pattern

```dart
class OfflineFirstRepository {
  final Box<User> _userBox;
  final http.Client _client;
  
  OfflineFirstRepository(this._userBox, this._client);
  
  Future<List<User>> getUsers() async {
    try {
      // 1. Try to fetch from API
      final users = await _fetchFromApi();
      
      // 2. Save to local storage
      await _userBox.clear();
      await _userBox.addAll(users);
      
      return users;
    } catch (e) {
      // 3. If offline, return cached data
      if (_userBox.isNotEmpty) {
        return _userBox.values.toList();
      }
      rethrow;
    }
  }
  
  Future<List<User>> _fetchFromApi() async {
    final response = await _client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch');
  }
}
```

---

## 9. Best Practices

| Practice | Mô tả |
|----------|-------|
| Keys constants | Định nghĩa keys ở một chỗ |
| Service class | Wrap storage logic |
| Type-safe | Dùng generics |
| Cache expiry | Đặt thời hạn cache |
| Error handling | Try-catch storage ops |
| Init early | Khởi tạo trong main |

---

## 10. So Sánh

| Feature | SharedPreferences | Hive |
|---------|-------------------|------|
| Setup | Simple | More setup |
| Speed | Slower | Much faster |
| Data types | Primitive only | Custom objects |
| Use case | Settings, tokens | Cache, offline |
| Web support | ✅ | ✅ |

---

## Tóm Tắt

1. **SharedPreferences** = Key-value đơn giản (settings)
2. **Hive** = NoSQL database nhanh (complex data)
3. **Cache pattern** = Check cache → Fetch API → Save cache
4. **Offline first** = Try API → Fallback to cache

---

## Bài Tiếp Theo

➡️ [Lesson 7: Practice Projects](lesson_07_practice.md)
