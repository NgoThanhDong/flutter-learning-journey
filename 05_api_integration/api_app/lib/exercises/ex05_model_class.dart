/// ===========================================
/// EXERCISE 05: MODEL CLASS
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tạo Model class với fromJson/toJson
/// - Type-safe data handling
/// - So sánh với Map approach
///
/// 📝 Giải thích:
/// - Model class = Class đại diện cho 1 entity (User, Post, Product...)
/// - fromJson = Factory constructor parse JSON → Object
/// - toJson = Method convert Object → JSON Map

library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ===========================================
/// MODEL CLASS: User
/// ===========================================
/// Đại diện cho 1 User từ API
class User {
  /// [Fields] - Các thuộc tính của User
  /// Sử dụng final để immutable (không thay đổi sau khi tạo)
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;

  /// [Constructor]
  /// required = bắt buộc phải có giá trị
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
  });

  /// [Factory Constructor: fromJson]
  /// Parse JSON Map → User object
  ///
  /// Tham số:
  /// - json: [Map<String, dynamic>] từ [jsonDecode()]
  ///
  /// Cách hoạt động:
  /// 1. Truy xuất giá trị từ Map: json['key']
  /// 2. Cast về đúng type: as String, as int
  /// 3. Khởi tạo object User với các giá trị đó
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
    );
  }

  /// [toJson Method]
  /// Convert User object → JSON Map
  /// Dùng khi cần gửi data lên server
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }

  /// [toString] - Debug friendly
  @override
  String toString() => 'User(id: $id, name: $name)';
}

/// ===========================================
/// UI WIDGET
/// ===========================================
class Ex05ModelClass extends StatefulWidget {
  const Ex05ModelClass({super.key});

  @override
  State<Ex05ModelClass> createState() => _Ex05ModelClassState();
}

class _Ex05ModelClassState extends State<Ex05ModelClass> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  /// [Fetch với Model]
  /// Trả về [List<User>] thay vì [List<Map>]
  Future<List<User>> _fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      // 1. Parse JSON string → List<dynamic>
      final List<dynamic> jsonList = jsonDecode(response.body);

      // 2. Convert mỗi item → User object
      // .map() transform từng phần tử
      // .toList() chuyển Iterable → List
      return jsonList
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex05: Model Class')),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              /// [Type-safe access]
              /// IDE gợi ý tất cả properties!
              /// Không thể typo như với Map['nmae']
              final user = users[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ExpansionTile(
                  leading: CircleAvatar(child: Text(user.id.toString())),
                  title: Text(user.name), // ✅ IDE autocomplete
                  subtitle: Text('@${user.username}'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(user.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(user.phone),
                    ),
                    ListTile(
                      leading: const Icon(Icons.web),
                      title: Text(user.website),
                    ),
                    // Hiển thị toJson result
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'toJson(): ${user.toJson()}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
