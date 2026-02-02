/// ===========================================
/// EXERCISE 10: PATH PARAMETERS (/:id)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Định nghĩa dynamic route với tham số (vd: /user/123)
/// - Lấy tham số từ state.pathParameters
///
/// 📝 Giải thích:
/// - Path: '/user/:userId' -> :userId là placeholder.
/// - state.pathParameters['userId'] -> lấy giá trị thực tế.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Ex10PathParameters extends StatelessWidget {
  const Ex10PathParameters({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const UserListScreen()),

        /// [Dynamic Route]
        /// :userId sẽ hứng bất kỳ giá trị nào ở vị trí đó
        GoRoute(
          path: '/user/:userId',
          builder: (context, state) {
            // Lấy giá trị userId từ URL
            final userId = state.pathParameters['userId']!;
            return UserProfileScreen(userId: userId);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  final users = const ['Alice', 'Bob', 'Charlie'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          // Giả lập ID
          final id = (index + 1).toString();

          return ListTile(
            leading: CircleAvatar(child: Text(id)),
            title: Text(user),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              /// [Navigate với Parameter]
              /// Truyền giá trị thực tế vào URL
              context.go('/user/$id');
            },
          );
        },
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile (ID: $userId)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple.shade100,
              child: Text(userId, style: const TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            Text(
              'Profile của User $userId',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to List'),
            ),
          ],
        ),
      ),
    );
  }
}
