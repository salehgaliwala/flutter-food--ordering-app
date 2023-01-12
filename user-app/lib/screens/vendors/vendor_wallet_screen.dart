import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/vendors/vendor_withdraw_screens.dart';

import '../../components/warning_dialog.dart';

class VendorWallet extends StatefulWidget {
  final String vendorId;
  const VendorWallet({super.key, required this.vendorId});

  @override
  State<VendorWallet> createState() => _VendorWalletState();
}

class _VendorWalletState extends State<VendorWallet> {
  double vendorBalance = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Vendor")
                  .doc(widget.vendorId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!['vendor_walletl_id'] == "") {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("VendorWallet")
                                .doc(widget.vendorId)
                                .set({
                              "vendor_balance": "0",
                            }).then((value) {
                              FirebaseFirestore.instance
                                  .collection("Vendor")
                                  .doc(widget.vendorId)
                                  .update({
                                "vendor_walletl_id": widget.vendorId,
                              });
                            });
                          },
                          child: const Text("Open my wallet"),
                        ),
                      ),
                    );
                  } else if (snapshot.data!['vendor_walletl_id'] != "") {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("VendorWallet")
                                    .doc(widget.vendorId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    vendorBalance = double.parse(
                                        snapshot.data!['vendor_balance']);
                                    return Container(
                                      height: 150,
                                      width: double.infinity,
                                      padding:
                                          const EdgeInsetsDirectional.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xffeb721a)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            "Foodie Wallet",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text(
                                            "Balance",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "RM ${double.parse(snapshot.data!['vendor_balance']).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Transactions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 300,
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("VendorTransactions")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            if (snapshot.data!.docs[index]
                                                        ['approval'] ==
                                                    "1" &&
                                                snapshot.data!.docs[index]
                                                        ['vendor_id'] ==
                                                    widget.vendorId) {
                                              return ListTile(
                                                leading: Image.asset(
                                                  "assets/takeover.png",
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                title: Text(
                                                    snapshot.data!.docs[index]
                                                                ['type'] ==
                                                            "1"
                                                        ? "Withdrawal"
                                                        : ""),
                                                subtitle: Text(snapshot
                                                    .data!.docs[index]['time']),
                                                trailing: Text(
                                                  "RM ${double.parse(snapshot.data!.docs[index]['amount']).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              );
                                            }
                                            return const SizedBox();
                                          });
                                    }
                                    return const SizedBox();
                                  }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: const Text("Withdraw"),
                                onPressed: () {
                                  if (vendorBalance <= 0) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                                child: WarningDialog(
                                              label: "Insufficient Balance",
                                            )));
                                  } else if (vendorBalance > 0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VendorWithdrawScreen(
                                                  vendorId: widget.vendorId,
                                                )));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox();
              })),
    );
  }
}
