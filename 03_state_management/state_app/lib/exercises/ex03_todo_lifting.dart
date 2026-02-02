/// ===========================================
/// EXERCISE 03: -TODO LIST VỚI LIFTING STATE UP
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Áp dụng pattern "Lifting State Up" (Nâng cấp trạng thái)
/// - Tách UI thành nhiều widget nhưng dùng chung state
///
/// 📝 Yêu cầu:
/// - TodoInput widget để thêm task
/// - TodoList widget để hiển thị tasks
/// - Parent widget giữ state và truyền xuống con

library;

import 'package:flutter/material.dart';

/// [Model] Đại diện cho 1 Todo item
class Todo {
  final String id; // ID duy nhất của todo
  final String title; // Tiêu đề task
  bool isCompleted; // Trạng thái hoàn thành

  Todo({required this.id, required this.title, this.isCompleted = false});
}

/// ===========================================
/// PARENT WIDGET - GIỮ STATE
/// ===========================================
/// [Pattern: Lifting State Up]
/// - State được đặt ở widget cha chung
/// - Widget con nhận data và callback qua props
/// - Khi cần thay đổi state, widget con gọi callback
class Ex03TodoLifting extends StatefulWidget {
  const Ex03TodoLifting({super.key});

  @override
  State<Ex03TodoLifting> createState() => _Ex03TodoLiftingState();
}

class _Ex03TodoLiftingState extends State<Ex03TodoLifting> {
  /// [State] List todos được giữ ở đây
  /// Tại sao không để trong TodoList?
  /// → Vì TodoInput cũng cần thêm vào list này
  final List<Todo> _todos = []; // Danh sách todos

  /// [Callback] Để TodoInput gọi khi thêm todo mới
  void _addTodo(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      _todos.add(
        // Thêm todo mới vào danh sách
        Todo(
          id: DateTime.now().millisecondsSinceEpoch
              .toString(), // ID tạo bằng thời gian hiện tại
          title: title.trim(), // Tiêu đề task
        ),
      );
    });
  }

  /// [Callback] Để TodoList gọi khi toggle complete
  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((t) => t.id == id); // Tìm todo bằng ID
      todo.isCompleted = !todo.isCompleted; // Đảo ngược trạng thái hoàn thành
    });
  }

  /// [Callback] Để TodoList gọi khi xóa todo
  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((t) => t.id == id); // Xóa todo bằng ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex03: Lifting State Up'),
        backgroundColor: Colors.teal.shade100,
      ),
      body: Column(
        children: [
          // Widget con 1: Input
          // Truyền callback để thêm todo
          _TodoInput(
            onAdd: _addTodo,
          ), // Truyền callback _addTodo vào _TodoInput

          const Divider(), // Đường kẻ ngang
          // Widget con 2: List
          // Truyền data VÀ callbacks
          Expanded(
            child: _TodoList(
              todos: _todos, // Truyền danh sách todos
              onToggle: _toggleTodo, // Truyền callback _toggleTodo
              onDelete: _deleteTodo, // Truyền callback _deleteTodo
            ),
          ),

          // Footer hiển thị tổng số
          Container(
            padding: const EdgeInsets.all(16), // Padding 16
            color: Colors.grey[100], // Màu nền xám nhạt
            child: Row(
              // Căn đều hai bên, ko chừa khoảng trống 2 bên
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng: ${_todos.length} tasks'), // Tổng số tasks
                Text(
                  'Hoàn thành: ${_todos.where((t) => t.isCompleted).length}', // Số tasks đã hoàn thành
                  style: const TextStyle(
                    color: Colors.green,
                  ), // Text màu xanh lá
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// WIDGET CON 1: -TODO INPUT
/// ===========================================
/// [Stateless với callback]
/// Widget này chỉ lo việc nhập liệu.
/// Không biết gì về list todos, chỉ gọi onAdd khi user submit.
class _TodoInput extends StatefulWidget {
  /// [Callback prop] Parent truyền xuống
  final void Function(String) onAdd;

  const _TodoInput({required this.onAdd});

  @override
  State<_TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<_TodoInput> {
  // Controller cần thiết để lấy text và clear sau khi add
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Quan trọng: dispose controller
    super.dispose();
  }

  // Hàm xử lý khi submit
  void _submit() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      // Kiểm tra text có rỗng không
      widget.onAdd(text); // Gọi callback từ parent
      _controller.clear(); // Clear input sau khi add
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // Ô nhập liệu
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Thêm task mới...',
                border: OutlineInputBorder(
                  // Viền bo góc
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              // Submit khi nhấn Enter
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _submit, // Gọi hàm _submit khi nhấn nút
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.teal,
            ),
            child: const Icon(Icons.add, color: Colors.white), // Icon nút bấm
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// WIDGET CON 2: -TODO LIST
/// ===========================================
/// [Props]
/// - todos: Data từ parent (read-only)
/// - onToggle: Callback khi toggle complete
/// - onDelete: Callback khi xóa
///
/// Widget này KHÔNG sở hữu data, chỉ hiển thị và gọi callbacks.
class _TodoList extends StatelessWidget {
  final List<Todo> todos; // Danh sách todos
  final void Function(String) onToggle; // Callback khi toggle complete
  final void Function(String) onDelete; // Callback khi xóa

  const _TodoList({
    required this.todos,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      // Kiểm tra danh sách todos có rỗng không
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey), // Icon rỗng
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

    // Hiển thị danh sách todos
    return ListView.builder(
      itemCount: todos.length, // Số lượng item
      itemBuilder: (context, index) {
        // Hàm build từng item
        final todo = todos[index]; // Lấy todo tại index
        return ListTile(
          // Widget hiển thị từng item
          leading: Checkbox(
            // Checkbox để đánh dấu hoàn thành
            value: todo.isCompleted, // Giá trị checkbox
            onChanged: (_) => onToggle(todo.id), // Callback khi toggle
          ),
          title: Text(
            todo.title, // Tiêu đề task
            style: TextStyle(
              // Nếu đã hoàn thành thì gạch ngang
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              // Nếu đã hoàn thành thì màu xám
              color: todo.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red), // Icon xóa
            onPressed: () => onDelete(todo.id), // Callback khi xóa
          ),
        );
      },
    );
  }
}
