/// ===========================================
/// EXERCISE 13: HIVE BASIC
/// ===========================================
/// 🎯 Mục tiêu:
/// - Khởi tạo và sử dụng Hive
/// - CRUD operations với Hive Box
/// - So sánh với SharedPreferences
///
/// 📝 Hive vs SharedPreferences:
/// - Hive: Nhanh hơn, hỗ trợ custom objects
/// - SharedPreferences: Đơn giản, chỉ primitive types (kiểu nguyên thủy)
///
/// ⚠️ Lưu ý: Hive cần init trong main() TRƯỚC runApp()

library;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// ===========================================
/// NOTE MODEL (không dùng adapter cho demo đơn giản)
/// ===========================================
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(); // Default value

  /// [toMap] - Convert để lưu vào Hive
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };

  /// [fromMap] - Parse từ Hive
  factory Note.fromMap(Map<dynamic, dynamic> map) {
    return Note(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

/// ===========================================
/// UI WIDGET
/// ===========================================
/// Ex13HiveBasic là widget tạo UI cho bài tập Hive Basic
class Ex13HiveBasic extends StatefulWidget {
  const Ex13HiveBasic({super.key});

  @override
  State<Ex13HiveBasic> createState() => _Ex13HiveBasicState();
}

class _Ex13HiveBasicState extends State<Ex13HiveBasic> {
  /// [Box] - Container lưu trữ data trong Hive
  /// Box giống như table trong database
  /// Box có thể chứa các object phức tạp
  /// Box được mở thông qua Hive.openBox()
  /// Box được đóng thông qua box.close()
  Box? _notesBox;

  List<Note> _notes = []; // [List<Note>] - Danh sách notes
  bool _isLoading = true; // [bool] - Loading state
  String? _error; // [String] - Error message

  @override
  void initState() {
    super.initState();
    _initHive(); // [Init Hive] - Khởi tạo Hive
  }

  /// [Init Hive] - Khởi tạo Hive
  Future<void> _initHive() async {
    try {
      /// [Hive.initFlutter] - Khởi tạo Hive cho Flutter
      /// Thường gọi trong main(), nhưng để demo, gọi ở đây
      await Hive.initFlutter();

      /// [openBox] - Mở box (tạo mới nếu chưa có)
      /// Box giống như table trong database
      _notesBox = await Hive.openBox('notes_box');

      _loadNotes(); // [Load Notes] - Load notes từ box
    } catch (e) {
      setState(() {
        _error = 'Error init Hive: $e';
        _isLoading = false;
      });
    }
  }

  /// [READ] Đọc tất cả notes
  void _loadNotes() {
    if (_notesBox == null) return;

    /// [box.values] - Lấy tất cả values
    /// [box.keys] - Lấy tất cả keys
    /// [box.toMap()] - Lấy Map<key, value>
    /// [Note.fromMap] - Parse từ Map
    /// [toList] - Chuyển thành List<Note>
    final notes = _notesBox!.values
        .map((item) => Note.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();

    // Sort by createdAt desc
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  /// [CREATE] Thêm note mới
  /// [Note] - Object note mới
  Future<void> _addNote(String title, String content) async {
    if (_notesBox == null) return;

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
    );

    /// [box.put] - Lưu với key cụ thể
    /// Key = note.id, Value = note.toMap()
    await _notesBox!.put(note.id, note.toMap());

    _loadNotes(); // [Load Notes] - Load notes từ box
  }

  /// [DELETE] Xóa note
  Future<void> _deleteNote(String id) async {
    if (_notesBox == null) return;

    /// [box.delete] - Xóa theo key
    await _notesBox!.delete(id);

    _loadNotes();
  }

  /// [CLEAR] Xóa tất cả
  Future<void> _clearAll() async {
    if (_notesBox == null) return;

    /// [box.clear] - Xóa toàn bộ data trong box
    await _notesBox!.clear();

    _loadNotes();
  }

  /// [ADD] Hiển thị dialog thêm note
  void _showAddDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          /// [CANCEL] Hủy
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          /// [ADD] Thêm
          ElevatedButton(
            onPressed: () {
              _addNote(titleController.text, contentController.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    /// [box.close] - Đóng box khi không cần
    _notesBox?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex13: Hive Basic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),

            /// [CLEAR ALL] Xóa tất cả
            onPressed: _notes.isEmpty ? null : _clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),

      /// [FAB] Floating Action Button - Thêm note
      floatingActionButton: FloatingActionButton(
        // [Show Add Dialog] - Hiển thị dialog thêm note
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  /// [BUILD BODY] Build body
  Widget _buildBody() {
    // [LOADING] - Loading
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // [ERROR] - Lỗi
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    // [EMPTY] - Trống
    if (_notes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No notes yet'),
            Text('Tap + to add a note'),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Info card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.green[50],
          child: Text(
            '💾 ${_notes.length} notes stored in Hive',
            style: const TextStyle(color: Colors.green),
          ),
        ),

        /// [LIST NOTES] Danh sách notes
        Expanded(
          child: ListView.builder(
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              final note = _notes[index];

              // [DISMISSIBLE] - Xóa note
              // [KEY] - Key của note
              // [DIRECTION] - Hướng xóa
              // [BACKGROUND] - Background khi xóa
              // [ON DISMISSED] - Khi xóa
              return Dismissible(
                key: Key(note.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                // [ON DISMISSED] - Khi xóa
                // [DELETE NOTE] - Xóa note
                onDismissed: (_) => _deleteNote(note.id),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),

                  // [LIST TILE] - List tile
                  child: ListTile(
                    // [TITLE] - Tiêu đề note
                    title: Text(
                      note.title.isEmpty ? '(No title)' : note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // [SUBTITLE] - Subtitle note
                    subtitle: Text(
                      note.content.isEmpty ? '(No content)' : note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // [TRAILING] - Trailing note
                    trailing: Text(
                      // [CREATED AT] - Thời gian tạo
                      '${note.createdAt.hour}:${note.createdAt.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
