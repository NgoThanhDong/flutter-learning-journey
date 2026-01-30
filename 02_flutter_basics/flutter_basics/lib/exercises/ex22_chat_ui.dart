/// ===========================================
/// EXERCISE 22: CHAT UI
/// ===========================================
///
/// Mục tiêu: Màn hình chat chi tiết
///
/// Yêu cầu:
/// - Message List (ListView reverse)
/// - Input area: TextField + Send Button
/// - Bong bóng chat (Chat Bubble) khác màu cho Sender/Receiver

library;

import 'package:flutter/material.dart';

class Ex22ChatUI extends StatefulWidget {
  const Ex22ChatUI({super.key});

  @override
  State<Ex22ChatUI> createState() => _Ex22ChatUIState();
}

class _Ex22ChatUIState extends State<Ex22ChatUI> {
  final _controller = TextEditingController();
  // Fake data tin nhắn
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hi, how are you?', 'isMe': false},
    {'text': 'I am good, thanks! And you?', 'isMe': true},
    {'text': 'Doing great. Working on Flutter?', 'isMe': false},
    {'text': 'Yes! Learning Layouts now.', 'isMe': true},
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      // insert(0, ...): Thêm tin mới vào ĐẦU list
      // Tại sao? Vì ListView đang dùng reverse: true -> Đầu list là Dưới cùng màn hình.
      _messages.insert(0, {'text': _controller.text, 'isMe': true});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(child: Text('A')),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alice', style: TextStyle(fontSize: 16)),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Expanded: Chiếm phần lớn màn hình cho danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              reverse:
                  true, // [Quan trọng] Đảo ngược list: Item 0 nằm dưới cùng. Khi có tin nhắn mới, nó sẽ hiện ngay ngón tay người dùng.
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;
                // Align: Căn trái nếu là người khác, căn phải nếu là tôi
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blue
                          : Colors.grey[300], // Màu nền khác nhau
                      // Bo góc bất đối xứng (tạo hiệu ứng bong bóng chat)
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomRight: isMe ? Radius.zero : null,
                        bottomLeft: isMe ? null : Radius.zero,
                      ),
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Khu vực nhập tin nhắn
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.attach_file), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
