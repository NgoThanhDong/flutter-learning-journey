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

// -TODO: Uncomment và hoàn thiện

class Ex10ProfileHeader extends StatelessWidget {
  const Ex10ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Header')),
      body: Column(
        children: [
          // Stack chứa Cover + Avatar
          Stack(
            clipBehavior: Clip.none, // Cho phép avatar tràn ra ngoài Stack
            alignment: Alignment.bottomCenter, // Căn giữa đáy
            children: [
              // 1. Cover Image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/800/400'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // 2. Avatar - Sử dụng Positioned để đẩy xuống dưới
              // Hoặc đơn giản là dùng alignment của Stack + padding/margin
              // Ở đây dùng Positioned để minh họa
              Positioned(
                bottom: -50, // Tràn xuống dưới 50px
                child: Container(
                  padding: EdgeInsets.all(4), // Viền trắng
                  decoration: BoxDecoration(
                    color: Colors.white,
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
          
          SizedBox(height: 60), // Khoảng trống cho Avatar
          
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
