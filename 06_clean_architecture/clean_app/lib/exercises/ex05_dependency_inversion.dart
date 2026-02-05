/// ===========================================
/// EXERCISE 05: DEPENDENCY INVERSION PRINCIPLE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu DIP: Depend on abstractions, not concretions
///     Hãy dựa vào các khái niệm trừu tượng, chứ không phải các khái niệm cụ thể.
/// - High-level modules không phụ thuộc low-level
/// - Chuẩn bị cho Dependency Injection
///
/// 📝 DIP nói gì?
/// "High-level modules should not depend on low-level modules.
///  Both should depend on abstractions."
/// "High-level modules không nên phụ thuộc vào low-level modules.
///  Cả hai nên phụ thuộc vào abstraction."

library;

import 'dart:convert';
import 'package:flutter/material.dart';

/// ===========================================
/// ❌ VI PHẠM DIP - Phụ thuộc trực tiếp implementation
/// ===========================================

/// Low-level module (concrete)
class BadMySqlDatabase {
  Future<String> query(String sql) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return '{"name": "From MySQL"}';
  }
}

/// High-level module phụ thuộc TRỰC TIẾP vào MySql
class BadUserService {
  final BadMySqlDatabase database =
      BadMySqlDatabase(); // Tight coupling! (Tính chặt chẽ)

  Future<String> getUser() async {
    return database.query('SELECT * FROM users');
  }
}

/// Vấn đề:
/// 1. Không thể test (phải dùng real database)
/// 2. Không thể đổi sang Postgres, MongoDB...
/// 3. UserService biết quá nhiều về MySql

/// ===========================================
/// ✅ TUÂN THỦ DIP - Depend on abstraction
/// ===========================================

/// [Database] - Abstraction (interface)
/// High-level và low-level đều depend vào interface này
abstract class Database {
  /// [query] - Abstract method
  /// Trả về dữ liệu từ database
  Future<Map<String, dynamic>> query(String collection, int id);

  /// [save] - Abstract method
  /// Lưu dữ liệu vào database
  Future<void> save(String collection, Map<String, dynamic> data);
}

/// [MySqlDatabase] - Low-level implementation 1
class MySqlDatabase implements Database {
  @override
  Future<Map<String, dynamic>> query(String collection, int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Giả lập MySQL response
    return {'id': id, 'name': 'User from MySQL', 'source': 'MySQL Database'};
  }

  @override
  Future<void> save(String collection, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('MySQL: Saved $data to $collection');
  }
}

/// [MongoDatabase] - Low-level implementation 2
class MongoDatabase implements Database {
  @override
  Future<Map<String, dynamic>> query(String collection, int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'id': id, 'name': 'User from MongoDB', 'source': 'MongoDB Atlas'};
  }

  @override
  Future<void> save(String collection, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('MongoDB: Saved ${jsonEncode(data)}');
  }
}

/// [MockDatabase] - For testing
class MockDatabase implements Database {
  /// [query] - Implement abstract method
  /// Trả về dữ liệu từ database
  @override
  Future<Map<String, dynamic>> query(String collection, int id) async {
    return {
      'id': id,
      'name': 'Mock User',
      'source': 'Mock Database (for testing)',
    };
  }

  /// [save] - Implement abstract method
  /// Lưu dữ liệu vào database
  @override
  Future<void> save(String collection, Map<String, dynamic> data) async {
    debugPrint('Mock: Pretending to save $data');
  }
}

/// [UserService] - High-level module
/// Phụ thuộc vào abstraction (Database), không phải implementation
class UserService {
  /// [database] - Inject từ bên ngoài (DI)
  final Database database;

  /// Constructor injection - nhận dependency từ ngoài
  UserService(this.database);

  /// [getUser] - Get user from database
  Future<Map<String, dynamic>> getUser(int id) {
    return database.query('users', id);
  }

  /// [saveUser] - Save user to database
  Future<void> saveUser(Map<String, dynamic> user) {
    return database.save('users', user);
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex05DependencyInversion extends StatefulWidget {
  const Ex05DependencyInversion({super.key});

  @override
  State<Ex05DependencyInversion> createState() =>
      _Ex05DependencyInversionState();
}

class _Ex05DependencyInversionState extends State<Ex05DependencyInversion> {
  /// [Các database implementations]
  final Map<String, Database> _databases = {
    'MySQL': MySqlDatabase(),
    'MongoDB': MongoDatabase(),
    'Mock': MockDatabase(),
  };

  String _selectedDb = 'MySQL'; // Database được chọn
  UserService? _userService; // UserService instance chứa database được chọn
  Map<String, dynamic>? _userData; // User data từ database
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _updateService(); // Update UserService khi initState
  }

  /// [updateService] - Update UserService khi chọn database khác
  void _updateService() {
    /// [Key insight] - Tạo UserService với database được chọn
    /// UserService KHÔNG BIẾT đang dùng MySQL hay MongoDB
    _userService = UserService(_databases[_selectedDb]!);
  }

  /// [fetchUser] - Fetch user from database
  Future<void> _fetchUser() async {
    setState(() {
      _isLoading = true;
      _userData = null;
    });

    // Lấy user data từ database có ID = 1
    final data = await _userService!.getUser(1);

    setState(() {
      _userData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex05: Dependency Inversion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            const Card(
              color: Colors.teal,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 DIP = Dependency Inversion Principle',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'UserService phụ thuộc vào Database (interface)\n'
                      'KHÔNG phụ thuộc vào MySQL hay MongoDB.\n\n'
                      'Có thể swap database mà không sửa UserService!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Database selector
            const Text(
              'Chọn Database Implementation:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Radio group để chọn database implementation
            RadioGroup<String>(
              groupValue: _selectedDb, // Giá trị hiện tại
              // Khi chọn database implementation khác
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDb = value;
                    // Update UserService khi chọn database khác
                    _updateService();
                    _userData = null;
                  });
                }
              },
              // Widget hiển thị các options
              child: Column(
                children: List.generate(_databases.length, (index) {
                  // Lấy tên database
                  final dbName = _databases.keys.elementAt(index);

                  // Lấy description của database
                  final dbDescription = _getDatabaseDescription(dbName);

                  // Return RadioListTile
                  return RadioListTile<String>(
                    title: Text(dbName),
                    subtitle: Text(dbDescription),
                    value: dbName,
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Button fetch user
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchUser,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Fetch User'),
            ),

            const SizedBox(height: 24),

            // Result
            if (_userData != null)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Data:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),

                      // User data từ database có ID = 1
                      Text('ID: ${_userData!['id']}'),
                      Text('Name: ${_userData!['name']}'),
                      Text('Source: ${_userData!['source']}'),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Code explanation
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '💻 Code structure:\n\n'
                  'abstract class Database { ... }\n\n'
                  'class MySqlDatabase implements Database { ... }\n'
                  'class MongoDatabase implements Database { ... }\n\n'
                  'class UserService {\n'
                  '  final Database database; // Abstract!\n'
                  '  UserService(this.database);\n'
                  '}\n\n'
                  '// Inject dependency:\n'
                  'final service = UserService(MySqlDatabase());',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [getDatabaseDescription] - Get database description
  String _getDatabaseDescription(String name) {
    switch (name) {
      case 'MySQL':
        return 'Relational database, SQL queries';
      case 'MongoDB':
        return 'NoSQL database, document-based';
      case 'Mock':
        return 'For testing, no real database';
      default:
        return '';
    }
  }
}
