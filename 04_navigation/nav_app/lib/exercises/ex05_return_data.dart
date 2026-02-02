/// ===========================================
/// EXERCISE 05: RETURN DATA (TRẢ DỮ LIỆU VỀ)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Nhận dữ liệu trả về từ màn hình B -> A
/// - Hiểu cơ chế Future/async/await trong Navigator
///
/// 📝 Giải thích:
/// - Navigator.push trả về một [Future].
/// - Navigator.pop(context, result) trả về [result].
/// - Dùng [await] để đợi người dùng đóng màn hình B và lấy result.

library;

import 'package:flutter/material.dart';

class Ex05ReturnData extends StatefulWidget {
  const Ex05ReturnData({super.key});

  @override
  State<Ex05ReturnData> createState() => _Ex05ReturnDataState();
}

class _Ex05ReturnDataState extends State<Ex05ReturnData> {
  String _selection = 'Chưa chọn gì';

  /// [Hàm điều hướng]
  /// Phải là async vì cần đợi kết quả
  void _navigateAndGetSelection() async {
    // 1. Chờ (await) cho đến khi SelectionScreen đóng lại
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
    );

    // 2. Xử lý kết quả trả về
    if (!mounted) return; // Kiểm tra xem widget còn tồn tại không

    if (result != null) {
      setState(() {
        _selection = result as String; // Ép kiểu kết quả
      });

      // Hiện thông báo
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bạn đã chọn: $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex05: Return Data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Lựa chọn của bạn:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              _selection,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _navigateAndGetSelection(),
              child: const Text('Chọn Option 👉'),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn một Option')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(context, 'Option A (Táo) 🍎'),
            const SizedBox(height: 16),
            _buildOptionButton(context, 'Option B (Chuối) 🍌'),
            const SizedBox(height: 16),
            _buildOptionButton(context, 'Option C (Cam) 🍊'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String value) {
    return ElevatedButton(
      onPressed: () {
        /// [Navigator.pop với result]
        /// Tham số thứ 2 là kết quả trả về cho màn hình trước
        Navigator.pop(context, value);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Text(value, style: const TextStyle(fontSize: 18)),
    );
  }
}
