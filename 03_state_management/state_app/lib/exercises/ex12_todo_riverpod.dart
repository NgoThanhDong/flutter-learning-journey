/// ===========================================
/// EXERCISE 12: -TODO VỚI RIVERPOD STATENOTIFIER
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Sử dụng StateNotifier cho state phức tạp
/// - Hiểu immutable state updates
/// - StateNotifierProvider pattern
///
/// 📝 Yêu cầu:
/// - TodoNotifier extends StateNotifier
/// - Add, remove, toggle todos
/// - Immutable state updates (tạo list mới)

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===========================================
/// MODEL
/// ===========================================
/// [Model] là class immutable chứa dữ liệu
/// [@immutable] để đánh dấu class là immutable, không thể thay đổi giá trị sau khi tạo
/// [copyWith] để tạo object mới với giá trị đã thay đổi
@immutable
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  const Todo({required this.id, required this.title, this.isCompleted = false});

  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// ===========================================
/// STATE NOTIFIER
/// ===========================================
/// [StateNotifier<T>] cho state phức tạp (List, Object...)
/// T là kiểu của state, state được truy cập qua `state`
class TodoNotifier extends StateNotifier<List<Todo>> {
  /// Constructor với super([]) = initial state là empty list
  TodoNotifier() : super([]);

  /// [Add todo]
  /// QUAN TRỌNG: Tạo list MỚI, không mutate list cũ
  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

    // ✅ ĐÚNG: Tạo list mới với spread operator
    state = [...state, newTodo];

    // ❌ SAI: state.add(newTodo) - Mutate list cũ, không notify!
  }

  /// [Remove todo]
  void removeTodo(String id) {
    // Tạo list mới không chứa todo cần xóa
    state = state.where((todo) => todo.id != id).toList();
  }

  /// [Toggle todo]
  void toggleTodo(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();
  }

  /// [Clear completed]
  void clearCompleted() {
    state = state.where((todo) => !todo.isCompleted).toList();
  }
}

/// ===========================================
/// PROVIDERS
/// ===========================================
/// [StateNotifierProvider] cho StateNotifier
/// `<NotifierType, StateType>`
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

/// [Derived provider] Đếm todos chưa hoàn thành
/// Tự động update khi todoProvider thay đổi
final pendingCountProvider = Provider<int>((ref) {
  // [ref.watch] Lắng nghe thay đổi của provider
  final todos = ref.watch(todoProvider);
  return todos.where((t) => !t.isCompleted).length;
});

/// [Derived provider] Đếm todos đã hoàn thành
final completedCountProvider = Provider<int>((ref) {
  // [ref.watch] Lắng nghe thay đổi của provider
  final todos = ref.watch(todoProvider);
  return todos.where((t) => t.isCompleted).length;
});

/// ===========================================
/// APP
/// ===========================================
class Ex12TodoRiverpod extends StatelessWidget {
  const Ex12TodoRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    // [ProviderScope] bao bọc ứng dụng để sử dụng Riverpod
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const _TodoScreen(),
      ),
    );
  }
}

/// ===========================================
/// -TODO SCREEN
/// ===========================================
/// [ConsumerWidget] widget có thể đọc provider
/// [WidgetRef ref] tham số thứ 2 của build method
/// [ref.watch] lắng nghe thay đổi của provider
/// [ref.read] đọc provider một lần
/// [ref.listen] lắng nghe thay đổi của provider và thực hiện side effect
/// [ref.read(provider.notifier)] đọc notifier của provider
/// [ref.read(provider.notifier).method()] gọi method của notifier
class _TodoScreen extends ConsumerWidget {
  const _TodoScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // [ref.watch] Lắng nghe thay đổi của provider
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex12: Riverpod Todo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            // [ref.read(provider.notifier).method()] gọi method của notifier
            onPressed: () => ref.read(todoProvider.notifier).clearCompleted(),
            tooltip: 'Clear completed',
          ),
        ],
      ),
      body: Column(
        children: [
          // Input
          const _TodoInput(),

          // Stats
          const _StatsBar(),

          // Divider là đường kẻ ngang
          const Divider(height: 1),

          // List
          // [Expanded] để chiếm hết không gian còn lại
          Expanded(
            // [todos.isEmpty] kiểm tra xem list có rỗng không
            child: todos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Chưa có todo nào',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                // [else] nếu list không rỗng thì hiển thị list
                : ListView.builder(
                    // [itemCount] số lượng item
                    itemCount: todos.length,
                    // [itemBuilder] builder cho từng item
                    itemBuilder: (context, index) =>
                        _TodoItem(todo: todos[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// -TODO INPUT
/// ===========================================
/// _TodoInput là widget để nhập todo
class _TodoInput extends ConsumerStatefulWidget {
  const _TodoInput();

  // ConsumerStatefulWidget là widget có state
  // ConsumerState<T> extends ConsumerStatefulWidget
  // T là widget
  // ConsumerState là state của widget
  @override
  ConsumerState<_TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends ConsumerState<_TodoInput> {
  // TextEditingController dùng để nhập todo
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // giải phóng bộ nhớ
    super.dispose();
  }

  // submit là method để thêm todo
  void _submit() {
    if (_controller.text.isNotEmpty) {
      /// [ref.read] trong callback
      ref.read(todoProvider.notifier).addTodo(_controller.text);
      _controller.clear(); // xóa controller sau khi thêm todo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Expanded là widget để chiếm hết không gian còn lại
          // TextField dùng để nhập todo
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Thêm todo mới...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.add_task),
              ),
              // onSubmitted là method được gọi khi nhấn Enter
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 12),
          // FloatingActionButton là nút để thêm todo
          FloatingActionButton(
            onPressed: _submit, // gọi method _submit khi nhấn nút
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

/// ===========================================
/// STATS BAR
/// ===========================================
/// _StatsBar là widget để hiển thị số lượng todo
class _StatsBar extends ConsumerWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [Derived providers] Tự động update
    /// [ref.watch] Lắng nghe thay đổi của provider
    /// [todoProvider] là provider chứa danh sách todo
    /// [pendingCountProvider] là provider chứa số lượng todo chưa hoàn thành
    /// [completedCountProvider] là provider chứa số lượng todo đã hoàn thành
    final total = ref.watch(todoProvider).length;
    final pending = ref.watch(pendingCountProvider);
    final completed = ref.watch(completedCountProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // _Stat là widget để hiển thị số lượng todo
          _Stat(label: 'Total', value: total, color: Colors.blue),
          _Stat(label: 'Pending', value: pending, color: Colors.orange),
          _Stat(label: 'Done', value: completed, color: Colors.green),
        ],
      ),
    );
  }
}

/// _Stat là widget để hiển thị số lượng todo
class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _Stat({required this.label, required this.value, required this.color});

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
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

/// ===========================================
/// -TODO ITEM
/// ===========================================
/// _TodoItem là widget để hiển thị danh sách todo
/// ConsumerWidget là widget có state
/// [ConsumerState<T>] extends [ConsumerStatefulWidget]
/// [T] là widget
/// [ConsumerState] là state của widget
class _TodoItem extends ConsumerWidget {
  final Todo todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [Dismissible] là widget để xóa item khi vuốt
    /// [key] là key của item
    /// [direction] là hướng vuốt
    /// [background] là background khi vuốt
    /// [onDismissed] là method được gọi khi xóa item
    /// [child] là item
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      /// [onDismissed] là method được gọi khi xóa item
      /// [ref.read] trong callback
      /// [todoProvider.notifier] là notifier của provider
      /// [removeTodo] là method để xóa item
      onDismissed: (_) => ref.read(todoProvider.notifier).removeTodo(todo.id),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,

          /// [onChanged] là method được gọi khi thay đổi trạng thái todo
          /// [ref.read] trong callback
          /// [todoProvider.notifier] là notifier của provider
          /// [toggleTodo] là method để thay đổi trạng thái todo
          onChanged: (_) => ref.read(todoProvider.notifier).toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => ref.read(todoProvider.notifier).removeTodo(todo.id),
        ),
      ),
    );
  }
}
