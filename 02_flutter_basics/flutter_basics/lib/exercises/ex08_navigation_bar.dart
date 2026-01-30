/// ===========================================
/// EXERCISE 08: NAVIGATION BAR
/// ===========================================
///
/// Mục tiêu: Sử dụng Row, Expanded, Column để tạo Navigation Bar tùy chỉnh
/// (Thường dùng BottomNavigationBar widget có sẵn, nhưng ở đây ta tự build để luyện Layout)
///
/// Yêu cầu:
/// - Tạo thanh điều hướng ở dưới cùng màn hình
/// - 4 Icons: Home, Search, Favorites, Profile
/// - Icon & Text xếp dọc (Column)

library;

import 'package:flutter/material.dart';

// Ex08NavigationBar - Widget để tạo thanh điều hướng tùy chỉnh
class Ex08NavigationBar extends StatelessWidget {
  const Ex08NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: Widget cơ bản của Material Design, cung cấp cấu trúc màn hình
    // (AppBar, Body, BottomNavigationBar...)
    return Scaffold(
      appBar: AppBar(title: Text('Custom Nav Bar')),
      body: Center(child: Text('Content', style: TextStyle(fontSize: 24))),

      // bottomNavigationBar: Slot đặc biệt của Scaffold dành cho thanh điều hướng dưới cùng
      bottomNavigationBar: Container(
        height: 70, // Chiều cao cố định
        decoration: BoxDecoration(
          color: Colors.white,
          // Bóng đổ ngược lên trên (offset y = -2) để tách biệt với body
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          // [Quan trọng]
          // spaceAround: Chia đều khoảng cách giữa các phần tử và cả 2 đầu
          // Home -- Search -- Fav -- Profile
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true),
            _buildNavItem(Icons.search, 'Search', false),
            _buildNavItem(Icons.favorite_border, 'Favorites', false),
            _buildNavItem(Icons.person_outline, 'Profile', false),
          ],
        ),
      ),
    );
  }

  // Helper method: Tách code lặp lại ra hàm riêng -> Code gọn, dễ bảo trì
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      // Căn giữa nội dung trong Column (Icon và Text)
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          // Active thì màu xanh, in-active màu xám
          color: isActive ? Colors.blue : Colors.grey,
          iconSize: 28,
          onPressed: () {
            debugPrint('Pressed $label');
          },
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
