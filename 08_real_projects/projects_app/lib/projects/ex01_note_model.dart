/// ============================================================================
/// EXERCISE 01: NOTE MODEL
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// Học cách thiết kế Data Model cho ứng dụng Flutter.
///
/// 📝 BẠN SẼ HỌC:
/// - Tạo class model với các thuộc tính cần thiết
/// - Sử dụng Equatable để so sánh objects
/// - Pattern copyWith để tạo bản sao với thay đổi
/// - Serialization với toJson/fromJson
/// - Tại sao cần immutable data
///
/// ============================================================================
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ============================================================================
// NOTE MODEL
// ============================================================================
///
/// [Note] là data model đại diện cho một ghi chú trong ứng dụng.
///
/// ## Tại sao cần Model?
///
/// Model giúp:
/// - Định nghĩa cấu trúc dữ liệu rõ ràng
/// - Type-safe: Compiler sẽ báo lỗi nếu dùng sai kiểu dữ liệu
/// - Dễ bảo trì: Thay đổi ở một chỗ, áp dụng toàn app
/// - Dễ test: Test từng thuộc tính riêng biệt
///
/// ## Tại sao extends Equatable?
///
/// [Equatable] giúp so sánh 2 objects bằng giá trị thay vì reference.
///
/// Không có Equatable:
/// ```dart
/// final note1 = Note(id: '1', title: 'Hello');
/// final note2 = Note(id: '1', title: 'Hello');
/// print(note1 == note2); // false (khác reference)
/// ```
///
/// Có Equatable:
/// ```dart
/// print(note1 == note2); // true (cùng giá trị)
/// ```
///
/// Điều này QUAN TRỌNG cho BLoC/Cubit vì:
/// - Cubit dùng == để check state có thay đổi không
/// - Nếu state mới == state cũ, UI không rebuild
/// - Equatable giúp so sánh chính xác
///
// ============================================================================
class Note extends Equatable {
  // ==========================================================================
  // PROPERTIES (Thuộc tính)
  // ==========================================================================
  //
  // Tất cả properties đều là [final] = IMMUTABLE (không thể thay đổi sau khi tạo)
  //
  // Tại sao dùng final?
  // - Tránh bugs do thay đổi data bất ngờ
  // - State management yêu cầu immutable data
  // - Dễ debug: Biết chắc data không bị modify
  // ==========================================================================

  /// Unique identifier cho note.
  ///
  /// Chúng ta dùng String thay vì int vì:
  /// - UUID có thể generate ở client (không cần server)
  /// - Không bị trùng khi sync nhiều devices
  /// - Dễ dàng tìm kiếm và reference
  final String id;

  /// Tiêu đề của note.
  ///
  /// Hiển thị ở list view và đầu note editor.
  final String title;

  /// Nội dung chi tiết của note.
  ///
  /// Có thể dài, nhiều dòng, hỗ trợ markdown (optional).
  final String content;

  /// Index của màu note trong color palette.
  ///
  /// Tại sao dùng int thay vì Color?
  /// - Color không serialize được thành JSON dễ dàng
  /// - int nhỏ gọn, dễ lưu trữ
  /// - Dùng index để lookup trong color palette
  ///
  /// Palette colors (xem [NoteColors] bên dưới):
  /// 0 = Yellow, 1 = Green, 2 = Blue, 3 = Purple,
  /// 4 = Orange, 5 = Pink, 6 = White, 7 = Grey
  final int colorIndex;

  /// Thời điểm note được tạo.
  ///
  /// Dùng để sort notes theo thời gian.
  final DateTime createdAt;

  /// Thời điểm note được cập nhật lần cuối.
  ///
  /// Cập nhật mỗi khi user edit note.
  final DateTime updatedAt;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================
  //
  // [const] constructor:
  // - Cho phép tạo compile-time constants
  // - Tiết kiệm memory nếu tạo nhiều objects giống nhau
  //
  // [required] keyword:
  // - Bắt buộc phải truyền parameter này
  // - Compiler sẽ báo lỗi nếu thiếu
  // ==========================================================================

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.colorIndex = 0, // Mặc định màu vàng (index 0)
    required this.createdAt,
    required this.updatedAt,
  });

  // ==========================================================================
  // FACTORY CONSTRUCTOR: empty()
  // ==========================================================================
  //
  // Factory constructor là gì?
  // - Không bắt buộc tạo instance mới (có thể return existing)
  // - Có thể chứa logic trước khi tạo object
  // - Ở đây dùng để tạo note trống với default values
  //
  // Khi nào dùng?
  // - Khi user tạo note mới, bắt đầu với note trống
  // - Cung cấp default values tiện lợi
  // ==========================================================================

  /// Tạo một note trống với id mới và timestamp hiện tại.
  ///
  /// Dùng khi user bấm nút "Tạo note mới".
  ///
  /// [id] được generate bằng UUID để đảm bảo unique.
  factory Note.empty({required String id}) {
    final now = DateTime.now();
    return Note(
      id: id,
      title: '',
      content: '',
      colorIndex: 0,
      createdAt: now,
      updatedAt: now,
    );
  }

  // ==========================================================================
  // COPY WITH METHOD
  // ==========================================================================
  //
  // [copyWith] là pattern QUAN TRỌNG trong Flutter/Dart.
  //
  // Vấn đề:
  // - Properties là final → không thể thay đổi
  // - Muốn "thay đổi" phải tạo object mới
  //
  // Giải pháp:
  // - copyWith tạo bản sao với một số properties thay đổi
  // - Properties không truyền sẽ giữ nguyên giá trị cũ
  //
  // Ví dụ:
  // ```dart
  // final note = Note(title: 'Hello', ...);
  // final updated = note.copyWith(title: 'Goodbye');
  // // updated.title = 'Goodbye', các props khác giữ nguyên
  // ```
  //
  // Tại sao dùng pattern này?
  // - Immutability: Original object không bị thay đổi
  // - Predictable: Biết chính xác data sẽ như thế nào
  // - Cubit/BLoC: emit(state.copyWith(...)) rất tiện
  // ==========================================================================

  /// Tạo bản sao của note với một số properties thay đổi.
  ///
  /// Parameters là optional, không truyền thì giữ nguyên.
  Note copyWith({
    String? id,
    String? title,
    String? content,
    int? colorIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      // Nếu id != null thì dùng id mới, ngược lại giữ this.id
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ==========================================================================
  // JSON SERIALIZATION
  // ==========================================================================
  //
  // Tại sao cần toJson/fromJson?
  //
  // 1. Lưu trữ local (SharedPreferences):
  //    - SharedPreferences chỉ lưu được String
  //    - Cần convert Note → JSON String để lưu
  //
  // 2. API communication:
  //    - Server gửi/nhận data dưới dạng JSON
  //    - Cần parse JSON → Note và ngược lại
  //
  // 3. Debugging:
  //    - Dễ dàng print object xem data
  //
  // Giải thích toJson():
  // - Return Map<String, dynamic>
  // - Keys là tên fields, values là giá trị
  // - DateTime phải convert sang String (ISO8601)
  // ==========================================================================

  /// Convert Note thành JSON Map.
  ///
  /// Dùng khi lưu vào SharedPreferences hoặc gửi lên API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'colorIndex': colorIndex,
      // DateTime.toIso8601String() → "2024-01-15T10:30:00.000"
      // Format chuẩn quốc tế, dễ parse lại
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Parse Note từ JSON Map.
  ///
  /// [json] là Map từ SharedPreferences hoặc API response.
  ///
  /// factory constructor phù hợp vì:
  /// - Có logic parse phức tạp (DateTime.parse)
  /// - Có thể throw exception nếu JSON invalid
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      // ?? 0: Nếu null thì default = 0 (màu vàng)
      colorIndex: json['colorIndex'] as int? ?? 0,
      // DateTime.parse() biến String → DateTime
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // ==========================================================================
  // EQUATABLE: props
  // ==========================================================================
  //
  // [props] là getter BẮT BUỘC khi extend Equatable.
  //
  // Cách Equatable hoạt động:
  // 1. So sánh từng item trong props list
  // 2. Nếu TẤT CẢ items bằng nhau → 2 objects bằng nhau
  //
  // Lưu ý:
  // - Phải include TẤT CẢ properties quan trọng
  // - Nếu thiếu, 2 objects có thể bằng nhau dù khác data
  //
  // Ví dụ thiếu props:
  // ```dart
  // @override
  // List<Object> get props => [id]; // Chỉ có id
  //
  // note1(id: '1', title: 'A') == note2(id: '1', title: 'B') // true! SAI!
  // ```
  // ==========================================================================

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    colorIndex,
    createdAt,
    updatedAt,
  ];

  // ==========================================================================
  // HELPER GETTERS
  // ==========================================================================
  //
  // Getters giúp access data một cách tiện lợi hơn.
  // UI không cần biết logic bên trong, chỉ cần gọi getter.
  // ==========================================================================

  /// Check note có rỗng không (chưa có nội dung).
  ///
  /// Dùng để quyết định có save hay không.
  bool get isEmpty => title.isEmpty && content.isEmpty;

  /// Check note có nội dung không.
  bool get isNotEmpty => !isEmpty;

  /// Preview ngắn của content (50 ký tự đầu).
  ///
  /// Dùng cho list view khi không muốn show full content.
  String get contentPreview {
    if (content.length <= 50) return content;
    return '${content.substring(0, 50)}...';
  }
}

// ============================================================================
// NOTE COLORS - Color Palette
// ============================================================================
//
// Tách colors ra class riêng vì:
// - Dễ maintain: Thay đổi màu ở 1 chỗ
// - Dễ access: NoteColors.colors[index]
// - Reusable: Dùng ở nhiều widgets
//
// Tại sao dùng abstract class?
// - Không tạo instance được (chỉ access static members)
// - Như một namespace cho constants
// - Giống pattern của Colors class trong Flutter
// ============================================================================

/// Color palette cho notes.
///
/// 8 màu pastel dễ nhìn, phù hợp làm background.
abstract class NoteColors {
  /// Danh sách 8 màu cho notes.
  ///
  /// Truy cập: NoteColors.colors[note.colorIndex]
  static const List<Color> colors = [
    Color(0xFFFFF59D), // 0: Yellow - Vàng pastel
    Color(0xFFC5E1A5), // 1: Green - Xanh lá pastel
    Color(0xFF90CAF9), // 2: Blue - Xanh dương pastel
    Color(0xFFCE93D8), // 3: Purple - Tím pastel
    Color(0xFFFFCC80), // 4: Orange - Cam pastel
    Color(0xFFF48FB1), // 5: Pink - Hồng pastel
    Color(0xFFFFFFFF), // 6: White - Trắng
    Color(0xFFCFD8DC), // 7: Grey - Xám nhẹ
  ];

  /// Lấy màu theo index, với fallback về Yellow nếu index invalid.
  ///
  /// An toàn hơn so với colors[index] trực tiếp vì:
  /// - Không throw RangeError
  /// - Luôn return màu hợp lệ
  static Color getColor(int index) {
    if (index < 0 || index >= colors.length) {
      return colors[0]; // Default: Yellow
    }
    return colors[index];
  }

  /// Số lượng màu trong palette.
  static int get count => colors.length;
}

// ============================================================================
// DEMO WIDGET
// ============================================================================
//
// Widget này demo cách sử dụng Note model.
// Bạn có thể chạy exercise này để xem kết quả.
// ============================================================================

class Ex01NoteModel extends StatelessWidget {
  const Ex01NoteModel({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo sample notes để demo
    final sampleNotes = [
      Note(
        id: '1',
        title: 'Học Flutter',
        content: 'Hôm nay học về Data Model và Equatable...',
        colorIndex: 2, // Blue
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Note(
        id: '2',
        title: 'Shopping List',
        content: '- Sữa\n- Bánh mì\n- Trứng\n- Rau xanh',
        colorIndex: 1, // Green
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      Note.empty(id: '3'), // Note trống
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex01: Note Model'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            '📝 Data Model Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'File này demo cách thiết kế Note model với:\n'
            '• Equatable cho object comparison\n'
            '• copyWith cho immutability\n'
            '• toJson/fromJson cho serialization',
          ),
          const Divider(height: 32),

          // Sample Notes
          const Text(
            '🗂️ Sample Notes:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...sampleNotes.map((note) => _NoteCard(note: note)),

          const Divider(height: 32),

          // Color Palette
          const Text(
            '🎨 Color Palette:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              NoteColors.count,
              (index) => Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: NoteColors.colors[index],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          index == 6
                              ? Colors.grey
                              : Colors.black87, // White cần text đậm
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Divider(height: 32),

          // Equatable Demo
          const Text(
            '⚖️ Equatable Demo:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _EquatableDemo(),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: NoteColors.getColor(note.colorIndex),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              note.title.isEmpty ? '(Không có tiêu đề)' : note.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Content preview
            Text(
              note.isEmpty ? '(Note trống)' : note.contentPreview,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),

            // Metadata
            Text(
              'ID: ${note.id} | Created: ${_formatDate(note.createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _EquatableDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime(2024, 1, 15, 10, 30);

    final note1 = Note(
      id: '1',
      title: 'Hello',
      content: 'World',
      createdAt: now,
      updatedAt: now,
    );

    final note2 = Note(
      id: '1',
      title: 'Hello',
      content: 'World',
      createdAt: now,
      updatedAt: now,
    );

    final note3 = note1.copyWith(title: 'Goodbye');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('note1 == note2: ${note1 == note2}'), // true
          const Text('(Cùng giá trị → bằng nhau)'),
          const SizedBox(height: 8),
          Text('note1 == note3: ${note1 == note3}'), // false
          const Text('(note3 có title khác → khác nhau)'),
          const SizedBox(height: 8),
          const Text(
            '💡 Equatable so sánh theo giá trị, không phải reference!',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
