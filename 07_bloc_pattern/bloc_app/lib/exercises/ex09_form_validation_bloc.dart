/// ============================================================================
/// EXERCISE 09: FORM VALIDATION BLOC
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Form validation với BLoC
/// - Reactive validation (validate khi user đang nhập)
/// - Xử lý multiple fields với complex state
/// - Submit form khi valid
///
/// 📝 REAL-WORLD USE CASE:
/// - Registration form với nhiều fields
/// - Validate email, password, confirm password
/// - Enable submit button chỉ khi tất cả valid
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// EVENTS
// ============================================================================
sealed class FormEvent extends Equatable {
  const FormEvent();
  @override
  List<Object> get props => [];
}

/// Event: Email changed
class EmailChanged extends FormEvent {
  final String email;
  const EmailChanged(this.email);
  @override
  List<Object> get props => [email];
}

/// Event: Password changed
class PasswordChanged extends FormEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object> get props => [password];
}

/// Event: Confirm password changed
class ConfirmPasswordChanged extends FormEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged(this.confirmPassword);
  @override
  List<Object> get props => [confirmPassword];
}

/// Event: Submit form
class FormSubmitted extends FormEvent {
  const FormSubmitted();
}

// ============================================================================
// STATE - Complex form state
// ============================================================================
class FormValidationState extends Equatable {
  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
  final String confirmPassword;
  final String? confirmPasswordError;
  final FormStatus status;

  const FormValidationState({
    this.email = '',
    this.emailError,
    this.password = '',
    this.passwordError,
    this.confirmPassword = '',
    this.confirmPasswordError,
    this.status = FormStatus.initial,
  });

  // ============================================================================
  // COMPUTED PROPERTIES
  // ============================================================================

  /// Kiểm tra tất cả fields có valid không
  bool get isValid =>
      email.isNotEmpty &&
      emailError == null &&
      password.isNotEmpty &&
      passwordError == null &&
      confirmPassword.isNotEmpty &&
      confirmPasswordError == null;

  FormValidationState copyWith({
    String? email,
    String? emailError,
    bool clearEmailError = false,
    String? password,
    String? passwordError,
    bool clearPasswordError = false,
    String? confirmPassword,
    String? confirmPasswordError,
    bool clearConfirmPasswordError = false,
    FormStatus? status,
  }) {
    return FormValidationState(
      email: email ?? this.email,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      password: password ?? this.password,
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPassword: confirmPassword ?? this.confirmPassword,
      confirmPasswordError: clearConfirmPasswordError
          ? null
          : (confirmPasswordError ?? this.confirmPasswordError),
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        email,
        emailError,
        password,
        passwordError,
        confirmPassword,
        confirmPasswordError,
        status,
      ];
}

enum FormStatus { initial, loading, success, failure }

// ============================================================================
// BLOC
// ============================================================================
class FormValidationBloc extends Bloc<FormEvent, FormValidationState> {
  FormValidationBloc() : super(const FormValidationState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  // ============================================================================
  // EMAIL VALIDATION
  // ============================================================================
  void _onEmailChanged(EmailChanged event, Emitter<FormValidationState> emit) {
    final email = event.email;
    String? error;

    if (email.isEmpty) {
      error = 'Email không được để trống';
    } else if (!_isValidEmail(email)) {
      error = 'Email không hợp lệ';
    }

    emit(state.copyWith(
      email: email,
      emailError: error,
      clearEmailError: error == null,
    ));
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  // ============================================================================
  // PASSWORD VALIDATION
  // ============================================================================
  void _onPasswordChanged(
      PasswordChanged event, Emitter<FormValidationState> emit) {
    final password = event.password;
    String? error;

    if (password.isEmpty) {
      error = 'Mật khẩu không được để trống';
    } else if (password.length < 6) {
      error = 'Mật khẩu phải ít nhất 6 ký tự';
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      error = 'Mật khẩu phải chứa ít nhất 1 số';
    }

    // Re-validate confirm password nếu đã nhập
    String? confirmError;
    if (state.confirmPassword.isNotEmpty && state.confirmPassword != password) {
      confirmError = 'Mật khẩu xác nhận không khớp';
    }

    emit(state.copyWith(
      password: password,
      passwordError: error,
      clearPasswordError: error == null,
      confirmPasswordError: confirmError,
      clearConfirmPasswordError: confirmError == null,
    ));
  }

  // ============================================================================
  // CONFIRM PASSWORD VALIDATION
  // ============================================================================
  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<FormValidationState> emit,
  ) {
    final confirmPassword = event.confirmPassword;
    String? error;

    if (confirmPassword.isEmpty) {
      error = 'Xác nhận mật khẩu không được để trống';
    } else if (confirmPassword != state.password) {
      error = 'Mật khẩu xác nhận không khớp';
    }

    emit(state.copyWith(
      confirmPassword: confirmPassword,
      confirmPasswordError: error,
      clearConfirmPasswordError: error == null,
    ));
  }

  // ============================================================================
  // FORM SUBMISSION
  // ============================================================================
  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<FormValidationState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormStatus.loading));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: FormStatus.success));
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex09FormValidationBloc extends StatelessWidget {
  const Ex09FormValidationBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormValidationBloc(),
      child: const _FormView(),
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex09: Form Validation BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<FormValidationBloc, FormValidationState>(
        // ====================================================================
        // LISTENER - Side effects
        // ====================================================================
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thành công!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        // ====================================================================
        // BUILDER - UI
        // ====================================================================
        builder: (context, state) {
          if (state.status == FormStatus.success) {
            return _buildSuccessView(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: state.isValid
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        state.isValid ? Icons.check_circle : Icons.info_outline,
                        color: state.isValid ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isValid
                            ? 'Form hợp lệ - Sẵn sàng submit'
                            : 'Vui lòng điền đầy đủ thông tin',
                        style: TextStyle(
                          color: state.isValid ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ============================================================
                // EMAIL FIELD
                // ============================================================
                TextField(
                  onChanged: (value) {
                    context.read<FormValidationBloc>().add(EmailChanged(value));
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                    errorText: state.emailError,
                    suffixIcon:
                        state.email.isNotEmpty && state.emailError == null
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // ============================================================
                // PASSWORD FIELD
                // ============================================================
                TextField(
                  onChanged: (value) {
                    context
                        .read<FormValidationBloc>()
                        .add(PasswordChanged(value));
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    errorText: state.passwordError,
                    helperText: 'Ít nhất 6 ký tự, chứa số',
                    suffixIcon:
                        state.password.isNotEmpty && state.passwordError == null
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                  ),
                ),

                const SizedBox(height: 16),

                // ============================================================
                // CONFIRM PASSWORD FIELD
                // ============================================================
                TextField(
                  onChanged: (value) {
                    context
                        .read<FormValidationBloc>()
                        .add(ConfirmPasswordChanged(value));
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    errorText: state.confirmPasswordError,
                    suffixIcon: state.confirmPassword.isNotEmpty &&
                            state.confirmPasswordError == null
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                  ),
                ),

                const SizedBox(height: 32),

                // ============================================================
                // SUBMIT BUTTON
                // ============================================================
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    // Disable nếu invalid hoặc đang loading
                    onPressed:
                        state.isValid && state.status != FormStatus.loading
                            ? () => context
                                .read<FormValidationBloc>()
                                .add(const FormSubmitted())
                            : null,
                    child: state.status == FormStatus.loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('ĐĂNG KÝ'),
                  ),
                ),

                const SizedBox(height: 32),

                // ============================================================
                // EXPLANATION
                // ============================================================
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
                        '💡 Reactive Form Validation:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• onChange → dispatch event\n'
                        '• BLoC validate → emit new state\n'
                        '• UI rebuild với error messages\n'
                        '• Button enabled khi isValid = true',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 100, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            'Đăng ký thành công!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Reset form - trong thực tế có thể navigate
              Navigator.of(context).pop();
            },
            child: const Text('Quay lại'),
          ),
        ],
      ),
    );
  }
}
