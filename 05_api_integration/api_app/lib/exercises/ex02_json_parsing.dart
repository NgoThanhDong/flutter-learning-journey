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

class Ex02JsonParsing extends StatefulWidget {
  const Ex02JsonParsing({super.key});

  @override
  State<Ex02JsonParsing> createState() => _Ex02JsonParsingState();
}

class _Ex02JsonParsingState extends State<Ex02JsonParsing> {
  bool _isLoading = false;

  /// [Parsed data]
  /// Thay vì lưu String, ta lưu Map đã parse
  Map<String, dynamic>? _userData;
  String? _error;

  Future<void> _fetchAndParseUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
      );

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
        _error = 'Lỗi: Status ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Lỗi parse JSON: $e';
    } finally {
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
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchAndParseUser,
              icon: const Icon(Icons.code),
              label: const Text('Fetch & Parse JSON'),
            ),

            const SizedBox(height: 20),

            if (_isLoading) const Center(child: CircularProgressIndicator()),

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
