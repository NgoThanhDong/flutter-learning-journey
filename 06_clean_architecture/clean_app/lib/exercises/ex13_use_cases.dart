/// ===========================================
/// EXERCISE 13: USE CASES
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tạo Use Cases (Interactors)
/// - Business logic tập trung
/// - Single responsibility cho mỗi use case
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

  double get subtotal => product.price * quantity;
}

class Cart {
  final List<CartItem> items;

  const Cart({this.items = const []});

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }
}

/// ===========================================
/// DOMAIN LAYER - REPOSITORY INTERFACE
/// ===========================================

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product?> getProduct(int id);
  Future<void> updateStock(int productId, int newStock);
}

abstract class CartRepository {
  Future<Cart> getCart();
  Future<void> saveCart(Cart cart);
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
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) {
    return repository.getAllProducts();
  }
}

/// ===========================================
/// [AddToCartUseCase] - Thêm vào giỏ hàng
/// ===========================================
class AddToCartParams {
  final int productId;
  final int quantity;

  const AddToCartParams({required this.productId, this.quantity = 1});
}

class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  final ProductRepository productRepository;
  final CartRepository cartRepository;

  AddToCartUseCase({
    required this.productRepository,
    required this.cartRepository,
  });

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
class CheckoutUseCase implements UseCase<bool, NoParams> {
  final ProductRepository productRepository;
  final CartRepository cartRepository;

  CheckoutUseCase({
    required this.productRepository,
    required this.cartRepository,
  });

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

class InMemoryProductRepository implements ProductRepository {
  final List<Product> _products = [
    Product(id: 1, name: 'iPhone 15', price: 25000000, stock: 10),
    Product(id: 2, name: 'MacBook Pro', price: 55000000, stock: 5),
    Product(id: 3, name: 'AirPods Pro', price: 6000000, stock: 20),
  ];

  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_products);
  }

  @override
  Future<Product?> getProduct(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateStock(int productId, int newStock) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      _products[index] = _products[index].copyWith(stock: newStock);
    }
  }
}

class InMemoryCartRepository implements CartRepository {
  Cart _cart = const Cart();

  @override
  Future<Cart> getCart() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _cart;
  }

  @override
  Future<void> saveCart(Cart cart) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cart = cart;
  }

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
  late final GetProductsUseCase _getProductsUseCase;
  late final AddToCartUseCase _addToCartUseCase;
  late final CheckoutUseCase _checkoutUseCase;
  late final CartRepository _cartRepository;

  List<Product> _products = [];
  Cart _cart = const Cart();
  bool _isLoading = false;
  String? _message;

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

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _products = await _getProductsUseCase(const NoParams());
    _cart = await _cartRepository.getCart();
    setState(() => _isLoading = false);
  }

  Future<void> _addToCart(int productId) async {
    try {
      _cart = await _addToCartUseCase(AddToCartParams(productId: productId));
      setState(() => _message = 'Added to cart!');
    } catch (e) {
      setState(() => _message = e.toString());
    }
    setState(() {});
  }

  Future<void> _checkout() async {
    try {
      await _checkoutUseCase(const NoParams());
      setState(() => _message = 'Checkout successful!');
      _loadData();
    } catch (e) {
      setState(() => _message = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex13: Use Cases'),
        actions: [
          Badge(
            label: Text('${_cart.itemCount}'),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
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

                // Products
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
                              onPressed: () => _addToCart(product.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Cart summary
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
