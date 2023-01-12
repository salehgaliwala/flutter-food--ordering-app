import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String label;
  const SuccessDialog({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      color: Color.fromARGB(255, 26, 206, 65),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 3, color: Colors.white)),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
