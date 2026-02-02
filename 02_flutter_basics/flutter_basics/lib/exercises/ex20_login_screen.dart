/// ===========================================
/// EXERCISE 20: LOGIN SCREEN (COMPLETE)
/// ===========================================
///
/// Đây là bài tập tổng hợp!
/// Tham khảo code mẫu trong lesson_08_practice.md

library;

import 'package:flutter/material.dart';

// Ex20LoginScreen - Bài tập tổng hợp Login Screen
class Ex20LoginScreen extends StatefulWidget {
  const Ex20LoginScreen({super.key});

  @override
  State<Ex20LoginScreen> createState() => _Ex20LoginScreenState();
}

class _Ex20LoginScreenState extends State<Ex20LoginScreen> {
  final _emailController =
      TextEditingController(); // TextEditingController là widget dùng để quản lý nội dung của TextField
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // Biến để ẩn/hiện password

  @override
  void dispose() {
    _emailController.dispose(); // Giải phóng bộ nhớ khi widget bị hủy
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold là widget dùng để tạo giao diện chính của ứng dụng
      // SafeArea: Đảm bảo nội dung không bị che bởi tai thỏ (notch) hoặc thanh điều hướng
      body: SafeArea(
        child: SingleChildScrollView(
          // SingleChildScrollView là widget cho phép cuộn trên màn hình nhỏ
          // Cho phép cuộn trên màn hình nhỏ
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Kéo dãn các con theo chiều ngang
            children: [
              SizedBox(height: 60), // Tạo khoảng cách 60px
              // Logo
              Icon(
                Icons.flutter_dash,
                size: 80,
                // Lấy màu primary từ theme hiện tại -> Hỗ trợ cả Dark/Light mode tự động
                color: Theme.of(context).colorScheme.primary,
              ),

              SizedBox(height: 40),

              // Welcome text
              Text(
                'Welcome Back!',
                // Copy style từ theme và chỉnh sửa thêm (copyWith)
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Login to continue',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // Email field
              TextField(
                controller:
                    _emailController, // TextField là widget dùng để nhập liệu
                keyboardType: TextInputType
                    .emailAddress, // TextInputType.emailAddress là kiểu bàn phím dùng để nhập email
                decoration: InputDecoration(
                  // InputDecoration là widget dùng để trang trí TextField
                  labelText:
                      'Email', // Label text là text hiển thị trên TextField
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ), // Icon hiển thị trước TextField
                  border: OutlineInputBorder(
                    // OutlineInputBorder là kiểu viền của TextField
                    borderRadius: BorderRadius.circular(12), // Bo góc TextField
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Password field
              TextField(
                controller:
                    _passwordController, // controller là widget dùng để quản lý nội dung của TextField
                obscureText:
                    _obscurePassword, // obscureText là thuộc tính để ẩn/hiện password
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                  ), // Icon hiển thị trước TextField
                  border: OutlineInputBorder(
                    // OutlineInputBorder là kiểu viền của TextField
                    borderRadius: BorderRadius.circular(12), // Bo góc TextField
                  ),
                  suffixIcon: IconButton(
                    // IconButton là widget dùng để hiển thị icon
                    icon: Icon(
                      _obscurePassword // obscureText là thuộc tính để ẩn/hiện password
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(
                        () => _obscurePassword = !_obscurePassword,
                      ); // setState là widget dùng để cập nhật trạng thái của widget
                    },
                  ),
                ),
              ),

              SizedBox(height: 8),

              // Forgot password (Align right)
              Align(
                // Align là widget dùng để căn chỉnh vị trí của widget
                alignment: Alignment.centerRight, // Căn chỉnh vị trí của widget
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?'),
                ),
              ),

              SizedBox(height: 24),

              // Login button
              ElevatedButton(
                // ElevatedButton là widget dùng để tạo nút bấm
                onPressed:
                    () {}, // onPressed là thuộc tính để xử lý sự kiện khi nút bấm được nhấn
                style: ElevatedButton.styleFrom(
                  // ElevatedButton.styleFrom là widget dùng để tạo style cho ElevatedButton
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ), // Padding là khoảng cách bên trong của widget
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Bo góc TextField
                  ),
                ),
                child: Text('LOGIN'),
              ),

              SizedBox(height: 24),

              // OR divider (Dùng Row + Divider)
              Row(
                children: [
                  Expanded(
                    child: Divider(),
                  ), // Divider là widget dùng để tạo đường kẻ ngang
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ), // Padding là khoảng cách bên trong của widget
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey),
                    ), // Text là widget dùng để hiển thị text
                  ),
                  Expanded(
                    child: Divider(),
                  ), // Divider là widget dùng để tạo đường kẻ ngang
                ],
              ),

              SizedBox(height: 24),

              // Social login keys
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // mainAxisAlignment là thuộc tính để căn chỉnh vị trí của widget
                children: [
                  _buildSocialButton(
                    Icons.g_mobiledata,
                  ), // _buildSocialButton là widget dùng để tạo nút bấm mạng xã hội
                  SizedBox(
                    width: 16,
                  ), // SizedBox là widget dùng để tạo khoảng cách
                  _buildSocialButton(
                    Icons.facebook,
                  ), // _buildSocialButton là widget dùng để tạo nút bấm mạng xã hội
                  SizedBox(
                    width: 16,
                  ), // SizedBox là widget dùng để tạo khoảng cách
                  _buildSocialButton(
                    Icons.apple,
                  ), // _buildSocialButton là widget dùng để tạo nút bấm mạng xã hội
                ],
              ),

              SizedBox(height: 40),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // mainAxisAlignment là thuộc tính để căn chỉnh vị trí của widget
                children: [
                  Text(
                    "Don't have an account?",
                  ), // Text là widget dùng để hiển thị text
                  TextButton(
                    onPressed: () {},
                    child: Text('Sign Up'),
                  ), // TextButton là widget dùng để tạo nút bấm
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget cho Social Button
  Widget _buildSocialButton(IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(12),
        shape: CircleBorder(), // Nút hình tròn
      ),
      child: Icon(icon, size: 24),
    );
  }
}
