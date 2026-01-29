/// ===========================================
/// BÀI TẬP 9: STREAM CƠ BẢN
/// ===========================================
///
/// Mục tiêu: Hiểu cách tạo và lắng nghe Stream
///
/// Yêu cầu:
/// Tạo Stream phát ra số từ 1 đến 10, mỗi giây 1 số
///
/// Chạy file: dart run exercise_09_stream.dart

void main() async {
  print('=== BÀI TẬP 9: STREAM CƠ BẢN ===\n');

  // ╔════════════════════════════════════════════╗
  // ║  GIẢI THÍCH STREAM CHO NGƯỜI MỚI           ║
  // ╚════════════════════════════════════════════╝

  print('''
📚 STREAM LÀ GÌ?

Hãy tưởng tượng bạn đang xem một bộ phim dài tập trên Netflix:

  Future = Tải 1 bộ phim TRỌN BỘ rồi mới xem
            → Phải đợi lâu, nhưng có hết ngay
  
  Stream = Xem từng tập một, mỗi tuần ra tập mới
            → Xem được ngay, nhưng phải chờ tập tiếp

Trong code:
  
  Future<int>  = Trả về 1 số
  Stream<int>  = Trả về NHIỀU số, lần lượt theo thời gian

─────────────────────────────────────────────────

📝 CÁCH TẠO STREAM:

1. Dùng từ khóa "async*" (có dấu sao)
2. Dùng "yield" để phát từng giá trị

Ví dụ:
  
  Stream<int> countUp() async* {
    yield 1;  // Phát số 1
    yield 2;  // Phát số 2
    yield 3;  // Phát số 3
  }

─────────────────────────────────────────────────

📝 CÁCH LẮNG NGHE STREAM:

  await for (var number in countUp()) {
    print(number);  // In ra: 1, 2, 3
  }

  Hoặc:
  
  countUp().listen((number) {
    print(number);  // In ra: 1, 2, 3
  });

''');

  // Uncomment sau khi implement
  print('⏳ Đang đếm từ 1 đến 10...\n');
  
  await for (var number in countToTen()) {
    print('Đã nhận: $number');
  }
  
  print('\n✅ Stream đã kết thúc!');

  print('👆 Hãy implement function countToTen() rồi uncomment code trên!');
}

// ============================================
// -TODO: VIẾT CODE CỦA BẠN Ở ĐÂY
// ============================================

Stream<int> countToTen() async* {
  // -TODO: Phát ra số từ 1 đến 10
  // Mỗi số cách nhau 1 giây
  for (int i = 1; i <= 10; i++) {
    await Future.delayed(Duration(seconds: 1)); // Đợi 1 giây
    yield i; // Phát số i vào Stream
  }
}

// ============================================
// GỢI Ý TỪNG BƯỚC
// ============================================
// 
// Stream<int> countToTen() async* {
//   for (int i = 1; i <= 10; i++) {
//     await Future.delayed(Duration(seconds: 1)); // Đợi 1 giây
//     yield i; // Phát số i vào Stream
//   }
// }
// 
// ─────────────────────────────────────────────
// 
// GIẢI THÍCH TỪNG DÒNG:
// 
// 1. async* = Function tạo Stream (không phải async thường!)
// 
// 2. for (int i = 1; i <= 10; i++)
//    = Lặp từ 1 đến 10
// 
// 3. await Future.delayed(Duration(seconds: 1))
//    = Đợi 1 giây trước khi phát số tiếp
// 
// 4. yield i
//    = "Phát" số i ra Stream
//    = Ai đang listen() sẽ nhận được số này
// 
// ─────────────────────────────────────────────
// 
// HÌNH DUNG:
// 
//   countToTen()
//       │
//       │ yield 1 ──► [1 giây] ──► yield 2 ──► [1 giây] ──► ...
//       │
//       ▼
//   await for / listen()
//       │
//       │ Nhận 1 ──► Nhận 2 ──► Nhận 3 ──► ... ──► Nhận 10 ──► Kết thúc
//       ▼

// ============================================
// BONUS: Thử nghiệm nếu bạn có thời gian
// ============================================
// 
// 1. Thử thay đổi delay thành 500ms
// 2. Thử đếm ngược từ 10 về 1
// 3. Thử phát ra các số chẵn từ 2 đến 20
