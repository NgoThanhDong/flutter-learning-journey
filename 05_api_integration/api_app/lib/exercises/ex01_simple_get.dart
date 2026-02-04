/// ===========================================
/// EXERCISE 01: SIMPLE GET REQUEST
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu cách gọi GET request với http package
/// - Xử lý response cơ bản
/// - Hiển thị JSON data thô
///
/// 📝 API sử dụng:
/// GET https://jsonplaceholder.typicode.com/users/1
/// Trả về thông tin 1 user dạng JSON

library;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ex01SimpleGet extends StatefulWidget {
  const Ex01SimpleGet({super.key});

  @override
  State<Ex01SimpleGet> createState() => _Ex01SimpleGetState();
}

class _Ex01SimpleGetState extends State<Ex01SimpleGet> {
  /// [State variables]
  /// - _isLoading: Đang tải hay không
  /// - _responseText: Nội dung response (JSON string)
  /// - _statusCode: HTTP status code (200, 404, etc.)
  /// - _error: Thông báo lỗi nếu có
  bool _isLoading = false;
  String _responseText = '';
  int? _statusCode;
  String? _error;

  /// [Hàm gọi API]
  /// Sử dụng async/await vì HTTP request là bất đồng bộ
  Future<void> _fetchUser() async {
    // 1. Bắt đầu loading
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      /// [http.get] - Hàm gửi GET request
      /// - Tham số: Uri.parse(url) - Chuyển string URL thành Uri object
      /// - Trả về: Future<Response>
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
      );

      /// [response.statusCode] - Mã trạng thái HTTP
      /// - 200: Thành công
      /// - 404: Không tìm thấy
      /// - 500: Lỗi server
      _statusCode = response.statusCode;

      /// [response.body] - Nội dung response (String)
      /// Đây là JSON string, cần parse nếu muốn dùng như object
      _responseText = response.body;
    } catch (e) {
      /// [Error handling]
      /// Bắt lỗi kết nối, timeout, etc.
      _error = 'Lỗi: $e';
    } finally {
      // 2. Kết thúc loading (luôn chạy dù success hay error)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex01: Simple GET')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nút gọi API
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchUser,
              icon: const Icon(Icons.download),
              label: Text(_isLoading ? 'Đang tải...' : 'Fetch User'),
            ),

            const SizedBox(height: 16),

            // Hiển thị status code
            if (_statusCode != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _statusCode == 200
                      ? Colors.green[100]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Status Code: $_statusCode ${_statusCode == 200 ? "✅" : "❌"}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 16),

            // Hiển thị loading indicator
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Hiển thị lỗi
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            // Hiển thị response
            if (_responseText.isNotEmpty && !_isLoading)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _responseText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
