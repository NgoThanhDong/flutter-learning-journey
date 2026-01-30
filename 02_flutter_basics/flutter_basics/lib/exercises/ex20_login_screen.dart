/// ===========================================
/// EXERCISE 20: LOGIN SCREEN (COMPLETE)
/// ===========================================
///
/// Đây là bài tập tổng hợp!
/// Tham khảo code mẫu trong lesson_08_practice.md

library;

import 'package:flutter/material.dart';

// -TODO: Uncomment và hoàn thiện

class Ex20LoginScreen extends StatefulWidget {
  const Ex20LoginScreen({super.key});

  @override
  State<Ex20LoginScreen> createState() => _Ex20LoginScreenState();
}

class _Ex20LoginScreenState extends State<Ex20LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60),
              
              // Logo
              Icon(
                Icons.flutter_dash,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              
              SizedBox(height: 40),
              
              // Welcome text
              Text(
                'Welcome Back!',
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              
              SizedBox(height: 8),
              
              // Forgot password
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
              
              // OR divider
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Social login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  TextButton(
                    onPressed: () {},
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialButton(IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(12),
        shape: CircleBorder(),
      ),
      child: Icon(icon, size: 24),
    );
  }
}
