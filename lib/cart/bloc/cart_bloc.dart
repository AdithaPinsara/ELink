// cart_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:elink/cart/models/cart_item.dart';
import 'package:equatable/equatable.dart';
import 'package:elink/products/models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCleared>(_onCartCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    // Check if the item is already in the cart
    final existingItem = state.items.firstWhere(
      (item) => item.product.id == event.product.id,
      orElse: () => CartItem(product: event.product, quantity: 0),
    );

    final updatedItems = List<CartItem>.from(state.items);
    if (existingItem.quantity > 0) {
      // If it exists, increase the quantity
      final index = updatedItems.indexOf(existingItem);
      updatedItems[index] = CartItem(
        product: existingItem.product,
        quantity: existingItem.quantity + 1,
      );
    } else {
      // If not, add it to the cart with quantity 1
      updatedItems.add(CartItem(product: event.product, quantity: 1));
    }

    final updatedPrice = _calculateTotalPrice(updatedItems);

    emit(state.copyWith(
      items: updatedItems,
      totalPrice: updatedPrice,
      itemCount: updatedItems.length,
    ));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updatedItems = List<CartItem>.from(state.items);
    final existingItem = updatedItems.firstWhere(
      (item) => item.product.id == event.product.id,
      orElse: () => CartItem(product: event.product, quantity: 0),
    );

    if (existingItem.quantity > 1) {
      // Decrease quantity if more than 1
      final index = updatedItems.indexOf(existingItem);
      updatedItems[index] = CartItem(
        product: existingItem.product,
        quantity: existingItem.quantity - 1,
      );
    } else {
      // Remove the item if quantity is 1
      updatedItems.remove(existingItem);
    }

    final updatedPrice = _calculateTotalPrice(updatedItems);

    emit(state.copyWith(
      items: updatedItems,
      totalPrice: updatedPrice,
      itemCount: updatedItems.length,
    ));
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  double _calculateTotalPrice(List<CartItem> items) {
    return items.fold(
        0, (total, item) => total + (item.product.price * item.quantity));
  }
}
