/// ===========================================
/// EXERCISE 13: PRODUCT GRID
/// ===========================================
///
/// Mục tiêu: Sử dụng GridView.builder
///
/// Yêu cầu:
/// - Hiển thị lưới sản phẩm 2 cột
/// - Mỗi sản phẩm có: Ảnh, Tên, Giá
/// - Grid có spacing dọc và ngang

import 'package:flutter/material.dart';

/*
class Ex13ProductGrid extends StatelessWidget {
  const Ex13ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Grid')),
      backgroundColor: Colors.grey[100],
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cột
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75, // Tỷ lệ rộng/cao (0.75 = cao hơn rộng)
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh (chiếm phần lớn không gian, dùng Expanded)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage('https://picsum.photos/200?random=$index'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Thông tin
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product $index',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${(index + 1) * 10}.00',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/
