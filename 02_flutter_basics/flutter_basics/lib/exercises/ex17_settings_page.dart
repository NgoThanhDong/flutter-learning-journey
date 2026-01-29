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

import 'package:flutter/material.dart';

/*
class Ex17SettingsPage extends StatefulWidget {
  const Ex17SettingsPage({super.key});

  @override
  State<Ex17SettingsPage> createState() => _Ex17SettingsPageState();
}

class _Ex17SettingsPageState extends State<Ex17SettingsPage> {
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'English';
  final List<String> _languages = ['English', 'Vietnamese', 'French', 'Japanese'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Section 1: General
          _buildSectionHeader('General'),
          
          SwitchListTile(
            secondary: Icon(Icons.notifications),
            title: Text('Notifications'),
            value: _notifications,
            onChanged: (val) => setState(() => _notifications = val),
          ),
          
          SwitchListTile(
            secondary: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              underline: SizedBox(), // Bỏ gạch chân
              items: _languages.map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              )).toList(),
              onChanged: (val) => setState(() => _language = val!),
            ),
          ),
          
          Divider(),
          
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
            onTap: _showLogoutDialog,
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
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
*/
