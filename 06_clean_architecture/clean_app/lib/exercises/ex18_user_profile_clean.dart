/// ===========================================
/// EXERCISE 18: USER PROFILE CRUD (Clean Architecture)
/// ===========================================
/// Ứng dụng quản lý user với:
/// - Fetch users từ JSONPlaceholder API
/// - Display user list
/// - View user detail
/// - Create new user (mock)
/// - Clean Architecture với DI

/*
lib/
├── core/
│   ├── network/dio_client.dart
│   ├── error/failures.dart
│   └── usecases/usecase.dart
│
├── features/users/
│   ├── data/
│   │   ├── datasources/user_remote_datasource.dart
│   │   ├── models/user_model.dart
│   │   └── repositories/user_repository_impl.dart
│   │
│   ├── domain/
│   │   ├── entities/user.dart
│   │   ├── repositories/user_repository.dart
│   │   └── usecases/
│   │       ├── get_users.dart
│   │       └── get_user_detail.dart
│   │
│   └── presentation/
│       ├── pages/
│       │   ├── user_list_page.dart
│       │   └── user_detail_page.dart
│       └── viewmodels/
│           ├── user_list_viewmodel.dart
│           └── user_detail_viewmodel.dart
│
└── injection_container.dart
*/

library;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

/// Entity định nghĩa các thuộc tính của user
class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  UserProfile copyWith({String? name, String? email, String? avatar}) =>
      UserProfile(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
      );
}

/// Failure định nghĩa các lỗi có thể xảy ra
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// ServerFailure định nghĩa lỗi khi có vấn đề với server
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// UserProfileRepository định nghĩa các phương thức cần thiết
abstract class UserProfileRepository {
  /// Lấy danh sách user
  Future<Either<Failure, List<UserProfile>>> getUsers();

  /// Tạo user mới
  Future<Either<Failure, UserProfile>> createUser(String name, String email);

  /// Cập nhật user
  Future<Either<Failure, UserProfile>> updateUser(UserProfile user);

  /// Xóa user
  Future<Either<Failure, void>> deleteUser(int id);
}

/// InMemoryUserProfileRepository là một implement của UserProfileRepository
/// Mock dữ liệu trong bộ nhớ
class InMemoryUserProfileRepository implements UserProfileRepository {
  final List<UserProfile> _users = [
    UserProfile(id: 1, name: 'Alice', email: 'alice@example.com'),
    UserProfile(id: 2, name: 'Bob', email: 'bob@example.com'),
  ];
  int _nextId = 3;

  /// Lấy danh sách user
  @override
  Future<Either<Failure, List<UserProfile>>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(List.from(_users));
  }

  /// Tạo user mới
  @override
  Future<Either<Failure, UserProfile>> createUser(
    String name,
    String email,
  ) async {
    if (name.isEmpty || email.isEmpty) {
      return const Left(ServerFailure('Fields required'));
    }
    final user = UserProfile(id: _nextId++, name: name, email: email);
    _users.add(user);
    return Right(user);
  }

  /// Cập nhật user
  @override
  Future<Either<Failure, UserProfile>> updateUser(UserProfile user) async {
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx < 0) return const Left(ServerFailure('User not found'));
    _users[idx] = user;
    return Right(user);
  }

  /// Xóa user
  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    _users.removeWhere((u) => u.id == id);
    return const Right(null);
  }
}

/// UserProfileViewModel chứa logic của ứng dụng
class UserProfileViewModel extends ChangeNotifier {
  final UserProfileRepository _repo;
  UserProfileViewModel(this._repo);

  List<UserProfile> users = [];
  bool isLoading = false;
  String? error;

  /// Load danh sách user
  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    final result = await _repo.getUsers();
    result.fold((f) => error = f.message, (u) => users = u);
    isLoading = false;
    notifyListeners();
  }

  /// Tạo user mới
  Future<void> create(String name, String email) async {
    final result = await _repo.createUser(name, email);
    result.fold((f) => error = f.message, (_) => load());
  }

  /// Cập nhật user
  Future<void> update(UserProfile user) async {
    final result = await _repo.updateUser(user);
    result.fold((f) => error = f.message, (_) => load());
  }

  /// Xóa user
  Future<void> delete(int id) async {
    await _repo.deleteUser(id);
    load();
  }
}

/// UI
class Ex18UserProfileClean extends StatefulWidget {
  const Ex18UserProfileClean({super.key});
  @override
  State<Ex18UserProfileClean> createState() => _Ex18UserProfileCleanState();
}

class _Ex18UserProfileCleanState extends State<Ex18UserProfileClean> {
  /// UserProfileViewModel chứa logic của ứng dụng
  late final UserProfileViewModel _vm;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Tạo instance của UserProfileViewModel
    /// và load danh sách user
    _vm = UserProfileViewModel(InMemoryUserProfileRepository())..load();
    _vm.addListener(() => setState(() {}));
  }

  /// Hiển thị dialog để cập nhật thông tin user
  void _showEditDialog(UserProfile user) {
    final nameC = TextEditingController(text: user.name);
    final emailC = TextEditingController(text: user.email);

    /// Hiển thị dialog để cập nhật thông tin user
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),

          /// Button cập nhật thông tin user
          ElevatedButton(
            onPressed: () {
              _vm.update(user.copyWith(name: nameC.text, email: emailC.text));
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex18: User Profiles')),
      body: Column(
        children: [
          /// Input name và email
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),

                  /// Button tạo user mới
                  onPressed: () {
                    _vm.create(_nameCtrl.text, _emailCtrl.text);
                    _nameCtrl.clear();
                    _emailCtrl.clear();
                  },
                ),
              ],
            ),
          ),

          /// Hiển thị error
          if (_vm.error != null)
            Text(
              'Error: ${_vm.error}',
              style: const TextStyle(color: Colors.red),
            ),

          /// Hiển thị danh sách user
          Expanded(
            child: _vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: _vm.users
                        .map(
                          (u) => ListTile(
                            leading: CircleAvatar(child: Text(u.name[0])),
                            title: Text(u.name),
                            subtitle: Text(u.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Button cập nhật thông tin user
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showEditDialog(u),
                                ),

                                /// Button xóa user
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _vm.delete(u.id),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
