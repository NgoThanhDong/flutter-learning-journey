/// ============================================================================
/// EXERCISE 12: CART CUBIT
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Quản lý giỏ hàng với Cubit.
///
/// 📝 BẠN SẼ HỌC:
/// - Cart state management
/// - Add/remove/update quantity
/// - Coupon codes
/// - Total calculations
/// - Persist cart (bonus)
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'ex11_product_model.dart';

// ============================================================================
// CART STATE
// ============================================================================
///
/// State của giỏ hàng.
///
/// ## Properties:
/// - [items]: Danh sách CartItem
/// - [couponCode]: Mã giảm giá đang áp dụng
/// - [discount]: Số tiền được giảm
///
/// ## Computed Properties:
/// - [subtotal]: Tổng tiền trước giảm
/// - [total]: Tổng tiền sau giảm
/// - [itemCount]: Số loại sản phẩm
/// - [totalQuantity]: Tổng số lượng
/// - [isEmpty]: Giỏ hàng trống không
///
// ============================================================================

class CartState extends Equatable {
  /// Danh sách items trong giỏ.
  final List<CartItem> items;

  /// Mã giảm giá đang áp dụng (null = không có).
  final String? couponCode;

  /// Số tiền được giảm.
  final double discount;

  /// Đang loading (khi apply coupon).
  final bool isLoading;

  /// Message lỗi.
  final String? error;

  const CartState({
    this.items = const [],
    this.couponCode,
    this.discount = 0,
    this.isLoading = false,
    this.error,
  });

  // ==========================================================================
  // COMPUTED PROPERTIES
  // ==========================================================================

  /// Tổng tiền trước giảm giá.
  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  /// Tổng tiền sau giảm giá.
  double get total => subtotal - discount;

  /// Số loại sản phẩm trong giỏ.
  int get itemCount => items.length;

  /// Tổng số lượng sản phẩm.
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Giỏ hàng trống không.
  bool get isEmpty => items.isEmpty;

  /// Có coupon không.
  bool get hasCoupon => couponCode != null && discount > 0;

  /// Format tổng tiền.
  String get subtotalFormatted => _formatPrice(subtotal);
  String get discountFormatted => _formatPrice(discount);
  String get totalFormatted => _formatPrice(total);

  static String _formatPrice(double price) {
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

  CartState copyWith({
    List<CartItem>? items,
    String? couponCode,
    bool clearCoupon = false,
    double? discount,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CartState(
      items: items ?? this.items,
      couponCode: clearCoupon ? null : (couponCode ?? this.couponCode),
      discount: clearCoupon ? 0 : (discount ?? this.discount),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [items, couponCode, discount, isLoading, error];
}

// ============================================================================
// CART CUBIT
// ============================================================================
///
/// Cubit quản lý giỏ hàng.
///
/// ## Actions:
/// - addToCart: Thêm sản phẩm
/// - removeFromCart: Xóa sản phẩm
/// - updateQuantity: Cập nhật số lượng
/// - applyCoupon: Áp dụng mã giảm giá
/// - removeCoupon: Xóa mã giảm giá
/// - clearCart: Xóa toàn bộ giỏ hàng
///
// ============================================================================

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  // ==========================================================================
  // AVAILABLE COUPONS (simulated)
  // ==========================================================================

  static const _coupons = <String, double>{
    'SAVE10': 0.10, // 10%
    'SAVE20': 0.20, // 20%
    'VIP50': 0.50, // 50%
    'FIXED100K': 100000, // 100k fixed
  };

  // ==========================================================================
  // ADD TO CART
  // ==========================================================================
  ///
  /// Thêm sản phẩm vào giỏ.
  ///
  /// Nếu sản phẩm đã có trong giỏ → Tăng quantity.
  /// Nếu chưa có → Thêm mới với quantity = 1.
  ///
  // ==========================================================================

  void addToCart(Product product, {int quantity = 1}) {
    // Clear any previous error
    if (state.error != null) {
      emit(state.copyWith(clearError: true));
    }

    // Check stock
    if (product.stock < quantity) {
      emit(state.copyWith(error: 'Không đủ hàng trong kho'));
      return;
    }

    // Find existing item
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItem> newItems;

    if (existingIndex >= 0) {
      // Update existing item
      final existing = state.items[existingIndex];
      final newQuantity = existing.quantity + quantity;

      // Check stock again for total quantity
      if (newQuantity > product.stock) {
        emit(state.copyWith(error: 'Không đủ hàng trong kho'));
        return;
      }

      newItems = List.from(state.items);
      newItems[existingIndex] = existing.copyWith(quantity: newQuantity);
    } else {
      // Add new item
      newItems = [
        ...state.items,
        CartItem(product: product, quantity: quantity),
      ];
    }

    emit(state.copyWith(items: newItems));

    // Recalculate discount if coupon applied
    if (state.hasCoupon) {
      _recalculateDiscount();
    }
  }

  // ==========================================================================
  // REMOVE FROM CART
  // ==========================================================================

  void removeFromCart(String productId) {
    final newItems =
        state.items.where((item) => item.product.id != productId).toList();

    emit(state.copyWith(items: newItems));

    // Recalculate discount
    if (state.hasCoupon) {
      _recalculateDiscount();
    }
  }

  // ==========================================================================
  // UPDATE QUANTITY
  // ==========================================================================

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = state.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (itemIndex < 0) return;

    final item = state.items[itemIndex];

    // Check stock
    if (newQuantity > item.product.stock) {
      emit(state.copyWith(error: 'Chỉ còn ${item.product.stock} sản phẩm'));
      return;
    }

    final newItems = List<CartItem>.from(state.items);
    newItems[itemIndex] = item.copyWith(quantity: newQuantity);

    emit(state.copyWith(items: newItems, clearError: true));

    // Recalculate discount
    if (state.hasCoupon) {
      _recalculateDiscount();
    }
  }

  /// Tăng quantity.
  void increaseQuantity(String productId) {
    final item = state.items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => throw StateError('Product not found'),
    );
    updateQuantity(productId, item.quantity + 1);
  }

  /// Giảm quantity.
  void decreaseQuantity(String productId) {
    final item = state.items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => throw StateError('Product not found'),
    );
    updateQuantity(productId, item.quantity - 1);
  }

  // ==========================================================================
  // APPLY COUPON
  // ==========================================================================
  ///
  /// Áp dụng mã giảm giá.
  ///
  /// Flow:
  /// 1. Validate code
  /// 2. Calculate discount
  /// 3. Update state
  ///
  // ==========================================================================

  Future<void> applyCoupon(String code) async {
    final normalized = code.trim().toUpperCase();

    if (normalized.isEmpty) {
      emit(state.copyWith(error: 'Vui lòng nhập mã giảm giá'));
      return;
    }

    // Start loading
    emit(state.copyWith(isLoading: true, clearError: true));

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final discountValue = _coupons[normalized];

    if (discountValue == null) {
      emit(state.copyWith(isLoading: false, error: 'Mã giảm giá không hợp lệ'));
      return;
    }

    // Calculate discount
    double calculatedDiscount;
    if (discountValue < 1) {
      // Percentage discount
      calculatedDiscount = state.subtotal * discountValue;
    } else {
      // Fixed discount
      calculatedDiscount = discountValue;
    }

    // Cap discount at subtotal
    if (calculatedDiscount > state.subtotal) {
      calculatedDiscount = state.subtotal;
    }

    emit(
      state.copyWith(
        isLoading: false,
        couponCode: normalized,
        discount: calculatedDiscount,
      ),
    );
  }

  // ==========================================================================
  // REMOVE COUPON
  // ==========================================================================

  void removeCoupon() {
    emit(state.copyWith(clearCoupon: true));
  }

  // ==========================================================================
  // RECALCULATE DISCOUNT
  // ==========================================================================

  void _recalculateDiscount() {
    if (state.couponCode == null) return;

    final discountValue = _coupons[state.couponCode];
    if (discountValue == null) return;

    double calculatedDiscount;
    if (discountValue < 1) {
      calculatedDiscount = state.subtotal * discountValue;
    } else {
      calculatedDiscount = discountValue;
    }

    if (calculatedDiscount > state.subtotal) {
      calculatedDiscount = state.subtotal;
    }

    emit(state.copyWith(discount: calculatedDiscount));
  }

  // ==========================================================================
  // CLEAR CART
  // ==========================================================================

  void clearCart() {
    emit(const CartState());
  }

  // ==========================================================================
  // HELPER: Check if product is in cart
  // ==========================================================================

  bool isInCart(String productId) {
    return state.items.any((item) => item.product.id == productId);
  }

  int getQuantity(String productId) {
    for (final item in state.items) {
      if (item.product.id == productId) {
        return item.quantity;
      }
    }
    return 0;
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex12CartCubit extends StatelessWidget {
  const Ex12CartCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => CartCubit(), child: const _CartDemo());
  }
}

class _CartDemo extends StatefulWidget {
  const _CartDemo();

  @override
  State<_CartDemo> createState() => _CartDemoState();
}

class _CartDemoState extends State<_CartDemo> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex12: Cart Cubit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Badge(
                label: Text('${state.totalQuantity}'),
                isLabelVisible: state.totalQuantity > 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Products to add
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: const Text(
              '📦 Chọn sản phẩm để thêm vào giỏ:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: SampleProducts.all.length,
              itemBuilder: (context, index) {
                final product = SampleProducts.all[index];
                return _MiniProductCard(product: product);
              },
            ),
          ),

          const Divider(),

          // Cart Items
          Expanded(
            child: BlocBuilder<CartCubit, CartState>(
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

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Error message
                    if (state.error != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(state.error!),
                          ],
                        ),
                      ),

                    // Cart items
                    ...state.items.map((item) => _CartItemTile(item: item)),

                    const Divider(height: 32),

                    // Coupon
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              hintText: 'Mã giảm giá (SAVE10, SAVE20)',
                              border: const OutlineInputBorder(),
                              isDense: true,
                              suffixIcon:
                                  state.hasCoupon
                                      ? IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          context
                                              .read<CartCubit>()
                                              .removeCoupon();
                                          _couponController.clear();
                                        },
                                      )
                                      : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed:
                              state.isLoading
                                  ? null
                                  : () {
                                    context.read<CartCubit>().applyCoupon(
                                      _couponController.text,
                                    );
                                  },
                          child:
                              state.isLoading
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text('Áp dụng'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Summary
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: 'Tạm tính',
                              value: state.subtotalFormatted,
                            ),
                            if (state.hasCoupon)
                              _SummaryRow(
                                label: 'Giảm giá (${state.couponCode})',
                                value: '-${state.discountFormatted}',
                                valueColor: Colors.green,
                              ),
                            const Divider(),
                            _SummaryRow(
                              label: 'Tổng cộng',
                              value: state.totalFormatted,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CartCubit>().clearCart();
                        _couponController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text('Xóa giỏ hàng'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniProductCard extends StatelessWidget {
  final Product product;

  const _MiniProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        child: InkWell(
          onTap: () {
            context.read<CartCubit>().addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm ${product.name}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.category.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.add_circle, color: Colors.green, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: item.product.category.color.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text(item.product.category.icon)),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.product.effectivePriceFormatted,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Quantity
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed:
                      item.canDecrease
                          ? () => context.read<CartCubit>().decreaseQuantity(
                            item.product.id,
                          )
                          : null,
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed:
                      item.canIncrease
                          ? () => context.read<CartCubit>().increaseQuantity(
                            item.product.id,
                          )
                          : null,
                ),
              ],
            ),
            // Subtotal
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.subtotalFormatted,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed:
                      () => context.read<CartCubit>().removeFromCart(
                        item.product.id,
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : null,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
