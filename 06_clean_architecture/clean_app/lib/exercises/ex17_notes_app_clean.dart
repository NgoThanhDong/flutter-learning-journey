/// EXERCISE 17: NOTES APP (Clean Architecture)
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

/// Failure
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Repository Interface
abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Note>> addNote(String title, String content);
  Future<Either<Failure, void>> deleteNote(String id);
}

/// Repository Implementation
class InMemoryNoteRepository implements NoteRepository {
  final List<Note> _notes = [];
  int _nextId = 1;

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Right(List.from(_notes));
  }

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

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    return const Right(null);
  }
}

/// ViewModel
class NotesViewModel extends ChangeNotifier {
  final NoteRepository _repo;
  NotesViewModel(this._repo);

  List<Note> notes = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    final result = await _repo.getNotes();
    result.fold((f) => error = f.message, (n) => notes = n);
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(String title, String content) async {
    final result = await _repo.addNote(title, content);
    result.fold((f) => error = f.message, (_) => load());
  }

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
  late final NotesViewModel _vm;
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = NotesViewModel(InMemoryNoteRepository())..load();
    _vm.addListener(() => setState(() {}));
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
          if (_vm.error != null)
            Text(
              'Error: ${_vm.error}',
              style: const TextStyle(color: Colors.red),
            ),
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
