/// ===========================================
/// EXERCISE 12: BLOC SELECTOR (OPTIMIZATION)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tối ưu hóa việc rebuild widget
/// - Chỉ rebuild khi một phần cụ thể của State thay đổi
/// - So sánh với BlocBuilder thông thường
///
/// 📝 Tình huống:
/// - UserState có {name, age}
/// - Widget hiển thị Name chỉ cần rebuild khi Name đổi, không quan tâm Age đổi

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. STATE (Complex)
class UserState extends Equatable {
  final String name;
  final int age;

  const UserState({this.name = '', this.age = 0});

  UserState copyWith({String? name, int? age}) {
    return UserState(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  @override
  List<Object> get props => [name, age];
}

/// 2. CUBIT
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  void changeName(String newName) {
    debugPrint('Changing name to: $newName');
    emit(state.copyWith(name: newName));
  }

  void incrementAge() {
    debugPrint('Incrementing age to: ${state.age + 1}');
    emit(state.copyWith(age: state.age + 1));
  }
}

/// 3. UI
class Ex12BlocSelector extends StatelessWidget {
  const Ex12BlocSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ex12: BlocSelector Optimization')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Open Debug Console to see Rebuild logs!'),
              const SizedBox(height: 30),

              // Widget này chỉ quan tâm 'Age'
              const AgeWidget(),

              const SizedBox(height: 20),

              // Widget này chỉ quan tâm 'Name'
              const NameWidget(),

              const Divider(height: 48),

              // Controls
              const ControlButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class AgeWidget extends StatelessWidget {
  const AgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// BLOCK SELECTOR
    /// Chỉ rebuild khi kết quả của selector function thay đổi
    return BlocSelector<UserCubit, UserState, int>(
      selector: (state) => state.age,
      builder: (context, age) {
        debugPrint('🔴 Rebuilding AgeWidget');
        return Card(
          color: Colors.orange.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Age Widget (Only listens to age):'),
                Text('$age',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NameWidget extends StatelessWidget {
  const NameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// BLOC SELECTOR
    /// Chỉ rebuild khi name đổi
    return BlocSelector<UserCubit, UserState, String>(
      selector: (state) => state.name,
      builder: (context, name) {
        debugPrint('🔵 Rebuilding NameWidget');
        return Card(
          color: Colors.blue.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Name Widget (Only listens to name):'),
                Text(name.isEmpty ? 'Unknown' : name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
              labelText: 'Change Name (Rebuilds Blue only)'),
          onSubmitted: (value) => cubit.changeName(value),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => cubit.incrementAge(),
          child: const Text('Increment Age (Rebuilds Orange only)'),
        ),
      ],
    );
  }
}
