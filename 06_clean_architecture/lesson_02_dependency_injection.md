# Lesson 2: Dependency Injection 💉

## Mục Tiêu

- Hiểu Dependency Injection (DI) là gì
- Tại sao cần DI trong Flutter
- Sử dụng get_it package
- Các pattern: Singleton, Factory, Lazy

---

## Dependency Injection là gì?

DI = Truyền dependencies từ bên ngoài vào, thay vì tạo bên trong.

### ❌ Không dùng DI:
```dart
class UserScreen extends StatelessWidget {
  /// Tạo trực tiếp bên trong - TIGHT COUPLING
  final userRepo = UserRepository();
  final authService = AuthService();
  
  // Vấn đề:
  // 1. Khó test (không thể mock)
  // 2. Khó thay đổi implementation
  // 3. Mỗi instance tạo dependencies mới
}
```

### ✅ Dùng DI:
```dart
class UserScreen extends StatelessWidget {
  /// Nhận từ bên ngoài - LOOSE COUPLING
  final UserRepository userRepo;
  final AuthService authService;
  
  UserScreen({
    required this.userRepo,
    required this.authService,
  });
  
  // Lợi ích:
  // 1. Dễ test (inject mock)
  // 2. Dễ swap implementation
  // 3. Control lifecycle
}
```

---

## Các Loại Dependency Injection

| Loại | Mô tả | Ví dụ |
|------|-------|-------|
| **Constructor Injection** | Truyền qua constructor | `MyClass(this.dependency)` |
| **Property Injection** | Set qua property | `obj.dependency = dep` |
| **Service Locator** | Lấy từ container | `getIt<Dependency>()` |

---

## get_it Package

`get_it` là Service Locator phổ biến nhất trong Flutter.

### Cài đặt:
```yaml
dependencies:
  get_it: ^8.0.0
```

### Setup cơ bản:
```dart
import 'package:get_it/get_it.dart';

/// [GetIt.instance] - Container toàn cục
/// [sl] = service locator (convention)
final sl = GetIt.instance;

/// [Setup function] - Gọi 1 lần trong main()
void setupDependencies() {
  // Đăng ký dependencies ở đây
}

void main() {
  setupDependencies();
  runApp(MyApp());
}
```

---

## Các Cách Đăng Ký

### 1. registerSingleton
```dart
/// [Singleton] - Tạo ngay, dùng chung 1 instance
/// Use case: Services cần khởi tạo sớm
sl.registerSingleton<ApiClient>(ApiClient());

// Lấy ra:
final api = sl<ApiClient>(); // Luôn cùng instance
```

### 2. registerLazySingleton
```dart
/// [Lazy Singleton] - Tạo khi cần, dùng chung 1 instance
/// Use case: Services nặng, có thể không dùng
sl.registerLazySingleton<Database>(() => Database());

// Instance chỉ được tạo khi gọi lần đầu:
final db = sl<Database>();
```

### 3. registerFactory
```dart
/// [Factory] - Tạo instance mới mỗi lần gọi
/// Use case: ViewModels, objects cần fresh state
sl.registerFactory<UserViewModel>(() => UserViewModel());

// Mỗi lần gọi = instance mới:
final vm1 = sl<UserViewModel>();
final vm2 = sl<UserViewModel>();
// vm1 != vm2
```

### 4. registerFactoryParam
```dart
/// [Factory with params] - Tạo mới với tham số
sl.registerFactoryParam<UserDetailVM, int, void>(
  (userId, _) => UserDetailVM(userId),
);

// Sử dụng:
final vm = sl<UserDetailVM>(param1: 123);
```

---

## Dependency Graph - mô tả mối quan hệ giữa các dependencies

```dart
void setupDependencies() {
  // 1. External services (bottom layer)
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  
  // 2. Data sources
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl<Dio>()),
  );
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorage(sl<SharedPreferences>()),
  );
  
  // 3. Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      apiClient: sl<ApiClient>(),
      localStorage: sl<LocalStorage>(),
    ),
  );
  
  // 4. Use cases
  sl.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(sl<UserRepository>()),
  );
  
  // 5. ViewModels (factory - new instance each time)
  sl.registerFactory<UserViewModel>(
    () => UserViewModel(sl<GetUserUseCase>()),
  );
}
```

---

## Reset và Dispose - mục đích là cleanup

```dart
/// [Reset] - Xóa tất cả registrations
await sl.reset();

/// [ResetLazySingleton] - Reset 1 lazy singleton cụ thể
sl.resetLazySingleton<Database>();

/// [Dispose callback] - Cleanup khi dispose
sl.registerLazySingleton<Database>(
  () => Database(),
  dispose: (db) => db.close(), // Được gọi khi reset
);
```

---

## DI trong Widget - mục đích là lấy dependency từ service locator

```dart
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Lấy dependency từ service locator
    final userRepo = sl<UserRepository>();
    
    return FutureBuilder(
      future: userRepo.getUser(1),
      builder: (context, snapshot) { ... },
    );
  }
}
```

### Hoặc dùng với StatefulWidget:
```dart
class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final UserViewModel viewModel;
  
  @override
  void initState() {
    super.initState();
    viewModel = sl<UserViewModel>();
  }
  
  @override
  Widget build(BuildContext context) { ... }
}
```

---

## get_it vs Provider/Riverpod

| Khía cạnh | get_it | Provider/Riverpod |
|-----------|--------|-------------------|
| Mục đích | Service Locator | State Management + DI |
| Lifecycle | Manual | Tied to widget tree |
| Testing | Mock bằng reset/register | Override trong test |
| Complexity | Simple | More features |
| Use case | Services, Repos | UI State |

**Thực tế**: Nhiều dự án dùng cả hai:
- `get_it` cho services/repositories
- `Provider/Riverpod` cho UI state

---

## Best Practices

1. **Đăng ký theo thứ tự**: Dependencies → Dependents
2. **Dùng Lazy cho heavy objects**
3. **Factory cho ViewModels**
4. **Abstract types**: Register interface, not implementation
5. **Dispose cleanup**: Đăng ký dispose callback

---

## Bài Tập Liên Quan

- `ex06_manual_di.dart` - Constructor Injection thủ công
- `ex07_get_it_basic.dart` - Đăng ký và sử dụng get_it
- `ex08_get_it_lazy.dart` - Lazy registration và dispose

---

## Bài Tiếp Theo

➡️ [Lesson 3: Repository Pattern](lesson_03_repository_pattern.md)
