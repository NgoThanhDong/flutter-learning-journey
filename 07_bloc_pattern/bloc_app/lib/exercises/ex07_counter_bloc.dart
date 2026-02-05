/// ===========================================
/// EXERCISE 07: COUNTER BLOC (EVENT DRIVEN)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Chuyển từ Cubit sang BLoC
/// - Định nghĩa Events và States
/// - Xử lý Event Handler bằng on<Event>
///
/// 📝 BLoC Pattern:
/// - Input: Events (CounterIncrementPressed)
/// - Output: States (int)
/// - UI gửi Event: context.read<Bloc>().add(Event())

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// -------------------------------------------
/// 1. DEFINE EVENTS
/// -------------------------------------------
sealed class CounterEvent {}

final class CounterIncrementPressed extends CounterEvent {}

final class CounterDecrementPressed extends CounterEvent {}

final class CounterResetPressed extends CounterEvent {}

/// -------------------------------------------
/// 2. DEFINE BLOC
/// -------------------------------------------
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    /// Đăng ký Event Handlers
    /// on<EventType>((event, emit) { ... })

    on<CounterIncrementPressed>((event, emit) {
      // Logic xử lý khi nhận được event Increment
      // Có thể gọi API, check điều kiện, v.v. trước khi emit
      emit(state + 1);
    });

    on<CounterDecrementPressed>((event, emit) {
      emit(state - 1);
    });

    on<CounterResetPressed>((event, emit) {
      emit(0);
    });
  }
}

/// -------------------------------------------
/// 3. UI IMPLEMENTATION
/// -------------------------------------------
class Ex07CounterBloc extends StatelessWidget {
  const Ex07CounterBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<CounterBloc>() để gửi Event
    final counterBloc = context.read<CounterBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ex07: Counter BLoC (Events)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Counter Value (via BLoC):'),
            const SizedBox(height: 20),
            BlocBuilder<CounterBloc, int>(
              builder: (context, count) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'dec_bloc',
                  onPressed: () => counterBloc.add(CounterDecrementPressed()),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'reset_bloc',
                  backgroundColor: Colors.grey,
                  onPressed: () => counterBloc.add(CounterResetPressed()),
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'inc_bloc',
                  onPressed: () => counterBloc.add(CounterIncrementPressed()),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Lưu ý: Chúng ta không gọi function trực tiếp (.increment) mà gửi Event (.add(IncrementEvent))',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
