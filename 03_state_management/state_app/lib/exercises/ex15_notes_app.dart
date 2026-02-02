/// ===========================================
/// EXERCISE 15: NOTES APP (Practice)
/// ===========================================
///
/// 🎯 Mục tiêu:
/// - Áp dụng Riverpod vào project thực tế
/// - CRUD operations với StateNotifier
/// - Search functionality

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===========================================
/// MODEL
/// ===========================================
@immutable
class Note {
  final String id;
  final String title;
  final String content;
  final Color color;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Note copyWith({String? title, String? content, Color? color}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      createdAt: createdAt,
    );
  }
}

/// ===========================================
/// NOTES NOTIFIER
/// ===========================================
class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier()
    : super([
        // Sample notes
        Note(
          id: '1',
          title: 'Welcome!',
          content: 'This is your first note.',
          color: Colors.blue.shade100,
        ),
        Note(
          id: '2',
          title: 'Flutter Tips',
          content: 'Use const for immutable widgets.',
          color: Colors.green.shade100,
        ),
      ]);

  void addNote(String title, String content, Color color) {
    if (title.trim().isEmpty) return;
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      color: color,
    );
    state = [note, ...state]; // Newest first
  }

  void updateNote(String id, {String? title, String? content, Color? color}) {
    state = state.map((note) {
      if (note.id == id) {
        return note.copyWith(title: title, content: content, color: color);
      }
      return note;
    }).toList();
  }

  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}

/// ===========================================
/// PROVIDERS
/// ===========================================
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredNotesProvider = Provider<List<Note>>((ref) {
  final notes = ref.watch(notesProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) return notes;

  return notes
      .where(
        (note) =>
            note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query),
      )
      .toList();
});

/// ===========================================
/// NOTE COLORS
/// ===========================================
final noteColors = [
  Colors.red.shade100,
  Colors.orange.shade100,
  Colors.yellow.shade100,
  Colors.green.shade100,
  Colors.blue.shade100,
  Colors.purple.shade100,
];

/// ===========================================
/// APP
/// ===========================================
class Ex15NotesApp extends StatelessWidget {
  const Ex15NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: const _NotesScreen(),
      ),
    );
  }
}

/// ===========================================
/// NOTES SCREEN
/// ===========================================
class _NotesScreen extends ConsumerWidget {
  const _NotesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(filteredNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Notes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No notes found'),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) => _NoteCard(note: notes[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteEditor(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteEditor(BuildContext context, WidgetRef ref, [Note? note]) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    Color selectedColor = note?.color ?? noteColors.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note == null ? 'New Note' : 'Edit Note',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: noteColors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color),
                    child: CircleAvatar(
                      backgroundColor: color,
                      child: selectedColor == color
                          ? const Icon(Icons.check, size: 16)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (note == null) {
                        ref
                            .read(notesProvider.notifier)
                            .addNote(
                              titleController.text,
                              contentController.text,
                              selectedColor,
                            );
                      } else {
                        ref
                            .read(notesProvider.notifier)
                            .updateNote(
                              note.id,
                              title: titleController.text,
                              content: contentController.text,
                              color: selectedColor,
                            );
                      }
                      Navigator.pop(context);
                    },
                    child: Text(note == null ? 'Add' : 'Save'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===========================================
/// NOTE CARD
/// ===========================================
class _NoteCard extends ConsumerWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: note.color,
      child: InkWell(
        onTap: () => _showNoteDetail(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () =>
                        ref.read(notesProvider.notifier).deleteNote(note.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  note.content,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoteDetail(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: note.color,
        title: Text(note.title),
        content: Text(note.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
