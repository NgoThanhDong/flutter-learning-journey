# Lesson 05: Architecture & Dependency Injection

## 🎯 Mục Tiêu Bài Học
Sau bài này, bạn sẽ hiểu:
- Clean Architecture với BLoC
- Repository Pattern
- Dependency Injection với get_it
- RepositoryProvider
- Testing considerations

## 📚 Lý Thuyết

### 1. Clean Architecture Overview

```
┌─────────────────────────────────────┐
│           Presentation              │
│         (BLoC, Widgets)             │
├─────────────────────────────────────┤
│            Domain                   │
│    (Use Cases, Entities)            │
├─────────────────────────────────────┤
│             Data                    │
│  (Repository, DataSource)           │
└─────────────────────────────────────┘
```

### 2. Repository Pattern

```dart
// Abstract Repository (Domain layer)
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> saveUser(User user);
}

// Concrete Implementation (Data layer)
class UserRepositoryImpl implements UserRepository {
  final ApiClient _api;
  
  UserRepositoryImpl(this._api);
  
  @override
  Future<User> getUser(String id) => _api.fetchUser(id);
  
  @override
  Future<void> saveUser(User user) => _api.saveUser(user);
}
```

### 3. BLoC + Repository

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;
  
  UserBloc(this._repository) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }
  
  Future<void> _onLoadUser(LoadUser event, Emitter emit) async {
    emit(UserLoading());
    try {
      final user = await _repository.getUser(event.id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

### 4. Dependency Injection với get_it

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDI() {
  // Singleton: 1 instance cho toàn app
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  // Lazy Singleton: Tạo khi cần lần đầu
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<ApiClient>()),
  );
  
  // Factory: Tạo instance mới mỗi lần gọi
  getIt.registerFactory<UserBloc>(
    () => UserBloc(getIt<UserRepository>()),
  );
}

// Usage
void main() {
  setupDI();
  runApp(MyApp());
}

// In widget
BlocProvider(
  create: (_) => getIt<UserBloc>(),
  child: UserPage(),
)
```

### 5. RepositoryProvider

```dart
// Provide repository through widget tree
RepositoryProvider<UserRepository>(
  create: (_) => UserRepositoryImpl(ApiClient()),
  child: BlocProvider(
    create: (context) => UserBloc(
      context.read<UserRepository>(),
    ),
    child: UserPage(),
  ),
)

// Multiple repositories
MultiRepositoryProvider(
  providers: [
    RepositoryProvider(create: (_) => UserRepository()),
    RepositoryProvider(create: (_) => AuthRepository()),
  ],
  child: MyApp(),
)
```

### 6. Testing Benefits

```dart
// Mock repository for testing
class MockUserRepository implements UserRepository {
  @override
  Future<User> getUser(String id) async => User(name: 'Test');
}

// Unit test
test('loads user successfully', () async {
  final bloc = UserBloc(MockUserRepository());
  bloc.add(LoadUser('123'));
  
  await expectLater(
    bloc.stream,
    emitsInOrder([
      UserLoading(),
      isA<UserLoaded>(),
    ]),
  );
});
```

## 💻 Bài Tập Thực Hành

| Exercise | Tên | Mục tiêu |
|----------|-----|----------|
| Ex15 | Todo App | Complete CRUD với Repository |
| Ex16 | Weather App | API integration pattern |
| Ex17 | User CRUD | Full architecture demo |

## 🔑 Key Takeaways
1. Repository pattern tách biệt data và logic
2. DI giúp code testable và maintainable
3. get_it: Singleton, LazySingleton, Factory
4. RepositoryProvider cho widget tree
5. Testing dễ với mock repositories

---
**Hoàn thành Phase 7: BLoC Pattern!** 🎉
