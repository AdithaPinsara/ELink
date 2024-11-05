// cart_event.dart
part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class CartItemAdded extends CartEvent {
  final Product product;

  CartItemAdded(this.product);

  @override
  List<Object> get props => [product];
}

final class CartItemRemoved extends CartEvent {
  final Product product;

  CartItemRemoved(this.product);

  @override
  List<Object> get props => [product];
}

final class CartCleared extends CartEvent {}
