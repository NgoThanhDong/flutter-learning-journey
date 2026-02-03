/// ===========================================
/// EXERCISE 07: ROUTE ARGUMENTS
/// ===========================================
/// 🎯 Mục tiêu:
/// - Truyền tham số cho Named Routes (ví dụ: id, title)
/// - Trích xuất tham số từ ModalRoute
///
/// 📝 Giải thích:
/// - Navigator.pushNamed(context, '/route', arguments: data)
/// - ModalRoute.of(context)!.settings.arguments as T

library;

import 'package:flutter/material.dart';

// Class chứa arguments để truyền đi
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

// Ex07RouteArguments là widget màn hình chính của bài tập 7
class Ex07RouteArguments extends StatelessWidget {
  const Ex07RouteArguments({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Định nghĩa routes
      routes: {
        '/': (context) => const HomeScreen(),
        '/extract': (context) => const ExtractArgumentsScreen(),
      },
    );
  }
}

// HomeScreen là màn hình đầu tiên, màn hình Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /// [Truyền Arguments]
            /// Tham số 'arguments' chấp nhận bất kỳ Object nào (Object?)
            Navigator.pushNamed(
              context,
              '/extract',
              arguments: ScreenArguments(
                'Extract Arguments Screen', // title
                'Đây là message được truyền từ Home.', // message
              ),
            );
          },
          child: const Text('Gửi Data qua Route 👉'),
        ),
      ),
    );
  }
}

// ExtractArgumentsScreen là màn hình thứ hai, màn hình nhận data
class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// [Lấy Arguments]
    /// Cần ép kiểu (cast) về đúng kiểu dữ liệu mong muốn.
    /// ModalRoute.of(context)!.settings.arguments có thể null.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title), // Sử dụng title từ arguments
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Data nhận được:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  args.message, // Sử dụng message từ arguments
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              OutlinedButton(
                // [Navigator.pop]
                // Quay về màn hình trước đó
                onPressed: () => Navigator.pop(context),
                child: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
