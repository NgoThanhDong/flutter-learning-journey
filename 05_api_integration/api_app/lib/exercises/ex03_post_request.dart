/// ===========================================
/// EXERCISE 03: POST REQUEST
/// ===========================================
/// 🎯 Mục tiêu:
/// - Gửi POST request với body
/// - Thiết lập headers (Content-Type)
/// - Xử lý response từ POST
///
/// 📝 Giải thích:
/// - POST dùng để tạo mới resource
/// - Body chứa dữ liệu gửi lên server
/// - Headers cho biết định dạng body

library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ex03PostRequest extends StatefulWidget {
  const Ex03PostRequest({super.key});

  @override
  State<Ex03PostRequest> createState() => _Ex03PostRequestState();
}

class _Ex03PostRequestState extends State<Ex03PostRequest> {
  /// [Controllers] - Quản lý input từ TextField
  final _titleController = TextEditingController(text: 'My First Post');
  final _bodyController = TextEditingController(
    text: 'This is the content of my post',
  );

  bool _isLoading = false;
  Map<String, dynamic>? _createdPost;
  String? _error;

  /// [POST Request]
  Future<void> _createPost() async {
    // Validate input
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      setState(() => _error = 'Vui lòng nhập đủ thông tin');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _createdPost = null;
    });

    try {
      /// [http.post] - Gửi POST request
      ///
      /// Tham số:
      /// - Uri: URL endpoint
      /// - headers: Metadata của request
      /// - body: Dữ liệu gửi lên (phải là String)
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),

        /// [Headers]
        /// Content-Type: cho server biết body là JSON
        /// charset=UTF-8: hỗ trợ tiếng Việt và ký tự đặc biệt
        headers: {'Content-Type': 'application/json; charset=UTF-8'},

        /// [Body]
        /// jsonEncode: Convert Map → JSON String
        /// Server chỉ nhận String, không nhận Map trực tiếp
        body: jsonEncode({
          'title': _titleController.text,
          'body': _bodyController.text,
          'userId': 1, // Giả lập user ID
        }),
      );

      /// [Status 201] - Created
      /// POST thành công thường trả về 201, không phải 200
      if (response.statusCode == 201) {
        _createdPost = jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        _error = 'Lỗi: Status ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Lỗi: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex03: POST Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Giải thích
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '💡 POST request tạo resource mới trên server.\n'
                  'JSONPlaceholder sẽ giả lập việc tạo và trả về ID.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Input Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 12),

            // Input Body
            TextField(
              controller: _bodyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.article),
              ),
            ),

            const SizedBox(height: 16),

            // Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _createPost,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_isLoading ? 'Đang gửi...' : 'Create Post (POST)'),
            ),

            const SizedBox(height: 16),

            // Error
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),

            // Response
            if (_createdPost != null)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Post Created! (Status 201)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text('ID: ${_createdPost!['id']}'),
                      Text('Title: ${_createdPost!['title']}'),
                      Text('Body: ${_createdPost!['body']}'),
                      Text('User ID: ${_createdPost!['userId']}'),
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
