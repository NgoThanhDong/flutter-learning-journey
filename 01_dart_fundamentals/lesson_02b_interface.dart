/// ===========================================
/// BÀI BỔ SUNG: INTERFACE TRONG DART
/// ===========================================
/// 
/// Dart không có từ khóa "interface" như Java/C#
/// Thay vào đó, MỌI CLASS đều có thể dùng như interface!
/// 
/// Chạy file:
///    dart run lesson_02b_interface.dart

void main() {
  print('=== 1. INTERFACE CƠ BẢN ===\n');
  demonstrateBasicInterface();
  
  print('\n=== 2. ABSTRACT CLASS VS INTERFACE ===\n');
  demonstrateAbstractVsInterface();
  
  print('\n=== 3. MULTIPLE INTERFACES ===\n');
  demonstrateMultipleInterfaces();
  
  print('\n=== 4. THỰC TẾ: REPOSITORY PATTERN ===\n');
  demonstrateRepositoryPattern();
}

// ============================================
// 1. INTERFACE CƠ BẢN
// ============================================

// Trong Dart, dùng abstract class làm interface
// Đây là "giao ước" - các class implement PHẢI có các method này

abstract class Printable {
  // Không có code, chỉ khai báo "giao ước"
  void printInfo();
}

abstract class Exportable {
  String exportToJson();
}

// Class implement interface bằng từ khóa "implements"
class Document implements Printable {
  String title;
  String content;
  
  Document(this.title, this.content);
  
  // BẮT BUỘC phải implement method printInfo()
  @override
  void printInfo() {
    print('📄 Document: $title');
    print('   Nội dung: $content');
  }
}

void demonstrateBasicInterface() {
  var doc = Document('Báo cáo', 'Nội dung báo cáo...');
  doc.printInfo();
  
  // 💡 ĐIỂM QUAN TRỌNG:
  // - "implements" = phải implement TẤT CẢ methods
  // - "extends" = kế thừa, có thể dùng code của parent
  print('\n💡 implements = phải viết lại tất cả methods');
  print('💡 extends = kế thừa code, chỉ override khi cần');
}

// ============================================
// 2. ABSTRACT CLASS VS INTERFACE
// ============================================

// Abstract class: Có thể có code sẵn
abstract class Animal {
  String name;
  
  Animal(this.name);
  
  // Method có code sẵn
  void breathe() {
    print('$name đang thở...');
  }
  
  // Abstract method - không có code
  void makeSound();
}

// Interface (abstract class không có code)
abstract class CanFly {
  void fly();  // Chỉ khai báo, không có code
}

// extends Animal: kế thừa code breathe()
// implements CanFly: phải tự viết fly()
class Bird extends Animal implements CanFly {
  Bird(String name) : super(name);
  
  @override
  void makeSound() {
    print('$name: Chíp chíp!');
  }
  
  @override
  void fly() {
    print('$name đang bay trên bầu trời!');
  }
}

void demonstrateAbstractVsInterface() {
  var bird = Bird('Chim sẻ');
  
  bird.breathe();   // Từ Animal (extends) - không cần viết lại
  bird.makeSound(); // Override từ Animal
  bird.fly();       // Từ CanFly (implements) - phải viết
  
  print('\n📊 So sánh:');
  print('┌─────────────┬──────────────────────────────────┐');
  print('│ extends     │ Kế thừa code, override khi cần   │');
  print('├─────────────┼──────────────────────────────────┤');
  print('│ implements  │ Phải viết tất cả methods          │');
  print('├─────────────┼──────────────────────────────────┤');
  print('│ with        │ Trộn mixin vào class             │');
  print('└─────────────┴──────────────────────────────────┘');
}

// ============================================
// 3. MULTIPLE INTERFACES
// ============================================

// Dart cho phép implement NHIỀU interface (không như extends)

abstract class Readable {
  String read();
}

abstract class Writable {
  void write(String data);
}

abstract class Deletable {
  void delete();
}

// Implement nhiều interface cùng lúc
class File implements Readable, Writable, Deletable {
  String name;
  String _content = '';
  
  File(this.name);
  
  @override
  String read() {
    print('📖 Đang đọc file $name...');
    return _content;
  }
  
  @override
  void write(String data) {
    print('✏️ Đang ghi vào file $name...');
    _content = data;
  }
  
  @override
  void delete() {
    print('🗑️ Đã xóa file $name');
    _content = '';
  }
}

void demonstrateMultipleInterfaces() {
  var file = File('document.txt');
  
  file.write('Hello World!');
  var content = file.read();
  print('   Nội dung: $content');
  file.delete();
  
  print('\n💡 Một class có thể implement nhiều interface!');
  print('   class File implements Readable, Writable, Deletable');
}

// ============================================
// 4. THỰC TẾ: REPOSITORY PATTERN
// ============================================
// 
// Đây là pattern bạn sẽ dùng rất nhiều trong Flutter!
// Interface giúp dễ dàng thay đổi nguồn dữ liệu

// Interface định nghĩa các operations
abstract class UserRepository {
  Future<User> getById(int id);
  Future<List<User>> getAll();
  Future<void> save(User user);
  Future<void> delete(int id);
}

class User {
  int id;
  String name;
  User(this.id, this.name);
}

// Implementation 1: Lấy từ API
class ApiUserRepository implements UserRepository {
  @override
  Future<User> getById(int id) async {
    print('🌐 Fetching user $id from API...');
    await Future.delayed(Duration(milliseconds: 100));
    return User(id, 'User from API');
  }
  
  @override
  Future<List<User>> getAll() async {
    print('🌐 Fetching all users from API...');
    return [User(1, 'Alice'), User(2, 'Bob')];
  }
  
  @override
  Future<void> save(User user) async {
    print('🌐 Saving user ${user.name} to API...');
  }
  
  @override
  Future<void> delete(int id) async {
    print('🌐 Deleting user $id from API...');
  }
}

// Implementation 2: Lấy từ local database
class LocalUserRepository implements UserRepository {
  @override
  Future<User> getById(int id) async {
    print('💾 Getting user $id from local DB...');
    return User(id, 'User from Local DB');
  }
  
  @override
  Future<List<User>> getAll() async {
    print('💾 Getting all users from local DB...');
    return [User(1, 'Local Alice'), User(2, 'Local Bob')];
  }
  
  @override
  Future<void> save(User user) async {
    print('💾 Saving user ${user.name} to local DB...');
  }
  
  @override
  Future<void> delete(int id) async {
    print('💾 Deleting user $id from local DB...');
  }
}

// Service sử dụng interface, không quan tâm implementation cụ thể
class UserService {
  final UserRepository _repository;  // Interface, không phải class cụ thể
  
  UserService(this._repository);
  
  Future<void> displayUser(int id) async {
    var user = await _repository.getById(id);
    print('   → Kết quả: ${user.name}');
  }
}

void demonstrateRepositoryPattern() async {
  print('--- Dùng API Repository ---');
  var apiService = UserService(ApiUserRepository());
  await apiService.displayUser(1);
  
  print('\n--- Dùng Local Repository ---');
  var localService = UserService(LocalUserRepository());
  await localService.displayUser(1);
  
  print('\n💡 LỢI ÍCH CỦA INTERFACE:');
  print('   - Dễ thay đổi implementation (API ↔ Local)');
  print('   - Dễ test (dùng Mock Repository)');
  print('   - Code linh hoạt, ít phụ thuộc');
}

// ============================================
// 💡 GHI NHỚ QUAN TRỌNG
// ============================================
// 
// 1. Dart không có từ khóa "interface"
// 2. Dùng abstract class không có code làm interface
// 3. extends = kế thừa (chỉ 1 class)
// 4. implements = thực thi interface (nhiều interfaces)
// 5. with = trộn mixin (nhiều mixins)
// 
// Khi nào dùng gì?
// - extends: Khi muốn kế thừa code và behavior
// - implements: Khi chỉ muốn "giao ước" phải có methods
// - with: Khi muốn chia sẻ code mà không cần inheritance
