# Bài 7: Styling & Theming

## 🎯 Mục tiêu
- Tạo Theme cho toàn app
- Sử dụng ColorScheme
- Custom fonts
- Tạo Dark/Light mode

---

## 1. ThemeData - Theme Toàn App

### 1.1 Cơ bản

```dart
MaterialApp( // MaterialApp là widget gốc (root) của app Flutter dùng Material Design
  theme: ThemeData( // ThemeData chứa các theme cho toàn app
    // Primary color
    // Bảng màu chính kiểu cũ
    // Chỉ dùng cho Material 2
    // Kiểu Colors.blue, Colors.red
    // Ít linh hoạt, đang bị thay thế
    primarySwatch: Colors.blue,
    
    // Color scheme - Bộ màu đầy đủ cho toàn app
    // Gồm: primary, secondary, surface, background, error…
    // Dùng cho Material 3
    // Kiểm soát màu chuẩn & đồng bộ
    colorScheme: ColorScheme.fromSeed(
      // Màu gốc để Flutter tự sinh colorScheme
      // Flutter tự tính toán các màu còn lại
      seedColor: Colors.blue,
      brightness: Brightness.light, // Tối ưu cho màn hình sáng
    ),
    
    // Use Material 3
    useMaterial3: true, // Sử dụng Material 3
  ),
  home: MyHomePage(),
)
```

### 1.2 ThemeData đầy đủ

```dart
ThemeData(
  // Material 3
  useMaterial3: true,
  
  // Color Scheme
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF6750A4),
    brightness: Brightness.light,
  ),
  
  // Scaffold
  scaffoldBackgroundColor: Colors.grey[50], // Màu nền của Scaffold
  
  // AppBar
  // AppBarTheme chứa các theme cho AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white, // Màu nền của AppBar
    foregroundColor: Colors.black, // Màu text, icon của AppBar
    elevation: 0, // Loại bỏ bóng của AppBar
    centerTitle: true, // Center title
    titleTextStyle: TextStyle( // TextStyle cho title của AppBar
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600, // Bold
    ),
  ),
  
  // Card
  // CardTheme chứa các theme cho Card
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  // ElevatedButton
  // ElevatedButtonThemeData chứa các theme cho ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  
  // TextButton
  // TextButtonThemeData chứa các theme cho TextButton
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue, // Màu text của TextButton
    ),
  ),
  
  // OutlinedButton
  // OutlinedButtonThemeData chứa các theme cho OutlinedButton
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  
  // Input (TextField)
  // InputDecorationTheme chứa các theme cho TextField
  inputDecorationTheme: InputDecorationTheme(
    filled: true, // Bật fill
    fillColor: Colors.grey[100], // Màu fill
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // Bán kính của border
      borderSide: BorderSide.none, // Loại bỏ border
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  
  // FloatingActionButton
  // FloatingActionButtonThemeData chứa các theme cho FloatingActionButton
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  
  // ListTile
  // ListTileThemeData chứa các theme cho ListTile
  listTileTheme: ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16), // Padding nội dung của ListTile
  ),
  
  // Divider
  // DividerThemeData chứa các theme cho Divider
  dividerTheme: DividerThemeData(
    thickness: 1, // Độ dày của Divider
    color: Colors.grey[300], // Màu của Divider
  ),
  
  // Icon
  // IconThemeData chứa các theme cho Icon
  iconTheme: IconThemeData(
    color: Colors.grey[700],
    size: 24,
  ),
  
  // Text
  // TextTheme chứa các theme cho Text
  textTheme: TextTheme(
    // Text style cho displayLarge
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    // Text style cho displayMedium
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    // Text style cho displaySmall
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    // Text style cho headlineMedium
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    // Text style cho titleLarge
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    // Text style cho titleMedium
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16), // Text style cho bodyLarge
    bodyMedium: TextStyle(fontSize: 14), // Text style cho bodyMedium
    bodySmall: TextStyle(fontSize: 12), // Text style cho bodySmall
    // Text style cho labelLarge
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  ),
)
```

---

## 2. ColorScheme - bản đồ màu toàn app

### 2.1 Tạo từ seed color

```dart
// Tạo ColorScheme từ seed color
ColorScheme.fromSeed(
  seedColor: Color(0xFF6750A4), // Tím
  brightness: Brightness.light,
)
```

### 2.2 Các màu trong ColorScheme

```dart
// Truy cập trong widget
ColorScheme colors = Theme.of(context).colorScheme;

colors.primary        // Màu chính
colors.onPrimary      // Màu text/icon trên primary
colors.primaryContainer // Màu container
colors.onPrimaryContainer // Màu text trên container

colors.secondary      // Màu phụ
colors.onSecondary      // Màu text/icon trên secondary
colors.secondaryContainer // Màu container
colors.onSecondaryContainer // Màu text trên container

colors.tertiary       // Màu thứ 3
colors.error          // Màu lỗi
colors.onError

colors.background     // Màu nền
colors.onBackground   // Màu text trên nền
colors.surface        // Màu bề mặt (card, dialog)
colors.onSurface      // Màu text trên bề mặt

colors.outline        // Màu viền
colors.shadow         // Màu bóng
```

### 2.3 Sử dụng trong widget

```dart
Container(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  ),
)
```

---

## 3. TextTheme - bộ style chữ chuẩn dùng chung cho toàn app

### 3.1 Sử dụng TextTheme

```dart
Text(
  'Headline',
  style: Theme.of(context).textTheme.headlineMedium,
)

Text(
  'Body text',
  style: Theme.of(context).textTheme.bodyMedium,
)

// Customize thêm
Text(
  'Title',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
)
```

### 3.2 Text styles trong Material 3

| Style | Kích thước | Sử dụng |
|-------|-----------|---------|
| displayLarge | 57px | Hero text |
| displayMedium | 45px | Large headers |
| displaySmall | 36px | Section headers |
| headlineLarge | 32px | Page titles |
| headlineMedium | 28px | Section titles |
| headlineSmall | 24px | Sub-section |
| titleLarge | 22px | Card titles |
| titleMedium | 16px | List item title |
| titleSmall | 14px | Tabs, chips |
| bodyLarge | 16px | Main content |
| bodyMedium | 14px | Body text |
| bodySmall | 12px | Captions |
| labelLarge | 14px | Buttons |
| labelMedium | 12px | Small buttons |
| labelSmall | 11px | Tiny labels |

---

## 4. Custom Fonts

### 4.1 Thêm font vào project

1. Tạo thư mục `assets/fonts/`
2. Copy file font (.ttf, .otf)
3. Khai báo trong `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        - asset: assets/fonts/Poppins-Italic.ttf
          style: italic
    
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
```

### 4.2 Sử dụng font

```dart
// Trong Text cụ thể
Text(
  'Custom Font',
  style: TextStyle(fontFamily: 'Poppins'),
)

// Toàn app
ThemeData(
  fontFamily: 'Poppins',
  textTheme: TextTheme(...),
)
```

### 4.3 Google Fonts Package

```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.1.0
```

```dart
import 'package:google_fonts/google_fonts.dart';

// Trong widget
Text(
  'Google Font',
  style: GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
)

// Toàn app
ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
)
```

---

## 5. Dark Mode / Light Mode

### 5.1 Cấu hình trong MaterialApp

```dart
MaterialApp(
  // Light theme
  theme: ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  ),
  
  // Dark theme
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  ),
  
  // Theme mode
  themeMode: ThemeMode.system, // Theo hệ thống
  // ThemeMode.light,  // Luôn light
  // ThemeMode.dark,   // Luôn dark
  
  home: MyHomePage(),
)
```

### 5.2 Toggle Theme (Manual)

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  
  // Hàm thay đổi Theme
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}

// Trong HomeScreen
IconButton(
  icon: Icon(
    Theme.of(context).brightness == Brightness.dark
        ? Icons.light_mode
        : Icons.dark_mode,
  ),
  onPressed: widget.onToggleTheme,
)
```

### 5.3 Check Dark Mode

```dart
// Kiểm tra theme ĐANG ĐƯỢC APP sử dụng
// Tôn trọng: themeMode, user toggle trong app
// Chuẩn nhất khi app có Dark/Light riêng
// Dùng khi: App có setting Dark Mode
bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

// Hoặc
// Kiểm tra Dark Mode của HỆ ĐIỀU HÀNH
// iOS / Android / Windows / macOS
// Không quan tâm app đang dùng theme gì
// Dùng khi: App không có setting riêng, theo hệ thống
bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
```

---

## 6. Custom Theme Extension

```dart
// Định nghĩa extension
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color success;
  final Color warning;
  final Color info;
  
  const CustomColors({
    required this.success,
    required this.warning,
    required this.info,
  });
  
  // Hàm copyWith dùng để tạo bản sao có chỉnh sửa một phần
  @override
  CustomColors copyWith({Color? success, Color? warning, Color? info}) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }
  
  // Hàm nội suy (lerp = linear interpolation) cho ThemeExtension
  // Mỗi màu được blend (trộn, đổi màu) mượt khi đổi theme
  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

// Thêm vào ThemeData
ThemeData(
  extensions: [
    CustomColors(
      success: Colors.green,
      warning: Colors.orange,
      info: Colors.blue,
    ),
  ],
)

// Sử dụng
CustomColors customColors = Theme.of(context).extension<CustomColors>()!;
Container(color: customColors.success)
```

---

## 7. Bài Tập

### Exercise 18: App Theme
Tạo theme app với:
- Primary color: Tím (#6750A4)
- Custom TextTheme
- Rounded buttons và cards
- Input decoration theme

### Exercise 19: Dark Mode Toggle
Tạo settings screen với:
- Switch để toggle dark/light mode
- Theme thay đổi theo switch
- Lưu preference (optional)

---

## 📝 Checklist Bài 7

- [ ] Tạo ThemeData cho app
- [ ] Sử dụng ColorScheme
- [ ] Hiểu TextTheme và cách dùng
- [ ] Thêm custom fonts
- [ ] Implement Dark/Light mode
- [ ] Hoàn thành 2 exercises
