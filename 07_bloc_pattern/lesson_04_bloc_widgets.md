# Lesson 04: Flutter BLoC Widgets

`flutter_bloc` cung cấp một bộ Widget mạnh mẽ giúp tích hợp BLoC vào UI dễ dàng.

## 1. Các Widget cơ bản

### BlocBuilder
- **Chức năng**: Xây dựng lại UI (Build) mỗi khi State thay đổi.
- **Sử dụng**: Hiển thị dữ liệu lên màn hình.
- **Lưu ý**: Chỉ dùng để Build, không dùng để Navigate hay Show Dialog.

### BlocListener
- **Chức năng**: Lắng nghe (Listen) State thay đổi, nhưng **KHÔNG** rebuild UI.
- **Sử dụng**: Hiển thị SnackBar, Dialog, Navigate màn hình.
- **Tại sao?**: Nếu bạn show dialog trong `builder`, nó sẽ bị hiện lại mỗi khi rebuild -> Bug.

### BlocConsumer
- **Chức năng**: Kết hợp cả `BlocBuilder` và `BlocListener`.
- **Sử dụng**: Khi bạn vừa muốn update UI, vừa muốn bắt sự kiện (VD: Loading -> Show Loading UI, Error -> Show SnackBar).

```dart
BlocConsumer<MyBloc, MyState>(
  listener: (context, state) {
    if (state is Error) showSnackBar(state.message);
  },
  builder: (context, state) {
    if (state is Loading) return CircularProgressIndicator();
    return Text('Content');
  },
)
```

## 2. Các Widget cung cấp (Injection)

### BlocProvider
- Tạo mới một BLoC và cung cấp cho cây Widget con.
- Tự động gọi `bloc.close()` khi Widget bị hủy.

### MultiBlocProvider
- Giúp code gọn gàng khi bạn cần cung cấp nhiều BLoC cùng lúc.

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => BlocA()),
    BlocProvider(create: (_) => BlocB()),
  ],
  child: MyApp(),
)
```

## 3. Các Widget tối ưu

### BlocSelector
- Giúp UI chỉ rebuild khi một **phần nhỏ** của State thay đổi.
- **Ví dụ**: UserState có {name, age, email}. Widget hiển thị Name chỉ cần lắng nghe sự thay đổi của `name`.

```dart
BlocSelector<UserBloc, UserState, String>(
  selector: (state) => state.name,
  builder: (context, name) {
    return Text(name); // Chỉ rebuild khi name đổi
  },
)
```

---

## 4. Bài tập thực hành

### Ex10: BlocConsumer
- **File**: `exercises/ex10_bloc_consumer.dart`
- **Mục tiêu**: Xử lý kịch bản: Random Number Generator. 
- Nếu số chẵn -> Update UI.
- Nếu số lẻ -> Show SnackBar (không update UI).

### Ex11: MultiBlocProvider
- **File**: `exercises/ex11_multi_bloc_provider.dart`
- **Mục tiêu**: Kết hợp CounterCubit và ThemeCubit trong cùng 1 màn hình.

### Ex12: BlocSelector
- **File**: `exercises/ex12_bloc_selector.dart`
- **Mục tiêu**: Tối ưu performance cho Form nhập liệu (User Profile). Chỉ rebuild TextField tương ứng khi state thay đổi.
