/// ===========================================
/// EXERCISE 01: SINGLE RESPONSIBILITY PRINCIPLE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu SRP: Mỗi class chỉ nên có 1 lý do để thay đổi
/// - Tách biệt responsibilities ra các class riêng
/// - Áp dụng trong Flutter (Widget, Service, Repository)
///
/// 📝 SRP nói gì?
/// "A class should have only one reason to change"
/// = Mỗi class chỉ làm 1 việc, chịu trách nhiệm 1 thứ

library;

import 'package:flutter/material.dart';

/// ===========================================
/// ❌ VI PHẠM SRP - Class làm quá nhiều việc
/// ===========================================
/// Class này vi phạm SRP vì nó:
/// 1. Quản lý user data (state)
/// 2. Validate email
/// 3. Gọi API (giả lập)
/// 4. Build UI
class BadUserManager {
  String name = '';
  String email = '';
  bool isLoading = false;
  String? error;

  /// Validate - trách nhiệm 1
  bool validateEmail() {
    return email.contains('@') && email.contains('.');
  }

  /// API call - trách nhiệm 2
  Future<void> saveToServer() async {
    isLoading = true;
    await Future.delayed(const Duration(seconds: 1));
    // Giả lập save
    isLoading = false;
  }

  /// Build UI - trách nhiệm 3
  Widget buildUserCard() {
    return Card(
      child: ListTile(title: Text(name), subtitle: Text(email)),
    );
  }
}

/// ===========================================
/// ✅ TUÂN THỦ SRP - Tách riêng từng class
/// ===========================================

/// [User] - Chỉ chứa data (Entity)
/// Trách nhiệm duy nhất: Đại diện cho user data
class User {
  final String name;
  final String email;

  const User({required this.name, required this.email});

  /// [copyWith] - Cách cập nhật immutable object
  User copyWith({String? name, String? email}) {
    return User(name: name ?? this.name, email: email ?? this.email);
  }
}

/// [EmailValidator] - Chỉ validate email
/// Trách nhiệm duy nhất: Kiểm tra email hợp lệ
class EmailValidator {
  /// [isValid] - Kiểm tra email
  /// Có thể mở rộng logic mà không ảnh hưởng class khác
  bool isValid(String email) {
    // Regex đơn giản cho demo
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  /// [getError] - Lấy message lỗi
  String? getError(String email) {
    if (email.isEmpty) return 'Email không được để trống';
    if (!email.contains('@')) return 'Email phải chứa @';
    if (!isValid(email)) return 'Email không hợp lệ';
    return null;
  }
}

/// [UserRepository] - Chỉ xử lý API
/// Trách nhiệm duy nhất: Giao tiếp với data source
class UserRepository {
  /// [saveUser] - Lưu user (giả lập API)
  Future<bool> saveUser(User user) async {
    // Giả lập network delay
    await Future.delayed(const Duration(seconds: 1));
    // Giả lập success
    return true;
  }

  /// [getUser] - Lấy user (giả lập API)
  Future<User> getUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(name: 'User $id', email: 'user$id@example.com');
  }
}

/// [UserCard] - Chỉ hiển thị UI
/// Trách nhiệm duy nhất: Render user data
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex01SingleResponsibility extends StatefulWidget {
  const Ex01SingleResponsibility({super.key});

  @override
  State<Ex01SingleResponsibility> createState() =>
      _Ex01SingleResponsibilityState();
}

class _Ex01SingleResponsibilityState extends State<Ex01SingleResponsibility> {
  // TextEditingController là widget để xử lý input text
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  /// Sử dụng các class đã tách
  final _validator = EmailValidator();
  final _repository = UserRepository();

  User? _savedUser;
  bool _isLoading = false;
  String? _emailError;

  // _saveUser là hàm để lưu user
  Future<void> _saveUser() async {
    // 1. Validate (dùng EmailValidator)
    final email = _emailController.text;
    final error = _validator.getError(email);

    if (error != null) {
      setState(() => _emailError = error);
      return;
    }

    setState(() {
      _emailError = null;
      _isLoading = true;
    });

    // 2. Create User object
    final user = User(name: _nameController.text, email: email);

    // 3. Save (dùng UserRepository)
    final success = await _repository.saveUser(user);

    setState(() {
      _isLoading = false;
      if (success) _savedUser = user;
    });
  }

  @override
  void dispose() {
    _nameController.dispose(); // dispose là để giải phóng bộ nhớ
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex01: Single Responsibility')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 SRP = Single Responsibility Principle',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Classes đã được tách:\n'
                      '• User - Chỉ chứa data\n'
                      '• EmailValidator - Chỉ validate\n'
                      '• UserRepository - Chỉ xử lý API\n'
                      '• UserCard - Chỉ render UI',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form nhập liệu
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                errorText: _emailError,
              ),
            ),
            const SizedBox(height: 16),

            // Nút save user
            ElevatedButton(
              onPressed: _isLoading ? null : _saveUser,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save User'),
            ),

            const SizedBox(height: 24),

            // Saved user (dùng UserCard widget)
            // _savedUser != null là điều kiện để kiểm tra xem user đã được lưu hay chưa
            // ... là để spread the list
            // Nếu _savedUser != null thì sẽ hiển thị list này
            // Nếu _savedUser == null thì sẽ không hiển thị gì cả
            if (_savedUser != null) ...[
              const Text(
                'Saved User:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Sử dụng UserCard widget để hiển thị user
              UserCard(user: _savedUser!),
            ],
          ],
        ),
      ),
    );
  }
}
