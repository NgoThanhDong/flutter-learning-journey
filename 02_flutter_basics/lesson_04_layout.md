# Bài 4: Layout Widgets - Row, Column, Stack, Flex

## 🎯 Mục tiêu
- Thành thạo Row và Column
- Hiểu MainAxisAlignment và CrossAxisAlignment
- Sử dụng Expanded, Flexible, Spacer
- Làm việc với Stack và Positioned

---

## 1. Khái Niệm Cơ Bản

### 1.1 Main Axis vs Cross Axis

```
┌─────────────────────────────────────┐
│  ROW (ngang)                        │
│  Main Axis: ←──────────────────→    │
│  Cross Axis: ↑                      │
│              │                      │
│              ↓                      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  COLUMN (dọc)                       │
│  Main Axis: ↑                       │
│             │                       │
│             ↓                       │
│  Cross Axis: ←──────────────────→   │
└─────────────────────────────────────┘
```

---

## 2. Row Widget - Xếp Ngang

### 2.1 Cơ bản

```dart
Row(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)
```

### 2.2 MainAxisAlignment (căn ngang)

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.start,      // Căn trái (mặc định)
  // MainAxisAlignment.center,                     // Căn giữa
  // MainAxisAlignment.end,                        // Căn phải
  // MainAxisAlignment.spaceBetween,               // Cách đều, không có khoảng 2 đầu
  // MainAxisAlignment.spaceAround,                // Cách đều, khoảng 2 đầu = 1/2
  // MainAxisAlignment.spaceEvenly,                // Cách đều hoàn toàn
  
  children: [...],
)
```

**Hình minh họa:**

```
start:        [A][B][C]____________
center:       ____[A][B][C]________
end:          ____________[A][B][C]
spaceBetween: [A]_____[B]_____[C]
spaceAround:  _[A]___[B]___[C]_
spaceEvenly:  __[A]__[B]__[C]__
```

### 2.3 CrossAxisAlignment (căn dọc)

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.center,   // Căn giữa (mặc định)
  // CrossAxisAlignment.start,                     // Căn trên
  // CrossAxisAlignment.end,                       // Căn dưới
  // CrossAxisAlignment.stretch,                   // Kéo dài full chiều cao
  // CrossAxisAlignment.baseline,                  // Căn theo baseline text
  
  children: [...],
)
```

### 2.4 Ví dụ thực tế: Header

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Left: Back button
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {},
    ),
    
    // Center: Title
    Text('Profile', style: TextStyle(fontSize: 18)),
    
    // Right: Actions
    Row(
      children: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    ),
  ],
)
```

---

## 3. Column Widget - Xếp Dọc

### 3.1 Cơ bản

```dart
Column(
  children: [
    Text('Line 1'),
    Text('Line 2'),
    Text('Line 3'),
  ],
)
```

### 3.2 MainAxisAlignment (căn dọc)

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [...],
)
```

### 3.3 CrossAxisAlignment (căn ngang)

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
  children: [
    Text('Title'),
    Text('Subtitle with longer text'),
    Text('Body'),
  ],
)
```

### 3.4 MainAxisSize

```dart
Column(
  mainAxisSize: MainAxisSize.min, // Co lại vừa đủ children
  // MainAxisSize.max,            // Chiếm hết không gian (mặc định)
  children: [...],
)
```

---

## 4. Expanded & Flexible

### 4.1 Expanded - Chiếm hết không gian còn lại

```dart
Row(
  children: [
    Container(width: 50, color: Colors.red),
    Expanded(
      child: Container(color: Colors.green), // Chiếm hết phần còn lại
    ),
    Container(width: 50, color: Colors.blue),
  ],
)
```

### 4.2 Flex - Chia tỷ lệ

```dart
Row(
  children: [
    Expanded(
      flex: 1, // 1 phần
      child: Container(color: Colors.red),
    ),
    Expanded(
      flex: 2, // 2 phần
      child: Container(color: Colors.green),
    ),
    Expanded(
      flex: 1, // 1 phần
      child: Container(color: Colors.blue),
    ),
  ],
)
// Kết quả: Red 25% | Green 50% | Blue 25%
```

### 4.3 Flexible vs Expanded

```dart
// Expanded: PHẢI chiếm hết không gian được phân bổ
Expanded(child: Container(...))

// Flexible: CÓ THỂ nhỏ hơn không gian được phân bổ
Flexible(
  fit: FlexFit.loose, // Có thể nhỏ hơn
  // fit: FlexFit.tight, // Bằng Expanded
  child: Container(...),
)
```

### 4.4 Spacer - Khoảng trống linh hoạt

```dart
Row(
  children: [
    Text('Left'),
    Spacer(), // Đẩy 2 text sang 2 đầu
    Text('Right'),
  ],
)

// Với flex
Row(
  children: [
    Text('A'),
    Spacer(flex: 1),
    Text('B'),
    Spacer(flex: 2), // Gấp đôi khoảng cách trước
    Text('C'),
  ],
)
```

---

## 5. Stack Widget - Chồng Chéo

### 5.1 Cơ bản

```dart
Stack(
  children: [
    // Bottom layer (phía dưới)
    Container(
      width: 200,
      height: 200,
      color: Colors.blue,
    ),
    // Top layer (phía trên)
    Container(
      width: 100,
      height: 100,
      color: Colors.red,
    ),
  ],
)
```

### 5.2 Alignment

```dart
Stack(
  alignment: Alignment.center, // Căn giữa tất cả
  // alignment: Alignment.topRight,
  children: [...],
)
```

### 5.3 Positioned - Vị trí chính xác

```dart
Stack(
  children: [
    // Background
    Container(
      width: 300,
      height: 200,
      color: Colors.grey[200],
    ),
    
    // Top-left corner
    Positioned(
      top: 10,
      left: 10,
      child: Icon(Icons.star),
    ),
    
    // Bottom-right corner
    Positioned(
      bottom: 10,
      right: 10,
      child: Text('Badge'),
    ),
    
    // Center with size
    Positioned(
      top: 50,
      left: 50,
      width: 100,
      height: 100,
      child: Container(color: Colors.blue),
    ),
    
    // Fill (stretch to edges)
    Positioned.fill(
      child: Container(color: Colors.black26),
    ),
  ],
)
```

### 5.4 Ví dụ: Badge trên Icon

```dart
Stack(
  clipBehavior: Clip.none, // Cho phép tràn ra ngoài
  children: [
    Icon(Icons.shopping_cart, size: 30),
    Positioned(
      top: -5,
      right: -5,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '3',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    ),
  ],
)
```

### 5.5 Ví dụ: Image với overlay

```dart
Stack(
  children: [
    // Image
    Image.network(
      'https://picsum.photos/300/200',
      width: 300,
      height: 200,
      fit: BoxFit.cover,
    ),
    
    // Gradient overlay
    Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black54],
          ),
        ),
      ),
    ),
    
    // Text at bottom
    Positioned(
      bottom: 16,
      left: 16,
      child: Text(
        'Image Title',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  ],
)
```

---

## 6. Wrap Widget - Tự động xuống dòng

```dart
Wrap(
  spacing: 8,          // Khoảng cách ngang
  runSpacing: 8,       // Khoảng cách dọc
  alignment: WrapAlignment.start,
  
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Mobile')),
    Chip(label: Text('Web')),
    Chip(label: Text('Desktop')),
    // Tự động xuống dòng nếu không đủ chỗ
  ],
)
```

---

## 7. LayoutBuilder - Responsive

```dart
LayoutBuilder(
  builder: (context, constraints) {
    // constraints chứa maxWidth, maxHeight
    
    if (constraints.maxWidth > 600) {
      // Desktop layout
      return Row(
        children: [
          Expanded(child: LeftPanel()),
          Expanded(flex: 2, child: MainContent()),
        ],
      );
    } else {
      // Mobile layout
      return Column(
        children: [
          MainContent(),
        ],
      );
    }
  },
)
```

---

## 8. Lỗi Thường Gặp

### 8.1 Unbounded height trong Column

```dart
// ❌ LỖI: Column trong ListView không có bounds
ListView(
  children: [
    Column(
      children: [...], // Error!
    ),
  ],
)

// ✅ SỬA: Dùng shrinkWrap hoặc fixed height
ListView(
  children: [
    Column(
      mainAxisSize: MainAxisSize.min, // Hoặc wrap trong SizedBox
      children: [...],
    ),
  ],
)
```

### 8.2 Overflow

```dart
// ❌ LỖI: Tràn khi text quá dài
Row(
  children: [
    Text('Very very very long text...'),
    Icon(Icons.star),
  ],
)

// ✅ SỬA: Dùng Expanded hoặc Flexible
Row(
  children: [
    Expanded(
      child: Text(
        'Very very very long text...',
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Icon(Icons.star),
  ],
)
```

---

## 9. Bài Tập

### Exercise 08: Navigation Bar
Tạo Bottom Navigation Bar với:
- 4 icons: Home, Search, Favorites, Profile
- Icon active có màu khác
- Label dưới mỗi icon

### Exercise 09: Price Row
Tạo Row hiển thị:
- Tên sản phẩm (bên trái, Expanded)
- Số lượng (giữa)
- Giá (bên phải, bold)

### Exercise 10: Profile Header
Tạo header với Stack:
- Cover image full width
- Avatar chồng lên giữa cover và content
- Tên và bio bên dưới

### Exercise 11: Grid Layout
Tạo layout 2 cột với:
- Mỗi item là Card
- Sử dụng Wrap hoặc GridView

---

## 📝 Checklist Bài 4

- [ ] Thành thạo Row và Column
- [ ] Hiểu MainAxisAlignment và CrossAxisAlignment
- [ ] Sử dụng Expanded, Flexible, Spacer
- [ ] Làm việc với Stack và Positioned
- [ ] Biết Wrap và LayoutBuilder
- [ ] Hoàn thành 4 exercises
