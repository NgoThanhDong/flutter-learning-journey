/// ===========================================
/// EXERCISE 12: DOMAIN ENTITIES
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tạo Domain Entities với Equatable
/// - Value Object pattern
/// - Immutable entities
///
/// 📝 Entity trong Clean Architecture:
/// - Pure Dart classes
/// - Không có JSON/serialization
/// - Chứa business logic
/// - Dùng Equatable cho comparison

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// ===========================================
/// VALUE OBJECTS
/// ===========================================

/// [Email] - Value Object cho email
/// Value Object = Immutable, equality by value
class Email extends Equatable {
  final String value;

  /// Private constructor - dùng factory để validate
  const Email._(this.value);

  /// Factory constructor với validation
  factory Email(String value) {
    final trimmed = value.trim().toLowerCase();
    if (!_isValid(trimmed)) {
      throw ArgumentError('Invalid email: $value');
    }
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

  static bool _isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

/// [Money] - Value Object cho tiền
class Money extends Equatable {
  final double amount;
  final String currency;

  const Money._(this.amount, this.currency);

  factory Money(double amount, {String currency = 'VND'}) {
    if (amount < 0) throw ArgumentError('Amount cannot be negative');
    return Money._(amount, currency);
  }

  /// [Operators] - Business logic trong Value Object
  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money(amount + other.amount, currency: currency);
  }

  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract different currencies');
    }
    return Money(amount - other.amount, currency: currency);
  }

  Money operator *(double multiplier) {
    return Money(amount * multiplier, currency: currency);
  }

  String get formatted {
    final formatted = amount.toStringAsFixed(0);
    return '$formatted $currency';
  }

  @override
  List<Object?> get props => [amount, currency];

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
  final String productId;
  final String productName;
  final int quantity;
  final Money unitPrice;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  /// [subtotal] - Computed property
  Money get subtotal => unitPrice * quantity.toDouble();

  /// [copyWith] - Immutable update
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

  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice];
}

/// [Order] - Main Domain Entity
class Order extends Equatable {
  final String id;
  final String customerId;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final Email? customerEmail;

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

  /// [copyWith] - Immutable update
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
  late Order _order;

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

  void _changeStatus(OrderStatus status) {
    setState(() {
      _order = _order.copyWith(status: status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex12: Domain Entities'),
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
              spacing: 8,
              children: OrderStatus.values.map((status) {
                final isDisabled = _order.status == status;
                return ElevatedButton(
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
    return Chip(
      label: Text(status.name, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

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
