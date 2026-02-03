/// ===========================================
/// EXERCISE 07: SHOPPING CART VỚI PROVIDER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Xây dựng Cart state phức tạp hơn
/// - Hiểu cách tính toán derived state (total, itemCount) - Derived: được suy ra từ state khác
/// - Kết hợp nhiều screens (Products, Cart)
///
/// 📝 Yêu cầu:
/// - CartNotifier với add, remove, update quantity
/// - Product list + Cart badge - Badge: huy hiệu
/// - Cart screen với total

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// MODELS
/// ===========================================
// Product model dùng để lưu thông tin sản phẩm
class Product {
  final String id; // ID của sản phẩm
  final String name; // Tên sản phẩm
  final double price; // Giá sản phẩm
  final String emoji; // Emoji của sản phẩm

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
  });
}

// CartItem model dùng để lưu thông tin sản phẩm trong cart
class CartItem {
  final Product product; // Sản phẩm
  int quantity; // Số lượng

  CartItem({required this.product, this.quantity = 1});

  /// [Derived value] Tính tổng tiền của item này
  double get subtotal => product.price * quantity;
}

/// ===========================================
/// SAMPLE DATA
/// ===========================================
// Sample data dùng để test
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
// CartNotifier dùng để quản lý state của cart
class CartNotifier extends ChangeNotifier {
  // Danh sách các item trong cart
  final List<CartItem> _items = [];

  /// [Getter] Danh sách items trong cart
  // List.unmodifiable() để ngăn chặn việc thay đổi danh sách từ bên ngoài
  List<CartItem> get items => List.unmodifiable(_items);

  /// [Derived: itemCount] Tổng số lượng sản phẩm
  // fold() là một higher-order function dùng để duyệt qua danh sách và tính toán giá trị
  // 0 là giá trị khởi tạo
  // (sum, item) => sum + item.quantity là function dùng để tính toán giá trị
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// [Derived: total] Tổng tiền
  // 0.0 là giá trị khởi tạo
  // (sum, item) => sum + item.subtotal là function dùng để tính toán giá trị
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
    notifyListeners(); // Thông báo cho các widget lắng nghe biết state đã thay đổi
  }

  /// [Method] Xóa sản phẩm khỏi cart
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// [Method] Cập nhật số lượng
  void updateQuantity(String productId, int quantity) {
    // Tìm index của sản phẩm trong cart
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        // Nếu quantity <= 0 → xóa sản phẩm khỏi cart
        _items.removeAt(index);
      } else {
        // Nếu quantity > 0 → cập nhật quantity
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  /// [Method] Xóa toàn bộ cart
  void clearCart() {
    _items.clear(); // Xóa toàn bộ item trong cart
    notifyListeners();
  }

  /// [Helper] Kiểm tra sản phẩm có trong cart không
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// [Helper] Lấy quantity của sản phẩm trong cart
  int getQuantity(String productId) {
    // firstWhere() trả về item đầu tiên thỏa mãn điều kiện
    // orElse() trả về giá trị mặc định nếu không tìm thấy
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
// Ex07CartProvider là widget gốc của app
class Ex07CartProvider extends StatelessWidget {
  const Ex07CartProvider({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider dùng để cung cấp CartNotifier cho các widget con
    // create: (_) => CartNotifier() tạo ra một instance của CartNotifier
    // child: MaterialApp(...) là widget con
    return ChangeNotifierProvider(
      create: (_) => CartNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping Cart',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const _ProductsScreen(), // Màn hình hiển thị danh sách sản phẩm
      ),
    );
  }
}

/// ===========================================
/// PRODUCTS SCREEN
/// ===========================================
// _ProductsScreen là màn hình hiển thị danh sách sản phẩm
class _ProductsScreen extends StatelessWidget {
  const _ProductsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar hiển thị tiêu đề và icon cart
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // Cart icon với badge
          Stack(
            // Stack dùng để hiển thị icon và badge cùng nhau
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Khi nhấn vào icon cart → chuyển sang màn hình cart
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _CartScreen()),
                  );
                },
              ),

              // Badge hiển thị số lượng
              Positioned(
                // Positioned dùng để hiển thị badge ở vị trí cố định
                top: 8,
                right: 8,
                // Consumer<CartNotifier> lắng nghe sự thay đổi của CartNotifier
                child: Consumer<CartNotifier>(
                  // builder: (context, cart, _) => widget sẽ được build lại khi CartNotifier thay đổi
                  builder: (context, cart, _) {
                    // Nếu số lượng item trong cart bằng 0 → không hiển thị badge
                    if (cart.itemCount == 0) {
                      return const SizedBox(); // SizedBox() là widget rỗng
                    }

                    // Nếu số lượng item trong cart > 0 → hiển thị badge
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red, // Màu nền của badge
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // Bo góc của badge
                      ),
                      // Đảm bảo badge có kích thước tối thiểu 18x18
                      // BoxConstraints dùng để đảm bảo kích thước tối thiểu của widget
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      // Hiển thị số lượng item trong cart
                      child: Text(
                        '${cart.itemCount}', // Số lượng item trong cart
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

      // Màn hình hiển thị danh sách sản phẩm
      // GridView.builder dùng để hiển thị danh sách sản phẩm dưới dạng lưới
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        // SliverGridDelegateWithFixedCrossAxisCount dùng để hiển thị danh sách sản phẩm dưới dạng lưới
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số cột của lưới
          childAspectRatio: 0.8, // Tỷ lệ chiều rộng trên chiều cao của mỗi item
          crossAxisSpacing: 16, // Khoảng cách giữa các cột
          mainAxisSpacing: 16, // Khoảng cách giữa các hàng
        ),
        // itemCount là số lượng item trong danh sách
        itemCount: sampleProducts.length,
        // itemBuilder là hàm build từng item trong danh sách
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
// _ProductCard là widget hiển thị thông tin sản phẩm
class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    // context.watch<CartNotifier>() lắng nghe sự thay đổi của CartNotifier
    final cart = context.watch<CartNotifier>();
    // isInCart là biến boolean kiểm tra xem sản phẩm có trong cart không
    final isInCart = cart.isInCart(product.id);

    // Card hiển thị thông tin sản phẩm
    return Card(
      elevation: 2, // Độ cao của card
      child: Padding(
        padding: const EdgeInsets.all(12), // Khoảng cách bên trong card
        child: Column(
          // mainAxisAlignment dùng để căn chỉnh các widget con theo chiều dọc
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
              // Hiển thị giá sản phẩm
              // toStringAsFixed(0) dùng để làm tròn giá sản phẩm
              '\$${product.price.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // SizedBox dùng để đảm bảo kích thước tối thiểu của widget
            SizedBox(
              width: double.infinity, // max chiều rộng
              // isInCart là biến boolean kiểm tra xem sản phẩm có trong cart không
              // nếu có trong cart thì hiển thị OutlinedButton.icon
              // nếu không có trong cart thì hiển thị ElevatedButton.icon
              child: isInCart
                  ? OutlinedButton.icon(
                      // đã có trong cart
                      // khi nhấn nút thì xóa sản phẩm khỏi cart
                      onPressed: () => cart.removeFromCart(product.id),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('In Cart'),
                    )
                  : ElevatedButton.icon(
                      // chưa có trong cart
                      // khi nhấn nút thì thêm sản phẩm vào cart
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
/// Màn hình hiển thị danh sách sản phẩm trong cart
class _CartScreen extends StatelessWidget {
  const _CartScreen();

  @override
  Widget build(BuildContext context) {
    // context.watch<CartNotifier>() lắng nghe sự thay đổi của CartNotifier
    final cart = context.watch<CartNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          // nếu cart không rỗng thì hiển thị nút Clear All
          if (cart.items.isNotEmpty)
            TextButton(
              // khi nhấn nút thì xóa tất cả sản phẩm khỏi cart
              onPressed: () => cart.clearCart(),
              child: const Text('Clear All'),
            ),
        ],
      ),

      // Nếu cart rỗng thì hiển thị thông báo giỏ hàng trống
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
                // ListView.builder dùng để hiển thị danh sách sản phẩm trong cart
                // Expanded dùng để đảm bảo kích thước tối thiểu của widget
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      // _CartItemTile dùng để hiển thị thông tin sản phẩm trong cart
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
                      // BoxShadow dùng để tạo bóng cho widget
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10, // Độ mờ của bóng
                        offset: const Offset(0, -2), // Độ dịch chuyển của bóng
                      ),
                    ],
                  ),

                  // SafeArea dùng để đảm bảo kích thước tối thiểu của widget
                  child: SafeArea(
                    child: Row(
                      // mainAxisAlignment dùng để căn chỉnh khoảng cách giữa các widget
                      // spaceBetween dùng để căn chỉnh khoảng cách giữa các widget
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
                              // toStringAsFixed(2) dùng để định dạng số thập phân
                              '\$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // ElevatedButton dùng để hiển thị nút Checkout
                        ElevatedButton(
                          onPressed: () {
                            // showSnackBar dùng để hiển thị thông báo
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
/// _CartItemTile dùng để hiển thị thông tin sản phẩm trong cart
class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    // context.read<CartNotifier>() dùng để đọc CartNotifier
    final cart = context.read<CartNotifier>();

    // ListTile dùng để hiển thị thông tin sản phẩm trong cart
    return ListTile(
      // leading dùng để hiển thị icon sản phẩm
      leading: Text(
        cartItem.product.emoji,
        style: const TextStyle(fontSize: 32),
      ),
      // title dùng để hiển thị tên sản phẩm
      title: Text(cartItem.product.name),
      // subtitle dùng để hiển thị giá sản phẩm
      subtitle: Text('\$${cartItem.product.price.toStringAsFixed(0)} each'),
      // trailing dùng để hiển thị số lượng sản phẩm
      trailing: Row(
        // mainAxisSize: MainAxisSize.min dùng để giới hạn kích thước của widget theo nội dung
        mainAxisSize: MainAxisSize.min,
        children: [
          // IconButton dùng để hiển thị nút giảm số lượng
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              // cart.updateQuantity dùng để cập nhật số lượng sản phẩm
              cart.updateQuantity(cartItem.product.id, cartItem.quantity - 1);
            },
          ),
          // Text dùng để hiển thị số lượng sản phẩm
          Text(
            '${cartItem.quantity}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // IconButton dùng để hiển thị nút tăng số lượng
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // cart.updateQuantity dùng để cập nhật số lượng sản phẩm
              cart.updateQuantity(cartItem.product.id, cartItem.quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
