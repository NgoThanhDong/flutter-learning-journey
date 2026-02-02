# Bài 6: Practice Projects

## 🎯 Mục tiêu bài học
- Áp dụng kiến thức State Management vào dự án thực tế
- Xây dựng **Shopping Cart** hoàn chỉnh
- Tạo **Notes App** với CRUD operations
- Implement **Theme Switcher** với persistence

---

## 1. Project 1: Shopping Cart

### 1.1. Mô tả

Tạo ứng dụng giỏ hàng đơn giản với các tính năng:
- Danh sách sản phẩm
- Thêm/Xóa sản phẩm vào giỏ
- Cập nhật số lượng
- Tính tổng tiền

### 1.2. Cấu trúc State

```dart
// Model
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  
  Product({required this.id, required this.name, required this.price, required this.imageUrl});
}

class CartItem {
  final Product product;
  int quantity;
  
  CartItem({required this.product, this.quantity = 1});
  
  double get subtotal => product.price * quantity;
}
```

### 1.3. CartNotifier (Provider version)

```dart
class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);
  
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }
  
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
  
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
```

### 1.4. UI Components

```
ProductListScreen
├── AppBar (with cart badge)
└── GridView
    └── ProductCard
        ├── Image
        ├── Name, Price
        └── Add to Cart button

CartScreen
├── AppBar
├── ListView
│   └── CartItemTile
│       ├── Product info
│       ├── Quantity selector (+/-)
│       └── Remove button
├── Total display
└── Checkout button
```

---

## 2. Project 2: Notes App

### 2.1. Mô tả

Ứng dụng ghi chú với đầy đủ CRUD:
- Tạo note mới
- Xem danh sách notes
- Sửa note
- Xóa note
- Tìm kiếm notes

### 2.2. Cấu trúc State

```dart
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? color;
  
  Note({
    required this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.color,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
  
  Note copyWith({String? title, String? content, String? color}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      color: color ?? this.color,
    );
  }
}
```

### 2.3. NotesNotifier (Riverpod version)

```dart
class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);
  
  void addNote(String title, String content, {String? color}) {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      color: color,
    );
    state = [note, ...state]; // Newest first
  }
  
  void updateNote(String id, {String? title, String? content, String? color}) {
    state = state.map((note) {
      if (note.id == id) {
        return note.copyWith(title: title, content: content, color: color);
      }
      return note;
    }).toList();
  }
  
  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
  
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return state;
    return state.where((note) =>
      note.title.toLowerCase().contains(query.toLowerCase()) ||
      note.content.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}

// Provider
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered notes
final filteredNotesProvider = Provider<List<Note>>((ref) {
  final notes = ref.watch(notesProvider);
  final query = ref.watch(searchQueryProvider);
  
  if (query.isEmpty) return notes;
  return notes.where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
    note.content.toLowerCase().contains(query.toLowerCase())
  ).toList();
});
```

### 2.4. UI Components

```
NotesListScreen
├── AppBar with search
├── FloatingActionButton (Add note)
└── GridView/ListView
    └── NoteCard
        ├── Title
        ├── Content preview
        ├── Date
        └── Color indicator

NoteDetailScreen
├── AppBar with edit/delete
├── Title
├── Content
└── Metadata (created, updated)

NoteEditorScreen
├── AppBar with save
├── Title TextField
├── Content TextField
└── Color picker
```

---

## 3. Project 3: Theme Switcher

### 3.1. Mô tả

Theme management với:
- Toggle Dark/Light mode
- Chọn Primary color
- Lưu preference (persist)

### 3.2. ThemeNotifier

```dart
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = Colors.blue;
  
  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  
  bool get isDark => _themeMode == ThemeMode.dark;
  
  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    // TODO: Save to SharedPreferences
  }
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  
  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }
  
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );
  
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
```

### 3.3. Áp dụng vào App

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return MaterialApp(
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.themeMode,
          home: HomeScreen(),
        );
      },
    );
  }
}
```

### 3.4. Settings Screen

```dart
class SettingsScreen extends StatelessWidget {
  final List<Color> colors = [
    Colors.blue, Colors.green, Colors.purple, 
    Colors.orange, Colors.pink, Colors.teal,
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Consumer<ThemeNotifier>(
        builder: (context, theme, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: Text('Dark Mode'),
                value: theme.isDark,
                onChanged: (_) => theme.toggleTheme(),
              ),
              
              ListTile(
                title: Text('Primary Color'),
                subtitle: Wrap(
                  spacing: 8,
                  children: colors.map((color) => 
                    GestureDetector(
                      onTap: () => theme.setPrimaryColor(color),
                      child: CircleAvatar(
                        backgroundColor: color,
                        child: theme.primaryColor == color 
                            ? Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## 📝 Bài tập

### Ex14: Shopping Cart
File: `ex14_shopping_cart.dart`
- Implement CartNotifier với Provider
- Product list + Cart screen
- Add, remove, update quantity
- Total calculation

### Ex15: Notes App
File: `ex15_notes_app.dart`
- Implement với Riverpod
- CRUD operations
- Search functionality
- Color-coded notes

### Ex16: Theme Switcher
File: `ex16_theme_switcher.dart`
- ThemeNotifier với Provider
- Dark/Light toggle
- Primary color selection
- Apply to MaterialApp

---

## 🔑 Tóm tắt

1. **Shopping Cart**: CartNotifier quản lý items, quantity, total
2. **Notes App**: CRUD với StateNotifier, search với Provider.family
3. **Theme Switcher**: ThemeNotifier apply vào MaterialApp
4. **Best Practices**:
   - Immutable state updates (copy, không mutate)
   - Tách business logic ra Notifier class
   - UI chỉ đọc state và gọi methods

---

## 🎉 Hoàn thành Phase 3!

Bạn đã học:
- ✅ setState và giới hạn của nó
- ✅ InheritedWidget - nền tảng của Provider
- ✅ Provider: ChangeNotifier, MultiProvider, Selector
- ✅ Riverpod: StateProvider, StateNotifier, FutureProvider
- ✅ 3 dự án thực tế: Cart, Notes, Theme

---

## ➡️ Tiếp theo

**Phase 4: Navigation & Routing** (GoRouter, Deep linking)
