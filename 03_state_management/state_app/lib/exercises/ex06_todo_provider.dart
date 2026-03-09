/// ===========================================
/// EXERCISE 06: -TODO VỚI PROVIDER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Áp dụng Provider cho CRUD operations
/// - Quản lý List state với ChangeNotifier
/// - Hiểu immutable updates pattern (tạo object mới thay vì modify)
///
/// 📝 Yêu cầu:
/// - TodoNotifier với `List<Todo>`
/// - Add, remove, toggle complete
/// - Input field + ListView hiển thị

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// MODEL
/// ===========================================
class Todo {
  final String id; // ID duy nhất của todo
  final String title; // Tiêu đề của todo
  final bool isCompleted; // Trạng thái hoàn thành

  const Todo({required this.id, required this.title, this.isCompleted = false});

  /// [copyWith] Pattern cho immutable object
  /// Tạo bản sao với 1 số field thay đổi
  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// ===========================================
/// -TODO NOTIFIER
/// ===========================================
// ChangeNotifier là class của Provider quản lý state
class TodoNotifier extends ChangeNotifier {
  /// [List state]
  /// Lưu ý: Nên dùng final để tránh reassign (gán lại biến) trực tiếp
  final List<Todo> _todos = [];

  /// [Getter] Trả về bản copy để tránh modification (thay đổi) từ bên ngoài
  // List.unmodifiable() trả về một unmodifiable list (không thể thay đổi)
  List<Todo> get todos => List.unmodifiable(_todos);

  /// [Getter] Số lượng todos chưa hoàn thành
  int get pendingCount => _todos.where((t) => !t.isCompleted).length;

  /// [Getter] Số lượng todos đã hoàn thành
  int get completedCount => _todos.where((t) => t.isCompleted).length;

  /// [Method] Thêm todo mới
  void addTodo(String title) {
    // trim() loại bỏ khoảng trắng ở đầu và cuối chuỗi
    if (title.trim().isEmpty) return;

    // Thêm todo mới vào danh sách
    _todos.add(
      Todo(
        // millisecondsSinceEpoch trả về số milliseconds kể từ ngày 1/1/1970
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
      ),
    );
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
  }

  /// [Method] Toggle hoàn thành
  /// Dùng immutable update: tạo object mới thay vì modify
  void toggleTodo(String id) {
    // Tìm index của todo cần toggle
    final index = _todos.indexWhere((t) => t.id == id);

    // Nếu tìm thấy todo
    if (index != -1) {
      final todo = _todos[index]; // Lấy todo cần toggle
      // Tạo Todo mới với isCompleted đảo ngược
      _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      notifyListeners(); // Thông báo cho widget biết state đã thay đổi
    }
  }

  /// [Method] Xóa todo
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id); // Xóa todo khỏi danh sách
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
  }

  /// [Method] Xóa tất cả đã hoàn thành
  void clearCompleted() {
    _todos.removeWhere((t) => t.isCompleted); // Xóa tất cả todos đã hoàn thành
    notifyListeners(); // Thông báo cho widget biết state đã thay đổi
  }
}

/// ===========================================
/// APP VỚI PROVIDER
/// ===========================================
class Ex06TodoProvider extends StatelessWidget {
  const Ex06TodoProvider({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider bao bọc widget con và cung cấp TodoNotifier
    // create: function tạo instance của TodoNotifier
    // child: widget con
    return ChangeNotifierProvider(
      create: (_) => TodoNotifier(),
      child: const _TodoScreen(),
    );
  }
}

/// ===========================================
/// -TODO SCREEN
/// ===========================================
class _TodoScreen extends StatelessWidget {
  const _TodoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex06: Todo Provider'),
        backgroundColor: Colors.teal.shade100,
        actions: [
          // Nút xóa todos đã hoàn thành
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Xóa todos đã hoàn thành',
            onPressed: () {
              // ✅ Dùng read vì trong callback
              context.read<TodoNotifier>().clearCompleted();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Input section
          const _TodoInput(),

          // Stats bar
          const _StatsBar(),

          // Divider line ngăn cách giữa stats bar và todo list
          const Divider(height: 1),

          // Todo list
          const Expanded(child: _TodoList()),
        ],
      ),
    );
  }
}

/// ===========================================
/// -TODO INPUT
/// ===========================================
// Widget nhập liệu todo dùng StatefulWidget vì có local state (_controller)
class _TodoInput extends StatefulWidget {
  const _TodoInput();

  @override
  State<_TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<_TodoInput> {
  // Local state: controller cho TextField
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng controller khi widget bị xóa
    super.dispose();
  }

  // Method xử lý submit
  void _submit() {
    final text = _controller.text; // Lấy text từ controller
    if (text.isNotEmpty) {
      // ✅ Dùng read vì trong callback
      context.read<TodoNotifier>().addTodo(text);
      _controller.clear(); // Xóa text sau khi submit
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // TextField chiếm hết không gian còn lại
          Expanded(
            child: TextField(
              controller: _controller, // Controller để quản lý text
              // InputDecoration để tùy chỉnh giao diện TextField
              decoration: InputDecoration(
                hintText: 'Thêm task mới...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // Icon hiển thị trước TextField
                prefixIcon: const Icon(Icons.add_task),
              ),
              onSubmitted: (_) => _submit(), // Xử lý submit khi nhấn Enter
            ),
          ),
          const SizedBox(width: 12),

          // Nút thêm todo
          ElevatedButton(
            onPressed: _submit, // Xử lý submit khi nhấn nút
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              backgroundColor: Colors.teal,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// STATS BAR
/// ===========================================
// Hiển thị số lượng todo
class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    // ✅ Dùng watch vì cần hiển thị và rebuild khi thay đổi
    final todoNotifier = context.watch<TodoNotifier>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade100,
      child: Row(
        // Căn đều các item trong row khoảng cách đều nhau
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Hiển thị số lượng todo
          _StatItem(
            label: 'Tổng',
            value: todoNotifier.todos.length,
            color: Colors.blue,
          ),

          // Hiển thị số lượng todo chờ làm
          _StatItem(
            label: 'Chờ làm',
            value: todoNotifier.pendingCount,
            color: Colors.orange,
          ),

          // Hiển thị số lượng todo đã hoàn thành
          _StatItem(
            label: 'Hoàn thành',
            value: todoNotifier.completedCount,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

// _StatItem là widget con của _StatsBar để hiển thị số lượng todo
class _StatItem extends StatelessWidget {
  final String label; // Nhãn
  final int value; // Giá trị
  final Color color; // Màu sắc

  // Constructor
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hiển thị số lượng todo
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        // Hiển thị nhãn
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}

/// ===========================================
/// -TODO LIST
/// ===========================================
// _TodoList là widget con của _TodoScreen để hiển thị danh sách todo
class _TodoList extends StatelessWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context) {
    // ✅ Dùng watch vì cần hiển thị và rebuild khi thay đổi
    final todos = context.watch<TodoNotifier>().todos;

    // Nếu không có todo thì hiển thị thông báo
    if (todos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chưa có task nào.\nThêm task mới ở trên!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Nếu có todo thì hiển thị danh sách todo
    // ListView.separated để hiển thị danh sách todo có phân cách
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: todos.length, // Số lượng todo
      // Phân cách giữa các todo
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      // Xây dựng từng todo
      itemBuilder: (context, index) {
        final todo = todos[index]; // Lấy todo tại index
        return _TodoItem(todo: todo); // Trả về _TodoItem
      },
    );
  }
}

/// ===========================================
/// -TODO ITEM
/// ===========================================
// _TodoItem là widget con của _TodoList để hiển thị từng todo
class _TodoItem extends StatelessWidget {
  final Todo todo; // Todo cần hiển thị

  // Constructor
  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    // Dismissible để cho phép vuốt để xóa
    return Dismissible(
      key: Key(todo.id), // Key duy nhất cho mỗi todo
      // Cho phép vuốt từ phải sang trái
      direction: DismissDirection.endToStart,
      // Background khi vuốt
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight, // Căn phải
        padding: const EdgeInsets.only(right: 16), // Padding bên phải
        child: const Icon(Icons.delete, color: Colors.white), // Icon xóa
      ),
      // Xử lý khi vuốt
      onDismissed: (_) {
        // Xóa todo dùng context.read vì trong onDismissed không cần rebuild
        context.read<TodoNotifier>().deleteTodo(todo.id);
      },
      // Nội dung của todo
      child: ListTile(
        // Checkbox để đánh dấu hoàn thành
        leading: Checkbox(
          value: todo.isCompleted, // Giá trị của checkbox
          onChanged: (_) {
            // Toggle todo dùng context.read vì trong onChanged không cần rebuild
            context.read<TodoNotifier>().toggleTodo(todo.id);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        // Tiêu đề của todo
        title: Text(
          todo.title,
          // Nếu todo đã hoàn thành thì gạch ngang tiêu đề và đổi màu chữ
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : Colors.black,
          ),
        ),

        // Icon xóa ở cuối ListTile
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            // Xóa todo dùng context.read vì trong onPressed không cần rebuild
            context.read<TodoNotifier>().deleteTodo(todo.id);
          },
        ),
      ),
    );
  }
}
