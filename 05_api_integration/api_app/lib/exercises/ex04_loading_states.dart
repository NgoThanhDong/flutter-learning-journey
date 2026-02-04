/// ===========================================
/// EXERCISE 04: LOADING STATES (FUTUREBUILDER)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Sử dụng FutureBuilder để quản lý async UI
/// - Xử lý 4 trạng thái: Initial, Loading, Error, Success
/// - Best practice: Future trong initState
///
/// 📝 Giải thích:
/// - FutureBuilder tự động rebuild UI khi Future thay đổi trạng thái
/// - snapshot chứa thông tin về trạng thái hiện tại

library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ex04LoadingStates extends StatefulWidget {
  const Ex04LoadingStates({super.key});

  @override
  State<Ex04LoadingStates> createState() => _Ex04LoadingStatesState();
}

class _Ex04LoadingStatesState extends State<Ex04LoadingStates> {
  /// [late Future] - Khai báo Future sẽ được gán sau
  /// Sử dụng late để tránh null
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();

    /// ✅ [Best Practice] - Gọi Future trong initState
    /// Điều này đảm bảo Future chỉ được tạo 1 lần
    /// Nếu đặt trong build(), mỗi lần rebuild sẽ gọi API lại!
    _usersFuture = _fetchUsers();
  }

  /// [Fetch Function]
  /// Trả về [Future<List<...>>] để [FutureBuilder] có thể consume
  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    // Giả lập delay để thấy loading
    await Future.delayed(const Duration(seconds: 1));

    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }

    throw Exception('Failed to load users: ${response.statusCode}');
  }

  /// [Refresh Function]
  /// Tạo Future mới và trigger rebuild
  void _refresh() {
    setState(() {
      _usersFuture = _fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex04: FutureBuilder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        /// [future] - Future cần theo dõi
        future: _usersFuture,

        /// [builder] - Build UI dựa trên snapshot
        /// snapshot chứa:
        /// - connectionState: trạng thái kết nối
        /// - data: dữ liệu nếu success
        /// - error: lỗi nếu có
        builder: (context, snapshot) {
          /// [ConnectionState.waiting]
          /// Future đang chạy, chưa có kết quả
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải dữ liệu...'),
                ],
              ),
            );
          }

          /// [snapshot.hasError]
          /// Future hoàn thành nhưng có lỗi
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đã xảy ra lỗi!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          /// [Empty State]
          /// Success nhưng không có dữ liệu
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Không có dữ liệu'),
                ],
              ),
            );
          }

          /// [Success State]
          /// Future hoàn thành và có dữ liệu
          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${user['id']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(user['name'] as String),
                  subtitle: Text(user['email'] as String),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
