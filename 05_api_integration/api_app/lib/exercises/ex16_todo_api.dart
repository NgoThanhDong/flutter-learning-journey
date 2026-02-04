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

class Todo {
  final int id;
  final String title;
  bool completed;

  Todo({required this.id, required this.title, this.completed = false});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] as int,
    title: json['title'] as String,
    completed: json['completed'] as bool? ?? false,
  );
}

class Ex16TodoApi extends StatefulWidget {
  const Ex16TodoApi({super.key});

  @override
  State<Ex16TodoApi> createState() => _Ex16TodoApiState();
}

class _Ex16TodoApiState extends State<Ex16TodoApi> {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';
  List<Todo> _todos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  /// [GET] Lấy danh sách
  Future<void> _fetchTodos() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$_baseUrl/todos?_limit=10'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        _todos = list.map((j) => Todo.fromJson(j)).toList();
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
    setState(() => _isLoading = false);
  }

  /// [POST] Tạo mới
  Future<void> _createTodo(String title) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/todos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'completed': false, 'userId': 1}),
      );
      if (response.statusCode == 201) {
        final todo = Todo.fromJson(jsonDecode(response.body));
        setState(() => _todos.insert(0, todo));
        _showSnack('Created!');
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  /// [PUT] Toggle completed
  Future<void> _toggleTodo(Todo todo) async {
    try {
      await http.put(
        Uri.parse('$_baseUrl/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'completed': !todo.completed}),
      );
      setState(() => todo.completed = !todo.completed);
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  /// [DELETE] Xóa
  Future<void> _deleteTodo(int id) async {
    try {
      await http.delete(Uri.parse('$_baseUrl/todos/$id'));
      setState(() => _todos.removeWhere((t) => t.id == id));
      _showSnack('Deleted!');
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Todo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchTodos),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, i) {
                final todo = _todos[i];
                return Dismissible(
                  key: Key('${todo.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteTodo(todo.id),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (_) => _toggleTodo(todo),
                    ),
                    title: Text(
                      todo.title,
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
