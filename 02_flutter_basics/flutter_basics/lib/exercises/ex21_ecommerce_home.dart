/// ===========================================
/// EXERCISE 21: E-COMMERCE HOME
/// ===========================================
///
/// Mục tiêu: Trang chủ ứng dụng bán hàng
///
/// Yêu cầu:
/// - AppBar với Search Bar
/// - Banner quảng cáo (PageView)
/// - Categories (Horizontal List)
/// - Popular Products (Grid)
/// - Bottom Navigation Bar (Fake UI)

library;

import 'package:flutter/material.dart';

// Ex21EcommerceHome - Trang chủ ứng dụng bán hàng
class Ex21EcommerceHome extends StatelessWidget {
  const Ex21EcommerceHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Custom Title Area: Chứa Search Bar
        title: Container(
          // Container là widget dùng để tạo khung cho widget
          height: 40,
          decoration: BoxDecoration(
            // BoxDecoration là widget dùng để tạo khung cho widget
            color: Colors.grey[200], // Màu nền của widget
            borderRadius: BorderRadius.circular(8), // Bo góc của widget
          ),
          child: TextField(
            // TextField là widget dùng để tạo ô nhập liệu
            decoration: InputDecoration(
              hintText:
                  'Search products...', // Text hiển thị khi ô nhập liệu trống
              prefixIcon: Icon(Icons.search), // Icon là widget dùng để tạo icon
              border: InputBorder.none, // Bỏ viền mặc định
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
              ), // Padding là khoảng cách bên trong của widget
            ),
          ),
        ),
        actions: [
          // Actions là widget dùng để tạo icon ở cuối AppBar
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ), // IconButton là widget dùng để tạo icon
        ],
      ),

      // Body là widget dùng để tạo nội dung của trang
      body: SingleChildScrollView(
        // SingleChildScrollView là widget dùng để tạo thanh cuộn
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Banner
            Container(
              height: 180,
              margin: EdgeInsets.all(
                16,
              ), // Margin là khoảng cách bên ngoài của widget
              decoration: BoxDecoration(
                // BoxDecoration là widget dùng để tạo khung cho widget
                color: Colors.blue, // Màu nền của widget
                borderRadius: BorderRadius.circular(16), // Bo góc của widget
              ),
              child: Center(
                // Center là widget dùng để căn giữa widget
                child: Text(
                  'Summer Sale 50% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 2. Categories
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ), // Padding là khoảng cách bên trong của widget
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),

            // ListView ngang
            SizedBox(
              height:
                  90, // Bắt buộc set height cố định vì ListView nằm trong Column
              child: ListView(
                scrollDirection: Axis.horizontal, // Scroll theo chiều ngang
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ), // Padding là khoảng cách bên trong của widget
                children: [
                  // Children là danh sách các widget con
                  _buildCategoryItem(
                    Icons.phone_iphone,
                    'Phones',
                  ), // _buildCategoryItem là widget dùng để tạo danh mục
                  _buildCategoryItem(Icons.laptop, 'Laptops'),
                  _buildCategoryItem(Icons.watch, 'Watches'),
                  _buildCategoryItem(Icons.headset, 'Audio'),
                  _buildCategoryItem(Icons.videogame_asset, 'Gaming'),
                ],
              ),
            ),

            SizedBox(height: 16),

            // 3. Popular Products header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                // mainAxisAlignment là thuộc tính của widget Row dùng để căn chỉnh khoảng cách giữa các widget con
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('See All'),
                  ), // TextButton là widget dùng để tạo nút bấm
                ],
              ),
            ),

            // 4. Products Grid
            // [Thủ thuật] Nested Scrolling:
            // GridView nằm trong SingleChildScrollView -> Xung đột cuộn.
            // Giải pháp:
            // - shrinkWrap: true (Thu gọn Grid bằng nội dung)
            // - physics: NeverScrollableScrollPhysics() (Tắt cuộn Grid, dùng cuộn của SingleChildScrollView cha)
            GridView.builder(
              // GridView là widget dùng để tạo lưới
              shrinkWrap: true, // Thu gọn Grid bằng nội dung
              physics:
                  NeverScrollableScrollPhysics(), // Tắt cuộn Grid, dùng cuộn của SingleChildScrollView cha
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ), // Padding là khoảng cách bên trong của widget
              itemCount: 4, // Số lượng widget con
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // SliverGridDelegateWithFixedCrossAxisCount là widget dùng để tạo lưới
                crossAxisCount: 2, // Số lượng cột
                childAspectRatio:
                    0.7, // Tỷ lệ chiều rộng trên chiều cao của mỗi ô
                mainAxisSpacing:
                    16, // Khoảng cách giữa các widget con theo chiều dọc
                crossAxisSpacing:
                    16, // Khoảng cách giữa các widget con theo chiều ngang
              ),
              itemBuilder: (context, index) {
                // itemBuilder là hàm dùng để tạo widget con
                return Container(
                  decoration: BoxDecoration(
                    // BoxDecoration là widget dùng để tạo khung cho widget
                    color: Colors.white, // Màu nền của widget
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Bo góc của widget
                    border: Border.all(
                      color: Colors.grey[200]!,
                    ), // Viền của widget
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh sản phẩm
                      Expanded(
                        // Expanded là widget dùng để chiếm hết không gian còn lại
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // Thông tin
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$99.00',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar là thanh điều hướng ở dưới cùng của ứng dụng
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Hiển thị label cho cả 4 items
        items: [
          // Items là danh sách các mục trong thanh điều hướng
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ), // BottomNavigationBarItem là widget dùng để tạo mục trong thanh điều hướng
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'News',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  // Widget dùng để tạo danh mục
  Widget _buildCategoryItem(IconData icon, String label) {
    return Container(
      width: 70,
      margin: EdgeInsets.only(
        right: 12,
      ), // Margin là khoảng cách bên ngoài của widget
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(
              12,
            ), // Padding là khoảng cách bên trong của widget
            decoration: BoxDecoration(
              color: Colors.grey[100], // Màu nền của widget
              shape: BoxShape.circle, // Hình dạng của widget
            ),
            child: Icon(
              icon,
              color: Colors.blue,
            ), // Icon là widget dùng để tạo icon
          ),
          SizedBox(height: 4), // SizedBox là widget dùng để tạo khoảng cách
          Text(
            label,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center, // Căn chỉnh văn bản
          ),
        ],
      ),
    );
  }
}
