/// ===========================================
/// EXERCISE 11: QUERY PARAMETERS (?key=value)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Sử dụng Query Parameters cho filter, search
/// - Lấy tham số từ state.uri.queryParameters
///
/// 📝 Giải thích:
/// - URL: /search?keyword=flutter&filter=all
/// - Query params là tùy chọn (optional), không bắt buộc phải có trong path.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Ex11QueryParameters là widget để demo Query Parameters
class Ex11QueryParameters extends StatelessWidget {
  const Ex11QueryParameters({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo router
    // GoRouter có thể có nhiều routes
    // Mỗi route có path và builder
    // builder: (context, state) => const SearchInputScreen(),
    // builder: (context, state) => const SearchResultScreen(keyword: keyword),
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SearchInputScreen(),
        ),
        GoRoute(
          path: '/results',
          builder: (context, state) {
            // Lấy query param 'q'
            final keyword = state.uri.queryParameters['q'] ?? '';
            return SearchResultScreen(keyword: keyword);
          },
        ),
      ],
    );

    // Tạo MaterialApp với router
    return MaterialApp.router(
      routerConfig: router, // Cấu hình router
      debugShowCheckedModeBanner: false, // Tắt banner debug
    );
  }
}

// SearchInputScreen là widget để demo Query Parameters
class SearchInputScreen extends StatefulWidget {
  const SearchInputScreen({super.key});

  @override
  State<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen> {
  final _controller = TextEditingController(); // Controller để nhập keyword

  // Hàm để xử lý tìm kiếm
  void _search() {
    final keyword = _controller.text.trim(); // Lấy keyword từ TextField
    if (keyword.isEmpty) return; // Nếu keyword trống, không tìm kiếm

    /// [Navigate với Query Params]
    /// Cách 1: String interpolation
    // context.go('/results?q=$keyword');

    /// Cách 2: Uri object (An toàn hơn với ký tự đặc biệt)
    context.go(
      Uri(path: '/results', queryParameters: {'q': keyword}).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller, // Controller để nhập keyword
              decoration: const InputDecoration(
                labelText: 'Nhập từ khóa',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) =>
                  _search(), // Khi Enter được nhấn, gọi _search()
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search, // Khi nút được nhấn, gọi _search()
              child: const Text('Tìm kiếm 🔎'),
            ),
          ],
        ),
      ),
    );
  }
}

// SearchResultScreen là widget để demo Query Parameters
class SearchResultScreen extends StatelessWidget {
  final String keyword; // Từ khóa tìm kiếm

  const SearchResultScreen({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bạn đang tìm kiếm:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              // Hiển thị từ khóa tìm kiếm
              keyword.isEmpty ? 'Trống' : '"$keyword"',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () => context.go('/'), // Quay lại trang chủ
              child: const Text('Tìm cái khác'),
            ),
          ],
        ),
      ),
    );
  }
}
