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

// import 'package:flutter/material.dart';

/*
class Ex11GridLayout extends StatelessWidget {
  const Ex11GridLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard Grid')),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16),
        // Cách 1: Dùng Wrap (Tự động xuống dòng)
        child: Wrap(
          spacing: 16,    // Khoảng cách ngang
          runSpacing: 16, // Khoảng cách dọc
          children: [
            _buildCard(Icons.people, '1,204', 'Users', Colors.blue),
            _buildCard(Icons.shopping_bag, '340', 'Orders', Colors.orange),
            _buildCard(Icons.attach_money, '\$12k', 'Revenue', Colors.green),
            _buildCard(Icons.star, '4.8', 'Rating', Colors.purple),
          ],
        ),
        
        // Cách 2: Dùng Row + Column (Thủ công)
        // child: Column( ... )
      ),
    );
  }

  Widget _buildCard(IconData icon, String value, String label, Color color) {
    // Tính toán width: (Màn hình - padding - spacing) / 2
    // Để đơn giản, ta dùng fix width hoặc LayoutBuilder
    return Container(
      width: 160, // Fixed width cho demo
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
*/
