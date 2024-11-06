import 'package:flutter/material.dart';

class CheckoutFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;

  const CheckoutFormTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.blueGrey[700],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.blueGrey[400]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.blueGrey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
