import 'package:flutter/material.dart';

class NewVendorComponent extends StatelessWidget {
  final String label;
  final Function() onTap;
  const NewVendorComponent(
      {super.key, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: const Text(
              "View more >",
            ),
          )
        ],
      ),
    );
  }
}
