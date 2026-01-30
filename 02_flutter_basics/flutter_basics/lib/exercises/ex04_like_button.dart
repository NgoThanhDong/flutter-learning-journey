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

// -TODO: Uncomment và hoàn thiện

class Ex04LikeButton extends StatefulWidget {
  const Ex04LikeButton({super.key});

  @override
  State<Ex04LikeButton> createState() => _Ex04LikeButtonState();
}

class _Ex04LikeButtonState extends State<Ex04LikeButton> {
  bool _isLiked = false;
  int _likeCount = 99;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
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
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút like
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.grey,
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

