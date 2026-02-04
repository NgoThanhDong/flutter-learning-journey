/// ===========================================
/// EXERCISE 08: DIO BASIC
/// ===========================================
/// 🎯 Mục tiêu:
/// - Cài đặt và sử dụng Dio package
/// - So sánh với http package
/// - Cấu hình BaseOptions
///
/// 📝 Dio vs http:
/// - http: Light, simple, official
/// - Dio: Feature-rich, interceptors, better DX

library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// ===========================================
/// MODEL
/// ===========================================
class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  /// [fromJson] - Convert JSON to User object
  /// @param json: [Map<String, dynamic>] - JSON object
  /// @return User - User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

/// ===========================================
/// UI WIDGET
/// ===========================================
/// [Ex08DioBasic] - Widget hiển thị danh sách user
class Ex08DioBasic extends StatefulWidget {
  const Ex08DioBasic({super.key});

  @override
  State<Ex08DioBasic> createState() => _Ex08DioBasicState();
}

class _Ex08DioBasicState extends State<Ex08DioBasic> {
  /// [Dio instance]
  /// Tạo với BaseOptions để cấu hình toàn cục
  /// [late final] - Khởi tạo một lần duy nhất
  /// [Dio] - Class từ dio package
  late final Dio _dio;

  /// [State variables]
  /// [users] - Danh sách user
  /// [isLoading] - Trạng thái loading
  /// [error] - Thông báo lỗi
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    /// [BaseOptions] - Cấu hình mặc định cho tất cả requests
    _dio = Dio(
      BaseOptions(
        /// [baseUrl] - Prefix (tiền tố) cho tất cả requests
        /// Thay vì: dio.get('https://jsonplaceholder.typicode.com/users')
        /// Chỉ cần: dio.get('/users')
        baseUrl: 'https://jsonplaceholder.typicode.com',

        /// [connectTimeout] - Timeout khi kết nối
        connectTimeout: const Duration(seconds: 5),

        /// [receiveTimeout] - Timeout khi nhận data
        receiveTimeout: const Duration(seconds: 10),

        /// [headers] - Headers mặc định
        headers: {
          'Content-Type': 'application/json', // Định dạng dữ liệu gửi đi
          'Accept': 'application/json', // Định dạng dữ liệu nhận về
        },
      ),
    );

    /// [Thêm LogInterceptor] để debug
    /// [LogInterceptor] - Interceptor để log requests và responses
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true, // Log request body
        responseBody: true, // Log response body
        logPrint: (log) => debugPrint(log.toString()), // Hàm log
      ),
    );
  }

  /// [GET với Dio]
  /// [fetchUsers] - Lấy danh sách user từ API
  /// [setState] - Cập nhật trạng thái
  /// [try-catch] - Xử lý lỗi
  /// [finally] - Luôn thực hiện sau khi try-catch
  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      /// [dio.get] - Gửi GET request
      /// Trả về Response object
      final response = await _dio.get('/users');

      /// [response.data] - Đã tự động parse JSON!
      /// Không cần jsonDecode() như http package
      /// response.data là dynamic (List hoặc Map)
      final List<dynamic> data = response.data;

      /// [map] - Map từng JSON object sang User object
      /// [toList] - Convert sang List
      _users = data.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      /// [DioException] - Lỗi từ Dio
      /// Có nhiều thông tin hơn Exception thông thường
      _error = _getErrorMessage(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// [Error message helper]
  /// [getErrorMessage] - Lấy thông báo lỗi từ DioException
  /// [e] - DioException
  /// [return] - Thông báo lỗi
  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Kết nối chậm, vui lòng thử lại';
      case DioExceptionType.receiveTimeout:
        return 'Server phản hồi chậm';
      case DioExceptionType.connectionError:
        return 'Không có kết nối mạng';
      case DioExceptionType.badResponse:
        return 'Lỗi server: ${e.response?.statusCode}';
      default:
        return 'Đã xảy ra lỗi: ${e.message}';
    }
  }

  @override
  void dispose() {
    _dio.close(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex08: Dio Basic')),
      body: Column(
        children: [
          // Info card
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dio tự động parse JSON! Không cần jsonDecode()',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fetch button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchUsers,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2, // Độ dày của progress indicator
                      ),
                    )
                  : const Icon(Icons.download),
              label: Text(_isLoading ? 'Loading...' : 'Fetch with Dio'),
            ),
          ),

          const SizedBox(height: 16),

          // Error
          if (_error != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!)), // Hiển thị lỗi
                ],
              ),
            ),

          // Users list
          Expanded(
            child: _users.isEmpty
                // Hiển thị khi không có data
                ? const Center(child: Text('Nhấn button để fetch data'))
                // Hiển thị danh sách user
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${user.id}')),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
