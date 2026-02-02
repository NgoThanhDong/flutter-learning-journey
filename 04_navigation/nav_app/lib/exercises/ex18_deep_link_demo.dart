/// ===========================================
/// EXERCISE 18: DEEP LINK DEMO
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu cách hoạt động của URL parameters
/// - Thử nghiệm đổi URL trên browser và thấy app update
///
/// 📝 Cách dẫn:
/// 1. Chạy app (flutter run -d chrome).
/// 2. Đổi URL trên thanh địa chỉ:
///    - localhost:port/ -> Home
///    - localhost:port/promo/SUMMER25 -> Promo Screen
///
/// Chú ý: Cần config 'Path Url Strategy' ở main.dart để bỏ dấu '#' thì URL mới đẹp.
/// Bài này giả định đang dùng Hash Strategy mặc định (có dấu #) cho đơn giản.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Ex18DeepLinkDemo extends StatelessWidget {
  const Ex18DeepLinkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const DeepLinkHome(),
            routes: [
              GoRoute(
                path: 'promo/:code',
                builder: (context, state) {
                  return PromoScreen(code: state.pathParameters['code']);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeepLinkHome extends StatelessWidget {
  const DeepLinkHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep Link Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thử nhập URL này vào trình duyệt:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: const SelectableText('.../#/promo/HELLO_WORLD'),
            ),
            const SizedBox(height: 20),
            const Text('Hoặc nhấn nút dưới đây:'),
            ElevatedButton(
              onPressed: () => context.go('/promo/FLUTTER_DEAL_50'),
              child: const Text('Mở Promo Deal'),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoScreen extends StatelessWidget {
  final String? code;

  const PromoScreen({super.key, this.code});

  @override
  Widget build(BuildContext context) {
    bool isValid = code != null && code!.length > 5;

    return Scaffold(
      appBar: AppBar(title: const Text('Promo Deal')),
      body: Center(
        child: Card(
          color: isValid ? Colors.green.shade50 : Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isValid ? Icons.verified : Icons.error,
                  size: 60,
                  color: isValid ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 20),
                Text(
                  'Promo Code:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  code ?? 'Unknown',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isValid
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                if (isValid)
                  const Text('🎉 Mã hợp lệ! Bạn được giảm giá 50%')
                else
                  const Text('❌ Mã không hợp lệ'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
