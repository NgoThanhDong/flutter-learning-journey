/// ===========================================
/// EXERCISE 08: AUTH BLOC (LOGIN FLOW)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xử lý Logic Login giả lập (Async)
/// - Quản lý các trạng thái: Initial, Loading, Success, Failure
/// - Truyền dữ liệu qua Event (username, password)
/// - Hiển thị Feedback cho User (SnackBar, Loading Indicator)

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// -------------------------------------------
/// 1. DEFINE STATES
/// -------------------------------------------
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String username;
  const AuthSuccess(this.username);
  @override
  List<Object> get props => [username];
}

final class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
  @override
  List<Object> get props => [error];
}

/// -------------------------------------------
/// 2. DEFINE EVENTS
/// -------------------------------------------
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

final class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  const LoginSubmitted({required this.username, required this.password});
  @override
  List<Object> get props => [username, password];
}

final class LogoutRequested extends AuthEvent {}

/// -------------------------------------------
/// 3. BLOC IMPLEMENTATION
/// -------------------------------------------
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit Loading
    emit(AuthLoading());

    // 2. Simulate Network Request
    await Future.delayed(const Duration(seconds: 2));

    // 3. Validate Logic
    if (event.password.length < 6) {
      emit(const AuthFailure('Password must be at least 6 characters'));
      return;
    }

    if (event.username == 'admin' && event.password == '123456') {
      emit(AuthSuccess(event.username));
    } else {
      emit(const AuthFailure('Invalid credentials (try admin/123456)'));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthLoading());
    // Simulate logout delay if needed
    emit(AuthInitial());
  }
}

/// -------------------------------------------
/// 4. UI IMPLEMENTATION
/// -------------------------------------------
class Ex08AuthBloc extends StatelessWidget {
  const Ex08AuthBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ex08: Auth BLoC Flow')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // Side Effects: Show SnackBar, Navigate, etc.
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Login Successful!'),
                    backgroundColor: Colors.green),
              );
            }
          },
          builder: (context, state) {
            // Build UI based on State
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthSuccess) {
              return _LoggedInView(username: state.username);
            }
            return const _LoginForm();
          },
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 80, color: Colors.blue),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameCtrl,
            decoration: const InputDecoration(
                labelText: 'Username', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordCtrl,
            decoration: const InputDecoration(
                labelText: 'Password', border: OutlineInputBorder()),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      LoginSubmitted(
                        username: _usernameCtrl.text,
                        password: _passwordCtrl.text,
                      ),
                    );
              },
              child: const Text('LOGIN'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoggedInView extends StatelessWidget {
  final String username;
  const _LoggedInView({required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          Text('Welcome, $username!', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}
