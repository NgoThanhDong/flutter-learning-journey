# Bài 8: Real UI Practice - Tổng Hợp

## 🎯 Mục tiêu
- Áp dụng tất cả kiến thức đã học
- Xây dựng các màn hình UI thực tế
- Thực hành tư duy thiết kế UI

---

## 1. Phân Tích UI Trước Khi Code

### 1.1 Quy trình

```
1. Nhìn tổng thể màn hình
2. Chia thành các section lớn
3. Phân tích từng section thành Row/Column
4. Xác định widget cần dùng
5. Code từ ngoài vào trong
```

### 1.2 Ví dụ phân tích

```
┌─────────────────────────────────────┐
│ AppBar                              │ ← Scaffold.appBar
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ Cover Image                     │ │ ← Stack
│ │         ┌───────┐               │ │
│ │         │Avatar │               │ │ ← Positioned
│ │         └───────┘               │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Name                                │ ← Column
│ Bio text                            │
│                                     │
│ ┌─────┐ ┌─────┐ ┌─────┐             │ ← Row
│ │Posts│ │Follw│ │Folng│             │
│ │ 123 │ │ 456 │ │ 789 │             │
│ └─────┘ └─────┘ └─────┘             │
│                                     │
│ [   Edit Profile   ]                │ ← ElevatedButton
│                                     │
│ ┌────────────────────────────────┐  │
│ │ GridView of posts              │  │ ← GridView
│ │ ┌────┐ ┌────┐ ┌────┐           │  │
│ │ │    │ │    │ │    │           │  │
│ │ └────┘ └────┘ └────┘           │  │
│ └────────────────────────────────┘  │
└─────────────────────────────────────┘
```

---

## 2. Project 1: Login Screen

### 2.1 Phân tích

```
┌─────────────────────────────────────┐
│                                     │
│           [Logo/Image]              │ ← Image hoặc Icon
│                                     │
│        "Welcome Back!"              │ ← Text (headline)
│     "Login to continue"             │ ← Text (body)
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Email                         │  │ ← TextField
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Password                 👁   │  │ ← TextField + IconButton
│  └───────────────────────────────┘  │
│                                     │
│          "Forgot Password?"         │ ← TextButton
│                                     │
│  ┌───────────────────────────────┐  │
│  │          LOGIN                │  │ ← ElevatedButton
│  └───────────────────────────────┘  │
│                                     │
│         ───── OR ─────              │ ← Row + Divider
│                                     │
│  ┌────┐  ┌────┐  ┌────┐             │
│  │ G  │  │ F  │  │ A  │             │ ← Row + IconButtons
│  └────┘  └────┘  └────┘             │
│                                     │
│    "Don't have account? Sign Up"    │ ← Row + TextButton
│                                     │
└─────────────────────────────────────┘
```

### 2.2 Code mẫu

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // dùng để lấy dữ liệu từ TextField
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // dùng để ẩn/hiện mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // SafeArea để tránh bị che bởi notch và status bar
        child: SingleChildScrollView( // SingleChildScrollView để khi màn hình nhỏ thì có thể cuộn lên
          padding: EdgeInsets.all(24), // padding cho toàn bộ màn hình
          child: Column(
            // crossAxisAlignment.stretch để các widget con chiếm hết chiều rộng của Column
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60), // SizedBox để tạo khoảng cách
              
              // Logo
              Icon(
                Icons.flutter_dash,
                size: 80,
                // lấy màu primary từ theme
                color: Theme.of(context).colorScheme.primary, 
              ),
              
              SizedBox(height: 40), // SizedBox để tạo khoảng cách
              
              // Welcome text
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Login to continue',
                // lấy màu bodyMedium từ theme và thêm màu xám
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 40),
              
              // Email field
              TextField(
                controller: _emailController, // controller để lấy dữ liệu từ TextField
                keyboardType: TextInputType.emailAddress, // keyboardType để hiển thị bàn phím email
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined), // icon email ở bên trái
                ),
              ),
              
              SizedBox(height: 16),
              
              // Password field
              TextField(
                controller: _passwordController, // controller để lấy dữ liệu từ TextField
                obscureText: _obscurePassword, // obscureText để ẩn/hiện mật khẩu
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined), // icon lock ở bên trái
                  suffixIcon: IconButton( // icon để ẩn/hiện mật khẩu
                    icon: Icon(
                      _obscurePassword 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () { // khi nhấn vào icon thì ẩn/hiện mật khẩu
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              
              SizedBox(height: 8),
              
              // Forgot password
              Align( // Align để căn chỉnh vị trí của widget con
                alignment: Alignment.centerRight, // căn chỉnh sang bên phải
                child: TextButton(
                  onPressed: () {}, // khi nhấn vào thì không làm gì cả
                  child: Text('Forgot Password?'), // text forgot password
                ),
              ),
              
              SizedBox(height: 24),
              
              // Login button
              ElevatedButton(
                onPressed: () {}, // khi nhấn vào thì không làm gì cả
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // padding cho button
                ),
                child: Text('LOGIN'), // text login
              ),
              
              SizedBox(height: 24),
              
              // OR divider
              Row(
                children: [
                  Expanded(child: Divider()), // Divider để tạo đường kẻ
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    // text OR
                    child: Text('OR', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Social login
              Row(
                // mainAxisAlignment để căn chỉnh vị trí của widget con
                mainAxisAlignment: MainAxisAlignment.center, // căn chỉnh ở giữa
                children: [
                  _SocialButton(icon: Icons.g_mobiledata, onPressed: () {}), // social button google
                  SizedBox(width: 16),
                  _SocialButton(icon: Icons.facebook, onPressed: () {}), // social button facebook
                  SizedBox(width: 16),
                  _SocialButton(icon: Icons.apple, onPressed: () {}), // social button apple
                ],
              ),
              
              SizedBox(height: 40),
              
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // căn chỉnh ở giữa
                children: [
                  Text("Don't have an account?"), // text don't have an account
                  TextButton(
                    onPressed: () {}, // khi nhấn vào thì không làm gì cả
                    child: Text('Sign Up'), // text sign up
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Social button là một widget con của ProductCard
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  
  const _SocialButton({required this.icon, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return OutlinedButton( // OutlinedButton là một widget button có viền
      onPressed: onPressed, // khi nhấn vào thì thực hiện onPressed
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(12), // padding cho button
        shape: CircleBorder(), // shape của button
      ),
      child: Icon(icon, size: 24), // icon của button
    );
  }
}
```

---

## 3. Project 2: Product Card

### 3.1 Code mẫu

```dart
class ProductCard extends StatelessWidget {
  final String imageUrl; // url của ảnh sản phẩm
  final String name; // tên sản phẩm
  final double price; // giá sản phẩm
  final double rating; // đánh giá sản phẩm
  final VoidCallback? onTap; // khi nhấn vào thì thực hiện onTap
  final VoidCallback? onAddToCart; // khi nhấn vào thì thực hiện onAddToCart
  
  // Constructor của ProductCard
  const ProductCard({
    super.key,
    required this.imageUrl, // url của ảnh sản phẩm
    required this.name, // tên sản phẩm
    required this.price, // giá sản phẩm
    this.rating = 0, // đánh giá sản phẩm
    this.onTap, // khi nhấn vào thì thực hiện onTap
    this.onAddToCart, // khi nhấn vào thì thực hiện onAddToCart
  });
  
  @override
  Widget build(BuildContext context) {
    return Card( // Card là một widget có hình dạng giống như một tấm thẻ
      clipBehavior: Clip.antiAlias, // clipBehavior để cắt widget con, antiAlias là bo góc khử răng cưa
      child: InkWell( // InkWell là một widget cho phép xử lý các tương tác của người dùng
        onTap: onTap, // khi nhấn vào thì thực hiện onTap
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // căn chỉnh các widget con sang bên trái
          children: [
            // Image with badge
            Stack( // Stack là một widget cho phép xếp chồng các widget lên nhau
              children: [
                AspectRatio(
                  aspectRatio: 1, // tỷ lệ khung hình của ảnh
                  child: Image.network( // Image.network là một widget để hiển thị ảnh từ url
                    imageUrl, // url của ảnh sản phẩm
                    fit: BoxFit.cover, // fit: BoxFit.cover là để ảnh lấp đầy khung hình
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200], // màu nền của ảnh
                      child: Icon(Icons.image, size: 40), // icon của ảnh
                    ),
                  ),
                ),
                
                // Sale badge
                Positioned( // Positioned là một widget cho phép đặt widget con ở vị trí cụ thể
                  top: 8, // cách trên 8 pixel
                  left: 8, // cách trái 8 pixel
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // padding cho container
                    decoration: BoxDecoration(
                      color: Colors.red, // màu nền của container
                      borderRadius: BorderRadius.circular(4), // bo góc của container
                    ),
                    child: Text(
                      'SALE', // text sale
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Favorite button
                Positioned( // Positioned là một widget cho phép đặt widget con ở vị trí cụ thể
                  top: 8, // cách trên 8 pixel
                  right: 8, // cách phải 8 pixel
                  child: CircleAvatar(
                    radius: 16, // bán kính của circle avatar
                    backgroundColor: Colors.white, // màu nền của circle avatar
                    child: IconButton(
                      icon: Icon(Icons.favorite_border, size: 16), // icon của button
                      onPressed: () {}, // khi nhấn vào thì thực hiện onPressed
                      padding: EdgeInsets.zero, // padding của button
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(12), // padding cho container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // căn chỉnh các widget con sang bên trái
                children: [
                  // Name
                  Text(
                    name, // tên sản phẩm
                    style: Theme.of(context).textTheme.titleMedium, // style của text
                    maxLines: 2, // số dòng tối đa của text
                    overflow: TextOverflow.ellipsis, // khi text vượt quá số dòng tối đa thì hiển thị ...
                  ),
                  
                  SizedBox(height: 4),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1), // định dạng số với 1 chữ số thập phân
                        style: Theme.of(context).textTheme.bodySmall, // style của text
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Price and Add to cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // căn chỉnh các widget con ở hai đầu
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}', // định dạng số với 2 chữ số thập phân
                        // style của text
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary, // màu của text
                          fontWeight: FontWeight.bold, // in đậm text
                        ),
                      ),
                      IconButton(
                        onPressed: onAddToCart, // khi nhấn vào thì thực hiện onAddToCart
                        icon: Icon(Icons.add_shopping_cart), // icon của button
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary, // màu nền của button
                          foregroundColor: Colors.white, // màu của icon
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 4. Project 3: Profile Screen

### 4.1 Code mẫu

```dart
// ProfileScreen là một widget StatelessWidget
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView( // CustomScrollView là một widget cho phép cuộn nhiều widget con
        slivers: [
          // Collapsing AppBar with cover image
          SliverAppBar( // SliverAppBar là một widget cho phép tạo app bar có thể cuộn
            expandedHeight: 200, // chiều cao của app bar khi không cuộn
            pinned: true, // khi cuộn thì app bar sẽ không bị ẩn đi
            flexibleSpace: FlexibleSpaceBar( // FlexibleSpaceBar là phần nội dung co giãn bên trong SliverAppBar 
              background: Image.network(
                'https://picsum.photos/800/400', // ảnh nền của app bar
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            ],
          ),
          
          // Profile content
          SliverToBoxAdapter( // SliverToBoxAdapter là widget “bọc” để đưa widget bình thường vào thế giới Sliver
            child: Column(
              children: [
                // Avatar (overlapping)
                // Transform.translate là widget dùng để dịch chuyển (move) widget theo trục X / Y mà KHÔNG làm ảnh hưởng layout
                Transform.translate(
                  offset: Offset(0, -50), // offset là khoảng cách dịch chuyển của widget theo trục X / Y
                  child: CircleAvatar( // CircleAvatar là widget dùng để hiển thị avatar hình tròn
                    radius: 50, // bán kính của app bar
                    backgroundColor: Colors.white, // màu nền của app bar
                    child: CircleAvatar(
                      radius: 46, // bán kính của app bar
                      backgroundImage: NetworkImage( // NetworkImage là widget dùng để hiển thị ảnh từ URL
                        'https://i.pravatar.cc/150', // ảnh nền của app bar
                      ),
                    ),
                  ),
                ),
                
                // Name and bio
                Transform.translate(
                  offset: Offset(0, -30),
                  child: Column(
                    children: [
                      Text(
                        'John Doe',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '@johndoe',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Flutter Developer | Tech Enthusiast | Coffee Lover ☕',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Stats
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    // mainAxisAlignment là thuộc tính của widget Row dùng để căn chỉnh các widget con theo chiều ngang
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // căn chỉnh các widget con ở hai đầu, khoảng cách giữa các widget con bằng nhau
                    children: [
                      _StatItem(count: '128', label: 'Posts'),
                      _StatItem(count: '5.2K', label: 'Followers'),
                      _StatItem(count: '342', label: 'Following'),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Action buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded( // Expanded là widget dùng để mở rộng widget con theo chiều ngang
                        child: ElevatedButton( // ElevatedButton là widget dùng để tạo nút có nền
                          onPressed: () {},
                          child: Text('Edit Profile'),
                        ),
                      ),
                      SizedBox(width: 12),
                      OutlinedButton( // OutlinedButton là widget dùng để tạo nút có viền
                        onPressed: () {},
                        child: Icon(Icons.share),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Tab bar for posts
                DefaultTabController( // DefaultTabController là widget dùng để quản lý trạng thái của TabBar
                  length: 3, // số lượng tab
                  child: Column(
                    children: [
                      TabBar( // TabBar là widget dùng để hiển thị các tab
                        tabs: [
                          Tab(icon: Icon(Icons.grid_on)), // Tab là widget dùng để hiển thị một tab
                          Tab(icon: Icon(Icons.video_library)),
                          Tab(icon: Icon(Icons.bookmark_border)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Grid of posts
          SliverPadding( // SliverPadding là widget dùng để thêm padding vào sliver
            padding: EdgeInsets.all(4), // padding của sliver
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // số lượng cột
                mainAxisSpacing: 4, // khoảng cách giữa các cột theo chiều dọc
                crossAxisSpacing: 4, // khoảng cách giữa các cột theo chiều ngang
              ),
              delegate: SliverChildBuilderDelegate( // SliverChildBuilderDelegate là widget dùng để tạo sliver từ một builder
                (context, index) => Image.network( // Image.network là widget dùng để hiển thị ảnh từ URL
                  'https://picsum.photos/200?random=$index', // URL của ảnh
                  fit: BoxFit.cover, // cách hiển thị ảnh
                ),
                childCount: 12, // số lượng sliver
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// _StatItem là widget dùng để hiển thị số lượng bài viết, followers và following
class _StatItem extends StatelessWidget {
  final String count; // số lượng bài viết, followers và following
  final String label; // nhãn của số lượng bài viết, followers và following
  
  const _StatItem({required this.count, required this.label});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text( // Text là widget dùng để hiển thị văn bản
          count, // số lượng bài viết, followers và following
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ), // style của văn bản là titleLarge và in đậm
        ),
        Text( // Text là widget dùng để hiển thị văn bản
          label, // nhãn của số lượng bài viết, followers và following
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ), // style của văn bản là bodySmall và màu xám
        ),
      ],
    );
  }
}
```

---

## 5. Bài Tập

### Exercise 20: Login Screen
Tạo Login screen hoàn chỉnh như mẫu ở trên.

### Exercise 21: E-commerce Home
Tạo trang chủ e-commerce với:
- Search bar
- Horizontal categories
- Banner carousel (đơn giản)
- "Popular Products" section với GridView

### Exercise 22: Chat UI
Tạo màn hình chat với:
- AppBar với avatar và tên
- ListView các tin nhắn (trái phải khác nhau)
- Input bar ở dưới (TextField + Send button)

---

## 📝 Checklist Bài 8

- [ ] Biết phân tích UI trước khi code
- [ ] Xây dựng Login Screen
- [ ] Tạo Product Card component
- [ ] Xây dựng Profile Screen với SliverAppBar
- [ ] Hoàn thành 3 exercises

---

## 🎉 Hoàn thành Phase 2!

Bạn đã học xong Flutter Basics! Tiếp theo:
- **Phase 3: State Management** - Provider, Riverpod
- Quản lý state phức tạp
- Chia sẻ data giữa các màn hình
