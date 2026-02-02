# Bài 1: Tổng quan State Management

## 🎯 Mục tiêu bài học
- Hiểu **State** là gì trong Flutter
- Phân biệt **Local State** vs **Global State**
- Hiểu vấn đề **Prop Drilling** và tại sao cần State Management
- So sánh các giải pháp: setState, Provider, Riverpod, BLoC

---

## 1. State là gì?

### Định nghĩa đơn giản
> **State** = Dữ liệu có thể thay đổi theo thời gian và ảnh hưởng đến giao diện.

### Ví dụ thực tế
Hãy tưởng tượng bạn đang lướt Shopee:

| Hành động | State thay đổi | UI thay đổi |
|-----------|---------------|-------------|
| Bấm "Add to Cart" | `cartItems: [item1]` | Icon giỏ hàng hiện số 1 |
| Bấm Like sản phẩm | `isLiked: true` | Tim chuyển đỏ ❤️ |
| Chọn Dark Mode | `isDarkMode: true` | Toàn bộ app đổi màu tối |
| Đăng nhập | `user: {name: "John"}` | Hiện avatar, tên user |

### Kết luận
**State = Dữ liệu mà khi thay đổi → UI phải cập nhật theo.**

---

## 2. Phân loại State

### 2.1. Local State (Ephemeral State)
- Chỉ dùng trong **1 widget duy nhất**
- Không cần chia sẻ với widget khác
- Dùng `setState()` là đủ

**Ví dụ:**
```dart
// Trạng thái mở/đóng của dropdown
bool _isExpanded = false;

// Nội dung đang gõ trong TextField
String _searchQuery = '';

// Tab đang được chọn
int _currentTabIndex = 0;
```

### 2.2. Global State (App State)
- Dùng ở **nhiều nơi** trong app
- Cần chia sẻ giữa nhiều widget/screen
- Cần **State Management solution**

**Ví dụ:**
```dart
// Thông tin user đăng nhập (dùng ở Profile, Settings, Header...)
User? currentUser;

// Giỏ hàng (dùng ở Product List, Cart Screen, Checkout...)
List<CartItem> cartItems;

// Theme setting (ảnh hưởng toàn bộ app)
bool isDarkMode;

// Ngôn ngữ app
String locale;
```

### 2.3. Bảng so sánh

| Tiêu chí | Local State | Global State |
|----------|-------------|--------------|
| Phạm vi | 1 widget | Toàn app |
| Giải pháp | setState | Provider/Riverpod/BLoC |
| Ví dụ | Checkbox checked, TextField text | User info, Cart, Theme |

---

## 3. Vấn đề Prop Drilling

### 3.1. Prop Drilling là gì?

Khi bạn cần truyền dữ liệu từ widget cha xuống widget con qua **nhiều tầng**, bạn phải "khoan" (drill) prop xuyên qua tất cả các widget trung gian.

### 3.2. Ví dụ minh họa

**Tình huống**: Hiển thị tên user ở nhiều nơi

```
App (có user data)
  └── HomePage
        └── MainContent
              └── SideBar
                    └── UserAvatar  ← Cần user.name
```

**Code xấu (Prop Drilling):**
```dart
class App extends StatelessWidget {
  final user = User(name: 'John');
  
  @override
  Widget build(BuildContext context) {
    // Phải truyền user xuống HomePage
    return HomePage(user: user);
  }
}

class HomePage extends StatelessWidget {
  final User user; // Nhận vào, chỉ để truyền tiếp!
  
  @override
  Widget build(BuildContext context) {
    // Lại phải truyền xuống MainContent
    return MainContent(user: user);
  }
}

class MainContent extends StatelessWidget {
  final User user; // Nhận vào, chỉ để truyền tiếp!
  
  @override
  Widget build(BuildContext context) {
    return SideBar(user: user);
  }
}

class SideBar extends StatelessWidget {
  final User user; // Nhận vào, chỉ để truyền tiếp!
  
  @override
  Widget build(BuildContext context) {
    return UserAvatar(user: user);
  }
}

class UserAvatar extends StatelessWidget {
  final User user; // CUỐI CÙNG mới dùng!
  
  @override
  Widget build(BuildContext context) {
    return Text(user.name);
  }
}
```

### 3.3. Vấn đề của Prop Drilling

| Vấn đề | Mô tả |
|--------|-------|
| **Code dài dòng** | Mỗi widget trung gian đều phải nhận và truyền prop |
| **Khó maintain** | Thêm/xóa prop → Sửa nhiều file |
| **Performance** | Widget trung gian rebuild dù không dùng prop |
| **Khó test** | Widget phụ thuộc vào widget cha |

### 3.4. Giải pháp: State Management

Với Provider/Riverpod, `UserAvatar` có thể trực tiếp lấy user mà không cần truyền qua các widget trung gian:

```dart
class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy trực tiếp từ Provider, không cần prop!
    final user = context.watch<User>();
    return Text(user.name);
  }
}
```

---

## 4. So sánh các giải pháp State Management

### 4.1. Bảng tổng hợp

| Giải pháp | Độ khó | Phù hợp với | Ưu điểm | Nhược điểm |
|-----------|--------|-------------|---------|------------|
| **setState** | ⭐ | App nhỏ, local state | Đơn giản, built-in | Không scale được |
| **InheritedWidget** | ⭐⭐ | Tìm hiểu, ít dùng trực tiếp | Built-in, cơ sở Provider | Boilerplate nhiều |
| **Provider** | ⭐⭐ | App vừa & lớn | Dễ học, phổ biến | Cần BuildContext |
| **Riverpod** | ⭐⭐⭐ | App mới, team có kinh nghiệm | Compile-safe, testable | Cú pháp mới lạ hơn |
| **BLoC** | ⭐⭐⭐⭐ | App enterprise, logic phức tạp | Tách biệt rõ ràng, reactive | Boilerplate nhiều |

- Boilerplate = phần code “thủ tục bắt buộc”
- Càng nhiều boilerplate → càng mệt khi viết & đọc
- Dev chê “boilerplate nhiều” = “viết mỏi tay mà logic chẳng bao nhiêu” 😆

### 4.2. Khuyến nghị theo loại project

| Loại project | Nên dùng | Lý do |
|--------------|----------|-------|
| **App học tập, nhỏ** | setState | Đơn giản, tập trung học Flutter |
| **App cá nhân, vừa** | Provider | Đủ mạnh, cộng đồng lớn |
| **App production mới** | Riverpod | Hiện đại, ít bug hơn |
| **App enterprise (doanh nghiệp)** | BLoC | Cấu trúc rõ ràng, team lớn dễ maintain (bảo trì) |

---

## 5. Lộ trình học trong Phase này

```
Bài 1: Overview (Bạn đang ở đây!)
    ↓
Bài 2: setState & InheritedWidget
    ↓ (Hiểu cơ bản)
Bài 3: Provider Basics
    ↓
Bài 4: Provider Advanced
    ↓ (Thành thạo Provider)
Bài 5: Riverpod
    ↓ (Giải pháp hiện đại)
Bài 6: Practice Projects
```

---

## 🔑 Tóm tắt

1. **State** = Dữ liệu thay đổi → UI cập nhật
2. **Local State** (1 widget) → `setState`
3. **Global State** (toàn app) → Provider/Riverpod
4. **Prop Drilling** = Anti-pattern, tránh bằng State Management
5. **Provider** = Đủ tốt cho hầu hết apps
6. **Riverpod** = Giải pháp hiện đại hơn

---

## ➡️ Tiếp theo

[Bài 2: setState & InheritedWidget](lesson_02_setstate.md)
