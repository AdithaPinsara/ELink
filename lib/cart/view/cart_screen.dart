import 'package:elink/cart/view/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elink/cart/bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text(
            'Cart',
            style: TextStyle(fontSize: 30),
          )),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
                child: Text(
              'Your cart is empty.',
              style: TextStyle(fontSize: 30),
            ));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = state.items[index];
                    return ListTile(
                      title: Text(cartItem.product.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                      subtitle: Text(
                          '\$${cartItem.product.price}   X ${cartItem.quantity}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          context
                              .read<CartBloc>()
                              .add(CartItemRemoved(cartItem.product));
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total Price: \$${state.totalPrice}',
                      style: const TextStyle(color: Colors.red, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<CartBloc>().add(CartCleared());
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
                          child: const Text('Clear Cart'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const CheckoutScreen()), // Navigate to checout
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
                          child: const Text("Checkout",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
