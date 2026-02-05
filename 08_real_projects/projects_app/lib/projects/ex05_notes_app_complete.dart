/// ============================================================================
/// EXERCISE 05: NOTES APP COMPLETE
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Ghép tất cả components thành ứng dụng Notes hoàn chỉnh.
///
/// 📝 BẠN SẼ HỌC:
/// - App initialization
/// - Dependency Injection với BlocProvider
/// - Navigation setup
/// - Theme configuration
/// - App lifecycle
///
/// 🔗 COMPONENTS ĐƯỢC DÙNG:
/// - ex01_note_model.dart: Note và NoteColors
/// - ex02_notes_cubit.dart: NotesCubit
/// - ex03_notes_list_screen.dart: NotesListScreen
/// - ex04_note_editor_screen.dart: NoteEditorScreen
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ex01_note_model.dart';
import 'ex02_notes_cubit.dart';
// import 'ex03_notes_list_screen.dart';
import 'ex04_note_editor_screen.dart';

// ============================================================================
// NOTES APP - MAIN WIDGET
// ============================================================================
///
/// Widget chính của Notes App.
///
/// ## Architecture:
///
/// ```
/// Ex05NotesAppComplete (Root)
///     │
///     └── BlocProvider<NotesCubit>  ← Cung cấp Cubit cho toàn app
///             │
///             └── MaterialApp
///                     │
///                     └── NotesListScreen (Home)
///                             │
///                             └── NoteEditorScreen (Navigator.push)
/// ```
///
/// ## Tại sao BlocProvider ở đây?
///
/// - **Single source of truth**: Chỉ có 1 NotesCubit cho toàn app
/// - **State preservation**: Navigate giữa screens không mất data
/// - **Easy access**: Mọi screen đều có thể `context.read<NotesCubit>()`
///
// ============================================================================

class Ex05NotesAppComplete extends StatelessWidget {
  const Ex05NotesAppComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ======================================================================
      // CREATE CUBIT
      // ======================================================================
      //
      // [create]: Hàm tạo Cubit instance.
      //
      // Cascade operator (..) cho phép:
      // 1. Tạo NotesCubit()
      // 2. Gọi .init() ngay sau đó
      // 3. Return Cubit instance (không phải return của init())
      //
      // Equivalent:
      // ```dart
      // final cubit = NotesCubit();
      // cubit.init();
      // return cubit;
      // ```
      //
      // Tại sao dùng cascade?
      // - Gọn hơn
      // - init() là async nhưng ta không cần await
      // - Cubit emit Loading state, UI sẽ show loading indicator
      // ======================================================================
      create: (_) => NotesCubit()..init(),

      // ======================================================================
      // MATERIAL APP
      // ======================================================================
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',

        // ====================================================================
        // THEME
        // ====================================================================
        //
        // Material 3 theme với seed color.
        //
        // ColorScheme.fromSeed tự động generate:
        // - primary, onPrimary
        // - secondary, onSecondary
        // - surface, onSurface
        // - error, onError
        // - etc.
        // ====================================================================
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            brightness: Brightness.light,
          ),
          // AppBar theme
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          // Card theme
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // FAB theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 4,
          ),
        ),

        // Home screen
        home: const _NotesHome(),
      ),
    );
  }
}

// ============================================================================
// NOTES HOME
// ============================================================================
///
/// Wrapper widget cho home screen.
///
/// Tại sao cần wrapper?
/// - Dễ thêm logic (splash screen, onboarding, etc.)
/// - Có thể switch giữa các screens
/// - Centralized navigation
///
// ============================================================================

class _NotesHome extends StatelessWidget {
  const _NotesHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Ghi Chú'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Info button
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Thông tin',
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: const _NotesBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditor(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Tạo mới'),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.note_alt, size: 48),
        title: const Text('Notes App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📝 Ứng dụng ghi chú đơn giản'),
            SizedBox(height: 8),
            Text('Features:'),
            Text('• Tạo, sửa, xóa ghi chú'),
            Text('• Tìm kiếm nhanh'),
            Text('• 8 màu sắc'),
            Text('• Lưu trữ local'),
            SizedBox(height: 16),
            Text(
              'Phase 8: Real Projects\nExercise 01-05',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditor(BuildContext context, String? noteId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<NotesCubit>(),
          child: Ex04NoteEditorScreen(noteId: noteId),
        ),
      ),
    );
  }
}

// ============================================================================
// NOTES BODY
// ============================================================================
///
/// Body chứa search và list notes.
///
// ============================================================================

class _NotesBody extends StatefulWidget {
  const _NotesBody();

  @override
  State<_NotesBody> createState() => _NotesBodyState();
}

class _NotesBodyState extends State<_NotesBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm ghi chú...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (_, value, __) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
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
            onChanged: (value) {
              context.read<NotesCubit>().searchNotes(value);
            },
          ),
        ),

        // Notes list
        Expanded(
          child: BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              return switch (state) {
                NotesInitial() => const Center(child: Text('Đang khởi tạo...')),
                NotesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                NotesLoaded() => _buildNotesList(context, state),
                NotesError() => _buildError(context, state),
              };
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotesList(BuildContext context, NotesLoaded state) {
    if (!state.hasNotes) {
      return _buildEmptyState(
        icon: Icons.note_add,
        title: 'Chưa có ghi chú nào',
        subtitle: 'Nhấn nút + để tạo ghi chú đầu tiên',
      );
    }

    if (state.isSearching && !state.hasResults) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'Không tìm thấy',
        subtitle: 'Không có ghi chú khớp với "${state.searchQuery}"',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: state.displayedNotes.length,
      itemBuilder: (context, index) {
        final note = state.displayedNotes[index];
        return _NoteCard(
          note: note,
          onTap: () => _navigateToEditor(context, note.id),
          onDelete: () => _confirmDelete(context, note),
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }

  void _navigateToEditor(BuildContext context, String noteId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<NotesCubit>(),
          child: Ex04NoteEditorScreen(noteId: noteId),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa ghi chú?'),
        content: Text(
          'Xóa "${note.title.isEmpty ? 'Không tiêu đề' : note.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<NotesCubit>().deleteNote(note.id);
    }
  }

  Widget _buildError(BuildContext context, NotesError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Lỗi: ${state.message}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<NotesCubit>().init(),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

// ============================================================================
// NOTE CARD
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
    return Card(
      color: NoteColors.getColor(note.colorIndex),
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              if (note.title.isNotEmpty && note.content.isNotEmpty)
                const SizedBox(height: 8),
              if (note.content.isNotEmpty)
                Expanded(
                  child: Text(
                    note.content,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    overflow: TextOverflow.fade,
                  ),
                ),
              const Spacer(),
              Text(
                '${note.updatedAt.day}/${note.updatedAt.month}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
