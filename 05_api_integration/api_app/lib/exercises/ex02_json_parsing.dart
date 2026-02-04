/// ===========================================
/// EXERCISE 02: JSON PARSING
/// ===========================================
/// 🎯 Mục tiêu:
/// - Parse JSON string thành Dart Map
/// - Truy xuất các field từ Map
/// - Hiển thị dữ liệu đã parse đẹp hơn
///
/// 📝 Giải thích:
/// - [jsonDecode()] chuyển JSON string → Dart object (Map hoặc List)
/// - Kết quả là [Map<String, dynamic>] hoặc [List<dynamic>]

library;

import 'dart:convert'; // Cần import để dùng jsonDecode

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*
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
}
*/

/// ===========================================
/// EXERCISE 02: JSON PARSING
/// ===========================================
// Ex02JsonParsing là StatefulWidget để hiển thị kết quả GET request
class Ex02JsonParsing extends StatefulWidget {
  const Ex02JsonParsing({super.key});

  @override
  State<Ex02JsonParsing> createState() => _Ex02JsonParsingState();
}

// _Ex02JsonParsingState là State của Ex02JsonParsing
class _Ex02JsonParsingState extends State<Ex02JsonParsing> {
  // _isLoading là biến boolean để kiểm tra trạng thái tải
  bool _isLoading = false;

  /// [Parsed data]
  /// Thay vì lưu String, ta lưu Map đã parse
  Map<String, dynamic>? _userData;
  String? _error; // _error là biến String để lưu thông báo lỗi

  // _fetchAndParseUser là hàm async để fetch data từ API và parse JSON
  // Hàm này sẽ được gọi khi nhấn nút "Fetch & Parse JSON"
  Future<void> _fetchAndParseUser() async {
    // setState được gọi để thông báo cho Flutter rằng có sự thay đổi trạng thái
    // và widget cần được rebuild
    setState(() {
      // _isLoading được set thành true để hiển thị CircularProgressIndicator
      _isLoading = true;
      // _error được set thành null để xóa thông báo lỗi cũ
      _error = null;
    });

    // try-catch block để bắt lỗi
    try {
      // http.get() được gọi để fetch data từ API
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
      );

      // if-else block để kiểm tra trạng thái response
      if (response.statusCode == 200) {
        /// [jsonDecode] - Parse JSON string → Dart object
        ///
        /// Input: '{"id": 1, "name": "John"}'
        /// Output: {'id': 1, 'name': 'John'} (Map<String, dynamic>)
        ///
        /// Nếu JSON là array [...], output sẽ là List<dynamic>
        final data = jsonDecode(response.body);

        /// [Type casting]
        /// jsonDecode trả về dynamic, cast về Map để có autocomplete
        _userData = data as Map<String, dynamic>;
      } else {
        // else block sẽ được gọi nếu response.statusCode != 200
        _error = 'Lỗi: Status ${response.statusCode}';
      }
    } catch (e) {
      // catch block sẽ bắt lỗi nếu có
      _error = 'Lỗi parse JSON: $e';
    } finally {
      // finally block sẽ được gọi dù có lỗi hay không
      // _isLoading được set thành false để ẩn CircularProgressIndicator
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex02: JSON Parsing')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ElevatedButton.icon là widget để tạo nút có icon và label
            // onPressed là callback function sẽ được gọi khi nút được nhấn
            // _isLoading ? null : _fetchAndParseUser là conditional expression
            // Nếu _isLoading là true, nút sẽ bị disable (onPressed = null)
            // Nếu _isLoading là false, nút sẽ được enable và gọi _fetchAndParseUser
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchAndParseUser,
              icon: const Icon(Icons.code),
              label: const Text('Fetch & Parse JSON'),
            ),

            const SizedBox(height: 20),

            // Nếu _isLoading là true, Center(child: CircularProgressIndicator()) sẽ được hiển thị
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Nếu _error != null, Text(_error!) sẽ được hiển thị
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            // Hiển thị dữ liệu đã parse
            if (_userData != null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// [Truy xuất field từ Map]
                        /// Sử dụng cú pháp map['key']
                        /// Kết quả là dynamic, cần cast nếu cần
                        _buildInfoRow('ID', _userData!['id'].toString()),
                        _buildInfoRow('Name', _userData!['name'] as String),
                        _buildInfoRow(
                          'Username',
                          _userData!['username'] as String,
                        ),
                        _buildInfoRow('Email', _userData!['email'] as String),
                        _buildInfoRow('Phone', _userData!['phone'] as String),
                        _buildInfoRow(
                          'Website',
                          _userData!['website'] as String,
                        ),

                        const Divider(),

                        /// [Nested object]
                        /// Nếu value là object, nó sẽ là Map<String, dynamic>
                        const Text(
                          'Address (Nested):',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Truy xuất nested object
                        Builder(
                          builder: (context) {
                            // address là nested object
                            // _userData!['address'] là Map<String, dynamic>
                            // address['street'] là String
                            // address['city'] là String
                            // address['zipcode'] là String
                            final address =
                                _userData!['address'] as Map<String, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('  Street: ${address['street']}'),
                                Text('  City: ${address['city']}'),
                                Text('  Zipcode: ${address['zipcode']}'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // _buildInfoRow là hàm private để build từng row
  // label: Label của row
  // value: Value của row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
