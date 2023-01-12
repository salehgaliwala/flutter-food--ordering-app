import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/switch_screen.dart';
import 'package:foodie/screens/vendors/vendor_edit_profile_screen.dart';
import 'package:image_picker/image_picker.dart';

class VendorProfileScreen extends StatefulWidget {
  final String vendorId;
  const VendorProfileScreen({super.key, required this.vendorId});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  ImagePicker imagePicker = ImagePicker();
  XFile? file;
  String imageUrl = "";
  bool isLoading = false;
  bool canUpload = false;
  void pickImage() async {
    isLoading = true;
    file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    // upload to firebase storage
    // get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('image');

    //create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueName);

    //handle errors
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(file!.path));

      imageUrl = await referenceImageToUpload.getDownloadURL();
      if (imageUrl != null) {
        setState(() {
          isLoading = false;
          canUpload = true;
        });
        FirebaseFirestore.instance
            .collection("Vendor")
            .doc(widget.vendorId)
            .update({
          "image": imageUrl,
        });
      }
      print(imageUrl);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Vendor")
            .doc(widget.vendorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot.data!['image'] != ""
                      ? Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(snapshot.data!['image']),
                                  fit: BoxFit.cover)),
                        )
                      : InkWell(
                          onTap: pickImage,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.amber[300],
                            child: Text("Add a photo"),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data!['type'] == "1"
                              ? "Open"
                              : snapshot.data!['type'] == "2"
                                  ? "Closed"
                                  : "",
                          style: TextStyle(
                              color: snapshot.data!['type'] == "1"
                                  ? Colors.green
                                  : snapshot.data!['type'] == "2"
                                      ? Colors.red
                                      : Colors.amber),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VendorEditProfile(
                                            vendorId: widget.vendorId,
                                          )));
                            },
                            child: const Text('Edit Profile >'))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                        "${snapshot.data!['mall_id']}, ${snapshot.data!['location_id']}"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("${snapshot.data!['restaurant_name']}"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Open hour: ${snapshot.data!['open_time']}"),
                        Text("Close hour: ${snapshot.data!['close_time']}"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Bio: ${snapshot.data!['bio']}"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        Text("Description: ${snapshot.data!['description']}"),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SwitchScreen()),
                              (route) => false);
                        },
                        child: const Text("Logout")),
                  )
                ]);
          }
          return const SizedBox();
        },
      ))),
    );
  }
}
