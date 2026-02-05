/// ===========================================
/// EXERCISE 04: COUNTER CUBIT
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tạo Cubit đơn giản (State là primitive type: int)
/// - Cung cấp Cubit bằng BlocProvider
/// - Consum Cubit bằng BlocBuilder
///
/// 📝 Cubit Pattern:
/// - Kế thừa từ Cubit<T>
/// - Initial State truyền vào super()
/// - Dùng emit(newState) để update UI
/// - UI gọi function trực tiếp: context.read<Cubit>().func()

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// -------------------------------------------
/// 1. DEFINE CUBIT
/// -------------------------------------------
/// State ở đây chỉ là một số nguyên (int)
class CounterCubit extends Cubit<int> {
  /// Khởi tạo với giá trị 0
  CounterCubit() : super(0);

  /// Hàm tăng giá trị
  /// Lưu ý: State của Cubit là immutable (hoặc coi như vậy)
  /// Ta luôn emit một giá trị MỚI
  void increment() {
    debugPrint('Cubit: incrementing from $state to ${state + 1}');
    emit(state + 1);
  }

  /// Hàm giảm giá trị
  void decrement() {
    debugPrint('Cubit: decrementing from $state to ${state - 1}');
    emit(state - 1);
  }

  /// Hàm reset
  void reset() => emit(0);
}

/// -------------------------------------------
/// 2. UI IMPLEMENTATION
/// -------------------------------------------
class Ex04CounterCubit extends StatelessWidget {
  const Ex04CounterCubit({super.key});

  @override
  Widget build(BuildContext context) {
    /// BƯỚC 1: Cung cấp Cubit cho cây Widget con
    /// BlocProvider tự động tạo và đóng (close) Cubit
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<Type>() : Lấy instance của Cubit để gọi hàm (không listen)
    // context.watch<Type>() : Lấy instance và listen changes (rebuild toàn bộ widget)
    // Tốt nhất nên dùng context.read() trong nút bấm, và BlocBuilder để hiển thị UI

    final counterCubit = context.read<CounterCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ex04: Counter Cubit')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Counter Value:',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            /// BƯỚC 2: Lắng nghe và build lại UI khi state đổi
            /// BlocBuilder<CubitType, StateType>
            BlocBuilder<CounterCubit, int>(
              builder: (context, count) {
                // count chính là state hiện tại
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: count >= 0 ? Colors.blue : Colors.red,
                      ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'dec',
                  onPressed: () => counterCubit.decrement(),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'reset',
                  backgroundColor: Colors.grey,
                  onPressed: () => counterCubit.reset(),
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'inc',
                  onPressed: () => counterCubit.increment(),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
