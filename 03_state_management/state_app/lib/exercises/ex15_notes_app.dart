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
/// [Note] là class để lưu trữ thông tin của note
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
  // Nếu không có createdAt thì lấy thời gian hiện tại

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
/// [NotesNotifier] là class để quản lý state của notes
class NotesNotifier extends StateNotifier<List<Note>> {
  /// [NotesNotifier] là constructor của [NotesNotifier]
  /// [super] là constructor của [StateNotifier]
  /// [super] nhận vào một list của [Note]
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

  /// [addNote] là method để thêm note
  void addNote(String title, String content, Color color) {
    if (title.trim().isEmpty) return;
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      color: color,
    );

    /// [state] là state của [NotesNotifier]
    /// [state] là list của [Note]
    state = [note, ...state]; // Newest first
  }

  /// [updateNote] là method để cập nhật note
  void updateNote(String id, {String? title, String? content, Color? color}) {
    state = state.map((note) {
      if (note.id == id) {
        return note.copyWith(title: title, content: content, color: color);
      }
      return note;
    }).toList();
  }

  /// [deleteNote] là method để xóa note
  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}

/// ===========================================
/// PROVIDERS
/// ===========================================
/// [notesProvider] là provider để quản lý state của notes
/// [StateNotifierProvider] là provider của [NotesNotifier]
/// [List<Note>] là list của [Note]
/// [NotesNotifier] là class để quản lý state của notes
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

/// [searchQueryProvider] là provider để quản lý state của search query
/// [StateProvider] là provider của [String]
final searchQueryProvider = StateProvider<String>((ref) => '');

/// [filteredNotesProvider] là provider để quản lý state của notes đã lọc
/// [Provider] là provider của [List<Note>]
final filteredNotesProvider = Provider<List<Note>>((ref) {
  /// [notes] là list của [Note]
  final notes = ref.watch(notesProvider);

  /// [query] là string
  final query = ref.watch(searchQueryProvider).toLowerCase();

  /// [query] rỗng thì trả về [notes]
  if (query.isEmpty) return notes;

  /// [notes] có chứa [query] thì trả về [notes]
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
/// [Ex15NotesApp] là class để quản lý state của app
class Ex15NotesApp extends StatelessWidget {
  const Ex15NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// [ProviderScope] là scope của [Provider]
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
/// [_NotesScreen] là class để quản lý state của notes screen
class _NotesScreen extends ConsumerWidget {
  const _NotesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [notes] là list của [Note]
    /// [filteredNotesProvider] là provider để quản lý state của notes đã lọc
    /// [ref.watch] là method để watch state của [Provider]
    final notes = ref.watch(filteredNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Notes'),

        /// [bottom] là bottom của [AppBar]
        /// [PreferredSize]: là widget dùng để nói cho parent biết muốn có kích thước bao nhiêu
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60), // Chiều cao của [AppBar]
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              /// [onChanged] là method khi người dùng thay đổi text
              /// [ref.read] là method để đọc state của [Provider]
              /// [searchQueryProvider.notifier] là notifier của [searchQueryProvider]
              /// [state] là state của [searchQueryProvider]
              /// [value] là giá trị của [TextField]
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                filled: true, // filled = true: có nền
                fillColor: Colors.white, // Màu nền
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Bán kính
                  borderSide: BorderSide.none, // Không có border
                ),
              ),
            ),
          ),
        ),
      ),

      // Nếu notes rỗng thì hiển thị [Center]
      // Nếu notes không rỗng thì hiển thị [GridView]
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
                crossAxisCount: 2, // Số lượng hàng
                crossAxisSpacing: 12, // Khoảng cách giữa các hàng
                mainAxisSpacing: 12, // Khoảng cách giữa các cột
                childAspectRatio: 1, // Tỷ lệ giữa chiều rộng và chiều cao
              ),
              itemCount: notes.length, // Số lượng notes
              // itemBuilder là method để hiển thị note, trả về [NoteCard]
              itemBuilder: (context, index) => _NoteCard(note: notes[index]),
            ),

      // Nút thêm note
      floatingActionButton: FloatingActionButton(
        // Khi người dùng nhấn nút thì hiển thị [showNoteEditor]
        onPressed: () => _showNoteEditor(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// ===========================================
/// NOTE CARD
/// ===========================================
/// [_NoteCard] là widget để hiển thị note
class _NoteCard extends ConsumerWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: note.color,
      // [InkWell] là widget để tạo hiệu ứng sóng nước khi người dùng nhấn vào note
      child: InkWell(
        // Khi người dùng nhấn vào note thì hiển thị [showNoteDetail]
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
                  // Text title note
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

                  // Icon edit note
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    // Khi người dùng nhấn vào icon edit thì hiển thị [showNoteEditor]
                    onPressed: () => _showNoteEditor(context, ref, note),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  const SizedBox(width: 8),

                  // Icon delete note
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    // Khi người dùng nhấn vào icon delete thì xóa note
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

// [_showNoteEditor] là method để hiển thị [showNoteEditor]
// [note] là note cần chỉnh sửa
void _showNoteEditor(BuildContext context, WidgetRef ref, [Note? note]) {
  // [titleController] là controller của [TextField] title
  final titleController = TextEditingController(text: note?.title ?? '');
  // [contentController] là controller của [TextField] content
  final contentController = TextEditingController(text: note?.content ?? '');
  // [selectedColor] là màu của note
  Color selectedColor = note?.color ?? noteColors.first;

  // Hiển thị [showModalBottomSheet]
  // [isScrollControlled] là method để control scroll của [showModalBottomSheet]
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Cho phép scroll
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.only(
          // [MediaQuery.of(context).viewInsets.bottom] là khoảng cách từ bottom của màn hình
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

            // Wrap là widget để hiển thị các widget theo hàng ngang
            Wrap(
              spacing: 8,
              children: noteColors.map((color) {
                // GestureDetector là widget để nhận sự kiện click
                return GestureDetector(
                  // onTap là sự kiện click
                  // setState là method để update UI
                  onTap: () => setState(() => selectedColor = color),
                  // CircleAvatar là widget để hiển thị hình tròn
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
                  // Navigator.pop là method để đóng [showModalBottomSheet]
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 8),

                // FilledButton là widget để hiển thị button
                FilledButton(
                  onPressed: () {
                    // Nếu note == null thì thêm note
                    // Nếu note != null thì cập nhật note
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
                    // Navigator.pop là method để đóng [showModalBottomSheet]
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
