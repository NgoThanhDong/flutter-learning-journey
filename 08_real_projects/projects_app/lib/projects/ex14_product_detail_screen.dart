/// ============================================================================
/// EXERCISE 14: PRODUCT DETAIL SCREEN
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Màn hình chi tiết sản phẩm.
///
/// 📝 BẠN SẼ HỌC:
/// - Product detail layout
/// - Quantity selector
/// - Add to cart action
/// - Related products
/// - Reviews section
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ex11_product_model.dart';
import 'ex12_cart_cubit.dart';

// ============================================================================
// PRODUCT DETAIL SCREEN
// ============================================================================

class Ex14ProductDetailScreen extends StatefulWidget {
  final Product product;

  const Ex14ProductDetailScreen({super.key, required this.product});

  @override
  State<Ex14ProductDetailScreen> createState() =>
      _Ex14ProductDetailScreenState();
}

class _Ex14ProductDetailScreenState extends State<Ex14ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          _buildSliverAppBar(product),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Chip(
                    avatar: Text(product.category.icon),
                    label: Text(product.category.displayName),
                    backgroundColor: product.category.color.withAlpha(50),
                  ),

                  const SizedBox(height: 8),

                  // Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        if (index < product.rating.floor()) {
                          return const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          );
                        } else if (index < product.rating) {
                          return const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 20,
                          );
                        } else {
                          return const Icon(
                            Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating} (${product.reviewCount} đánh giá)',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price
                  _buildPriceSection(product),

                  const SizedBox(height: 16),

                  // Stock status
                  _buildStockStatus(product),

                  const Divider(height: 32),

                  // Description
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  // Quantity selector
                  _buildQuantitySelector(product),

                  const SizedBox(height: 24),

                  // Add to cart button
                  _buildAddToCartButton(context, product),

                  const Divider(height: 32),

                  // Tags
                  if (product.tags.isNotEmpty) ...[
                    const Text(
                      'Tags',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          product.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: Colors.grey.shade100,
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Related products
                  _buildRelatedProducts(product),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SLIVER APP BAR WITH IMAGE
  // ==========================================================================

  Widget _buildSliverAppBar(Product product) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFavorite
                      ? 'Đã thêm vào yêu thích'
                      : 'Đã xóa khỏi yêu thích',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Chia sẻ...')));
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: product.category.color.withAlpha(50),
              child: Center(
                child: Text(
                  product.category.icon,
                  style: const TextStyle(fontSize: 120),
                ),
              ),
            ),
            // Sale badge
            if (product.isOnSale)
              Positioned(
                top: 100,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '-${product.discountPercent}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // PRICE SECTION
  // ==========================================================================

  Widget _buildPriceSection(Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          product.effectivePriceFormatted,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: product.isOnSale ? Colors.red : null,
          ),
        ),
        if (product.isOnSale) ...[
          const SizedBox(width: 12),
          Text(
            product.priceFormatted,
            style: const TextStyle(
              fontSize: 18,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Tiết kiệm ${Product.formatPrice(product.price - product.salePrice!)}',
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================================================
  // STOCK STATUS
  // ==========================================================================

  Widget _buildStockStatus(Product product) {
    if (!product.isInStock) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.cancel, color: Colors.red.shade700),
            const SizedBox(width: 8),
            const Text(
              'Hết hàng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (product.isLowStock) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Text(
              'Chỉ còn ${product.stock} sản phẩm!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 8),
        Text(
          'Còn ${product.stock} sản phẩm',
          style: const TextStyle(color: Colors.green),
        ),
      ],
    );
  }

  // ==========================================================================
  // QUANTITY SELECTOR
  // ==========================================================================

  Widget _buildQuantitySelector(Product product) {
    return Row(
      children: [
        const Text('Số lượng:', style: TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed:
                    _quantity > 1
                        ? () {
                          setState(() {
                            _quantity--;
                          });
                        }
                        : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed:
                    _quantity < product.stock
                        ? () {
                          setState(() {
                            _quantity++;
                          });
                        }
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // ADD TO CART BUTTON
  // ==========================================================================

  Widget _buildAddToCartButton(BuildContext context, Product product) {
    final totalPrice = product.effectivePrice * _quantity;

    return Column(
      children: [
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng cộng:'),
            Text(
              Product.formatPrice(totalPrice),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    product.isInStock
                        ? () {
                          // Buy now
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chuyển đến thanh toán...'),
                            ),
                          );
                        }
                        : null,
                icon: const Icon(Icons.flash_on),
                label: const Text('Mua ngay'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    product.isInStock
                        ? () {
                          context.read<CartCubit>().addToCart(
                            product,
                            quantity: _quantity,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã thêm $_quantity ${product.name}',
                              ),
                              action: SnackBarAction(
                                label: 'Xem giỏ',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          );
                        }
                        : null,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Thêm vào giỏ'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================================
  // RELATED PRODUCTS
  // ==========================================================================

  Widget _buildRelatedProducts(Product product) {
    final related =
        SampleProducts.byCategory(
          product.category,
        ).where((p) => p.id != product.id).take(4).toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sản phẩm liên quan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: related.length,
            itemBuilder: (context, index) {
              final item = related[index];
              return _RelatedProductCard(
                product: item,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider.value(
                            value: context.read<CartCubit>(),
                            child: Ex14ProductDetailScreen(product: item),
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// RELATED PRODUCT CARD
// ============================================================================

class _RelatedProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _RelatedProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        margin: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: product.category.color.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        product.category.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Name
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                // Price
                Text(
                  product.effectivePriceFormatted,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex14ProductDetail extends StatelessWidget {
  const Ex14ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: Ex14ProductDetailScreen(product: SampleProducts.all.first),
    );
  }
}
