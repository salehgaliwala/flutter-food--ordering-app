import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/bloc/cubit.dart';
import 'package:foodie/components/logo.dart';
import 'package:foodie/components/register_input.dart';
import 'package:foodie/screens/vendors/vendor_first_time_login.dart';
import 'package:foodie/screens/vendors/vendor_home_screen.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  TextEditingController vendorUsername = TextEditingController();
  TextEditingController vendorPassword = TextEditingController();
  bool usernameEmpty = false;
  bool passwordEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Logo(),
              const SizedBox(
                height: 50,
              ),
              RegisterInput(
                obscure: false,
                controller: vendorUsername,
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter your username",
                isEmpty: usernameEmpty,
                errorMessage: "Username cannot be empty",
                label: "Username",
              ),
              const SizedBox(
                height: 20,
              ),
              RegisterInput(
                obscure: true,
                controller: vendorPassword,
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter your password",
                isEmpty: passwordEmpty,
                errorMessage: "Password cannot be empty",
                label: "Password",
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Vendor")
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text("Login"),
                          onPressed: () {
                            if (vendorUsername.text.isEmpty) {
                              setState(() {
                                usernameEmpty = true;
                              });
                            } else if (vendorPassword.text.isEmpty) {
                              setState(() {
                                passwordEmpty = true;
                              });
                            } else {
                              for (int i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
                                if (snapshot.data!.docs[i]['username'] ==
                                        vendorUsername.text &&
                                    snapshot.data!.docs[i]['password'] ==
                                        vendorPassword.text &&
                                    snapshot.data!.docs[i]['first_time'] ==
                                        "1") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VendorFirstTimeLogin(
                                                  vendorId: snapshot.data!
                                                      .docs[i].reference.id)));
                                } else if (snapshot.data!.docs[i]['username'] ==
                                        vendorUsername.text &&
                                    snapshot.data!.docs[i]['password'] ==
                                        vendorPassword.text &&
                                    snapshot.data!.docs[i]['first_time'] !=
                                        "1") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VendorHomeScreen(
                                                  vendorId: snapshot.data!
                                                      .docs[i].reference.id)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: Container(
                                              width: 300,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.red
                                                      .withOpacity(10)),
                                              child: Column(children: [
                                                Text(
                                                    "Wrong username or password"),
                                              ]),
                                            ),
                                          ));
                                }
                              }
                            }
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  })),
              const SizedBox(
                height: 20,
              ),
              const Text("Forgot password"),
            ],
          ),
        ),
      )),
    );
  }
}
