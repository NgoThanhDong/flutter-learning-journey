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

library; // library là widget dùng để tạo thư viện

import 'package:flutter/material.dart';

// Ex22ChatUI - Màn hình chat chi tiết
// Ex22ChatUI là StatefulWidget vì nó có state là danh sách tin nhắn
class Ex22ChatUI extends StatefulWidget {
  // super.key là tham số tùy chọn để truyền key cho StatefulWidget
  const Ex22ChatUI({super.key});

  // createState() là phương thức trả về State của StatefulWidget
  @override
  State<Ex22ChatUI> createState() => _Ex22ChatUIState();
}

// _Ex22ChatUIState là State của Ex22ChatUI
class _Ex22ChatUIState extends State<Ex22ChatUI> {
  // TextEditingController là widget dùng để điều khiển ô nhập văn bản
  final _controller = TextEditingController();

  // Fake data tin nhắn
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hi, how are you?', 'isMe': false},
    {'text': 'I am good, thanks! And you?', 'isMe': true},
    {'text': 'Doing great. Working on Flutter?', 'isMe': false},
    {'text': 'Yes! Learning Layouts now.', 'isMe': true},
  ];

  // Hàm gửi tin nhắn
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) {
      return; // Nếu ô nhập rỗng thì không gửi
    }
    setState(() {
      // insert(0, ...): Thêm tin mới vào ĐẦU list
      // Tại sao? Vì ListView đang dùng reverse: true -> Đầu list là Dưới cùng màn hình.
      _messages.insert(0, {'text': _controller.text, 'isMe': true});
    });
    _controller.clear(); // Xóa ô nhập sau khi gửi
  }

  // build() là phương thức trả về widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold là widget dùng để tạo cấu trúc cơ bản của màn hình
      appBar: AppBar(
        // AppBar là widget dùng để tạo thanh tiêu đề
        title: Row(
          // Row là widget dùng để sắp xếp các widget theo chiều ngang
          children: [
            CircleAvatar(
              child: Text('A'),
            ), // CircleAvatar là widget dùng để tạo ảnh đại diện tròn
            SizedBox(width: 10), // SizedBox là widget dùng để tạo khoảng cách
            // Column là widget dùng để sắp xếp các widget theo chiều dọc
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start là để căn các widget theo chiều ngang
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alice',
                  style: TextStyle(fontSize: 16),
                ), // Text là widget dùng để hiển thị văn bản
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        // actions: là widget dùng để tạo các widget ở bên phải của AppBar
        actions: [
          IconButton(
            // IconButton là widget dùng để tạo nút bấm có icon
            icon: Icon(Icons.call), // Icon là widget dùng để tạo icon
            onPressed: () {
              // onPressed: là hàm được gọi khi nút bấm được nhấn
              debugPrint('Call');
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              debugPrint('Video Call');
            },
          ),
        ],
      ),

      // body: là widget dùng để tạo nội dung chính của màn hình
      body: Column(
        children: [
          // Expanded: Chiếm phần lớn màn hình cho danh sách tin nhắn
          Expanded(
            // ListView.builder là widget dùng để tạo danh sách các widget
            child: ListView.builder(
              // padding: là khoảng cách lề
              padding: EdgeInsets.all(16),
              // [Quan trọng] Đảo ngược list: Item 0 nằm dưới cùng. Khi có tin nhắn mới, nó sẽ hiện ngay ngón tay người dùng.
              reverse: true,
              // itemCount: là số lượng item trong list
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // itemBuilder: là hàm được gọi để tạo item
                final msg = _messages[index]; // msg: là item hiện tại
                // isMe: là true nếu là người gửi, false nếu là người nhận
                final isMe = msg['isMe'] as bool;

                // Align: Căn trái nếu là người khác, căn phải nếu là tôi
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    // Container: là widget dùng để tạo khung chứa các widget
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      // BoxDecoration: là widget dùng để tạo khung chứa các widget
                      color: isMe
                          ? Colors.blue
                          : Colors.grey[300], // Màu nền khác nhau
                      // Bo góc bất đối xứng (tạo hiệu ứng bong bóng chat)
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomRight: isMe
                            ? Radius.zero
                            : null, // bottomRight: là góc dưới bên phải
                        bottomLeft: isMe
                            ? null
                            : Radius.zero, // bottomLeft: là góc dưới bên trái
                      ),
                    ),
                    child: Text(
                      // msg['text']: là nội dung tin nhắn
                      msg['text'] as String,
                      style: TextStyle(
                        color: isMe
                            ? Colors.white
                            : Colors.black, // Màu chữ khác nhau
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
              // BoxDecoration: là widget dùng để tạo khung chứa các widget
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ], // BoxShadow: là widget dùng để tạo bóng đổ
            ),
            child: Row(
              children: [
                IconButton(
                  // IconButton: là widget dùng để tạo nút bấm có icon
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    debugPrint('Attach file');
                  },
                ),

                // Expanded: Chiếm phần lớn màn hình cho ô nhập văn bản
                Expanded(
                  child: TextField(
                    // TextEditingController: là widget dùng để điều khiển nội dung của TextField
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        // OutlineInputBorder: là widget dùng để tạo khung viền cho TextField
                        borderRadius: BorderRadius.circular(24),
                        // BorderSide.none: là không có viền
                        borderSide: BorderSide.none,
                      ),
                      filled: true, // filled: là true nếu có màu nền
                      fillColor: Colors.grey[100], // fillColor: là màu nền
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // contentPadding: là khoảng cách bên trong
                    ),
                  ),
                ),

                SizedBox(width: 8),
                CircleAvatar(
                  // CircleAvatar: là widget dùng để tạo hình tròn
                  backgroundColor: Colors.blue, // backgroundColor: là màu nền
                  child: IconButton(
                    // IconButton: là widget dùng để tạo nút bấm có icon
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ), // Icon: là widget dùng để tạo icon
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
