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

// Ex10PathParameters là widget để demo path parameters
class Ex10PathParameters extends StatelessWidget {
  const Ex10PathParameters({super.key});

  @override
  Widget build(BuildContext context) {
    // router là GoRouter để quản lý navigation
    // initialLocation: URL ban đầu
    // routes: danh sách các route
    // GoRoute: định nghĩa route
    // builder: định nghĩa widget để hiển thị
    // state.pathParameters: lấy tham số từ URL
    // context.go(): navigate đến route
    // context.pop(): navigate trở lại
    // context.replace(): replace route hiện tại
    // context.canPop(): kiểm tra có thể navigate trở lại không
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
            return UserProfileScreen(
              userId: userId,
            ); // Hiển thị màn hình Profile
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router, // routerConfig: định nghĩa router
      debugShowCheckedModeBanner: false,
    );
  }
}

// UserListScreen là widget để demo màn hình User List
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
          // Lấy user từ list
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

// UserProfileScreen là widget để demo màn hình User Profile
class UserProfileScreen extends StatelessWidget {
  final String userId; // userId: ID của user

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hiển thị title
      appBar: AppBar(title: Text('User Profile (ID: $userId)')),
      // Hiển thị nội dung
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
            // Hiển thị thông tin user
            Text(
              'Profile của User $userId',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // Button để navigate trở lại
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
