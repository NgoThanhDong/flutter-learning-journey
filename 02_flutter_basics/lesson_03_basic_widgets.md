# Bài 3: Basic Widgets - Text, Container, Image, Icon

## 🎯 Mục tiêu
- Thành thạo các Widget cơ bản nhất
- Hiểu cách styling cho từng Widget
- Biết cách sử dụng BoxDecoration

---

## 1. Text Widget

### 1.1 Cơ bản

```dart
Text('Hello World') // // Text - Widget để hiển thị chữ

Text(
  'Hello Flutter',
  style: TextStyle( // TextStyle - Widget để hiển thị chữ
    fontSize: 24, // Kích thước chữ
    fontWeight: FontWeight.bold, // Độ đậm của chữ
    color: Colors.blue, // Màu chữ
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
    decoration: TextDecoration.underline, // Gạch chân
    decorationColor: Colors.red, // Màu gạch chân
    decorationStyle: TextDecorationStyle.wavy, // Kiểu gạch chân
    
    // Letter & Word spacing
    letterSpacing: 2.0, // Khoảng cách giữa các chữ
    wordSpacing: 5.0, // Khoảng cách giữa các từ
    
    // Line height (1.0 = normal)
    height: 1.5, // Chiều cao dòng
    
    // Shadow
    shadows: [
      Shadow(
        color: Colors.grey, // Màu bóng
        offset: Offset(2, 2), // Độ lệch bóng (x=2, y=2 -> bóng xuống dưới và sang phải)
        blurRadius: 4, // Độ mờ của bóng
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
// RichText: Widget để hiển thị text với nhiều style khác nhau trong cùng 1 widget
RichText(
  text: TextSpan( // TextSpan: Widget để hiển thị text với nhiều style khác nhau trong cùng 1 widget
    text: 'Hello ',
    style: TextStyle(color: Colors.black), // Style cho text "Hello"
    children: [
      TextSpan(
        text: 'Flutter',
        style: TextStyle( // Style cho text "Flutter"
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: '!'), // Text "!" sẽ kế thừa style từ TextSpan cha
    ],
  ),
)

// Hoặc dùng Text.rich
// Text.rich: Widget để hiển thị text với nhiều style khác nhau trong cùng 1 widget
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

## 2. Container Widget - Tạo khung, nền, bo góc, đổ bóng

### 2.1 Cơ bản

```dart
Container(
  child: Text('Hello'),
)
```

### 2.2 Kích thước

```dart
Container(
  width: 200, // Chiều rộng
  height: 100, // Chiều cao
  
  // Constraints - Ràng buộc kích thước
  constraints: BoxConstraints(
    minWidth: 100, // chiều rộng tối thiểu
    maxWidth: 300, // chiều rộng tối đa
    minHeight: 50, // chiều cao tối thiểu
    maxHeight: 200, // chiều cao tối đa
  ),
  
  child: Text('Sized Container'), // Widget con
)
```

### 2.3 Màu sắc và Padding/Margin

```dart
Container(
  // Màu nền (không dùng khi có decoration)
  color: Colors.blue,
  
  // Khoảng cách bên trong
  padding: EdgeInsets.all(16), // Tạo khoảng cách đều nhau ở tất cả các phía
  // EdgeInsets.symmetric(horizontal: 20, vertical: 10) // Tạo khoảng cách đều nhau ở hai phía đối diện
  // EdgeInsets.only(left: 10, top: 20) // Tạo khoảng cách ở các phía cụ thể
  // EdgeInsets.fromLTRB(10, 20, 10, 20) // Tạo khoảng cách ở các phía: left, top, right, bottom
  
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
    
    // Gradient - Tạo hiệu ứng chuyển màu
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple], // Màu sắc chuyển đổi
      begin: Alignment.topLeft, // Điểm bắt đầu
      end: Alignment.bottomRight, // Điểm kết thúc
    ),
    
    // Border - Tạo viền
    border: Border.all(
      color: Colors.black, // Màu viền
      width: 2, // Độ rộng viền
    ),
    
    // Bo góc
    borderRadius: BorderRadius.circular(12), // Bo tròn tất cả các góc
    // BorderRadius.only(topLeft: Radius.circular(20)) // Bo tròn góc trên bên trái
    
    // Shadow - Tạo bóng đổ
    boxShadow: [
      BoxShadow(
        color: Colors.black26, // Màu bóng
        offset: Offset(0, 4), // Độ lệch bóng (bóng đổ xuống dưới 4px)
        blurRadius: 8, // Độ mờ của bóng (Số càng lớn → bóng càng mềm)
        spreadRadius: 2, // Độ rộng của bóng (> 0 → bóng to ra, < 0 → bóng nhỏ lại)
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
    // Image - Hình ảnh
    image: DecorationImage( // DecorationImage: Widget để hiển thị hình ảnh
      image: NetworkImage('https://...'), // NetworkImage: Widget để hiển thị hình ảnh từ mạng
      fit: BoxFit.cover, // BoxFit.cover: Hình ảnh sẽ lấp đầy khung mà không bị méo
    ),
  ),
)
```

---

## 3. Image Widget

### 3.1 Image từ Internet

```dart
// Image.network: Widget để hiển thị hình ảnh từ mạng
Image.network(
  'https://picsum.photos/300/200',
  
  // Kích thước
  width: 300,
  height: 200,
  
  // Fit mode
  fit: BoxFit.cover, // BoxFit.cover: Hình ảnh sẽ lấp đầy khung mà không bị méo
  // BoxFit.contain: Hình ảnh sẽ lấp đầy khung mà không bị cắt
  // BoxFit.fill: Hình ảnh sẽ lấp đầy khung mà không bị méo
  // BoxFit.fitWidth: Hình ảnh sẽ lấp đầy chiều rộng khung mà không bị méo
  // BoxFit.fitHeight: Hình ảnh sẽ lấp đầy chiều cao khung mà không bị méo
  // BoxFit.none: Hình ảnh sẽ không lấp đầy khung
  
  // loadingBuilder: Widget để hiển thị khi đang tải ảnh
  loadingBuilder: (context, child, loadingProgress) { 
    if (loadingProgress == null) return child; // Nếu không có lỗi thì trả về ảnh
    return Center(child: CircularProgressIndicator()); // Nếu có lỗi thì trả về loading indicator
  },
  
  // errorBuilder: Widget để hiển thị khi có lỗi
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
// Image.asset: Widget để hiển thị hình ảnh từ assets
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)
```

### 3.3 ClipRRect - Bo góc ảnh

```dart
// ClipRRect: Widget để bo góc ảnh
ClipRRect(
  borderRadius: BorderRadius.circular(12), // Bo góc 12px
  child: Image.network( // Image.network: Widget để hiển thị hình ảnh từ mạng
    'https://picsum.photos/200',
    width: 200,
    height: 200,
    fit: BoxFit.cover,
  ),
)
```

### 3.4 CircleAvatar

```dart
// CircleAvatar: Widget để tạo ảnh tròn
CircleAvatar(
  radius: 50, // Bán kính
  backgroundImage: NetworkImage('https://...'), // Ảnh từ mạng
  backgroundColor: Colors.grey, // Màu nền
  
  // Hoặc hiển thị text
  // child: Text('AB'),
)
```

---

## 4. Icon Widget

### 4.1 Material Icons

```dart
// Icon: Widget để hiển thị icon
Icon(
  Icons.favorite, // Icon từ Material Icons
  size: 30, // Kích thước icon
  color: Colors.red, // Màu sắc icon
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
// IconButton: Widget để hiển thị icon có thể bấm
IconButton(
  icon: Icon(Icons.favorite), // Icon từ Material Icons
  iconSize: 30, // Kích thước icon
  color: Colors.red, // Màu sắc icon
  onPressed: () { // Hàm được gọi khi bấm vào icon
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
  width: double.infinity, // Chiều rộng full màn hình
  child: ElevatedButton(...),
)
```

### 5.2 Padding - Tạo khoảng cách bên trong

```dart
Padding(
  padding: EdgeInsets.all(16), // Tạo khoảng cách đều nhau ở tất cả các phía
  child: Text('Padded'),
)
```

### 5.3 Center

```dart
// Center: Widget để căn giữa widget con
Center(
  child: Text('Centered'), // Widget con
)
```

### 5.4 Align

```dart
// Align: Widget để căn chỉnh vị trí của widget con
Align(
  alignment: Alignment.topRight, // Căn chỉnh vị trí của widget con
  child: Text('Top Right'), // Widget con
)
// Alignment.center, topLeft, bottomCenter...
```

### 5.5 Opacity - Độ trong suốt

```dart
// Opacity: Widget để tạo độ trong suốt
Opacity(
  opacity: 0.5, // 0.0 - 1.0
  child: Container(...), // Widget con
)
```

---

## 6. Card Widget

```dart
// Card: Widget có sẵn shadow và bo góc nhẹ, thường dùng để group thông tin
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
// Divider: Widget để tạo đường kẻ ngang
Divider(
  height: 20, // Chiều cao của đường kẻ
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
