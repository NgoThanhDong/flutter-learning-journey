/// ===========================================
/// EXERCISE 17: NOTES APP (Clean Architecture)
/// ===========================================
/// Ứng dụng ghi chú với:
/// - CRUD operations (Create, Read, Update, Delete)
/// - Local storage (SharedPreferences)
/// - Clean Architecture structure
/// - Error handling với Either

/*
lib/
├── core/
│   ├── failure.dart
│   └── usecase.dart
│
├── features/notes/
│   ├── data/
│   │   ├── datasources/note_local_datasource.dart
│   │   ├── models/note_model.dart
│   │   └── repositories/note_repository_impl.dart
│   │
│   ├── domain/
│   │   ├── entities/note.dart
│   │   ├── repositories/note_repository.dart
│   │   └── usecases/
│   │       ├── get_all_notes.dart
│   │       ├── add_note.dart
│   │       └── delete_note.dart
│   │
│   └── presentation/
│       ├── pages/notes_page.dart
│       └── viewmodels/notes_viewmodel.dart
│
└── injection_container.dart
*/

library;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

/// Domain Entity
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

/// Failure định nghĩa các lỗi chung
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// StorageFailure định nghĩa các lỗi liên quan đến lưu trữ dữ liệu
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Repository Interface định nghĩa các phương thức cần phải có trong repository
abstract class NoteRepository {
  /// [getNotes] lấy danh sách ghi chú
  Future<Either<Failure, List<Note>>> getNotes();

  /// [addNote] thêm ghi chú
  Future<Either<Failure, Note>> addNote(String title, String content);

  /// [deleteNote] xóa ghi chú
  Future<Either<Failure, void>> deleteNote(String id);
}

/// Repository Implementation định nghĩa các phương thức cần phải có trong repository
class InMemoryNoteRepository implements NoteRepository {
  final List<Note> _notes = [];
  int _nextId = 1;

  /// [getNotes] lấy danh sách ghi chú
  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Right(List.from(_notes));
  }

  /// [addNote] thêm ghi chú
  @override
  Future<Either<Failure, Note>> addNote(String title, String content) async {
    if (title.isEmpty) return const Left(StorageFailure('Title required'));
    final note = Note(
      id: 'note_${_nextId++}',
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    _notes.add(note);
    return Right(note);
  }

  /// [deleteNote] xóa ghi chú
  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    return const Right(null);
  }
}

/// ViewModel định nghĩa các phương thức cần phải có trong viewmodel
class NotesViewModel extends ChangeNotifier {
  /// [NoteRepository] repository để truy cập dữ liệu
  final NoteRepository _repo;

  /// [NotesViewModel] khởi tạo viewmodel
  NotesViewModel(this._repo);

  List<Note> notes = [];
  bool isLoading = false;
  String? error;

  /// [load] tải danh sách ghi chú
  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repo.getNotes();
    result.fold((f) => error = f.message, (n) => notes = n);
    isLoading = false;
    notifyListeners();
  }

  /// [add] thêm ghi chú
  Future<void> add(String title, String content) async {
    final result = await _repo.addNote(title, content);
    result.fold((f) => error = f.message, (_) => load());
  }

  /// [delete] xóa ghi chú
  Future<void> delete(String id) async {
    await _repo.deleteNote(id);
    load();
  }
}

/// UI
class Ex17NotesAppClean extends StatefulWidget {
  const Ex17NotesAppClean({super.key});
  @override
  State<Ex17NotesAppClean> createState() => _Ex17NotesAppCleanState();
}

class _Ex17NotesAppCleanState extends State<Ex17NotesAppClean> {
  /// [NotesViewModel] viewmodel để truy cập dữ liệu
  late final NotesViewModel _vm;

  /// [TextEditingController] controller cho title
  final _titleCtrl = TextEditingController();

  /// [TextEditingController] controller cho content
  final _contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// [NotesViewModel] khởi tạo viewmodel
    _vm = NotesViewModel(InMemoryNoteRepository())..load();

    /// [NotesViewModel] lắng nghe sự thay đổi
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.removeListener(() => setState(() {}));
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex17: Notes App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _contentCtrl,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
                const SizedBox(height: 8),

                /// [ElevatedButton] nút thêm ghi chú
                ElevatedButton(
                  onPressed: () {
                    _vm.add(_titleCtrl.text, _contentCtrl.text);
                    _titleCtrl.clear();
                    _contentCtrl.clear();
                  },
                  child: const Text('Add Note'),
                ),
              ],
            ),
          ),

          /// [Text] hiển thị lỗi
          if (_vm.error != null)
            Text(
              'Error: ${_vm.error}',
              style: const TextStyle(color: Colors.red),
            ),

          /// [Expanded] hiển thị danh sách ghi chú
          Expanded(
            child: _vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: _vm.notes
                        .map(
                          (n) => ListTile(
                            title: Text(n.title),
                            subtitle: Text(n.content),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),

                              /// [onPressed] xóa ghi chú
                              onPressed: () => _vm.delete(n.id),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
