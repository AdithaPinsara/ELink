import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:elink/products/models/product.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends Equatable {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}
