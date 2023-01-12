import 'package:flutter/material.dart';
import 'package:foodie/screens/vendors/vendor_register_screen.dart';

import 'customers/customer_register_screen.dart';

class SwitchScreen extends StatelessWidget {
  const SwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorRegisterScreen(),
                    ),
                  );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text("Vendor"))),
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerRegisterScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text("Customer"),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
