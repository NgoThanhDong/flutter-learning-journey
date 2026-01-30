# Bài 5: Scrollable Widgets - ListView, GridView, ScrollView

## 🎯 Mục tiêu
- Thành thạo ListView và các constructor
- Sử dụng GridView
- Hiểu SingleChildScrollView
- Xử lý scroll hiệu quả

---

## 1. ListView - Danh Sách Cuộn

### 1.1 ListView Constructor Cơ Bản

```dart
// Dùng khi có ÍT items (render tất cả cùng lúc)
ListView( // ListView đơn giản
  children: [
    ListTile(title: Text('Item 1')), // Item đơn giản
    ListTile(title: Text('Item 2')),
    ListTile(title: Text('Item 3')),
  ],
)
```

### 1.2 ListView.builder - KHUYÊN DÙNG

```dart
// Dùng khi có NHIỀU items (chỉ render items visible)
ListView.builder( // ListView.builder
  itemCount: 100, // Số lượng items
  itemBuilder: (context, index) { // Hàm tạo item
    return ListTile( // Item đơn giản
      leading: CircleAvatar(child: Text('$index')), // Avatar
      title: Text('Item $index'), // Tên
      subtitle: Text('Description for item $index'), // Mô tả
      trailing: Icon(Icons.arrow_forward_ios), // Icon
      onTap: () {
        print('Tapped item $index'); // Khi click
      },
    );
  },
)
```

### 1.3 ListView.separated - Có Divider

```dart
ListView.separated( // ListView.separated
  itemCount: 20, // Số lượng items
  
  // Item builder
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'));
  },
  
  // Separator builder
  separatorBuilder: (context, index) {
    return Divider(height: 1);
  },
)
```

### 1.4 ListView Properties

```dart
ListView.builder(
  // Scroll direction
  scrollDirection: Axis.vertical, // hoặc Axis.horizontal
  
  // Reverse
  reverse: false, // False: từ trên xuống, True: từ dưới lên
  
  // Physics (hiệu ứng scroll)
  physics: BouncingScrollPhysics(),       // Bounce như iOS
  // physics: ClampingScrollPhysics(),    // Clamp như Android
  // physics: NeverScrollableScrollPhysics(), // Không scroll được
  
  // Padding
  padding: EdgeInsets.all(16),
  
  // Shrink wrap (co lại vừa content)
  shrinkWrap: true, // Cẩn thận: ảnh hưởng performance
  
  itemCount: items.length, // Số lượng items
  itemBuilder: (context, index) => ..., // Hàm tạo item
)
```

### 1.5 Horizontal ListView

```dart
// SizedBox: Cố định height khi horizontal
SizedBox(
  height: 120, // PHẢI có height khi horizontal
  child: ListView.builder(
    scrollDirection: Axis.horizontal, // Scroll ngang
    itemCount: 10,
    itemBuilder: (context, index) {
      return Container(
        width: 100,
        margin: EdgeInsets.only(right: 12), // Khoảng cách giữa các item
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text('$index')),
      );
    },
  ),
)
```

---

## 2. ListTile - Item Chuẩn

```dart
ListTile(
  // Leading icon/avatar
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://...'),
  ),
  
  // Title
  title: Text('John Doe'),
  
  // Subtitle
  subtitle: Text('Software Developer'),
  
  // Trailing widget
  trailing: Icon(Icons.arrow_forward_ios),
  
  // Dense mode (compact)
  dense: false, // Làm ListTile “gọn” hơn – giảm chiều cao và khoảng cách bên trong
  
  // Content padding
  contentPadding: EdgeInsets.symmetric(horizontal: 16), // Khoảng cách bên trong
  
  // Callback
  onTap: () {}, // Khi click
  onLongPress: () {}, // Khi long press
  
  // Selected state
  selected: false, // selected = true → đây là item đang active
  selectedTileColor: Colors.blue.withOpacity(0.1), // Màu khi chọn
)
```

---

## 3. GridView - Lưới

### 3.1 GridView.count - Số cột cố định

```dart
GridView.count(
  crossAxisCount: 2, // Số cột
  
  // Spacing
  mainAxisSpacing: 10,   // Cách dọc
  crossAxisSpacing: 10,  // Cách ngang
  
  // Child aspect ratio (width / height)
  childAspectRatio: 1.0, // Vuông
  
  padding: EdgeInsets.all(16),
  
  children: [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
    Container(color: Colors.yellow),
  ],
)
```

### 3.2 GridView.builder - Dynamic

```dart
GridView.builder(
  // GridDelegate: Định dạng lưới
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Số cột
    mainAxisSpacing: 10, // Khoảng cách giữa hàng
    crossAxisSpacing: 10, // Khoảng cách giữa cột
    childAspectRatio: 0.75, // Cao hơn rộng
  ),
  
  itemCount: products.length, // Số lượng items
  itemBuilder: (context, index) { // Hàm tạo item
    return ProductCard(product: products[index]);
  },
)
```

### 3.3 GridView.extent - Max Width

```dart
GridView.builder(
  // GridDelegate: Định dạng lưới
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200, // Max width mỗi item
    mainAxisSpacing: 10, // Khoảng cách giữa hàng
    crossAxisSpacing: 10, // Khoảng cách giữa cột
    childAspectRatio: 1.0, // Cao hơn rộng
  ),
  itemCount: 10, // Số lượng items
  itemBuilder: (context, index) => ..., // Hàm tạo item
)
```

---

## 4. SingleChildScrollView

### 4.1 Cơ bản

```dart
// Dùng khi nội dung CÓ THỂ tràn màn hình
SingleChildScrollView(
  child: Column(
    children: [
      Image.network('https://...'),
      Text('Long content...'),
      // ... more content
    ],
  ),
)
```

### 4.2 Properties

```dart
SingleChildScrollView(
  // Scroll direction
  scrollDirection: Axis.vertical, // Trượt dọc
  
  // Padding
  padding: EdgeInsets.all(16), // Khoảng cách bên trong
  
  // Physics
  physics: BouncingScrollPhysics(), // Hiệu ứng bounce
  
  // Reverse
  reverse: false, // False: từ trên xuống, True: từ dưới lên
  
  child: Column(...), // Nội dung
)
```

### 4.3 Với keyboard (Form)

```dart
// Khi bàn phím mở, tự động scroll để TextField visible (ẩn bàn phím)
SingleChildScrollView(
  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Khi kéo scroll để dismiss keyboard
  child: Column(
    children: [
      TextField(...),
      TextField(...),
      TextField(...),
    ],
  ),
)
```

---

## 5. CustomScrollView & Slivers

### 5.1 Giới thiệu Slivers

👉 Những “mảnh” giao diện có thể cuộn, được Flutter ghép lại để tạo một màn hình scroll phức tạp.
Slivers = Scrollable pieces có thể kết hợp với nhau.

```dart
// CustomScrollView: Gộp các Slivers lại
CustomScrollView(
  slivers: [
    // SliverAppBar - AppBar co giãn (collapse / expand) khi scroll
    SliverAppBar(
      expandedHeight: 200, // Khi chưa scroll → cao 200. Scroll xuống → giảm dần về chiều cao AppBar chuẩn (~56)
      floating: false, // False: Ẩn khi cuộn, True: Hiển thị luôn. AppBar KHÔNG tự bật lại ngay khi cuộn lên.
      pinned: true, // True: Luôn fix ở trên, AppBar luôn dính ở trên cùng. Nếu false, Cuộn xuống → AppBar biến mất hoàn toàn
      flexibleSpace: FlexibleSpaceBar( // Phần co giãn theo scroll
        title: Text('My App'),
        background: Image.network(
          'https://picsum.photos/600/400',
          fit: BoxFit.cover,
        ),
      ),
    ),
    
    // SliverList: danh sách cuộn dùng Sliver, tạo item lười biếng (lazy) để tối ưu hiệu năng
    SliverList(
      delegate: SliverChildBuilderDelegate( // Tạo item lười biếng
        (context, index) => ListTile(title: Text('Item $index')),
        childCount: 20, // Số lượng item
      ),
    ),
    
    // SliverGrid: grid cuộn dùng Sliver, ghép chung scroll với các Sliver khác (AppBar, List…)
    SliverGrid(
      // GridDelegate: Định dạng lưới
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Số cột
        mainAxisSpacing: 10, // Khoảng cách giữa hàng
        crossAxisSpacing: 10, // Khoảng cách giữa cột
        childAspectRatio: 1.0, // Cao hơn rộng
      ),
      // delegate: Tạo item lười biếng
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(color: Colors.primaries[index % 18]), // Item
        childCount: 10, // Số lượng item
      ),
    ),
  ],
)
```

### 5.2 SliverAppBar Effects

```dart
SliverAppBar(
  expandedHeight: 250, // Khi chưa scroll → cao 250. Scroll xuống → giảm dần về chiều cao AppBar chuẩn (~56)
  floating: true,   // Hiện khi scroll lên (Khi AppBar thu gọn xong → ẩn)
  pinned: true,     // Luôn hiện thanh nhỏ (Khi AppBar thu gọn xong → vẫn dính trên cùng)
  snap: true,       // Snap về vị trí (Khi AppBar thu gọn xong → snap về vị trí)
  
  // flexibleSpace: Phần co giãn theo scroll
  flexibleSpace: FlexibleSpaceBar(
    title: Text('Title'), // Tiêu đề
    centerTitle: true, // Tiêu đề ở giữa
    background: Image.network(...), // Background
    collapseMode: CollapseMode.parallax, // Hiệu ứng parallax
  ),
  
  // actions: Thêm các action (ví dụ: IconButton)
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}), // Action
  ],
)
```

---

## 6. ScrollController

### 6.1 Scroll to position

```dart
class _MyWidgetState extends State<MyWidget> {
  final ScrollController _scrollController = ScrollController(); // Controller để control scroll
  
  @override
  void dispose() {
    _scrollController.dispose(); // QUAN TRỌNG: Dispose!
    super.dispose();
  }
  
  void _scrollToTop() {
    // Animate to top
    _scrollController.animateTo(
      0, // Position
      duration: Duration(milliseconds: 500), // Thời gian animate
      curve: Curves.easeInOut, // Hiệu ứng animate
    );
  }
  
  void _scrollToBottom() {
    // Animate to bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Position max (Vị trí cuối cùng có thể cuộn tới)
      duration: Duration(milliseconds: 500), // Thời gian animate
      curve: Curves.easeInOut, // Hiệu ứng animate
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController, // Controller để control scroll
        itemCount: 50, // Số lượng item
        itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
      ),
      // FloatingActionButton: Nút cuộn lên
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop, // Khi nhấn nút → scroll lên
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
```

### 6.2 Listen to scroll

```dart
@override
void initState() { // Khi widget được tạo ra
  super.initState();
  _scrollController.addListener(_onScroll); // Add listener để lắng nghe sự kiện scroll
}

void _onScroll() { // Khi scroll
  // Current position
  double offset = _scrollController.offset; // Vị trí hiện tại
  
  // Max scroll extent
  double max = _scrollController.position.maxScrollExtent; // Vị trí cuối cùng có thể cuộn tới
  
  // Check if near bottom (load more)
  if (offset >= max - 200) {
    _loadMore(); // Load thêm
  }
}
```

---

## 7. Pull to Refresh

```dart
// RefreshIndicator: kéo xuống để làm mới dữ liệu (pull-to-refresh)
RefreshIndicator(
  onRefresh: () async { // Khi pull down → refresh
    // Fetch new data
    await fetchData();
  },
  child: ListView.builder(
    itemCount: items.length, // Số lượng item
    itemBuilder: (context, index) => ..., // Item builder
  ),
)
```

---

## 8. Bài Tập

### Exercise 12: Contact List
Tạo danh sách contacts với:
- ListView.separated
- Avatar + Name + Phone
- Divider giữa các items
- Tap để hiện dialog

### Exercise 13: Product Grid
Tạo grid sản phẩm với:
- GridView.builder 2 cột
- Product card (Image, Name, Price)
- Pull to refresh

### Exercise 14: Horizontal Categories
Tạo horizontal scroll categories với:
- Chip/Button cho mỗi category
- Selected state (màu khác)
- Scroll horizontal

---

## 📝 Checklist Bài 5

- [ ] Thành thạo ListView.builder
- [ ] Sử dụng ListView.separated
- [ ] Tạo GridView với 2+ cột
- [ ] Dùng SingleChildScrollView đúng cách
- [ ] Hiểu ScrollController
- [ ] Hoàn thành 3 exercises
