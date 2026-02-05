/// ============================================================================
/// EXERCISE 03: NOTES LIST SCREEN
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Xây dựng màn hình danh sách notes với:
/// - StaggeredGridView layout
/// - Search bar
/// - Empty state handling
/// - Navigation đến editor
///
/// 📝 BẠN SẼ HỌC:
/// - StaggeredGridView cho layout đẹp
/// - BlocBuilder vs BlocListener
/// - Search với debounce
/// - Responsive design
/// - Empty state pattern
///
/// ============================================================================
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import 'ex01_note_model.dart';
import 'ex02_notes_cubit.dart';

// ============================================================================
// NOTES LIST SCREEN
// ============================================================================
///
/// Màn hình chính hiển thị danh sách notes.
///
/// ## Features:
/// - Search bar với debounce
/// - Grid layout với StaggeredGridView
/// - Tap để edit, long press để xóa
/// - Empty state khi không có notes
/// - FAB để tạo note mới
///
// ============================================================================

class Ex03NotesListScreen extends StatelessWidget {
  const Ex03NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider đã được setup ở bên ngoài (Ex05)
    // Ở đây chỉ cần BlocBuilder để lắng nghe state
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Hiển thị số notes trong title
        actions: [
          BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              if (state is NotesLoaded) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text('${state.allNotes.length} notes'),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: const _NotesListBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditor(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Tạo mới'),
      ),
    );
  }

  /// Navigate đến editor screen.
  ///
  /// [noteId] null = tạo mới, có giá trị = edit.
  static void _navigateToEditor(BuildContext context, String? noteId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<NotesCubit>(),
          child: _NoteEditorScreen(noteId: noteId),
        ),
      ),
    );
  }
}

// ============================================================================
// NOTES LIST BODY
// ============================================================================
///
/// Body chứa search bar và grid notes.
///
/// Tách ra widget riêng để:
/// - Dễ quản lý state (TextEditingController)
/// - Tránh rebuild toàn bộ screen
///
// ============================================================================

class _NotesListBody extends StatefulWidget {
  const _NotesListBody();

  @override
  State<_NotesListBody> createState() => _NotesListBodyState();
}

class _NotesListBodyState extends State<_NotesListBody> {
  // ==========================================================================
  // SEARCH CONTROLLER
  // ==========================================================================
  //
  // TextEditingController để quản lý input search.
  //
  // Phải dispose khi widget bị destroy để tránh memory leak.
  // ==========================================================================

  final _searchController = TextEditingController();

  // ==========================================================================
  // DEBOUNCE TIMER
  // ==========================================================================
  //
  // Debounce: Chờ user dừng gõ mới search.
  //
  // Tại sao cần?
  // - Không search mỗi ký tự (tốn resource)
  // - User thường gõ liên tục, chờ họ dừng mới search
  // - Trải nghiệm mượt hơn
  //
  // Cách hoạt động:
  // 1. User gõ ký tự → Cancel timer cũ (nếu có)
  // 2. Tạo timer mới 300ms
  // 3. Nếu user không gõ thêm → Timer fire → Search
  // 4. Nếu user gõ tiếp → Quay lại bước 1
  // ==========================================================================

  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Xử lý search với debounce.
  void _onSearchChanged(String query) {
    // Cancel timer cũ
    _debounce?.cancel();

    // Tạo timer mới
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<NotesCubit>().searchNotes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==================================================================
        // SEARCH BAR
        // ==================================================================
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm notes...',
              prefixIcon: const Icon(Icons.search),
              // Clear button khi có text
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (_, value, __) {
                  if (value.text.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<NotesCubit>().clearSearch();
                    },
                  );
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        // ==================================================================
        // NOTES GRID
        // ==================================================================
        Expanded(
          child: BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              return switch (state) {
                NotesInitial() => const Center(child: Text('Đang khởi tạo...')),
                NotesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                NotesLoaded() => _buildNotesGrid(context, state),
                NotesError() => _buildErrorView(context, state),
              };
            },
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // BUILD NOTES GRID
  // ==========================================================================
  //
  // StaggeredGridView cho phép:
  // - Các items có height khác nhau
  // - Layout tự động fill gaps
  // - Đẹp như Pinterest, Google Keep
  //
  // crossAxisCount: Số cột
  // mainAxisSpacing/crossAxisSpacing: Khoảng cách giữa items
  // ==========================================================================

  Widget _buildNotesGrid(BuildContext context, NotesLoaded state) {
    // Empty state: Không có notes nào
    if (!state.hasNotes) {
      return _EmptyState(
        icon: Icons.note_add,
        title: 'Chưa có ghi chú nào',
        subtitle: 'Nhấn nút + để tạo ghi chú đầu tiên',
      );
    }

    // Empty search results
    if (state.isSearching && !state.hasResults) {
      return _EmptyState(
        icon: Icons.search_off,
        title: 'Không tìm thấy',
        subtitle: 'Không có ghi chú nào khớp với "${state.searchQuery}"',
      );
    }

    // Grid view
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      crossAxisCount: _getCrossAxisCount(context),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: state.displayedNotes.length,
      itemBuilder: (context, index) {
        final note = state.displayedNotes[index];
        return _NoteCard(
          note: note,
          onTap: () => Ex03NotesListScreen._navigateToEditor(context, note.id),
          onDelete: () => _confirmDelete(context, note),
        );
      },
    );
  }

  /// Tính số cột dựa trên screen width.
  ///
  /// Responsive design:
  /// - Mobile: 2 cột
  /// - Tablet: 3 cột
  /// - Desktop: 4 cột
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }

  Widget _buildErrorView(BuildContext context, NotesError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Lỗi: ${state.message}'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<NotesCubit>().init(),
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CONFIRM DELETE DIALOG
  // ==========================================================================
  //
  // Luôn confirm trước khi xóa để tránh mất data.
  //
  // showDialog trả về Future<bool?> để biết user chọn gì.
  // ==========================================================================

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa ghi chú?'),
        content: Text(
          'Bạn có chắc muốn xóa "${note.title.isEmpty ? 'Không tiêu đề' : note.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<NotesCubit>().deleteNote(note.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa ghi chú')));
    }
  }
}

// ============================================================================
// NOTE CARD
// ============================================================================
///
/// Card hiển thị 1 note trong grid.
///
/// Features:
/// - Background color theo note color
/// - Title và content preview
/// - Date badge
/// - Tap gesture
///
// ============================================================================

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Định dạng ngày
    final dateFormat = DateFormat('dd/MM');
    final formattedDate = dateFormat.format(note.updatedAt);

    return Card(
      // Màu background theo note color
      color: NoteColors.getColor(note.colorIndex),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              if (note.title.isNotEmpty)
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              // Spacing
              if (note.title.isNotEmpty && note.content.isNotEmpty)
                const SizedBox(height: 8),

              // Content
              if (note.content.isNotEmpty)
                Text(
                  note.content,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),

              // Date
              const SizedBox(height: 12),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================
///
/// Widget hiển thị khi không có data.
///
/// Pattern phổ biến trong apps:
/// - Icon to
/// - Title
/// - Subtitle với hướng dẫn
///
// ============================================================================

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// NOTE EDITOR SCREEN (Simplified for this exercise)
// ============================================================================
///
/// Màn hình tạo/sửa note.
///
/// Chi tiết đầy đủ ở Ex04.
///
// ============================================================================

class _NoteEditorScreen extends StatefulWidget {
  final String? noteId;

  const _NoteEditorScreen({this.noteId});

  @override
  State<_NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<_NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  int _selectedColor = 0;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<NotesCubit>();

    if (widget.noteId != null) {
      final note = cubit.getNoteById(widget.noteId!);
      if (note != null) {
        _isEditing = true;
        _titleController = TextEditingController(text: note.title);
        _contentController = TextEditingController(text: note.content);
        _selectedColor = note.colorIndex;
      } else {
        _titleController = TextEditingController();
        _contentController = TextEditingController();
      }
    } else {
      _titleController = TextEditingController();
      _contentController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final cubit = context.read<NotesCubit>();

    if (_isEditing && widget.noteId != null) {
      final existingNote = cubit.getNoteById(widget.noteId!);
      if (existingNote != null) {
        cubit.updateNote(
          existingNote.copyWith(
            title: _titleController.text,
            content: _contentController.text,
            colorIndex: _selectedColor,
          ),
        );
      }
    } else {
      cubit.addNote(
        title: _titleController.text,
        content: _contentController.text,
        colorIndex: _selectedColor,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoteColors.getColor(_selectedColor),
      appBar: AppBar(
        title: Text(_isEditing ? 'Sửa Note' : 'Tạo Note'),
        backgroundColor: Colors.transparent,
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Tiêu đề',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Content
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Nội dung...',
                border: InputBorder.none,
              ),
              maxLines: null,
              minLines: 10,
            ),

            const SizedBox(height: 24),

            // Color picker
            Wrap(
              spacing: 8,
              children: List.generate(
                NoteColors.count,
                (index) => GestureDetector(
                  onTap: () => setState(() => _selectedColor = index),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: NoteColors.colors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == index
                            ? Colors.black
                            : Colors.grey.shade300,
                        width: _selectedColor == index ? 3 : 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
