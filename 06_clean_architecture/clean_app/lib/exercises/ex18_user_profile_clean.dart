/// EXERCISE 18: USER PROFILE CRUD (Clean Architecture)
library;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

/// Entity
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

/// Failure
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Repository
abstract class UserProfileRepository {
  Future<Either<Failure, List<UserProfile>>> getUsers();
  Future<Either<Failure, UserProfile>> createUser(String name, String email);
  Future<Either<Failure, UserProfile>> updateUser(UserProfile user);
  Future<Either<Failure, void>> deleteUser(int id);
}

class InMemoryUserProfileRepository implements UserProfileRepository {
  final List<UserProfile> _users = [
    UserProfile(id: 1, name: 'Alice', email: 'alice@example.com'),
    UserProfile(id: 2, name: 'Bob', email: 'bob@example.com'),
  ];
  int _nextId = 3;

  @override
  Future<Either<Failure, List<UserProfile>>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(List.from(_users));
  }

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

  @override
  Future<Either<Failure, UserProfile>> updateUser(UserProfile user) async {
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx < 0) return const Left(ServerFailure('User not found'));
    _users[idx] = user;
    return Right(user);
  }

  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    _users.removeWhere((u) => u.id == id);
    return const Right(null);
  }
}

/// ViewModel
class UserProfileViewModel extends ChangeNotifier {
  final UserProfileRepository _repo;
  UserProfileViewModel(this._repo);

  List<UserProfile> users = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    final result = await _repo.getUsers();
    result.fold((f) => error = f.message, (u) => users = u);
    isLoading = false;
    notifyListeners();
  }

  Future<void> create(String name, String email) async {
    final result = await _repo.createUser(name, email);
    result.fold((f) => error = f.message, (_) => load());
  }

  Future<void> update(UserProfile user) async {
    final result = await _repo.updateUser(user);
    result.fold((f) => error = f.message, (_) => load());
  }

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
  late final UserProfileViewModel _vm;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = UserProfileViewModel(InMemoryUserProfileRepository())..load();
    _vm.addListener(() => setState(() {}));
  }

  void _showEditDialog(UserProfile user) {
    final nameC = TextEditingController(text: user.name);
    final emailC = TextEditingController(text: user.email);
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
                  onPressed: () {
                    _vm.create(_nameCtrl.text, _emailCtrl.text);
                    _nameCtrl.clear();
                    _emailCtrl.clear();
                  },
                ),
              ],
            ),
          ),
          if (_vm.error != null)
            Text(
              'Error: ${_vm.error}',
              style: const TextStyle(color: Colors.red),
            ),
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
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showEditDialog(u),
                                ),
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
