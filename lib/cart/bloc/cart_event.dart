part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//add item to cart event
final class CartItemAdded extends CartEvent {
  final Product product;

  CartItemAdded(this.product);

  @override
  List<Object> get props => [product];
}

//item remove event
final class CartItemRemoved extends CartEvent {
  final Product product;

  CartItemRemoved(this.product);

  @override
  List<Object> get props => [product];
}

//cart clear event
final class CartCleared extends CartEvent {}
