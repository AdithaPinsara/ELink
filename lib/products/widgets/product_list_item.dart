import 'package:elink/cart/bloc/cart_bloc.dart';
import 'package:elink/products/models/product.dart';
import 'package:elink/products/view/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name),
        subtitle: Text("\$${product.price}"),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            final cartBloc = BlocProvider.of<CartBloc>(context);
            cartBloc.add(CartItemAdded(product));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added to cart')),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productId: product.id),
            ),
          );
        },
      ),
    );
  }
}
