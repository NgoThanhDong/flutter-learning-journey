# Lesson 05: BLoC Architecture & DI

Trong Phase 6, ta đã học về Clean Architecture. Bài này sẽ kết hợp BLoC vào kiến trúc đó.

## 1. Vị trí của BLoC

Trong mô hình Layer:
- **Presentation Layer**: UI (Widgets) + BLoC/Cubit.
- **Domain Layer**: Use Cases + Entities.
- **Data Layer**: Repositories + Data Sources.

-> **BLoC đóng vai trò là cầu nối** giữa UI và Domain/Data.
- UI gửi Event -> BLoC.
- BLoC gọi Repository để lấy dữ liệu.
- BLoC emit State -> UI update.

## 2. RepositoryProvider

`flutter_bloc` cung cấp `RepositoryProvider` để đưa dependency (Repository) vào cây Widget, giống như `BlocProvider`.

```dart
RepositoryProvider(
  create: (context) => UserRepository(),
  child: BlocProvider(
    create: (context) => UserBloc(repository: context.read<UserRepository>()),
    child: UserPage(),
  ),
)
```

## 3. Dependency Injection (get_it)

Thay vì dùng `RepositoryProvider`, ta có thể dùng `get_it` (Service Locator) để inject Repository vào BLoC. Cách này linh hoạt hơn và tách biệt dependency khỏi Widget Tree.

```dart
// 1. Setup locator
final getIt = GetIt.instance;
void setup() {
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
}

// 2. Inject vào Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repo;
  
  UserBloc({UserRepository? repo}) 
      : _repo = repo ?? getIt<UserRepository>(), // Auto inject nếu không truyền
        super(Initial());
}
```

---

## 4. Bài tập thực hành

### Ex13: Repository Integration
- **File**: `exercises/ex13_repository_integration.dart`
- **Mục tiêu**: Kết nối BLoC với một Repository giả lập.
- Sử dụng `RepositoryProvider` để cung cấp Repo cho BLoC.

### Ex14: API Handling (Networking)
- **File**: `exercises/ex14_api_handling.dart`
- **Mục tiêu**: Xử lý các trạng thái mạng (Loading, Success, Error).
- Mô phỏng gọi API lấy danh sách sản phẩm.
- Try-catch block trong BLoC để bắt lỗi và emit Error state.

### Ex15: Dependency Injection with get_it
- **File**: `exercises/ex15_dependency_injection.dart`
- **Mục tiêu**: Sử dụng `get_it` để inject Repository thay vì `RepositoryProvider`.
- Đây là cách tiếp cận phổ biến trong Clean Architecture.
