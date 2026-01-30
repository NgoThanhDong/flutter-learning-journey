/// ===========================================
/// EXERCISE 05: PROFILE CARD
/// ===========================================
///
/// Mục tiêu: Sử dụng các Basic Widgets
///
/// Yêu cầu:
/// - Avatar (CircleAvatar)
/// - Tên (Text bold)
/// - Bio (Text nhỏ, màu xám)
/// - Location với Icon

library;

import 'package:flutter/material.dart';

class Ex05ProfileCard extends StatelessWidget {
  const Ex05ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Card')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          // Card: Widget có sẵn shadow và bo góc nhẹ, thường dùng để group thông tin
          child: Card(
            elevation: 4, // Độ nổi của Card (bóng đổ đậm hơn nếu số to)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                // [Quan trọng]
                // MainAxisSize.min: Column chỉ cao vừa đủ nội dung.
                // Nếu không dùng cái này, Column sẽ chiếm hết height màn hình -> Card bị kéo dài vô duyên.
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CircleAvatar: Widget tạo ảnh tròn tiện lợi
                  CircleAvatar(
                    radius: 50, // Bán kính
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150',
                    ), // Load ảnh từ mạng
                  ),
                  SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Flutter Developer | Tech Enthusiast',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign:
                        TextAlign.center, // Căn giữa text nếu nó dài quá 1 dòng
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min, // Row cũng chỉ rộng vừa đủ
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Ho Chi Minh, Vietnam',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
