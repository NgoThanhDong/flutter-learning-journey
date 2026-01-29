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
ListView(
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
    ListTile(title: Text('Item 3')),
  ],
)
```

### 1.2 ListView.builder - KHUYÊN DÙNG

```dart
// Dùng khi có NHIỀU items (chỉ render items visible)
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(child: Text('$index')),
      title: Text('Item $index'),
      subtitle: Text('Description for item $index'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        print('Tapped item $index');
      },
    );
  },
)
```

### 1.3 ListView.separated - Có Divider

```dart
ListView.separated(
  itemCount: 20,
  
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
  reverse: false,
  
  // Physics (hiệu ứng scroll)
  physics: BouncingScrollPhysics(),       // Bounce như iOS
  // physics: ClampingScrollPhysics(),    // Clamp như Android
  // physics: NeverScrollableScrollPhysics(), // Không scroll được
  
  // Padding
  padding: EdgeInsets.all(16),
  
  // Shrink wrap (co lại vừa content)
  shrinkWrap: true, // Cẩn thận: ảnh hưởng performance
  
  itemCount: items.length,
  itemBuilder: (context, index) => ...,
)
```

### 1.5 Horizontal ListView

```dart
SizedBox(
  height: 120, // PHẢI có height khi horizontal
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 10,
    itemBuilder: (context, index) {
      return Container(
        width: 100,
        margin: EdgeInsets.only(right: 12),
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
  dense: false,
  
  // Content padding
  contentPadding: EdgeInsets.symmetric(horizontal: 16),
  
  // Callback
  onTap: () {},
  onLongPress: () {},
  
  // Selected state
  selected: false,
  selectedTileColor: Colors.blue.withOpacity(0.1),
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
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 0.75, // Cao hơn rộng
  ),
  
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)
```

### 3.3 GridView.extent - Max Width

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200, // Max width mỗi item
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 1.0,
  ),
  itemCount: 10,
  itemBuilder: (context, index) => ...,
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
  scrollDirection: Axis.vertical,
  
  // Padding
  padding: EdgeInsets.all(16),
  
  // Physics
  physics: BouncingScrollPhysics(),
  
  // Reverse
  reverse: false,
  
  child: Column(...),
)
```

### 4.3 Với keyboard (Form)

```dart
// Khi bàn phím mở, tự động scroll để TextField visible
SingleChildScrollView(
  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

Slivers = Scrollable pieces có thể kết hợp với nhau.

```dart
CustomScrollView(
  slivers: [
    // SliverAppBar - AppBar co giãn
    SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('My App'),
        background: Image.network(
          'https://picsum.photos/600/400',
          fit: BoxFit.cover,
        ),
      ),
    ),
    
    // SliverList
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Item $index')),
        childCount: 20,
      ),
    ),
    
    // SliverGrid
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(color: Colors.primaries[index % 18]),
        childCount: 10,
      ),
    ),
  ],
)
```

### 5.2 SliverAppBar Effects

```dart
SliverAppBar(
  expandedHeight: 250,
  floating: true,   // Hiện khi scroll lên
  pinned: true,     // Luôn hiện thanh nhỏ
  snap: true,       // Snap về vị trí
  
  flexibleSpace: FlexibleSpaceBar(
    title: Text('Title'),
    centerTitle: true,
    background: Image.network(...),
    collapseMode: CollapseMode.parallax,
  ),
  
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)
```

---

## 6. ScrollController

### 6.1 Scroll to position

```dart
class _MyWidgetState extends State<MyWidget> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose(); // QUAN TRỌNG: Dispose!
    super.dispose();
  }
  
  void _scrollToTop() {
    _scrollController.animateTo(
      0, // Position
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 50,
        itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
```

### 6.2 Listen to scroll

```dart
@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
}

void _onScroll() {
  // Current position
  double offset = _scrollController.offset;
  
  // Max scroll extent
  double max = _scrollController.position.maxScrollExtent;
  
  // Check if near bottom (load more)
  if (offset >= max - 200) {
    _loadMore();
  }
}
```

---

## 7. Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    // Fetch new data
    await fetchData();
  },
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ...,
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
