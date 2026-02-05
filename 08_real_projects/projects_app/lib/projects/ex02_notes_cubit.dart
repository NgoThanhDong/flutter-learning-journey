/// ============================================================================
/// EXERCISE 02: NOTES CUBIT - State Management cho Notes App
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Học cách tổ chức State Management với Cubit cho ứng dụng CRUD.
///
/// 📝 BẠN SẼ HỌC:
/// - Thiết kế States cho complex features
/// - CRUD operations trong Cubit
/// - Search/Filter functionality
/// - Local storage integration
/// - Error handling patterns
///
/// ============================================================================
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'ex01_note_model.dart';

// ============================================================================
// NOTES STATE
// ============================================================================
///
/// ## Tại sao dùng sealed class?
///
/// [sealed class] (Dart 3+) cho phép:
/// - Giới hạn các subclasses có thể tạo
/// - Pattern matching exhaustive (compiler báo nếu thiếu case)
/// - Rõ ràng về các trạng thái có thể có
///
/// ## Các trạng thái của Notes App:
///
/// ```
/// App Start → NotesInitial
///     │
///     ▼
/// Load Data → NotesLoading
///     │
///     ├──[Success]──→ NotesLoaded
///     │                    │
///     │                    ├── Add/Update/Delete → NotesLoaded (new list)
///     │                    │
///     │                    └── Search → NotesLoaded (filtered list)
///     │
///     └──[Error]────→ NotesError
/// ```
///
// ============================================================================

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu - chưa load data.
///
/// App vừa khởi động, chưa gọi loadNotes().
class NotesInitial extends NotesState {
  const NotesInitial();
}

/// Đang load dữ liệu từ storage.
///
/// Hiển thị loading indicator cho user.
class NotesLoading extends NotesState {
  const NotesLoading();
}

/// Đã load xong, có data (có thể rỗng).
///
/// Đây là state chính của app, chứa:
/// - [allNotes]: Tất cả notes trong storage
/// - [displayedNotes]: Notes đang hiển thị (sau filter/search)
/// - [searchQuery]: Từ khóa tìm kiếm hiện tại
class NotesLoaded extends NotesState {
  /// Tất cả notes trong storage.
  ///
  /// Đây là "source of truth" - data gốc.
  final List<Note> allNotes;

  /// Notes đang hiển thị (có thể đã được filter).
  ///
  /// Khi search: displayedNotes là subset của allNotes.
  /// Khi không search: displayedNotes = allNotes.
  final List<Note> displayedNotes;

  /// Từ khóa tìm kiếm hiện tại.
  ///
  /// Empty string = không search.
  final String searchQuery;

  const NotesLoaded({
    required this.allNotes,
    required this.displayedNotes,
    this.searchQuery = '',
  });

  /// Factory tạo NotesLoaded với displayedNotes = allNotes.
  ///
  /// Dùng khi không có filter/search.
  factory NotesLoaded.all(List<Note> notes) {
    return NotesLoaded(allNotes: notes, displayedNotes: notes, searchQuery: '');
  }

  /// Số lượng notes hiển thị.
  int get count => displayedNotes.length;

  /// Check có đang search không.
  bool get isSearching => searchQuery.isNotEmpty;

  /// Check có notes nào không (trước khi search).
  bool get hasNotes => allNotes.isNotEmpty;

  /// Check có kết quả search không.
  bool get hasResults => displayedNotes.isNotEmpty;

  @override
  List<Object?> get props => [allNotes, displayedNotes, searchQuery];
}

/// Có lỗi xảy ra.
///
/// Hiển thị error message và cho phép retry.
class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================================================
// NOTES CUBIT
// ============================================================================
///
/// [NotesCubit] quản lý toàn bộ state và logic của Notes feature.
///
/// ## Responsibilities:
/// - Load notes từ local storage
/// - CRUD operations (Create, Read, Update, Delete)
/// - Search/Filter notes
/// - Persist data vào storage
///
/// ## Tại sao dùng Cubit thay vì BLoC?
///
/// Cubit phù hợp hơn cho Notes App vì:
/// - Logic đơn giản, không cần event tracking
/// - CRUD operations straightforward
/// - Ít boilerplate code hơn BLoC
///
/// Nếu cần BLoC: Xem Weather App (Ex08) với complex events.
///
// ============================================================================

class NotesCubit extends Cubit<NotesState> {
  // ==========================================================================
  // DEPENDENCIES
  // ==========================================================================
  //
  // SharedPreferences dùng để lưu notes vào local storage.
  //
  // Tại sao dùng late final?
  // - late: Sẽ khởi tạo sau (trong init method)
  // - final: Chỉ gán 1 lần, không thay đổi
  // ==========================================================================

  late final SharedPreferences _prefs;

  /// Key để lưu notes trong SharedPreferences.
  ///
  /// Format: 'notes_app_notes' = JSON array của notes.
  static const String _storageKey = 'notes_app_notes';

  /// UUID generator cho note IDs.
  final _uuid = const Uuid();

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================
  //
  // Cubit constructor phải gọi super với initial state.
  //
  // Chú ý: KHÔNG gọi async operations trong constructor!
  // Thay vào đó, dùng init() method riêng.
  // ==========================================================================

  NotesCubit() : super(const NotesInitial());

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  //
  // [init] được gọi SAU khi Cubit được tạo.
  //
  // Tại sao tách ra khỏi constructor?
  // - Constructor không thể async
  // - Cần chờ SharedPreferences initialize
  // - Có thể xử lý errors riêng biệt
  // ==========================================================================

  /// Khởi tạo Cubit: Load SharedPreferences và load notes.
  ///
  /// Gọi method này trong BlocProvider create:
  /// ```dart
  /// BlocProvider(
  ///   create: (_) => NotesCubit()..init(),
  /// )
  /// ```
  Future<void> init() async {
    emit(const NotesLoading());

    try {
      // Lấy instance của SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Load notes từ storage
      await _loadNotes();
    } catch (e) {
      emit(NotesError('Không thể khởi tạo: $e'));
    }
  }

  // ==========================================================================
  // PRIVATE: LOAD NOTES
  // ==========================================================================
  //
  // Method private (bắt đầu bằng _) chỉ dùng nội bộ.
  //
  // Logic load:
  // 1. Đọc JSON string từ SharedPreferences
  // 2. Parse JSON → List<Map>
  // 3. Convert mỗi Map → Note object
  // 4. Sort theo updatedAt (mới nhất trước)
  // 5. Emit NotesLoaded state
  // ==========================================================================

  Future<void> _loadNotes() async {
    try {
      // Đọc string từ storage, null nếu chưa có
      final jsonString = _prefs.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        // Chưa có notes, emit empty list
        emit(NotesLoaded.all([]));
        return;
      }

      // Parse JSON string → List<dynamic>
      final jsonList = jsonDecode(jsonString) as List<dynamic>;

      // Convert mỗi item → Note, filter out failures
      final notes = jsonList
          .map((json) {
            try {
              return Note.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              // Corrupted item, skip
              debugPrint('Skip corrupted note: $e');
              return null;
            }
          })
          .whereType<Note>() // Filter out nulls
          .toList();

      // Sort: Mới nhất trước (updatedAt descending)
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      emit(NotesLoaded.all(notes));
    } catch (e) {
      emit(NotesError('Không thể load notes: $e'));
    }
  }

  // ==========================================================================
  // PRIVATE: SAVE NOTES
  // ==========================================================================
  //
  // Persist notes vào storage sau mỗi thay đổi.
  //
  // Logic:
  // 1. Convert List<Note> → List<Map>
  // 2. Encode → JSON string
  // 3. Save vào SharedPreferences
  // ==========================================================================

  Future<void> _saveNotes(List<Note> notes) async {
    try {
      // Convert notes → JSON maps
      final jsonList = notes.map((note) => note.toJson()).toList();

      // Encode → JSON string
      final jsonString = jsonEncode(jsonList);

      // Save vào SharedPreferences
      await _prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving notes: $e');
      // Không emit error state vì đây là background operation
      // User vẫn thấy UI bình thường, chỉ data có thể mất
    }
  }

  // ==========================================================================
  // PUBLIC: ADD NOTE
  // ==========================================================================
  //
  // Thêm note mới vào list.
  //
  // Parameters:
  // - [title]: Tiêu đề note
  // - [content]: Nội dung note
  // - [colorIndex]: Index màu (0-7)
  //
  // Flow:
  // 1. Validate: Không thêm note rỗng
  // 2. Tạo Note mới với UUID
  // 3. Thêm vào đầu list (mới nhất trước)
  // 4. Save vào storage
  // 5. Emit state mới
  // ==========================================================================

  /// Thêm note mới.
  ///
  /// Trả về Note đã tạo (để navigation có thể dùng).
  Future<Note?> addNote({
    required String title,
    required String content,
    int colorIndex = 0,
  }) async {
    final currentState = state;

    // Chỉ thêm khi đang ở trạng thái Loaded
    if (currentState is! NotesLoaded) {
      return null;
    }

    // Validate: Không thêm note rỗng
    if (title.trim().isEmpty && content.trim().isEmpty) {
      return null;
    }

    final now = DateTime.now();

    // Tạo note mới với UUID
    final newNote = Note(
      id: _uuid.v4(), // Generate unique ID
      title: title.trim(),
      content: content.trim(),
      colorIndex: colorIndex,
      createdAt: now,
      updatedAt: now,
    );

    // Thêm vào đầu list
    final updatedNotes = [newNote, ...currentState.allNotes];

    // Save vào storage
    await _saveNotes(updatedNotes);

    // Emit state mới
    // Nếu đang search, re-apply filter
    if (currentState.isSearching) {
      _emitWithSearch(updatedNotes, currentState.searchQuery);
    } else {
      emit(NotesLoaded.all(updatedNotes));
    }

    return newNote;
  }

  // ==========================================================================
  // PUBLIC: UPDATE NOTE
  // ==========================================================================
  //
  // Cập nhật note đã có.
  //
  // Logic:
  // 1. Tìm note trong list bằng ID
  // 2. Replace với note mới (đã update)
  // 3. Đưa lên đầu list (mới update = mới nhất)
  // 4. Save và emit
  // ==========================================================================

  /// Cập nhật note.
  ///
  /// [updatedNote] phải có ID trùng với note đang tồn tại.
  Future<void> updateNote(Note updatedNote) async {
    final currentState = state;

    if (currentState is! NotesLoaded) {
      return;
    }

    // Validate: Không lưu note rỗng
    if (updatedNote.isEmpty) {
      return;
    }

    // Update với timestamp mới
    final noteWithTimestamp = updatedNote.copyWith(updatedAt: DateTime.now());

    // Xóa note cũ, thêm note mới vào đầu
    final updatedNotes = [
      noteWithTimestamp,
      ...currentState.allNotes.where((note) => note.id != updatedNote.id),
    ];

    await _saveNotes(updatedNotes);

    if (currentState.isSearching) {
      _emitWithSearch(updatedNotes, currentState.searchQuery);
    } else {
      emit(NotesLoaded.all(updatedNotes));
    }
  }

  // ==========================================================================
  // PUBLIC: DELETE NOTE
  // ==========================================================================
  //
  // Xóa note khỏi list.
  //
  // Logic:
  // 1. Filter out note với ID cần xóa
  // 2. Save và emit
  //
  // Không cần confirm ở Cubit level - xử lý ở UI.
  // ==========================================================================

  /// Xóa note theo ID.
  Future<void> deleteNote(String id) async {
    final currentState = state;

    if (currentState is! NotesLoaded) {
      return;
    }

    // Filter out note cần xóa
    final updatedNotes = currentState.allNotes
        .where((note) => note.id != id)
        .toList();

    await _saveNotes(updatedNotes);

    if (currentState.isSearching) {
      _emitWithSearch(updatedNotes, currentState.searchQuery);
    } else {
      emit(NotesLoaded.all(updatedNotes));
    }
  }

  // ==========================================================================
  // PUBLIC: SEARCH NOTES
  // ==========================================================================
  //
  // Tìm kiếm notes theo title và content.
  //
  // Logic:
  // - Query rỗng: Hiện tất cả
  // - Có query: Filter notes có title/content chứa query
  // - Case-insensitive search
  // ==========================================================================

  /// Tìm kiếm notes.
  ///
  /// [query] là từ khóa tìm kiếm (case-insensitive).
  void searchNotes(String query) {
    final currentState = state;

    if (currentState is! NotesLoaded) {
      return;
    }

    _emitWithSearch(currentState.allNotes, query);
  }

  /// Clear search, hiện tất cả notes.
  void clearSearch() {
    final currentState = state;

    if (currentState is! NotesLoaded) {
      return;
    }

    emit(NotesLoaded.all(currentState.allNotes));
  }

  // ==========================================================================
  // PRIVATE: EMIT WITH SEARCH
  // ==========================================================================
  //
  // Helper method để emit state với search filter.
  //
  // Được dùng bởi:
  // - searchNotes()
  // - addNote() (khi đang search)
  // - updateNote() (khi đang search)
  // - deleteNote() (khi đang search)
  // ==========================================================================

  void _emitWithSearch(List<Note> allNotes, String query) {
    final trimmedQuery = query.trim().toLowerCase();

    if (trimmedQuery.isEmpty) {
      emit(NotesLoaded.all(allNotes));
      return;
    }

    // Filter notes chứa query trong title hoặc content
    final filteredNotes = allNotes.where((note) {
      final titleMatch = note.title.toLowerCase().contains(trimmedQuery);
      final contentMatch = note.content.toLowerCase().contains(trimmedQuery);
      return titleMatch || contentMatch;
    }).toList();

    emit(
      NotesLoaded(
        allNotes: allNotes,
        displayedNotes: filteredNotes,
        searchQuery: query,
      ),
    );
  }

  // ==========================================================================
  // PUBLIC: GET NOTE BY ID
  // ==========================================================================
  //
  // Utility method để lấy note theo ID.
  //
  // Dùng khi navigate đến edit screen với note ID.
  // ==========================================================================

  /// Lấy note theo ID.
  ///
  /// Trả về null nếu không tìm thấy.
  Note? getNoteById(String id) {
    final currentState = state;

    if (currentState is! NotesLoaded) {
      return null;
    }

    try {
      return currentState.allNotes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex02NotesCubit extends StatelessWidget {
  const Ex02NotesCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit()..init(),
      child: const _NotesCubitDemo(),
    );
  }
}

class _NotesCubitDemo extends StatelessWidget {
  const _NotesCubitDemo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex02: Notes Cubit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Explanation
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              '📚 File này demo NotesCubit với:\n'
              '• States: Initial, Loading, Loaded, Error\n'
              '• CRUD: Add, Update, Delete\n'
              '• Search functionality\n'
              '• Local storage với SharedPreferences',
            ),
          ),

          const Divider(),

          // State display
          Expanded(
            child: BlocBuilder<NotesCubit, NotesState>(
              builder: (context, state) {
                return switch (state) {
                  NotesInitial() => const Center(
                    child: Text('Chưa khởi tạo...'),
                  ),
                  NotesLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  NotesLoaded() => _NotesLoadedView(state: state),
                  NotesError() => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Lỗi: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<NotesCubit>().init(),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSampleNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addSampleNote(BuildContext context) {
    final cubit = context.read<NotesCubit>();
    final colors = [0, 1, 2, 3, 4, 5];
    final colorIndex = colors[DateTime.now().second % colors.length];

    cubit.addNote(
      title: 'Note ${DateTime.now().second}',
      content: 'Đây là note được tạo lúc ${DateTime.now()}',
      colorIndex: colorIndex,
    );
  }
}

class _NotesLoadedView extends StatelessWidget {
  final NotesLoaded state;

  const _NotesLoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(label: 'Tổng', value: '${state.allNotes.length}'),
              _StatChip(
                label: 'Hiển thị',
                value: '${state.displayedNotes.length}',
              ),
              if (state.isSearching)
                Chip(
                  label: Text('🔍 "${state.searchQuery}"'),
                  onDeleted: () => context.read<NotesCubit>().clearSearch(),
                ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => context.read<NotesCubit>().searchNotes(value),
          ),
        ),

        const SizedBox(height: 16),

        // Notes list
        Expanded(
          child: state.displayedNotes.isEmpty
              ? const Center(child: Text('Không có notes'))
              : ListView.builder(
                  itemCount: state.displayedNotes.length,
                  itemBuilder: (context, index) {
                    final note = state.displayedNotes[index];
                    return ListTile(
                      leading: Container(
                        width: 12,
                        height: 40,
                        decoration: BoxDecoration(
                          color: NoteColors.getColor(note.colorIndex),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      title: Text(
                        note.title.isEmpty ? '(Không tiêu đề)' : note.title,
                      ),
                      subtitle: Text(note.contentPreview),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            context.read<NotesCubit>().deleteNote(note.id),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
