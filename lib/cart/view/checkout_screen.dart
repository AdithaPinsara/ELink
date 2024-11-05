import 'package:elink/cart/bloc/cart_bloc.dart';
import 'package:elink/cart/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  // Calculate total price based on cart items from the CartBloc
  double getTotalPrice(List<CartItem> cartItems) {
    return cartItems.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    // Form controllers
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final cartItems = state.items;
            if (cartItems.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Information Form
                  Text("Shipping Information",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cart Summary
                  Text("Order Summary",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text("Quantity: ${item.quantity}"),
                        trailing: Text(
                            "\$${(item.product.price * item.quantity).toStringAsFixed(2)}"),
                      );
                    },
                  ),
                  const Divider(),

                  // Total Price
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("\$${getTotalPrice(cartItems).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Place Order Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate form fields
                        if (nameController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill out all fields")),
                          );
                          return;
                        }

                        // Show a confirmation message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Order placed successfully!")),
                        );

                        // Clear form fields
                        nameController.clear();
                        addressController.clear();
                        phoneController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text("Place Order"),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No Items in the Cart"));
            }
          },
        ),
      ),
    );
  }
}
