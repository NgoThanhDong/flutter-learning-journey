/// ===========================================
/// BÀI TẬP 12: THAO TÁC VỚI MAP (JSON)
/// ===========================================
///
/// Mục tiêu: Làm việc với Map, đặc biệt là JSON từ API
///
/// Chạy file: dart run exercise_12_map.dart

void main() {
  print('=== BÀI TẬP 12: THAO TÁC VỚI MAP ===\n');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 1: Tạo và truy cập Map            ║
  // ╚════════════════════════════════════════════╝

  print('--- Bài tập 1: Tạo thông tin cá nhân ---');

  // -TODO: Tạo Map chứa thông tin của bạn
  // Keys: 'name', 'age', 'city', 'skills' (List<String>)

  Map<String, dynamic> myInfo = {
    'name': 'Nguyễn Văn A',
    'age': 25,
    'city': 'Hồ Chí Minh',
    'skills': ['Flutter', 'Dart', 'Firebase'],
  };
  print('Thông tin: $myInfo');
  print('Tên: ${myInfo["name"]}');
  print('Skills: ${myInfo["skills"]}');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 2: Parse JSON từ API              ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 2: Parse dữ liệu API ---');

  // Giả lập response từ API
  Map<String, dynamic> apiResponse = {
    'status': 'success',
    'data': {
      'user': {'id': 1, 'name': 'Nguyễn Văn A', 'email': 'a@example.com'},
      'orders': [
        {'id': 101, 'total': 500000},
        {'id': 102, 'total': 750000},
        {'id': 103, 'total': 1200000},
      ],
    },
  };

  // -TODO: Trích xuất thông tin sau:
  // 1. Tên user
  // 2. Email user
  // 3. Tổng số orders
  // 4. Tổng tiền tất cả orders

  var userData = apiResponse['data']['user'];
  var userName = userData['name'];
  var userEmail = userData['email'];
  
  var orders = apiResponse['data']['orders'] as List;
  var totalOrders = orders.length;
  var totalAmount = orders.fold(0, (sum, order) => sum + order['total'] as int);
  
  print('User: $userName ($userEmail)');
  print('Số orders: $totalOrders');
  print('Tổng tiền: $totalAmount VNĐ');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 3: Chuyển Object sang Map         ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 3: Object to JSON ---');

  // -TODO: Implement method toJson() cho class Product
  var product3 = Product(1, 'Laptop', 15000000);
  var json = product3.toJson();
  print('Product JSON: $json');

  // ╔════════════════════════════════════════════╗
  // ║  BÀI TẬP 4: Chuyển Map sang Object         ║
  // ╚════════════════════════════════════════════╝

  print('\n--- Bài tập 4: JSON to Object ---');

  Map<String, dynamic> productJson = {
    'id': 2,
    'name': 'Phone',
    'price': 8000000,
  };

  // -TODO: Implement factory constructor Product.fromJson()
  var product4 = Product.fromJson(productJson);
  print('Product: ${product4.name}, ${product4.price} VNĐ');

  print('\n--- KIỂM TRA ---');
  print('👆 Implement code rồi uncomment để kiểm tra!');
}

// ============================================
// CLASS PRODUCT (Hoàn thành -TODO bên dưới)
// ============================================

class Product {
  int id;
  String name;
  int price;

  Product(this.id, this.name, this.price);

  // -TODO: Implement factory constructor
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'],
      json['name'],
      json['price'],
    );
  }

  // -TODO: Implement toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

// ============================================
// GỢI Ý
// ============================================
// 
// Bài 2 - Trích xuất nested data:
//   var userData = apiResponse['data']['user'];
//   var userEmail = userData['email'];
//   
//   var orders = apiResponse['data']['orders'] as List;
//   var totalAmount = orders.fold<int>(0, (sum, order) => sum + (order['total'] as int));
// 
// Bài 3 & 4:
//   Xem comment trong class Product
//   
// 💡 Trong thực tế, bạn sẽ dùng package json_serializable
//    để tự động generate fromJson/toJson
