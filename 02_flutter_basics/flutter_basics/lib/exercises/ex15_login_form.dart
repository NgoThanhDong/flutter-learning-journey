/// ===========================================
/// EXERCISE 15: LOGIN FORM
/// ===========================================
///
/// Mục tiêu: Tạo Form với validation
///
/// Yêu cầu:
/// - Email, Password fields
/// - Validation (Required, Email format, Password length)
/// - Toggle hide/show password
/// - Checkbox Remember Me

library;

import 'package:flutter/material.dart';

// Ex15LoginForm - Widget hiển thị form đăng nhập
class Ex15LoginForm extends StatefulWidget {
  const Ex15LoginForm({super.key}); // Tạo widget Ex15LoginForm

  @override
  State<Ex15LoginForm> createState() => _Ex15LoginFormState(); // Tạo state cho widget Ex15LoginForm
}

class _Ex15LoginFormState extends State<Ex15LoginForm> {
  // GlobalKey: Chìa khóa để truy cập trạng thái của Form từ bên ngoài (khi bấm nút submit)
  final _formKey = GlobalKey<FormState>(); // Tạo key cho form

  // Controller: Kiểm soát nội dung của TextField
  final _emailController = TextEditingController(); // Tạo controller cho email
  final _passwordController =
      TextEditingController(); // Tạo controller cho password

  // State variables
  bool _obscurePassword = true; // Ẩn/hiện mật khẩu
  bool _rememberMe = false; // Ghi nhớ đăng nhập

  // Dispose: Hủy controller khi màn hình đóng để tránh memory leak
  @override
  void dispose() {
    _emailController.dispose(); // Hủy controller cho email
    _passwordController.dispose(); // Hủy controller cho password
    super.dispose();
  }

  void _login() {
    // [Validation] Kiểm tra xem tất cả các field trong Form có hợp lệ không
    if (_formKey.currentState!.validate()) {
      // Kiểm tra form có hợp lệ không
      // Nếu OK -> Thực hiện login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in...')),
      ); // Hiển thị thông báo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      // SingleChildScrollView: Cần thiết để khung input trượt lên khi bàn phím hiện ra (tránh lỗi bottom overflow)
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        // Form: Container bao quanh các TextFormField, cung cấp validating chung
        child: Form(
          key: _formKey, // Gán key đã tạo
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Căn chỉnh các widget theo chiều ngang
            children: [
              // TextFormField khác TextField thường ở chỗ nó hỗ trợ Validator
              TextFormField(
                controller: _emailController, // Controller cho email
                keyboardType: TextInputType.emailAddress, // Bàn phím có @
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email), // Icon trước input
                  border: OutlineInputBorder(), // Viền bao quanh
                ),
                // Validation Logic
                validator: (value) {
                  // Validation Logic
                  if (value == null || value.isEmpty) {
                    // Kiểm tra email rỗng
                    return 'Please enter email'; // Trả về text lỗi
                  }
                  if (!value.contains('@')) {
                    // Kiểm tra email có @ không
                    return 'Please enter valid email';
                  }
                  return null; // Null nghĩa là không có lỗi (Hợp lệ)
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _passwordController, // Controller cho password
                obscureText: _obscurePassword, // Che dấu ***
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock), // Icon trước input
                  border: OutlineInputBorder(), // Viền bao quanh
                  // Suffix Icon để toggle Ẩn/Hiện pass
                  suffixIcon: IconButton(
                    // Icon để toggle Ẩn/Hiện pass
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                                .visibility // Hiện pass
                          : Icons.visibility_off, // Ẩn pass
                    ),
                    onPressed: () {
                      // Khi bấm nút
                      setState(() {
                        // Cập nhật state
                        _obscurePassword =
                            !_obscurePassword; // Toggle Ẩn/Hiện pass
                      });
                    },
                  ),
                ),
                validator: (value) {
                  // Validation Logic
                  if (value == null || value.isEmpty) {
                    // Kiểm tra password rỗng
                    return 'Please enter password'; // Trả về text lỗi
                  }
                  if (value.length < 6) {
                    // Kiểm tra password có ít nhất 6 ký tự không
                    return 'Password must be at least 6 characters'; // Trả về text lỗi
                  }
                  return null; // Null nghĩa là không có lỗi (Hợp lệ)
                },
              ),
              SizedBox(height: 8), // Khoảng cách giữa các widget

              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Căn chỉnh các widget theo chiều ngang
                children: [
                  Row(
                    children: [
                      Checkbox(
                        // Checkbox để ghi nhớ đăng nhập
                        value: _rememberMe, // Giá trị của checkbox
                        onChanged: (value) {
                          // Khi bấm nút
                          setState(() {
                            // Cập nhật state
                            // value có thể null nên dùng ?? false
                            _rememberMe = value ?? false; // Ghi nhớ đăng nhập
                          });
                        },
                      ),
                      Text('Remember me'), // Text ghi nhớ đăng nhập
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('Forgot Password?');
                    },
                    child: Text('Forgot Password?'),
                  ), // Text quên mật khẩu
                ],
              ),
              SizedBox(height: 24), // Khoảng cách giữa các widget

              ElevatedButton( // Nút đăng nhập
                onPressed: _login, // Gọi hàm _login khi bấm nút
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('LOGIN'), // Text trên nút đăng nhập
              ),
            ],
          ),
        ),
      ),
    );
  }
}
