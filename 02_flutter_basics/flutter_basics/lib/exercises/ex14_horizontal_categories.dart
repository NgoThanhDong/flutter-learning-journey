/// ===========================================
/// EXERCISE 14: HORIZONTAL CATEGORIES
/// ===========================================
///
/// Mục tiêu: ListView horizontal
///
/// Yêu cầu:
/// - Tạo danh sách categories (All, Fashion, Electronics, Home...)
/// - Cuộn ngang
/// - Item được chọn đổi màu nền

library;

import 'dart:ui';

import 'package:flutter/material.dart';

// Ex14HorizontalCategories - Widget hiển thị danh sách categories
class Ex14HorizontalCategories extends StatefulWidget {
  const Ex14HorizontalCategories({super.key});

  @override
  State<Ex14HorizontalCategories> createState() =>
      _Ex14HorizontalCategoriesState();
}

class _Ex14HorizontalCategoriesState extends State<Ex14HorizontalCategories> {
  // List chứa các category
  final List<String> categories = [
    'All',
    'Fashion',
    'Shoes',
    'Electronics',
    'Home',
    'Beauty',
    'Sports',
    'Books',
    'Toys',
  ];
  int _selectedIndex = 0; // Lưu index đang được chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: Column(
        children: [
          // Khu vực Categories
          // [Quan Trọng] ListView khi nằm trong Column phải có chiều cao xác định.
          // Nếu không có SizedBox bao ngoài, ListView sẽ ko biết nó cao bao nhiêu -> Lỗi layout.
          Container(
            margin: EdgeInsets.only(top: 16),
            height: 50, // Chiều cao cố định cho list ngang
            child: ScrollConfiguration( // ScrollConfiguration và cho phép mouse drag
              // ScrollConfiguration.of(context) lấy behavior hiện tại của context
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch, 
                  PointerDeviceKind.mouse, // ⭐ CHÌA KHÓA
                },
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Hướng cuộn: Ngang
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ), // Padding cho list ngang
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedIndex;
                  // GestureDetector: Widget giúp bắt sự kiện chạm (tap, drag...)
                  // vì Container thường ko có sự kiện này.
                  return GestureDetector(
                    onTap: () {
                      // Cập nhật UI khi chọn item mới
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 12,
                      ), // Padding giữa các item
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ), // Padding cho item
                      alignment: Alignment.center, // Căn giữa chữ
                      decoration: BoxDecoration(
                        // Màu nền thay đổi theo trạng thái
                        color: isSelected ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          // Màu chữ cũng đổi (nền xanh -> chữ trắng, nền xám -> chữ đen)
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Divider: Tạo đường kẻ ngang
          Divider(),

          // Hiển thị category được chọn
          Expanded(
            child: Center(
              child: Text(
                'Selected: ${categories[_selectedIndex]}',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
