/// ===========================================
/// EXERCISE 11: REPOSITORY IMPLEMENTATION
/// ===========================================
/// 🎯 Mục tiêu:
/// - Full repository implementation
/// - Model ↔ Entity conversion
/// - Error handling trong repository
///
/// 📝 Repository responsibilities:
/// - Orchestrate data sources
/// - Convert Model → Entity
/// - Handle errors

library;

import 'package:flutter/material.dart';

/// ===========================================
/// DOMAIN LAYER - ENTITY
/// ===========================================

/// [UserEntity] - Pure domain object
/// Không có JSON, chỉ business data
class UserEntity {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  @override
  String toString() => 'User($id, $name)';
}

/// [UserRepository] - Abstract repository interface
abstract class UserRepository {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity?> getUserById(int id);
  Future<UserEntity> createUser(String name, String email);
  Future<UserEntity> updateUser(UserEntity user);
  Future<void> deleteUser(int id);
}

/// ===========================================
/// DATA LAYER - MODEL
/// ===========================================

/// [UserModel] - Data layer model với JSON support
/// Thêm fromJson/toJson, mapping với API response
class UserModel {
  final int id;
  final String fullName;
  final String emailAddress;
  final String status;

  UserModel({
    required this.id,
    required this.fullName,
    required this.emailAddress,
    required this.status,
  });

  /// [fromJson] - Parse từ API response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      emailAddress: json['email_address'] as String,
      status: json['status'] as String,
    );
  }

  /// [toJson] - Serialize để gửi API
  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'email_address': emailAddress,
    'status': status,
  };

  /// [toEntity] - Convert sang Domain Entity
  /// ĐÂY LÀ ĐIỂM CHÍNH của Repository pattern!
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: fullName,
      email: emailAddress,
      isActive: status == 'active',
    );
  }

  /// [fromEntity] - Convert từ Entity về Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.name,
      emailAddress: entity.email,
      status: entity.isActive ? 'active' : 'inactive',
    );
  }
}

/// ===========================================
/// DATA LAYER - DATA SOURCE
/// ===========================================

/// [UserDataSource] - Giả lập API
class UserDataSource {
  final List<Map<String, dynamic>> _fakeDb = [
    {
      'id': 1,
      'full_name': 'Alice Johnson',
      'email_address': 'alice@example.com',
      'status': 'active',
    },
    {
      'id': 2,
      'full_name': 'Bob Smith',
      'email_address': 'bob@example.com',
      'status': 'active',
    },
    {
      'id': 3,
      'full_name': 'Charlie Brown',
      'email_address': 'charlie@example.com',
      'status': 'inactive',
    },
  ];

  int _nextId = 4;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_fakeDb);
  }

  Future<Map<String, dynamic>?> fetchUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _fakeDb.firstWhere((u) => u['id'] == id);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newUser = {
      'id': _nextId++,
      'full_name': data['full_name'],
      'email_address': data['email_address'],
      'status': 'active',
    };
    _fakeDb.add(newUser);
    return newUser;
  }

  Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _fakeDb.indexWhere((u) => u['id'] == id);
    if (index == -1) throw Exception('User not found');
    _fakeDb[index] = {...data, 'id': id};
    return _fakeDb[index];
  }

  Future<void> deleteUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fakeDb.removeWhere((u) => u['id'] == id);
  }
}

/// ===========================================
/// DATA LAYER - REPOSITORY IMPLEMENTATION
/// ===========================================

/// [UserRepositoryImpl] - Implement repository interface
class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<List<UserEntity>> getUsers() async {
    /// 1. Fetch raw data từ data source
    final jsonList = await dataSource.fetchUsers();

    /// 2. Parse thành Models
    final models = jsonList.map((json) => UserModel.fromJson(json)).toList();

    /// 3. Convert Models → Entities
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<UserEntity?> getUserById(int id) async {
    final json = await dataSource.fetchUser(id);
    if (json == null) return null;

    final model = UserModel.fromJson(json);
    return model.toEntity();
  }

  @override
  Future<UserEntity> createUser(String name, String email) async {
    /// 1. Tạo request data
    final requestData = {'full_name': name, 'email_address': email};

    /// 2. Call data source
    final responseJson = await dataSource.createUser(requestData);

    /// 3. Parse response → Model → Entity
    final model = UserModel.fromJson(responseJson);
    return model.toEntity();
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    /// 1. Entity → Model → JSON
    final model = UserModel.fromEntity(user);
    final json = model.toJson();

    /// 2. Call data source
    final responseJson = await dataSource.updateUser(user.id, json);

    /// 3. Response → Model → Entity
    return UserModel.fromJson(responseJson).toEntity();
  }

  @override
  Future<void> deleteUser(int id) async {
    await dataSource.deleteUser(id);
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex11RepositoryImpl extends StatefulWidget {
  const Ex11RepositoryImpl({super.key});

  @override
  State<Ex11RepositoryImpl> createState() => _Ex11RepositoryImplState();
}

class _Ex11RepositoryImplState extends State<Ex11RepositoryImpl> {
  late final UserRepository _repository;

  List<UserEntity> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inject data source vào repository
    _repository = UserRepositoryImpl(UserDataSource());
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await _repository.getUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _addUser() async {
    final name = 'New User ${DateTime.now().second}';
    await _repository.createUser(name, '$name@example.com');
    _loadUsers();
  }

  Future<void> _toggleActive(UserEntity user) async {
    final updated = UserEntity(
      id: user.id,
      name: user.name,
      email: user.email,
      isActive: !user.isActive,
    );
    await _repository.updateUser(updated);
    _loadUsers();
  }

  Future<void> _deleteUser(int id) async {
    await _repository.deleteUser(id);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex11: Repository Impl'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addUser)],
      ),
      body: Column(
        children: [
          // Info
          const Card(
            color: Colors.indigo,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Repository Implementation',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Flow: UI → Repository → DataSource\n'
                    'Data: API JSON → UserModel → UserEntity\n\n'
                    'UI chỉ biết UserEntity, không biết JSON format!',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Users list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: user.isActive
                              ? Colors.green
                              : Colors.grey,
                          child: Text(user.name[0]),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: user.isActive,
                              onChanged: (_) => _toggleActive(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteUser(user.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
