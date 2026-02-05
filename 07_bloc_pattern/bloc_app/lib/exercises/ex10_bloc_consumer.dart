/// ===========================================
/// EXERCISE 10: BLOC CONSUMER
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu sự khác biệt giữa Builder và Listener
/// - Sử dụng BlocConsumer để kết hợp cả hai
/// - Xử lý Side Effects (SnackBar, Dialog) an toàn
///
/// 📝 Kịch bản:
/// - Random một số từ 1-100
/// - Nếu số CHẴN: Hiển thị lên UI (Builder)
/// - Nếu số LẺ: Show SnackBar cảnh báo (Listener), KHÔNG đổi số trên UI

library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. CUBIT
class RandomCubit extends Cubit<int> {
  RandomCubit() : super(0);

  void generateRandom() {
    final number = Random().nextInt(100);
    debugPrint('Generated: $number');
    emit(number);
  }
}

/// 2. UI
class Ex10BlocConsumer extends StatelessWidget {
  const Ex10BlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RandomCubit(),
      child: const RandomNumberView(),
    );
  }
}

class RandomNumberView extends StatelessWidget {
  const RandomNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex10: BlocConsumer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Generate Random Number (0-99)'),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Even (Chẵn) -> Update View\nOdd (Lẻ) -> Show SnackBar',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            /// BLOC CONSUMER
            BlocConsumer<RandomCubit, int>(
              /// listener này ĐƯỢC gọi mỗi khi state thay đổi
              /// NHƯNG không dùng để vẽ UI
              listener: (context, number) {
                if (number % 2 != 0) {
                  // Số lẻ: Show thông báo
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('⚠️ Số lẻ ($number) không được hiển thị!'),
                      backgroundColor: Colors.orange,
                      duration: const Duration(milliseconds: 1000),
                    ),
                  );
                }
              },

              /// buildWhen: Kiểm soát khi nào hàm builder được chạy
              /// Ở đây ta chỉ rebuild nếu là số CHẴN
              buildWhen: (previous, current) {
                return current % 2 == 0;
              },

              /// builder này CHỈ chạy khi buildWhen trả về true
              builder: (context, number) {
                return Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 4),
                  ),
                  child: Text(
                    '$number',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.read<RandomCubit>().generateRandom(),
              child: const Text('Generate Random'),
            ),
          ],
        ),
      ),
    );
  }
}
