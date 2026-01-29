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
│ ┌─────┐ ┌─────┐ ┌─────┐            │ ← Row
│ │Posts│ │Follw│ │Folng│            │
│ │ 123 │ │ 456 │ │ 789 │            │
│ └─────┘ └─────┘ └─────┘            │
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
│  │          LOGIN               │  │ ← ElevatedButton
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60),
              
              // Logo
              Icon(
                Icons.flutter_dash,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              
              SizedBox(height: 40),
              
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 40),
              
              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              
              SizedBox(height: 8),
              
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?'),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Login button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('LOGIN'),
              ),
              
              SizedBox(height: 24),
              
              // OR divider
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Social login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(icon: Icons.g_mobiledata, onPressed: () {}),
                  SizedBox(width: 16),
                  _SocialButton(icon: Icons.facebook, onPressed: () {}),
                  SizedBox(width: 16),
                  _SocialButton(icon: Icons.apple, onPressed: () {}),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {},
                    child: Text('Sign Up'),
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  
  const _SocialButton({required this.icon, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(12),
        shape: CircleBorder(),
      ),
      child: Icon(icon, size: 24),
    );
  }
}
```

---

## 3. Project 2: Product Card

### 3.1 Code mẫu

```dart
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.rating = 0,
    this.onTap,
    this.onAddToCart,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: 40),
                    ),
                  ),
                ),
                
                // Sale badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SALE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border, size: 16),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 4),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Price and Add to cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: onAddToCart,
                        icon: Icon(Icons.add_shopping_cart),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
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
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing AppBar with cover image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://picsum.photos/800/400',
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            ],
          ),
          
          // Profile content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Avatar (overlapping)
                Transform.translate(
                  offset: Offset(0, -50),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Edit Profile'),
                        ),
                      ),
                      SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        child: Icon(Icons.share),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Tab bar for posts
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.grid_on)),
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
          SliverPadding(
            padding: EdgeInsets.all(4),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Image.network(
                  'https://picsum.photos/200?random=$index',
                  fit: BoxFit.cover,
                ),
                childCount: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  
  const _StatItem({required this.count, required this.label});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
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
