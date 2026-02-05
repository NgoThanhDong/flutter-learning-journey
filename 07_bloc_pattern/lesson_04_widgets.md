# Lesson 04: Flutter BLoC Widgets

## 🎯 Mục Tiêu Bài Học
Sau bài này, bạn sẽ hiểu:
- Các widgets trong flutter_bloc package
- Khi nào dùng Builder vs Listener vs Consumer
- BlocSelector để tối ưu performance
- MultiBlocProvider cho multiple blocs

## 📚 Các Widgets Chính

### 1. BlocBuilder - Rebuild UI

```dart
BlocBuilder<CounterCubit, int>(
  // buildWhen: Rebuild có điều kiện
  buildWhen: (previous, current) => current != previous,
  
  builder: (context, count) {
    return Text('$count');
  },
)
```

**Dùng khi:** Cần hiển thị state trong UI

### 2. BlocListener - Side Effects

```dart
BlocListener<AuthBloc, AuthState>(
  // listenWhen: Listen có điều kiện
  listenWhen: (previous, current) => current is AuthFailure,
  
  listener: (context, state) {
    // Side effects: SnackBar, Dialog, Navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text((state as AuthFailure).message)),
    );
  },
  child: LoginForm(),
)
```

**Dùng khi:** Cần thực hiện side effects (không rebuild UI)

### 3. BlocConsumer - Builder + Listener

```dart
BlocConsumer<CartBloc, CartState>(
  listener: (context, state) {
    if (state is CartUpdated) {
      showSnackBar('Added to cart');
    }
  },
  builder: (context, state) {
    return CartWidget(items: state.items);
  },
)
```

**Dùng khi:** Cần cả UI update VÀ side effects

### 4. BlocSelector - Selective Rebuild

```dart
// Chỉ rebuild khi user.name thay đổi
BlocSelector<UserBloc, UserState, String>(
  selector: (state) => state.name,
  builder: (context, name) {
    return Text(name);
  },
)
```

**Dùng khi:** State phức tạp, chỉ cần watch 1 phần

### 5. MultiBlocProvider - Multiple Blocs

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc()),
    BlocProvider(create: (_) => ThemeCubit()),
    BlocProvider(create: (_) => CartBloc()),
  ],
  child: MyApp(),
)
```

**Dùng khi:** Cung cấp nhiều BLoC cho widget tree

### 6. MultiBlocListener - Multiple Listeners

```dart
MultiBlocListener(
  listeners: [
    BlocListener<AuthBloc, AuthState>(
      listener: (context, state) { /* ... */ },
    ),
    BlocListener<CartBloc, CartState>(
      listener: (context, state) { /* ... */ },
    ),
  ],
  child: HomePage(),
)
```

## 💻 Bài Tập Thực Hành

| Exercise | Tên | Mục tiêu |
|----------|-----|----------|
| Ex11 | BlocBuilder | Build UI theo state |
| Ex12 | BlocListener | Side effects (SnackBar, Navigation) |
| Ex13 | BlocConsumer | Kết hợp Builder + Listener |
| Ex14 | BlocSelector | Tối ưu rebuild |

## 🔑 Key Takeaways
1. Builder = UI, Listener = Side Effects
2. Consumer = Builder + Listener
3. Selector giảm rebuild không cần thiết
4. buildWhen/listenWhen để filter
5. Multi* widgets cho nhiều BLoCs

---
**Tiếp theo:** [Lesson 05 - Architecture & DI](./lesson_05_architecture.md)
