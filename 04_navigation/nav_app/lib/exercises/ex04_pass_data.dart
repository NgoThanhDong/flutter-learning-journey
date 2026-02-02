/// ===========================================
/// EXERCISE 04: PASSING DATA (TRUYỀN DỮ LIỆU)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Truyền dữ liệu từ màn hình A -> B
/// - Sử dụng Constructor để nhận dữ liệu
///
/// 📝 Giải thích:
/// - Cách đơn giản nhất để truyền data trong Navigator 1.0 là pass qua Constructor của Widget đích.
/// - Data phải được khai báo final trong Widget đích.

library;

import 'package:flutter/material.dart';

// [Data Model] Class chứa dữ liệu cần truyền
class Product {
  final String name;
  final double price;
  final String description;

  const Product(this.name, this.price, this.description);
}

class Ex04PassData extends StatelessWidget {
  const Ex04PassData({super.key});

  // Danh sách sản phẩm mẫu
  final List<Product> products = const [
    Product('Laptop Gaming', 1500, 'CPU i9, RTX 4080'),
    Product('Smartphone Pro', 999, 'Camera 200MP'),
    Product('Tai nghe Noise', 250, 'Chống ồn chủ động'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex04: Pass Data')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              /// [Truyền Data]
              /// Khởi tạo widget đích và truyền data vào constructor
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Màn hình chi tiết nhận dữ liệu
class ProductDetailScreen extends StatelessWidget {
  // [1] Khai báo biến final để nhận data
  final Product product;

  // [2] Constructor yêu cầu data
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name), // Sử dụng data
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 24, color: Colors.blue.shade700),
            ),
            const SizedBox(height: 20),
            Text(
              'Mô tả sản phẩm:',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            Text(product.description, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
