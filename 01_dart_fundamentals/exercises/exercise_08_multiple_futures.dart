/// ===========================================
/// BÀI TẬP 8: XỬ LÝ NHIỀU FUTURE
/// ===========================================
///
/// Mục tiêu: Hiểu cách chạy nhiều Future song song
///
/// Yêu cầu:
/// Viết function fetchAllUsers() gọi đồng thời 3 "API" giả lập
/// và trả về danh sách users
///
/// Chạy file: dart run exercise_08_multiple_futures.dart

void main() async {
  print('=== BÀI TẬP 8: NHIỀU FUTURE SONG SONG ===\n');

  // Demo các API giả lập
  print('--- Demo API giả lập ---');
  print('fetchUser(1) sẽ trả về User 1 sau 1 giây');
  print('fetchUser(2) sẽ trả về User 2 sau 2 giây');
  print('fetchUser(3) sẽ trả về User 3 sau 1.5 giây\n');

  // Uncomment sau khi implement
  // print('⏳ Đang fetch tất cả users...');
  // var start = DateTime.now();
  //
  // var users = await fetchAllUsers();
  //
  // var elapsed = DateTime.now().difference(start).inMilliseconds;
  //
  // print('✅ Đã fetch xong trong ${elapsed}ms');
  // print('Danh sách: $users');
  //
  // print('\n--- KIỂM TRA ---');
  // if (elapsed < 2500) {
  //   print('✅ Chạy song song! (${elapsed}ms < 4500ms tuần tự)');
  // } else {
  //   print('❌ Có vẻ chạy tuần tự. Hãy dùng Future.wait!');
  // }

  print('\n👆 Hãy implement function fetchAllUsers() rồi uncomment code trên!');
}

// ============================================
// API GIẢ LẬP (Đã viết sẵn, không cần sửa)
// ============================================

Future<String> fetchUser(int id) async {
  // Mỗi user có thời gian khác nhau
  var delays = {1: 1000, 2: 2000, 3: 1500};
  await Future.delayed(Duration(milliseconds: delays[id] ?? 1000));
  return 'User $id';
}

// ============================================
// TODO: VIẾT CODE CỦA BẠN Ở ĐÂY
// ============================================

// Future<List<String>> fetchAllUsers() async {
//   // TODO: Gọi fetchUser(1), fetchUser(2), fetchUser(3) SONG SONG
//   // và trả về List<String> chứa tất cả users
// }

// ============================================
// GỢI Ý TỪNG BƯỚC
// ============================================
// 
// ❌ SAI - Chạy tuần tự (chậm):
// 
// Future<List<String>> fetchAllUsers() async {
//   var user1 = await fetchUser(1);  // Đợi 1 giây
//   var user2 = await fetchUser(2);  // Đợi 2 giây
//   var user3 = await fetchUser(3);  // Đợi 1.5 giây
//   return [user1, user2, user3];    // Tổng: 4.5 giây!
// }
// 
// ─────────────────────────────────────────────
// 
// ✅ ĐÚNG - Chạy song song (nhanh):
// 
// Future<List<String>> fetchAllUsers() async {
//   var results = await Future.wait([
//     fetchUser(1),  // ─┐
//     fetchUser(2),  // ─┼─ Chạy cùng lúc!
//     fetchUser(3),  // ─┘
//   ]);
//   return results; // Tổng: 2 giây (max của 3 cái)
// }
// 
// ─────────────────────────────────────────────
// 
// GIẢI THÍCH Future.wait:
// 
// Future.wait([future1, future2, future3])
// 
// 1. Bắt đầu TẤT CẢ futures cùng lúc
// 2. Đợi TẤT CẢ hoàn thành
// 3. Trả về List<T> theo thứ tự ban đầu
// 
// Ví dụ timeline:
// 
// fetchUser(1): |███░░░░░░░| 1 giây
// fetchUser(2): |██████░░░░| 2 giây
// fetchUser(3): |█████░░░░░| 1.5 giây
//               └──────────┘
//                 ^ Tổng 2 giây (max)
