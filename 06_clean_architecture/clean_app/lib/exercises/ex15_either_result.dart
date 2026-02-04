/// EXERCISE 15: EITHER / RESULT PATTERN
library;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

/// [Failure] - Base class
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

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

  Future<Either<Failure, User>> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (id == 999) return const Left(NetworkFailure());
    final user = _users.where((u) => u.id == id).firstOrNull;
    if (user == null) return Left(NotFoundFailure('User $id not found'));
    return Right(user);
  }

  Future<Either<Failure, List<User>>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(List.from(_users));
  }

  Future<Either<Failure, User>> createUser(String name, String email) async {
    if (name.trim().isEmpty) return const Left(ValidationFailure('Name empty'));
    if (!email.contains('@')) {
      return const Left(ValidationFailure('Invalid email'));
    }
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
  final _repo = UserRepository();
  List<User>? _users;
  Failure? _failure;
  bool _isLoading = false;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _failure = null;
    });
    final result = await _repo.getAllUsers();
    result.fold(
      (f) => setState(() => _failure = f),
      (u) => setState(() => _users = u),
    );
    setState(() => _isLoading = false);
  }

  Future<void> _createUser() async {
    setState(() {
      _isLoading = true;
      _failure = null;
    });
    final result = await _repo.createUser(_nameCtrl.text, _emailCtrl.text);
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
            ElevatedButton(onPressed: _createUser, child: const Text('Create')),
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
