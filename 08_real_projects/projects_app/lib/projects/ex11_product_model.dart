/// ============================================================================
/// EXERCISE 11: PRODUCT MODEL
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Thiết kế data models cho ứng dụng shopping.
///
/// 📝 BẠN SẼ HỌC:
/// - Product model với multiple fields
/// - Category và sorting
/// - Price calculations (giá gốc, giá sale)
/// - Cart item model
/// - Sample data generation
///
/// ============================================================================
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ============================================================================
// PRODUCT CATEGORY ENUM
// ============================================================================
///
/// Enum cho các categories sản phẩm.
///
// ============================================================================

enum ProductCategory {
  electronics,
  fashion,
  home,
  beauty,
  sports,
  books;

  String get displayName => switch (this) {
    ProductCategory.electronics => 'Điện tử',
    ProductCategory.fashion => 'Thời trang',
    ProductCategory.home => 'Gia dụng',
    ProductCategory.beauty => 'Làm đẹp',
    ProductCategory.sports => 'Thể thao',
    ProductCategory.books => 'Sách',
  };

  String get icon => switch (this) {
    ProductCategory.electronics => '📱',
    ProductCategory.fashion => '👕',
    ProductCategory.home => '🏠',
    ProductCategory.beauty => '💄',
    ProductCategory.sports => '⚽',
    ProductCategory.books => '📚',
  };

  Color get color => switch (this) {
    ProductCategory.electronics => Colors.blue,
    ProductCategory.fashion => Colors.pink,
    ProductCategory.home => Colors.orange,
    ProductCategory.beauty => Colors.purple,
    ProductCategory.sports => Colors.green,
    ProductCategory.books => Colors.brown,
  };
}

// ============================================================================
// PRODUCT SORT OPTIONS
// ============================================================================

enum ProductSort {
  recommended,
  priceLowToHigh,
  priceHighToLow,
  rating,
  newest;

  String get displayName => switch (this) {
    ProductSort.recommended => 'Đề xuất',
    ProductSort.priceLowToHigh => 'Giá: Thấp → Cao',
    ProductSort.priceHighToLow => 'Giá: Cao → Thấp',
    ProductSort.rating => 'Đánh giá cao',
    ProductSort.newest => 'Mới nhất',
  };
}

// ============================================================================
// PRODUCT MODEL
// ============================================================================
///
/// Model đại diện cho một sản phẩm.
///
/// ## Computed Properties:
/// - [effectivePrice]: Giá thực tế (sale hoặc gốc)
/// - [discountPercent]: % giảm giá
/// - [isOnSale]: Có đang sale không
/// - [isInStock]: Còn hàng không
///
// ============================================================================

class Product extends Equatable {
  // ==========================================================================
  // PROPERTIES
  // ==========================================================================

  /// ID unique của sản phẩm.
  final String id;

  /// Tên sản phẩm.
  final String name;

  /// Mô tả chi tiết.
  final String description;

  /// Giá gốc (VNĐ).
  final double price;

  /// Giá sale (optional). Null = không sale.
  final double? salePrice;

  /// URL hình ảnh.
  ///
  /// Dùng placeholder image cho demo.
  final String imageUrl;

  /// Category của sản phẩm.
  final ProductCategory category;

  /// Số lượng trong kho.
  final int stock;

  /// Rating (0-5).
  final double rating;

  /// Số lượng reviews.
  final int reviewCount;

  /// Tags cho search.
  final List<String> tags;

  /// Ngày thêm sản phẩm.
  final DateTime createdAt;

  /// Đã yêu thích chưa.
  final bool isFavorite;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.rating,
    required this.reviewCount,
    this.tags = const [],
    required this.createdAt,
    this.isFavorite = false,
  });

  // ==========================================================================
  // COMPUTED PROPERTIES
  // ==========================================================================

  /// Giá thực tế sau khi áp dụng sale.
  double get effectivePrice => salePrice ?? price;

  /// Có đang sale không.
  bool get isOnSale => salePrice != null && salePrice! < price;

  /// Phần trăm giảm giá.
  int get discountPercent {
    if (!isOnSale) return 0;
    return ((price - salePrice!) / price * 100).round();
  }

  /// Còn hàng không.
  bool get isInStock => stock > 0;

  /// Số lượng còn ít (< 10).
  bool get isLowStock => stock > 0 && stock < 10;

  /// Giá format VNĐ.
  String get priceFormatted => formatPrice(price);

  /// Giá sale format VNĐ.
  String? get salePriceFormatted =>
      salePrice != null ? formatPrice(salePrice!) : null;

  /// Giá thực tế format VNĐ.
  String get effectivePriceFormatted => formatPrice(effectivePrice);

  /// Rating dạng stars string.
  String get ratingStars {
    final fullStars = rating.floor();
    final halfStar = (rating - fullStars) >= 0.5;
    final emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
    return '${'★' * fullStars}${halfStar ? '½' : ''}${'☆' * emptyStars}';
  }

  /// Format price as VND currency.
  static String formatPrice(double price) {
    // Format với dấu chấm ngăn cách hàng nghìn
    final formatted = price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match.group(1)}.',
        );
    return '$formattedđ';
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    bool clearSalePrice = false,
    String? imageUrl,
    ProductCategory? category,
    int? stock,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: clearSalePrice ? null : (salePrice ?? this.salePrice),
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    salePrice,
    imageUrl,
    category,
    stock,
    rating,
    reviewCount,
    tags,
    createdAt,
    isFavorite,
  ];
}

// ============================================================================
// CART ITEM MODEL
// ============================================================================
///
/// Item trong giỏ hàng = Product + Quantity.
///
// ============================================================================

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  /// Tổng tiền của item này.
  double get subtotal => product.effectivePrice * quantity;

  /// Subtotal formatted.
  String get subtotalFormatted => Product.formatPrice(subtotal);

  /// Có thể tăng quantity không (còn stock).
  bool get canIncrease => quantity < product.stock;

  /// Có thể giảm quantity không.
  bool get canDecrease => quantity > 1;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }

  @override
  List<Object?> get props => [product.id, quantity];
}

// ============================================================================
// SAMPLE DATA
// ============================================================================
///
/// Dữ liệu mẫu cho demo.
///
/// Trong production, data này sẽ từ API.
///
// ============================================================================

class SampleProducts {
  // Placeholder images (không cần internet)
  static String _placeholderImage(int id) =>
      'https://picsum.photos/seed/product$id/300/300';

  static final List<Product> all = [
    // Electronics
    Product(
      id: 'e1',
      name: 'Tai nghe Bluetooth Pro',
      description:
          'Tai nghe không dây cao cấp với công nghệ chống ồn chủ động ANC. Pin 30 giờ, âm thanh hi-fi.',
      price: 2500000,
      salePrice: 1990000,
      imageUrl: _placeholderImage(1),
      category: ProductCategory.electronics,
      stock: 15,
      rating: 4.7,
      reviewCount: 234,
      tags: ['tai nghe', 'bluetooth', 'anc'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Product(
      id: 'e2',
      name: 'Sạc nhanh 65W GaN',
      description:
          'Củ sạc nhanh công nghệ GaN, 3 cổng USB-C/A. Sạc laptop, điện thoại, tablet.',
      price: 890000,
      imageUrl: _placeholderImage(2),
      category: ProductCategory.electronics,
      stock: 42,
      rating: 4.5,
      reviewCount: 189,
      tags: ['sạc', 'gan', 'nhanh'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Product(
      id: 'e3',
      name: 'Smartwatch Series 8',
      description:
          'Đồng hồ thông minh với đo SpO2, ECG, GPS. Kháng nước 50m. Pin 7 ngày.',
      price: 8990000,
      salePrice: 7990000,
      imageUrl: _placeholderImage(3),
      category: ProductCategory.electronics,
      stock: 8,
      rating: 4.8,
      reviewCount: 567,
      tags: ['đồng hồ', 'thông minh', 'sức khỏe'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // Fashion
    Product(
      id: 'f1',
      name: 'Áo thun Cotton Premium',
      description:
          'Áo thun 100% cotton organic, mềm mại, thoáng mát. Size S-XXL.',
      price: 390000,
      salePrice: 290000,
      imageUrl: _placeholderImage(4),
      category: ProductCategory.fashion,
      stock: 100,
      rating: 4.3,
      reviewCount: 423,
      tags: ['áo', 'thun', 'cotton'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Product(
      id: 'f2',
      name: 'Quần Jeans Slim Fit',
      description: 'Quần jeans co giãn thoải mái, dáng slim fit hiện đại.',
      price: 790000,
      imageUrl: _placeholderImage(5),
      category: ProductCategory.fashion,
      stock: 35,
      rating: 4.4,
      reviewCount: 178,
      tags: ['quần', 'jeans', 'slim'],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),

    // Home
    Product(
      id: 'h1',
      name: 'Nồi chiên không dầu 5L',
      description:
          'Air fryer 1800W, dung tích 5L. Màn hình cảm ứng, 8 chế độ nấu.',
      price: 2890000,
      salePrice: 2190000,
      imageUrl: _placeholderImage(6),
      category: ProductCategory.home,
      stock: 20,
      rating: 4.6,
      reviewCount: 892,
      tags: ['nồi', 'chiên', 'không dầu'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Product(
      id: 'h2',
      name: 'Bộ chăn ga cotton',
      description: 'Bộ chăn ga gối 100% cotton, size 1m8. Mềm mại, thoáng khí.',
      price: 1490000,
      imageUrl: _placeholderImage(7),
      category: ProductCategory.home,
      stock: 25,
      rating: 4.5,
      reviewCount: 234,
      tags: ['chăn', 'ga', 'gối'],
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),

    // Beauty
    Product(
      id: 'b1',
      name: 'Serum Vitamin C 20%',
      description: 'Serum dưỡng sáng, chống lão hóa. Vitamin C tinh khiết 20%.',
      price: 690000,
      salePrice: 550000,
      imageUrl: _placeholderImage(8),
      category: ProductCategory.beauty,
      stock: 50,
      rating: 4.7,
      reviewCount: 1234,
      tags: ['serum', 'vitamin c', 'dưỡng da'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),

    // Sports
    Product(
      id: 's1',
      name: 'Giày chạy bộ Ultra Boost',
      description:
          'Giày running với đế Boost êm ái. Trọng lượng nhẹ, thoáng khí.',
      price: 3990000,
      imageUrl: _placeholderImage(9),
      category: ProductCategory.sports,
      stock: 12,
      rating: 4.8,
      reviewCount: 567,
      tags: ['giày', 'chạy bộ', 'running'],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),

    // Books
    Product(
      id: 'bk1',
      name: 'Clean Code - Robert C. Martin',
      description:
          'Sách lập trình kinh điển về cách viết code sạch, dễ bảo trì.',
      price: 350000,
      imageUrl: _placeholderImage(10),
      category: ProductCategory.books,
      stock: 30,
      rating: 4.9,
      reviewCount: 2345,
      tags: ['sách', 'lập trình', 'clean code'],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  /// Lấy sản phẩm theo category.
  static List<Product> byCategory(ProductCategory category) {
    return all.where((p) => p.category == category).toList();
  }

  /// Lấy sản phẩm đang sale.
  static List<Product> onSale() {
    return all.where((p) => p.isOnSale).toList();
  }

  /// Sản phẩm rating cao.
  static List<Product> topRated() {
    final sorted = List<Product>.from(all)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex11ProductModel extends StatelessWidget {
  const Ex11ProductModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex11: Product Model'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '🛒 Product Model Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Categories
          const Text(
            '📂 Categories:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                ProductCategory.values.map((cat) {
                  return Chip(
                    avatar: Text(cat.icon),
                    label: Text(cat.displayName),
                    backgroundColor: cat.color.withAlpha(50),
                  );
                }).toList(),
          ),

          const SizedBox(height: 24),

          // Products
          const Text(
            '📦 Sample Products:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...SampleProducts.all
              .take(5)
              .map(
                (product) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: product.category.color.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text(product.category.icon)),
                    ),
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (product.isOnSale) ...[
                              Text(
                                product.priceFormatted,
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              product.effectivePriceFormatted,
                              style: TextStyle(
                                color: product.isOnSale ? Colors.red : null,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (product.isOnSale) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${product.discountPercent}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${product.ratingStars} (${product.reviewCount})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          product.isInStock ? Icons.check_circle : Icons.cancel,
                          color: product.isInStock ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        Text(
                          product.isInStock
                              ? 'Còn ${product.stock}'
                              : 'Hết hàng',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

          const SizedBox(height: 16),

          // Cart Item demo
          const Text(
            '🛒 Cart Item Demo:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              final cartItem = CartItem(
                product: SampleProducts.all.first,
                quantity: 2,
              );
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product: ${cartItem.product.name}'),
                      Text('Quantity: ${cartItem.quantity}'),
                      Text(
                        'Unit price: ${cartItem.product.effectivePriceFormatted}',
                      ),
                      Text(
                        'Subtotal: ${cartItem.subtotalFormatted}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
