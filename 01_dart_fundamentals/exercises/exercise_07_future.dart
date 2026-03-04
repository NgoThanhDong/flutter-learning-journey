/// ===========================================
/// BÀI TẬP 7: FUTURE CƠ BẢN
/// ===========================================
///
/// Mục tiêu: Hiểu cách tạo và sử dụng Future
///
/// Yêu cầu:
/// Viết function delayedHello(String name) trả về Future<String>
/// sau 2 giây trả về chuỗi "Xin chào, [name]!"
///
/// Chạy file: 
///   dart run 01_dart_fundamentals/exercises/exercise_07_future.dart

void main() async {
  print('=== BÀI TẬP 7: FUTURE CƠ BẢN ===\n');

  print('⏳ Đang chờ...');

  // Uncomment sau khi implement
  // Cách 1: Dùng Future.delayed
  var message = await delayedHello('Dong');
  print(message);

  // Cách 2: Dùng async/await
  message = await delayedHello2('DongNT');
  print(message);

  print('\n--- KIỂM TRA ---');
  await checkExercise();

  print('\n👆 Hãy implement function delayedHello() rồi uncomment code trên!');
}

// ============================================
// -TODO: VIẾT CODE CỦA BẠN Ở ĐÂY
// ============================================

// Cách 1: Dùng Future.delayed
Future<String> delayedHello(String name) {
  // -TODO: Trả về Future sau 2 giây
  // với nội dung "Xin chào, [name]!"
  return Future.delayed(Duration(seconds: 2), () {
    return 'Xin chào, $name!';
  });
}

// Cách 2: Dùng async/await
Future<String> delayedHello2(String name) async {
  await Future.delayed(Duration(seconds: 2));
  return 'Xin chào, $name!';
}

// ============================================
// GỢI Ý TỪNG BƯỚC
// ============================================
//
// Cách 1: Dùng Future.delayed
//
// Future<String> delayedHello(String name) {
//   return Future.delayed(Duration(seconds: 2), () {
//     return 'Xin chào, $name!';
//   });
// }
//
// Giải thích:
// - Future.delayed(Duration, callback): Đợi Duration rồi gọi callback
// - Duration(seconds: 2): Đợi 2 giây
// - () { return 'Xin chào, $name!'; }: Callback trả về String
//
// ─────────────────────────────────────────────
//
// Cách 2: Dùng async/await
//
// Future<String> delayedHello(String name) async {
//   await Future.delayed(Duration(seconds: 2));
//   return 'Xin chào, $name!';
// }
//
// Giải thích:
// - async: Đánh dấu function là bất đồng bộ
// - await: Đợi Future hoàn thành rồi mới chạy tiếp
// - return: Tự động wrap trong Future<String>

// ============================================
// HÀM KIỂM TRA
// ============================================

Future<void> checkExercise() async {
  print('Test 1: delayedHello("Test")');
  var start = DateTime.now();

  var result = await delayedHello('Test');

  // Tính thời gian đợi
  var elapsed = DateTime.now().difference(start).inMilliseconds;

  // Kiểm tra thời gian đợi
  if (elapsed >= 1900 && elapsed <= 2500) {
    print('✅ Thời gian đợi: ${elapsed}ms (đúng ~2 giây)');
  } else {
    print('❌ Thời gian đợi: ${elapsed}ms (phải ~2000ms)');
  }

  if (result == 'Xin chào, Test!') {
    print('✅ Nội dung: "$result"');
  } else {
    print('❌ Nội dung sai. Expected: "Xin chào, Test!"');
  }
}
