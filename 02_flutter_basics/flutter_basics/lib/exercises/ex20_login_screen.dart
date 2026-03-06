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
  // TextEditingController là widget dùng để quản lý nội dung của TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Biến để ẩn/hiện password
  bool _obscurePassword = true;

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
          padding: EdgeInsets.all(24),
          child: Column(
            // Kéo dãn các con theo chiều ngang
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                // TextField là widget dùng để nhập liệu
                controller: _emailController,
                // TextInputType.emailAddress là kiểu bàn phím dùng để nhập email
                keyboardType: TextInputType.emailAddress,
                // InputDecoration là widget dùng để trang trí TextField
                decoration: InputDecoration(
                  // Label text là text hiển thị trên TextField
                  labelText: 'Email',
                  // Icon hiển thị trước TextField
                  prefixIcon: Icon(Icons.email_outlined),
                  // OutlineInputBorder là kiểu viền của TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Bo góc TextField
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                // obscureText là thuộc tính để ẩn/hiện password
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  // Icon hiển thị trước TextField
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Bo góc TextField
                  ),
                  // IconButton là widget dùng để hiển thị icon
                  suffixIcon: IconButton(
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
              // Align là widget dùng để căn chỉnh vị trí của widget
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?'),
                ),
              ),

              SizedBox(height: 24),

              // Login button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('LOGIN'),
              ),

              SizedBox(height: 24),

              // OR divider (Dùng Row + Divider)
              Row(
                children: [
                  // Divider là widget dùng để tạo đường kẻ ngang
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: 24),

              // Social login keys
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _buildSocialButton là widget dùng để tạo nút bấm mạng xã hội
                  _buildSocialButton(Icons.g_mobiledata),
                  SizedBox(width: 16),
                  _buildSocialButton(Icons.facebook),
                  SizedBox(width: 16),
                  _buildSocialButton(Icons.apple),
                ],
              ),

              SizedBox(height: 40),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 8),
                  TextButton(onPressed: () {}, child: Text('Sign Up')),
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
