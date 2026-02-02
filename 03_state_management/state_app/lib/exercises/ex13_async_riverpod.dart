/// ===========================================
/// EXERCISE 13: ASYNC DATA VỚI RIVERPOD
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Sử dụng FutureProvider cho async data
/// - Handle loading, error, data states với .when()
/// - Refresh data
///
/// 📝 Yêu cầu:
/// - FutureProvider fake API call
/// - AsyncValue.when() để handle states
/// - Refresh button

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===========================================
/// MODEL
/// ===========================================
class Product {
  final String id;
  final String name;
  final double price;
  final String emoji;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
  });
}

/// ===========================================
/// FAKE API SERVICE
/// ===========================================
class FakeProductApi {
  static Future<List<Product>> fetchProducts() async {
    debugPrint('📡 Fetching products from API...');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Fake random error (20% chance)
    // if (DateTime.now().second % 5 == 0) {
    //   throw Exception('Network error! Please try again.');
    // }

    return const [
      Product(id: '1', name: 'MacBook Pro', price: 2499, emoji: '💻'),
      Product(id: '2', name: 'iPhone 15 Pro', price: 999, emoji: '📱'),
      Product(id: '3', name: 'AirPods Pro', price: 249, emoji: '🎧'),
      Product(id: '4', name: 'iPad Pro', price: 799, emoji: '📲'),
      Product(id: '5', name: 'Apple Watch', price: 399, emoji: '⌚'),
      Product(id: '6', name: 'Magic Mouse', price: 99, emoji: '🖱️'),
    ];
  }
}

/// ===========================================
/// PROVIDERS
/// ===========================================
/// [FutureProvider] cho async data
/// Tự động handle loading, error, data states
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return await FakeProductApi.fetchProducts();
});

/// [Computed provider] Tính tổng giá trị
final totalValueProvider = Provider<AsyncValue<double>>((ref) {
  return ref
      .watch(productsProvider)
      .whenData((products) => products.fold(0.0, (sum, p) => sum + p.price));
});

/// ===========================================
/// APP
/// ===========================================
class Ex13AsyncRiverpod extends StatelessWidget {
  const Ex13AsyncRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const _ProductsScreen(),
      ),
    );
  }
}

/// ===========================================
/// PRODUCTS SCREEN
/// ===========================================
class _ProductsScreen extends ConsumerWidget {
  const _ProductsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [AsyncValue] Đại diện cho 3 states: loading, error, data
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex13: Async Riverpod'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              /// [ref.invalidate] Force refetch
              ref.invalidate(productsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Total value header
          const _TotalHeader(),

          const Divider(height: 1),

          // Products list
          Expanded(
            /// [AsyncValue.when] Pattern matching cho 3 states
            child: productsAsync.when(
              /// [loading] Đang fetch data
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading products...'),
                  ],
                ),
              ),

              /// [error] Có lỗi xảy ra
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => ref.invalidate(productsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),

              /// [data] Fetch thành công
              data: (products) => ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _ProductCard(product: product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// TOTAL HEADER
/// ===========================================
class _TotalHeader extends ConsumerWidget {
  const _TotalHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAsync = ref.watch(totalValueProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.indigo.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Value:', style: TextStyle(fontSize: 16)),
          totalAsync.when(
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, _) => const Text('--'),
            data: (total) => Text(
              '\$${total.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// PRODUCT CARD
/// ===========================================
class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(product.emoji, style: const TextStyle(fontSize: 32)),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(0)}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
