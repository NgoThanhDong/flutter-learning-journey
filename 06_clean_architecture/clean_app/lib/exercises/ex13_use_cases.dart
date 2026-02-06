/// ===========================================
/// EXERCISE 13: USE CASES
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tạo Use Cases (Interactors)
/// - Business logic tập trung
/// - Single responsibility (mỗi use case chỉ có trách nhiệm riêng) cho mỗi use case
///
/// 📝 Use Case trong Clean Architecture:
/// - 1 Use Case = 1 Business Action
/// - Chứa business logic
/// - Gọi Repository để lấy/lưu data
/// - Không biết về UI

library;

import 'package:flutter/material.dart';

/// ===========================================
/// DOMAIN LAYER - ENTITIES
/// ===========================================

class Product {
  final int id;
  final String name;
  final double price;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  /// Tạo copy của product  
  Product copyWith({int? id, String? name, double? price, int? stock}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }
}

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  /// Tính tổng tiền hàng
  double get subtotal => product.price * quantity;
}

class Cart {
  final List<CartItem> items;

  const Cart({this.items = const []});

  /// Tính tổng tiền hàng
  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  /// Tính tổng số lượng hàng
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Tạo copy của cart
  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }
}

/// ===========================================
/// DOMAIN LAYER - REPOSITORY INTERFACE
/// ===========================================

/// [ProductRepository] - Định nghĩa contract cho repository
abstract class ProductRepository {
  /// Lấy danh sách products
  Future<List<Product>> getAllProducts();

  /// Lấy product theo id
  Future<Product?> getProduct(int id);

  /// Cập nhật stock
  Future<void> updateStock(int productId, int newStock);
}

/// [CartRepository] - Định nghĩa contract cho repository
abstract class CartRepository {
  /// Lấy cart
  Future<Cart> getCart();

  /// Lưu cart
  Future<void> saveCart(Cart cart);

  /// Xóa cart
  Future<void> clearCart();
}

/// ===========================================
/// DOMAIN LAYER - USE CASES
/// ===========================================

/// [Base UseCase class]
/// Generic base cho tất cả use cases
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// [NoParams] - Khi không cần tham số
class NoParams {
  const NoParams();
}

/// ===========================================
/// [GetProductsUseCase] - Lấy danh sách products
/// ===========================================
class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  /// [ProductRepository] - Định nghĩa contract cho repository
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  /// Lấy danh sách products
  @override
  Future<List<Product>> call(NoParams params) {
    return repository.getAllProducts();
  }
}

/// ===========================================
/// [AddToCartUseCase] - Thêm vào giỏ hàng
/// ===========================================

/// [AddToCartParams] - Tham số cho use case
class AddToCartParams {
  final int productId;
  final int quantity;

  const AddToCartParams({required this.productId, this.quantity = 1});
}

/// [AddToCartUseCase] - Use case để thêm vào giỏ hàng
class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  /// [ProductRepository] - Định nghĩa contract cho repository
  final ProductRepository productRepository;

  /// [CartRepository] - Định nghĩa contract cho repository
  final CartRepository cartRepository;

  /// [AddToCartUseCase] - Use case để thêm vào giỏ hàng
  AddToCartUseCase({
    required this.productRepository,
    required this.cartRepository,
  });

  /// [call] - Gọi use case để thêm vào giỏ hàng
  @override
  Future<Cart> call(AddToCartParams params) async {
    /// 1. Lấy product
    final product = await productRepository.getProduct(params.productId);
    if (product == null) {
      throw Exception('Product not found');
    }

    /// 2. Kiểm tra stock (Business Rule!)
    if (product.stock < params.quantity) {
      throw Exception('Not enough stock. Available: ${product.stock}');
    }

    /// 3. Lấy cart hiện tại
    final currentCart = await cartRepository.getCart();

    /// 4. Thêm hoặc update item trong cart
    final existingIndex = currentCart.items.indexWhere(
      (i) => i.product.id == params.productId,
    );

    /// [newItems] - Danh sách items mới
    List<CartItem> newItems;
    if (existingIndex >= 0) {
      // Update quantity
      final existingItem = currentCart.items[existingIndex];
      final newQuantity = existingItem.quantity + params.quantity;

      // Check total quantity không vượt stock
      if (newQuantity > product.stock) {
        throw Exception('Cannot add more. Stock limit: ${product.stock}');
      }

      newItems = List.from(currentCart.items);
      newItems[existingIndex] = CartItem(
        product: existingItem.product,
        quantity: newQuantity,
      );
    } else {
      // Add new item
      newItems = [
        ...currentCart.items,
        CartItem(product: product, quantity: params.quantity),
      ];
    }

    /// 5. Save cart
    final updatedCart = currentCart.copyWith(items: newItems);
    await cartRepository.saveCart(updatedCart);

    return updatedCart;
  }
}

/// ===========================================
/// [CheckoutUseCase] - Thanh toán
/// ===========================================

/// [CheckoutUseCase] - Use case để thanh toán
class CheckoutUseCase implements UseCase<bool, NoParams> {
  /// [ProductRepository] - Định nghĩa contract cho repository
  final ProductRepository productRepository;

  /// [CartRepository] - Định nghĩa contract cho repository
  final CartRepository cartRepository;

  /// [CheckoutUseCase] - Use case để thanh toán
  CheckoutUseCase({
    required this.productRepository,
    required this.cartRepository,
  });

  /// [call] - Gọi use case để thanh toán
  @override
  Future<bool> call(NoParams params) async {
    /// 1. Lấy cart
    final cart = await cartRepository.getCart();
    if (cart.items.isEmpty) {
      throw Exception('Cart is empty');
    }

    /// 2. Update stock cho từng product
    for (final item in cart.items) {
      final product = await productRepository.getProduct(item.product.id);
      if (product == null) continue;

      final newStock = product.stock - item.quantity;
      if (newStock < 0) {
        throw Exception('${product.name} is out of stock');
      }

      await productRepository.updateStock(product.id, newStock);
    }

    /// 3. Clear cart
    await cartRepository.clearCart();

    return true;
  }
}

/// ===========================================
/// DATA LAYER - IMPLEMENTATIONS
/// ===========================================

/// [InMemoryProductRepository] - Implement product repository
class InMemoryProductRepository implements ProductRepository {
  /// [ProductRepository] - Định nghĩa contract cho repository
  final List<Product> _products = [
    Product(id: 1, name: 'iPhone 15', price: 25000000, stock: 10),
    Product(id: 2, name: 'MacBook Pro', price: 55000000, stock: 5),
    Product(id: 3, name: 'AirPods Pro', price: 6000000, stock: 20),
  ];

  /// [getAllProducts] - Lấy danh sách products
  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_products);
  }

  /// [getProduct] - Lấy product theo id
  @override
  Future<Product?> getProduct(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// [updateStock] - Cập nhật stock
  @override
  Future<void> updateStock(int productId, int newStock) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      _products[index] = _products[index].copyWith(stock: newStock);
    }
  }
}

/// [InMemoryCartRepository] - Implement cart repository
class InMemoryCartRepository implements CartRepository {
  /// [CartRepository] - Định nghĩa contract cho repository
  Cart _cart = const Cart();

  /// [getCart] - Lấy cart
  @override
  Future<Cart> getCart() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _cart;
  }

  /// [saveCart] - Lưu cart
  @override
  Future<void> saveCart(Cart cart) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cart = cart;
  }

  /// [clearCart] - Xóa cart
  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cart = const Cart();
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex13UseCases extends StatefulWidget {
  const Ex13UseCases({super.key});

  @override
  State<Ex13UseCases> createState() => _Ex13UseCasesState();
}

class _Ex13UseCasesState extends State<Ex13UseCases> {
  /// [GetProductsUseCase] - Use case để lấy danh sách products
  late final GetProductsUseCase _getProductsUseCase;

  /// [AddToCartUseCase] - Use case để thêm product vào cart
  late final AddToCartUseCase _addToCartUseCase;

  /// [CheckoutUseCase] - Use case để thanh toán
  late final CheckoutUseCase _checkoutUseCase;

  /// [CartRepository] - Định nghĩa contract cho repository
  late final CartRepository _cartRepository;

  List<Product> _products = [];
  Cart _cart = const Cart();
  bool _isLoading = false;
  String? _message;

  /// [initState] - Khởi tạo state
  @override
  void initState() {
    super.initState();
    final productRepo = InMemoryProductRepository();
    _cartRepository = InMemoryCartRepository();

    _getProductsUseCase = GetProductsUseCase(productRepo);
    _addToCartUseCase = AddToCartUseCase(
      productRepository: productRepo,
      cartRepository: _cartRepository,
    );
    _checkoutUseCase = CheckoutUseCase(
      productRepository: productRepo,
      cartRepository: _cartRepository,
    );

    _loadData();
  }

  /// [loadData] - Load danh sách products và cart
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _products = await _getProductsUseCase(const NoParams());
    _cart = await _cartRepository.getCart();
    setState(() => _isLoading = false);
  }

  /// [addToCart] - Thêm product vào cart
  Future<void> _addToCart(int productId) async {
    try {
      _cart = await _addToCartUseCase(AddToCartParams(productId: productId));
      setState(() => _message = 'Added to cart!');
    } catch (e) {
      setState(() => _message = e.toString());
    }
    setState(() {});
  }

  /// [checkout] - Thanh toán
  Future<void> _checkout() async {
    try {
      await _checkoutUseCase(const NoParams());
      setState(() => _message = 'Checkout successful!');
      _loadData();
    } catch (e) {
      setState(() => _message = e.toString());
    }
  }

  /// [build] - Xây dựng UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex13: Use Cases'),
        actions: [
          /// [Badge] - Hiển thị số lượng sản phẩm trong giỏ hàng
          Badge(
            label: Text('${_cart.itemCount}'),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),

      /// [body] - Hiển thị danh sách products
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info
                const Card(
                  color: Colors.teal,
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡 Use Cases Pattern',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• GetProductsUseCase: Lấy products\n'
                          '• AddToCartUseCase: Thêm vào giỏ + check stock\n'
                          '• CheckoutUseCase: Thanh toán + update stock',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                /// [message] - Hiển thị thông báo
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _message!.contains('Exception')
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),

                /// [Products] - Hiển thị danh sách products
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('Stock: ${product.stock}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${product.price.toStringAsFixed(0)}đ'),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              /// [addToCart] - Thêm product vào cart
                              onPressed: () => _addToCart(product.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// [Cart summary] - Hiển thị tổng số sản phẩm và tổng tiền
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cart: ${_cart.itemCount} items'),
                          Text(
                            'Total: ${_cart.total.toStringAsFixed(0)}đ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        /// [checkout] - Thanh toán
                        onPressed: _cart.items.isEmpty ? null : _checkout,
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
