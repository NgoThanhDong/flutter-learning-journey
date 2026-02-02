/// ===========================================
/// EXERCISE 14: SHOPPING CART (Practice)
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Áp dụng Provider vào project thực tế
/// - Cart với đầy đủ CRUD
/// - Navigation giữa các screens

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
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    this.category = 'General',
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

/// ===========================================
/// SAMPLE DATA
/// ===========================================
const sampleProducts = [
  Product(
    id: '1',
    name: 'Espresso',
    price: 3.50,
    emoji: '☕',
    category: 'Coffee',
  ),
  Product(id: '2', name: 'Latte', price: 4.50, emoji: '🥛', category: 'Coffee'),
  Product(
    id: '3',
    name: 'Cappuccino',
    price: 4.00,
    emoji: '☕',
    category: 'Coffee',
  ),
  Product(
    id: '4',
    name: 'Croissant',
    price: 2.50,
    emoji: '🥐',
    category: 'Food',
  ),
  Product(id: '5', name: 'Muffin', price: 3.00, emoji: '🧁', category: 'Food'),
  Product(
    id: '6',
    name: 'Sandwich',
    price: 5.50,
    emoji: '🥪',
    category: 'Food',
  ),
  Product(
    id: '7',
    name: 'Iced Tea',
    price: 3.00,
    emoji: '🍵',
    category: 'Drinks',
  ),
  Product(
    id: '8',
    name: 'Smoothie',
    price: 5.00,
    emoji: '🥤',
    category: 'Drinks',
  ),
];

/// ===========================================
/// CART NOTIFIER
/// ===========================================
class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

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

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
}

/// ===========================================
/// APP
/// ===========================================
class Ex14ShoppingCart extends StatelessWidget {
  const Ex14ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee Shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const _MenuScreen(),
      ),
    );
  }
}

/// ===========================================
/// MENU SCREEN
/// ===========================================
class _MenuScreen extends StatelessWidget {
  const _MenuScreen();

  @override
  Widget build(BuildContext context) {
    final categories = sampleProducts.map((p) => p.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Coffee Shop'),
        actions: [
          // Cart button with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _CartScreen()),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Consumer<CartNotifier>(
                  builder: (context, cart, _) {
                    if (cart.itemCount == 0) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final products = sampleProducts
              .where((p) => p.category == category)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 24),
              Text(
                category,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...products.map((product) => _ProductTile(product: product)),
            ],
          );
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    final isInCart = cart.isInCart(product.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(product.emoji, style: const TextStyle(fontSize: 32)),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: isInCart
            ? IconButton.filled(
                onPressed: () => cart.removeFromCart(product.id),
                icon: const Icon(Icons.check),
              )
            : IconButton.filledTonal(
                onPressed: () => cart.addToCart(product),
                icon: const Icon(Icons.add),
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
              child: const Text('Clear'),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Your cart is empty'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return _CartItemTile(cartItem: cart.items[index]);
                    },
                  ),
                ),
                // Checkout section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 16)),
                            Text(
                              '\$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Order placed!')),
                              );
                              cart.clearCart();
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text('Place Order'),
                            ),
                          ),
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

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartNotifier>();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(cartItem.product.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${cartItem.product.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => cart.updateQuantity(
                    cartItem.product.id,
                    cartItem.quantity - 1,
                  ),
                ),
                Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => cart.updateQuantity(
                    cartItem.product.id,
                    cartItem.quantity + 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
