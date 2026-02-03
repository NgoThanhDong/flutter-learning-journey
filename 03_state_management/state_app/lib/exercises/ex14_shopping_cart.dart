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
/// [Product] là model cho sản phẩm
class Product {
  final String id; // [id] là id của sản phẩm
  final String name; // [name] là tên của sản phẩm
  final double price; // [price] là giá của sản phẩm
  final String emoji; // [emoji] là emoji của sản phẩm
  final String category; // [category] là loại của sản phẩm

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    this.category = 'General',
  });
}

/// [CartItem] là model cho item trong cart
class CartItem {
  final Product product; // [product] là sản phẩm
  int quantity; // [quantity] là số lượng

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity; // [subtotal] là tổng tiền
}

/// ===========================================
/// SAMPLE DATA
/// ===========================================
/// [sampleProducts] là danh sách sản phẩm mẫu
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
/// [CartNotifier] là notifier cho cart
class CartNotifier extends ChangeNotifier {
  /// [_items] là danh sách item trong cart
  final List<CartItem> _items = [];

  /// [items] là danh sách item trong cart
  List<CartItem> get items => List.unmodifiable(_items);

  /// [itemCount] là số lượng item trong cart
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// [total] là tổng tiền trong cart
  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// [addToCart] thêm sản phẩm vào cart
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    /// Nếu sản phẩm đã có trong cart, tăng số lượng
    /// Nếu không, thêm sản phẩm vào cart
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  /// [removeFromCart] xóa sản phẩm khỏi cart
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// [updateQuantity] cập nhật số lượng sản phẩm trong cart
  void updateQuantity(String productId, int quantity) {
    // indexWhere() trả về index của item trong cart
    final index = _items.indexWhere((item) => item.product.id == productId);

    /// Nếu sản phẩm có trong cart, cập nhật số lượng
    /// Nếu quantity <= 0, xóa sản phẩm khỏi cart
    /// Nếu quantity > 0, cập nhật số lượng
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  /// [clearCart] xóa toàn bộ cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// [isInCart] kiểm tra sản phẩm có trong cart không
  bool isInCart(String productId) {
    // any() trả về true nếu có ít nhất một item trong cart
    return _items.any((item) => item.product.id == productId);
  }
}

/// ===========================================
/// APP
/// ===========================================
/// [Ex14ShoppingCart] là app chính
class Ex14ShoppingCart extends StatelessWidget {
  const Ex14ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    /// [ChangeNotifierProvider] cung cấp [CartNotifier] cho toàn bộ app
    /// create: (_) => CartNotifier() tạo [CartNotifier] và cung cấp cho toàn bộ app
    /// child: MaterialApp() là widget con của [ChangeNotifierProvider]
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
/// [_MenuScreen] là màn hình menu
class _MenuScreen extends StatelessWidget {
  const _MenuScreen();

  @override
  Widget build(BuildContext context) {
    /// [categories] là danh sách category từ [sampleProducts]
    final categories = sampleProducts.map((p) => p.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Coffee Shop'),
        actions: [
          // Cart button with badge
          // Stack là widget chứa các widget con chồng lên nhau
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  /// [Navigator.push] push [CartScreen] vào stack
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _CartScreen()),
                  );
                },
              ),

              /// [Positioned] là widget để đặt widget con ở vị trí cụ thể
              Positioned(
                top: 8,
                right: 8,

                /// [Consumer] là widget để consume [CartNotifier]
                child: Consumer<CartNotifier>(
                  builder: (context, cart, _) {
                    /// [cart.itemCount] là số lượng item trong cart
                    /// [cart.itemCount == 0] kiểm tra cart có item không
                    /// [return const SizedBox()] không có item thì return SizedBox
                    /// [else] có item thì return Container
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

      /// [body] là widget con của [Scaffold]
      /// [ListView.builder] là widget để tạo list view
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index]; // Lấy category từ list
          final products = sampleProducts
              .where((p) => p.category == category)
              .toList(); // Lấy sản phẩm theo category

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// [if (index > 0) const SizedBox(height: 24)] thêm khoảng cách
              if (index > 0) const SizedBox(height: 24),

              /// [Text] là widget để hiển thị text
              /// [category] là category từ list
              Text(
                category,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              /// [products.map((product) => _ProductTile(product: product))] map sản phẩm
              /// ... là toán tử spread
              ...products.map((product) => _ProductTile(product: product)),
            ],
          );
        },
      ),
    );
  }
}

/// ===========================================
/// PRODUCT TILE
/// ===========================================
/// [_ProductTile] là widget để hiển thị sản phẩm
class _ProductTile extends StatelessWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    // Lấy cart
    // [context.watch<CartNotifier>()] là widget để watch [CartNotifier]
    final cart = context.watch<CartNotifier>();

    // Kiểm tra sản phẩm có trong cart không
    final isInCart = cart.isInCart(product.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(product.emoji, style: const TextStyle(fontSize: 32)),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),

        /// [isInCart] là boolean
        /// [isInCart] kiểm tra sản phẩm có trong cart không
        /// [isInCart] nếu có thì return IconButton.filled
        /// [isInCart] nếu không thì return IconButton.filledTonal
        trailing: isInCart
            // IconButton.filled là widget để hiển thị button với style filled
            ? IconButton.filled(
                onPressed: () => cart.removeFromCart(product.id),
                icon: const Icon(Icons.check),
              )
            // IconButton.filledTonal là widget để hiển thị button với style filledTonal
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
/// [_CartScreen] là màn hình cart khi click vào icon cart ở appBar
class _CartScreen extends StatelessWidget {
  const _CartScreen();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          // Nếu cart có item thì hiển thị button clear
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => cart.clearCart(),
              child: const Text('Clear'),
            ),
        ],
      ),

      // Nếu cart không có item thì hiển thị màn hình empty
      // Nếu cart có item thì hiển thị màn hình cart
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

                // Place order section
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

                  // SafeArea là widget để đảm bảo widget không bị ẩn khi có status bar
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Hiển thị text Total
                            const Text('Total', style: TextStyle(fontSize: 16)),
                            // Hiển thị giá total
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
                              // Hiển thị snackbar khi click vào button place order
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Order placed!')),
                              );
                              // Xóa cart
                              cart.clearCart();
                              // Trở về màn hình home
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

/// ===========================================
/// CART ITEM TILE
/// ===========================================
/// [_CartItemTile] là widget để hiển thị item trong cart
class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    // Lấy cart
    // [context.read<CartNotifier>()] là widget để read [CartNotifier]
    final cart = context.read<CartNotifier>();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Hiển thị emoji của sản phẩm
            Text(cartItem.product.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            // Hiển thị thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị tên sản phẩm
                  Text(
                    cartItem.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Hiển thị giá sản phẩm
                  Text('\$${cartItem.product.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
            // Hiển thị số lượng và nút add, remove
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  // Khi click vào nút remove, giảm số lượng sản phẩm
                  onPressed: () => cart.updateQuantity(
                    cartItem.product.id,
                    cartItem.quantity - 1,
                  ),
                ),
                // Hiển thị số lượng
                Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  // Khi click vào nút add, tăng số lượng sản phẩm
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
