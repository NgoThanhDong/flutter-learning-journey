/// ===========================================
/// EXERCISE 16: -TODO API (CRUD)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Full CRUD với JSONPlaceholder API
/// - GET, POST, PUT, DELETE operations
/// - Quản lý state với UI updates
///
/// 📝 API Endpoints:
/// GET    /todos    - Lấy danh sách
/// POST   /todos    - Tạo mới
/// PUT    /todos/1  - Cập nhật
/// DELETE /todos/1  - Xóa

library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Todo model là class để map JSON response
// {"userId":1,"id":1,"title":"delectus aut autem","completed":false}
class Todo {
  final int id;
  final String title;
  bool completed;

  Todo({required this.id, required this.title, this.completed = false});

  // fromJson là hàm factory để parse JSON response
  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] as int,
    title: json['title'] as String,
    completed: json['completed'] as bool? ?? false,
  );
}

// Ex16TodoApi là widget để hiển thị danh sách todo
class Ex16TodoApi extends StatefulWidget {
  const Ex16TodoApi({super.key});

  @override
  State<Ex16TodoApi> createState() => _Ex16TodoApiState();
}

class _Ex16TodoApiState extends State<Ex16TodoApi> {
  // Base URL của API
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';
  // Danh sách todo
  List<Todo> _todos = [];
  // Trạng thái loading
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodos(); // Gọi hàm fetchTodos khi widget được tạo
  }

  /// [GET] Lấy danh sách
  Future<void> _fetchTodos() async {
    setState(() => _isLoading = true); // Set trạng thái loading

    // Try catch để bắt lỗi
    try {
      // Gọi API GET /todos?_limit=10
      final response = await http.get(Uri.parse('$_baseUrl/todos?_limit=10'));
      // Nếu response thành công
      if (response.statusCode == 200) {
        // Parse JSON response và map sang list of Todo
        final list = jsonDecode(response.body) as List;
        _todos = list.map((j) => Todo.fromJson(j)).toList();
      }
    } catch (e) {
      _showSnack('Error: $e'); // Hiển thị lỗi
    }

    // Set trạng thái loading
    setState(() => _isLoading = false);
  }

  /// [POST] Tạo mới
  Future<void> _createTodo(String title) async {
    try {
      // Gọi API POST /todos
      // headers: {'Content-Type': 'application/json'} để báo cho server biết body là JSON
      // body: jsonEncode({'title': title, 'completed': false, 'userId': 1}) để gửi dữ liệu
      final response = await http.post(
        Uri.parse('$_baseUrl/todos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'completed': false, 'userId': 1}),
      );

      // Nếu response thành công
      if (response.statusCode == 201) {
        // Parse JSON response và map sang Todo
        final todo = Todo.fromJson(jsonDecode(response.body));
        // Thêm todo vào đầu danh sách
        setState(() => _todos.insert(0, todo));
        // Hiển thị thông báo
        _showSnack('Created!');
      }
    } catch (e) {
      _showSnack('Error: $e'); // Hiển thị lỗi
    }
  }

  /// [PUT] Toggle completed
  Future<void> _toggleTodo(Todo todo) async {
    try {
      // Gọi API PUT /todos/{id}
      // headers: {'Content-Type': 'application/json'} để báo cho server biết body là JSON
      // body: jsonEncode({'completed': !todo.completed}) để gửi dữ liệu
      await http.put(
        Uri.parse('$_baseUrl/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'completed': !todo.completed}),
      );
      // Update state
      setState(() => todo.completed = !todo.completed);
    } catch (e) {
      _showSnack('Error: $e'); // Hiển thị lỗi
    }
  }

  /// [DELETE] Xóa
  Future<void> _deleteTodo(int id) async {
    try {
      // Gọi API DELETE /todos/{id}
      await http.delete(Uri.parse('$_baseUrl/todos/$id'));
      // Update state - Xóa todo khỏi danh sách
      setState(() => _todos.removeWhere((t) => t.id == id));
      // Hiển thị thông báo
      _showSnack('Deleted!');
    } catch (e) {
      _showSnack('Error: $e'); // Hiển thị lỗi
    }
  }

  // Hàm hiển thị thông báo
  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Hàm hiển thị dialog để thêm todo mới
  void _showAddDialog() {
    // Tạo TextEditingController để lấy dữ liệu từ TextField
    final controller = TextEditingController();

    // Hiển thị dialog
    showDialog(
      context: context,
      // builder: (ctx) => AlertDialog(...) là cách tạo dialog
      builder: (ctx) => AlertDialog(
        title: const Text('New Todo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
        actions: [
          // Nút Cancel để đóng dialog
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          // Nút Add để thêm todo mới
          ElevatedButton(
            onPressed: () {
              _createTodo(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex16: Todo CRUD'),
        actions: [
          // Nút Refresh để tải lại danh sách
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchTodos),
        ],
      ),

      // Nút thêm mới
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),

      // Body hiển thị danh sách todo
      body: _isLoading
          // Hiển thị loading khi đang tải
          ? const Center(child: CircularProgressIndicator())
          // Hiển thị danh sách todo
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, i) {
                final todo = _todos[i]; // Lấy todo tại index i

                // Dismissible để cho phép vuốt để xóa
                return Dismissible(
                  // Key duy nhất cho mỗi item
                  key: Key('${todo.id}'),
                  // Hướng vuốt
                  direction: DismissDirection.endToStart,
                  // Background hiển thị khi vuốt
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  // Hàm được gọi khi vuốt
                  onDismissed: (_) => _deleteTodo(todo.id),

                  // ListTile để hiển thị todo
                  child: ListTile(
                    // Checkbox để đánh dấu hoàn thành
                    leading: Checkbox(
                      value: todo.completed, // Giá trị checkbox
                      // Hàm được gọi khi checkbox thay đổi
                      onChanged: (_) => _toggleTodo(todo),
                    ),
                    // Tiêu đề todo
                    title: Text(
                      todo.title,
                      // Gạch ngang nếu todo đã hoàn thành
                      style: TextStyle(
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
