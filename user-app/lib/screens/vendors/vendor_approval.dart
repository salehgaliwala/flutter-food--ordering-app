import 'package:flutter/material.dart';
import 'package:foodie/components/logo.dart';

class VendorApproval extends StatelessWidget {
  const VendorApproval({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Logo(),
              SizedBox(
                height: 20,
              ),
              Text("Thank you for your registration"),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: Text(
                  "Admin is verifying your account, this might take 2-3 working days",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
