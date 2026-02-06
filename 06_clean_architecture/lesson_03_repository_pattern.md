# Lesson 3: Repository Pattern 📦

## Mục Tiêu

- Hiểu Repository Pattern (Domain Layer)
- Tách biệt Data Sources (Data Layer)
- Abstract Repository interface (Domain Layer)
- Implementation với multiple sources (Data Layer)

---

## Repository Pattern là gì?

Repository = Lớp trung gian giữa **Domain Layer** và **Data Layer**.

```
┌─────────────────┐
│   UI / BLoC     │  ← Chỉ biết Repository interface
├─────────────────┤
│   Repository    │  ← Quyết định lấy data từ đâu
├─────────────────┤
│  Data Sources   │  ← API, Local DB, Cache
└─────────────────┘
```

---

## Tại Sao Cần Repository?

| Không có Repository | Có Repository |
|--------------------|---------------|
| UI gọi trực tiếp API | UI gọi Repository |
| Khó test (mock API) | Dễ test (mock Repository) |
| Logic rải rác | Logic tập trung |
| Khó thay đổi source | Dễ swap sources |

---

## Cấu Trúc Repository

### 1. Repository Interface (Domain Layer) - mục đích là định nghĩa contract - UI/Domain chỉ biết interface này
```dart
/// [Abstract Repository]
/// Định nghĩa contract - UI/Domain chỉ biết interface này
abstract class UserRepository {
  Future<User> getUserById(int id);
  Future<List<User>> getAllUsers();
  Future<void> saveUser(User user);
  Future<void> deleteUser(int id);
}
```

### 2. Data Sources (Data Layer) - mục đích là tách biệt data sources
```dart
/// [Remote Data Source] - Gọi API
class UserRemoteDataSource {
  final Dio dio;
  
  UserRemoteDataSource(this.dio);
  
  Future<UserModel> getUserById(int id) async {
    final response = await dio.get('/users/$id');
    return UserModel.fromJson(response.data);
  }
}

/// [Local Data Source] - Local Database/Cache
class UserLocalDataSource {
  final SharedPreferences prefs;
  
  UserLocalDataSource(this.prefs);
  
  Future<UserModel?> getCachedUser(int id) async {
    final json = prefs.getString('user_$id');
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }
  
  Future<void> cacheUser(UserModel user) async {
    await prefs.setString('user_${user.id}', jsonEncode(user.toJson()));
  }
}
```

### 3. Repository Implementation (Data Layer) - mục đích là kết hợp các data sources, xử lý logic
```dart
/// [Repository Implementation]
/// Kết hợp các data sources, xử lý logic
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  
  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<User> getUserById(int id) async {
    // 1. Kiểm tra cache trước
    final cached = await localDataSource.getCachedUser(id);
    if (cached != null) {
      return cached.toEntity(); // Model → Entity
    }
    
    // 2. Nếu không có cache, gọi API
    final remote = await remoteDataSource.getUserById(id);
    
    // 3. Cache lại
    await localDataSource.cacheUser(remote);
    
    return remote.toEntity();
  }
}
```

---

## Model vs Entity

| Model (Data Layer) | Entity (Domain Layer) |
|--------------------|----------------------|
| Có `fromJson`/`toJson` | Không có serialization |
| Phụ thuộc data format | Clean, pure Dart |
| Thay đổi khi API thay đổi | Ổn định |

```dart
/// [Model] - Data Layer
class UserModel {
  final int id;
  final String fullName;
  final String emailAddress;
  
  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['full_name'],
        emailAddress = json['email_address'];
  
  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email_address': emailAddress,
      };
  
  /// Convert to Entity
  User toEntity() => User(id: id, name: fullName, email: emailAddress);
}

/// [Entity] - Domain Layer
class User {
  final int id;
  final String name;
  final String email;
  
  const User({required this.id, required this.name, required this.email});
}
```

---

## Strategies trong Repository là kỹ thuật để chọn data source (chính sách chọn data source)

### 1. Cache-First Strategy
```dart
Future<User> getUser(int id) async {
  // 1. Kiểm tra cache
  final cached = await localSource.get(id);
  if (cached != null) return cached;
  
  // 2. Gọi network
  final remote = await remoteSource.get(id);
  await localSource.cache(remote);
  return remote;
}
```

### 2. Network-First Strategy
```dart
Future<User> getUser(int id) async {
  try {
    // 1. Gọi network trước
    final remote = await remoteSource.get(id);
    await localSource.cache(remote);
    return remote;
  } catch (e) {
    // 2. Fallback sang cache
    final cached = await localSource.get(id);
    if (cached != null) return cached;
    rethrow;
  }
}
```

### 3. Stale-While-Revalidate - mục đích là khi có cache thì trả về ngay, không cần đợi network
```dart
Stream<User> getUser(int id) async* {
  // 1. Trả về cache ngay (stale)
  final cached = await localSource.get(id);
  if (cached != null) yield cached;
  
  // 2. Fetch fresh data (revalidate)
  final remote = await remoteSource.get(id);
  await localSource.cache(remote);
  yield remote;
}
```

---

## Đăng Ký với get_it (Dependency Injection)

```dart
void setupDependencies() {
  // Data Sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(sl<SharedPreferences>()),
  );
  
  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserRemoteDataSource>(),
      localDataSource: sl<UserLocalDataSource>(),
    ),
  );
}
```

---

## Testing Repository - mục đích để mock data source

```dart
/// [Mock Data Source]
class MockUserRemoteDataSource implements UserRemoteDataSource {
  @override
  Future<UserModel> getUserById(int id) async {
    return UserModel(id: id, fullName: 'Test', emailAddress: 'test@test.com');
  }
}

/// [Test]
void main() {
  test('getUserById returns user from remote', () async {
    final repo = UserRepositoryImpl(
      remoteDataSource: MockUserRemoteDataSource(),
      localDataSource: MockUserLocalDataSource(),
    );
    
    final user = await repo.getUserById(1);
    
    expect(user.name, 'Test');
  });
}
```

---

## Best Practices

1. **Interface ở Domain layer**: UI/Use Cases chỉ biết interface
2. **Implementation ở Data layer**: Details ở đây
3. **Model ↔ Entity mapping**: Trong repository
4. **Error handling**: Repository catch và wrap errors
5. **Testing**: Mock data sources

---

## Bài Tập Liên Quan

- `ex09_repository_interface.dart` - Tạo abstract repository
- `ex10_local_remote_source.dart` - Implement data sources
- `ex11_repository_impl.dart` - Implement repository với cache

---

## Bài Tiếp Theo

➡️ [Lesson 4: Layers](lesson_04_layers.md)
