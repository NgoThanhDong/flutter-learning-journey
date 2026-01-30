/// ===========================================
/// EXERCISE 10: PROFILE HEADER
/// ===========================================
///
/// Mục tiêu: Sử dụng Stack và Positioned
///
/// Yêu cầu:
/// - Ảnh bìa (Cover image) làm nền phía trên
/// - Ảnh đại diện (Avatar) hình tròn đè lên giữa ảnh bìa và phần dưới
/// - Tên và thông tin bên dưới

library;

import 'package:flutter/material.dart';

class Ex10ProfileHeader extends StatelessWidget {
  const Ex10ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Header')),
      body: Column(
        children: [
          // [Concept] Stack: Cho phép xếp chồng các Widget lên nhau (layer).
          // Widget viết sau sẽ đè lên Widget viết trước.
          Stack(
            // clipBehavior.none: Cho phép con (Avatar) vẽ tràn ra ngoài khung Stack -> Hiệu ứng avatar nằm đè lên biên giới.
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter, // Các con mặc định căn giữa đáy
            children: [
              // 1. Layer dưới cùng: Cover Image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/800/400'),
                    fit: BoxFit.cover, // Cắt ảnh để lấp đầy khung
                  ),
                ),
              ),

              // 2. Layer trên: Avatar
              // Positioned: Định vị trí tuyệt đối trong Stack
              Positioned(
                bottom:
                    -50, // Tràn xuống dưới đáy Stack 50px (tạo hiệu ứng 1/2 nằm trên cover, 1/2 nằm dưới)
                child: Container(
                  padding: EdgeInsets.all(4), // Tạo viền trắng dày 4px
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu viền
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),
                ),
              ),
            ],
          ),

          // [Tip] Vì Avatar tràn xuống 50px và có bán kính 50px (tổng ~100px)
          // Ta cần SizedBox khoảng 60px để đẩy text bên dưới xuống, tránh bị Avatar che mất.
          SizedBox(height: 60),

          // Thông tin
          Text(
            'Jessica Parker',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'UX/UI Designer',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
