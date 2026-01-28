/// ===========================================
/// BÀI TẬP 2: HỆ THỐNG NHÂN VIÊN (INHERITANCE)
/// ===========================================
///
/// Yêu cầu:
/// 1. Tạo abstract class Employee với:
///    - Properties: name, id
///    - Abstract method: calculateSalary()
///    - Concrete method: displayInfo()
///
/// 2. Tạo FullTimeEmployee:
///    - Property: monthlySalary (lương cố định)
///    - calculateSalary() trả về monthlySalary
///
/// 3. Tạo PartTimeEmployee:
///    - Properties: hourlyRate (lương/giờ), hoursWorked (số giờ làm)
///    - calculateSalary() trả về hourlyRate * hoursWorked
///
/// Chạy file: dart run exercise_05_employee.dart

void main() {
  print('=== BÀI TẬP 2: HỆ THỐNG NHÂN VIÊN ===\n');

  // Uncomment sau khi implement xong

  // Nhân viên full-time
  var manager = FullTimeEmployee('Nguyễn Văn A', 'E001', 20000000);
  manager.displayInfo();
  print('Lương: ${manager.calculateSalary()} VNĐ\n');

  // Nhân viên part-time
  var intern = PartTimeEmployee('Trần Thị B', 'E002', 50000, 80);
  intern.displayInfo();
  print('Lương: ${intern.calculateSalary()} VNĐ\n');

  // Polymorphism - xử lý tất cả như Employee
  print('--- Tổng lương nhân viên ---');
  List<Employee> employees = [manager, intern];
  double totalSalary = 0;
  for (var emp in employees) {
    totalSalary += emp.calculateSalary();
  }
  print('Tổng: $totalSalary VNĐ');

  print('\n--- KIỂM TRA ---');
  checkExercise();

  print('👆 Hãy implement các class rồi uncomment code trên!');
}

// ============================================
// -TODO: VIẾT CODE CỦA BẠN Ở ĐÂY
// ============================================

// Abstract class Employee
abstract class Employee {
  String name;
  String id;

  Employee(this.name, this.id);

  // Abstract method - class con PHẢI implement
  double calculateSalary();

  // Concrete method - class con có thể dùng luôn
  void displayInfo() {
    print('Nhân viên: $name (ID: $id)');
  }
}

// FullTimeEmployee - lương cố định
class FullTimeEmployee extends Employee {
  // -TODO: Thêm property monthlySalary
  double monthlySalary;

  // -TODO: Constructor
  FullTimeEmployee(String name, String id, this.monthlySalary)
    : super(name, id);

  // -TODO: Override calculateSalary()
  @override
  double calculateSalary() => monthlySalary;
}

// PartTimeEmployee - lương theo giờ
class PartTimeEmployee extends Employee {
  // -TODO: Thêm properties hourlyRate, hoursWorked
  double hourlyRate;
  int hoursWorked;

  // -TODO: Constructor
  PartTimeEmployee(String name, String id, this.hourlyRate, this.hoursWorked)
    : super(name, id);

  // -TODO: Override calculateSalary()
  @override
  double calculateSalary() => hourlyRate * hoursWorked;
}

// ============================================
// GỢI Ý CHI TIẾT
// ============================================
//
// class FullTimeEmployee extends Employee {
//   double monthlySalary;
//
//   FullTimeEmployee(String name, String id, this.monthlySalary)
//       : super(name, id);  // Gọi constructor của parent
//
//   @override
//   double calculateSalary() => monthlySalary;
// }
//
// class PartTimeEmployee extends Employee {
//   double hourlyRate;
//   int hoursWorked;
//
//   PartTimeEmployee(String name, String id, this.hourlyRate, this.hoursWorked)
//       : super(name, id);
//
//   @override
//   double calculateSalary() => hourlyRate * hoursWorked;
// }

// ============================================
// HÀM KIỂM TRA
// ============================================

void checkExercise() {
  int score = 0;

  try {
    // Test FullTimeEmployee
    var ft = FullTimeEmployee('Test', 'T1', 10000000);
    if (ft.calculateSalary() == 10000000) {
      print('✅ FullTimeEmployee.calculateSalary(): PASSED');
      score++;
    }

    // Test PartTimeEmployee
    var pt = PartTimeEmployee('Test', 'T2', 100000, 40);
    if (pt.calculateSalary() == 4000000) {
      print('✅ PartTimeEmployee.calculateSalary(): PASSED');
      score++;
    }

    // Test polymorphism
    List<Employee> list = [ft, pt];
    if (list.length == 2) {
      print('✅ Polymorphism (List<Employee>): PASSED');
      score++;
    }

    print('\n🎯 Kết quả: $score/3 điểm');
  } catch (e) {
    print('❌ Lỗi: $e');
  }
}
