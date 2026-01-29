/// ===========================================
/// BÀI TẬP 15: ERROR HANDLING
/// ===========================================
///
/// Mục tiêu: Thành thạo try-catch và custom exception
///
/// Chạy file: dart run exercise_15_error_handling.dart

void main() async {
  print('=== BÀI TẬP 15: ERROR HANDLING ===\n');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 1: Try-Catch cơ bản               ║
  // ╚════════════════════════════════════════════╝

  print('--- Bài tập 1: Parse số an toàn ---');

  // -TODO: Implement function safeParseInt(String value)
  // - Nếu parse được → trả về số
  // - Nếu không parse được → trả về null

  int? safeParseInt(String value) {
    try {
      return int.parse(value);
    } on FormatException {
      return null;
    }
  }

  print(safeParseInt('123')); // 123
  print(safeParseInt('abc')); // null
  print(safeParseInt('12.5')); // null

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 2: Validate với Exception         ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 2: Validate email ---');

  // -TODO: Implement function validateEmail(String email)
  // - Throw FormatException nếu email rỗng
  // - Throw FormatException nếu không có @
  // - Throw FormatException nếu không có .
  // - Return true nếu hợp lệ

  bool validateEmail(String email) {
    if (email.isEmpty) {
      throw FormatException('Email không được rỗng');
    }
    if (!email.contains('@')) {
      throw FormatException('Email phải có @');
    }
    if (!email.contains('.')) {
      throw FormatException('Email phải có .');
    }
    return true;
  }

  void testEmail(String email) {
    try {
      validateEmail(email);
      print('✅ "$email" is valid');
    } on FormatException catch (e) {
      print('❌ "$email" invalid: $e');
    }
  }

  testEmail('test@example.com'); // ✅ Valid
  testEmail('invalid-email'); // ❌ Invalid
  testEmail(''); // ❌ Invalid

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 3: Custom Exception               ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 3: Custom Exception cho ngân hàng ---');

  // -TODO: Tạo các custom exception:
  // - InsufficientBalanceException(required, available)
  // - InvalidAmountException(amount)

  // Sau đó implement class BankAccount:
  // - balance property
  // - withdraw(amount) method
  //   + throw InvalidAmountException nếu amount <= 0
  //   + throw InsufficientBalanceException nếu không đủ tiền
  //   + trừ tiền và return balance mới nếu OK

   void testWithdraw(BankAccount account, int amount) {
    try {
      account.withdraw(amount);
      print('✅ $amount withdrawed successfully');
    } on InvalidAmountException catch (e) {
      print('❌ Invalid amount: $e');
    } on InsufficientBalanceException catch (e) {
      print('❌ Insufficient balance: $e');
    }
  }

  int balance = 1000000;
  var account = BankAccount(balance);

  testWithdraw(account, 500000); // ✅ OK
  testWithdraw(account, 1000000); // ❌ Không đủ tiền
  testWithdraw(account, -100); // ❌ Số tiền không hợp lệ

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 4: Finally - Cleanup              ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 4: Xử lý file (giả lập) ---');

  // -TODO: Implement function processFile(String filename)
  // Giả lập:
  // - "openFile" (print)
  // - "readFile" (có thể throw nếu filename là 'error.txt')
  // - "closeFile" (print) - PHẢI luôn được gọi dù có lỗi hay không

  void processFile(String filename) {
    print('📂 Opening $filename...');
    try {
      // Giả lập đọc file
      if (filename == 'error.txt') {
        throw Exception('File bị lỗi!');
      }
      print('📖 Reading $filename...');
    } catch (e) {
      print('❌ Error: $e');
    } finally {
      // Luôn close file
      print('🔒 Closing $filename...');
    }
    print('');
  }

  processFile('data.txt'); // Open, Read, Close
  processFile('error.txt'); // Open, Error, Close (finally)

  print('\n--- KIỂM TRA ---');
  print('👆 Implement code rồi uncomment để kiểm tra!');
}

// ============================================
// BÀI 1: Safe Parse
// ============================================

// -TODO: Implement
// int? safeParseInt(String value) {
//   try {
//     return int.parse(value);
//   } on FormatException {
//     return null;
//   }
// }

// ============================================
// BÀI 2: Validate Email
// ============================================

// -TODO: Implement
// bool validateEmail(String email) {
//   if (email.isEmpty) {
//     throw FormatException('Email không được rỗng');
//   }
//   if (!email.contains('@')) {
//     throw FormatException('Email phải có @');
//   }
//   if (!email.contains('.')) {
//     throw FormatException('Email phải có .');
//   }
//   return true;
// }
//
// void testEmail(String email) {
//   try {
//     validateEmail(email);
//     print('✅ "$email" is valid');
//   } on FormatException catch (e) {
//     print('❌ "$email" invalid: $e');
//   }
// }

// ============================================
// BÀI 3: Custom Exception - Bank
// ============================================

// -TODO: Tạo custom exceptions
class InsufficientBalanceException implements Exception {
  final int required;
  final int available;

  InsufficientBalanceException(this.required, this.available);

  @override
  String toString() =>
      'InsufficientBalanceException: Cần $required, chỉ có $available';
}

class InvalidAmountException implements Exception {
  final int amount;

  InvalidAmountException(this.amount);

  @override
  String toString() => 'InvalidAmountException: Số tiền $amount không hợp lệ';
}

// -TODO: Implement BankAccount
class BankAccount {
  int balance;

  BankAccount(this.balance);
  int withdraw(int amount) {
    if (amount <= 0) {
      throw InvalidAmountException(amount);
    }
    if (amount > balance) {
      throw InsufficientBalanceException(amount, balance);
    }
    balance -= amount;
    return balance;
  }
}

// ============================================
// BÀI 4: Finally
// ============================================

// -TODO: Implement
// void processFile(String filename) {
//   print('📂 Opening $filename...');
//   try {
//     // Giả lập đọc file
//     if (filename == 'error.txt') {
//       throw Exception('File bị lỗi!');
//     }
//     print('📖 Reading $filename...');
//   } catch (e) {
//     print('❌ Error: $e');
//   } finally {
//     // Luôn close file
//     print('🔒 Closing $filename...');
//   }
//   print('');
// }

// ============================================
// GỢI Ý
// ============================================
// 
// Bài 1: Dùng try-on FormatException-return null
// 
// Bài 2: Throw FormatException với message
// 
// Bài 3: 
//   - Tạo class Exception với implements Exception
//   - Override toString() để có message đẹp
//   - BankAccount.withdraw() kiểm tra điều kiện rồi throw
// 
// Bài 4: finally block luôn chạy dù có lỗi hay không
