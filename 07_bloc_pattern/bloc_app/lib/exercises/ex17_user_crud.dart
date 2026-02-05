/// ============================================================================
/// EXERCISE 17: USER CRUD WITH DEPENDENCY INJECTION
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Complete CRUD với BLoC
/// - Dependency Injection với get_it
/// - Repository pattern
/// - Real-world architecture demo
///
/// 📝 ARCHITECTURE:
/// main() → setupDI() → `getIt<UserBloc>`
/// ↓
/// UserBloc → UserRepository → DataSource (simulated)
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

// ============================================================================
// DEPENDENCY INJECTION SETUP
// ============================================================================
//
// get_it: Simple service locator for Dart/Flutter
//
// Registration types:
// - registerSingleton: 1 instance tồn tại suốt app lifetime
// - registerLazySingleton: Tạo khi gọi lần đầu, sau đó reuse
// - registerFactory: Tạo instance mới mỗi lần gọi
// ============================================================================
final getIt = GetIt.instance;

void setupDependencies() {
  // Repository: Lazy singleton (tạo khi cần, reuse sau đó)
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  // BLoC: Factory (mỗi lần cần là tạo mới)
  getIt.registerFactory<UserBloc>(
      () => UserBloc(repository: getIt<UserRepository>()));
}

// ============================================================================
// USER MODEL
// ============================================================================
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  User copyWith({String? name, String? email}) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt,
    );
  }

  @override
  List<Object> get props => [id, name, email, createdAt];
}

// ============================================================================
// REPOSITORY (ABSTRACT + IMPL)
// ============================================================================
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> addUser(String name, String email);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  // In-memory storage (simulated database)
  final List<User> _users = [];

  @override
  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_users);
  }

  @override
  Future<void> addUser(String name, String email) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _users.add(User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _users.removeWhere((u) => u.id == id);
  }
}

// ============================================================================
// EVENTS
// ============================================================================
sealed class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final String name;
  final String email;
  const AddUser(this.name, this.email);
  @override
  List<Object> get props => [name, email];
}

class UpdateUser extends UserEvent {
  final User user;
  const UpdateUser(this.user);
  @override
  List<Object> get props => [user];
}

class DeleteUser extends UserEvent {
  final String id;
  const DeleteUser(this.id);
  @override
  List<Object> get props => [id];
}

// ============================================================================
// STATES
// ============================================================================
sealed class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  const UserLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
  @override
  List<Object> get props => [message];
}

// ============================================================================
// BLOC
// ============================================================================
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await repository.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      await repository.addUser(event.name, event.email);
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await repository.updateUser(event.user);
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      await repository.deleteUser(event.id);
      add(LoadUsers());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex17UserCrud extends StatefulWidget {
  const Ex17UserCrud({super.key});

  @override
  State<Ex17UserCrud> createState() => _Ex17UserCrudState();
}

class _Ex17UserCrudState extends State<Ex17UserCrud> {
  @override
  void initState() {
    super.initState();
    // Setup DI if not already done
    if (!getIt.isRegistered<UserRepository>()) {
      setupDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Sử dụng get_it để lấy BLoC instance
      create: (_) => getIt<UserBloc>()..add(LoadUsers()),
      child: const _UserView(),
    );
  }
}

class _UserView extends StatelessWidget {
  const _UserView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex17: User CRUD'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return switch (state) {
            UserInitial() ||
            UserLoading() =>
              const Center(child: CircularProgressIndicator()),
            UserLoaded(:final users) => users.isEmpty
                ? const Center(child: Text('Chưa có user nào'))
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _UserItem(user: user);
                    },
                  ),
            UserError(:final message) => Center(child: Text('Error: $message')),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                context.read<UserBloc>().add(
                      AddUser(nameController.text, emailController.text),
                    );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _UserItem extends StatelessWidget {
  final User user;

  const _UserItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(user.name[0].toUpperCase()),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context, user),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<UserBloc>().add(DeleteUser(user.id));
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserBloc>().add(
                    UpdateUser(user.copyWith(
                      name: nameController.text,
                      email: emailController.text,
                    )),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
