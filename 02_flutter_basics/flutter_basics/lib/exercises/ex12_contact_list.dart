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

// Ex12ContactList - Widget hiển thị danh sách contact
class Ex12ContactList extends StatelessWidget {
  const Ex12ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake data: Tạo list 20 phần tử giả lập
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
      // ListView.separated: Giống Builder nhưng có thêm separatorBuilder
      // Rất hữu ích khi muốn kẻ đường gạch ngang ngăn cách giữa các item
      body: ListView.separated(
        itemCount: contacts.length,
        // separatorBuilder: Widget phân cách (ở đây dùng Divider)
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 70, // indent: thụt đầu dòng 70px (tránh avatar)
        ),
        // itemBuilder: Hàm này được gọi lười (liên tục) khi user cuộn xuống
        itemBuilder: (context, index) {
          final contact = contacts[index]; // Lấy contact tại vị trí index
          // ListTile: Widget chuẩn của Material hỗ trợ: leading, title, subtitle, trailing
          return ListTile(
            // tileColor: Màu nền của item
            tileColor: index % 2 == 0 ? Colors.white : Colors.grey[200],
            // leading: Widget hiển thị ở đầu hàng (ở đây là avatar)
            leading: CircleAvatar(
              backgroundColor: index % 2 == 0
                  ? Colors.greenAccent
                  : Colors.redAccent,
              child: Text(contact['name']![0]), // Lấy chữ cái đầu tiên
            ),
            // title: Widget hiển thị ở giữa hàng (ở đây là tên)
            title: Text(
              contact['name']!,
              style: TextStyle(
                fontSize: 16,
                color: index % 2 == 0 ? Colors.black : Colors.redAccent,
              ),
            ),
            // subtitle: Widget hiển thị ở dưới title (ở đây là số điện thoại)
            subtitle: Text(
              contact['phone']!,
              style: TextStyle(
                fontSize: 12,
                color: index % 2 == 0 ? Colors.black : Colors.redAccent,
              ),
            ),
            // trailing: Widget hiển thị ở cuối hàng (ở đây là icon call)
            trailing: index % 2 == 0
                ? Icon(Icons.call, color: Colors.green)
                : Icon(Icons.call, color: Colors.red),
            // onTap: Hàm này được gọi khi user bấm vào item
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
