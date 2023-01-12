import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String customerId;
  const OrderHistoryScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Order History"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [],
          ),
        ),
      )),
    );
  }
}
