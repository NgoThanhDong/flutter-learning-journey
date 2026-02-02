# Lesson 06: Deep Linking 🔗

## 1. Deep Linking là gì?

Là khả năng mở ứng dụng vào một màn hình cụ thể từ một URL (ví dụ click link trong email, hoặc gõ URL trên trình duyệt web).

### Các loại Deep Link:
1. **Custom Scheme**: `myapp://path/to/content` (Dễ setup, nhưng chỉ hoạt động khi app đã cài).
2. **Universal Links (iOS) / App Links (Android)**: `https://www.myapp.com/path` (Mở web nếu chưa cài app, mở app nếu đã cài).
3. **Web URL**: URL thông thường trên trình duyệt.

## 2. Web Configuration

Với Flutter Web, GoRouter tự động hỗ trợ URL mapping. Tuy nhiên, mặc định URL có dấu `#` (Hash Strategy), ví dụ: `localhost:8080/#/details`.

Để bỏ dấu `#` (Path Strategy - `localhost:8080/details`), cần cấu hình thêm.

### Cấu hình Path URL Strategy

Trong `main.dart`:
```dart
import 'package:flutter_web_plugins/url_strategy.dart'; // Cần thêm package này hoặc setup

void main() {
  usePathUrlStrategy(); // Bỏ dấu #
  runApp(MyApp());
}
```

*Lưu ý: Cần thêm cấu hình server (như Firebase Hosting, Nginx) để rewrite tất cả request về index.html nếu deploy thực tế.*

## 3. Web History

GoRouter tích hợp sẵn với Browser History API.
- Back button trên trình duyệt hoạt động như `Navigator.pop`.
- User có thể gõ trực tiếp URL để navigate.

## 4. Testing

Để test Deep Link trên Simulator/Device:

**Android:**
```bash
adb shell am start -W -a android.intent.action.VIEW -d "example://myapp/details" com.example.myapp
```

**iOS:**
```bash
xcrun simctl openurl booted "example://myapp/details"
```

Với **Flutter Web (Chrome)**, bạn chỉ cần gõ URL vào thanh địa chỉ trình duyệt. Đây là môi trường test dễ nhất cho logic routing.
