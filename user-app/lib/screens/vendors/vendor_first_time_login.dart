import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/logo.dart';
import 'package:foodie/components/register_input.dart';
import 'package:foodie/screens/vendors/vendor_home_screen.dart';

class VendorFirstTimeLogin extends StatefulWidget {
  final String vendorId;
  const VendorFirstTimeLogin({super.key, required this.vendorId});

  @override
  State<VendorFirstTimeLogin> createState() => _VendorFirstTimeLoginState();
}

class _VendorFirstTimeLoginState extends State<VendorFirstTimeLogin> {
  TextEditingController newUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool usernameEmpty = false;
  bool passwordEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Logo(),
            const SizedBox(
              height: 20,
            ),
            const Text("Please update your username and password"),
            const SizedBox(
              height: 20,
            ),
            RegisterInput(
                label: "New Username",
                errorMessage: "Username cannot be empty",
                hintText: "Enter your username",
                isEmpty: usernameEmpty,
                controller: newUsernameController,
                keyboardType: TextInputType.emailAddress,
                obscure: false),
            const SizedBox(
              height: 20,
            ),
            RegisterInput(
                label: "New Password",
                errorMessage: "Password cannot be empty",
                hintText: "Enter your password",
                isEmpty: passwordEmpty,
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                obscure: true),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (newUsernameController.text.isEmpty) {
                      setState(() {
                        usernameEmpty = true;
                      });
                    }
                    if (passwordController.text.isEmpty) {
                      setState(() {
                        passwordEmpty = true;
                      });
                    }
                    if (newUsernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection("Vendor")
                          .doc(widget.vendorId)
                          .update({
                        "username": newUsernameController.text,
                        "password": passwordController.text,
                        "first_time": "0",
                      }).then((value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VendorHomeScreen(
                                        vendorId: widget.vendorId,
                                      )),
                              (route) => false));
                    }
                  },
                  child: const Text("Confirm")),
            )
          ],
        ),
      )),
    );
  }
}
