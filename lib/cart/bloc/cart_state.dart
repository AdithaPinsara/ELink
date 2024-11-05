part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final double totalPrice;
  final int itemCount;

  const CartState({
    this.items = const [],
    this.totalPrice = 0.0,
    this.itemCount = 0,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? totalPrice,
    int? itemCount,
  }) {
    return CartState(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  List<Object> get props => [items, totalPrice, itemCount];
}
