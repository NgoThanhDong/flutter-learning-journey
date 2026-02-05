/// ===========================================
/// EXERCISE 09: BLOC OBSERVER
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu và cài đặt BlocObserver
/// - Theo dõi toàn bộ luồng Events và Transitions của App
/// - Debug hiệu quả bằng logs
///
/// 📝 BlocObserver:
/// - onEvent: Gọi khi BLoC nhận event
/// - onChange: Gọi khi Cubit/BLoC đổi state
/// - onTransition: Gọi khi BLoC chuyển state (State cũ -> Event -> State mới)
/// - onError: Gọi khi có lỗi xảy ra

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Reuse CounterBloc from Ex07 for demo purposes
import 'ex07_counter_bloc.dart';

/// -------------------------------------------
/// 1. DEFINE OBSERVER
/// -------------------------------------------
class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('🟢 Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('📩 Event: ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Áp dụng cho cả Cubit và BLoC
    debugPrint(
        '🔄 Change: ${bloc.runtimeType} | ${change.currentState} -> ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // Chỉ áp dụng cho BLoC (chi tiết hơn Change vì có cả Event)
    debugPrint(
        '🔀 Transition: ${bloc.runtimeType} | ${transition.currentState} -> [${transition.event}] -> ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('❌ Error: ${bloc.runtimeType} -> $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('🔴 Closed: ${bloc.runtimeType}');
  }
}

/// -------------------------------------------
/// 2. APP SETUP
/// -------------------------------------------
/// Lưu ý: Thông thường dòng `Bloc.observer = ...` được đặt ở main.dart
/// Ở bài tập này, chúng ta sẽ gán nó ngay khi vào màn hình này để demo
class Ex09BlocObserver extends StatefulWidget {
  const Ex09BlocObserver({super.key});

  @override
  State<Ex09BlocObserver> createState() => _Ex09BlocObserverState();
}

class _Ex09BlocObserverState extends State<Ex09BlocObserver> {
  @override
  void initState() {
    super.initState();
    // Gán Observer cho BLoC
    Bloc.observer = SimpleBlocObserver();
  }

  @override
  void dispose() {
    // Reset về null hoặc logic cũ nếu cần (tùy app)
    // Thực tế thì Observer thường sống suốt vòng đời App
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ex09: Bloc Observer Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Bật "Debug Console" để xem logs chi tiết!\n\n'
                  'Mỗi khi bạn bấm nút, Observer sẽ in ra:\n'
                  '- Event (được gửi đi)\n'
                  '- Transition (từ state cũ qua state mới)\n'
                  '- Change (thay đổi state)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Just reutilizing the UI part logic
              // In a real app we would reuse the Widget class, but here duplicating for clarity/independence
              BlocBuilder<CounterBloc, int>(
                builder: (context, count) {
                  return Text('$count',
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold));
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context
                        .read<CounterBloc>()
                        .add(CounterDecrementPressed()),
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => context
                        .read<CounterBloc>()
                        .add(CounterIncrementPressed()),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white),
                onPressed: () {
                  // Simulate an error logic if we had one, or just reset
                  context.read<CounterBloc>().add(CounterResetPressed());
                },
                child: const Text('Reset (Check Transition Log)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
