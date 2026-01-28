/// ===========================================
/// BÀI TẬP 2: NULL SAFETY
/// ===========================================
///
/// Mục tiêu: Hiểu và sử dụng Null Safety trong Dart
///
/// Chạy file:
///    dart run exercise_02_null_safety.dart

void main() {
  print('=== BÀI TẬP 2: NULL SAFETY ===\n');

  // Test cases
  print('Test 1: getDisplayName(null)');
  print('Kết quả: ${getDisplayName(null)}'); // Expected: Guest

  print('\nTest 2: getDisplayName("Dong")');
  print('Kết quả: ${getDisplayName("Dong")}'); // Expected: Dong

  print('\nTest 3: getDisplayName("")');
  print(
    'Kết quả: ${getDisplayName("")}',
  ); // Expected: Guest (chuỗi rỗng cũng là Guest)

  print('\n=== KIỂM TRA ===');
  checkExercise2();
}

/// TODO: Implement function này
///
/// Yêu cầu:
/// - Nếu nickname là null hoặc rỗng → trả về "Guest"
/// - Nếu nickname có giá trị → trả về nickname
///
/// Gợi ý: Sử dụng ?? hoặc if-else
String getDisplayName(String? nickname) {
  // TODO: Viết code ở đây

  return 'Guest'; // Placeholder, thay bằng logic thực
}

// Function kiểm tra
void checkExercise2() {
  int score = 0;

  if (getDisplayName(null) == 'Guest') {
    print('✅ Test null → Guest: PASSED');
    score++;
  } else {
    print('❌ Test null → Guest: FAILED');
  }

  if (getDisplayName('Dong') == 'Dong') {
    print('✅ Test "Dong" → Dong: PASSED');
    score++;
  } else {
    print('❌ Test "Dong" → Dong: FAILED');
  }

  if (getDisplayName('') == 'Guest') {
    print('✅ Test "" → Guest: PASSED');
    score++;
  } else {
    print('❌ Test "" → Guest: FAILED');
  }

  print('\n Kết quả: $score/3 điểm');

  if (score == 3) {
    print('🎉 Xuất sắc! Bạn đã hiểu Null Safety!');
  }
}
