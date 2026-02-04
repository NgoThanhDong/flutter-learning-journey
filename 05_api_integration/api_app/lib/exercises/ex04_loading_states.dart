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

/*
[
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  },
  {...}
]
*/

library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ===========================================
/// EXERCISE 04: LOADING STATES (FUTUREBUILDER)
/// ===========================================
// Ex04LoadingStates là widget cho bài tập 04
class Ex04LoadingStates extends StatefulWidget {
  const Ex04LoadingStates({super.key});

  @override
  State<Ex04LoadingStates> createState() => _Ex04LoadingStatesState();
}

class _Ex04LoadingStatesState extends State<Ex04LoadingStates> {
  /// [late Future] - Khai báo Future sẽ được gán sau
  /// Sử dụng late để tránh null
  /// Future chứa danh sách users
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();

    /// ✅ [Best Practice] - Gọi Future trong initState
    /// Điều này đảm bảo Future chỉ được tạo 1 lần
    /// Nếu đặt trong build(), mỗi lần rebuild sẽ gọi API lại!
    _usersFuture = _fetchUsers(); // Gọi API ngay khi widget được tạo
  }

  /// [Fetch Function]
  /// Trả về [Future<List<...>>] để [FutureBuilder] có thể consume (nhận)
  /// Trả về danh sách users từ API
  /// Nếu có lỗi, throw exception
  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    // Giả lập delay để thấy loading
    /// ✅ [Best Practice] - Giả lập delay
    /// Tránh UI block khi gọi API
    await Future.delayed(const Duration(seconds: 2));

    /// ✅ [Best Practice] - Gọi API
    /// Trả về response từ API
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    /// ✅ [Best Practice] - Xử lý response
    /// Trả về danh sách users nếu thành công
    if (response.statusCode == 200) {
      // jsonDecode() chuyển response.body thành List<dynamic>
      final List<dynamic> data = jsonDecode(response.body);
      // cast<Map<String, dynamic>>() chuyển List<dynamic> thành List<Map<String, dynamic>>
      return data.cast<Map<String, dynamic>>();
    }

    /// Throw exception nếu thất bại
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
            onPressed: _refresh, // Gọi _refresh khi nhấn refresh
            tooltip: 'Refresh',
          ),
        ],
      ),

      // FutureBuilder sẽ theo dõi _usersFuture
      // và rebuild UI khi _usersFuture thay đổi
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
          /// snapshot.hasError kiểm tra có lỗi không
          /// snapshot.error chứa thông tin lỗi
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
                      '${snapshot.error}', // snapshot.error chứa thông tin lỗi
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refresh, // Gọi _refresh khi nhấn refresh
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
          /// snapshot.data!.isEmpty kiểm tra danh sách có rỗng không
          /// snapshot.hasData kiểm tra Future có dữ liệu không
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
          /// snapshot.data! chứa danh sách users
          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index]; // Lấy user tại index
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${user['id']}', // Lấy id của user
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(user['name'] as String), // Lấy name của user
                  subtitle: Text(user['email'] as String), // Lấy email của user
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
