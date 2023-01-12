import 'package:flutter/material.dart';

class RegisterInput extends StatelessWidget {
  final String label, errorMessage, hintText;
  final bool isEmpty;
  final TextInputType keyboardType;
  final bool obscure;
  final TextEditingController controller;
  const RegisterInput(
      {super.key,
      required this.label,
      required this.errorMessage,
      required this.hintText,
      required this.isEmpty,
      required this.controller,
      required this.keyboardType,
      required this.obscure});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            obscureText: obscure,
            keyboardType: keyboardType,
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
          ),
          isEmpty
              ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
