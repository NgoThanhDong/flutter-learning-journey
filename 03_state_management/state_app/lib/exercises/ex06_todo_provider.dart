/// ===========================================
/// EXERCISE 06: -TODO VỚI PROVIDER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Áp dụng Provider cho CRUD operations
/// - Quản lý List state với ChangeNotifier
/// - Hiểu immutable updates pattern
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
  final String id;
  final String title;
  final bool isCompleted;

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
class TodoNotifier extends ChangeNotifier {
  /// [List state]
  /// Lưu ý: Nên dùng final để tránh reassign trực tiếp
  final List<Todo> _todos = [];

  /// [Getter] Trả về bản copy để tránh modification từ bên ngoài
  List<Todo> get todos => List.unmodifiable(_todos);

  /// [Getter] Số lượng todos chưa hoàn thành
  int get pendingCount => _todos.where((t) => !t.isCompleted).length;

  /// [Getter] Số lượng todos đã hoàn thành
  int get completedCount => _todos.where((t) => t.isCompleted).length;

  /// [Method] Thêm todo mới
  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    _todos.add(
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
      ),
    );
    notifyListeners();
  }

  /// [Method] Toggle hoàn thành
  /// Dùng immutable update: tạo object mới thay vì modify
  void toggleTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = _todos[index];
      // Tạo Todo mới với isCompleted đảo ngược
      _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      notifyListeners();
    }
  }

  /// [Method] Xóa todo
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// [Method] Xóa tất cả đã hoàn thành
  void clearCompleted() {
    _todos.removeWhere((t) => t.isCompleted);
    notifyListeners();
  }
}

/// ===========================================
/// APP VỚI PROVIDER
/// ===========================================
class Ex06TodoProvider extends StatelessWidget {
  const Ex06TodoProvider({super.key});

  @override
  Widget build(BuildContext context) {
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
class _TodoInput extends StatefulWidget {
  const _TodoInput();

  @override
  State<_TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<_TodoInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      // ✅ Dùng read vì trong callback
      context.read<TodoNotifier>().addTodo(text);
      _controller.clear();
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
                prefixIcon: const Icon(Icons.add_task),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _submit,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Tổng',
            value: todoNotifier.todos.length,
            color: Colors.blue,
          ),
          _StatItem(
            label: 'Chờ làm',
            value: todoNotifier.pendingCount,
            color: Colors.orange,
          ),
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

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
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
class _TodoList extends StatelessWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoNotifier>().todos;

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

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: todos.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return _TodoItem(todo: todo);
      },
    );
  }
}

/// ===========================================
/// -TODO ITEM
/// ===========================================
class _TodoItem extends StatelessWidget {
  final Todo todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<TodoNotifier>().deleteTodo(todo.id);
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) {
            context.read<TodoNotifier>().toggleTodo(todo.id);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            context.read<TodoNotifier>().deleteTodo(todo.id);
          },
        ),
      ),
    );
  }
}
