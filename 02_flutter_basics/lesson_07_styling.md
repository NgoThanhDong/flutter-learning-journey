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
MaterialApp(
  theme: ThemeData(
    // Primary color
    primarySwatch: Colors.blue,
    
    // Color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    
    // Use Material 3
    useMaterial3: true,
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
  scaffoldBackgroundColor: Colors.grey[50],
  
  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  
  // Card
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  // ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  
  // TextButton
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
    ),
  ),
  
  // OutlinedButton
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  
  // Input (TextField)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  
  // FloatingActionButton
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  
  // ListTile
  listTileTheme: ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
  ),
  
  // Divider
  dividerTheme: DividerThemeData(
    thickness: 1,
    color: Colors.grey[300],
  ),
  
  // Icon
  iconTheme: IconThemeData(
    color: Colors.grey[700],
    size: 24,
  ),
  
  // Text
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  ),
)
```

---

## 2. ColorScheme

### 2.1 Tạo từ seed color

```dart
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
colors.primaryContainer
colors.onPrimaryContainer

colors.secondary      // Màu phụ
colors.onSecondary
colors.secondaryContainer
colors.onSecondaryContainer

colors.tertiary       // Màu thứ 3
colors.error          // Màu lỗi
colors.onError

colors.background     // Màu nền
colors.onBackground   // Màu text trên nền
colors.surface        // Màu bề mặt (card, dialog)
colors.onSurface

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

## 3. TextTheme

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
bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

// Hoặc
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
  
  @override
  CustomColors copyWith({Color? success, Color? warning, Color? info}) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }
  
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
