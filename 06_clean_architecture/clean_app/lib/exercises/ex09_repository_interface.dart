/// ===========================================
/// EXERCISE 09: REPOSITORY INTERFACE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Định nghĩa abstract repository
/// - Repository ở Domain layer (business interface)
/// - Implementation ở Data layer
///
/// 📝 Repository Pattern:
/// - Tách biệt business logic khỏi data access
/// - Domain chỉ biết interface
/// - Data implement interface

library;

import 'package:flutter/material.dart';

/// ===========================================
/// DOMAIN LAYER - ENTITIES & REPOSITORY INTERFACE
/// ===========================================

/// [Product] - Domain Entity
/// Pure Dart class, không có JSON serialization
class Product {
  final int id;
  final String name;
  final double price;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  @override
  String toString() => 'Product($id, $name, $priceđ)';
}

/// [ProductRepository] - Abstract Repository Interface
/// Đây là contract mà Data layer phải implement
abstract class ProductRepository {
  /// [getAll] - Lấy tất cả products
  Future<List<Product>> getAll();

  /// [getById] - Lấy product theo ID
  Future<Product?> getById(int id);

  /// [getByCategory] - Lấy products theo category
  Future<List<Product>> getByCategory(String category);

  /// [add] - Thêm product mới
  Future<Product> add(Product product);

  /// [update] - Cập nhật product
  Future<Product> update(Product product);

  /// [delete] - Xóa product
  Future<bool> delete(int id);
}

/// ===========================================
/// DATA LAYER - REPOSITORY IMPLEMENTATION
/// ===========================================

/// [InMemoryProductRepository] - Implementation với in-memory storage
/// Trong real app, đây có thể là ApiProductRepository, SqliteProductRepository...
class InMemoryProductRepository implements ProductRepository {
  /// [_products] - In-memory storage
  final List<Product> _products = [
    Product(id: 1, name: 'iPhone 15', price: 25000000, category: 'Phone'),
    Product(id: 2, name: 'MacBook Pro', price: 55000000, category: 'Laptop'),
    Product(id: 3, name: 'AirPods Pro', price: 6000000, category: 'Audio'),
    Product(id: 4, name: 'Samsung Galaxy', price: 20000000, category: 'Phone'),
    Product(id: 5, name: 'Dell XPS', price: 40000000, category: 'Laptop'),
  ];

  int _nextId = 6;

  @override
  Future<List<Product>> getAll() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_products);
  }

  @override
  Future<Product?> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> getByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _products.where((p) => p.category == category).toList();
  }

  @override
  Future<Product> add(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newProduct = Product(
      id: _nextId++,
      name: product.name,
      price: product.price,
      category: product.category,
    );
    _products.add(newProduct);
    return newProduct;
  }

  @override
  Future<Product> update(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) throw Exception('Product not found');
    _products[index] = product;
    return product;
  }

  @override
  Future<bool> delete(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final initialLength = _products.length;
    _products.removeWhere((p) => p.id == id);
    return _products.length < initialLength;
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex09RepositoryInterface extends StatefulWidget {
  const Ex09RepositoryInterface({super.key});

  @override
  State<Ex09RepositoryInterface> createState() =>
      _Ex09RepositoryInterfaceState();
}

class _Ex09RepositoryInterfaceState extends State<Ex09RepositoryInterface> {
  /// [repository] - Dependency on INTERFACE, not implementation
  /// Có thể swap InMemoryProductRepository với bất kỳ implementation nào
  final ProductRepository repository = InMemoryProductRepository();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    final products = _selectedCategory == null
        ? await repository.getAll()
        : await repository.getByCategory(_selectedCategory!);

    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _addProduct() async {
    final name = 'New Product ${DateTime.now().second}';
    await repository.add(
      Product(
        id: 0, // Will be assigned by repository
        name: name,
        price: 1000000,
        category: 'Phone',
      ),
    );
    _loadProducts();
  }

  Future<void> _deleteProduct(int id) async {
    await repository.delete(id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Phone', 'Laptop', 'Audio'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex09: Repository Interface'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addProduct),
        ],
      ),
      body: Column(
        children: [
          // Info
          const Card(
            color: Colors.blue,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Repository Pattern',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ProductRepository (interface) ← Domain layer\n'
                    'InMemoryProductRepository ← Data layer\n\n'
                    'UI chỉ biết interface, có thể swap implementation!',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: categories.map((cat) {
                final isSelected =
                    (cat == 'All' && _selectedCategory == null) ||
                    cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat == 'All' ? null : cat;
                      });
                      _loadProducts();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Products list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${product.id}')),
                        title: Text(product.name),
                        subtitle: Text(
                          '${product.price.toStringAsFixed(0)}đ | ${product.category}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProduct(product.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
