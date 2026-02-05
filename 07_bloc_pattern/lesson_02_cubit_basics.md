# Lesson 02: Cubit Basics (Simplified BLoC)

## 1. Cubit là gì?

**Cubit** là một phiên bản đơn giản hóa của BLoC.
- Nó quản lý State của ứng dụng.
- Nó **không dùng Events** (như BLoC chuẩn) mà dùng **Functions** để thay đổi State.
- Cực kỳ phù hợp cho các tính năng đơn giản: Counter, Toggle, Theme, Form Validation.

## 2. Cấu trúc của 1 Cubit

Gồm 2 phần:
1.  **State**: Dữ liệu hiện tại (VD: `int` cho counter, hoặc class `UserState`).
2.  **Cubit Class**: Chứa các hàm để emit state mới.

```dart
// 1. State: int (counter)
// 2. Cubit: CounterCubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0); // Giá trị khởi tạo

  // Function thay đổi state
  void increment() {
    emit(state + 1); // Phát ra state mới
  }
}
```

## 3. Cách sử dụng trong UI

Flutter BLoC cung cấp các Widget để kết nối Cubit với UI:

### BlocProvider
- Tạo và cung cấp Cubit cho các widget con.
- Tự động đóng (close) Cubit khi widget bị hủy.

```dart
BlocProvider(
  create: (_) => CounterCubit(),
  child: CounterView(),
)
```

### BlocBuilder
- Lắng nghe state thay đổi và build lại UI.
- Chỉ build lại khi state thực sự thay đổi (dùng Equatable để so sánh).

```dart
BlocBuilder<CounterCubit, int>(
  builder: (context, state) {
    return Text('$state');
  },
)
```

## 4. Tại sao dùng Cubit thay vì ChangeNotifier?

| Feature | ChangeNotifier (Provider) | Cubit (Bloc) |
|---------|---------------------------|--------------|
| Bản chất | Mutable (biến đổi) | Immutable (Bất biến) |
| Cập nhật | `notifyListeners()` | `emit(newState)` |
| Debug | Khó theo dõi lịch sử | Dễ dàng (BlocObserver) |
| Test | Khá dễ | Rất dễ, rõ ràng |

-> **Cubit** rõ ràng hơn về luồng dữ liệu một chiều (One-way Data Flow).

---

## 5. Bài tập thực hành

### Ex04: Counter Cubit
- **File**: `exercises/ex04_counter_cubit.dart`
- **Mục tiêu**: Làm quen với `Cubit<int>`, `BlocProvider`, và `BlocBuilder`.

### Ex05: Theme Cubit
- **File**: `exercises/ex05_theme_cubit.dart`
- **Mục tiêu**: Dùng Cubit để quản lý ThemeMode (Dark/Light). Review lại về `BlocBuilder` bao bọc `MaterialApp`.

### Ex06: Timer Cubit (Complex State)
- **File**: `exercises/ex06_timer_cubit.dart`
- **Mục tiêu**: State phức tạp hơn không chỉ là 1 biến primitive.
- Sử dụng `class TimerState` với `Equatable`.
- Xử lý logic thời gian (Ticker) bên trong Cubit.
