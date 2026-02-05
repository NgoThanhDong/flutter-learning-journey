/// ============================================================================
/// EXERCISE 10: BLOC OBSERVER
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu BlocObserver và cách sử dụng
/// - Debug tất cả BLoC/Cubit trong app
/// - Log events, state changes, errors
///
/// 📝 BLOCOBSERVER:
/// - Global observer cho tất cả BLoC/Cubit
/// - Track: onCreate, onEvent, onChange, onClose, onError
/// - Hữu ích cho debugging và analytics
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// CUSTOM BLOC OBSERVER
// ============================================================================
//
// BlocObserver là abstract class cung cấp hooks cho lifecycle của BLoC
//
// Override các methods để xử lý events:
// - onCreate: Khi BLoC/Cubit được tạo
// - onEvent: Khi event được dispatch (chỉ BLoC)
// - onChange: Khi state thay đổi
// - onTransition: Event + state change (chỉ BLoC)
// - onError: Khi có lỗi
// - onClose: Khi BLoC/Cubit bị dispose
// ============================================================================
class AppBlocObserver extends BlocObserver {
  // Danh sách logs để hiển thị trong UI
  final List<String> logs = [];
  final void Function()? onLogAdded;

  AppBlocObserver({this.onLogAdded});

  void _addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    logs.add('[$timestamp] $message');
    if (logs.length > 100) logs.removeAt(0);
    onLogAdded?.call();
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _addLog('🆕 CREATE: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _addLog('📤 EVENT: ${bloc.runtimeType} ← $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _addLog('🔄 CHANGE: ${bloc.runtimeType}');
    _addLog('   from: ${change.currentState}');
    _addLog('   to: ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _addLog('➡️ TRANSITION: ${bloc.runtimeType}');
    _addLog('   event: ${transition.event}');
    _addLog('   ${transition.currentState} → ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _addLog('❌ ERROR: ${bloc.runtimeType} - $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _addLog('🔒 CLOSE: ${bloc.runtimeType}');
  }
}

// ============================================================================
// SAMPLE CUBIT VÀ BLOC ĐỂ DEMO
// ============================================================================

/// Simple Counter Cubit
class DemoCounterCubit extends Cubit<int> {
  DemoCounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void throwError() => throw Exception('Demo error from Cubit!');
}

/// Simple Counter BLoC với Events
sealed class DemoCounterEvent {}

class DemoIncrement extends DemoCounterEvent {}

class DemoDecrement extends DemoCounterEvent {}

class DemoCounterBloc extends Bloc<DemoCounterEvent, int> {
  DemoCounterBloc() : super(0) {
    on<DemoIncrement>((event, emit) => emit(state + 1));
    on<DemoDecrement>((event, emit) => emit(state - 1));
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex10BlocObserver extends StatefulWidget {
  const Ex10BlocObserver({super.key});

  @override
  State<Ex10BlocObserver> createState() => _Ex10BlocObserverState();
}

class _Ex10BlocObserverState extends State<Ex10BlocObserver> {
  late final AppBlocObserver _observer;

  @override
  void initState() {
    super.initState();

    // ========================================================================
    // THIẾT LẬP BLOC OBSERVER
    // ========================================================================
    //
    // Bloc.observer: Global observer cho tất cả BLoC/Cubit
    //
    // Thường đặt trong main():
    //   void main() {
    //     Bloc.observer = AppBlocObserver();
    //     runApp(MyApp());
    //   }
    //
    // Ở đây đặt trong initState để demo trong exercise
    // ========================================================================
    _observer = AppBlocObserver(onLogAdded: () {
      // Sử dụng addPostFrameCallback để tránh lỗi setState() called during build
      // vì onCreate có thể được gọi trong quá trình build widget tree
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    });
    Bloc.observer = _observer;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DemoCounterCubit()),
        BlocProvider(create: (_) => DemoCounterBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ex10: BlocObserver'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  _observer.logs.clear();
                });
              },
              tooltip: 'Clear logs',
            ),
          ],
        ),
        // Wrap body in Builder to get a context that is a descendant of MultiBlocProvider
        body: Builder(
          builder: (context) => Column(
            children: [
              // ================================================================
              // DEMO CONTROLS
              // ================================================================
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bấm các nút để xem logs:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        // Cubit counter display
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  const Text('CUBIT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  BlocBuilder<DemoCounterCubit, int>(
                                    builder: (context, count) {
                                      return Text('$count',
                                          style: const TextStyle(fontSize: 24));
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => context
                                            .read<DemoCounterCubit>()
                                            .decrement(),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => context
                                            .read<DemoCounterCubit>()
                                            .increment(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // BLoC counter display
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  const Text('BLOC',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  BlocBuilder<DemoCounterBloc, int>(
                                    builder: (context, count) {
                                      return Text('$count',
                                          style: const TextStyle(fontSize: 24));
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => context
                                            .read<DemoCounterBloc>()
                                            .add(DemoDecrement()),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => context
                                            .read<DemoCounterBloc>()
                                            .add(DemoIncrement()),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Error demo button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          try {
                            context.read<DemoCounterCubit>().throwError();
                          } catch (e) {
                            // Error đã được log bởi observer
                          }
                        },
                        icon: const Icon(Icons.error_outline),
                        label: const Text('Trigger Error'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================================================================
              // LOGS DISPLAY
              // ================================================================
              Expanded(
                child: Container(
                  color: Colors.black87,
                  child: _observer.logs.isEmpty
                      ? const Center(
                          child: Text(
                            'Logs sẽ hiển thị ở đây...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _observer.logs.length,
                          itemBuilder: (context, index) {
                            final log = _observer.logs[index];
                            return Text(
                              log,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: _getLogColor(log),
                              ),
                            );
                          },
                        ),
                ),
              ),

              // ================================================================
              // EXPLANATION
              // ================================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.blue.shade50,
                child: const Text(
                  '💡 BlocObserver hooks: onCreate, onEvent, onChange, onTransition, onError, onClose',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLogColor(String log) {
    if (log.contains('CREATE')) return Colors.green;
    if (log.contains('EVENT')) return Colors.yellow;
    if (log.contains('CHANGE')) return Colors.cyan;
    if (log.contains('TRANSITION')) return Colors.blue;
    if (log.contains('ERROR')) return Colors.red;
    if (log.contains('CLOSE')) return Colors.orange;
    return Colors.white70;
  }
}
