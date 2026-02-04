# Lesson 4: Dio Package 🚀

## Mục tiêu

- Hiểu tại sao dùng Dio thay vì http
- Cấu hình Dio cơ bản
- Sử dụng Interceptors
- Error handling với DioException

---

## 1. Tại sao Dio?

| Feature | http | Dio |
|---------|------|-----|
| Basic requests | ✅ | ✅ |
| Interceptors | ❌ | ✅ |
| Global config | ❌ | ✅ |
| Request cancel | ❌ | ✅ |
| Progress tracking | ❌ | ✅ |
| Form data | Manual | ✅ |
| Transformers | ❌ | ✅ |

**Kết luận**: Dùng `http` cho app đơn giản, `Dio` cho app production.

---

## 2. Cài đặt

```yaml
dependencies:
  dio: ^5.4.0
```

```dart
import 'package:dio/dio.dart';
```

---

## 3. Basic Usage

```dart
/// Tạo instance Dio
final dio = Dio();

/// GET request
final response = await dio.get('https://jsonplaceholder.typicode.com/users');
print(response.data); // Đã tự parse JSON!

/// POST request
final response = await dio.post(
  'https://jsonplaceholder.typicode.com/posts',
  data: {
    'title': 'Hello',
    'body': 'World',
    'userId': 1,
  },
);
```

### So sánh với http:
```dart
// http package - phải tự parse JSON
final response = await http.get(Uri.parse(url));
final data = jsonDecode(response.body);

// Dio - tự động parse JSON
final response = await dio.get(url);
final data = response.data; // Đã là Map/List!
```

---

## 4. BaseOptions - Cấu hình Global

```dart
final dio = Dio(
  BaseOptions(
    /// Base URL - prefix cho tất cả requests
    baseUrl: 'https://jsonplaceholder.typicode.com',
    
    /// Timeout settings
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    
    /// Default headers
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),
);

// Giờ chỉ cần path, không cần full URL
final response = await dio.get('/users'); // = baseUrl + '/users'
```

---

## 5. Interceptors

Interceptors cho phép **can thiệp** vào request/response.

### Logging Interceptor:
```dart
dio.interceptors.add(
  LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (log) => print(log),
  ),
);
```

### Custom Interceptor:
```dart
dio.interceptors.add(
  InterceptorsWrapper(
    /// [onRequest] - Trước khi gửi request
    onRequest: (options, handler) {
      print('REQUEST: ${options.method} ${options.path}');
      
      // Thêm auth token
      options.headers['Authorization'] = 'Bearer $token';
      
      handler.next(options); // Tiếp tục
    },
    
    /// [onResponse] - Khi nhận response thành công
    onResponse: (response, handler) {
      print('RESPONSE: ${response.statusCode}');
      handler.next(response);
    },
    
    /// [onError] - Khi có lỗi
    onError: (error, handler) {
      print('ERROR: ${error.message}');
      
      // Có thể retry, refresh token, etc.
      if (error.response?.statusCode == 401) {
        // Redirect to login
      }
      
      handler.next(error);
    },
  ),
);
```

---

## 6. Auth Interceptor Pattern

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Lấy token từ storage
    final token = AuthStorage.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired → logout
      AuthStorage.clear();
      // Navigate to login...
    }
    handler.next(err);
  }
}

// Sử dụng
dio.interceptors.add(AuthInterceptor());
```

---

## 7. Error Handling

### DioException types:
```dart
try {
  final response = await dio.get('/users');
} on DioException catch (e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      print('Connection timeout');
      break;
    case DioExceptionType.receiveTimeout:
      print('Receive timeout');
      break;
    case DioExceptionType.badResponse:
      // Server trả về error (4xx, 5xx)
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      break;
    case DioExceptionType.cancel:
      print('Request cancelled');
      break;
    case DioExceptionType.connectionError:
      print('No internet connection');
      break;
    default:
      print('Unknown error: ${e.message}');
  }
}
```

### Helper function:
```dart
String getErrorMessage(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Kết nối chậm, vui lòng thử lại';
    case DioExceptionType.connectionError:
      return 'Không có kết nối mạng';
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status == 401) return 'Phiên đăng nhập hết hạn';
      if (status == 403) return 'Không có quyền truy cập';
      if (status == 404) return 'Không tìm thấy dữ liệu';
      if (status == 500) return 'Lỗi server, vui lòng thử lại sau';
      return 'Lỗi: $status';
    default:
      return 'Đã có lỗi xảy ra';
  }
}
```

---

## 8. Cancel Requests

```dart
final cancelToken = CancelToken();

// Bắt đầu request
dio.get('/users', cancelToken: cancelToken);

// Hủy request (ví dụ khi user rời trang)
cancelToken.cancel('User left the page');
```

---

## 9. Api Service Pattern

```dart
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  late final Dio _dio;
  
  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      AuthInterceptor(),
    ]);
  }
  
  Dio get dio => _dio;
  
  // Helper methods
  Future<Response<T>> get<T>(String path) => _dio.get<T>(path);
  Future<Response<T>> post<T>(String path, {dynamic data}) => 
      _dio.post<T>(path, data: data);
}

// Sử dụng
final response = await ApiService().get('/users');
```

---

## 10. Full Example

```dart
import 'package:dio/dio.dart';

class UserRepository {
  final Dio _dio;
  
  UserRepository() : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(LogInterceptor());
  
  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      final list = response.data as List;
      return list.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException(getErrorMessage(e));
    }
  }
  
  Future<User> createUser(String name, String email) async {
    try {
      final response = await _dio.post('/users', data: {
        'name': name,
        'email': email,
      });
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(getErrorMessage(e));
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}
```

---

## Tóm Tắt

| Feature | Cách dùng |
|---------|-----------|
| Basic | `dio.get()`, `dio.post()` |
| Config | `BaseOptions` |
| Interceptors | `dio.interceptors.add()` |
| Error | `DioException`, `e.type` |
| Cancel | `CancelToken` |
| Pattern | Singleton ApiService |

---

---

## Bài Tập Liên Quan

- `ex08_dio_basic.dart` - Cấu hình Dio và GET request
- `ex09_dio_interceptors.dart` - Logging và Auth Interceptors
- `ex10_error_handling.dart` - Xử lý lỗi (Timeout, 404, 500)
- `ex11_api_service.dart` - Repository Pattern với Dio

---

## Bài Tiếp Theo

➡️ [Lesson 5: Loading States](lesson_05_loading_states.md)
