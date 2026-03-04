/// ===========================================
/// BÀI TẬP 14: ENUM
/// ===========================================
///
/// Mục tiêu: Thành thạo Enum cơ bản và Enhanced Enum
///
/// Chạy file: 
///   dart run 01_dart_fundamentals/exercises/exercise_14_enum.dart

void main() {
  print('=== BÀI TẬP 14: ENUM ===\n');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 1: Enum cơ bản                    ║
  // ╚════════════════════════════════════════════╝

  print('--- Bài tập 1: Hệ thống đánh giá ---');

  // -TODO: Tạo enum Rating với các giá trị:
  // terrible, poor, average, good, excellent

  var myRating = Rating.good;
  print('Rating: ${myRating.name}');
  print('Index: ${myRating.index}');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 2: Enhanced Enum                  ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 2: Priority với mức độ và màu ---');

  // -TODO: Tạo enhanced enum Priority với:
  // - low: level 1, màu 'green'
  // - medium: level 2, màu 'yellow'
  // - high: level 3, màu 'orange'
  // - critical: level 4, màu 'red'

  var task1Priority = Priority.high;
  print('Priority: ${task1Priority.name}');
  print('Level: ${task1Priority.level}');
  print('Color: ${task1Priority.color}');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 3: Switch với Enum                ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 3: Xử lý trạng thái đơn hàng ---');

  // Enum đã có sẵn
  // enum PaymentStatus { pending, processing, completed, failed, refunded }

  // -TODO: Implement function getPaymentMessage(PaymentStatus status)
  // Trả về message tương ứng với mỗi status

  print(getPaymentMessage(PaymentStatus.pending));
  print(getPaymentMessage(PaymentStatus.completed));
  print(getPaymentMessage(PaymentStatus.failed));

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 4: Enum trong thực tế             ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 4: Task Manager ---');

  // -TODO: Tạo class Task với:
  // - String title
  // - Priority priority (dùng enum ở bài 2)
  // - TaskStatus status (tạo enum mới: todo, inProgress, done)

  var task = Task('Học Flutter', Priority.high, TaskStatus.inProgress);
  print('Task: ${task.title}');
  print('Priority: ${task.priority.name} (Level ${task.priority.level})');
  print('Status: ${task.status.name}');

  print('\n--- KIỂM TRA ---');
  print('👆 Implement code rồi uncomment để kiểm tra!');
}

// ============================================
// ENUMS CHO BÀI TẬP (uncomment khi cần)
// ============================================

// Bài 1
enum Rating { terrible, poor, average, good, excellent }

// Bài 2
enum Priority {
  low(1, 'green'),
  medium(2, 'yellow'),
  high(3, 'orange'),
  critical(4, 'red');

  final int level;
  final String color;

  const Priority(this.level, this.color);
}

// Bài 3
enum PaymentStatus { pending, processing, completed, failed, refunded }

// -TODO: Implement this function
String getPaymentMessage(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.pending:
      return '⏳ Đang chờ thanh toán';
    case PaymentStatus.processing:
      return '🔄 Đang xử lý';
    case PaymentStatus.completed:
      return '✅ Thanh toán thành công';
    case PaymentStatus.failed:
      return '❌ Thanh toán thất bại';
    case PaymentStatus.refunded:
      return '💰 Đã hoàn tiền';
  }
}

// Bài 4
enum TaskStatus { todo, inProgress, done }

class Task {
  String title;
  Priority priority;
  TaskStatus status;
  
  Task(this.title, this.priority, this.status);
}

// ============================================
// GỢI Ý
// ============================================
// 
// Bài 1: enum Rating { terrible, poor, average, good, excellent }
// 
// Bài 2: Xem comment ở trên
// 
// Bài 3: Dùng switch và return message cho mỗi case
// 
// Bài 4: 
//   - Tạo enum TaskStatus
//   - Tạo class Task với 3 properties
