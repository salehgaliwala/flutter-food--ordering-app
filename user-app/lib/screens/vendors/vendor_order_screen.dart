import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/vendors/order_details.dart';

class VendorOrderScreen extends StatefulWidget {
  final String vendorId;
  const VendorOrderScreen({super.key, required this.vendorId});

  @override
  State<VendorOrderScreen> createState() => _VendorOrderScreenState();
}

class _VendorOrderScreenState extends State<VendorOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("Cart").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]['vendor_id'] ==
                                widget.vendorId) {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                                data:
                                                    snapshot.data!.docs[index],
                                              )));
                                },
                                leading: Image.network(
                                    snapshot.data!.docs[index]['image']),
                                title: Text(
                                    snapshot.data!.docs[index]['item_name']),
                                subtitle: Text(
                                    "X ${snapshot.data!.docs[index]['quantity']}"),
                                trailing: Text(
                                    "RM ${snapshot.data!.docs[index]['total_price']}"),
                              );
                            }
                            return const SizedBox();
                          });
                    }
                    return const SizedBox();
                  })
            ],
          ),
        ),
      )),
    );
  }
}
