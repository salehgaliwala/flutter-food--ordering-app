import 'package:flutter/material.dart';

class ShowDialogComponent extends StatelessWidget {
  final TextEditingController controller;
  final String label, hintText;
  final Function() function;
  const ShowDialogComponent(
      {super.key,
      required this.controller,
      required this.label,
      required this.function,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w600),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              fillColor: Colors.grey[300],
              hintText: hintText,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(),
            onPressed: function,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
