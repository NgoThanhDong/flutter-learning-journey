/// ===========================================
/// EXERCISE 19: SHOPPING CART (COMPLEX STATE)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Quản lý giỏ hàng (Danh sách sản phẩm)
/// - Tính toán tổng tiền (Derived State)
/// - Tương tác giữa Catalog (ListSP) và Cart (Giỏ hàng)
///
/// 📝 Logic:
/// - CartBloc nhận events: AddItem, RemoveItem
/// - State: CartLoaded(items: [], totalPrice: 0)

library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1. MODEL
class Item extends Equatable {
  final int id;
  final String name;
  final double price;
  final Color color;

  const Item(
      {required this.id,
      required this.name,
      required this.price,
      required this.color});

  @override
  List<Object> get props => [id, name, price, color];
}

/// Catalog data giả lập
const _catalog = [
  Item(id: 1, name: 'Red Shirt', price: 20.0, color: Colors.red),
  Item(id: 2, name: 'Blue Jeans', price: 35.0, color: Colors.blue),
  Item(id: 3, name: 'Green Hat', price: 15.0, color: Colors.green),
  Item(id: 4, name: 'Yellow Scarf', price: 12.0, color: Colors.yellow),
  Item(id: 5, name: 'Purple Dress', price: 45.0, color: Colors.purple),
];

/// 2. EVENTS
sealed class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartItemAdded extends CartEvent {
  final Item item;
  CartItemAdded(this.item);
  @override
  List<Object> get props => [item];
}

class CartItemRemoved extends CartEvent {
  final Item item;
  CartItemRemoved(this.item);
  @override
  List<Object> get props => [item];
}

/// 3. STATEMANAGEMENT (BLoC)
class CartState extends Equatable {
  final List<Item> items;

  const CartState({this.items = const []});

  // Getter tính toán (Derived State)
  double get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  @override
  List<Object> get props => [items];
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>((event, emit) {
      final updatedItems = List<Item>.from(state.items)..add(event.item);
      emit(CartState(items: updatedItems));
    });

    on<CartItemRemoved>((event, emit) {
      final updatedItems = List<Item>.from(state.items)..remove(event.item);
      emit(CartState(items: updatedItems));
    });
  }
}

/// 4. UI
class Ex19CartBloc extends StatelessWidget {
  const Ex19CartBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(),
      child: const CartView(),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex19: Shopping Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Center(
                  child: Badge(
                    label: Text('${state.items.length}'),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: const CatalogList()),
          const Divider(height: 1, thickness: 2),
          SizedBox(
            height: 200,
            child: const CartList(), // Danh sách giỏ hàng bên dưới
          ),
        ],
      ),
    );
  }
}

class CatalogList extends StatelessWidget {
  const CatalogList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('CATALOG', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _catalog.length,
            itemBuilder: (context, index) {
              final item = _catalog[index];
              return ListTile(
                leading: Container(width: 40, height: 40, color: item.color),
                title: Text(item.name),
                subtitle: Text('\$${item.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    context.read<CartBloc>().add(CartItemAdded(item));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${item.name}'),
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CartList extends StatelessWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('YOUR CART',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      'Total: \$${state.totalPrice}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return ListTile(
                      dense: true,
                      leading: Icon(Icons.circle, color: item.color, size: 16),
                      title: Text(item.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () {
                          context.read<CartBloc>().add(CartItemRemoved(item));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
