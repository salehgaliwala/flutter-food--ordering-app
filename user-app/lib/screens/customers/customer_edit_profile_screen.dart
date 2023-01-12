import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/edit_input.dart';

class CustomerEditProfile extends StatefulWidget {
  final String customerId;
  const CustomerEditProfile({super.key, required this.customerId});

  @override
  State<CustomerEditProfile> createState() => _CustomerEditProfileState();
}

class _CustomerEditProfileState extends State<CustomerEditProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Edit Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(widget.customerId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  EditInputComponent(
                      label: "Email",
                      hintText: snapshot.data!['user_email'],
                      function: () {
                        snapshot.data!.reference.update({
                          "user_email": emailController.text,
                        });
                      },
                      controller: emailController),
                  const SizedBox(
                    height: 20,
                  ),
                  EditInputComponent(
                      label: "Phone",
                      hintText: snapshot.data!['user_phone'],
                      function: () {
                        snapshot.data!.reference.update({
                          "user_phone": phoneController.text,
                        });
                      },
                      controller: phoneController),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        )),
      ),
    );
  }
}
