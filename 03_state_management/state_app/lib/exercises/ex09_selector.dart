/// ===========================================
/// EXERCISE 09: SELECTOR - TỐI ƯU REBUILD
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Hiểu vấn đề rebuild không cần thiết
/// - Sử dụng Selector để chỉ lắng nghe 1 phần state
/// - Verify bằng debug print
///
/// 📝 Yêu cầu:
/// - UserNotifier với name, age, email
/// - 3 widgets riêng hiển thị từng field
/// - Dùng Selector để chỉ rebuild widget cần thiết

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// USER NOTIFIER
/// ===========================================
/// UserNotifier là một ChangeNotifier quản lý thông tin người dùng
class UserNotifier extends ChangeNotifier {
  String _name = 'John Doe';
  int _age = 25;
  String _email = 'john@example.com';

  String get name => _name;
  int get age => _age;
  String get email => _email;

  // Hàm cập nhật name
  void updateName(String name) {
    _name = name;
    debugPrint('🔔 UserNotifier: name updated to $name');
    notifyListeners(); // Thông báo cho các widget lắng nghe biết state đã thay đổi
  }

  // Hàm cập nhật age
  void updateAge(int age) {
    _age = age;
    debugPrint('🔔 UserNotifier: age updated to $age');
    notifyListeners();
  }

  // Hàm cập nhật email
  void updateEmail(String email) {
    _email = email;
    debugPrint('🔔 UserNotifier: email updated to $email');
    notifyListeners();
  }
}

/// ===========================================
/// APP VỚI PROVIDER
/// ===========================================
/// Ex09Selector là một StatelessWidget tạo ra một ChangeNotifierProvider
class Ex09Selector extends StatelessWidget {
  const Ex09Selector({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider dùng để cung cấp UserNotifier cho các widget con
    // create: (_) => UserNotifier() là một callback function tạo ra một UserNotifier
    // child: const _SelectorScreen() là widget con
    return ChangeNotifierProvider(
      create: (_) => UserNotifier(),
      child: const _SelectorScreen(),
    );
  }
}

/// ===========================================
/// MAIN SCREEN
/// ===========================================
/// _SelectorScreen là một StatelessWidget hiển thị thông tin người dùng
class _SelectorScreen extends StatelessWidget {
  const _SelectorScreen();

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 _SelectorScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex09: Selector'),
        backgroundColor: Colors.orange.shade100,
      ),

      // body là một SingleChildScrollView chứa các widget con
      // SingleChildScrollView là một widget cho phép cuộn nội dung khi nội dung vượt quá kích thước màn hình
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch là để các widget con stretch theo chiều ngang
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 Mở Console để xem debug logs'),
                  SizedBox(height: 4),
                  Text(
                    'Khi thay đổi Name, chỉ NameWidget rebuild.\n'
                    'Các widgets khác KHÔNG rebuild!',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Display widgets
            const Text(
              'Display Widgets (dùng Selector):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// Chỉ rebuild khi name thay đổi
            const _NameWidget(), // Widget hiển thị name
            const SizedBox(height: 8),
            const _AgeWidget(), // Widget hiển thị age
            const SizedBox(height: 8),
            const _EmailWidget(), // Widget hiển thị email

            const SizedBox(height: 24),

            // Control widgets
            const Text(
              'Control Widgets:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Name input
            const _NameInput(), // Widget nhập liệu name
            const SizedBox(height: 12),

            // Age slider
            const _AgeSlider(), // Widget slider để cập nhật age
            const SizedBox(height: 12),

            // Email input
            const _EmailInput(), // Widget input để cập nhật email

            const SizedBox(height: 24),

            // Comparison
            const _ComparisonSection(), // Widget so sánh watch vs select
          ],
        ),
      ),
    );
  }
}

/// ===========================================
/// DISPLAY WIDGETS VỚI SELECTOR
/// ===========================================

/// [Widget hiển thị Name] - Chỉ rebuild khi name thay đổi
class _NameWidget extends StatelessWidget {
  const _NameWidget();

  @override
  Widget build(BuildContext context) {
    debugPrint('🟢 _NameWidget build');

    /// [context.select] Chỉ lắng nghe field cụ thể
    /// Khi age hoặc email thay đổi, widget này KHÔNG rebuild
    final name = context.select<UserNotifier, String>((user) => user.name);

    return Card(
      color: Colors.green.shade50,
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Name'),
        subtitle: Text(name),
        trailing: const Text('🟢', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

/// [Widget hiển thị Age] - Chỉ rebuild khi age thay đổi
class _AgeWidget extends StatelessWidget {
  const _AgeWidget();

  @override
  Widget build(BuildContext context) {
    debugPrint('🔵 _AgeWidget build');

    // context.select<UserNotifier, int>((user) => user.age) là một callback function
    // Nó sẽ lắng nghe sự thay đổi của field age trong UserNotifier
    // Khi age thay đổi, widget này sẽ rebuild
    final age = context.select<UserNotifier, int>((user) => user.age);

    return Card(
      color: Colors.blue.shade50,
      child: ListTile(
        leading: const Icon(Icons.cake),
        title: const Text('Age'),
        subtitle: Text('$age years old'),
        trailing: const Text('🔵', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

/// [Widget hiển thị Email] - Chỉ rebuild khi email thay đổi
class _EmailWidget extends StatelessWidget {
  const _EmailWidget();

  @override
  Widget build(BuildContext context) {
    debugPrint('🟣 _EmailWidget build');

    // context.select<UserNotifier, String>((user) => user.email) là một callback function
    // Nó sẽ lắng nghe sự thay đổi của field email trong UserNotifier
    // Khi email thay đổi, widget này sẽ rebuild
    final email = context.select<UserNotifier, String>((user) => user.email);

    return Card(
      color: Colors.purple.shade50,
      child: ListTile(
        leading: const Icon(Icons.email),
        title: const Text('Email'),
        subtitle: Text(email),
        trailing: const Text('🟣', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

/// ===========================================
/// INPUT WIDGETS
/// ===========================================
/// Widget nhập liệu name
class _NameInput extends StatefulWidget {
  const _NameInput();

  @override
  State<_NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  // Controller để quản lý text input
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose(); // Giải phóng bộ nhớ khi widget bị xóa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Update Name',
        border: const OutlineInputBorder(), // Viền cho text field
        // Icon check để cập nhật name
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          // Khi nhấn nút check, cập nhật name và clear text field
          onPressed: () {
            // Kiểm tra nếu text field không rỗng
            if (controller.text.isNotEmpty) {
              // Gọi method updateName từ UserNotifier
              context.read<UserNotifier>().updateName(controller.text);
              // Xóa text field sau khi cập nhật
              controller.clear();
            }
          },
        ),
      ),
    );
  }
}

/// Widget slider để cập nhật age
class _AgeSlider extends StatelessWidget {
  const _AgeSlider();

  @override
  Widget build(BuildContext context) {
    // Lấy giá trị age từ UserNotifier
    // context.select<UserNotifier, int>((u) => u.age) là một callback function
    // Nó sẽ lắng nghe sự thay đổi của field age trong UserNotifier
    // Khi age thay đổi, widget này sẽ rebuild
    final age = context.select<UserNotifier, int>((u) => u.age);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Update Age: $age'),
        // Slider là widget UI cho phép chọn giá trị trong một khoảng nhất định
        // value: giá trị hiện tại của slider
        // min: giá trị nhỏ nhất của slider
        // max: giá trị lớn nhất của slider
        // divisions: số khoảng chia
        // onChanged: callback function khi giá trị thay đổi
        Slider(
          value: age.toDouble(),
          min: 1,
          max: 100,
          divisions: 99,
          onChanged: (value) {
            // Khi giá trị thay đổi, gọi method updateAge từ UserNotifier
            context.read<UserNotifier>().updateAge(value.toInt());
          },
        ),
      ],
    );
  }
}

/// Widget input để cập nhật email
class _EmailInput extends StatefulWidget {
  const _EmailInput();

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  // Controller để quản lý text input
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose(); // Giải phóng bộ nhớ khi widget bị xóa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Update Email',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          // Khi nhấn nút check, cập nhật email và clear text field
          onPressed: () {
            // Kiểm tra nếu text field không rỗng
            if (controller.text.isNotEmpty) {
              // Gọi method updateEmail từ UserNotifier
              context.read<UserNotifier>().updateEmail(controller.text);
              // Xóa text field sau khi cập nhật
              controller.clear();
            }
          },
        ),
      ),
    );
  }
}

/// ===========================================
/// COMPARISON SECTION
/// ===========================================
/// Widget so sánh watch vs select
class _ComparisonSection extends StatelessWidget {
  const _ComparisonSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 So sánh watch vs select:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            '❌ context.watch<UserNotifier>()\n'
            '   → Rebuild khi BẤT KỲ field nào thay đổi\n\n'
            '✅ context.select<UserNotifier, String>((u) => u.name)\n'
            '   → Chỉ rebuild khi NAME thay đổi',
          ),
          SizedBox(height: 12),
          Text(
            '💡 Tip: Dùng select khi:\n'
            '• Widget chỉ cần 1-2 fields của state\n'
            '• State object lớn với nhiều fields\n'
            '• Muốn tối ưu performance',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
