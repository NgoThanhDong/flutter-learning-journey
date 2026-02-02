/// ===========================================
/// EXERCISE 08: ON GENERATE ROUTE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xử lý routes động (dynamic routes)
/// - Xử lý trường hợp route không tồn tại (404)
///
/// 📝 Giải thích:
/// - [onGenerateRoute]: Được gọi khi push một named route.
/// - Cho phép ta check settings.name, xử lý logic, rồi trả về Route tương ứng.
/// - [onUnknownRoute]: Được gọi khi onGenerateRoute trả về null (lỗi 404).

library;

import 'package:flutter/material.dart';

class Ex08OnGenerateRoute extends StatelessWidget {
  const Ex08OnGenerateRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OnGenerateRoute Demo',
      initialRoute: '/',

      /// [onGenerateRoute]
      /// Kiểm soát toàn bộ logic điều hướng
      onGenerateRoute: (settings) {
        // settings.name: tên route (vd: '/detail')
        // settings.arguments: arguments truyền theo
        debugPrint('Navigating to: ${settings.name}');

        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const HomeScreen());
        }

        // Xử lý route '/detail'
        if (settings.name == '/detail') {
          // Lấy argument, nếu không có thì gán mặc định
          final args = settings.arguments as String? ?? 'Không có ID';

          return MaterialPageRoute(builder: (_) => DetailScreen(id: args));
        }

        // Nếu không khớp route nào -> Trả về null để Flutter gọi onUnknownRoute
        return null;
      },

      /// [onUnknownRoute] (Giống trang 404 trên Web)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: 'Product-123',
                );
              },
              child: const Text('Go to Detail (Valid) 👉'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Route này chưa được định nghĩa -> Sẽ vào trang 404
                Navigator.pushNamed(context, '/xyz-random-route');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
              ),
              child: const Text('Go to Random Route (Invalid) 🚫'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Text('Product ID: $id', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lỗi (404)')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Không tìm thấy trang này!', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
