/// ============================================================================
/// EXERCISE 12: BLOC LISTENER
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu BlocListener và side effects
/// - Phân biệt Listener vs Builder
/// - Sử dụng listenWhen
/// - Navigation, SnackBar, Dialog với BlocListener
///
/// 📝 BLOCLISTENER:
/// - KHÔNG rebuild UI
/// - Dùng cho side effects: navigation, snackbar, dialog, analytics
/// - Chạy 1 lần khi state thay đổi
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// STATES
// ============================================================================
sealed class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;
  const NotificationSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class NotificationError extends NotificationState {
  final String error;
  const NotificationError(this.error);
  @override
  List<Object> get props => [error];
}

class NotificationNavigate extends NotificationState {
  final String route;
  const NotificationNavigate(this.route);
  @override
  List<Object> get props => [route];
}

// ============================================================================
// CUBIT
// ============================================================================
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void showSuccess(String message) {
    emit(NotificationSuccess(message));
    // Reset về initial sau khi emit
    emit(NotificationInitial());
  }

  void showError(String error) {
    emit(NotificationError(error));
    emit(NotificationInitial());
  }

  void navigate(String route) {
    emit(NotificationNavigate(route));
    emit(NotificationInitial());
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex12BlocListener extends StatelessWidget {
  const Ex12BlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    // ========================================================================
    // BLOC LISTENER
    // ========================================================================
    //
    // BlocListener<Bloc/Cubit, State>
    // - listener: Callback khi state thay đổi
    // - listenWhen: Điều kiện để trigger listener
    // - child: Widget con (KHÔNG rebuild)
    //
    // KHÁC với BlocBuilder:
    // - Builder: rebuild UI, gọi nhiều lần
    // - Listener: side effects, gọi 1 lần per state change
    // ========================================================================
    return BlocListener<NotificationCubit, NotificationState>(
      // ======================================================================
      // LISTENER CALLBACK
      // ======================================================================
      //
      // Được gọi MỖI KHI state thay đổi
      // Dùng cho:
      // - SnackBar, Toast
      // - Dialog, BottomSheet
      // - Navigation
      // - Analytics tracking
      // ======================================================================
      listener: (context, state) {
        switch (state) {
          case NotificationSuccess(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(message),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          case NotificationError(:final error):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(error),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          case NotificationNavigate(:final route):
            // Navigate to detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _DetailPage(route: route),
              ),
            );
          default:
            break;
        }
      },
      // ======================================================================
      // CHILD - KHÔNG REBUILD
      // ======================================================================
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ex12: BlocListener'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Explanation
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
                      '💡 BlocListener vs BlocBuilder:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Builder: Rebuild UI (Text, Widget, ...)\n'
                      '• Listener: Side effects (SnackBar, Navigate, ...)\n\n'
                      'Listener KHÔNG rebuild child widget!',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ================================================================
              // ACTION BUTTONS
              // ================================================================
              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<NotificationCubit>()
                      .showSuccess('Thao tác thành công!');
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Show Success SnackBar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  context.read<NotificationCubit>().showError('Đã xảy ra lỗi!');
                },
                icon: const Icon(Icons.error_outline),
                label: const Text('Show Error SnackBar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  context.read<NotificationCubit>().navigate('/detail');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Navigate to Detail Page'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const Spacer(),

              // Code example
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BlocListener<Cubit, State>(\n'
                  '  listener: (context, state) {\n'
                  '    if (state is Success) {\n'
                  '      showSnackBar(...);\n'
                  '    }\n'
                  '  },\n'
                  '  child: MyWidget(), // Không rebuild\n'
                  ')',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DETAIL PAGE (Navigation target)
// ============================================================================
class _DetailPage extends StatelessWidget {
  final String route;

  const _DetailPage({required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Navigated to: $route',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Đây là trang được navigate bởi BlocListener'),
          ],
        ),
      ),
    );
  }
}
