/// ============================================================================
/// EXERCISE 14: BLOC SELECTOR
/// ============================================================================
///
/// 🎯 MỤC TIÊU:
/// - Hiểu BlocSelector và selective rebuilds
/// - Tối ưu performance với state phức tạp
/// - So sánh với BlocBuilder + buildWhen
///
/// 📝 BLOCSELECTOR:
/// - Chỉ rebuild khi PHẦN ĐƯỢC CHỌN thay đổi
/// - selector: Hàm extract phần cần watch
/// - Tối ưu hơn buildWhen cho use case cụ thể
///
/// ============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// COMPLEX STATE
// ============================================================================
class ProfileState extends Equatable {
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final bool isVerified;
  final int updateCount;

  const ProfileState({
    this.firstName = 'John',
    this.lastName = 'Doe',
    this.age = 25,
    this.email = 'john@example.com',
    this.isVerified = false,
    this.updateCount = 0,
  });

  String get fullName => '$firstName $lastName';

  ProfileState copyWith({
    String? firstName,
    String? lastName,
    int? age,
    String? email,
    bool? isVerified,
    int? updateCount,
  }) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      updateCount: updateCount ?? this.updateCount,
    );
  }

  @override
  List<Object> get props =>
      [firstName, lastName, age, email, isVerified, updateCount];
}

// ============================================================================
// CUBIT
// ============================================================================
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void updateFirstName(String name) {
    emit(state.copyWith(firstName: name, updateCount: state.updateCount + 1));
  }

  void updateLastName(String name) {
    emit(state.copyWith(lastName: name, updateCount: state.updateCount + 1));
  }

  void incrementAge() {
    emit(
        state.copyWith(age: state.age + 1, updateCount: state.updateCount + 1));
  }

  void toggleVerified() {
    emit(state.copyWith(
        isVerified: !state.isVerified, updateCount: state.updateCount + 1));
  }
}

// ============================================================================
// UI WIDGET
// ============================================================================
class Ex14BlocSelector extends StatelessWidget {
  const Ex14BlocSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex14: BlocSelector'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                    '💡 BlocSelector:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• selector: Chọn phần state cần watch\n'
                    '• Chỉ rebuild khi phần đó thay đổi\n'
                    '• Tối ưu hơn BlocBuilder cho complex state',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================================================================
            // SELECTOR FOR FULLNAME
            // ================================================================
            _SelectorCard(
              title: 'Full Name Selector',
              subtitle: 'Chỉ rebuild khi firstName hoặc lastName đổi',
              // ============================================================
              // BLOC SELECTOR
              // ============================================================
              //
              // BlocSelector<Cubit, State, SelectedValue>
              //
              // selector: (state) => state.someField
              // - Extract phần cần watch
              // - Chỉ rebuild khi return value thay đổi
              //
              // builder: (context, selectedValue) => Widget
              // - Build UI với selectedValue
              // ============================================================
              child: BlocSelector<ProfileCubit, ProfileState, String>(
                selector: (state) => state.fullName,
                builder: (context, fullName) {
                  return _RebuildTracker(
                    label: 'Full Name',
                    value: fullName,
                    color: Colors.blue,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ================================================================
            // SELECTOR FOR AGE
            // ================================================================
            _SelectorCard(
              title: 'Age Selector',
              subtitle: 'Chỉ rebuild khi age đổi',
              child: BlocSelector<ProfileCubit, ProfileState, int>(
                selector: (state) => state.age,
                builder: (context, age) {
                  return _RebuildTracker(
                    label: 'Age',
                    value: '$age years old',
                    color: Colors.green,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ================================================================
            // SELECTOR FOR VERIFICATION STATUS
            // ================================================================
            _SelectorCard(
              title: 'Verified Selector',
              subtitle: 'Chỉ rebuild khi isVerified đổi',
              child: BlocSelector<ProfileCubit, ProfileState, bool>(
                selector: (state) => state.isVerified,
                builder: (context, isVerified) {
                  return _RebuildTracker(
                    label: 'Status',
                    value: isVerified ? '✅ Verified' : '❌ Not Verified',
                    color: isVerified ? Colors.green : Colors.orange,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ================================================================
            // TOTAL UPDATE COUNT (BlocBuilder for comparison)
            // ================================================================
            _SelectorCard(
              title: 'Update Counter (BlocBuilder)',
              subtitle: 'Rebuild MỌI LÚC state đổi (để so sánh)',
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return _RebuildTracker(
                    label: 'Total Updates',
                    value: '${state.updateCount}',
                    color: Colors.red,
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // CONTROL BUTTONS
            // ================================================================
            const Text('Thử bấm buttons và xem widget nào rebuild:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final names = ['John', 'Jane', 'Bob', 'Alice'];
                    final name = names[DateTime.now().second % names.length];
                    context.read<ProfileCubit>().updateFirstName(name);
                  },
                  child: const Text('Change First Name'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileCubit>().incrementAge();
                  },
                  child: const Text('+1 Age'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileCubit>().toggleVerified();
                  },
                  child: const Text('Toggle Verified'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Code example
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'BlocSelector<Cubit, State, String>(\n'
                '  selector: (state) => state.name,\n'
                '  builder: (context, name) {\n'
                '    return Text(name);\n'
                '  },\n'
                ')',
                style: TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HELPER WIDGETS
// ============================================================================
class _SelectorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SelectorCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}

class _RebuildTracker extends StatefulWidget {
  final String label;
  final String value;
  final Color color;

  const _RebuildTracker({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  State<_RebuildTracker> createState() => _RebuildTrackerState();
}

class _RebuildTrackerState extends State<_RebuildTracker> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.color.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Rebuilds: $_rebuildCount',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
