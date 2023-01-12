import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/edit_input.dart';

class VendorEditProfile extends StatefulWidget {
  final String vendorId;
  const VendorEditProfile({super.key, required this.vendorId});

  @override
  State<VendorEditProfile> createState() => _VendorEditProfileState();
}

class _VendorEditProfileState extends State<VendorEditProfile> {
  TextEditingController openController = TextEditingController();
  TextEditingController closeController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController descController = TextEditingController();
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
              .collection("Vendor")
              .doc(widget.vendorId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  EditInputComponent(
                      label: "Open Hour",
                      hintText: snapshot.data!['open_time'],
                      function: () {
                        snapshot.data!.reference.update({
                          "open_time": openController.text,
                        });
                      },
                      controller: openController),
                  const SizedBox(
                    height: 20,
                  ),
                  EditInputComponent(
                      label: "Close Hour",
                      hintText: snapshot.data!['close_time'],
                      function: () {
                        snapshot.data!.reference.update({
                          "close_time": closeController.text,
                        });
                      },
                      controller: closeController),
                  const SizedBox(
                    height: 20,
                  ),
                  EditInputComponent(
                      label: "Bio",
                      hintText: snapshot.data!['bio'],
                      function: () {
                        snapshot.data!.reference.update({
                          "bio": bioController.text,
                        });
                      },
                      controller: bioController),
                  const SizedBox(
                    height: 20,
                  ),
                  EditInputComponent(
                      label: "Description",
                      hintText: snapshot.data!['description'],
                      function: () {
                        snapshot.data!.reference.update({
                          "description": descController.text,
                        });
                      },
                      controller: descController),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (snapshot.data!['type'] == "1") {
                            snapshot.data!.reference.update({
                              "type": "2",
                            });
                          } else if (snapshot.data!['type'] == "2") {
                            snapshot.data!.reference.update({
                              "type": "1",
                            });
                          }
                        },
                        child: Text(snapshot.data!['type'] == "1"
                            ? "Set Close"
                            : snapshot.data!['type'] == "2"
                                ? "Set Open"
                                : "")),
                  )
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
