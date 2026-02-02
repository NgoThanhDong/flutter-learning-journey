/// ===========================================
/// EXERCISE 16: REGISTRATION FORM
/// ===========================================
///
/// Mục tiêu: Form phức tạp với nhiều loại input
///
/// Yêu cầu:
/// - Name, Email, Phone fields
/// - Password và Confirm Password
/// - Gender (Radio)
/// - Accept terms (Checkbox)
/// - Register button
/// - Full validation

library;

import 'package:flutter/material.dart';

// Ex16RegistrationForm - Widget hiển thị form đăng ký
class Ex16RegistrationForm extends StatefulWidget {
  const Ex16RegistrationForm({super.key});

  @override
  State<Ex16RegistrationForm> createState() => _Ex16RegistrationFormState();
}

// enum Gender: Định nghĩa các giá trị Radio
enum Gender { male, female, other }

class _Ex16RegistrationFormState extends State<Ex16RegistrationForm> {
  final _formKey = GlobalKey<FormState>(); // Tạo form key
  Gender? _gender = Gender.male; // Lưu giá trị Radio đang chọn
  bool _agreedToTerms = false; // Lưu giá trị Checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        // SingleChildScrollView: Cho phép scroll
        padding: EdgeInsets.all(24),
        child: Form(
          // Form: Widget chứa các TextFormField
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Text lề trái
            children: [
              TextFormField(
                // TextFormField: Input text
                decoration: InputDecoration(labelText: 'Full Name'),
                // Validator rút gọn
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16), // Khoảng cách giữa các TextFormField
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
              ),
              SizedBox(height: 16),

              // [Radio Button - CÁCH MỚI]
              // Flutter bản cập nhật mới (>= 3.32) yêu cầu dùng RadioGroup thay vì groupValue lẻ tẻ.
              // RadioGroup sẽ quản lý việc chọn 1 trong nhiều options.
              Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioGroup<Gender>(
                // Thay đổi từ 'value' thành 'groupValue' cho đúng chuẩn
                groupValue: _gender, // Giá trị Radio đang chọn
                onChanged: (value) =>
                    setState(() => _gender = value), // Khi chọn Radio
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<Gender>(
                        // RadioListTile: Radio + Text
                        title: Text('Male'),
                        value: Gender.male,
                        contentPadding: EdgeInsets.zero, // Ẩn padding
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Gender>(
                        title: Text('Female'),
                        value: Gender.female,
                        contentPadding: EdgeInsets.zero, // Ẩn padding
                      ),
                    ),
                  ],
                ),
              ),

              // CheckboxListTile: Tiện lợi hơn Checkbox + Text vì bấm được cả text
              CheckboxListTile(
                // CheckboxListTile: Checkbox + Text
                title: Text('I agree to Terms & Conditions'),
                value: _agreedToTerms, // Giá trị Checkbox đang chọn
                onChanged: (v) => setState(
                  () => _agreedToTerms = v ?? false,
                ), // Khi chọn Checkbox
                controlAffinity:
                    ListTileControlAffinity.leading, // Checkbox nằm bên trái
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity, // Nút full width
                child: ElevatedButton(
                  onPressed: () {
                    // Logic validate Custom
                    if (_formKey.currentState!.validate()) {
                      // Validate Checkbox riêng (vì nó không nằm trong TextFormField)
                      if (!_agreedToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please agree to terms')),
                        );
                        return;
                      }
                      // Submit thành công
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Processing...')));
                    }
                  },
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                  child: Text('REGISTER'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
