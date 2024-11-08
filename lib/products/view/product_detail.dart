import 'package:elink/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elink/products/bloc/product_bloc.dart';
import 'package:elink/products/models/product.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(httpClient: http.Client())
        ..add(ProductDetailFetched(productId)),
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        //title
        appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: const Text(
              'Product Details',
              style: TextStyle(fontSize: 30),
            )),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state.productDetailStatus == ProductDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.productDetailStatus ==
                    ProductDetailStatus.success &&
                state.selectedProduct != null) {
              final Product product = state.selectedProduct!;
              //product details
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.network(product.imageUrl, height: 200)),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(product.name,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    const SizedBox(height: 8),
                    Text('\$${product.price}',
                        style: TextStyle(fontSize: 25, color: Colors.red[700])),
                    const SizedBox(height: 16),
                    Text(product.description,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        //add the product to cart
                        final cartBloc = BlocProvider.of<CartBloc>(context);
                        cartBloc.add(CartItemAdded(product));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Product added to cart')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Failed to load product'));
            }
          },
        ),
      ),
    );
  }
}
