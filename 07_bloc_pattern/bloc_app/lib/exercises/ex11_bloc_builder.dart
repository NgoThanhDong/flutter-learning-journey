/// ============================================================================
/// EXERCISE 11: BLOC BUILDER
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu BlocBuilder và cách rebuild UI
/// - Sử dụng buildWhen để tối ưu
/// - Nested BlocBuilder
///
/// 📝 BLOCBUILDER:
/// - Widget rebuild khi state thay đổi
/// - buildWhen: Điều kiện để rebuild
/// - Không làm side effects trong builder
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// CUBIT VỚI COMPLEX STATE
// ============================================================================
class UserState extends Equatable {
  final String name;
  final int age;
  final int rebuildCount;

  const UserState({
    this.name = 'Guest',
    this.age = 0,
    this.rebuildCount = 0,
  });

  UserState copyWith({String? name, int? age, int? rebuildCount}) {
    return UserState(
      name: name ?? this.name,
      age: age ?? this.age,
      rebuildCount: rebuildCount ?? this.rebuildCount,
    );
  }

  @override
  List<Object> get props => [name, age, rebuildCount];
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  void updateName(String name) {
    emit(state.copyWith(name: name, rebuildCount: state.rebuildCount + 1));
  }

  void updateAge(int age) {
    emit(state.copyWith(age: age, rebuildCount: state.rebuildCount + 1));
  }

  void incrementAge() {
    emit(state.copyWith(
        age: state.age + 1, rebuildCount: state.rebuildCount + 1));
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex11BlocBuilder extends StatelessWidget {
  const Ex11BlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(),
      child: const _UserView(),
    );
  }
}

class _UserView extends StatefulWidget {
  const _UserView();

  @override
  State<_UserView> createState() => _UserViewState();
}

class _UserViewState extends State<_UserView> {
  int _builderCallCount1 = 0;
  int _builderCallCount2 = 0;
  int _builderCallCount3 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex11: BlocBuilder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================================================================
            // BASIC BLOCBUILDER
            // ================================================================
            _buildCard(
              title: '1. Basic BlocBuilder',
              subtitle: 'Rebuild mỗi khi state thay đổi',
              child: BlocBuilder<UserCubit, UserState>(
                // ============================================================
                // BUILDER FUNCTION
                // ============================================================
                //
                // Được gọi mỗi khi:
                // 1. State thay đổi (emit được gọi)
                // 2. Widget được rebuild bởi parent
                //
                // KHÔNG NÊN làm side effects ở đây
                // (API calls, navigation, snackbar, ...)
                // ============================================================
                builder: (context, state) {
                  _builderCallCount1++;
                  return Column(
                    children: [
                      Text('Name: ${state.name}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Age: ${state.age}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Text('Builder called: $_builderCallCount1 times'),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ================================================================
            // BLOCBUILDER VỚI BUILDWHEN
            // ================================================================
            _buildCard(
              title: '2. BlocBuilder với buildWhen',
              subtitle: 'Chỉ rebuild khi name thay đổi',
              child: BlocBuilder<UserCubit, UserState>(
                // ============================================================
                // BUILDWHEN
                // ============================================================
                //
                // Điều kiện để rebuild
                // - previous: State trước đó
                // - current: State hiện tại
                // - Return true: Rebuild
                // - Return false: Không rebuild
                //
                // Dùng khi: State có nhiều properties, chỉ quan tâm một số
                // ============================================================
                buildWhen: (previous, current) {
                  // Chỉ rebuild khi name thay đổi
                  return previous.name != current.name;
                },
                builder: (context, state) {
                  _builderCallCount2++;
                  return Column(
                    children: [
                      Text('Name: ${state.name}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Text('Builder called: $_builderCallCount2 times'),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '↑ Chỉ tăng khi bấm Change Name',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ================================================================
            // BLOCBUILDER CHỈ LISTEN AGE
            // ================================================================
            _buildCard(
              title: '3. BlocBuilder chỉ listen Age',
              subtitle: 'Chỉ rebuild khi age thay đổi',
              child: BlocBuilder<UserCubit, UserState>(
                buildWhen: (previous, current) {
                  return previous.age != current.age;
                },
                builder: (context, state) {
                  _builderCallCount3++;
                  return Column(
                    children: [
                      Text('Age: ${state.age}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Text('Builder called: $_builderCallCount3 times'),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '↑ Chỉ tăng khi bấm +1 Age',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // CONTROL BUTTONS
            // ================================================================
            ElevatedButton(
              onPressed: () {
                final names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve'];
                final newName =
                    names[(DateTime.now().millisecond) % names.length];
                context.read<UserCubit>().updateName(newName);
              },
              child: const Text('Change Name'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<UserCubit>().incrementAge();
              },
              child: const Text('+1 Age'),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // EXPLANATION
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
                  Text('💡 buildWhen optimization:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    '• Card 1: Rebuild mọi lúc (không có buildWhen)\n'
                    '• Card 2: Chỉ rebuild khi name đổi\n'
                    '• Card 3: Chỉ rebuild khi age đổi\n\n'
                    'Thử bấm buttons và quan sát số lần rebuild!',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const Divider(),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
