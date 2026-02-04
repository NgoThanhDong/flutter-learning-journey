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

// [Deep Link Demo]
// Demo cách hoạt động của URL parameters
class Ex18DeepLinkDemo extends StatelessWidget {
  const Ex18DeepLinkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // routerConfig: GoRouter: Cấu hình router
      // initialLocation: '/': Vị trí ban đầu
      // routes: Danh sách các route
      // GoRoute: Định nghĩa một route
      // path: Đường dẫn của route
      // builder: Widget được hiển thị khi route được gọi
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const DeepLinkHome(), // Home screen
            routes: [
              GoRoute(
                path: 'promo/:code',
                builder: (context, state) {
                  // state.pathParameters: Map chứa các tham số đường dẫn
                  // 'code': Tên tham số được định nghĩa trong path
                  // state.pathParameters['code']: Lấy giá trị của tham số 'code'
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

// [Deep Link Home]
// DeepLinkHome là home screen
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
              // Điều hướng đến route 'promo' với tham số 'code' là 'FLUTTER_DEAL_50'
              onPressed: () => context.go('/promo/FLUTTER_DEAL_50'),
              child: const Text('Mở Promo Deal - FLUTTER_DEAL_50'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              // Điều hướng đến route 'promo' với tham số 'code' là 'FLUTTER_DEAL_50'
              onPressed: () => context.go('/promo/ERROR'),
              child: const Text('Mở Promo Deal - ERROR'),
            ),
          ],
        ),
      ),
    );
  }
}

// [Promo Screen]
// Promo screen hiển thị thông tin mã giảm giá
class PromoScreen extends StatelessWidget {
  final String? code; // Mã giảm giá

  const PromoScreen({super.key, this.code});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra tính hợp lệ của mã giảm giá
    bool isValid = code != null && code!.length > 5;

    return Scaffold(
      appBar: AppBar(title: const Text('Promo Deal')),
      body: Center(
        child: Card(
          // Màu sắc của card dựa trên tính hợp lệ của mã giảm giá
          color: isValid ? Colors.green.shade50 : Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Kiểm tra tính hợp lệ của mã giảm giá
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
