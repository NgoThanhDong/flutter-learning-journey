/// ===========================================
/// EXERCISE 09: DIO INTERCEPTORS
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu Interceptors là gì và tại sao cần
/// - Tạo custom interceptor (logging, auth)
/// - Thứ tự xử lý interceptors
///
/// 📝 Giải thích:
/// Interceptor = "Người đón chặn" - xen vào giữa request/response
/// - onRequest: Trước khi gửi request (thêm token, log)
/// - onResponse: Sau khi nhận response (transform, log)
/// - onError: Khi có lỗi (retry, refresh token)

library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// ===========================================
/// CUSTOM INTERCEPTORS
/// ===========================================

/// [LoggingInterceptor] - In ra console mọi request/response
class LoggingInterceptor extends Interceptor {
  /// [onRequest] - Trước khi gửi
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌───────────────────────────────────────────');
    debugPrint('│ REQUEST: ${options.method} ${options.uri}');
    debugPrint('│ Headers: ${options.headers}');
    if (options.data != null) {
      debugPrint('│ Body: ${options.data}');
    }
    debugPrint('└───────────────────────────────────────────');

    /// [handler.next] - Tiếp tục xử lý
    /// Nếu không gọi, request sẽ bị chặn!
    handler.next(options);
  }

  /// [onResponse] - Sau khi nhận thành công
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌───────────────────────────────────────────');
    debugPrint(
      '│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    debugPrint('│ Data: ${response.data.toString().substring(0, 100)}...');
    debugPrint('└───────────────────────────────────────────');

    handler.next(response);
  }

  /// [onError] - Khi có lỗi
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌───────────────────────────────────────────');
    debugPrint('│ ERROR: ${err.type}');
    debugPrint('│ Message: ${err.message}');
    debugPrint('└───────────────────────────────────────────');

    handler.next(err);
  }
}

/// [AuthInterceptor] - Tự động thêm token vào header
class AuthInterceptor extends Interceptor {
  /// Giả lập token storage
  String? _token = 'demo_token_12345';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// [Thêm Authorization header]
    /// Mọi request đều tự động có token
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    /// [Handle 401 Unauthorized]
    /// Có thể redirect về login hoặc refresh token
    if (err.response?.statusCode == 401) {
      debugPrint('Token expired! Redirecting to login...');
      // In real app: clear token, navigate to login
      _token = null;
    }

    handler.next(err);
  }
}

/// ===========================================
/// UI WIDGET
/// ===========================================
class Ex09DioInterceptors extends StatefulWidget {
  const Ex09DioInterceptors({super.key});

  @override
  State<Ex09DioInterceptors> createState() => _Ex09DioInterceptorsState();
}

class _Ex09DioInterceptorsState extends State<Ex09DioInterceptors> {
  late final Dio _dio;
  String _log = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

    /// [Thêm Interceptors]
    /// Thứ tự quan trọng: Request xử lý từ đầu → cuối
    ///                   Response xử lý từ cuối → đầu
    _dio.interceptors.addAll([
      AuthInterceptor(), // 1. Thêm token
      LoggingInterceptor(), // 2. Log request với token
    ]);
  }

  Future<void> _makeRequest() async {
    setState(() {
      _isLoading = true;
      _log = '';
    });

    try {
      final response = await _dio.get('/posts/1');

      setState(() {
        _log =
            '''
✅ Request thành công!
Status: ${response.statusCode}
Headers được gửi: ${response.requestOptions.headers}

Data: ${response.data}
        ''';
      });
    } on DioException catch (e) {
      setState(() {
        _log = '❌ Error: ${e.message}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex09: Dio Interceptors')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Giải thích
            const Card(
              color: Colors.purple,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔍 Interceptors trong app này:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. AuthInterceptor: Tự thêm "Bearer token" vào header\n'
                      '2. LoggingInterceptor: In request/response ra console',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _makeRequest,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: const Text('Make Request'),
            ),

            const SizedBox(height: 16),

            // Log output
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  SelectableText(
                    _log.isEmpty ? 'Nhấn button để test...' : _log,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Mở Console (F12) để xem log chi tiết!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Interceptors giúp:\n'
                      '• Tự động thêm auth token\n'
                      '• Debug request/response\n'
                      '• Xử lý 401 (token expired)\n'
                      '• Retry failed requests',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
