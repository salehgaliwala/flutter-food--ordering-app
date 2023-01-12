import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/customers/customer_top_up_screen.dart';
import 'package:foodie/screens/vendors/vendor_withdraw_screens.dart';

import '../../components/warning_dialog.dart';

class CustomerWalletScreen extends StatefulWidget {
  final String customerId;
  const CustomerWalletScreen({super.key, required this.customerId});

  @override
  State<CustomerWalletScreen> createState() => _CustomerWalletScreenState();
}

class _CustomerWalletScreenState extends State<CustomerWalletScreen> {
  double vendorBalance = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(widget.customerId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!['user_wallet_id'] == "") {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("UserWallet")
                                .doc(widget.customerId)
                                .set({
                              "user_balance": "0",
                            }).then((value) {
                              snapshot.data!.reference.update({
                                "user_wallet_id": widget.customerId,
                              });
                              // FirebaseFirestore.instance
                              //     .collection("Users")
                              //     .doc(widget.customerId)
                              //     .update({
                              //   "user_wallet_id": widget.customerId,
                              // });
                            });
                          },
                          child: const Text("Open my wallet"),
                        ),
                      ),
                    );
                  } else if (snapshot.data!['user_wallet_id'] != "") {
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
                                    .collection("UserWallet")
                                    .doc(widget.customerId)
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
                                        snapshot.data!['user_balance']);
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerTopUpScreen(
                                                      balance: double.parse(
                                                          snapshot.data![
                                                              'user_balance']),
                                                      customerId:
                                                          widget.customerId,
                                                    )));
                                      },
                                      child: Container(
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "RM ${double.parse(snapshot.data!['user_balance']).toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "Top up",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Transactions")
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
                                                  ['user_id'] ==
                                              widget.customerId) {
                                            return ListTile(
                                              title: Text(snapshot
                                                              .data!.docs[index]
                                                          ['type'] ==
                                                      "1"
                                                  ? "Top up"
                                                  : snapshot.data!.docs[index]
                                                              ['type'] ==
                                                          "2"
                                                      ? "Food"
                                                      : snapshot.data!.docs[
                                                                      index]
                                                                  ['type'] ==
                                                              "3"
                                                          ? "Refund"
                                                          : ""),
                                              subtitle: Text(snapshot
                                                  .data!.docs[index]['time']),
                                              trailing: Text(
                                                "RM ${double.parse(snapshot.data!.docs[index]['amount']).toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              leading: Image.asset(
                                                snapshot.data!.docs[index]
                                                            ['type'] ==
                                                        "1"
                                                    ? "assets/top-up.png"
                                                    : snapshot.data!.docs[index]
                                                                ['type'] ==
                                                            "2"
                                                        ? "assets/dish.png"
                                                        : snapshot.data!.docs[
                                                                        index]
                                                                    ['type'] ==
                                                                "3"
                                                            ? "assets/cashback.png"
                                                            : "",
                                                width: 40,
                                                height: 40,
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        });
                                  }
                                  return const SizedBox();
                                }),
                            const SizedBox(
                              height: 20,
                            ),

                            // ),
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
