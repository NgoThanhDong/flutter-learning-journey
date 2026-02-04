# Lesson 5: Error Handling 🛡️

## Mục Tiêu

- Hiểu vấn đề với Exceptions
- Either pattern (Left = Error, Right = Success)
- Custom Failure classes
- Error handling xuyên suốt layers

---

## Vấn Đề với Exceptions

### ❌ Exceptions có vấn đề:
```dart
Future<User> getUser(int id) async {
  final response = await dio.get('/users/$id');
  if (response.statusCode != 200) {
    throw Exception('Failed'); // Ai catch? Catch ở đâu?
  }
  return User.fromJson(response.data);
}

// Caller phải nhớ try-catch
void loadUser() async {
  try {
    final user = await getUser(1);
  } catch (e) {
    // Dễ quên try-catch
    // Không biết exception nào sẽ throw
  }
}
```

**Vấn đề:**
1. Compiler không bắt buộc handle
2. Không biết function throw gì
3. Exception là side effect, khó test

---

## Either Pattern

**Either** = Union type chứa 1 trong 2 giá trị:
- **Left** = Failure/Error
- **Right** = Success

```dart
/// Either<Failure, User>
/// - Left(Failure) = Có lỗi
/// - Right(User) = Thành công
```

### Cài đặt fpdart:
```yaml
dependencies:
  fpdart: ^1.1.0
```

### Sử dụng Either:
```dart
import 'package:fpdart/fpdart.dart';

/// [Định nghĩa return type rõ ràng]
Future<Either<Failure, User>> getUser(int id) async {
  try {
    final response = await dio.get('/users/$id');
    final user = User.fromJson(response.data);
    return Right(user); // Success
  } on DioException catch (e) {
    return Left(ServerFailure(e.message)); // Error
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}
```

### Xử lý Either:
```dart
void loadUser() async {
  final result = await getUser(1);
  
  /// [fold] - Xử lý cả 2 case
  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (user) => print('User: ${user.name}'),
  );
  
  /// [getOrElse] - Lấy giá trị hoặc default
  final user = result.getOrElse((failure) => User.empty());
  
  /// [isRight] / [isLeft] - Check type
  if (result.isRight()) {
    final user = result.getRight().getOrElse(() => User.empty());
  }
}
```

---

## Failure Classes

```dart
/// [Base Failure class]
abstract class Failure {
  final String message;
  final String? code;
  
  const Failure(this.message, {this.code});
}

/// [Server Failure] - Lỗi từ API
class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure(super.message, {this.statusCode, super.code});
  
  factory ServerFailure.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ServerFailure('Bad request', statusCode: 400);
      case 401:
        return ServerFailure('Unauthorized', statusCode: 401, code: 'AUTH_ERROR');
      case 403:
        return ServerFailure('Forbidden', statusCode: 403);
      case 404:
        return ServerFailure('Not found', statusCode: 404);
      case 500:
        return ServerFailure('Server error', statusCode: 500);
      default:
        return ServerFailure('Unknown error', statusCode: statusCode);
    }
  }
}

/// [Network Failure] - Không có mạng
class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

/// [Cache Failure] - Lỗi local storage
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// [Validation Failure] - Lỗi validation
class ValidationFailure extends Failure {
  final Map<String, String> errors;
  
  const ValidationFailure(super.message, {this.errors = const {}});
}
```

---

## Repository với Either

```dart
abstract class UserRepository {
  Future<Either<Failure, User>> getUserById(int id);
  Future<Either<Failure, List<User>>> getAllUsers();
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, User>> getUserById(int id) async {
    // 1. Check network
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    // 2. Try fetch
    try {
      final model = await remoteDataSource.getUserById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromStatusCode(
        e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## Use Case với Either

```dart
class GetUserUseCase {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  /// Return type rõ ràng: Either<Failure, User>
  Future<Either<Failure, User>> call(int userId) {
    return repository.getUserById(userId);
  }
}
```

---

## ViewModel với Either

```dart
class UserDetailViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  
  UserDetailViewModel(this.getUserUseCase);
  
  User? _user;
  Failure? _failure;
  bool _isLoading = false;
  
  User? get user => _user;
  Failure? get failure => _failure;
  bool get isLoading => _isLoading;
  bool get hasError => _failure != null;
  
  Future<void> loadUser(int id) async {
    _isLoading = true;
    _failure = null;
    notifyListeners();
    
    final result = await getUserUseCase(id);
    
    result.fold(
      (failure) => _failure = failure,
      (user) => _user = user,
    );
    
    _isLoading = false;
    notifyListeners();
  }
}
```

---

## UI Error Display

```dart
class UserDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (vm.hasError) {
          return _buildErrorWidget(vm.failure!);
        }
        
        return UserDetailContent(user: vm.user!);
      },
    );
  }
  
  Widget _buildErrorWidget(Failure failure) {
    /// [Map Failure → UI]
    String message;
    IconData icon;
    
    if (failure is NetworkFailure) {
      message = 'Không có kết nối mạng';
      icon = Icons.wifi_off;
    } else if (failure is ServerFailure && failure.statusCode == 404) {
      message = 'Không tìm thấy người dùng';
      icon = Icons.person_off;
    } else {
      message = failure.message;
      icon = Icons.error;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(message),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<UserDetailViewModel>().loadUser(1),
            child: Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
```

---

## TaskEither (Bonus)

`TaskEither` cho lazy evaluation:

```dart
/// [TaskEither] - Lazy Either
TaskEither<Failure, User> getUser(int id) {
  return TaskEither.tryCatch(
    () async {
      final response = await dio.get('/users/$id');
      return User.fromJson(response.data);
    },
    (error, stackTrace) => ServerFailure(error.toString()),
  );
}

// Sử dụng:
final result = await getUser(1).run();
```

---

## Best Practices

1. **Domain layer return Either**, không throw
2. **Failure classes có message rõ ràng**
3. **Map Failure → user-friendly message ở UI**
4. **Log original error ở repository**
5. **Retry logic ở repository hoặc use case**

---

## Bài Tập Liên Quan

- `ex15_either_result.dart` - Implement Either pattern
- `ex16_failure_classes.dart` - Custom Failure classes

---

## Bài Tiếp Theo

➡️ [Lesson 6: Practice Projects](lesson_06_practice.md)
