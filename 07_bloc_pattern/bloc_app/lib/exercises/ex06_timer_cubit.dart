/// ============================================================================
/// EXERCISE 06: TIMER CUBIT (COMPLEX STATE)
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Sử dụng Equatable (package giúp so sánh objects dựa trên properties) cho state phức tạp
/// - Quản lý multiple properties trong state
/// - Xử lý async operations trong Cubit (hoạt động bất đồng bộ)
/// - Hiểu copyWith pattern (tạo bản sao với một số properties thay đổi)
///
/// 📝 EQUATABLE:
/// - Package giúp so sánh objects dựa trên properties
/// - BLoC cần so sánh state cũ vs mới để quyết định rebuild
/// - Không có Equatable → mỗi emit đều rebuild (không tối ưu)
///
/// ============================================================================
library;

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// TIMER STATE - COMPLEX STATE VỚI EQUATABLE
// ============================================================================
//
// Equatable giúp:
// 1. So sánh 2 instances dựa trên props
// 2. Override == và hashCode tự động
// 3. BLoC biết khi nào state thực sự thay đổi
//
// Nếu không dùng Equatable:
// - Mỗi emit() đều trigger rebuild (vì mỗi instance là khác nhau)
// - Performance (hiệu năng) không tối ưu
// ============================================================================
class TimerState extends Equatable {
  /// Số giây hiện tại
  final int seconds;

  /// Trạng thái: initial, running, paused, finished
  final TimerStatus status;

  /// Số giây ban đầu (để tính %)
  final int initialSeconds;

  const TimerState({
    required this.seconds,
    required this.status,
    required this.initialSeconds,
  });

  // ============================================================================
  // FACTORY CONSTRUCTORS
  // ============================================================================
  //
  // Factory constructor giúp tạo state với giá trị mặc định
  // Dễ đọc và dễ maintain hơn
  // ============================================================================

  /// State ban đầu
  factory TimerState.initial() => const TimerState(
        seconds: 0,
        status: TimerStatus.initial,
        initialSeconds: 0,
      );

  /// State đang chạy
  factory TimerState.running(int seconds, int initial) => TimerState(
        seconds: seconds,
        status: TimerStatus.running,
        initialSeconds: initial,
      );

  // ============================================================================
  // COPYWITH PATTERN
  // ============================================================================
  //
  // copyWith: Tạo bản sao với một số properties thay đổi
  //
  // Tại sao cần?
  // - State là immutable (không thể thay đổi trực tiếp)
  // - Mỗi lần cần thay đổi → tạo bản sao mới
  //
  // Ví dụ:
  //   state.copyWith(seconds: 10)
  //   → Giữ nguyên status, thay đổi seconds
  // ============================================================================
  TimerState copyWith({
    int? seconds,
    TimerStatus? status,
    int? initialSeconds,
  }) {
    return TimerState(
      seconds: seconds ?? this.seconds,
      status: status ?? this.status,
      initialSeconds: initialSeconds ?? this.initialSeconds,
    );
  }

  // ============================================================================
  // EQUATABLE PROPS
  // ============================================================================
  //
  // props: List các properties để so sánh
  //
  // Khi nào 2 TimerState bằng nhau?
  // Khi seconds VÀ status VÀ initialSeconds đều giống nhau
  // ============================================================================
  @override
  List<Object> get props => [seconds, status, initialSeconds];

  // ============================================================================
  // HELPER GETTERS
  // ============================================================================

  /// Kiểm tra có đang chạy không
  bool get isRunning => status == TimerStatus.running;

  /// Kiểm tra có thể start không
  bool get canStart =>
      status == TimerStatus.initial || status == TimerStatus.paused;

  /// Tính phần trăm còn lại
  double get progress {
    if (initialSeconds == 0) return 0;
    return seconds / initialSeconds;
  }

  /// Format thời gian mm:ss
  String get formattedTime {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

/// Enum cho trạng thái timer
enum TimerStatus { initial, running, paused, finished }

// ============================================================================
// TIMER CUBIT (quản lý logic của timer)
// ============================================================================
class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;

  TimerCubit() : super(TimerState.initial());

  // ============================================================================
  // START TIMER
  // ============================================================================
  //
  // Bắt đầu đếm ngược từ số giây cho trước
  //
  // Flow:
  // 1. Cancel timer cũ (nếu có)
  // 2. Set initial state (trạng thái ban đầu)
  // 3. Tạo periodic timer (mỗi giây)
  // 4. Mỗi giây: giảm seconds, emit state mới
  // 5. Khi hết: emit finished state
  // ============================================================================
  void startTimer(int durationSeconds) {
    // Cancel timer cũ
    _timer?.cancel();

    // Emit state bắt đầu
    emit(TimerState(
      seconds: durationSeconds,
      status: TimerStatus.running,
      initialSeconds: durationSeconds,
    ));

    // Tạo timer mới
    // periodic: lặp lại hành động sau mỗi khoảng thời gian
    // (_) : tham số của hàm callback (không sử dụng)
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.seconds > 0) {
        // Còn thời gian → giảm 1 giây
        emit(state.copyWith(seconds: state.seconds - 1));
      } else {
        // Hết thời gian → finished
        _timer?.cancel();
        emit(state.copyWith(status: TimerStatus.finished));
      }
    });
  }

  /// Pause timer
  void pause() {
    _timer?.cancel();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  /// Resume timer (tiếp tục đếm ngược)
  void resume() {
    if (state.status != TimerStatus.paused) return;

    emit(state.copyWith(status: TimerStatus.running));

    // Tạo timer mới
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.seconds > 0) {
        emit(state.copyWith(seconds: state.seconds - 1));
      } else {
        _timer?.cancel();
        emit(state.copyWith(status: TimerStatus.finished));
      }
    });
  }

  /// Reset timer
  void reset() {
    _timer?.cancel();
    emit(TimerState.initial());
  }

  // ============================================================================
  // CLOSE
  // ============================================================================
  //
  // Override close() để cleanup resources
  // Được gọi khi BlocProvider dispose
  // ============================================================================
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex06TimerCubit extends StatelessWidget {
  const Ex06TimerCubit({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider: cung cấp TimerCubit cho widget con
    return BlocProvider(
      create: (context) => TimerCubit(),
      child: const _TimerView(),
    );
  }
}

class _TimerView extends StatelessWidget {
  const _TimerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex06: Timer Cubit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ================================================================
              // TIMER DISPLAY (hiển thị thời gian)
              // ================================================================
              // BlocBuilder: lắng nghe state thay đổi và rebuild UI
              // Chỉ rebuild khi state thay đổi
              // builder: hàm callback nhận context và state
              // state: trạng thái hiện tại của TimerCubit
              BlocBuilder<TimerCubit, TimerState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Progress indicator
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circle
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: state.progress,
                                strokeWidth: 12, // độ dày của đường tròn
                                backgroundColor: Colors.grey.shade200,
                                // màu của đường tròn
                                color: _getProgressColor(state),
                              ),
                            ),

                            // Time text
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Thời gian còn lại
                                Text(
                                  state.formattedTime, // định dạng thời gian
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),

                                // Trạng thái của timer
                                Text(
                                  state.status.name.toUpperCase(),
                                  style: TextStyle(
                                    // màu của chữ
                                    color: _getStatusColor(state),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ======================================================
                      // PRESET BUTTONS (nút chọn thời gian)
                      // ======================================================
                      const Text('Quick Start:'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [
                          _PresetButton(seconds: 10, label: '10s'),
                          _PresetButton(seconds: 30, label: '30s'),
                          _PresetButton(seconds: 60, label: '1m'),
                          _PresetButton(seconds: 120, label: '2m'),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ======================================================
                      // CONTROL BUTTONS (nút điều khiển)
                      // ======================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Pause/Resume
                          if (state.isRunning)
                            // Nút pause
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<TimerCubit>().pause(),
                              icon: const Icon(Icons.pause),
                              label: const Text('Pause'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade100,
                              ),
                            )
                          else if (state.status == TimerStatus.paused)
                            // Nút resume
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<TimerCubit>().resume(),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Resume'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade100,
                              ),
                            ),

                          const SizedBox(width: 16),

                          // Reset
                          ElevatedButton.icon(
                            onPressed: () => context.read<TimerCubit>().reset(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              // ================================================================
              // EXPLANATION BOX (hộp giải thích)
              // ================================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Equatable là gì?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• TimerState extends Equatable\n'
                      '• props = [seconds, status, initialSeconds]\n'
                      '• BLoC so sánh state cũ vs mới qua props\n'
                      '• Chỉ rebuild khi props thay đổi',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS (phương thức trợ giúp)
  // ============================================================================
  // Lấy màu của progress indicator
  Color _getProgressColor(TimerState state) {
    switch (state.status) {
      case TimerStatus.running:
        return Colors.blue;
      case TimerStatus.paused:
        return Colors.orange;
      case TimerStatus.finished:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Lấy màu của status text
  Color _getStatusColor(TimerState state) {
    switch (state.status) {
      case TimerStatus.running:
        return Colors.blue;
      case TimerStatus.paused:
        return Colors.orange;
      case TimerStatus.finished:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// ============================================================================
// PRESET BUTTON (nút chọn thời gian)
// ============================================================================
class _PresetButton extends StatelessWidget {
  final int seconds;
  final String label;

  const _PresetButton({required this.seconds, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Khi nhấn nút, gọi startTimer với thời gian đã chọn
      // context.read<TimerCubit>() để lấy TimerCubit
      // .startTimer(seconds) để gọi hàm startTimer
      onPressed: () => context.read<TimerCubit>().startTimer(seconds),
      child: Text(label),
    );
  }
}
