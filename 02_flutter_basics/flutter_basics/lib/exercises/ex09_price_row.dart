/// ===========================================
/// EXERCISE 09: PRICE ROW
/// ===========================================
///
/// Mục tiêu: Sử dụng Row, Expanded, Spacer
///
/// Yêu cầu:
/// - Tạo row hiển thị thông tin giỏ hàng
/// - Tên sản phẩm bên trái (có thể dài -> Expanded)
/// - Số lượng ở giữa
/// - Giá tiền ở bên phải

library;

// import 'package:flutter/material.dart';

/*
class Ex09PriceRow extends StatelessWidget {
  const Ex09PriceRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Price Row')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildItem('MacBook Pro M3 Max 16 inch', 1, 3499.00),
            Divider(),
            _buildItem('Magic Mouse', 2, 79.00),
            Divider(),
            _buildItem('USB-C Adapter', 5, 19.99),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String name, int qty, double price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // 1. Tên sản phẩm - Chiếm hết không gian còn lại
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // ... nếu dài quá
            ),
          ),
          
          // 2. Số lượng
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('x$qty'),
          ),
          
          SizedBox(width: 16),
          
          // 3. Giá tiền
          Text(
            '\$${(price * qty).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }
}
*/
