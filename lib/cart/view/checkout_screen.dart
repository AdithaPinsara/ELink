import 'package:elink/cart/bloc/cart_bloc.dart';
import 'package:elink/cart/models/cart_item.dart';
import 'package:elink/cart/widgets/checkout_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  //calculate total
  double getTotalPrice(List<CartItem> cartItems) {
    return cartItems.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    //form controllers
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text(
            "Checkout",
            style: TextStyle(fontSize: 30),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final cartItems = state.items;
            if (cartItems.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //shipping Information Form
                  Text("Shipping Information",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),

                  CheckoutFormTextField(
                    controller: nameController,
                    labelText: "Name",
                  ),
                  const SizedBox(height: 10),

                  CheckoutFormTextField(
                    controller: addressController,
                    labelText: "Address",
                  ),
                  const SizedBox(height: 10),

                  CheckoutFormTextField(
                    controller: phoneController,
                    labelText: "Phone Number",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

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
                        title: Text(
                          item.product.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        subtitle: Text(
                          "Quantity: ${item.quantity}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        trailing: Text(
                          "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  //total Price
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text("\$${getTotalPrice(cartItems).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        //validate form fields
                        if (nameController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill out all fields")),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Order placed successfully!")),
                        );

                        //clear form fields
                        nameController.clear();
                        addressController.clear();
                        phoneController.clear();

                        Navigator.pop(context);
                        Navigator.pop(context);
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
