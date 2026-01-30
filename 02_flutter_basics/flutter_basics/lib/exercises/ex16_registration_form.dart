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

// -TODO: Uncomment và hoàn thiện

class Ex16RegistrationForm extends StatefulWidget {
  const Ex16RegistrationForm({super.key});

  @override
  State<Ex16RegistrationForm> createState() => _Ex16RegistrationFormState();
}

enum Gender { male, female, other }

class _Ex16RegistrationFormState extends State<Ex16RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  Gender? _gender = Gender.male;
  bool _agreedToTerms = false;

  // Controllers (nếu cần lấy giá trị)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
              ),
              SizedBox(height: 16),

              // Gender Radio
              Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioGroup<Gender>(
                groupValue: _gender,
                onChanged: (value) => setState(() => _gender = value),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<Gender>(
                        title: Text('Male'),
                        value: Gender.male,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Gender>(
                        title: Text('Female'),
                        value: Gender.female,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),

              // Terms Checkbox
              CheckboxListTile(
                title: Text('I agree to Terms & Conditions'),
                value: _agreedToTerms,
                onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_agreedToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please agree to terms')),
                        );
                        return;
                      }
                      // Submit
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
