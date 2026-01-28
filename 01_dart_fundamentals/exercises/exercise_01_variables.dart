/// ===========================================
/// BÀI TẬP 1: KHAI BÁO BIẾN
/// ===========================================
///
/// Hướng dẫn:
/// 1. Điền code vào các chỗ TODO
/// 2. Chạy file để kiểm tra kết quả:
///    dart run exercise_01_variables.dart

void main() {
  print('=== BÀI TẬP 1: KHAI BÁO BIẾN ===\n');

  // TODO 1: Khai báo biến tên của bạn (String)
  // Gợi ý: Dùng var hoặc String

  // TODO 2: Khai báo biến tuổi (int)

  // TODO 3: Khai báo biến có phải sinh viên không (bool)

  // TODO 4: Khai báo biến điểm trung bình (double?, có thể null)
  // Gợi ý: Dùng double? và gán giá trị null hoặc số thực

  // TODO 5: In ra tất cả các biến
  // print('Tên: $name');
  // print('Tuổi: $age');
  // print('Sinh viên: $isStudent');
  // print('Điểm TB: ${gpa ?? "Chưa có"}');

  print('\n=== KIỂM TRA ===');
  // Uncomment dòng dưới khi hoàn thành:
  // checkExercise1(name, age, isStudent, gpa);
}

// Function kiểm tra bài tập
void checkExercise1(String name, int age, bool isStudent, double? gpa) {
  int score = 0;

  if (name.isNotEmpty) {
    print('✅ Tên hợp lệ: $name');
    score++;
  } else {
    print('❌ Tên không được rỗng');
  }

  if (age > 0 && age < 150) {
    print('✅ Tuổi hợp lệ: $age');
    score++;
  } else {
    print('❌ Tuổi không hợp lệ');
  }

  print('✅ isStudent = $isStudent');
  score++;

  if (gpa == null || (gpa >= 0 && gpa <= 10)) {
    print('✅ GPA hợp lệ: ${gpa ?? "null"}');
    score++;
  } else {
    print('❌ GPA phải từ 0-10 hoặc null');
  }

  print('\n Kết quả: $score/4 điểm');
}
