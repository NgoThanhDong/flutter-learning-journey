/// ============================================================================
/// EXERCISE 07: COUNTER BLOC (FULL BLoC PATTERN)
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu cấu trúc BLoC đầy đủ: Events → BLoC → States
/// - Định nghĩa Events và đăng ký handlers
/// - So sánh với Cubit để thấy sự khác biệt
///
/// 📝 BLoC vs CUBIT:
/// - Cubit: gọi method trực tiếp (cubit.increment())
/// - BLoC: dispatch event (bloc.add(IncrementEvent()))
///
/// Ưu điểm của BLoC:
/// - Trace được event history
/// - Dễ debug (biết user làm gì)
/// - Có thể transform events (debounce, throttle)
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// EVENTS - Định nghĩa các hành động người dùng có thể thực hiện
// ============================================================================
//
// sealed class: Dart 3 feature
// - Tất cả subclasses phải trong cùng file
// - Compiler biết đủ tất cả types → exhaustive switch
//
// Naming convention:
// - Động từ + đối tượng: Increment, Decrement, Reset
// - Hoặc: CounterIncremented, CounterDecremented
// ============================================================================
sealed class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

/// Event: Tăng counter
class Increment extends CounterEvent {
  const Increment();
}

/// Event: Giảm counter
class Decrement extends CounterEvent {
  const Decrement();
}

/// Event: Reset về 0
class Reset extends CounterEvent {
  const Reset();
}

/// Event: Set giá trị cụ thể (có parameter)
class SetValue extends CounterEvent {
  final int value;

  const SetValue(this.value);

  // Props bao gồm value để Equatable so sánh chính xác
  @override
  List<Object> get props => [value];
}

// ============================================================================
// BLOC - Business Logic Component
// ============================================================================
//
// Bloc<EventType, StateType>
// - EventType: Base class của tất cả events
// - StateType: Kiểu của state (int, custom class, ...)
//
// Trong constructor:
// - super(initialState): Gọi Bloc với state ban đầu
// - on<EventType>: Đăng ký handler cho event
// ============================================================================
class CounterBloc extends Bloc<CounterEvent, int> {
  /// Constructor: đăng ký handlers cho từng event type
  CounterBloc() : super(0) {
    // ========================================================================
    // ON<EVENT> - Đăng ký Event Handler
    // ========================================================================
    //
    // on<EventType>(handler): Khi nhận EventType, gọi handler
    //
    // Handler signature:
    //   Future<void> handler(Event event, Emitter<State> emit)
    //   - event: Instance của event được dispatch
    //   - emit: Function để phát ra state mới
    //
    // Lưu ý: Có thể có nhiều emit() trong 1 handler
    // ========================================================================

    on<Increment>((event, emit) {
      // Tăng state lên 1
      emit(state + 1);
    });

    on<Decrement>((event, emit) {
      // Giảm state đi 1
      emit(state - 1);
    });

    on<Reset>((event, emit) {
      // Reset về 0
      emit(0);
    });

    on<SetValue>((event, emit) {
      // event.value: Lấy value từ event
      emit(event.value);
    });
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex07CounterBloc extends StatelessWidget {
  const Ex07CounterBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      create: (context) => CounterBloc(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex07: Counter BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ================================================================
            // BLoC FLOW DIAGRAM
            // ================================================================
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'BLoC Flow:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Button → bloc.add(Increment()) → on<Increment> → emit(state+1) → UI',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ================================================================
            // COUNTER DISPLAY
            // ================================================================
            BlocBuilder<CounterBloc, int>(
              builder: (context, count) {
                return Column(
                  children: [
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: count > 0
                                ? Colors.green
                                : count < 0
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current state: $count',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            // ================================================================
            // CONTROL BUTTONS - DISPATCH EVENTS
            // ================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==========================================================
                // DISPATCH EVENT
                // ==========================================================
                //
                // bloc.add(Event): Dispatch event vào BLoC
                //
                // Khác với Cubit:
                // - Cubit: context.read<C>().method()
                // - BLoC: context.read<B>().add(Event())
                // ==========================================================
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: () {
                    // Dispatch Decrement event
                    context.read<CounterBloc>().add(const Decrement());
                  },
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.remove),
                ),

                const SizedBox(width: 16),

                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: () {
                    // Dispatch Reset event
                    context.read<CounterBloc>().add(const Reset());
                  },
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.refresh),
                ),

                const SizedBox(width: 16),

                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () {
                    // Dispatch Increment event
                    context.read<CounterBloc>().add(const Increment());
                  },
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================================================================
            // SET VALUE BUTTON (Event với parameter)
            // ================================================================
            ElevatedButton(
              onPressed: () {
                // Dispatch SetValue với parameter
                context.read<CounterBloc>().add(const SetValue(100));
              },
              child: const Text('Set to 100'),
            ),

            const SizedBox(height: 40),

            // ================================================================
            // COMPARISON BOX
            // ================================================================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔄 So sánh Cubit vs BLoC:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Cubit:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '  context.read<CounterCubit>().increment()',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'BLoC:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '  context.read<CounterBloc>().add(Increment())',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '✅ BLoC có event log → dễ debug\n'
                    '✅ Có thể transform events (debounce)\n'
                    '✅ Tách biệt what (event) và how (handler)',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
