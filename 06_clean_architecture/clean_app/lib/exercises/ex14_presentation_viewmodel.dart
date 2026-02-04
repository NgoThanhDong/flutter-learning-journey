/// ===========================================
/// EXERCISE 14: PRESENTATION - VIEWMODEL
/// ===========================================
/// 🎯 Mục tiêu:
/// - ViewModel pattern cho Presentation layer
/// - Tách biệt UI logic khỏi Widget
/// - State management với ChangeNotifier
///
/// 📝 ViewModel trong Clean Architecture:
/// - Quản lý UI state
/// - Gọi Use Cases
/// - Không biết về Widget cụ thể

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================================
/// DOMAIN LAYER
/// ===========================================

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// ===========================================
/// USE CASES (simplified)
/// ===========================================

class TaskRepository {
  final List<Task> _tasks = [];
  int _nextId = 1;

  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_tasks);
  }

  Future<Task> addTask(String title) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final task = Task(
      id: 'task_${_nextId++}',
      title: title,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    _tasks.add(task);
    return task;
  }

  Future<Task> toggleTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception('Task not found');

    _tasks[index] = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );
    return _tasks[index];
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.removeWhere((t) => t.id == id);
  }
}

/// ===========================================
/// PRESENTATION LAYER - VIEWMODEL
/// ===========================================

/// [TaskListViewModel] - Quản lý state cho TaskList UI
class TaskListViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  TaskListViewModel(this._repository);

  /// ===========================================
  /// STATE
  /// ===========================================
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  /// [Filter enum]
  TaskFilter _filter = TaskFilter.all;

  /// [Getters] - UI đọc state qua đây
  List<Task> get tasks {
    switch (_filter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.pending:
        return _tasks.where((t) => !t.isCompleted).toList();
    }
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get filter => _filter;

  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get totalCount => _tasks.length;

  /// ===========================================
  /// ACTIONS - UI gọi khi có event
  /// ===========================================

  /// [loadTasks] - Load danh sách tasks
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// [addTask] - Thêm task mới
  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) {
      _error = 'Title cannot be empty';
      notifyListeners();
      return;
    }

    try {
      await _repository.addTask(title.trim());
      await loadTasks(); // Refresh list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// [toggleTask] - Toggle complete status
  Future<void> toggleTask(String id) async {
    try {
      await _repository.toggleTask(id);
      // Update local state immediately for better UX
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index >= 0) {
        _tasks[index] = _tasks[index].copyWith(
          isCompleted: !_tasks[index].isCompleted,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// [deleteTask] - Xóa task
  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// [setFilter] - Đổi filter
  void setFilter(TaskFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  /// [clearError] - Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

enum TaskFilter { all, completed, pending }

/// ===========================================
/// PRESENTATION LAYER - UI
/// ===========================================
class Ex14PresentationViewmodel extends StatelessWidget {
  const Ex14PresentationViewmodel({super.key});

  @override
  Widget build(BuildContext context) {
    /// [ChangeNotifierProvider] - Cung cấp ViewModel cho widget tree
    return ChangeNotifierProvider(
      create: (_) => TaskListViewModel(TaskRepository())..loadTasks(),
      child: const _TaskListPage(),
    );
  }
}

class _TaskListPage extends StatelessWidget {
  const _TaskListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex14: ViewModel Pattern'),
        actions: [
          /// [Consumer] - Rebuild only this part when state changes
          Consumer<TaskListViewModel>(
            builder: (context, vm, _) => PopupMenuButton<TaskFilter>(
              icon: const Icon(Icons.filter_list),
              onSelected: vm.setFilter,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: TaskFilter.all,
                  child: Text('All (${vm.totalCount})'),
                ),
                PopupMenuItem(
                  value: TaskFilter.completed,
                  child: Text('Completed (${vm.completedCount})'),
                ),
                PopupMenuItem(
                  value: TaskFilter.pending,
                  child: Text('Pending (${vm.pendingCount})'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info
          const Card(
            color: Colors.deepPurple,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 ViewModel Pattern',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'TaskListViewModel:\n'
                    '• State: tasks, isLoading, error, filter\n'
                    '• Actions: loadTasks, addTask, toggleTask\n'
                    '• UI reads state via getters',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Filter indicator
          Consumer<TaskListViewModel>(
            builder: (context, vm, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Filter: ${vm.filter.name}'),
                  const Spacer(),
                  Text('Showing ${vm.tasks.length} tasks'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Task list
          Expanded(
            child: Consumer<TaskListViewModel>(
              builder: (context, vm, _) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${vm.error}'),
                        ElevatedButton(
                          onPressed: () {
                            vm.clearError();
                            vm.loadTasks();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (vm.tasks.isEmpty) {
                  return const Center(child: Text('No tasks yet. Add one!'));
                }

                return ListView.builder(
                  itemCount: vm.tasks.length,
                  itemBuilder: (context, index) {
                    final task = vm.tasks[index];
                    return ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => vm.toggleTask(task.id),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => vm.deleteTask(task.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Task title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskListViewModel>().addTask(controller.text);
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
