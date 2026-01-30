/// ===========================================
/// EXERCISE 06: PRODUCT CARD
/// ===========================================
///
/// Mục tiêu: Kết hợp Container, Column, Row, Image, Styling
///
/// Yêu cầu:
/// - Tạo Product Card giống thiết kế e-commerce
/// - Ảnh sản phẩm (bo góc trên)
/// - Badge "SALE" (đè lên ảnh dùng Stack - hoặc đơn giản Container nếu chưa học Stack)
/// - Tên sản phẩm, Rating, Giá
/// - Nút Add to Cart
///
/// Lưu ý: Bài này nằm ở bài 3 (Basic Widgets) nên có thể chưa dùng Stack
/// Nhưng nếu bạn biết dùng Stack (Bài 4) thì càng tốt.
/// Ở đây ta dùng Container decoration đơn giản.

library;

import 'package:flutter/material.dart';

// -TODO: Uncomment và hoàn thiện

class Ex06ProductCard extends StatelessWidget {
  const Ex06ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('Product Card')),
      body: Center(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  'https://picsum.photos/300/300', // Random image
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              
              // 2. Nội dung text
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên
                    Text(
                      'Wireless Headphones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '4.8 (102 reviews)',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Giá và Nút mua
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$129.00',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                            onPressed: () {},
                            constraints: BoxConstraints.tightFor(
                              width: 40,
                              height: 40,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
