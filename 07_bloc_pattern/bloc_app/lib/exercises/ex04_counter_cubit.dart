/// ============================================================================
/// EXERCISE 04: COUNTER CUBIT
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Tạo Cubit đầu tiên
/// - Hiểu emit() và state
/// - Sử dụng BlocProvider và BlocBuilder
/// - Hiểu context.read vs context.watch
///
/// 📝 CUBIT LÀ GÌ?
/// Cubit là phiên bản đơn giản của BLoC:
/// - BLoC: nhận Events → xử lý → emit States
/// - Cubit: gọi methods → emit States (không có Events)
///
/// Khi nào dùng Cubit?
/// - Logic đơn giản (counter, toggle, theme)
/// - Không cần trace event history
/// - Không cần debounce/throttle
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// CUBIT DEFINITION
// ============================================================================
//
// Cubit<T>: T là kiểu của State
// - Cubit<int>: State là số nguyên
// - Cubit<List<Todo>>: State là danh sách Todo
// - Cubit<UserState>: State là custom class
//
// super(0): Initial state = 0
// ============================================================================
class CounterCubit extends Cubit<int> {
  /// Constructor
  /// super(initialState): Gọi constructor của Cubit với state ban đầu
  CounterCubit() : super(0);

  // ============================================================================
  // METHODS
  // ============================================================================
  //
  // emit(newState): Phát ra state mới
  // - Tất cả BlocBuilder sẽ rebuild
  // - State cũ được thay thế
  //
  // state: Property chứa state hiện tại
  // - Read-only (không gán trực tiếp)
  // - Chỉ thay đổi qua emit()
  // ============================================================================

  /// Tăng counter lên 1
  void increment() {
    // state: giá trị hiện tại (int)
    // emit: phát ra giá trị mới
    emit(state + 1);
  }

  /// Giảm counter đi 1
  void decrement() {
    emit(state - 1);
  }

  /// Reset về 0
  void reset() {
    emit(0);
  }

  /// Set giá trị cụ thể
  void setValue(int value) {
    emit(value);
  }
}

// ============================================================================
// MAIN WIDGET
// ============================================================================
class Ex04CounterCubit extends StatelessWidget {
  const Ex04CounterCubit({super.key});

  @override
  Widget build(BuildContext context) {
    // ========================================================================
    // BLOC PROVIDER
    // ========================================================================
    //
    // BlocProvider: Cung cấp Cubit cho widget subtree
    //
    // - create: Hàm tạo instance của Cubit
    // - child: Widget con có thể access Cubit
    //
    // Tại sao cần BlocProvider?
    // - Dependency Injection: Child widgets không cần biết cách tạo Cubit
    // - Lifecycle management: Tự động dispose khi widget bị remove
    // - Scoping: Giới hạn phạm vi của Cubit
    // ========================================================================
    return BlocProvider<CounterCubit>(
      // create: Callback nhận context, trả về Cubit instance
      create: (BuildContext context) => CounterCubit(),

      // child: Widget subtree có thể access CounterCubit
      child: const _CounterView(),
    );
  }
}

// ============================================================================
// COUNTER VIEW
// ============================================================================
//
// Tách riêng View để:
// 1. BlocProvider ở widget cha
// 2. BlocBuilder/context.read ở widget con
// 3. Tránh lỗi "ProviderNotFoundException"
// ============================================================================
class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex04: Counter Cubit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ================================================================
            // GIẢI THÍCH CUBIT FLOW
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
                    'Cubit Flow:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Button → cubit.increment() → emit(state + 1) → BlocBuilder rebuild',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ================================================================
            // BLOC BUILDER
            // ================================================================
            //
            // BlocBuilder<CubitType, StateType>: Rebuild khi state thay đổi
            //
            // Parameters:
            // - builder: (context, state) => Widget
            //
            // Khi nào rebuild?
            // - Mỗi khi emit() được gọi với state MỚI
            // - Không rebuild nếu state giống nhau (so sánh bằng ==)
            //
            // Lưu ý:
            // - Chỉ wrap phần cần rebuild
            // - Tránh wrap cả Scaffold (rebuild không cần thiết)
            // ================================================================
            BlocBuilder<CounterCubit, int>(
              // ============================================================
              // BUILDER FUNCTION
              // ============================================================
              //
              // context: BuildContext
              // state: Giá trị state hiện tại (int trong trường hợp này)
              //
              // Return: Widget hiển thị tương ứng với state
              // ============================================================
              builder: (BuildContext context, int count) {
                return Column(
                  children: [
                    // Hiển thị giá trị
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            // Màu thay đổi theo giá trị
                            color: count > 0
                                ? Colors.green
                                : count < 0
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                    ),

                    const SizedBox(height: 8),

                    // Label
                    Text(
                      count == 1 ? '1 tap' : '$count taps',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            // ================================================================
            // CONTROL BUTTONS
            // ================================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==========================================================
                // CONTEXT.READ
                // ==========================================================
                //
                // context.read<T>(): Lấy instance của T, KHÔNG listen changes
                //
                // Dùng khi:
                // - Trong callbacks (onPressed, onTap)
                // - Gọi methods của Cubit
                //
                // KHÔNG dùng trong build() vì không tự động rebuild
                // ==========================================================
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: () {
                    // Lấy CounterCubit và gọi decrement()
                    context.read<CounterCubit>().decrement();
                  },
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.remove),
                ),

                const SizedBox(width: 16),

                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: () {
                    context.read<CounterCubit>().reset();
                  },
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.refresh),
                ),

                const SizedBox(width: 16),

                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () {
                    context.read<CounterCubit>().increment();
                  },
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ================================================================
            // CODE COMPARISON
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
                    '💡 So sánh với setState:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'setState:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '  setState(() { _count++; })',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cubit:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '  cubit.increment(); // emit(state + 1)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '✅ Cubit tách biệt logic khỏi UI\n✅ Dễ test (unit test Cubit riêng)\n✅ Có thể share state giữa nhiều widgets',
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
