/// ===========================================
/// EXERCISE 07: SHOPPING CART VỚI PROVIDER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Xây dựng Cart state phức tạp hơn
/// - Hiểu cách tính toán derived state (total, itemCount)
/// - Kết hợp nhiều screens (Products, Cart)
///
/// 📝 Yêu cầu:
/// - CartNotifier với add, remove, update quantity
/// - Product list + Cart badge
/// - Cart screen với total

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// MODELS
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

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  /// [Derived value] Tính tổng tiền của item này
  double get subtotal => product.price * quantity;
}

/// ===========================================
/// SAMPLE DATA
/// ===========================================
final sampleProducts = [
  const Product(id: '1', name: 'iPhone 15 Pro', price: 999, emoji: '📱'),
  const Product(id: '2', name: 'MacBook Pro', price: 2499, emoji: '💻'),
  const Product(id: '3', name: 'AirPods Pro', price: 249, emoji: '🎧'),
  const Product(id: '4', name: 'iPad Pro', price: 799, emoji: '📲'),
  const Product(id: '5', name: 'Apple Watch', price: 399, emoji: '⌚'),
  const Product(id: '6', name: 'Magic Keyboard', price: 299, emoji: '⌨️'),
];

/// ===========================================
/// CART NOTIFIER
/// ===========================================
class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// [Getter] Danh sách items trong cart
  List<CartItem> get items => List.unmodifiable(_items);

  /// [Derived: itemCount] Tổng số lượng sản phẩm
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// [Derived: total] Tổng tiền
  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// [Method] Thêm sản phẩm vào cart
  void addToCart(Product product) {
    // Kiểm tra sản phẩm đã có trong cart chưa
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Đã có → tăng quantity
      _items[index].quantity++;
    } else {
      // Chưa có → thêm mới
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  /// [Method] Xóa sản phẩm khỏi cart
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// [Method] Cập nhật số lượng
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  /// [Method] Xóa toàn bộ cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// [Helper] Kiểm tra sản phẩm có trong cart không
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// [Helper] Lấy quantity của sản phẩm trong cart
  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: const Product(id: '', name: '', price: 0, emoji: ''),
      ),
    );
    return item.quantity;
  }
}

/// ===========================================
/// APP VỚI PROVIDER
/// ===========================================
class Ex07CartProvider extends StatelessWidget {
  const Ex07CartProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping Cart',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
class _ProductsScreen extends StatelessWidget {
  const _ProductsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // Cart icon với badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _CartScreen()),
                  );
                },
              ),
              // Badge hiển thị số lượng
              Positioned(
                top: 8,
                right: 8,
                child: Consumer<CartNotifier>(
                  builder: (context, cart, _) {
                    if (cart.itemCount == 0) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: sampleProducts.length,
        itemBuilder: (context, index) {
          return _ProductCard(product: sampleProducts[index]);
        },
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
    final cart = context.watch<CartNotifier>();
    final isInCart = cart.isInCart(product.id);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(product.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: isInCart
                  ? OutlinedButton.icon(
                      onPressed: () => cart.removeFromCart(product.id),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('In Cart'),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => cart.addToCart(product),
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('Add'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===========================================
/// CART SCREEN
/// ===========================================
class _CartScreen extends StatelessWidget {
  const _CartScreen();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => cart.clearCart(),
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Giỏ hàng trống', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return _CartItemTile(cartItem: cart.items[index]);
                    },
                  ),
                ),
                // Total section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '\$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checkout not implemented'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// ===========================================
/// CART ITEM TILE
/// ===========================================
class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartNotifier>();

    return ListTile(
      leading: Text(
        cartItem.product.emoji,
        style: const TextStyle(fontSize: 32),
      ),
      title: Text(cartItem.product.name),
      subtitle: Text('\$${cartItem.product.price.toStringAsFixed(0)} each'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              cart.updateQuantity(cartItem.product.id, cartItem.quantity - 1);
            },
          ),
          Text(
            '${cartItem.quantity}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              cart.updateQuantity(cartItem.product.id, cartItem.quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
