/// ===========================================
/// EXERCISE 17: E-COMMERCE NAVIGATION
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xây dựng hệ thống navigation cho app bán hàng
/// - Danh sách -> Chi tiết (kèm Hero animation) -> Giỏ hàng
/// - Back navigation hợp lý
///
/// 📝 Routes:
/// - / (List)
/// - /product/:id (Detail)
/// - /cart (Cart)

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Mock Data
final products = List.generate(
  10,
  (i) => {'id': '$i', 'name': 'Sản phẩm $i', 'price': '${(i + 1) * 100}k'},
);

class Ex17EcommerceRoutes extends StatelessWidget {
  const Ex17EcommerceRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const StoreHomeScreen(),
          routes: [
            GoRoute(
              path: 'product/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                // Tìm sản phẩm từ ID mock
                final product = products.firstWhere(
                  (p) => p['id'] == id,
                  orElse: () => {'id': id, 'name': 'Unknown', 'price': '0'},
                );
                return ProductDetailScreen(product: product);
              },
            ),
            GoRoute(
              path: 'cart',
              pageBuilder: (context, state) => const MaterialPage(
                fullscreenDialog: true, // Mở kiểu modal từ dưới lên (iOS style)
                child: CartScreen(),
              ),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    );
  }
}

class StoreHomeScreen extends StatelessWidget {
  const StoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Flutter Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return GestureDetector(
            onTap: () => context.go('/product/${p['id']}'),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['name']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          p['price']!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name']!)),
      body: Column(
        children: [
          Container(
            height: 300,
            color: Colors.grey.shade300,
            width: double.infinity,
            child: const Icon(Icons.image, size: 100, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['name']!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      product['price']!,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mô tả chi tiết sản phẩm sẽ ở đây. Chất lượng tuyệt vời, giá cả phải chăng.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton.icon(
            onPressed: () {
              // Add to cart logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Thêm vào giỏ'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng 🛒')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text('Giỏ hàng của bạn đang trống'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
