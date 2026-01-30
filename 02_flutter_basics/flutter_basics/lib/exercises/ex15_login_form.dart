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

class Ex15LoginForm extends StatefulWidget {
  const Ex15LoginForm({super.key});

  @override
  State<Ex15LoginForm> createState() => _Ex15LoginFormState();
}

class _Ex15LoginFormState extends State<Ex15LoginForm> {
  // GlobalKey: Chìa khóa để truy cập trạng thái của Form từ bên ngoài (khi bấm nút submit)
  final _formKey = GlobalKey<FormState>();

  // Controller: Kiểm soát nội dung của TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables
  bool _obscurePassword = true; // Ẩn/hiện mật khẩu
  bool _rememberMe = false;

  // Dispose: Hủy controller khi màn hình đóng để tránh memory leak
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // [Validation] Kiểm tra xem tất cả các field trong Form có hợp lệ không
    if (_formKey.currentState!.validate()) {
      // Nếu OK -> Thực hiện login
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logging in...')));
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextFormField khác TextField thường ở chỗ nó hỗ trợ Validator
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Bàn phím có @
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(), // Viền bao quanh
                ),
                // Validation Logic
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email'; // Trả về text lỗi
                  }
                  if (!value.contains('@')) {
                    return 'Please enter valid email';
                  }
                  return null; // Null nghĩa là không có lỗi (Hợp lệ)
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword, // Che dấu ***
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  // Suffix Icon để toggle Ẩn/Hiện pass
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            // value có thể null nên dùng ?? false
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      Text('Remember me'),
                    ],
                  ),
                  TextButton(onPressed: () {}, child: Text('Forgot Password?')),
                ],
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
