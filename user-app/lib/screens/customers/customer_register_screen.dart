import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/logo.dart';
import 'package:foodie/components/register_input.dart';

import 'customer_login_screen.dart';

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool emailEmpty = false;
  bool phoneEmpty = false;
  bool passwordEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            Logo(),
            const SizedBox(
              height: 50,
            ),
            RegisterInput(
                label: "Email",
                errorMessage: "Email cannot be empty",
                hintText: "Enter your email",
                isEmpty: emailEmpty,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                obscure: false),
            const SizedBox(
              height: 20,
            ),
            RegisterInput(
                label: "Phone",
                errorMessage: "Phone cannot be empty",
                hintText: "Enter your phone number",
                isEmpty: phoneEmpty,
                controller: phoneController,
                keyboardType: TextInputType.number,
                obscure: false),
            const SizedBox(
              height: 20,
            ),
            RegisterInput(
                label: "Password",
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
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isEmpty) {
                      setState(() {
                        emailEmpty = true;
                      });
                    } else if (phoneController.text.isEmpty) {
                      setState(() {
                        phoneEmpty = true;
                      });
                    } else if (passwordController.text.isEmpty) {
                      setState(() {
                        passwordEmpty = true;
                      });
                    } else {
                      FirebaseFirestore.instance.collection("Users").add({
                        "user_email": emailController.text,
                        "user_password": passwordController.text,
                        "user_phone": phoneController.text,
                        "user_wallet_id": "",
                        "user_cart_id": "",
                        "image": "",
                      }).then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerLoginScreen()),
                          (route) => false));
                    }
                  },
                  child: const Text("Register")),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerLoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Color(0xffeb721a)),
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      )),
    );
  }
}
