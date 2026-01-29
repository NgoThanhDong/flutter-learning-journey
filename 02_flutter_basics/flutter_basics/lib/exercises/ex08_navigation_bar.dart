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

import 'package:flutter/material.dart';

/*
class Ex08NavigationBar extends StatelessWidget {
  const Ex08NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Nav Bar')),
      body: Center(child: Text('Content')),
      
      // Nav bar ở bottom
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Chia đều khoảng cách
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
  
  // Helper widget để code gọn hơn
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.blue : Colors.grey,
          size: 28,
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
*/
