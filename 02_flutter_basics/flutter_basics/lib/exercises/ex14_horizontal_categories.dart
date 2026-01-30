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

// -TODO: Uncomment và hoàn thiện

class Ex14HorizontalCategories extends StatefulWidget {
  const Ex14HorizontalCategories({super.key});

  @override
  State<Ex14HorizontalCategories> createState() => _Ex14HorizontalCategoriesState();
}

class _Ex14HorizontalCategoriesState extends State<Ex14HorizontalCategories> {
  final List<String> categories = [
    'All', 'Fashion', 'Shoes', 'Electronics', 
    'Home', 'Beauty', 'Sports', 'Books', 'Toys'
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: Column(
        children: [
          // Khu vực Categories
          SizedBox(
            height: 50, // Cần fixed height cho ListView ngang
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
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
