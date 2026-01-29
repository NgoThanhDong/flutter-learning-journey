/// ===========================================
/// BÀI TẬP 11: THAO TÁC VỚI LIST
/// ===========================================
///
/// Mục tiêu: Thành thạo các thao tác cơ bản với List
///
/// Chạy file: dart run exercise_11_list.dart

void main() {
  print('=== BÀI TẬP 11: THAO TÁC VỚI LIST ===\n');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 1: Tạo và thao tác List           ║
  // ╚════════════════════════════════════════════╝

  print('--- Bài tập 1: Tạo List số nguyên tố < 20 ---');
  // -TODO: Tạo List chứa các số nguyên tố nhỏ hơn 20
  // Số nguyên tố: 2, 3, 5, 7, 11, 13, 17, 19

  List<int> primes = [2, 3, 5, 7, 11, 13, 17, 19];
  print('Số nguyên tố: $primes');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 2: Thêm, xóa phần tử              ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 2: Quản lý danh sách sinh viên ---');
  var students = ['An', 'Bình', 'Cường'];
  print('Ban đầu: $students');

  // -TODO:
  // 1. Thêm 'Dũng' vào cuối danh sách
  // 2. Thêm 'Ánh' vào đầu danh sách (vị trí 0)
  // 3. Xóa 'Bình' khỏi danh sách
  // 4. In kết quả

  students.add('Dũng');
  students.insert(0, 'Ánh');
  students.remove('Bình');
  print('Sau khi chỉnh sửa: $students');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 3: Tìm kiếm trong List            ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 3: Tìm kiếm ---');
  var products = [
    {'name': 'Laptop', 'price': 15000000},
    {'name': 'Phone', 'price': 8000000},
    {'name': 'Tablet', 'price': 10000000},
    {'name': 'Watch', 'price': 5000000},
  ];

  // -TODO: Tìm sản phẩm có giá > 9000000
  // Dùng where() để lọc

  var expensive = products.where((p) => p['price'] as int > 9000000).toList();
  print('Sản phẩm giá > 9 triệu: $expensive');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 4: Sắp xếp List                   ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 4: Sắp xếp ---');
  var scores = [85, 92, 78, 95, 88, 70];
  print('Điểm gốc: $scores');

  // -TODO:
  // 1. Sắp xếp tăng dần
  // 2. In 3 điểm cao nhất (dùng reversed và take)

  scores.sort();
  print('Tăng dần: $scores');
  var top3 = scores.reversed.take(3).toList();
  print('Top 3: $top3');

  print('\n--- KIỂM TRA ---');
  // Uncomment để chạy kiểm tra
  checkExercises();
}

void checkExercises() {
  int score = 0;

  // Test 1
  var primes = [2, 3, 5, 7, 11, 13, 17, 19];
  if (primes.length == 8 && primes.first == 2 && primes.last == 19) {
    print('✅ Bài 1: PASSED');
    score++;
  }

  // Test 2
  var students = ['An', 'Bình', 'Cường'];
  students.add('Dũng');
  students.insert(0, 'Ánh');
  students.remove('Bình');
  if (students[0] == 'Ánh' &&
      students.contains('Dũng') &&
      !students.contains('Bình')) {
    print('✅ Bài 2: PASSED');
    score++;
  }

  print('\n🎯 Kết quả: $score/2 bài đúng');
}

// ============================================
// GỢI Ý
// ============================================
// 
// Bài 1: List<int> primes = [2, 3, 5, 7, 11, 13, 17, 19];
// 
// Bài 2:
//   students.add('Dũng');
//   students.insert(0, 'Ánh');
//   students.remove('Bình');
// 
// Bài 3:
//   var expensive = products.where((p) => p['price'] as int > 9000000).toList();
// 
// Bài 4:
//   scores.sort();
//   var top3 = scores.reversed.take(3).toList();
