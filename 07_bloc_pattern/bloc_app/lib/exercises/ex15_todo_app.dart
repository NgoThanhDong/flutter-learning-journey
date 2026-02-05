/// ============================================================================
/// EXERCISE 15: -TODO APP (COMPLETE CRUD WITH CUBIT)
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Xây dựng Todo App hoàn chỉnh
/// - CRUD operations với Cubit
/// - Quản lý list state
/// - UI interactions
///
/// 📝 FEATURES:
/// - Add todo
/// - Toggle complete
/// - Delete todo
/// - Filter (All, Active, Completed)
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// -TODO MODEL
// ============================================================================
class Todo extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }

  @override
  List<Object> get props => [id, title, isCompleted, createdAt];
}

// ============================================================================
// -TODO STATE
// ============================================================================
enum TodoFilter { all, active, completed }

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoFilter filter;

  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
  });

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.active:
        return todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return todos.where((t) => t.isCompleted).toList();
      case TodoFilter.all:
        return todos;
    }
  }

  int get activeCount => todos.where((t) => !t.isCompleted).length;
  int get completedCount => todos.where((t) => t.isCompleted).length;

  TodoState copyWith({List<Todo>? todos, TodoFilter? filter}) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object> get props => [todos, filter];
}

// ============================================================================
// -TODO CUBIT
// ============================================================================
class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState());

  /// Add new todo
  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(todos: [...state.todos, todo]));
  }

  /// Toggle todo completion
  void toggleTodo(String id) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  /// Delete todo
  void deleteTodo(String id) {
    final updatedTodos = state.todos.where((t) => t.id != id).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  /// Set filter
  void setFilter(TodoFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  /// Clear completed
  void clearCompleted() {
    final updatedTodos = state.todos.where((t) => !t.isCompleted).toList();
    emit(state.copyWith(todos: updatedTodos));
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex15TodoApp extends StatelessWidget {
  const Ex15TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(),
      child: const _TodoView(),
    );
  }
}

class _TodoView extends StatefulWidget {
  const _TodoView();

  @override
  State<_TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<_TodoView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex15: Todo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Clear completed button
          BlocSelector<TodoCubit, TodoState, int>(
            selector: (state) => state.completedCount,
            builder: (context, completedCount) {
              if (completedCount == 0) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => context.read<TodoCubit>().clearCompleted(),
                icon: const Icon(Icons.delete_sweep),
                label: Text('Clear ($completedCount)'),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ================================================================
          // INPUT FIELD
          // ================================================================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Thêm todo mới...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.add_task),
                    ),
                    onSubmitted: (value) {
                      context.read<TodoCubit>().addTodo(value);
                      _controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<TodoCubit>().addTodo(_controller.text);
                    _controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // ================================================================
          // FILTER TABS
          // ================================================================
          BlocBuilder<TodoCubit, TodoState>(
            buildWhen: (prev, curr) => prev.filter != curr.filter,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<TodoFilter>(
                  segments: const [
                    ButtonSegment(value: TodoFilter.all, label: Text('All')),
                    ButtonSegment(
                        value: TodoFilter.active, label: Text('Active')),
                    ButtonSegment(
                        value: TodoFilter.completed, label: Text('Done')),
                  ],
                  selected: {state.filter},
                  onSelectionChanged: (selected) {
                    context.read<TodoCubit>().setFilter(selected.first);
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ================================================================
          // -TODO LIST
          // ================================================================
          Expanded(
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                final todos = state.filteredTodos;

                if (todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          state.filter == TodoFilter.all
                              ? 'Chưa có todo nào'
                              : 'Không có todo ${state.filter == TodoFilter.active ? 'active' : 'completed'}',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return _TodoItem(todo: todo);
                  },
                );
              },
            ),
          ),

          // ================================================================
          // STATS BAR
          // ================================================================
          BlocBuilder<TodoCubit, TodoState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Total: ${state.todos.length}'),
                    Text('Active: ${state.activeCount}'),
                    Text('Completed: ${state.completedCount}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<TodoCubit>().deleteTodo(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => context.read<TodoCubit>().toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.read<TodoCubit>().deleteTodo(todo.id),
        ),
      ),
    );
  }
}
