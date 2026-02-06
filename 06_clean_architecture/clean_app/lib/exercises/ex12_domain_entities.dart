/// ===========================================
/// EXERCISE 12: DOMAIN ENTITIES
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tạo Domain Entities với Equatable (để so sánh)
/// - Value Object pattern (để đóng gói dữ liệu)
/// - Immutable entities (để đảm bảo tính bất biến)
///
/// 📝 Entity trong Clean Architecture:
/// - Pure Dart classes (chỉ chứa logic nghiệp vụ)
/// - Không có JSON/serialization (để đảm bảo tính bất biến)
/// - Chứa business logic
/// - Dùng Equatable cho comparison (để so sánh)

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// ===========================================
/// VALUE OBJECTS
/// ===========================================

/// [Email] - Value Object cho email
/// Value Object = Immutable, equality by value (bằng nhau nếu giá trị bằng nhau)
class Email extends Equatable {
  final String value;

  /// Private constructor - dùng factory để validate
  const Email._(this.value);

  /// Factory constructor với validation
  factory Email(String value) {
    // trim() - loại bỏ khoảng trắng ở đầu và cuối
    // toLowerCase() - chuyển về chữ thường
    final trimmed = value.trim().toLowerCase();
    if (!_isValid(trimmed)) {
      // throw ArgumentError - ném lỗi nếu invalid
      throw ArgumentError('Invalid email: $value');
    }

    // return Email._(trimmed) - tạo instance mới với giá trị đã validate
    return Email._(trimmed);
  }

  /// [tryCreate] - Không throw, trả về null nếu invalid
  static Email? tryCreate(String value) {
    try {
      return Email(value);
    } catch (_) {
      return null;
    }
  }

  // Regex - biểu thức chính quy để validate email
  static bool _isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Equatable - để so sánh (equality by value)
  @override
  List<Object?> get props => [value];

  // toString - để in ra giá trị
  @override
  String toString() => value;
}

/// [Money] - Value Object cho tiền
class Money extends Equatable {
  final double amount; // số tiền
  final String currency; // đơn vị tiền tệ

  // Private constructor - dùng factory để validate
  const Money._(this.amount, this.currency);

  // Factory constructor với validation
  factory Money(double amount, {String currency = 'VND'}) {
    // amount < 0 - không cho phép số âm
    if (amount < 0) throw ArgumentError('Amount cannot be negative');
    return Money._(amount, currency);
  }

  /// [Operators] - Business logic trong Value Object
  /// Toán tử cộng
  Money operator +(Money other) {
    // currency != other.currency - không cho phép cộng khác đơn vị tiền tệ
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money(amount + other.amount, currency: currency);
  }

  // Toán tử trừ
  Money operator -(Money other) {
    // currency != other.currency - không cho phép trừ khác đơn vị tiền tệ
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract different currencies');
    }
    return Money(amount - other.amount, currency: currency);
  }

  // Toán tử nhân
  Money operator *(double multiplier) {
    return Money(amount * multiplier, currency: currency);
  }

  // Định dạng tiền tệ
  String get formatted {
    final formatted = amount.toStringAsFixed(0);
    return '$formatted $currency';
  }

  // Equatable - để so sánh (equality by value)
  @override
  List<Object?> get props => [amount, currency];

  // toString - để in ra giá trị
  @override
  String toString() => formatted;
}

/// ===========================================
/// DOMAIN ENTITIES
/// ===========================================

/// [OrderStatus] - Enum cho trạng thái
enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

/// [OrderItem] - Entity con
class OrderItem extends Equatable {
  final String productId; // ID sản phẩm
  final String productName; // Tên sản phẩm
  final int quantity; // Số lượng
  final Money unitPrice; // Giá đơn vị

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  /// [subtotal] - Computed property (tổng tiền)
  Money get subtotal => unitPrice * quantity.toDouble();

  /// [copyWith] - Immutable update (cập nhật không thay đổi)
  OrderItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
    Money? unitPrice,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  // Equatable - để so sánh (equality by value)
  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice];
}

/// [Order] - Main Domain Entity
class Order extends Equatable {
  final String id; // ID đơn hàng
  final String customerId; // ID khách hàng
  final List<OrderItem> items; // Danh sách sản phẩm
  final OrderStatus status; // Trạng thái
  final DateTime createdAt; // Thời gian tạo
  final Email? customerEmail; // Email khách hàng

  const Order({
    required this.id,
    required this.customerId,
    required this.items,
    required this.status,
    required this.createdAt,
    this.customerEmail,
  });

  /// ===========================================
  /// BUSINESS LOGIC trong Entity
  /// ===========================================

  /// [total] - Tổng tiền đơn hàng
  Money get total {
    if (items.isEmpty) return Money(0);
    return items.fold(Money(0), (sum, item) => sum + item.subtotal);
  }

  /// [itemCount] - Số lượng sản phẩm
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// [canCancel] - Business rule: chỉ hủy khi pending
  bool get canCancel => status == OrderStatus.pending;

  /// [canShip] - Business rule: chỉ ship khi confirmed
  bool get canShip => status == OrderStatus.confirmed;

  /// [copyWith] - Immutable update (cập nhật không thay đổi)
  Order copyWith({
    String? id,
    String? customerId,
    List<OrderItem>? items,
    OrderStatus? status,
    DateTime? createdAt,
    Email? customerEmail,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      customerEmail: customerEmail ?? this.customerEmail,
    );
  }

  // Equatable - để so sánh (equality by value)
  @override
  List<Object?> get props => [id, customerId, items, status, createdAt];
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex12DomainEntities extends StatefulWidget {
  const Ex12DomainEntities({super.key});

  @override
  State<Ex12DomainEntities> createState() => _Ex12DomainEntitiesState();
}

class _Ex12DomainEntitiesState extends State<Ex12DomainEntities> {
  late Order _order; // Order instance

  /// [initState] - Initialize state (khởi tạo state)
  @override
  void initState() {
    super.initState();

    _order = Order(
      id: 'ORD-001',
      customerId: 'CUST-123',
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      customerEmail: Email('customer@example.com'),
      items: [
        OrderItem(
          productId: 'P1',
          productName: 'iPhone 15',
          quantity: 1,
          unitPrice: Money(25000000),
        ),
        OrderItem(
          productId: 'P2',
          productName: 'AirPods Pro',
          quantity: 2,
          unitPrice: Money(6000000),
        ),
      ],
    );
  }

  /// [addItem] - Add new item to order (thêm sản phẩm vào đơn hàng)
  void _addItem() {
    setState(() {
      _order = _order.copyWith(
        items: [
          ..._order.items,
          OrderItem(
            productId: 'P${_order.items.length + 1}',
            productName: 'New Product ${_order.items.length + 1}',
            quantity: 1,
            unitPrice: Money(1000000),
          ),
        ],
      );
    });
  }

  /// [changeStatus] - Change order status (thay đổi trạng thái đơn hàng)
  void _changeStatus(OrderStatus status) {
    setState(() {
      _order = _order.copyWith(status: status);
    });
  }

  /// [build] - Build UI (build giao diện)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex12: Domain Entities'),
        // Nút thêm sản phẩm
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info
            const Card(
              color: Colors.purple,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Domain Entities & Value Objects',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Order, OrderItem: Entities với Equatable\n'
                      '• Email, Money: Value Objects\n'
                      '• Business logic trong Entity (canCancel, total)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Order info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${_order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Customer: ${_order.customerId}'),
                    Text('Email: ${_order.customerEmail}'),
                    Text('Created: ${_order.createdAt}'),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status: ${_order.status.name.toUpperCase()}'),
                        // Hiển thị chip trạng thái
                        _buildStatusChip(_order.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status buttons
            Wrap(
              spacing: 8, // Khoảng cách giữa các nút
              runSpacing: 8, // Khoảng cách giữa các hàng
              children: OrderStatus.values.map((status) {
                final isDisabled = _order.status == status;
                return ElevatedButton(
                  // Tắt nút khi trạng thái không hợp lệ
                  onPressed: isDisabled ? null : () => _changeStatus(status),
                  child: Text(status.name),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Business rules
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Business Rules:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    // Hiển thị các quy tắc kinh doanh
                    _buildRuleRow('Can Cancel', _order.canCancel),
                    _buildRuleRow('Can Ship', _order.canShip),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Items
            const Text(
              'Order Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Hiển thị danh sách sản phẩm
            ...List.generate(_order.items.length, (index) {
              final item = _order.items[index];
              return ListTile(
                title: Text(item.productName),
                subtitle: Text('${item.unitPrice} x ${item.quantity}'),
                trailing: Text(item.subtotal.formatted),
              );
            }),

            const Divider(),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _order.total.formatted,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildStatusChip] - Build status chip (hiển thị chip trạng thái)
  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
      case OrderStatus.confirmed:
        color = Colors.blue;
      case OrderStatus.shipped:
        color = Colors.purple;
      case OrderStatus.delivered:
        color = Colors.green;
      case OrderStatus.cancelled:
        color = Colors.red;
    }
    // Hiển thị chip trạng thái
    return Chip(
      label: Text(status.name, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  /// [_buildRuleRow] - Build rule row (hiển thị hàng quy tắc)
  Widget _buildRuleRow(String rule, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(rule),
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red,
        ),
      ],
    );
  }
}
