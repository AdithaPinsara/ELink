// cart_item.dart
import 'package:elink/products/models/product.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}
