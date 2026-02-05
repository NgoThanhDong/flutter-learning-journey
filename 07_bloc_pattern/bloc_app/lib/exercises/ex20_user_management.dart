/// ===========================================
/// EXERCISE 20: USER MANAGEMENT (CRUD)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Ứng dụng quản lý User hoàn chỉnh
/// - Load List -> Create -> Update -> Delete
/// - Sử dụng Repository pattern
/// - Dialogs cho Create/Update
///
/// 📝 Logic:
/// - UserBloc quản lý danh sách user
/// - Các thao tác gọi xuống Repository (giả lập delay)
/// - UI lắng nghe Loading/Success/Error

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. ENTITY
class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  User copyWith({String? name, String? email}) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [id, name, email];
}

/// 2. REPOSITORY
class UserRepository {
  final List<User> _users = [
    const User(id: '1', name: 'Alice', email: 'alice@example.com'),
    const User(id: '2', name: 'Bob', email: 'bob@example.com'),
  ];

  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_users);
  }

  Future<User> addUser(String name, String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email);
    _users.add(user);
    return user;
  }

  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) _users[index] = user;
  }

  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _users.removeWhere((u) => u.id == id);
  }
}

/// 3. BLOC
// Events
sealed class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class CreateUser extends UserEvent {
  final String name;
  final String email;
  CreateUser(this.name, this.email);
}

class UpdateUser extends UserEvent {
  final User user;
  UpdateUser(this.user);
}

class DeleteUser extends UserEvent {
  final String id;
  DeleteUser(this.id);
}

// States
sealed class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc Logic
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repo;

  UserBloc(this._repo) : super(UserLoading()) {
    // Start with loading
    on<LoadUsers>(_onLoadUsers);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await _repo.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      try {
        await _repo.addUser(event.name, event.email);
        add(LoadUsers()); // Reload list
      } catch (e) {
        emit(UserError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      try {
        await _repo.updateUser(event.user);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      try {
        await _repo.deleteUser(event.id);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    }
  }
}

/// 4. UI
class Ex20UserManagement extends StatelessWidget {
  const Ex20UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => UserRepository(),
      child: BlocProvider(
        create: (context) =>
            UserBloc(context.read<UserRepository>())..add(LoadUsers()),
        child: const UserView(),
      ),
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex20: User Management CRUD')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserError) {
            return Center(
                child: Text('Error: ${state.message}',
                    style: const TextStyle(color: Colors.red)));
          }

          if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(user.name[0])),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showUserDialog(context, user: user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            context.read<UserBloc>().add(DeleteUser(user.id)),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showUserDialog(BuildContext context, {User? user}) {
    final nameParams = TextEditingController(text: user?.name ?? '');
    final emailParams = TextEditingController(text: user?.email ?? '');
    final isEditing = user != null;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEditing ? 'Edit User' : 'Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameParams,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: emailParams,
                decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Note: We use original 'context' from UserView to access BLoC
              if (isEditing) {
                context.read<UserBloc>().add(UpdateUser(user!.copyWith(
                      name: nameParams.text,
                      email: emailParams.text,
                    )));
              } else {
                context
                    .read<UserBloc>()
                    .add(CreateUser(nameParams.text, emailParams.text));
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
