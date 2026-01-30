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

library;

import 'package:flutter/material.dart';

// Ex13ProductGrid - Widget hiển thị danh sách sản phẩm
class Ex13ProductGrid extends StatelessWidget {
  const Ex13ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Grid')),
      backgroundColor: Colors.grey[100],
      // [Concept] GridView: Hiển thị danh sách dạng lưới
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        // gridDelegate: Quy định cấu trúc lưới
        // [Concept] SliverGridDelegateWithFixedCrossAxisCount: Cấu hình lưới cố định số cột
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số cột: 2
          mainAxisSpacing: 10, // Khoảng cách dọc
          crossAxisSpacing: 10, // Khoảng cách ngang
          childAspectRatio:
              0.75, // Tỷ lệ Chiều Rộng / Chiều Cao (0.75 -> Cao > Rộng)
        ),
        itemCount: 20, // Số lượng sản phẩm
        itemBuilder: (context, index) {
          // Hàm này được gọi lười (liên tục) khi user cuộn xuống
          return Card(
            elevation: 5, // Tạo bóng đổ
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bo góc
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Text ở đầu
              children: [
                // Expanded: Phần ảnh chiếm hết khoảng trống còn lại phía trên Text
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ), // Chỉ bo góc trên
                      // [Concept] DecorationImage: Thêm ảnh vào khung
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://picsum.photos/200?random=$index',
                        ),
                        fit: BoxFit.cover, // Lấp đầy khung
                      ),
                    ),
                  ),
                ),

                // Phần Text bên dưới
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product ${index + 1}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 16),
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
