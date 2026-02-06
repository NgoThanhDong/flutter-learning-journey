# Lesson 4: Layer Architecture 🏛️

## Mục Tiêu

- Hiểu 3 layers trong Clean Architecture
- Phân biệt Entity, Model, DTO
- Use Cases và business logic
- Presentation layer patterns

---

## 3 Layers trong Clean Architecture

```
┌───────────────────────────────────────────────────┐
│              PRESENTATION LAYER                   │
│  ┌──────────┐  ┌────────────┐  ┌───────────────┐  │
│  │ Widgets  │  │ ViewModels │  │ BLoC/Cubit    │  │
│  └──────────┘  └────────────┘  └───────────────┘  │
├───────────────────────────────────────────────────┤
│                DOMAIN LAYER                       │
│  ┌──────────┐  ┌────────────┐  ┌────────────────┐ │
│  │ Entities │  │ Use Cases  │  │ Repo Interfaces│ │
│  └──────────┘  └────────────┘  └────────────────┘ │
├───────────────────────────────────────────────────┤
│                 DATA LAYER                        │
│  ┌──────────┐  ┌────────────┐  ┌─────────────┐    │
│  │  Models  │  │Data Sources│  │ Repo Impls  │    │
│  └──────────┘  └────────────┘  └─────────────┘    │
└───────────────────────────────────────────────────┘
```

---

## 1. Domain Layer (Core) <= Lớp nghiệp vụ

**Trung tâm của ứng dụng**, không phụ thuộc gì cả.

### Entities
```dart
/// [Entity] - Pure Dart class, business object
/// - Không có fromJson/toJson
/// - Dùng equatable cho value equality
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final UserStatus status;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
  });
  
  /// [props] - Để so sánh equality
  @override
  List<Object?> get props => [id, name, email, status];
  
  /// [Business methods] có thể ở đây
  bool get isActive => status == UserStatus.active;
}

enum UserStatus { active, inactive, banned }
```

### Use Cases
```dart
/// [Use Case] = 1 business action
/// - Single Responsibility
/// - Dễ test
/// - Reusable
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// [GetUserUseCase] - Lấy user theo ID
class GetUserUseCase implements UseCase<User, int> {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  @override
  Future<User> call(int userId) {
    return repository.getUserById(userId);
  }
}

/// [CreateUserUseCase] - Tạo user mới
class CreateUserUseCase implements UseCase<User, CreateUserParams> {
  final UserRepository repository;
  final EmailValidator emailValidator;
  
  CreateUserUseCase(this.repository, this.emailValidator);
  
  @override
  Future<User> call(CreateUserParams params) {
    // Business logic ở đây
    if (!emailValidator.isValid(params.email)) {
      throw InvalidEmailException();
    }
    return repository.createUser(params);
  }
}

/// [Params class] khi cần nhiều tham số
class CreateUserParams {
  final String name;
  final String email;
  
  const CreateUserParams({required this.name, required this.email});
}
```

### Repository Interfaces
```dart
/// [Abstract Repository] - Contract
/// Domain layer định nghĩa interface,
/// Data layer implement
abstract class UserRepository {
  Future<User> getUserById(int id);
  Future<List<User>> getAllUsers();
  Future<User> createUser(CreateUserParams params);
  Future<void> deleteUser(int id);
}
```

---

## 2. Data Layer <= Lớp dữ liệu

**Xử lý data từ external sources (API, Database, Shared Preferences, v.v.)**.

### Models
```dart
/// [Model] = Entity + Serialization
class UserModel {
  final int id;
  final String name;
  final String email;
  final String status;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
  });
  
  /// [fromJson] - Parse từ API response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
    );
  }
  
  /// [toJson] - Serialize để gửi API
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'status': status,
  };
  
  /// [toEntity] - Convert sang Domain Entity
  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    status: _parseStatus(status),
  );
  
  /// [fromEntity] - Convert từ Domain Entity
  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    name: user.name,
    email: user.email,
    status: user.status.name,
  );
  
  UserStatus _parseStatus(String status) {
    return UserStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => UserStatus.inactive,
    );
  }
}
```

### Data Sources 
```dart
/// [Remote Data Source]
abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(int id);
  Future<List<UserModel>> getAllUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  
  UserRemoteDataSourceImpl(this.dio);
  
  @override
  Future<UserModel> getUserById(int id) async {
    final response = await dio.get('/users/$id');
    return UserModel.fromJson(response.data);
  }
  
  @override
  Future<List<UserModel>> getAllUsers() async {
    final response = await dio.get('/users');
    return (response.data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }
}
```

### Repository Implementation
```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  
  UserRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<User> getUserById(int id) async {
    final model = await remoteDataSource.getUserById(id);
    return model.toEntity(); // Model → Entity
  }
  
  @override
  Future<List<User>> getAllUsers() async {
    final models = await remoteDataSource.getAllUsers();
    return models.map((m) => m.toEntity()).toList();
  }
}
```

---

## 3. Presentation Layer <= Lớp trình bày

**UI và State Management**.

### ViewModel Pattern
```dart
/// [ViewModel] - Quản lý UI state
class UserListViewModel extends ChangeNotifier {
  final GetAllUsersUseCase getAllUsers;
  
  UserListViewModel(this.getAllUsers);
  
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _users = await getAllUsers(NoParams());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### Widget sử dụng ViewModel
```dart
class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<UserListViewModel>()..loadUsers(),
      child: Consumer<UserListViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return CircularProgressIndicator();
          }
          if (viewModel.error != null) {
            return Text('Error: ${viewModel.error}');
          }
          return ListView.builder(
            itemCount: viewModel.users.length,
            itemBuilder: (_, i) => UserTile(viewModel.users[i]),
          );
        },
      ),
    );
  }
}
```

---

## Directory Structure theo Layers <= Cấu trúc thư mục theo lớp

```
lib/
├── core/                    # Shared utilities
│   ├── error/
│   ├── usecases/
│   └── utils/
│
├── features/
│   └── user/
│       ├── data/            # DATA LAYER
│       │   ├── datasources/
│       │   │   ├── user_local_datasource.dart
│       │   │   └── user_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── user_repository_impl.dart
│       │
│       ├── domain/          # DOMAIN LAYER
│       │   ├── entities/
│       │   │   └── user.dart
│       │   ├── repositories/
│       │   │   └── user_repository.dart
│       │   └── usecases/
│       │       ├── get_user.dart
│       │       └── create_user.dart
│       │
│       └── presentation/    # PRESENTATION LAYER
│           ├── pages/
│           │   ├── user_list_page.dart
│           │   └── user_detail_page.dart
│           ├── widgets/
│           │   └── user_tile.dart
│           └── viewmodels/
│               └── user_list_viewmodel.dart
│
└── injection_container.dart  # DI setup
```

---

## Dependency Rule <= Quy tắc phụ thuộc

> **Inner layers KHÔNG biết outer layers**

```
Presentation → Domain → Data
      ↑           ↑
      │           │
      └───────────┘
   Chỉ phụ thuộc vào trong
```

- Domain KHÔNG import Presentation hay Data
- Data implement Domain interfaces
- Presentation sử dụng Domain Use Cases

---

## Bài Tập Liên Quan

- `ex12_domain_entities.dart` - Tạo Entities với Equatable
- `ex13_use_cases.dart` - Implement Use Cases
- `ex14_presentation_viewmodel.dart` - ViewModel pattern

---

## Bài Tiếp Theo

➡️ [Lesson 5: Error Handling](lesson_05_error_handling.md)
