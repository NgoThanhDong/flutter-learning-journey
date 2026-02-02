/// ===========================================
/// EXERCISE 03: -TODO LIST VỚI LIFTING STATE UP
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Áp dụng pattern "Lifting State Up"
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
  final String id;
  final String title;
  bool isCompleted;

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
  final List<Todo> _todos = [];

  /// [Callback] Để TodoInput gọi khi thêm todo mới
  void _addTodo(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      _todos.add(
        Todo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.trim(),
        ),
      );
    });
  }

  /// [Callback] Để TodoList gọi khi toggle complete
  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((t) => t.id == id);
      todo.isCompleted = !todo.isCompleted;
    });
  }

  /// [Callback] Để TodoList gọi khi xóa todo
  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((t) => t.id == id);
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
          _TodoInput(onAdd: _addTodo),

          const Divider(),

          // Widget con 2: List
          // Truyền data VÀ callbacks
          Expanded(
            child: _TodoList(
              todos: _todos,
              onToggle: _toggleTodo,
              onDelete: _deleteTodo,
            ),
          ),

          // Footer hiển thị tổng số
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng: ${_todos.length} tasks'),
                Text(
                  'Hoàn thành: ${_todos.where((t) => t.isCompleted).length}',
                  style: const TextStyle(color: Colors.green),
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

  void _submit() {
    final text = _controller.text;
    if (text.isNotEmpty) {
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
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Thêm task mới...',
                border: OutlineInputBorder(
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
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
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
/// WIDGET CON 2: -TODO LIST
/// ===========================================
/// [Props]
/// - todos: Data từ parent (read-only)
/// - onToggle: Callback khi toggle complete
/// - onDelete: Callback khi xóa
///
/// Widget này KHÔNG sở hữu data, chỉ hiển thị và gọi callbacks.
class _TodoList extends StatelessWidget {
  final List<Todo> todos;
  final void Function(String) onToggle;
  final void Function(String) onDelete;

  const _TodoList({
    required this.todos,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => onToggle(todo.id),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todo.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(todo.id),
          ),
        );
      },
    );
  }
}
