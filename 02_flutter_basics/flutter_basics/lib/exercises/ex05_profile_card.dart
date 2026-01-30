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
    return Scaffold( // Scaffold: Cấu trúc cơ bản của màn hình
      appBar: AppBar(title: Text('Profile Card')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          // Card: Widget có sẵn shadow và bo góc nhẹ, thường dùng để group thông tin
          child: Card(
            elevation: 4, // Độ nổi của Card (bóng đổ đậm hơn nếu số to)
            shape: RoundedRectangleBorder(
              // Hình chữ nhật có bo góc
              borderRadius: BorderRadius.circular(16), // Bo tròn tất cả 4 góc
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                // [Quan trọng]
                // MainAxisSize.min: Column chỉ cao vừa đủ nội dung.
                // Nếu không dùng cái này, Column sẽ chiếm hết height màn hình -> Card bị kéo dài vô duyên.
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 200,
                    height: 200,

                    decoration: BoxDecoration(
                      // Màu nền
                      color: Colors.white,
                      // Gradient
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      // Border
                      border: Border.all(color: Colors.black, width: 2),
                      // Bo góc
                      // borderRadius: BorderRadius.circular(12),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),

                      // Cấu hình đổ bóng (shadow) cho widget
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black26, // black26 = đen với độ trong suốt 26%
                          offset: Offset(
                            0,
                            4,
                          ), // offset = vị trí của bóng (bóng đổ xuống dưới 4px)
                          blurRadius:
                              8, // blurRadius = độ mờ của bóng (Số càng lớn → bóng càng mềm)
                          spreadRadius:
                              2, // spreadRadius = độ rộng của bóng (> 0 → bóng to ra, < 0 → bóng nhỏ lại)
                        ),
                      ],
                    ),

                    // CircleAvatar: Widget tạo ảnh tròn tiện lợi
                    child: CircleAvatar(
                      radius: 50, // Bán kính
                      backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/22424228?v=4',
                      ), // Load ảnh từ mạng
                    ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    'Ngo Thanh Dong',
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

                  const SizedBox(height: 16),
                  // RichText: Cho phép hiển thị text với nhiều style khác nhau trong cùng 1 widget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Skills: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Flutter, Dart, C++',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Hoặc dùng Text.rich
                      Text.rich(
                        TextSpan(
                          text: 'Salary: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '\$1000',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '/month',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
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
