/// EXERCISE 15: EITHER / RESULT PATTERN
/// [Either] - Một monad biểu thị giá trị thuộc loại [L] (trái) hoặc giá trị thuộc loại [R] (phải).
/// [Left] - Biểu thị giá trị bên trái của một [Either].
/// [Right] - Biểu thị giá trị bên phải của một [Either].
/// [Failure] - Base class for all failures.

library;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

/// [Failure] - Base class
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// [NetworkFailure] - Biểu thị lỗi mạng.
class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

/// [NotFoundFailure] - Biểu thị lỗi không tìm thấy.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// [ValidationFailure] - Biểu thị lỗi xác thực.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// [User] - Model user.
class User {
  final int id;
  final String name;
  final String email;
  const User({required this.id, required this.name, required this.email});
}

/// Repository với Either return type
class UserRepository {
  final List<User> _users = [
    User(id: 1, name: 'Alice', email: 'alice@example.com'),
    User(id: 2, name: 'Bob', email: 'bob@example.com'),
  ];
  int _nextId = 3;

  /// [getUserById] - Get user by id.
  Future<Either<Failure, User>> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate network failure
    if (id == 999) return const Left(NetworkFailure());

    // Tìm người dùng
    final user = _users.where((u) => u.id == id).firstOrNull;

    // Trả về người dùng hoặc lỗi không tìm thấy
    if (user == null) return Left(NotFoundFailure('User $id not found'));
    return Right(user);
  }

  /// [getAllUsers] - Get all users.
  Future<Either<Failure, List<User>>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(List.from(_users));
  }

  /// [createUser] - Create a new user.
  Future<Either<Failure, User>> createUser(String name, String email) async {
    // Validate user data
    if (name.trim().isEmpty) return const Left(ValidationFailure('Name empty'));
    if (!email.contains('@')) {
      return const Left(ValidationFailure('Invalid email'));
    }

    // Tạo người dùng
    final user = User(id: _nextId++, name: name, email: email);
    _users.add(user);
    return Right(user);
  }
}

class Ex15EitherResult extends StatefulWidget {
  const Ex15EitherResult({super.key});
  @override
  State<Ex15EitherResult> createState() => _Ex15EitherResultState();
}

class _Ex15EitherResultState extends State<Ex15EitherResult> {
  final _repo = UserRepository(); // Khởi tạo repository
  List<User>? _users; // Danh sách người dùng
  Failure? _failure; // Lỗi
  bool _isLoading = false; // Đang tải
  final _nameCtrl = TextEditingController(); // Controller cho tên
  final _emailCtrl = TextEditingController(); // Controller cho email

  /// [loadUsers] - Load all users.
  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _failure = null;
    });

    // Gọi repository lấy danh sách người dùng
    final result = await _repo.getAllUsers();

    // Xử lý kết quả
    // fold() nhận 2 tham số: hàm xử lý lỗi (left) và hàm xử lý thành công (right)
    // Nếu result là Left(f) -> gọi hàm xử lý lỗi
    // Nếu result là Right(u) -> gọi hàm xử lý thành công
    result.fold(
      (f) => setState(() => _failure = f), // Xử lý lỗi
      (u) => setState(() => _users = u), // Xử lý thành công
    );
    setState(() => _isLoading = false);
  }

  /// [createUser] - Create a new user.
  Future<void> _createUser() async {
    setState(() {
      _isLoading = true;
      _failure = null;
    });

    // Gọi repository tạo người dùng
    final result = await _repo.createUser(_nameCtrl.text, _emailCtrl.text);

    // Xử lý kết quả
    // fold() nhận 2 tham số: hàm xử lý lỗi (left) và hàm xử lý thành công (right)
    // Nếu result là Left(f) -> gọi hàm xử lý lỗi
    // Nếu result là Right(_) -> gọi hàm xử lý thành công
    result.fold((f) => setState(() => _failure = f), (_) {
      _nameCtrl.clear();
      _emailCtrl.clear();
      _loadUsers();
    });
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex15: Either/Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.indigo,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '💡 Either<Failure, Success>\nLeft = Error, Right = Success',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Load users
            ElevatedButton(
              onPressed: _loadUsers,
              child: const Text('Load Users'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),

            // Create user
            ElevatedButton(onPressed: _createUser, child: const Text('Create')),
            const SizedBox(height: 8),

            // Loading indicator
            if (_isLoading) const LinearProgressIndicator(),
            
            if (_failure != null)
              Text(
                'Error: ${_failure!.message}',
                style: const TextStyle(color: Colors.red),
              ),
            if (_users != null)
              Expanded(
                child: ListView(
                  children: _users!
                      .map(
                        (u) => ListTile(
                          title: Text(u.name),
                          subtitle: Text(u.email),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
