/// ===========================================
/// EXERCISE 16: TODO APP (CUBIT)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xây dựng ứng dụng Todo hoàn chỉnh
/// - CRUD: Create, Read, Update (Toggle), Delete
/// - State: List<Todo>
///
/// 📝 Logic:
/// - TodoCubit quản lý List<Todo>
/// - Các thao tác (add, toggle, remove) sẽ emit state mới là List<Todo> mới

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. MODEL
class Todo extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const Todo({required this.id, required this.title, this.isCompleted = false});

  Todo copyWith({String? id, String? title, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, title, isCompleted];
}

/// 2. CUBIT
/// State chính là List<Todo>. Initial state là rỗng [].
class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void addTodo(String title) {
    if (title.isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().toIso8601String(),
      title: title,
    );

    // Spread operator [...] để tạo list mới -> State change
    emit([...state, newTodo]);
  }

  void toggleTodo(String id) {
    final updatedList = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    emit(updatedList);
  }

  void removeTodo(String id) {
    // Where trả về Iterable -> toList để thành List
    final updatedList = state.where((todo) => todo.id != id).toList();
    emit(updatedList);
  }
}

/// 3. UI
class Ex16TodoCubit extends StatelessWidget {
  const Ex16TodoCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(),
      child: const TodoView(),
    );
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex16: Todo App (Cubit)')),
      body: Column(
        children: [
          // Input Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'New Task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _addTash(),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _addTash,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Todo List
          Expanded(
            child: BlocBuilder<TodoCubit, List<Todo>>(
              builder: (context, todos) {
                if (todos.isEmpty) {
                  return const Center(child: Text('No tasks yet!'));
                }

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      key: ValueKey(todo.id),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) {
                          context.read<TodoCubit>().toggleTodo(todo.id);
                        },
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted ? Colors.grey : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<TodoCubit>().removeTodo(todo.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addTash() {
    context.read<TodoCubit>().addTodo(_controller.text);
    _controller.clear();
  }
}
