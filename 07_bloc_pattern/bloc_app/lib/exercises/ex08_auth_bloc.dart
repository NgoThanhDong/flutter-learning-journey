/// ============================================================================
/// EXERCISE 08: AUTHENTICATION BLOC
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - BLoC với multiple states (Initial, Loading, Success, Failure)
/// - Xử lý async operations (login simulation)
/// - Pattern matching với sealed classes (Dart 3)
/// - UI phản hồi theo từng state
///
/// 📝 USE CASE THỰC TẾ:
/// - Authentication là feature core của hầu hết apps
/// - Có nhiều states: chưa login, đang login, thành công, thất bại
/// - BLoC giúp quản lý flow rõ ràng
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// EVENTS
// ============================================================================
// sealed class: Tất cả các class con phải trong cùng file
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event: Người dùng submit login form
/// LoginSubmitted (Sự kiện người dùng submit form đăng nhập)
class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

/// Event: Người dùng logout
/// LogoutRequested (Sự kiện người dùng yêu cầu đăng xuất)
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

// ============================================================================
// STATES - Multiple states with sealed class
// ============================================================================
//
// Mỗi state có thể mang data khác nhau:
// - AuthInitial: không có data
// - AuthLoading: không có data
// - AuthSuccess: có user info
// - AuthFailure: có error message
// ============================================================================
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// State: Chưa login
/// AuthInitial (Trạng thái ban đầu - chưa đăng nhập)
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State: Đang xử lý login
/// AuthLoading (Trạng thái đang xử lý đăng nhập)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State: Login thành công
/// AuthSuccess (Trạng thái đăng nhập thành công)
class AuthSuccess extends AuthState {
  final String username;
  final String displayName;

  const AuthSuccess({required this.username, required this.displayName});

  @override
  List<Object> get props => [username, displayName];
}

/// State: Login thất bại
/// AuthFailure (Trạng thái đăng nhập thất bại)
class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// ============================================================================
// BLOC
// ============================================================================
// AuthBloc (Quản lý trạng thái đăng nhập)
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted); // Xử lý sự kiện đăng nhập
    on<LogoutRequested>(_onLogoutRequested); // Xử lý sự kiện đăng xuất
  }

  // ============================================================================
  // LOGIN HANDLER
  // ============================================================================
  //
  // Flow:
  // 1. Emit Loading state
  // 2. Thực hiện async operation (API call simulation)
  // 3. Emit Success hoặc Failure tùy kết quả
  // ============================================================================
  // Xử lý sự kiện đăng nhập
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // Emit loading state
    emit(const AuthLoading());

    // Simulate API call (2 giây)
    await Future.delayed(const Duration(seconds: 2));

    // Validate credentials (fake logic)
    // Username: admin, Password: 123456 → Success
    // Otherwise → Failure
    if (event.username == 'admin' && event.password == '123456') {
      emit(AuthSuccess(
        username: event.username,
        displayName: 'Administrator',
      ));
    } else if (event.username.isEmpty || event.password.isEmpty) {
      emit(const AuthFailure('Vui lòng nhập đầy đủ thông tin'));
    } else {
      emit(const AuthFailure('Sai tên đăng nhập hoặc mật khẩu'));
    }
  }

  // ============================================================================
  // LOGOUT HANDLER
  // ============================================================================
  // Xử lý sự kiện đăng xuất
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const AuthInitial());
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex08AuthBloc extends StatelessWidget {
  const Ex08AuthBloc({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider (Cung cấp AuthBloc cho widget con)
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: const _AuthView(),
    );
  }
}

class _AuthView extends StatefulWidget {
  const _AuthView();

  @override
  State<_AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<_AuthView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // Ẩn mật khẩu

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex08: Auth BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ================================================================
            // STATE DISPLAY
            // ================================================================
            // BlocBuilder (Lắng nghe thay đổi state và build UI tương ứng)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getStateColor(state).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStateColor(state)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current State: ${state.runtimeType}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Hiển thị mô tả state
                      Text(
                        _getStateDescription(state),
                        style: TextStyle(color: _getStateColor(state)),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ================================================================
            // PATTERN MATCHING UI
            // ================================================================
            //
            // Dart 3 switch expression với sealed classes
            // Compiler đảm bảo handle tất cả cases
            // ================================================================
            // BlocBuilder (Lắng nghe thay đổi state và build UI tương ứng)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                // Pattern matching với switch expression
                return switch (state) {
                  AuthInitial() => _buildLoginForm(context),
                  AuthLoading() => _buildLoading(),
                  AuthSuccess(:final username, :final displayName) =>
                    _buildSuccessView(context, username, displayName),
                  AuthFailure(:final errorMessage) =>
                    _buildLoginForm(context, errorMessage: errorMessage),
                };
              },
            ),

            const SizedBox(height: 32),

            // ================================================================
            // HINT BOX
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
                    '💡 Test Credentials:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Username: admin'),
                  Text('Password: 123456'),
                  SizedBox(height: 12),
                  Text(
                    '📝 Pattern Matching (Dart 3):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'switch (state) {\n'
                    '  AuthInitial() => LoginForm(),\n'
                    '  AuthLoading() => Spinner(),\n'
                    '  AuthSuccess(:final user) => Profile(user),\n'
                    '  AuthFailure(:final error) => Error(error),\n'
                    '}',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // LOGIN FORM WIDGET
  // ============================================================================
  // Widget hiển thị form đăng nhập
  Widget _buildLoginForm(BuildContext context, {String? errorMessage}) {
    return Column(
      children: [
        // Error message
        if (errorMessage != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(errorMessage,
                        style: const TextStyle(color: Colors.red))),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Username field
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        // Password field
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Login button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // Dispatch LoginSubmitted event
              context.read<AuthBloc>().add(LoginSubmitted(
                    username: _usernameController.text,
                    password: _passwordController.text,
                  ));
            },
            child: const Text('LOGIN'),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // LOADING WIDGET
  // ============================================================================
  // Widget hiển thị trạng thái loading
  Widget _buildLoading() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang xử lý...'),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // SUCCESS VIEW
  // ============================================================================
  // Widget hiển thị trạng thái thành công
  Widget _buildSuccessView(
      BuildContext context, String username, String displayName) {
    return Column(
      children: [
        const Icon(Icons.check_circle, size: 80, color: Colors.green),
        const SizedBox(height: 16),
        Text(
          'Chào mừng, $displayName!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text('Đăng nhập với: $username'),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            context.read<AuthBloc>().add(const LogoutRequested());
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade100,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  // Phương thức helper để lấy màu tương ứng với state
  Color _getStateColor(AuthState state) {
    return switch (state) {
      AuthInitial() => Colors.grey,
      AuthLoading() => Colors.blue,
      AuthSuccess() => Colors.green,
      AuthFailure() => Colors.red,
    };
  }

  // Phương thức helper để lấy mô tả tương ứng với state
  String _getStateDescription(AuthState state) {
    return switch (state) {
      AuthInitial() => 'Chưa đăng nhập',
      AuthLoading() => 'Đang xử lý...',
      AuthSuccess(:final username) => 'Đã đăng nhập: $username',
      AuthFailure(:final errorMessage) => 'Lỗi: $errorMessage',
    };
  }
}
