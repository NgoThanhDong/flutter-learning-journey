/// ============================================================================
/// EXERCISE 13: BLOC CONSUMER
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu BlocConsumer = BlocBuilder + BlocListener
/// - Khi nào cần cả UI update VÀ side effects
/// - Sử dụng buildWhen + listenWhen
///
/// 📝 BLOCCONSUMER:
/// - Kết hợp BlocBuilder và BlocListener
/// - listener: Gọi trước builder
/// - buildWhen: Filter conditions cho builder
/// - listenWhen: Filter conditions cho listener
///
/// ============================================================================
library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// EVENTS
// ============================================================================
sealed class DiceEvent {}

class RollDice extends DiceEvent {}

// ============================================================================
// STATE
// ============================================================================
class DiceState extends Equatable {
  final int value;
  final int rollCount;
  final bool isWin; // value == 6

  const DiceState({
    this.value = 1,
    this.rollCount = 0,
    this.isWin = false,
  });

  @override
  List<Object> get props => [value, rollCount, isWin];
}

// ============================================================================
// BLOC
// ============================================================================
class DiceBloc extends Bloc<DiceEvent, DiceState> {
  DiceBloc() : super(const DiceState()) {
    on<RollDice>(_onRollDice);
  }

  void _onRollDice(RollDice event, Emitter<DiceState> emit) {
    final newValue = Random().nextInt(6) + 1;
    emit(DiceState(
      value: newValue,
      rollCount: state.rollCount + 1,
      isWin: newValue == 6,
    ));
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex13BlocConsumer extends StatelessWidget {
  const Ex13BlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiceBloc(),
      child: const _DiceView(),
    );
  }
}

class _DiceView extends StatelessWidget {
  const _DiceView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex13: BlocConsumer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Explanation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      '🎲 Dice Game',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• BlocConsumer = Builder + Listener\n'
                      '• Builder: Hiển thị số xúc xắc\n'
                      '• Listener: Show dialog khi được 6 🎉',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ================================================================
              // BLOC CONSUMER
              // ================================================================
              //
              // BlocConsumer kết hợp cả Builder và Listener
              //
              // Use case:
              // - Hiển thị số xúc xắc (Builder)
              // - Và show dialog khi thắng (Listener)
              //
              // Thứ tự thực thi:
              // 1. listenWhen (nếu có)
              // 2. listener (nếu listenWhen = true)
              // 3. buildWhen (nếu có)
              // 4. builder (nếu buildWhen = true)
              // ================================================================
              BlocConsumer<DiceBloc, DiceState>(
                // ============================================================
                // LISTEN WHEN
                // ============================================================
                //
                // Chỉ trigger listener khi isWin chuyển thành true
                // ============================================================
                listenWhen: (previous, current) {
                  // Trigger khi vừa mới thắng (6)
                  return !previous.isWin && current.isWin;
                },

                // ============================================================
                // LISTENER - SIDE EFFECTS
                // ============================================================
                listener: (context, state) {
                  // Show celebration dialog
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Row(
                        children: [
                          Text('🎉'),
                          SizedBox(width: 8),
                          Text('Chúc mừng!'),
                        ],
                      ),
                      content: Text(
                        'Bạn đã được 6 sau ${state.rollCount} lần tung!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },

                // ============================================================
                // BUILD WHEN
                // ============================================================
                //
                // Luôn rebuild khi state thay đổi (default)
                // Có thể filter nếu cần
                // ============================================================
                buildWhen: (previous, current) {
                  // Rebuild mỗi khi giá trị xúc xắc thay đổi
                  return previous.value != current.value;
                },

                // ============================================================
                // BUILDER - UI
                // ============================================================
                builder: (context, state) {
                  return Column(
                    children: [
                      // Dice display
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: state.isWin
                              ? Colors.green.shade100
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: state.isWin
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(50),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _getDiceEmoji(state.value),
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Value text
                      Text(
                        'Giá trị: ${state.value}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      // Roll count
                      Text(
                        'Số lần tung: ${state.rollCount}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      if (state.isWin) ...[
                        const SizedBox(height: 8),
                        const Text(
                          '🎉 WINNER! 🎉',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              // Roll button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<DiceBloc>().add(RollDice());
                  },
                  icon: const Text('🎲', style: TextStyle(fontSize: 24)),
                  label: const Text('TUNG XÚC XẮC',
                      style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Code example
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BlocConsumer<Bloc, State>(\n'
                  '  listenWhen: (prev, curr) => ...,\n'
                  '  listener: (ctx, state) { /* effects */ },\n'
                  '  buildWhen: (prev, curr) => ...,\n'
                  '  builder: (ctx, state) { /* UI */ },\n'
                  ')',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDiceEmoji(int value) {
    const dice = ['⚀', '⚁', '⚂', '⚃', '⚄', '⚅'];
    return dice[value - 1];
  }
}
