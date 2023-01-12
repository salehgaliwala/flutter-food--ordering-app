import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/logo.dart';
import 'package:foodie/components/register_input.dart';
import 'package:foodie/screens/vendors/vendor_approval.dart';
import 'package:foodie/screens/vendors/vendor_login_screen.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController restaurantNameController = TextEditingController();
  bool emailIsEmpty = false;
  bool phoneIsEmpty = false;
  bool restaurantIsEmpty = false;
  String location = "Location";
  String mall = "Mall";
  String locationId = "";
  String mallId = "";

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
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter your email",
                  isEmpty: emailIsEmpty,
                  errorMessage: "Email cannot be empty",
                  label: "Email",
                ),
                const SizedBox(
                  height: 20,
                ),
                RegisterInput(
                  obscure: false,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  hintText: "Enter your phone number",
                  isEmpty: phoneIsEmpty,
                  errorMessage: "Phone cannot be empty",
                  label: "Phone",
                ),
                const SizedBox(
                  height: 20,
                ),
                RegisterInput(
                  obscure: false,
                  keyboardType: TextInputType.name,
                  controller: restaurantNameController,
                  hintText: "Enter your restaurant name",
                  isEmpty: restaurantIsEmpty,
                  errorMessage: "Restaurant name cannot be empty",
                  label: "Restaurant Name",
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Location")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return ExpansionTile(
                          title: Text(location),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        location = snapshot.data!.docs[index]
                                            ['location'];
                                        locationId = snapshot
                                            .data!.docs[index].reference.id;
                                      });
                                    },
                                    title: Text(
                                        snapshot.data!.docs[index]['location']),
                                  );
                                })
                          ],
                        );
                      }
                      return const SizedBox();
                    }),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Mall")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return ExpansionTile(
                          title: Text(mall),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data!.docs[index]
                                          ['location_id'] ==
                                      locationId) {
                                    return ListTile(
                                      onTap: () {
                                        setState(() {
                                          mall = snapshot.data!.docs[index]
                                              ['mall'];
                                          mallId = snapshot
                                              .data!.docs[index].reference.id;
                                        });
                                      },
                                      title: Text(
                                          snapshot.data!.docs[index]['mall']),
                                    );
                                  }
                                  return const SizedBox();
                                })
                          ],
                        );
                      }
                      return const SizedBox();
                    }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isEmpty) {
                        setState(() {
                          emailIsEmpty == true;
                        });
                      } else if (phoneController.text.isEmpty) {
                        setState(() {
                          phoneIsEmpty == true;
                        });
                      } else if (restaurantNameController.text.isEmpty) {
                        setState(() {
                          restaurantIsEmpty == true;
                        });
                      }
                      {
                        FirebaseFirestore.instance.collection("Vendor").add({
                          "vendor_email": emailController.text,
                          "vendor_phone": phoneController.text,
                          "vendor_walletl_id": "", //initally empty
                          "location_id": location,
                          "mall_id": mall,
                          "restaurant_name": restaurantNameController.text,
                          "image": "",
                          "type": "0",
                          "first_time": "1",
                          "username": "",
                          "password": "",
                          "open_time": "",
                          "close_time": "",
                          "bio": "",
                          "description": "",
                        }).then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VendorApproval())));
                      }
                    },
                    child: const Text("Register"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text("Already have an account, "),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VendorLoginScreen()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
