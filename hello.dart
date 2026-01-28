// ========================================
// 🎓 BÀI HỌC 1: HELLO DART
// ========================================
//
// Chào mừng bạn đến với Dart!
// File này là bài học đầu tiên của bạn.
//
// 📌 CÁCH CHẠY FILE NÀY:
// 1. Mở Terminal trong VS Code (View → Terminal)
// 2. Gõ lệnh: dart run hello.dart
// 3. Nhấn Enter và xem kết quả!

void main() {
  // ----------------------------------------
  // PHẦN 1: In ra màn hình
  // ----------------------------------------

  // print() là lệnh để in văn bản ra màn hình
  print('Xin chào! Tôi là Dart!');
  print('Đây là dòng thứ 2');

  // ----------------------------------------
  // PHẦN 2: Biến (Variables)
  // ----------------------------------------

  // Biến giống như một "hộp" để chứa dữ liệu
  // Ví dụ: hộp tên "name" chứa chữ "Dong"

  var name = 'Dong'; // Hộp chứa chữ (String)
  var age = 25; // Hộp chứa số nguyên (int)
  var height = 1.75; // Hộp chứa số thập phân (double)
  var isStudent = true; // Hộp chứa đúng/sai (bool)

  print(''); // In dòng trống
  print('--- Thông tin của tôi ---');
  print('Tên: $name'); // $name = lấy giá trị của biến name
  print('Tuổi: $age');
  print('Chiều cao: $height m');
  print('Là sinh viên: $isStudent');

  // ----------------------------------------
  // 📝 BÀI TẬP CHO BẠN:
  // ----------------------------------------
  //
  // 1. Thay tên "Dong" thành tên của bạn
  // 2. Thay tuổi 25 thành tuổi của bạn
  // 3. Chạy lại file và xem kết quả!
  //
  // Sau khi làm xong, hỏi tôi để học tiếp phần sau!
}
