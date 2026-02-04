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

/// [Ex10ErrorHandling] - Widget StatefulWidget để hiển thị kết quả
/// [StatefulWidget] - Widget có thể thay đổi trạng thái
/// [State] - Trạng thái của widget
class Ex10ErrorHandling extends StatefulWidget {
  const Ex10ErrorHandling({super.key});

  @override
  State<Ex10ErrorHandling> createState() => _Ex10ErrorHandlingState();
}

/// [_Ex10ErrorHandlingState] - State của widget
class _Ex10ErrorHandlingState extends State<Ex10ErrorHandling> {
  /// [Dio] - Instance của Dio
  /// [_result] - Kết quả trả về
  /// [_isLoading] - Trạng thái loading
  late final Dio _dio;
  String _result = '';
  bool _isLoading = false;

  /// [initState] - Hàm được gọi khi widget được tạo
  @override
  void initState() {
    super.initState();

    /// [BaseOptions] - Cấu hình Dio
    /// [baseUrl] - URL cơ sở
    /// [connectTimeout] - Thời gian timeout kết nối
    /// [receiveTimeout] - Thời gian timeout nhận dữ liệu
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
  }

  /// [Simulate different errors]
  /// [type] - Loại lỗi cần test
  /// [Future<void>] - Hàm bất đồng bộ không trả về giá trị
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
  /// [DioException] - Instance của Dio
  String _handleDioError(DioException e) {
    // Tạo buffer để lưu trữ thông tin lỗi
    // [StringBuffer] - Class để tạo chuỗi hiệu quả
    // [writeln] - Hàm để ghi chuỗi vào buffer
    // [toString] - Hàm để chuyển buffer thành chuỗi
    final buffer = StringBuffer();

    buffer.writeln('❌ ERROR DETAILS:');
    buffer.writeln('───────────────────');
    buffer.writeln('Type: ${e.type.name}');

    switch (e.type) {
      // Kết nối chậm
      case DioExceptionType.connectionTimeout:
        buffer.writeln('Message: Kết nối chậm');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln(
          '"Không thể kết nối đến server. Vui lòng kiểm tra mạng và thử lại."',
        );

      // Server phản hồi chậm
      case DioExceptionType.receiveTimeout:
        buffer.writeln('Message: Server phản hồi chậm');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln('"Server đang bận. Vui lòng thử lại sau."');

      // Server trả về lỗi
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

      // Không có kết nối mạng
      case DioExceptionType.connectionError:
        buffer.writeln('Message: Không có kết nối mạng');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln(
          '"Không có kết nối internet. Vui lòng kiểm tra WiFi/4G."',
        );

      // Request đã bị hủy
      case DioExceptionType.cancel:
        buffer.writeln('Message: Request đã bị hủy');

      // Lỗi mặc định
      default:
        buffer.writeln('Message: ${e.message}');
        buffer.writeln('');
        buffer.writeln('💡 User message:');
        buffer.writeln('"Đã xảy ra lỗi. Vui lòng thử lại."');
    }

    // Trả về chuỗi lỗi
    return buffer.toString();
  }

  @override
  void dispose() {
    _dio.close(); // Đóng Dio instance
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
                // Success button
                _buildTestButton('Success', 'success', Colors.green),
                // 404 Not Found button
                _buildTestButton('404 Not Found', '404', Colors.orange),
                // 500 Server button
                _buildTestButton('500 Server', '500', Colors.red),
                // Timeout button
                _buildTestButton('Timeout', 'timeout', Colors.purple),
                // No Network button
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
                // SelectableText cho phép copy text
                child: SelectableText(
                  _result, // Hiển thị kết quả
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build test button
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
