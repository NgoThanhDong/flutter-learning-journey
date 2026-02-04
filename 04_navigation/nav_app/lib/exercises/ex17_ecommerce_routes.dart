/// ===========================================
/// EXERCISE 17: E-COMMERCE NAVIGATION
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xây dựng hệ thống navigation cho app bán hàng
/// - Danh sách -> Chi tiết (kèm Hero animation) -> Giỏ hàng
/// - Back navigation hợp lý
///
/// 📝 Routes:
/// - / (List)
/// - /product/:id (Detail)
/// - /cart (Cart)

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Mock Data
// Tạo danh sách sản phẩm mock với ID, tên và giá
// List.generate: Tạo danh sách với số lượng phần tử xác định
// (i) => {...}: Hàm tạo phần tử thứ i
// 'id': '$i': ID của sản phẩm là chuỗi từ index
// 'name': 'Sản phẩm $i': Tên sản phẩm với index
// 'price': '${(i + 1) * 100}k': Giá sản phẩm với index
final products = List.generate(
  10,
  (i) => {'id': '$i', 'name': 'Sản phẩm $i', 'price': '${(i + 1) * 100}k'},
);

// [Main Widget]
// Ex17EcommerceRoutes là widget chính của ứng dụng
class Ex17EcommerceRoutes extends StatelessWidget {
  const Ex17EcommerceRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo GoRouter với cấu hình routes
    final router = GoRouter(
      // Vị trí ban đầu khi ứng dụng khởi động
      initialLocation: '/',
      // Danh sách các route
      // GoRoute: Định nghĩa một route
      // path: Đường dẫn của route
      // builder: Widget sẽ được hiển thị khi route được gọi
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const StoreHomeScreen(),
          routes: [
            GoRoute(
              path: 'product/:id',
              builder: (context, state) {
                // Lấy ID từ path parameters
                // state.pathParameters: Map chứa các tham số từ URL
                // ['id']: Lấy giá trị của tham số 'id'
                // !: Ép kiểu sang non-nullable (chắc chắn có giá trị)
                final id = state.pathParameters['id']!;

                // Tìm sản phẩm từ ID mock
                // products.firstWhere: Tìm phần tử đầu tiên thỏa mãn điều kiện
                // (p) => p['id'] == id: Điều kiện tìm kiếm
                // orElse: Giá trị trả về nếu không tìm thấy sản phẩm nào
                final product = products.firstWhere(
                  (p) => p['id'] == id,
                  orElse: () => {'id': id, 'name': 'Unknown', 'price': '0'},
                );

                // Trả về ProductDetailScreen với thông tin sản phẩm
                return ProductDetailScreen(product: product);
              },
            ),
            GoRoute(
              path: 'cart',
              // pageBuilder: Sử dụng pageBuilder để tùy chỉnh transition
              pageBuilder: (context, state) => const MaterialPage(
                fullscreenDialog: true, // Mở kiểu modal từ dưới lên (iOS style)
                child: CartScreen(), // Widget sẽ được hiển thị khi route được gọi
              ),
            ),
          ],
        ),
      ],
    );

    // MaterialApp.router: Sử dụng routerConfig để cấu hình router
    // routerConfig: Cấu hình router
    // debugShowCheckedModeBanner: false: Ẩn debug banner
    // theme: Cấu hình theme
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    );
  }
}

// [Store Home Screen]
// Hiển thị danh sách sản phẩm dạng grid
class StoreHomeScreen extends StatelessWidget {
  const StoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Flutter Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            // Khi nhấn vào icon giỏ hàng, chuyển sang route /cart
            // context.go: Chuyển sang route được chỉ định
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),

      // body: GridView.builder: Tạo grid view để hiển thị danh sách sản phẩm
      // padding: Khoảng cách từ mép màn hình đến nội dung
      // gridDelegate: Cấu hình grid view
      // SliverGridDelegateWithFixedCrossAxisCount: Tạo grid view với số cột cố định
      // crossAxisCount: Số cột
      // childAspectRatio: Tỷ lệ chiều rộng trên chiều cao của mỗi item
      // crossAxisSpacing: Khoảng cách giữa các cột
      // mainAxisSpacing: Khoảng cách giữa các hàng
      // itemCount: Số lượng item
      // itemBuilder: Hàm tạo item
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index]; // Lấy sản phẩm tại index

          // GestureDetector: Widget để phát hiện cử chỉ
          // onTap: Hàm được gọi khi nhấn vào widget
          return GestureDetector(
            // Khi nhấn vào sản phẩm, chuyển sang route /product/:id
            // context.go: Chuyển sang route được chỉ định
            onTap: () => context.go('/product/${p['id']}'),
            // Card: Widget để hiển thị nội dung dạng thẻ
            // clipBehavior: Clip.antiAlias: Bo góc card
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text: Widget để hiển thị văn bản
                        // p['name']!: Lấy giá trị của tham số 'name'
                        // !: Ép kiểu sang non-nullable (chắc chắn có giá trị)
                        // style: Theme.of(context).textTheme.titleMedium: Lấy style từ theme
                        Text(
                          p['name']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          p['price']!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// [Product Detail Screen]
// Hiển thị chi tiết sản phẩm
class ProductDetailScreen extends StatelessWidget {
  // Khai báo biến product để nhận dữ liệu từ route
  final Map<String, String> product;

  // Constructor để nhận dữ liệu từ route
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name']!)),
      body: Column(
        children: [
          Container(
            height: 300,
            color: Colors.grey.shade300,
            width: double.infinity,
            child: const Icon(Icons.image, size: 100, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['name']!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      product['price']!,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mô tả chi tiết sản phẩm sẽ ở đây. Chất lượng tuyệt vời, giá cả phải chăng.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // bottomNavigationBar: SafeArea: Widget để hiển thị thanh điều hướng dưới cùng
      // padding: Khoảng cách từ mép màn hình đến nội dung
      // FilledButton.icon: Widget để hiển thị nút với icon và văn bản
      // onPressed: Hàm được gọi khi nhấn vào nút
      // icon: Icon hiển thị trên nút
      // label: Văn bản hiển thị trên nút
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton.icon(
            onPressed: () {
              // Add to cart logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Thêm vào giỏ'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}

// [Cart Screen]
// Hiển thị giỏ hàng
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng 🛒')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text('Giỏ hàng của bạn đang trống'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
