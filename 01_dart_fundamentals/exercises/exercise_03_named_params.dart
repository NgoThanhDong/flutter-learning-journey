/// ===========================================
/// BÀI TẬP 3: NAMED PARAMETERS
/// ===========================================
/// 
/// Mục tiêu: Thành thạo Named Parameters trong Dart
/// 
/// Chạy file:
///    dart run exercise_03_named_params.dart

void main() {
  print('=== BÀI TẬP 3: NAMED PARAMETERS ===\n');
  
  // Test cases - Uncomment sau khi implement
  
  // print('Test 1: Chỉ có name');
  // createProfile(name: 'Dong');
  // Expected output: Profile: Dong, 18, email: không có
  
  // print('\nTest 2: name + age');
  // createProfile(name: 'An', age: 25);
  // Expected output: Profile: An, 25, email: không có
  
  // print('\nTest 3: Đầy đủ thông tin');
  // createProfile(name: 'Minh', age: 30, email: 'minh@email.com');
  // Expected output: Profile: Minh, 30, email: minh@email.com
  
  print('\n=== KIỂM TRA ===');
  // Uncomment sau khi implement:
  // checkExercise3();
}

/// TODO: Implement function này
/// 
/// Yêu cầu:
/// - name: required (bắt buộc)
/// - age: optional, default = 18
/// - email: optional, nullable (String?)
/// 
/// Output format:
/// "Profile: [name], [age], email: [email hoặc 'không có']"
void createProfile({
  // TODO: Thêm parameters ở đây
  // required String name,
  // int age = 18,
  // String? email,
}) {
  // TODO: Viết code ở đây
  // print('Profile: $name, $age, email: ${email ?? "không có"}');
}

// Function kiểm tra
void checkExercise3() {
  print('Đang kiểm tra...\n');
  
  // Để kiểm tra, bạn cần chạy các test case ở main()
  // và so sánh output với expected output
  
  print('💡 Gợi ý kiểm tra:');
  print('1. createProfile(name: "Test") → age phải là 18');
  print('2. createProfile(name: "Test", age: 25) → age phải là 25');
  print('3. email: null → hiển thị "không có"');
  print('4. email: "test@test.com" → hiển thị email');
}

// ============================================
// 💡 BONUS: Tại sao Named Parameters quan trọng?
// ============================================
// 
// So sánh 2 cách viết:
// 
// Positional (khó đọc):
// createUser('Dong', 25, true, 'dong@email.com');
// // Không biết 25 là gì, true là gì
// 
// Named (dễ đọc):
// createUser(
//   name: 'Dong',
//   age: 25,
//   isActive: true,
//   email: 'dong@email.com',
// );
// 
// Flutter sử dụng named parameters khắp nơi!
// Ví dụ:
// Container(
//   width: 100,
//   height: 200,
//   color: Colors.red,
//   child: Text('Hello'),
// )
