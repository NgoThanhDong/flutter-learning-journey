/// ===========================================
/// BÀI TẬP 3: EXTENSION METHOD
/// ===========================================
///
/// Yêu cầu:
/// Tạo extension cho DateTime với method toVietnameseFormat()
/// trả về chuỗi định dạng "dd/MM/yyyy"
///
/// Ví dụ:
/// DateTime(2024, 1, 15).toVietnameseFormat() → "15/01/2024"
///
/// Chạy file: 
///   dart run 01_dart_fundamentals/exercises/exercise_06_extension.dart

void main() {
  print('=== BÀI TẬP 3: EXTENSION METHOD ===\n');

  // Test các ngày khác nhau
  var date1 = DateTime(2024, 1, 15);
  var date2 = DateTime(2024, 12, 5);
  var date3 = DateTime.now();

  // Uncomment sau khi implement xong

  print('Ngày 1: ${date1.toVietnameseFormat()}');
  // Expected: 15/01/2024
  print('Ngày 1 có phải hôm nay không: ${date1.isToday}');
  print('Tên ngày trong tuần: ${date1.weekdayName}'); 
  print('Ngày 1: ${date1.toFullVietnameseFormat()}');

  print('\nNgày 2: ${date2.toVietnameseFormat()}');
  // Expected: 05/12/2024
  print('Ngày 2 có phải hôm nay không: ${date2.isToday}');
  print('Tên ngày trong tuần: ${date2.weekdayName}'); 
  print('Ngày 2: ${date2.toFullVietnameseFormat()}');

  print('\nHôm nay: ${date3.toVietnameseFormat()}');
  print('Hôm nay có phải hôm nay không: ${date3.isToday}');
  print('Tên ngày trong tuần: ${date3.weekdayName}'); 
  print('Ngày 3: ${date3.toFullVietnameseFormat()}');

  print('\n--- KIỂM TRA ---');
  checkExercise();

  print('👆 Hãy implement extension rồi uncomment code trên!');
}

// ============================================
// -TODO: VIẾT CODE CỦA BẠN Ở ĐÂY
// ============================================

// Extension method cho DateTime
extension DateTimeExtension on DateTime {
  String toVietnameseFormat() {
    // -TODO: Trả về "dd/MM/yyyy"
    // Gợi ý:
    // - day, month, year là properties của DateTime
    // - Dùng padLeft(2, '0') để thêm số 0 phía trước nếu cần
    //   Ví dụ: "5".padLeft(2, '0') → "05"
    String dd = day.toString().padLeft(2, '0');
    String mm = month.toString().padLeft(2, '0');
    String yyyy = year.toString();
    return '$dd/$mm/$yyyy';
  }
}

// ============================================
// GỢI Ý CHI TIẾT
// ============================================
//
// extension DateTimeExtension on DateTime {
//   String toVietnameseFormat() {
//     String dd = day.toString().padLeft(2, '0');
//     String mm = month.toString().padLeft(2, '0');
//     String yyyy = year.toString();
//     return '$dd/$mm/$yyyy';
//   }
// }
//
// Giải thích:
// - day.toString() chuyển số thành chuỗi: 5 → "5"
// - padLeft(2, '0') thêm '0' bên trái cho đủ 2 ký tự: "5" → "05"
// - Ghép lại theo format dd/MM/yyyy

// ============================================
// BONUS: Thêm các extension hữu ích khác
// ============================================

extension DateTimeExtensionBonus on DateTime {
  // Kiểm tra có phải hôm nay không
  bool get isToday {
    var now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Tên ngày trong tuần
  String get weekdayName {
    const days = ['', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
    return days[weekday]; // weekday là property của DateTime, trả về số từ 1-7
  }

  // Format đầy đủ: "Thứ 3, 15/01/2024"
  String toFullVietnameseFormat() {
    return '$weekdayName, ${toVietnameseFormat()}';
  }
}

// ============================================
// HÀM KIỂM TRA
// ============================================

void checkExercise() {
  int score = 0;

  try {
    var d1 = DateTime(2024, 1, 15);
    if (d1.toVietnameseFormat() == '15/01/2024') {
      print('✅ Test 1 (15/01/2024): PASSED');
      score++;
    } else {
      print('❌ Test 1: Expected "15/01/2024", got "${d1.toVietnameseFormat()}"');
    }

    var d2 = DateTime(2024, 12, 5);
    if (d2.toVietnameseFormat() == '05/12/2024') {
      print('✅ Test 2 (05/12/2024): PASSED');
      score++;
    } else {
      print('❌ Test 2: Expected "05/12/2024", got "${d2.toVietnameseFormat()}"');
    }

    var d3 = DateTime(2000, 6, 30);
    if (d3.toVietnameseFormat() == '30/06/2000') {
      print('✅ Test 3 (30/06/2000): PASSED');
      score++;
    }

    print('\n🎯 Kết quả: $score/3 điểm');
    if (score == 3) {
      print('🎉 Xuất sắc! Extension hoạt động chính xác!');
    }
  } catch (e) {
    print('❌ Lỗi: $e');
  }
}
