import 'package:bloc/bloc.dart';
import 'package:elink/cart/models/cart_item.dart';
import 'package:equatable/equatable.dart';
import 'package:elink/products/models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final Box<CartItem> cartBox;

  CartBloc({required this.cartBox}) : super(const CartState()) {
    on<CartInitialized>(_onCartInitialized); // Handler for initialization
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCleared>(_onCartCleared);

    // Trigger the initialization event
    add(CartInitialized());
  }

  Future<void> _onCartInitialized(
      CartInitialized event, Emitter<CartState> emit) async {
    final items = cartBox.values.toList();
    final totalPrice = _calculateTotalPrice(items);

    emit(state.copyWith(
      items: items,
      totalPrice: totalPrice,
      itemCount: items.length,
    ));
  }

  Future<void> _saveCartToLocalStorage(List<CartItem> items) async {
    await cartBox.clear();
    await cartBox.addAll(items);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final existingItem = state.items.firstWhere(
      (item) => item.product.id == event.product.id,
      orElse: () => CartItem(product: event.product, quantity: 0),
    );

    final updatedItems = List<CartItem>.from(state.items);
    if (existingItem.quantity > 0) {
      final index = updatedItems.indexOf(existingItem);
      updatedItems[index] = CartItem(
        product: existingItem.product,
        quantity: existingItem.quantity + 1,
      );
    } else {
      updatedItems.add(CartItem(product: event.product, quantity: 1));
    }

    final updatedPrice = _calculateTotalPrice(updatedItems);

    emit(state.copyWith(
      items: updatedItems,
      totalPrice: updatedPrice,
      itemCount: updatedItems.length,
    ));

    _saveCartToLocalStorage(updatedItems);
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updatedItems = List<CartItem>.from(state.items);
    final existingItem = updatedItems.firstWhere(
      (item) => item.product.id == event.product.id,
      orElse: () => CartItem(product: event.product, quantity: 0),
    );

    if (existingItem.quantity > 1) {
      final index = updatedItems.indexOf(existingItem);
      updatedItems[index] = CartItem(
        product: existingItem.product,
        quantity: existingItem.quantity - 1,
      );
    } else {
      updatedItems.remove(existingItem);
    }

    final updatedPrice = _calculateTotalPrice(updatedItems);

    emit(state.copyWith(
      items: updatedItems,
      totalPrice: updatedPrice,
      itemCount: updatedItems.length,
    ));

    _saveCartToLocalStorage(updatedItems);
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState());
    cartBox.clear();
  }

  double _calculateTotalPrice(List<CartItem> items) {
    return items.fold(
        0, (total, item) => total + (item.product.price * item.quantity));
  }
}
