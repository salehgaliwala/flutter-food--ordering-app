import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/register_input.dart';
import 'package:image_picker/image_picker.dart';

class VendorAddMenu extends StatefulWidget {
  final String vendorId;
  const VendorAddMenu({super.key, required this.vendorId});

  @override
  State<VendorAddMenu> createState() => _VendorAddMenuState();
}

class _VendorAddMenuState extends State<VendorAddMenu> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();

  bool nameEmpty = false;
  bool descrEmpty = false;
  bool codeEmpty = false;
  bool priceEmpty = false;

  String category = "";
  String cuisine = "";
  String newPrice = "";

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
      }
      print(imageUrl);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Add Menu"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: pickImage,
                child: imageUrl == ""
                    ? Container(
                        height: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                        width: MediaQuery.of(context).size.width,
                        child: const Text("Add picture"),
                      )
                    : Container(
                        height: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                        width: MediaQuery.of(context).size.width,
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              RegisterInput(
                  label: "Item name",
                  errorMessage: "Item name cannot be empty",
                  hintText: "Enter item name",
                  isEmpty: nameEmpty,
                  controller: itemNameController,
                  keyboardType: TextInputType.emailAddress,
                  obscure: false),
              const SizedBox(
                height: 20,
              ),
              RegisterInput(
                  label: "Item description",
                  errorMessage: "Item description cannot be empty",
                  hintText: "Enter item description",
                  isEmpty: descrEmpty,
                  controller: itemDescController,
                  keyboardType: TextInputType.emailAddress,
                  obscure: false),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Item code"),
                        TextField(
                          controller: itemCodeController,
                          decoration: const InputDecoration(
                              hintText: "Enter item code"),
                        ),
                        codeEmpty
                            ? const Text(
                                "Item code cannot be empty",
                                style: TextStyle(color: Colors.red),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Item price"),
                        TextField(
                          controller: itemPriceController,
                          decoration:
                              const InputDecoration(hintText: "RM 10.00"),
                        ),
                        priceEmpty
                            ? const Text(
                                "Item price cannot be empty",
                                style: TextStyle(color: Colors.red),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Cuisine")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return ExpansionTile(
                        title: Text(cuisine == "" ? "Category" : cuisine),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      cuisine = snapshot.data!.docs[index]
                                          ['cuisine_name'];
                                    });
                                  },
                                  title: Text(snapshot.data!.docs[index]
                                      ['cuisine_name']),
                                  // title: Text(
                                  //     snapshot.data!.docs[index]['location']),
                                );
                              })
                        ],
                      );
                    }
                    return const SizedBox();
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Category")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return ExpansionTile(
                        title: Text(category == "" ? "Category" : category),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data!.docs[index]['cuisine'] ==
                                    cuisine) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        category = snapshot.data!.docs[index]
                                            ['category_name'];
                                      });
                                    },
                                    title: Text(snapshot.data!.docs[index]
                                        ['category_name']),
                                    // title: Text(
                                    //     snapshot.data!.docs[index]['location']),
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
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Confirm"),
                  onPressed: () {
                    FirebaseFirestore.instance.collection("Menus").add({
                      "vendor_id": widget.vendorId,
                      "item_name": itemNameController.text,
                      "item_price": itemPriceController.text,
                      "item_availability": "1",
                      "category": category != "" ? category : "",
                      "cuisine": cuisine != "" ? cuisine : "",
                      "image": imageUrl,
                      "item_code": itemCodeController.text,
                      "item_description": itemDescController.text,
                    }).then((value) => Navigator.pop(context));
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
