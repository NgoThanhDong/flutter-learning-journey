# Lesson 03: BLoC Concept (Events & States)

## 1. BLoC vs Cubit

Nếu **Cubit** dùng **Functions** để thay đổi State, thì **BLoC** dùng **Events**.

| Đặc điểm | Cubit | BLoC |
|----------|-------|------|
| Input | Functions (`increment()`) | Events (`CounterIncrementPressed`) |
| Output | States | States |
| Cơ chế | Synchronous / Async | Async (Stream of Events) |
| Độ phức tạp | Thấp | Cao hơn |
| Traceability | Tốt | Xuất sắc (Biết chính xác Event nào gây ra State nào) |

## 2. Cấu trúc của 1 BLoC

Gồm 3 phần:
1.  **Event**: Sự kiện từ UI (VD: Bấm nút, Kéo thả, API trả về).
2.  **State**: Dữ liệu hiện tại của UI.
3.  **Bloc Class**: Nhận Event -> Xử lý Logic -> Emit State.

```dart
// 1. Event
abstract class CounterEvent {}
class IncrementPressed extends CounterEvent {}

// 2. State: int

// 3. Bloc
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    // Đăng ký Event Handler
    on<IncrementPressed>((event, emit) {
      emit(state + 1);
    });
  }
}
```

## 3. Tại sao cần Event?

Bạn sẽ tự hỏi "Tại sao phải phức tạp vậy? Sao không gọi hàm luôn cho nhanh?".
Lợi ích của Event-driven:
1.  **Decoupling**: UI không biết logic xử lý thế nào, chỉ biết gửi yêu cầu (Event).
2.  **Tracking**: Bạn có thể log toàn bộ lịch sử: Event A -> State B -> Event C -> State D. Rất hữu ích khi debug lỗi phức tạp.
3.  **Transformation**: Bạn có thể biến đổi luồng Event (Debounce search, Throttle click button) rất dễ dàng bằng `rxdart` transformers (điều mà Cubit khó làm được).

## 4. BlocObserver

Là "Camera giám sát" toàn bộ hoạt động của App.
- Nó ghi lại mọi `Change` (Cubit), `Transition` (Bloc), và `Error`.
- Chỉ cần cài đặt 1 lần ở `main.dart`.

```dart
Bloc.observer = MyBlocObserver();
```

---

## 5. Bài tập thực hành

### Ex07: Counter BLoC
- **File**: `exercises/ex07_counter_bloc.dart`
- **Mục tiêu**: Viết lại Counter bằng BLoC chuẩn. Định nghĩa Event class.

### Ex08: Auth BLoC (Login Flow)
- **File**: `exercises/ex08_auth_bloc.dart`
- **Mục tiêu**: Mô phỏng luồng Login.
- Events: `LoginSubmitted`, `LogoutRequested`.
- States: `AuthInitial`, `AuthLoading`, `AuthSuccess`, `AuthFailure`.
- Xử lý giả lập Network delay.

### Ex09: Bloc Observer
- **File**: `exercises/ex09_bloc_observer.dart`
- **Mục tiêu**: Tạo một Observer để in log ra console mỗi khi có Event hoặc State thay đổi. Áp dụng cho Counter BLoC.
