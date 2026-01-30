/// ===========================================
/// EXERCISE 07: SOCIAL POST CARD
/// ===========================================
///
/// Mục tiêu: Layout phức tạp hơn với nhiều thành phần
///
/// Yêu cầu:
/// - Header: Avatar, Tên, Thời gian
/// - Content: Text nội dung status
/// - Image: Ảnh bài đăng (optional)
/// - Footer: Row chứa 3 nút (Like, Comment, Share)

library;

import 'package:flutter/material.dart';

// Ex07SocialPostCard - Widget để tạo thẻ bài đăng mạng xã hội
class Ex07SocialPostCard extends StatelessWidget {
  const Ex07SocialPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Màu nền xám nhạt
      appBar: AppBar(title: Text('Social Post')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            // Xác định hình dạng (shape) của widget Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Avatar + Info + More icon)
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // CircleAvatar: Ảnh đại diện tròn
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/100',
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sarah Wilson',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '2 hours ago',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      // Spacer: Chiếm hết khoảng trống thừa còn lại -> Đẩy icon cuối cùng sang sát lề phải
                      Spacer(),
                      // IconButton: Nút có icon
                      IconButton(
                        onPressed: () {
                          debugPrint('More');
                        },
                        icon: Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                ),

                // 2. Content Text
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                  ), // Padding 2 bên
                  child: Text(
                    'Just arrived in Paris! The weather is amazing. 🗼☕ #travel #paris #france',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 12),

                // 3. Image
                // Image.network: Hiển thị ảnh từ URL
                Image.network(
                  'https://picsum.photos/600/300',
                  height: 200,
                  width: double.infinity, // Chiều rộng full màn hình
                  fit: BoxFit.cover, // Resize ảnh chuẩn đẹp
                ),

                SizedBox(height: 8),

                // 4. Footer Actions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8), // Padding 2 bên
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround, // Chia đều không gian cho 3 nút
                    children: [
                      // TextButton.icon: Nút có cả icon và chữ
                      TextButton.icon(
                        icon: Icon(
                          Icons.thumb_up_alt_outlined,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Like',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          debugPrint('Like');
                        },
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.comment_outlined, color: Colors.grey),
                        label: Text(
                          'Comment',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          debugPrint('Comment');
                        },
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.share_outlined, color: Colors.grey),
                        label: Text(
                          'Share',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          debugPrint('Share');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
