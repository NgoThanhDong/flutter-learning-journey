/// ===========================================
/// EXERCISE 10: ERROR HANDLING
/// ===========================================
/// 🎯 Mục tiêu:
/// - Phân biệt các loại lỗi: Network, Server, Client
/// - Xử lý DioException types
/// - Hiển thị error message thân thiện với user
///
/// 📝 Các loại lỗi:
/// - connectionTimeout: Không connect được server
/// - receiveTimeout: Server phản hồi quá lâu
/// - badResponse: Server trả về 4xx, 5xx
/// - connectionError: Không có mạng
/// - cancel: Request bị hủy

library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Ex10ErrorHandling extends StatefulWidget {
  const Ex10ErrorHandling({super.key});

  @override
  State<Ex10ErrorHandling> createState() => _Ex10ErrorHandlingState();
}

class _Ex10ErrorHandlingState extends State<Ex10ErrorHandling> {
  late final Dio _dio;
  String _result = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }

  /// [Simulate different errors]
  Future<void> _testError(String type) async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      switch (type) {
        case 'success':
          final response = await _dio.get('/posts/1');
          _result = '✅ Success!\nData: ${response.data['title']}';
          break;

        case '404':
          // Endpoint không tồn tại
          await _dio.get('/posts/999999');
          break;

        case '500':
          // JSONPlaceholder không có 500, giả lập với URL sai
          await _dio.get('https://httpstat.us/500');
          break;

        case 'timeout':
          // URL delay > timeout setting
          final slowDio = Dio(
            BaseOptions(receiveTimeout: const Duration(milliseconds: 100)),
          );
          await slowDio.get('https://httpstat.us/200?sleep=5000');
          break;

        case 'network':
          // URL không tồn tại
          await _dio.get('https://this-domain-does-not-exist-12345.com/api');
          break;
      }
    } on DioException catch (e) {
      /// [Xử lý DioException]
      _result = _handleDioError(e);
    } catch (e) {
      _result = '❌ Unknown error: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// [Error Handler]
  /// Convert DioException → User-friendly message
  String _handleDioError(DioException e) {
    final buffer = StringBuffer();

    buffer.writeln('❌ ERROR DETAILS:');
    buffer.writeln('───────────────────');
    buffer.writeln('Type: ${e.type.name}');

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        buffer.writeln('Message: Kết nối chậm');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln(
          '"Không thể kết nối đến server. Vui lòng kiểm tra mạng và thử lại."',
        );

      case DioExceptionType.receiveTimeout:
        buffer.writeln('Message: Server phản hồi chậm');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln('"Server đang bận. Vui lòng thử lại sau."');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final statusMessage = e.response?.statusMessage;
        buffer.writeln('Status: $statusCode $statusMessage');
        buffer.writeln('');
        buffer.writeln('💡 User message:');

        if (statusCode == 400) {
          buffer.writeln('"Dữ liệu không hợp lệ. Vui lòng kiểm tra lại."');
        } else if (statusCode == 401) {
          buffer.writeln('"Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại."');
        } else if (statusCode == 403) {
          buffer.writeln('"Bạn không có quyền truy cập."');
        } else if (statusCode == 404) {
          buffer.writeln('"Không tìm thấy dữ liệu."');
        } else if (statusCode != null && statusCode >= 500) {
          buffer.writeln('"Lỗi server. Vui lòng thử lại sau."');
        } else {
          buffer.writeln('"Đã xảy ra lỗi. Vui lòng thử lại."');
        }

      case DioExceptionType.connectionError:
        buffer.writeln('Message: Không có kết nối mạng');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln(
          '"Không có kết nối internet. Vui lòng kiểm tra WiFi/4G."',
        );

      case DioExceptionType.cancel:
        buffer.writeln('Message: Request đã bị hủy');

      default:
        buffer.writeln('Message: ${e.message}');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln('"Đã xảy ra lỗi. Vui lòng thử lại."');
    }

    return buffer.toString();
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex10: Error Handling')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test các loại lỗi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Test buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTestButton('Success', 'success', Colors.green),
                _buildTestButton('404 Not Found', '404', Colors.orange),
                _buildTestButton('500 Server', '500', Colors.red),
                _buildTestButton('Timeout', 'timeout', Colors.purple),
                _buildTestButton('No Network', 'network', Colors.grey),
              ],
            ),

            const SizedBox(height: 24),

            // Loading
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Result
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result.startsWith('✅')
                      ? Colors.green[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _result.startsWith('✅') ? Colors.green : Colors.red,
                  ),
                ),
                child: SelectableText(
                  _result,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, String type, Color color) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _testError(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }
}
