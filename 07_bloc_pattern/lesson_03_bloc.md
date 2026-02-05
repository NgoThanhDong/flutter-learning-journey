# Lesson 03: BLoC Pattern - Event-Driven Architecture

## 🎯 Mục Tiêu Bài Học
Sau bài này, bạn sẽ hiểu:
- BLoC đầy đủ với Events và States
- Khi nào dùng BLoC thay vì Cubit
- Cách định nghĩa Events và States
- Event handlers và transformers
- BlocObserver để debug

## 📚 Lý Thuyết

### 1. BLoC vs Cubit

```dart
// Cubit: Gọi function trực tiếp
class CounterCubit extends Cubit<int> {
  void increment() => emit(state + 1);
}
counterCubit.increment();

// BLoC: Dispatch event
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}
counterBloc.add(Increment());
```

### 2. Khi Nào Dùng BLoC Đầy Đủ?

| Dùng BLoC khi | Dùng Cubit khi |
|---------------|----------------|
| Cần debounce/throttle | Logic đơn giản |
| Cần event log/tracing | Không cần trace |
| Multiple events → 1 state | 1 action → 1 state |
| Complex async flows | Simple async |

### 3. Cấu Trúc BLoC

```dart
// 1. EVENTS - Định nghĩa các hành động
sealed class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

// 2. STATES - Định nghĩa các trạng thái
sealed class CounterState {}
class CounterInitial extends CounterState {}
class CounterLoading extends CounterState {}
class CounterLoaded extends CounterState {
  final int value;
  CounterLoaded(this.value);
}

// 3. BLOC - Business Logic
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
  }
  
  Future<void> _onIncrement(Increment event, Emitter<CounterState> emit) async {
    emit(CounterLoading());
    await Future.delayed(Duration(milliseconds: 500));
    final current = (state as CounterLoaded).value;
    emit(CounterLoaded(current + 1));
  }
}
```

### 4. Sealed Classes (Dart 3)

```dart
// sealed: Chỉ có thể extend trong cùng file
// Compiler biết tất cả subclasses → exhaustive switch
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState { final User user; }
class AuthFailure extends AuthState { final String error; }

// Pattern matching với switch
Widget build(context, state) {
  return switch (state) {
    AuthInitial() => LoginButton(),
    AuthLoading() => LoadingSpinner(),
    AuthSuccess(:final user) => UserProfile(user),
    AuthFailure(:final error) => ErrorMessage(error),
  };
}
```

### 5. BlocObserver - Debug Tool

```dart
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print('Created: ${bloc.runtimeType}');
  }
  
  @override
  void onEvent(Bloc bloc, Object? event) {
    print('Event: $event');
  }
  
  @override
  void onChange(BlocBase bloc, Change change) {
    print('Change: $change');
  }
  
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Error: $error');
  }
}

// Đăng ký trong main()
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
```

## 💻 Bài Tập Thực Hành

| Exercise | Tên | Mục tiêu |
|----------|-----|----------|
| Ex07 | Counter BLoC | BLoC cơ bản với Increment/Decrement events |
| Ex08 | Auth BLoC | Login/Logout với multiple states |
| Ex09 | Form Validation BLoC | Validate form với debounce |
| Ex10 | BlocObserver | Debug và logging BLoC events |

## 🔑 Key Takeaways
1. BLoC = Events (input) + States (output)
2. `on<Event>()` để đăng ký handlers
3. Sealed classes giúp exhaustive pattern matching
4. BlocObserver để debug tất cả BLoCs
5. Dùng BLoC khi cần traceability và complex flows

---
**Tiếp theo:** [Lesson 04 - Flutter BLoC Widgets](./lesson_04_widgets.md)
