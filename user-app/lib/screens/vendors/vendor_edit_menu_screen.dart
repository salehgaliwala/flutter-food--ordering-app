import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/edit_input.dart';

class VendorEditMenu extends StatefulWidget {
  final String vendorId;
  final QueryDocumentSnapshot data;
  final String menuId;
  const VendorEditMenu(
      {super.key,
      required this.vendorId,
      required this.menuId,
      required this.data});

  @override
  State<VendorEditMenu> createState() => _VendorEditMenuState();
}

class _VendorEditMenuState extends State<VendorEditMenu> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();

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
            .collection("Menus")
            .doc(widget.menuId)
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
      appBar: AppBar(
        title: Text(widget.data['item_name']),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            imageUrl == "" ? widget.data['image'] : imageUrl),
                        fit: BoxFit.cover)),
                child: const Text(
                  "Edit Image",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            EditInputComponent(
              label: "Item name",
              function: () {
                FirebaseFirestore.instance
                    .collection("Menus")
                    .doc(widget.menuId)
                    .update({
                  "item_name": itemNameController.text,
                }).then((value) => itemNameController.clear());
              },
              controller: itemNameController,
              hintText: widget.data['item_name'],
            ),
            const SizedBox(
              height: 20,
            ),
            EditInputComponent(
              label: "Item Description",
              function: () {
                FirebaseFirestore.instance
                    .collection("Menus")
                    .doc(widget.menuId)
                    .update({
                  "item_description": itemDescController.text,
                }).then((value) => itemDescController.clear());
              },
              controller: itemDescController,
              hintText: widget.data['item_description'],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  width: 180,
                  child: EditInputComponent(
                    label: "Item Code",
                    function: () {
                      FirebaseFirestore.instance
                          .collection("Menus")
                          .doc(widget.menuId)
                          .update({
                        "item_code": itemCodeController.text,
                      }).then((value) => itemCodeController.clear());
                    },
                    controller: itemCodeController,
                    hintText: widget.data['item_code'],
                  ),
                ),
                Container(
                  width: 180,
                  child: EditInputComponent(
                    label: "Item Price",
                    function: () {
                      FirebaseFirestore.instance
                          .collection("Menus")
                          .doc(widget.menuId)
                          .update({
                        "item_price": itemPriceController.text,
                      }).then((value) => itemPriceController.clear());
                    },
                    controller: itemPriceController,
                    hintText: widget.data['item_price'],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.data['item_availability'] == "0") {
                    FirebaseFirestore.instance
                        .collection("Menus")
                        .doc(widget.menuId)
                        .update({
                      "item_availability": "1",
                    }).then((value) => Navigator.pop(context));
                  } else {
                    FirebaseFirestore.instance
                        .collection("Menus")
                        .doc(widget.menuId)
                        .update({
                      "item_availability": "0",
                    }).then((value) => Navigator.pop(context));
                  }
                },
                child: Text(widget.data['item_availability'] == "1"
                    ? "Not Available"
                    : "Available"),
              ),
            )
          ],
        ),
      )),
    );
  }
}
