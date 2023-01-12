import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/vendors/vendor_add_menu.dart';
import 'package:foodie/screens/vendors/vendor_edit_menu_screen.dart';

class MyMenuScreen extends StatelessWidget {
  final String vendorId;
  const MyMenuScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("My Menu"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Menus")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]['vendor_id'] ==
                                vendorId) {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VendorEditMenu(
                                            data: snapshot.data!.docs[index],
                                                menuId: snapshot.data!
                                                    .docs[index].reference.id,
                                                vendorId: vendorId,
                                              )));
                                },
                                leading: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snapshot
                                            .data!.docs[index]['image']),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                title: Text(
                                    snapshot.data!.docs[index]['item_name']),
                                subtitle: Text(snapshot.data!.docs[index]
                                    ['item_description']),
                                trailing: Text(
                                    "RM ${double.parse(snapshot.data!.docs[index]['item_price']).toStringAsFixed(2)}"),
                              );
                            } else if (snapshot.data!.docs[index]
                                    ['vendor_id'] !=
                                vendorId) {
                              return const SizedBox();
                            }
                            return const SizedBox();
                          });
                    }
                    return const SizedBox();
                  }),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text("Add Menu"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VendorAddMenu(vendorId: vendorId)));
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      )),
    );
  }
}
