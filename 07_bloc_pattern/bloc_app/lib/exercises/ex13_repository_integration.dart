/// ===========================================
/// EXERCISE 13: REPOSITORY INTEGRATION
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tách biệt Data Layer (Repository) và Presentation Layer (Bloc/UI)
/// - Sử dụng RepositoryProvider để inject dependency vào Widget Tree
/// - BLoC nhận Repository thông qua constructor
///
/// 📝 Luồng dữ liệu:
/// UI -> Event -> BLoC -> Repository -> Data -> BLoC -> State -> UI

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. REPOSITORY (Fake Data Source)
class MessageRepository {
  Future<String> fetchMessage() async {
    await Future.delayed(const Duration(seconds: 1)); // Giả lập delay
    return 'Hello from Repository at ${DateTime.now().second}s';
  }
}

/// 2. CUBIT
class MessageCubit extends Cubit<String> {
  // Dependency Injection: Repo được truyền vào qua constructor
  final MessageRepository _repository;

  MessageCubit({required MessageRepository repository})
      : _repository = repository,
        super('Press button to fetch');

  Future<void> getMessage() async {
    emit('Loading...');
    try {
      final message = await _repository.fetchMessage();
      emit(message);
    } catch (e) {
      emit('Error: $e');
    }
  }
}

/// 3. UI
class Ex13RepositoryIntegration extends StatelessWidget {
  const Ex13RepositoryIntegration({super.key});

  @override
  Widget build(BuildContext context) {
    /// BƯỚC 1: Cung cấp Repository cho cây widget
    return RepositoryProvider(
      create: (context) => MessageRepository(),

      /// BƯỚC 2: Cung cấp Cubit, lấy Repo từ context
      child: BlocProvider(
        create: (context) {
          // context.read<RepositoryType>() tìm RepositoryProvider gần nhất
          final repo = context.read<MessageRepository>();
          return MessageCubit(repository: repo);
        },
        child: const MessageView(),
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex13: Repository Integration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.message, size: 60, color: Colors.blue),
            const SizedBox(height: 20),

            // Hien thi State
            BlocBuilder<MessageCubit, String>(
              builder: (context, state) {
                if (state == 'Loading...') {
                  return const CircularProgressIndicator();
                }
                return Text(
                  state,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                );
              },
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => context.read<MessageCubit>().getMessage(),
              child: const Text('Fetch Message'),
            ),
          ],
        ),
      ),
    );
  }
}
