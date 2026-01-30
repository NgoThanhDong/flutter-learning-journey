/// ===========================================
/// EXERCISE 11: GRID LAYOUT
/// ===========================================
///
/// Mục tiêu: Sử dụng Wrap hoặc GridView (Preview cho bài sau)
///
/// Yêu cầu:
/// - Tạo danh sách 4 thẻ thống kê (Stats)
/// - Xếp 2 cột trên mỗi hàng
/// - Mỗi thẻ gồm: Icon, Số liệu, Tiêu đề

library;

import 'package:flutter/material.dart';

// Ex11GridLayout - Widget để tạo dashboard grid
class Ex11GridLayout extends StatelessWidget {
  const Ex11GridLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard Grid')),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16),
        // [Concept] Wrap: Giống Row nhưng tự động xuống dòng khi hết chỗ.
        // Rất tiện để làm layout dạng lưới đơn giản mà không cần tính toán nhiều như GridView.
        child: Wrap(
          spacing: 16, // Khoảng cách ngang giữa các phần tử
          runSpacing: 16, // Khoảng cách dọc giữa các dòng
          children: [
            _buildCard(Icons.people, '1,204', 'Users', Colors.blue),
            _buildCard(Icons.shopping_bag, '340', 'Orders', Colors.orange),
            _buildCard(Icons.attach_money, '\$12k', 'Revenue', Colors.green),
            _buildCard(Icons.star, '4.8', 'Rating', Colors.purple),
          ],
        ),
      ),
    );
  }

  // _buildCard - Widget để tạo card thống kê
  Widget _buildCard(IconData icon, String value, String label, Color color) {
    return Container(
      width:
          160, // [Lưu ý] Wrap cần biết width con để xác định khi nào xuống dòng.
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow( // Tạo bóng đổ
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 10, // Độ mờ của bóng
            offset: Offset(0, 2), // Vị trí của bóng
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              // make color transparent: 10% opacity
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
