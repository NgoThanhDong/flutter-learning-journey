/// ===========================================
/// EXERCISE 15: DEPENDENCY INJECTION (GET_IT)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Sử dụng get_it làm Service Locator
/// - Inject Repository vào BLoC mà không cần RepositoryProvider
/// - Decoupling (Giảm sự phụ thuộc) giữa các lớp
///
/// 📝 Setup:
/// - getIt.registerLazySingleton: Tạo instance 1 lần dùng mãi
/// - getIt<Type>(): Lấy instance ra dùng

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Service Locator Instance
final getIt = GetIt.instance;

/// 1. REPOSITORY & SERVICE
abstract class AuthService {
  Future<bool> login(String token);
}

class AuthServiceImpl implements AuthService {
  @override
  Future<bool> login(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return token == 'secret';
  }
}

/// 2. DI SETUP FUNCTION
/// Hàm này thường được gọi ở main() trước runApp
void setupDependencies() {
  // Đảm bảo không register trùng lặp khi hot reload trong môi trường demo này
  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  }
}

/// 3. CUBIT
class DIDemoCubit extends Cubit<String> {
  // Dependency được inject vào, không khởi tạo trực tiếp bên trong
  final AuthService _authService;

  // Constructor cho phép inject (dễ test), nếu không truyền thì tự lấy từ getIt
  DIDemoCubit({AuthService? authService})
      : _authService = authService ?? getIt<AuthService>(),
        super('Initial');

  Future<void> checkToken(String token) async {
    emit('Checking...');
    final result = await _authService.login(token);
    if (result) {
      emit('Authenticated ✅');
    } else {
      emit('Invalid Token ❌');
    }
  }
}

/// 4. UI
class Ex15DependencyInjection extends StatefulWidget {
  const Ex15DependencyInjection({super.key});

  @override
  State<Ex15DependencyInjection> createState() =>
      _Ex15DependencyInjectionState();
}

class _Ex15DependencyInjectionState extends State<Ex15DependencyInjection> {
  @override
  void initState() {
    super.initState();
    // Gọi setup DI (trong thực tế gọi ở main)
    setupDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Không cần RepositoryProvider bao bọc
    return BlocProvider(
      create: (context) => DIDemoCubit(), // Cubit tự lấy dependency từ getIt
      child: const DIView(),
    );
  }
}

class DIView extends StatelessWidget {
  const DIView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Ex15: GetIt Dependency Injection')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Enter token ("secret" to pass):'),
            TextField(controller: controller),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<DIDemoCubit>().checkToken(controller.text);
              },
              child: const Text('Check Token'),
            ),
            const SizedBox(height: 30),
            BlocBuilder<DIDemoCubit, String>(
              builder: (context, state) {
                return Text(
                  state,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
