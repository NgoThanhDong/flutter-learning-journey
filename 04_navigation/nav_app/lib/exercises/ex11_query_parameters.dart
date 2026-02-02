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

class Ex11QueryParameters extends StatelessWidget {
  const Ex11QueryParameters({super.key});

  @override
  Widget build(BuildContext context) {
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

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchInputScreen extends StatefulWidget {
  const SearchInputScreen({super.key});

  @override
  State<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen> {
  final _controller = TextEditingController();

  void _search() {
    final keyword = _controller.text.trim();
    if (keyword.isEmpty) return;

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
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nhập từ khóa',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: const Text('Tìm kiếm 🔎'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultScreen extends StatelessWidget {
  final String keyword;

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
              keyword.isEmpty ? 'Trống' : '"$keyword"',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () => context.go('/'),
              child: const Text('Tìm cái khác'),
            ),
          ],
        ),
      ),
    );
  }
}
