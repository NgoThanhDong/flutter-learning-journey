/// ===========================================
/// EXERCISE 14: API HANDLING (NETWORKING)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xử lý 4 trạng thái chuẩn của API: Initial, Loading, Loaded, Error
/// - Try-catch block trong BLoC
/// - Modeling dữ liệu đơn giản
///
/// 📝 Pattern này áp dụng cho 90% các tính năng gọi API

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. MODEL
class Product {
  final int id;
  final String name;
  final double price;

  const Product(this.id, this.name, this.price);
}

/// 2. REPOSITORY
class ProductRepository {
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    // Giả lập lỗi ngẫu nhiên (30% cơ hội lỗi)
    if (DateTime.now().second % 3 == 0) {
      throw Exception('Server Timeout! Try again.');
    }

    return [
      const Product(1, 'iPhone 15', 999.0),
      const Product(2, 'MacBook Pro', 1999.0),
      const Product(3, 'AirPods Pro', 249.0),
      const Product(4, 'iPad Air', 599.0),
    ];
  }
}

/// 3. STATEMANAGEMENT (Cubit cho đơn giản)
/// State Classes
sealed class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);
  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object> get props => [message];
}

/// Cubit Logic
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repo;

  ProductCubit(this._repo) : super(ProductInitial());

  Future<void> loadProducts() async {
    try {
      emit(ProductLoading()); // 1. Emit Loading

      final products = await _repo.getProducts(); // 2. Call API

      emit(ProductLoaded(products)); // 3. Emit Success
    } catch (e) {
      emit(ProductError(e.toString())); // 4. Emit Error
    }
  }
}

/// 4. UI
class Ex14ApiHandling extends StatelessWidget {
  const Ex14ApiHandling({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(ProductRepository()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ex14: API Handling States')),
        body: const ProductListView(),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          /// INITIAL
          if (state is ProductInitial) {
            return ElevatedButton(
              onPressed: () => context.read<ProductCubit>().loadProducts(),
              child: const Text('Load Products'),
            );
          }

          /// LOADING
          if (state is ProductLoading) {
            return const CircularProgressIndicator();
          }

          /// LOADED
          if (state is ProductLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<ProductCubit>().loadProducts(),
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final p = state.products[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${p.id}')),
                    title: Text(p.name),
                    subtitle: Text('\$${p.price}'),
                    leadingAndTrailingTextStyle: const TextStyle(fontSize: 16),
                  );
                },
              ),
            );
          }

          /// ERROR
          if (state is ProductError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(state.message, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.read<ProductCubit>().loadProducts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
