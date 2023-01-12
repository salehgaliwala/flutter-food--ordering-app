import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/logo.dart';
import 'package:foodie/components/register_input.dart';
import 'package:foodie/components/warning_dialog.dart';
import 'package:foodie/screens/customers/customer_register_screen.dart';

import 'customer_screens.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool emailEmpty = false;
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
                label: "Password",
                errorMessage: "Password cannot be empty",
                hintText: "Enter your password",
                isEmpty: passwordEmpty,
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                obscure: true),
            const SizedBox(
              height: 50,
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
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
                            }
                            if (passwordController.text.isEmpty) {
                              setState(() {
                                passwordEmpty = true;
                              });
                            }
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              for (int i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
                                if (snapshot.data!.docs[i]['user_email'] ==
                                        emailController.text &&
                                    snapshot.data!.docs[i]['user_password'] ==
                                        passwordController.text) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CustomerScreens(
                                                customerId: snapshot
                                                    .data!.docs[i].reference.id,
                                              )),
                                      (route) => false);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: WarningDialog(
                                                label:
                                                    "Invalid email or password"),
                                          ));
                                }
                              }
                            }
                          },
                          child: const Text("Login")),
                    );
                  }
                  return const SizedBox();
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerRegisterScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xffeb721a)),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Forgot password"),
                )),
          ]),
        ),
      )),
    );
  }
}
