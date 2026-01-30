# Bài 3: Basic Widgets - Text, Container, Image, Icon

## 🎯 Mục tiêu
- Thành thạo các Widget cơ bản nhất
- Hiểu cách styling cho từng Widget
- Biết cách sử dụng BoxDecoration

---

## 1. Text Widget

### 1.1 Cơ bản

```dart
Text('Hello World')

Text(
  'Hello Flutter',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)
```

### 1.2 TextStyle đầy đủ

```dart
Text(
  'Styled Text',
  style: TextStyle(
    // Kích thước
    fontSize: 20,
    
    // Font weight
    fontWeight: FontWeight.w600, // 100-900, normal, bold
    
    // Màu sắc
    color: Colors.black87,
    backgroundColor: Colors.yellow,
    
    // Font family
    fontFamily: 'Roboto',
    
    // Style
    fontStyle: FontStyle.italic,
    
    // Decoration
    decoration: TextDecoration.underline,
    decorationColor: Colors.red,
    decorationStyle: TextDecorationStyle.wavy,
    
    // Letter & Word spacing
    letterSpacing: 2.0,
    wordSpacing: 5.0,
    
    // Line height (1.0 = normal)
    height: 1.5,
    
    // Shadow
    shadows: [
      Shadow(
        color: Colors.grey,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  ),
)
```

### 1.3 Xử lý text dài

```dart
Text(
  'This is a very long text that might overflow...',
  
  // Số dòng tối đa
  maxLines: 2,
  
  // Xử lý khi overflow
  overflow: TextOverflow.ellipsis, // ... ở cuối
  // overflow: TextOverflow.fade,  // Mờ dần
  // overflow: TextOverflow.clip,  // Cắt
  
  // Căn chỉnh
  textAlign: TextAlign.center,
  // TextAlign.left, right, justify
)
```

### 1.4 RichText - Text nhiều style

```dart
RichText(
  text: TextSpan(
    text: 'Hello ',
    style: TextStyle(color: Colors.black),
    children: [
      TextSpan(
        text: 'Flutter',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: '!'),
    ],
  ),
)

// Hoặc dùng Text.rich
Text.rich(
  TextSpan(
    text: 'Price: ',
    children: [
      TextSpan(
        text: '\$99.99',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    ],
  ),
)
```

---

## 2. Container Widget

### 2.1 Cơ bản

```dart
Container(
  child: Text('Hello'),
)
```

### 2.2 Kích thước

```dart
Container(
  width: 200,
  height: 100,
  
  // Constraints
  constraints: BoxConstraints(
    minWidth: 100,
    maxWidth: 300,
    minHeight: 50,
    maxHeight: 200,
  ),
  
  child: Text('Sized Container'),
)
```

### 2.3 Màu sắc và Padding/Margin

```dart
Container(
  // Màu nền (không dùng khi có decoration)
  color: Colors.blue,
  
  // Khoảng cách bên trong
  padding: EdgeInsets.all(16),
  // EdgeInsets.symmetric(horizontal: 20, vertical: 10)
  // EdgeInsets.only(left: 10, top: 20)
  // EdgeInsets.fromLTRB(10, 20, 10, 20)
  
  // Khoảng cách bên ngoài
  margin: EdgeInsets.all(8),
  
  child: Text('Container'),
)
```

### 2.4 BoxDecoration - Styling nâng cao

```dart
Container(
  width: 200,
  height: 100,
  
  decoration: BoxDecoration(
    // Màu nền
    color: Colors.white,
    
    // Gradient
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    
    // Border
    border: Border.all(
      color: Colors.black,
      width: 2,
    ),
    
    // Bo góc
    borderRadius: BorderRadius.circular(12),
    // BorderRadius.only(topLeft: Radius.circular(20))
    
    // Shadow
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0, 4),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ],
  ),
  
  child: Center(child: Text('Styled')),
)
```

### 2.5 Container với hình ảnh

```dart
Container(
  width: 200,
  height: 150,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    image: DecorationImage(
      image: NetworkImage('https://...'),
      fit: BoxFit.cover,
    ),
  ),
)
```

---

## 3. Image Widget

### 3.1 Image từ Internet

```dart
Image.network(
  'https://picsum.photos/300/200',
  
  // Kích thước
  width: 300,
  height: 200,
  
  // Fit mode
  fit: BoxFit.cover,
  // BoxFit.contain, fill, fitWidth, fitHeight, none
  
  // Loading placeholder
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(child: CircularProgressIndicator());
  },
  
  // Error handling
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error, size: 50);
  },
)
```

### 3.2 Image từ Assets

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
```

```dart
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)
```

### 3.3 ClipRRect - Bo góc ảnh

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.network(
    'https://picsum.photos/200',
    width: 200,
    height: 200,
    fit: BoxFit.cover,
  ),
)
```

### 3.4 CircleAvatar

```dart
CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage('https://...'),
  backgroundColor: Colors.grey,
  
  // Hoặc hiển thị text
  // child: Text('AB'),
)
```

---

## 4. Icon Widget

### 4.1 Material Icons

```dart
Icon(
  Icons.favorite,
  size: 30,
  color: Colors.red,
)

Icon(
  Icons.star,
  size: 24,
  color: Colors.amber,
)
```

### 4.2 Icon thường dùng

```dart
Icons.home
Icons.search
Icons.settings
Icons.person
Icons.notifications
Icons.menu
Icons.close
Icons.add
Icons.remove
Icons.edit
Icons.delete
Icons.share
Icons.favorite
Icons.favorite_border
Icons.star
Icons.star_border
Icons.check
Icons.error
Icons.warning
Icons.info
Icons.help
Icons.arrow_back
Icons.arrow_forward
Icons.arrow_drop_down
Icons.more_vert
Icons.more_horiz
```

### 4.3 IconButton

```dart
IconButton(
  icon: Icon(Icons.favorite),
  iconSize: 30,
  color: Colors.red,
  onPressed: () {
    print('Tapped!');
  },
)
```

---

## 5. Các Widget Utility

### 5.1 SizedBox - Khoảng cách/Kích thước

```dart
// Khoảng cách
SizedBox(height: 20) // Vertical spacing
SizedBox(width: 10)  // Horizontal spacing

// Kích thước cố định
SizedBox(
  width: 100,
  height: 50,
  child: ElevatedButton(...),
)

// Full width
SizedBox(
  width: double.infinity,
  child: ElevatedButton(...),
)
```

### 5.2 Padding

```dart
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Padded'),
)
```

### 5.3 Center

```dart
Center(
  child: Text('Centered'),
)
```

### 5.4 Align

```dart
Align(
  alignment: Alignment.topRight, // Căn chỉnh vị trí của widget con
  child: Text('Top Right'),
)
// Alignment.center, topLeft, bottomCenter...
```

### 5.5 Opacity

```dart
Opacity(
  opacity: 0.5, // 0.0 - 1.0
  child: Container(...),
)
```

---

## 6. Card Widget

```dart
Card(
  elevation: 4, // Độ cao của card
  margin: EdgeInsets.all(8), // Khoảng cách với các widget khác
  shape: RoundedRectangleBorder( // Bo góc
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Card Title'),
        Text('Card content'),
      ],
    ),
  ),
)
```

---

## 7. Divider Widget

```dart
Divider(
  height: 20,
  thickness: 1, // Độ dày của đường kẻ
  color: Colors.grey, // Màu của đường kẻ
  indent: 16, // Khoảng cách từ lề trái
  endIndent: 16, // Khoảng cách từ lề phải
)
```

---

## 8. Bài Tập

### Exercise 05: Profile Card
Tạo Profile Card với:
- Avatar (CircleAvatar)
- Tên (Text bold)
- Bio (Text nhỏ, màu xám)
- Location với Icon

### Exercise 06: Product Card
Tạo Product Card với:
- Image (bo góc)
- Tên sản phẩm
- Giá (màu đỏ, bold)
- Rating (Icon star + số)
- Nút "Add to Cart"

### Exercise 07: Social Post Card
Tạo Social Post Card với:
- Header (Avatar + Username + Time)
- Content text
- Image (optional)
- Footer (Like, Comment, Share icons với số)

---

## 📝 Checklist Bài 3

- [ ] Thành thạo Text và TextStyle
- [ ] Thành thạo Container và BoxDecoration
- [ ] Sử dụng Image (network, asset)
- [ ] Sử dụng Icon và IconButton
- [ ] Biết các widget utility (SizedBox, Padding, Center)
- [ ] Hoàn thành 3 exercises
