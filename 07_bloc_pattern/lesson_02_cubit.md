# Lesson 02: Cubit - BLoC Đơn Giản Hóa

## 🎯 Mục Tiêu Bài Học
Sau bài này, bạn sẽ hiểu:
- Cubit là gì và khi nào nên dùng
- Cách tạo và sử dụng Cubit
- Sự khác biệt giữa Cubit và BLoC đầy đủ
- Các widgets: BlocProvider, BlocBuilder

## 📚 Lý Thuyết

### 1. Cubit Là Gì?

Cubit = **Simplified BLoC**. Thay vì dùng Events, Cubit dùng **functions trực tiếp**.

```dart
// Cubit: Gọi function
counterCubit.increment();

// BLoC: Dispatch event
counterBloc.add(IncrementEvent());
```

### 2. Cấu Trúc Cubit

```dart
class CounterCubit extends Cubit<int> {
  // Constructor: super(initialState)
  CounterCubit() : super(0);
  
  // Methods: gọi emit(newState) để thay đổi state
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

### 3. Cubit vs BLoC - Khi Nào Dùng Gì?

| Tiêu chí | Cubit | BLoC |
|----------|-------|------|
| Độ phức tạp | Đơn giản | Phức tạp |
| Input | Functions | Events |
| Traceability | Ít | Nhiều (event log) |
| Transformation | Không | Có (event transformers) |
| Use case | Counter, Theme | Auth, Form, API |

**Rule of thumb:**
- **Dùng Cubit** khi logic đơn giản, không cần trace events
- **Dùng BLoC** khi cần: debounce, throttle, event history

### 4. Các Widgets Quan Trọng

#### BlocProvider
```dart
// Cung cấp Cubit/BLoC cho widget tree
BlocProvider(
  create: (context) => CounterCubit(),
  child: MyWidget(),
)
```

#### BlocBuilder
```dart
// Rebuild UI khi state thay đổi
BlocBuilder<CounterCubit, int>(
  builder: (context, count) {
    return Text('$count');
  },
)
```

#### context.read vs context.watch

```dart
// read: Lấy instance, KHÔNG listen changes
// Dùng trong: onPressed, callbacks
context.read<CounterCubit>().increment();

// watch: Lấy instance VÀ listen changes
// Dùng trong: build method
final cubit = context.watch<CounterCubit>();
```

### 5. Equatable - So Sánh State

```dart
class UserState extends Equatable {
  final String name;
  final int age;
  
  const UserState(this.name, this.age);
  
  // Props để so sánh
  @override
  List<Object> get props => [name, age];
}
```

**Tại sao cần Equatable?**
- BLoC so sánh state cũ và mới
- Nếu giống nhau → không rebuild UI
- Equatable giúp so sánh chính xác

## 💻 Bài Tập Thực Hành

| Exercise | Tên | Mục tiêu |
|----------|-----|----------|
| Ex04 | Counter Cubit | Cubit cơ bản với increment/decrement |
| Ex05 | Theme Cubit | Quản lý ThemeMode toàn app |
| Ex06 | Timer Cubit | State phức tạp với Equatable |

## 🔑 Key Takeaways
1. Cubit = BLoC - Events
2. `emit(newState)` để thay đổi state
3. BlocProvider cung cấp, BlocBuilder consume
4. `context.read` cho actions, `context.watch` cho UI
5. Equatable giúp so sánh state hiệu quả

---
**Tiếp theo:** [Lesson 03 - BLoC Pattern](./lesson_03_bloc.md)
