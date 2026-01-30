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

import 'package:flutter/material.dart';

// Ex09PriceRow - Widget để tạo hàng hiển thị thông tin giỏ hàng
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
            _buildItem(
              'MacBook Pro M3 Max 16 inch 1TB SSD 32GB RAM',
              1,
              3499.00,
            ),

            // Divider: Đường kẻ ngang
            Divider(
              height: 20,
              thickness: 1, // Độ dày của đường kẻ
              color: Colors.grey, // Màu của đường kẻ
              indent: 4, // Khoảng cách từ lề trái
              endIndent: 4, // Khoảng cách từ lề phải
            ),

            _buildItem('Magic Mouse', 2, 79.00),

            Divider(
              height: 20,
              thickness: 1,
              color: Colors.grey,
              indent: 4,
              endIndent: 4,
            ),

            _buildItem('USB-C Adapter', 5, 19.99),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String name, int qty, double price) {
    return Padding(
      // Tạo khoảng cách đều 12px cho cả trên, dưới, trái, phải
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          // [Quan trọng]
          // Expanded: Bắt buộc `name` phải chiếm HẾT khoảng trống còn lại trong Row.
          // Nếu tên dài quá, nó sẽ tự xuống dòng hoặc cắt bớt (ellipsis) chứ không gây lỗi Overflow.
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 1, // Chỉ hiện 1 dòng
              overflow: TextOverflow.ellipsis, // Nếu dài quá thì hiện dấu ...
            ),
          ),

          // Số lượng (Width tự động theo nội dung)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'x$qty',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(width: 16),

          // Giá tiền (Width tự động)
          Container(
            width: 100,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            // Tạo khung bo tròn
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              // toStringAsFixed(2): Định dạng số thập phân có 2 số sau dấu phẩy (19.99)
              '\$${(price * qty).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
              textAlign: TextAlign.right, // Căn phải
            ),
          ),
        ],
      ),
    );
  }
}
