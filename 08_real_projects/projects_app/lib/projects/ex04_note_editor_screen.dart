/// ============================================================================
/// EXERCISE 04: NOTE EDITOR SCREEN
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Xây dựng màn hình tạo/sửa note với đầy đủ tính năng.
///
/// 📝 BẠN SẼ HỌC:
/// - Form handling với TextEditingController
/// - Create vs Edit mode
/// - Color picker UI
/// - Auto-save pattern
/// - Unsaved changes warning
/// - Back gesture handling
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'ex01_note_model.dart';
import 'ex02_notes_cubit.dart';

// ============================================================================
// NOTE EDITOR SCREEN
// ============================================================================
///
/// Màn hình tạo mới hoặc chỉnh sửa note.
///
/// ## Modes:
/// - **Create mode**: noteId = null → Tạo note mới
/// - **Edit mode**: noteId có giá trị → Sửa note có sẵn
///
/// ## Features:
/// - Title và Content input
/// - Color picker
/// - Auto-save khi back
/// - Delete button (edit mode)
/// - Unsaved changes warning
///
// ============================================================================

class Ex04NoteEditorScreen extends StatefulWidget {
  /// ID của note cần edit.
  ///
  /// null = Create mode (tạo mới)
  /// non-null = Edit mode (sửa note có ID này)
  final String? noteId;

  const Ex04NoteEditorScreen({super.key, this.noteId});

  @override
  State<Ex04NoteEditorScreen> createState() => _Ex04NoteEditorScreenState();
}

class _Ex04NoteEditorScreenState extends State<Ex04NoteEditorScreen> {
  // ==========================================================================
  // CONTROLLERS
  // ==========================================================================
  //
  // TextEditingController quản lý input của TextField.
  //
  // Tại sao dùng late?
  // - Khởi tạo trong initState (cần context)
  // - Không thể khởi tạo ở declaration
  //
  // Phải dispose để tránh memory leak!
  // ==========================================================================

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  // ==========================================================================
  // STATE VARIABLES
  // ==========================================================================

  /// Màu được chọn (index 0-7).
  int _selectedColorIndex = 0;

  /// Đang ở Edit mode không?
  bool get _isEditMode => widget.noteId != null;

  /// Note gốc (chỉ có trong Edit mode).
  Note? _originalNote;

  /// Đã có thay đổi chưa?
  ///
  /// Dùng để warning khi user back mà chưa save.
  bool get _hasChanges {
    if (_isEditMode && _originalNote != null) {
      return _titleController.text != _originalNote!.title ||
          _contentController.text != _originalNote!.content ||
          _selectedColorIndex != _originalNote!.colorIndex;
    }
    // Create mode: có thay đổi nếu có nội dung
    return _titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty;
  }

  // ==========================================================================
  // LIFECYCLE
  // ==========================================================================

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// Khởi tạo controllers với data phù hợp.
  void _initializeControllers() {
    if (_isEditMode) {
      // Edit mode: Load note từ Cubit
      final cubit = context.read<NotesCubit>();
      final note = cubit.getNoteById(widget.noteId!);

      if (note != null) {
        _originalNote = note;
        _titleController = TextEditingController(text: note.title);
        _contentController = TextEditingController(text: note.content);
        _selectedColorIndex = note.colorIndex;
      } else {
        // Note không tồn tại, fallback về Create mode
        _titleController = TextEditingController();
        _contentController = TextEditingController();
      }
    } else {
      // Create mode: Controllers rỗng
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

  // ==========================================================================
  // SAVE ACTION
  // ==========================================================================
  //
  // Xử lý save note:
  // - Edit mode: update note existing
  // - Create mode: add new note
  //
  // Không save nếu cả title và content đều rỗng.
  // ==========================================================================

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Không save note rỗng
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final cubit = context.read<NotesCubit>();

    if (_isEditMode && _originalNote != null) {
      // Update existing note
      await cubit.updateNote(
        _originalNote!.copyWith(
          title: title,
          content: content,
          colorIndex: _selectedColorIndex,
        ),
      );
    } else {
      // Create new note
      await cubit.addNote(
        title: title,
        content: content,
        colorIndex: _selectedColorIndex,
      );
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? 'Đã cập nhật' : 'Đã tạo note mới'),
        ),
      );
    }
  }

  // ==========================================================================
  // DELETE ACTION
  // ==========================================================================
  //
  // Xóa note (chỉ có trong Edit mode).
  //
  // Luôn confirm trước khi xóa.
  // ==========================================================================

  Future<void> _deleteNote() async {
    if (!_isEditMode || _originalNote == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_forever, color: Colors.red, size: 48),
        title: const Text('Xóa ghi chú?'),
        content: const Text(
          'Bạn có chắc muốn xóa? Hành động này không thể hoàn tác.',
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

    if (confirmed == true && mounted) {
      context.read<NotesCubit>().deleteNote(_originalNote!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa ghi chú')));
    }
  }

  // ==========================================================================
  // BACK HANDLING
  // ==========================================================================
  //
  // PopScope thay thế WillPopScope (deprecated).
  //
  // Khi user back:
  // 1. Check có thay đổi chưa save không
  // 2. Nếu có → Show dialog confirm
  // 3. User chọn Save/Discard/Cancel
  // ==========================================================================

  Future<bool> _onWillPop() async {
    if (!_hasChanges) {
      return true; // No changes, allow pop
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lưu thay đổi?'),
        content: const Text('Bạn có muốn lưu các thay đổi trước khi thoát?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: const Text('Không lưu'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Tiếp tục sửa'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == 'save') {
      await _saveNote();
      return false; // _saveNote đã pop
    } else if (result == 'discard') {
      return true; // Allow pop without saving
    }
    return false; // Cancel, don't pop
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Handle pop manually
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        // Background màu theo note color
        backgroundColor: NoteColors.getColor(_selectedColorIndex),
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildColorPicker(),
      ),
    );
  }

  // ==========================================================================
  // APP BAR
  // ==========================================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_isEditMode ? 'Sửa ghi chú' : 'Tạo ghi chú'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // Delete button (only in edit mode)
        if (_isEditMode)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Xóa',
            onPressed: _deleteNote,
          ),
        // Save button
        IconButton(
          icon: const Icon(Icons.check),
          tooltip: 'Lưu',
          onPressed: _saveNote,
        ),
      ],
    );
  }

  // ==========================================================================
  // BODY: TITLE + CONTENT
  // ==========================================================================

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================================
          // TITLE FIELD
          // ==================================================================
          TextField(
            controller: _titleController,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'Tiêu đề',
              hintStyle: TextStyle(
                color: Colors.black38,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),

          // ==================================================================
          // METADATA (Edit mode only)
          // ==================================================================
          if (_isEditMode && _originalNote != null) ...[
            const SizedBox(height: 8),
            Text(
              'Cập nhật: ${DateFormat('dd/MM/yyyy HH:mm').format(_originalNote!.updatedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // ==================================================================
          // CONTENT FIELD
          // ==================================================================
          TextField(
            controller: _contentController,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Bắt đầu viết...',
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null, // Unlimited lines
            minLines: 20, // Minimum space
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // COLOR PICKER
  // ==========================================================================
  //
  // BottomNavigationBar chứa 8 nút màu.
  //
  // Khi chọn màu:
  // - Update _selectedColorIndex
  // - Background screen thay đổi theo
  // ==========================================================================

  Widget _buildColorPicker() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn màu:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              NoteColors.count,
              (index) => _ColorButton(
                color: NoteColors.colors[index],
                isSelected: _selectedColorIndex == index,
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// COLOR BUTTON
// ============================================================================
///
/// Nút chọn màu tròn.
///
/// Features:
/// - Hiển thị màu
/// - Border đậm khi được chọn
/// - Checkmark icon khi được chọn
///
// ============================================================================

class _ColorButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorButton({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 44 : 36,
        height: isSelected ? 44 : 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(128),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 20, color: Colors.black54)
            : null,
      ),
    );
  }
}

// ============================================================================
// DEMO WIDGET
// ============================================================================

class Ex04NoteEditorDemo extends StatelessWidget {
  const Ex04NoteEditorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit()..init(),
      child: const _DemoView(),
    );
  }
}

class _DemoView extends StatelessWidget {
  const _DemoView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex04: Note Editor'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📝 Note Editor Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Click button để mở editor'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<NotesCubit>(),
                      child: const Ex04NoteEditorScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tạo Note Mới'),
            ),
          ],
        ),
      ),
    );
  }
}
