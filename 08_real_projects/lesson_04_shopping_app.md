# Lesson 04: Shopping App - Ứng Dụng Mua Sắm với Cart Management

> 🛒 Xây dựng ứng dụng shopping với product catalog và giỏ hàng

---

## 🎯 Mục Tiêu

Trong bài này, bạn sẽ xây dựng Shopping App hoàn chỉnh với:

- ✅ **Product Models** với categories và variants
- ✅ **Cart Management** với Cubit
- ✅ **Product Listing** với filters và search
- ✅ **Product Detail** screen
- ✅ **Checkout Flow** (mock)
- ✅ **UI/UX** với animations và responsive design

---

## 🏗️ Kiến Trúc Shopping App

```
┌─────────────────────────────────────────────────────────────┐
│                         APP                                 │
│                                                              │
│   ProductsScreen    ProductDetailScreen    CartScreen      │
│        │                    │                   │           │
│        └────────────────────┼───────────────────┘           │
│                             │                               │
│                             ▼                               │
│    ┌──────────────────────────────────────────┐            │
│    │               CartCubit                   │            │
│    │  (Quản lý giỏ hàng, tính tổng, coupons)  │            │
│    └──────────────────────────────────────────┘            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 Data Models

### Product Model
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;     // Giá sale (optional)
  final String imageUrl;
  final String category;
  final int stock;
  final double rating;
  final int reviewCount;
}
```

### Cart Item Model
```dart
class CartItem {
  final Product product;
  final int quantity;
  
  double get subtotal => product.effectivePrice * quantity;
}
```

### Cart State
```dart
class CartState {
  final List<CartItem> items;
  final String? couponCode;
  final double discount;
  
  double get subtotal;      // Tổng trước discount
  double get total;         // Tổng sau discount
  int get itemCount;        // Số loại sản phẩm
  int get totalQuantity;    // Tổng số lượng
}
```

---

## 📝 Exercises

### Ex11: Product Model (`ex11_product_model.dart`)

**Học được gì:**
- Product và Category models
- Price calculations (sale, discount)
- Image URL handling
- Sample data generation

### Ex12: Cart Cubit (`ex12_cart_cubit.dart`)

**Học được gì:**
- Cart state management
- Add/remove/update quantity
- Coupon code logic
- Total calculations

### Ex13: Product List Screen (`ex13_product_list_screen.dart`)

**Học được gì:**
- Grid và List layouts
- Category filtering
- Search functionality
- Sort options
- Product cards

### Ex14: Product Detail Screen (`ex14_product_detail_screen.dart`)

**Học được gì:**
- Image gallery
- Size/color selection
- Add to cart action
- Related products
- Review section

### Ex15: Shopping App Complete (`ex15_shopping_app_complete.dart`)

**Học được gì:**
- Bottom navigation
- Cart badge
- Checkout flow
- Order confirmation

---

## 🔑 Key Concepts

### 1. Cart State Management

```dart
// Cart Item với quantity
class CartItem extends Equatable {
  final Product product;
  final int quantity;
  
  CartItem copyWith({int? quantity}) => CartItem(
    product: product,
    quantity: quantity ?? this.quantity,
  );
}

// Cart Cubit
class CartCubit extends Cubit<CartState> {
  void addToCart(Product product) {
    final existing = state.items.firstWhereOrNull(
      (item) => item.product.id == product.id,
    );
    
    if (existing != null) {
      // Increase quantity
      final updated = state.items.map((item) =>
        item.product.id == product.id
          ? item.copyWith(quantity: item.quantity + 1)
          : item
      ).toList();
      emit(state.copyWith(items: updated));
    } else {
      // Add new item
      emit(state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: 1)],
      ));
    }
  }
}
```

### 2. Product Filtering

```dart
// State với filters
class ProductsState {
  final List<Product> allProducts;
  final String? selectedCategory;
  final String searchQuery;
  final ProductSort sortBy;
  
  List<Product> get filteredProducts {
    var result = allProducts;
    
    // Category filter
    if (selectedCategory != null) {
      result = result.where((p) => p.category == selectedCategory).toList();
    }
    
    // Search
    if (searchQuery.isNotEmpty) {
      result = result.where((p) =>
        p.name.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    // Sort
    result.sort((a, b) => switch (sortBy) {
      ProductSort.priceLow => a.price.compareTo(b.price),
      ProductSort.priceHigh => b.price.compareTo(a.price),
      ProductSort.rating => b.rating.compareTo(a.rating),
      ProductSort.name => a.name.compareTo(b.name),
    });
    
    return result;
  }
}
```

### 3. Responsive Product Grid

```dart
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // Responsive columns
    final crossAxisCount = switch (width) {
      > 1200 => 4,
      > 800 => 3,
      > 600 => 2,
      _ => 2,
    };
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.7,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => ProductCard(product: products[i]),
    );
  }
}
```

---

## 🎨 UI Components

### Product Card
```
┌─────────────────────┐
│      [IMAGE]        │
│                     │
├─────────────────────┤
│ ❤️     Category     │
│                     │
│ Product Name        │
│ ⭐ 4.5 (120 reviews)│
│                     │
│ $99.00  $149.00     │
│ (strikethrough)     │
│                     │
│ [Add to Cart] 🛒    │
└─────────────────────┘
```

### Cart Item
```
┌───────────────────────────────────────────┐
│ [IMG] │ Product Name           │ $99.00  │
│       │ Category               │         │
│       │ [-] 2 [+]  | 🗑️ Remove │ $198.00 │
└───────────────────────────────────────────┘
```

---

## 📦 Packages Sử Dụng

| Package | Mục đích |
|---------|----------|
| `flutter_bloc` | Cart state management |
| `cached_network_image` | Image caching |
| `shimmer` | Loading placeholders |
| `intl` | Price formatting |

---

## 🚀 Chạy Shopping App

```bash
cd 08_real_projects/projects_app
flutter run -d chrome
```

Chọn **"🛒 Shopping App"** từ menu.

---

## ▶️ Bước Tiếp Theo

Sau khi hoàn thành Shopping App, tiếp tục với:

➡️ [Lesson 05: Portfolio App](./lesson_05_portfolio_app.md)

---

## 📋 Checklist

- [ ] Hiểu Product model design
- [ ] Implement Cart state management
- [ ] Tạo responsive product grid
- [ ] Xây dựng product detail page
- [ ] Implement filtering và sorting
- [ ] Tạo checkout flow
