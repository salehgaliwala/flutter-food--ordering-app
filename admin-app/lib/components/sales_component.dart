import 'package:flutter/material.dart';

class SalesComponent extends StatelessWidget {
  final String data, label;
  const SalesComponent({super.key, required this.data, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            data,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
