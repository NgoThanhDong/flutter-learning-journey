/// ===========================================
/// EXERCISE 11: MULTI BLOC PROVIDER
/// ===========================================
/// 🎯 Mục tiêu:
/// - Cung cấp nhiều BLoC/Cubit cùng lúc cho cây Widget
/// - Sử dụng MultiBlocProvider giúp code gọn gàng hơn
/// - Các BLoC hoạt động độc lập với nhau trong cùng 1 màn hình
///
/// 📝 Tình huống:
/// - 1 CounterCubit để đếm số
/// - 1 ColorCubit để đổi màu background

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit 1: Counter
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}

/// Cubit 2: Color
class ColorCubit extends Cubit<Color> {
  ColorCubit() : super(Colors.white);
  void changeColor() {
    if (state == Colors.white)
      emit(Colors.blue.shade100);
    else if (state == Colors.blue.shade100)
      emit(Colors.green.shade100);
    else
      emit(Colors.white);
  }
}

class Ex11MultiBlocProvider extends StatelessWidget {
  const Ex11MultiBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    /// Thay vì lồng nhau: BlocProvider(child: BlocProvider(child: ...))
    /// Chúng ta dùng MultiBlocProvider
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterCubit()),
        BlocProvider(create: (_) => ColorCubit()),
      ],
      child: const MultiBlocView(),
    );
  }
}

class MultiBlocView extends StatelessWidget {
  const MultiBlocView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe ColorCubit để đổi màu nền
    return BlocBuilder<ColorCubit, Color>(
      builder: (context, color) {
        return Scaffold(
          backgroundColor: color,
          appBar: AppBar(title: const Text('Ex11: MultiBlocProvider')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Counter (Bloc 1):'),

                // Lắng nghe CounterCubit để hiển thị số
                BlocBuilder<CounterCubit, int>(
                  builder: (context, count) {
                    return Text(
                      '$count',
                      style: Theme.of(context).textTheme.displayLarge,
                    );
                  },
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.read<CounterCubit>().increment(),
                      icon: const Icon(Icons.add),
                      label: const Text('Increment Count'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () => context.read<ColorCubit>().changeColor(),
                      icon: const Icon(Icons.color_lens),
                      label: const Text('Change Color'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
