/// ===========================================
/// EXERCISE 06: TIMER CUBIT (COMPLEX STATE)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Quản lý State phức tạp (Class thay vì primitive)
/// - Sử dụng Equatable để so sánh state
/// - Xử lý Ticker (stream) bên trong Cubit
/// - Đóng stream (Subscription) đúng cách
///
/// 📝 State Design:
/// - TimerInitial: Chưa chạy, hiển thị duration gốc
/// - TimerRunInProgress: Đang đếm ngược, hiển thị thời gian còn lại
/// - TimerRunPause: Đang tạm dừng
/// - TimerRunComplete: Đã xong (về 0)

library;

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// -------------------------------------------
/// 1. DEFINE STATE (With Equatable)
/// -------------------------------------------
/// Equatable giúp so sánh 2 object state.
/// Nếu state mới == state cũ -> BlocBuilder sẽ KHÔNG rebuild -> Tối ưu performance.
sealed class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(super.duration);
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);
}

class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}

/// -------------------------------------------
/// 2. TICKER HELPER
/// -------------------------------------------
class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

/// -------------------------------------------
/// 3. CUBIT IMPLEMENTATION
/// -------------------------------------------
class TimerCubit extends Cubit<TimerState> {
  final Ticker _ticker;
  static const int _defaultDuration = 60; // 60 seconds

  StreamSubscription<int>? _tickerSubscription;

  TimerCubit({Ticker ticker = const Ticker()})
      : _ticker = ticker,
        super(const TimerInitial(_defaultDuration));

  /// Start Timer
  void start({required int duration}) {
    emit(TimerRunInProgress(duration));
    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker.tick(ticks: duration).listen(
          (duration) => _ticked(duration),
        );
  }

  /// Pause
  void pause() {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  /// Resume
  void resume() {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  /// Reset
  void reset() {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_defaultDuration));
  }

  /// Private method handled internally whenever a tick occurs
  void _ticked(int duration) {
    if (duration > 0) {
      emit(TimerRunInProgress(duration));
    } else {
      emit(const TimerRunComplete());
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

/// -------------------------------------------
/// 4. UI IMPLEMENTATION
/// -------------------------------------------
class Ex06TimerCubit extends StatelessWidget {
  const Ex06TimerCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit(),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex06: Timer Cubit (Complex State)')),
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Center(child: TimerText()),
              ),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    // Chỉ rebuild Text khi duration thay đổi
    final duration = context.select((TimerCubit cubit) => cubit.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild buttons dựa trên Runtime Type của State
    return BlocBuilder<TimerCubit, TimerState>(
      // buildWhen giúp lọc điều kiện rebuild (tối ưu hóa)
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is TimerInitial) ...[
              FloatingActionButton(
                child: const Icon(Icons.play_arrow),
                onPressed: () =>
                    context.read<TimerCubit>().start(duration: state.duration),
              ),
            ],
            if (state is TimerRunInProgress) ...[
              FloatingActionButton(
                child: const Icon(Icons.pause),
                onPressed: () => context.read<TimerCubit>().pause(),
              ),
              FloatingActionButton(
                child: const Icon(Icons.replay),
                onPressed: () => context.read<TimerCubit>().reset(),
              ),
            ],
            if (state is TimerRunPause) ...[
              FloatingActionButton(
                child: const Icon(Icons.play_arrow),
                onPressed: () => context.read<TimerCubit>().resume(),
              ),
              FloatingActionButton(
                child: const Icon(Icons.replay),
                onPressed: () => context.read<TimerCubit>().reset(),
              ),
            ],
            if (state is TimerRunComplete) ...[
              FloatingActionButton(
                child: const Icon(Icons.replay),
                onPressed: () => context.read<TimerCubit>().reset(),
              ),
            ]
          ],
        );
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade200,
          ],
        ),
      ),
    );
  }
}
