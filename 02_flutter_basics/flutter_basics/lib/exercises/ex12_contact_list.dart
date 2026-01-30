/// ===========================================
/// EXERCISE 12: CONTACT LIST
/// ===========================================
///
/// Mục tiêu: Sử dụng ListView.separated
///
/// Yêu cầu:
/// - Tạo danh sách 20 contacts giả
/// - Mỗi row có: Avatar, Name, Phone
/// - Có divider giữa các rows
/// - Bấm vào row hiện snackbar hoặc dialog

library;

import 'package:flutter/material.dart';

// -TODO: Uncomment và hoàn thiện

class Ex12ContactList extends StatelessWidget {
  const Ex12ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake data
    final List<Map<String, String>> contacts = List.generate(
      20,
      (index) => {
        'name': 'Contact Person ${index + 1}',
        'phone': '0901 234 ${100 + index}',
        'id': '$index',
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (context, index) => Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(contact['name']![0]), // Chữ cái đầu
            ),
            title: Text(contact['name']!),
            subtitle: Text(contact['phone']!),
            trailing: Icon(Icons.call, color: Colors.green),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${contact['name']}...')),
              );
            },
          );
        },
      ),
    );
  }
}
