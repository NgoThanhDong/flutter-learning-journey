/// ===========================================
/// EXERCISE 02: OPEN/CLOSED PRINCIPLE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu OCP: Mở rộng được, không cần sửa đổi
/// - Dùng abstract class/interface để mở rộng
/// - Strategy pattern trong Flutter
///
/// 📝 OCP nói gì?
/// "Software entities should be open for extension,
///  but closed for modification"
/// = Thêm tính năng mới bằng cách thêm code, không sửa code cũ

library;

import 'package:flutter/material.dart';

/// ===========================================
/// ❌ VI PHẠM OCP - Phải sửa class khi thêm tính năng
/// ===========================================
class BadDiscountCalculator {
  double calculate(String type, double price) {
    /// Mỗi khi thêm discount mới, phải sửa method này!
    switch (type) {
      case 'percentage':
        return price * 0.1; // 10%
      case 'fixed':
        return 50.0;
      case 'buy2get1':
        return price / 3;
      // Thêm case mới ở đây... vi phạm OCP!
      default:
        return 0;
    }
  }
}

/// ===========================================
/// ✅ TUÂN THỦ OCP - Mở rộng qua interface
/// ===========================================

/// [DiscountStrategy] - Abstract interface
/// Định nghĩa contract cho tất cả discount types
abstract class DiscountStrategy {
  /// [name] - Tên hiển thị
  String get name;

  /// [calculate] - Tính discount
  double calculate(double originalPrice);

  /// [description] - Mô tả chi tiết
  String get description;
}

/// [PercentageDiscount] - Giảm theo phần trăm
class PercentageDiscount implements DiscountStrategy {
  final double percentage; // phần trăm giảm giá

  PercentageDiscount(this.percentage);

  @override
  String get name => 'Giảm $percentage%';

  @override
  String get description => 'Giảm $percentage% trên tổng đơn hàng';

  /// [calculate] - Tính discount
  @override
  double calculate(double originalPrice) {
    return originalPrice * (percentage / 100);
  }
}

/// [FixedDiscount] - Giảm số tiền cố định
class FixedDiscount implements DiscountStrategy {
  final double amount; // số tiền giảm giá

  FixedDiscount(this.amount);

  @override
  String get name => 'Giảm ${amount.toStringAsFixed(0)}đ';

  @override
  String get description => 'Giảm trực tiếp ${amount.toStringAsFixed(0)}đ';

  @override
  double calculate(double originalPrice) {
    return amount > originalPrice ? originalPrice : amount;
  }
}

/// [BuyXGetYDiscount] - Mua X tặng Y
class BuyXGetYDiscount implements DiscountStrategy {
  final int buy; // mua bao nhiêu
  final int free; // tặng bao nhiêu

  BuyXGetYDiscount({required this.buy, required this.free});

  @override
  String get name => 'Mua $buy tặng $free';

  @override
  String get description => 'Mua $buy sản phẩm, được tặng $free sản phẩm';

  @override
  double calculate(double originalPrice) {
    // Giả sử giá mỗi sản phẩm = originalPrice / (buy + free)
    final unitPrice = originalPrice / (buy + free);
    return unitPrice * free;
  }
}

/// [VIPDiscount] - Thêm discount mới mà KHÔNG sửa code cũ!
/// Đây là ví dụ về việc mở rộng (extension)
class VIPDiscount implements DiscountStrategy {
  final double percentage; // phần trăm giảm giá
  final double minOrder; // đơn tối thiểu

  VIPDiscount({required this.percentage, required this.minOrder});

  @override
  String get name => 'VIP $percentage%';

  @override
  String get description =>
      'Giảm $percentage% cho đơn từ ${minOrder.toStringAsFixed(0)}đ';

  @override
  double calculate(double originalPrice) {
    if (originalPrice >= minOrder) {
      return originalPrice * (percentage / 100);
    }
    return 0;
  }
}

/// ===========================================
/// [DiscountCalculator] - Không cần sửa khi thêm discount mới
/// ===========================================
class DiscountCalculator {
  /// [apply] - Áp dụng discount strategy
  /// Method này KHÔNG CẦN THAY ĐỔI khi thêm discount type mới
  double apply(DiscountStrategy strategy, double originalPrice) {
    return strategy.calculate(originalPrice);
  }

  /// [getFinalPrice] - Tính giá sau discount
  double getFinalPrice(DiscountStrategy strategy, double originalPrice) {
    // tính tiền discount
    final discount = apply(strategy, originalPrice);
    // tính tiền sau discount
    return originalPrice - discount;
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex02OpenClosed extends StatefulWidget {
  const Ex02OpenClosed({super.key});

  @override
  State<Ex02OpenClosed> createState() => _Ex02OpenClosedState();
}

class _Ex02OpenClosedState extends State<Ex02OpenClosed> {
  // controller cho input giá
  final _priceController = TextEditingController(text: '500000');
  // calculator
  final _calculator = DiscountCalculator();

  /// [Danh sách các strategies]
  /// Thêm strategy mới ở đây, KHÔNG cần sửa code ở đâu khác!
  final List<DiscountStrategy> _strategies = [
    PercentageDiscount(10),
    PercentageDiscount(20),
    FixedDiscount(50000),
    FixedDiscount(100000),
    BuyXGetYDiscount(buy: 2, free: 1),
    VIPDiscount(percentage: 15, minOrder: 300000),
  ];

  // chọn strategy
  DiscountStrategy? _selectedStrategy;

  // giá gốc
  double get _originalPrice => double.tryParse(_priceController.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex02: Open/Closed Principle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            const Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 OCP = Open/Closed Principle',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Thêm VIPDiscount mà KHÔNG sửa:\n'
                      '• DiscountCalculator\n'
                      '• Các discount classes khác\n'
                      '• UI code (chỉ thêm vào list)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Price input
            TextField(
              controller: _priceController, // controller cho input giá
              keyboardType: TextInputType.number, // bàn phím số
              decoration: const InputDecoration(
                labelText: 'Giá gốc (đ)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}), // cập nhật UI khi thay đổi
            ),

            const SizedBox(height: 24),

            // Strategy selection
            const Text(
              'Chọn loại giảm giá:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // danh sách các strategy
            RadioGroup<DiscountStrategy?>(
              // strategy đang được chọn
              groupValue: _selectedStrategy,
              // cập nhật strategy khi chọn
              onChanged: (value) {
                setState(() => _selectedStrategy = value);
              },
              child: Column(
                children: List.generate(_strategies.length, (index) {
                  // lấy strategy
                  final strategy = _strategies[index];
                  // kiểm tra strategy có được chọn không
                  final isSelected = _selectedStrategy == strategy;

                  return Card(
                    // đổi màu card khi được chọn
                    color: isSelected ? Colors.green[100] : null,
                    child: ListTile(
                      // radio button
                      leading: Radio<DiscountStrategy>(value: strategy),
                      // icon check khi được chọn
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      // tên strategy
                      title: Text(strategy.name),
                      // mô tả strategy
                      subtitle: Text(strategy.description),
                      // xử lý khi tap vào card
                      onTap: () {
                        setState(() => _selectedStrategy = strategy);
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Result
            if (_selectedStrategy != null)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // hiển thị giá gốc
                      _buildPriceRow('Giá gốc:', _originalPrice),

                      // hiển thị giảm giá
                      _buildPriceRow(
                        'Giảm giá:',
                        // tính giảm giá
                        _calculator.apply(_selectedStrategy!, _originalPrice),
                        isDiscount: true,
                      ),
                      const Divider(),

                      // hiển thị thành tiền
                      _buildPriceRow(
                        'Thành tiền:',
                        // tính thành tiền
                        _calculator.getFinalPrice(
                          _selectedStrategy!,
                          _originalPrice,
                        ),
                        isFinal: true,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // xây dựng hàng hiển thị giá
  Widget _buildPriceRow(
    String label,
    double value, {
    bool isDiscount = false,
    bool isFinal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${isDiscount ? "-" : ""}${value.toStringAsFixed(0)}đ',
            style: TextStyle(
              fontSize: isFinal ? 20 : 16,
              fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}
