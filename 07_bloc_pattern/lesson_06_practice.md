# Lesson 06: Practice Projects

Bài này tập hợp 5 dự án thực hành (Mini Projects) để củng cố kiến thức BLoC.

## Danh sách bài tập

### 1. Todo App (Cubit)
- **File**: `exercises/ex16_todo_cubit.dart`
- **Mục tiêu**: CRUD đơn giản (Create, Read, Update, Delete) trên danh sách.
- Sử dụng `Cubit` vì logic Todo khá straightforward (không cần async complex event).

### 2. Weather App (BLoC)
- **File**: `exercises/ex17_weather_bloc.dart`
- **Mục tiêu**: Xử lý API Data chuẩn Clean Architecture.
- States: Initial -> Loading -> Loaded -> Error.
- Input: Tên thành phố -> Fetch API -> Hiển thị nhiệt độ.

### 3. Infinite List (Pagination)
- **File**: `exercises/ex18_infinite_list.dart`
- **Mục tiêu**: Tải dữ liệu phân trang (Load more when scroll to bottom).
- Một trong những use-case **kinh điển** và mạnh mẽ nhất của BLoC.
- Sử dụng `Event Transformer` để debounce (chống spam request).

### 4. Shopping Cart (Complex State)
- **File**: `exercises/ex19_cart_bloc.dart`
- **Mục tiêu**: Quản lý giỏ hàng + danh sách sản phẩm.
- Tương tác giữa các Event: Add, Remove, Checkout.
- Tính toán tổng tiền realtime.

### 5. User Management (Full CRUD)
- **File**: `exercises/ex20_user_management.dart`
- **Mục tiêu**: Ứng dụng quản lý user hoàn chỉnh.
- Kết hợp DI, Repository, BLoC, View, Dialogs.

---

> [!TIP]
> Hãy code theo trình tự từ 16 đến 20. Độ khó sẽ tăng dần.
> Bài 18 (Infinite List) là bài quan trọng nhất vì nó áp dụng kỹ thuật nâng cao (Transformers) mà Cubit khó làm được.
