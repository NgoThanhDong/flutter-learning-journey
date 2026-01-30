/// ===========================================
/// EXERCISE 17: SETTINGS PAGE
/// ===========================================
///
/// Mục tiêu: Sử dụng Switch, Dropdown, Dialog
///
/// Yêu cầu:
/// - Switch: Notifications, Dark Mode
/// - Dropdown: Language
/// - Logout button -> Show confirmation dialog

library;

import 'package:flutter/material.dart';

class Ex17SettingsPage extends StatefulWidget {
  const Ex17SettingsPage({super.key});

  @override
  State<Ex17SettingsPage> createState() => _Ex17SettingsPageState();
}

class _Ex17SettingsPageState extends State<Ex17SettingsPage> {
  // State quản lý các cài đặt
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'English';
  final List<String> _languages = [
    'English',
    'Vietnamese',
    'French',
    'Japanese',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      // ListView: Tốt cho trang cài đặt dài
      body: ListView(
        children: [
          // Section 1: General
          _buildSectionHeader('General'),

          // SwitchListTile: Widget gồm Text + Switch
          SwitchListTile(
            secondary: Icon(Icons.notifications), // Icon bên trái
            title: Text('Notifications'),
            value: _notifications, // Giá trị true/false
            onChanged: (val) => setState(() => _notifications = val),
          ),

          SwitchListTile(
            secondary: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),

          // DropdownButton: Menu thả xuống
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _language, // Giá trị đang chọn
              underline:
                  SizedBox(), // Ẩn gạch chân mặc định của Dropdown cho đẹp
              // map: Chuyển list String -> list DropdownMenuItem
              items: _languages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
              // Khi chọn item mới
              onChanged: (val) => setState(() => _language = val!),
            ),
          ),

          Divider(), // Kẻ ngang phân cách
          // Section 2: Account
          _buildSectionHeader('Account'),

          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: _showLogoutDialog, // Gọi hàm hiện dialog
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Hàm hiển thị Dialog xác nhận
  void _showLogoutDialog() {
    showDialog(
      context: context,
      // Builder trả về Widget Dialog
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          // Nút Cancel
          TextButton(
            // Navigator.pop: Đóng dialog (quay lại màn hình trước)
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          // Nút Logout
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              // Thêm logic logout ở đây...
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
