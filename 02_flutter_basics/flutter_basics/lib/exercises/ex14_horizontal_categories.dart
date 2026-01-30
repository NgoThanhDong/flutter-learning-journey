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

import 'package:flutter/material.dart';

class Ex14HorizontalCategories extends StatefulWidget {
  const Ex14HorizontalCategories({super.key});

  @override
  State<Ex14HorizontalCategories> createState() =>
      _Ex14HorizontalCategoriesState();
}

class _Ex14HorizontalCategoriesState extends State<Ex14HorizontalCategories> {
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
          SizedBox(
            height: 50, // Chiều cao cố định cho list ngang
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Hướng cuộn: Ngang
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    alignment: Alignment.center,
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

          Divider(),

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
