/// ===========================================
/// EXERCISE 09: REPOSITORY INTERFACE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Định nghĩa abstract repository - Định nghĩa repository trừu tượng
/// - Repository ở Domain layer (business interface) - Repository ở Domain layer (business interface)
/// - Implementation ở Data layer - Implementation ở Data layer
///
/// 📝 Repository Pattern:
/// - Tách biệt business logic khỏi data access - Tách biệt logic nghiệp vụ khỏi truy cập dữ liệu
/// - Domain chỉ biết interface
/// - Data implement interface

library;

import 'package:flutter/material.dart';

/// ===========================================
/// DOMAIN LAYER - ENTITIES & REPOSITORY INTERFACE
/// ===========================================

/// [Product] - Domain Entity
/// Pure Dart class, không có JSON serialization (tuần tự hóa)
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
  /// Lưu trữ dữ liệu tạm thời trong bộ nhớ
  final List<Product> _products = [
    Product(id: 1, name: 'iPhone 15', price: 25000000, category: 'Phone'),
    Product(id: 2, name: 'MacBook Pro', price: 55000000, category: 'Laptop'),
    Product(id: 3, name: 'AirPods Pro', price: 6000000, category: 'Audio'),
    Product(id: 4, name: 'Samsung Galaxy', price: 20000000, category: 'Phone'),
    Product(id: 5, name: 'Dell XPS', price: 40000000, category: 'Laptop'),
  ];

  int _nextId = 6; // ID tiếp theo cho product mới

  /// [getAll] - Lấy tất cả products
  @override
  Future<List<Product>> getAll() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_products); // Trả về danh sách không thể thay đổi
  }

  /// [getById] - Lấy product theo ID
  @override
  Future<Product?> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// [getByCategory] - Lấy products theo category
  @override
  Future<List<Product>> getByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _products.where((p) => p.category == category).toList();
  }

  /// [add] - Thêm product mới
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

  /// [update] - Cập nhật product theo ID
  @override
  Future<Product> update(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Tìm index của product cần update
    final index = _products.indexWhere((p) => p.id == product.id);
    // Nếu không tìm thấy product thì ném ra exception
    if (index == -1) throw Exception('Product not found');
    _products[index] = product;
    return product;
  }

  /// [delete] - Xóa product theo ID
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

  List<Product> _products = []; // Danh sách products
  bool _isLoading = false; // Trạng thái loading
  String? _selectedCategory; // Category được chọn

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// [loadProducts] - Load products từ repository
  /// [category] - Category để filter products
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

  /// [addProduct] - Thêm product mới
  Future<void> _addProduct() async {
    final name = 'New Product ${DateTime.now().second}';
    await repository.add(
      Product(
        id: 0, // Sẽ được gán bởi repository
        name: name,
        price: 1000000,
        category: 'Phone',
      ),
    );
    _loadProducts();
  }

  /// [deleteProduct] - Xóa product theo ID
  Future<void> _deleteProduct(int id) async {
    await repository.delete(id);
    _loadProducts();
  }

  /// [build] - Xây dựng UI
  @override
  Widget build(BuildContext context) {
    // Danh sách các category
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
                // Kiểm tra xem category có được chọn không
                final isSelected =
                    (cat == 'All' && _selectedCategory == null) ||
                    cat == _selectedCategory;

                // FilterChip để chọn category
                // FilterChip là một widget của Flutter để chọn category
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        // Nếu chọn All, thì _selectedCategory = null
                        // Nếu chọn category khác, thì _selectedCategory = category đó
                        _selectedCategory = cat == 'All' ? null : cat;
                      });
                      _loadProducts(); // Load products khi chọn category
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
                      // Lấy product theo index
                      final product = _products[index];

                      // ListTile để hiển thị thông tin product
                      return ListTile(
                        leading: CircleAvatar(child: Text('${product.id}')),
                        title: Text(product.name),
                        subtitle: Text(
                          '${product.price.toStringAsFixed(0)}đ | ${product.category}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          // Xóa product khi click
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
