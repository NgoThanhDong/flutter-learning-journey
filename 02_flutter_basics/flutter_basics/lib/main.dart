/// ============================================================
/// MAIN.DART - ĐIỂM KHỞI ĐẦU CỦA ỨNG DỤNG FLUTTER
/// ============================================================
///
/// Chào bạn! Đây là file quan trọng nhất của mọi ứng dụng Flutter.
/// Khi bạn chạy app, Flutter sẽ tìm hàm `main()` ở đây để bắt đầu.
///
/// File này hiện tại đang đóng vai trò là "Mục lục" (Menu)
/// giúp bạn truy cập vào từng bài tập (Ex01 -> Ex22) mà bạn đã code.

library;

import 'package:flutter/material.dart';

// [IMPORT LIST]
// Để Main thấy được các file bài tập, ta cần import chúng vào đây.

import 'exercises/ex01_hello_flutter.dart';
import 'exercises/ex02_counter.dart';
import 'exercises/ex03_toggle_theme.dart';
import 'exercises/ex04_like_button.dart';
import 'exercises/ex05_profile_card.dart';
import 'exercises/ex06_product_card.dart';
import 'exercises/ex07_social_post_card.dart';
import 'exercises/ex08_navigation_bar.dart';
import 'exercises/ex09_price_row.dart';
import 'exercises/ex10_profile_header.dart';
import 'exercises/ex11_grid_layout.dart';
import 'exercises/ex12_contact_list.dart';
import 'exercises/ex13_product_grid.dart';
import 'exercises/ex14_horizontal_categories.dart';
import 'exercises/ex15_login_form.dart';
import 'exercises/ex16_registration_form.dart';
import 'exercises/ex17_settings_page.dart';
import 'exercises/ex18_app_theme.dart';
import 'exercises/ex19_dark_mode_toggle.dart';
import 'exercises/ex20_login_screen.dart';
import 'exercises/ex21_ecommerce_home.dart';
import 'exercises/ex22_chat_ui.dart';

/// Hàm main() là cửa ngõ đầu tiên.
/// Nó gọi runApp() để khởi động widget root của ứng dụng.
void main() {
  runApp(const MyApp());
}

/// MyApp là Widget gốc (Root Widget) của cả ứng dụng.
/// Thường nó là một Stateless widget chứa MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // const MyApp({super.key}): tạo widget MyApp

  // build: xây dựng widget
  // @override: ghi đè phương thức build
  // context: ngữ cảnh của widget
  @override
  Widget build(BuildContext context) {
    // MaterialApp: Widget bao bọc toàn bộ ứng dụng theo phong cách Material Design (Google).
    // Nó cung cấp các tính năng cốt lõi như: Navigation, Theme, Localization...
    return MaterialApp(
      title: 'Flutter Basics', // Tên app khi thu nhỏ
      debugShowCheckedModeBanner: false, // Tắt chữ "DEBUG" ở góc phải
      // Theme: Cấu hình màu sắc, font chữ chung cho toàn app
      theme: ThemeData(
        // ColorScheme: Cấu hình màu sắc cho toàn app
        // seedColor: Màu sắc chủ đạo của app
        // fromSeed: Tạo ColorScheme từ seedColor
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // sử dụng Material Design 3
      ),
      // home: Màn hình đầu tiên hiện ra khi mở app
      // Ở đây ta gọi ExerciseListScreen (màn hình danh sách bài tập)
      home: const ExerciseListScreen(),
    );
  }
}

/// Màn hình hiển thị danh sách tất cả các bài tập
class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: Cung cấp cấu trúc cơ bản cho màn hình (AppBar, Body, BottomNavigationBar...)
    return Scaffold(
      appBar: AppBar(
        // AppBar: Thanh tiêu đề ở trên cùng
        title: const Text('Phase 2: Flutter Basics'), // Tiêu đề của AppBar
        centerTitle: true, // căn giữa tiêu đề
        backgroundColor: Colors.blue[100], // Màu nền nhẹ cho AppBar
      ),

      // body: Phần thân chính của màn hình
      // ListView: Cho phép cuộn danh sách (vì danh sách bài tập rất dài)
      body: ListView(
        padding: const EdgeInsets.all(16), // Khoảng cách lề cho ListView
        children: [
          // Danh sách các widget con
          // Nhóm các bài tập theo từng bài học (Lesson) để dễ theo dõi
          _buildLessonSection(context, 'Bài 1: Introduction', [
            // Mỗi item gồm: Tên hiển thị + Widget màn hình tương ứng
            _ExerciseItem('Ex 01: Hello Flutter', const Ex01HelloFlutter()),
          ]),
          _buildLessonSection(context, 'Bài 2: Widget Fundamentals', [
            _ExerciseItem('Ex 02: Counter App', const Ex02Counter()),
            _ExerciseItem('Ex 03: Toggle Theme', const Ex03ToggleTheme()),
            _ExerciseItem('Ex 04: Like Button', const Ex04LikeButton()),
          ]),
          _buildLessonSection(context, 'Bài 3: Basic Widgets', [
            _ExerciseItem('Ex 05: Profile Card', const Ex05ProfileCard()),
            _ExerciseItem('Ex 06: Product Card', const Ex06ProductCard()),
            _ExerciseItem(
              'Ex 07: Social Post (Phức tạp)',
              const Ex07SocialPostCard(),
            ),
          ]),
          _buildLessonSection(context, 'Bài 4: Layout (Row/Column)', [
            _ExerciseItem('Ex 08: Custom Nav Bar', const Ex08NavigationBar()),
            _ExerciseItem('Ex 09: Price Row', const Ex09PriceRow()),
            _ExerciseItem('Ex 10: Profile Header', const Ex10ProfileHeader()),
            _ExerciseItem('Ex 11: Grid Layout (Wrap)', const Ex11GridLayout()),
          ]),
          _buildLessonSection(context, 'Bài 5: Scrollable List', [
            _ExerciseItem(
              'Ex 12: Contact List (ListView)',
              const Ex12ContactList(),
            ),
            _ExerciseItem(
              'Ex 13: Product Grid (GridView)',
              const Ex13ProductGrid(),
            ),
            _ExerciseItem(
              'Ex 14: Horizontal Categories',
              const Ex14HorizontalCategories(),
            ),
          ]),
          _buildLessonSection(context, 'Bài 6: Input & Form', [
            _ExerciseItem('Ex 15: Login Form', const Ex15LoginForm()),
            _ExerciseItem(
              'Ex 16: Registration Form',
              const Ex16RegistrationForm(),
            ),
            _ExerciseItem('Ex 17: Settings Page', const Ex17SettingsPage()),
          ]),
          _buildLessonSection(context, 'Bài 7: Styling & Theme', [
            _ExerciseItem('Ex 18: App Theme Rules', const Ex18AppTheme()),
            _ExerciseItem(
              'Ex 19: Dark Mode Toggle',
              const Ex19DarkModeToggle(),
            ),
          ]),
          _buildLessonSection(context, 'Bài 8: Practice Projects', [
            _ExerciseItem(
              'Ex 20: Login Screen Complete',
              const Ex20LoginScreen(),
            ),
            _ExerciseItem('Ex 21: E-commerce Home', const Ex21EcommerceHome()),
            _ExerciseItem('Ex 22: Chat UI Detail', const Ex22ChatUI()),
          ]),
          // Khoảng trống dưới cùng để không bị cấn nút Home của điện thoại
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Hàm helper để xây dựng giao diện cho từng nhóm bài học
  /// Giúp code gọn gàng hơn, tránh lặp lại code tạo Card/ListTile nhiều lần.
  Widget _buildLessonSection(
    BuildContext context,
    String title,
    List<_ExerciseItem> exercises, // Danh sách các bài tập trong nhóm
  ) {
    // Card: Tạo một khung có bo góc và đổ bóng
    return Card(
      margin: const EdgeInsets.only(bottom: 16), // Khoảng cách lề dưới
      elevation: 2, // Độ nổi bóng đổ
      child: Padding(
        // Padding: Tạo khoảng cách lề trong
        padding: const EdgeInsets.all(16), // Khoảng cách lề trong
        child: Column(
          // Column: Sắp xếp các widget theo chiều dọc
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
          children: [
            // Tiêu đề bài học
            Text(
              title,
              // Theme.of(context): Lấy theme hiện tại của app
              // .textTheme: Lấy bộ font chữ của theme
              // .titleMedium: Lấy font chữ cho tiêu đề cỡ trung bình
              // .copyWith: Copy và chỉnh sửa font chữ
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, // In đậm
                color: Colors.blue[800], // Màu xanh dương
              ),
            ),
            const Divider(), // Đường kẻ ngang
            // Danh sách bài tập trong bài học này
            ...exercises.map(
              (ex) => ListTile(
                // ListTile: Tạo một dòng trong danh sách
                contentPadding: EdgeInsets.zero, // Xóa khoảng cách lề mặc định
                // Icon trạng thái: Xanh = Có bài, Xám = Chưa có
                // Kiểm tra xem có bài tập không
                // Nếu có -> Hiển thị icon check, màu xanh
                // Nếu không -> Hiển thị icon radio, màu xám
                leading: Icon(
                  ex.widget != null
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: ex.widget != null ? Colors.green : Colors.grey,
                ),
                title: Text(ex.name), // Tên bài tập
                // Icon mũi tên chỉ sang phải
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                // [Quan trọng] Khi bấm vào item -> Chuyển màn hình
                // Navigator.push: Đẩy màn hình mới vào ngăn xếp (stack) màn hình.
                // Màn hình mới đè lên màn hình cũ. Có thể bấm Back để quay lại.
                // Kiểm tra xem có bài tập không, nếu có thì chuyển màn hình
                // Nếu không có thì hiện thông báo
                onTap: ex.widget != null
                    ? () {
                        Navigator.push(
                          context,
                          // MaterialPageRoute: Hiệu ứng chuyển cảnh chuẩn Android/iOS
                          MaterialPageRoute(builder: (_) => ex.widget!),
                        );
                      }
                    : () {
                        // Nếu chưa có widget (null) thì hiện thông báo
                        // ScaffoldMessenger.of(context): Lấy ScaffoldMessenger hiện tại
                        // .showSnackBar: Hiển thị thông báo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bài tập này chưa được liên kết!'),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Class đơn giản chứa thông tin mỗi bài tập
class _ExerciseItem {
  final String name; // Tên hiển thị
  final Widget? widget; // Màn hình bài tập tương ứng

  _ExerciseItem(this.name, this.widget);
}
