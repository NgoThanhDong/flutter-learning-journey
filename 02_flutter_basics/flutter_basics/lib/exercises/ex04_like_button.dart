/// ===========================================
/// EXERCISE 04: LIKE BUTTON
/// ===========================================
///
/// Mục tiêu: Quản lý state logic phức tạp hơn chút
///
/// Yêu cầu:
/// - Hiển thị 1 nút Like (Icon Heart)
/// - Hiển thị số lượng like bên cạnh
/// - Khi bấm nút:
///   + Nếu chưa like -> Like: Icon màu đỏ, số like + 1
///   + Nếu đã like -> Unlike: Icon màu xám, số like - 1
///   + Có animation nhỏ (optional - nâng cao)

library;

import 'package:flutter/material.dart';

class Ex04LikeButton extends StatefulWidget {
  const Ex04LikeButton({super.key});

  @override
  State<Ex04LikeButton> createState() => _Ex04LikeButtonState();
}

class _Ex04LikeButtonState extends State<Ex04LikeButton> {
  // Trạng thái đã like hay chưa
  bool _isLiked = false;
  // Số lượng like hiện tại
  int _likeCount = 99;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked; // Đảo ngược trạng thái
      // Logic cập nhật số lượng
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Like Button')),
      body: Center(
        child: Container(
          // Padding bên trong Container
          padding: EdgeInsets.all(16),
          // Decoration: Trang trí cho Container (màu nền, bo góc, bóng đổ)
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16), // Bo tròn 4 góc
            // BoxShadow: Tạo hiệu ứng nổi (bóng đổ)
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Màu bóng mờ nhạt
                blurRadius: 10, // Độ nhòe của bóng
                offset: Offset(
                  0,
                  5,
                ), // Độ lệch bóng (x=0, y=5 -> bóng xuống dưới)
              ),
            ],
          ),
          child: Row(
            // mainAxisSize.min: Row chỉ rộng bằng nội dung bên trong (không chiếm hết chiều ngang)
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút like
              IconButton(
                // Icon thay đổi tùy theo state
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.grey, // Màu cũng đổi
                  size: 40,
                ),
                onPressed: _toggleLike,
              ),

              SizedBox(width: 12),

              // Số lượng
              Text(
                '$_likeCount Likes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
