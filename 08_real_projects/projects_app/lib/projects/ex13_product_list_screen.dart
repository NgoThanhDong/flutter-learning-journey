/// ============================================================================
/// EXERCISE 13: PRODUCT LIST SCREEN
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Màn hình danh sách sản phẩm với filtering và search.
///
/// 📝 BẠN SẼ HỌC:
/// - Responsive grid layout
/// - Category filtering
/// - Search functionality
/// - Sort options
/// - Product card design
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ex11_product_model.dart';
import 'ex12_cart_cubit.dart';

// ============================================================================
// PRODUCTS LIST SCREEN
// ============================================================================

class Ex13ProductListScreen extends StatefulWidget {
  const Ex13ProductListScreen({super.key});

  @override
  State<Ex13ProductListScreen> createState() => _Ex13ProductListScreenState();
}

class _Ex13ProductListScreenState extends State<Ex13ProductListScreen> {
  // ==========================================================================
  // STATE
  // ==========================================================================

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  ProductCategory? _selectedCategory;
  ProductSort _sortBy = ProductSort.recommended;
  String _searchQuery = '';
  bool _isGridView = true;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allProducts = SampleProducts.all;
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // FILTER LOGIC
  // ==========================================================================

  void _applyFilters() {
    var result = List<Product>.from(_allProducts);

    // Category filter
    if (_selectedCategory != null) {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result =
          result.where((p) {
            return p.name.toLowerCase().contains(query) ||
                p.description.toLowerCase().contains(query) ||
                p.tags.any((tag) => tag.toLowerCase().contains(query));
          }).toList();
    }

    // Sort
    result.sort(
      (a, b) => switch (_sortBy) {
        ProductSort.recommended => 0, // Keep original order
        ProductSort.priceLowToHigh => a.effectivePrice.compareTo(
          b.effectivePrice,
        ),
        ProductSort.priceHighToLow => b.effectivePrice.compareTo(
          a.effectivePrice,
        ),
        ProductSort.rating => b.rating.compareTo(a.rating),
        ProductSort.newest => b.createdAt.compareTo(a.createdAt),
      },
    );

    setState(() {
      _filteredProducts = result;
    });
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🛒 Sản phẩm'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // View toggle
            IconButton(
              icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
            // Cart badge
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return Badge(
                  label: Text('${state.totalQuantity}'),
                  isLabelVisible: state.totalQuantity > 0,
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      _showCartBottomSheet(context);
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                              _applyFilters();
                            },
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _applyFilters();
                },
              ),
            ),

            // Category chips
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // All categories
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('Tất cả'),
                      selected: _selectedCategory == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = null;
                        });
                        _applyFilters();
                      },
                    ),
                  ),
                  // Category chips
                  ...ProductCategory.values.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        avatar: Text(category.icon),
                        label: Text(category.displayName),
                        selected: _selectedCategory == category,
                        selectedColor: category.color.withAlpha(100),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                          _applyFilters();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Sort & count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredProducts.length} sản phẩm',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  PopupMenuButton<ProductSort>(
                    child: Row(
                      children: [
                        Text(_sortBy.displayName),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                    onSelected: (sort) {
                      setState(() {
                        _sortBy = sort;
                      });
                      _applyFilters();
                    },
                    itemBuilder:
                        (context) =>
                            ProductSort.values
                                .map(
                                  (sort) => PopupMenuItem(
                                    value: sort,
                                    child: Row(
                                      children: [
                                        if (_sortBy == sort)
                                          const Icon(Icons.check, size: 18)
                                        else
                                          const SizedBox(width: 18),
                                        const SizedBox(width: 8),
                                        Text(sort.displayName),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                  ),
                ],
              ),
            ),

            // Products
            Expanded(
              child:
                  _filteredProducts.isEmpty
                      ? _buildEmptyState()
                      : _isGridView
                      ? _buildGridView(context)
                      : _buildListView(context),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // EMPTY STATE
  // ==========================================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy sản phẩm',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Thử tìm với từ khóa khác',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================================
  // GRID VIEW
  // ==========================================================================

  Widget _buildGridView(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount =
        width > 1200
            ? 4
            : width > 800
            ? 3
            : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.6,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(product: _filteredProducts[index]);
      },
    );
  }

  // ==========================================================================
  // LIST VIEW
  // ==========================================================================

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductListTile(product: _filteredProducts[index]);
      },
    );
  }

  // ==========================================================================
  // CART BOTTOM SHEET
  // ==========================================================================

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomContext) {
        return BlocProvider.value(
          value: context.read<CartCubit>(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) {
              return BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('Giỏ hàng trống'),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      AppBar(
                        title: Text('Giỏ hàng (${state.itemCount})'),
                        leading: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: state.items.length,
                          itemBuilder: (_, index) {
                            final item = state.items[index];
                            return ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: item.product.category.color.withAlpha(
                                    50,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(item.product.category.icon),
                                ),
                              ),
                              title: Text(item.product.name),
                              subtitle: Text(
                                '${item.quantity} x ${item.product.effectivePriceFormatted}',
                              ),
                              trailing: Text(item.subtotalFormatted),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tổng cộng:'),
                                Text(
                                  state.totalFormatted,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.payment),
                              label: const Text('Thanh toán'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ============================================================================
// PRODUCT CARD (Grid item)
// ============================================================================

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Container(
                  color: product.category.color.withAlpha(50),
                  child: Center(
                    child: Text(
                      product.category.icon,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                // Sale badge
                if (product.isOnSale)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${product.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Low stock badge
                if (product.isLowStock)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Còn ít',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    product.category.displayName,
                    style: TextStyle(
                      fontSize: 10,
                      color: product.category.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(
                        ' ${product.rating}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        ' (${product.reviewCount})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Price
                  if (product.isOnSale)
                    Text(
                      product.priceFormatted,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.effectivePriceFormatted,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: product.isOnSale ? Colors.red : null,
                        ),
                      ),
                      // Add to cart
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            iconSize: 20,
                            onPressed: () {
                              context.read<CartCubit>().addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã thêm ${product.name}'),
                                  duration: const Duration(seconds: 1),
                                  action: SnackBarAction(
                                    label: 'Xem giỏ',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
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

// ============================================================================
// PRODUCT LIST TILE (List item)
// ============================================================================

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
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
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(' ${product.rating} (${product.reviewCount})'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (product.isOnSale) ...[
                        Text(
                          product.priceFormatted,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        product.effectivePriceFormatted,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: product.isOnSale ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add to cart
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    context.read<CartCubit>().addToCart(product);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
