import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final String customerId;
  const OrderScreen({super.key, required this.customerId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Cart").snapshots(),
              builder: (context, snapshot11) {
                if (snapshot11.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot11.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot11.data!.docs[index]['user_id'] ==
                                widget.customerId &&
                            snapshot11.data!.docs[index]['type'] == "0") {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                      color: Colors.amber[300],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.asset(
                                    "assets/cooking.png",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Order")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 70),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 2),
                                                            shape: BoxShape
                                                                .circle),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("Order accepted"),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    width: 5,
                                                    height: 30,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 2),
                                                            shape: BoxShape
                                                                .circle),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("Order accepted"),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    width: 5,
                                                    height: 30,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 2),
                                                            shape: BoxShape
                                                                .circle),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text("Order accepted"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      );
                                    }
                                    return const SizedBox();
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Order")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            if (snapshot.data!.docs[index]
                                                    ['user_id'] ==
                                                widget.customerId) {
                                              return StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("Cart")
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['cart_id'])
                                                      .snapshots(),
                                                  builder:
                                                      (context, snapshot11) {
                                                    if (snapshot11.hasData) {
                                                      return ExpansionTile(
                                                        title: Text(
                                                            "View Details"),
                                                        children: [
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(snapshot11
                                                                      .data![
                                                                  'item_name'])),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  "Price: RM ${snapshot11.data!['item_price']}")),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  "Quantity: X ${snapshot11.data!['quantity']}")),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  "Total: RM ${snapshot11.data!['total_price']}")),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  snapshot11
                                                                          .data![
                                                                      'time'])),
                                                        ],
                                                      );
                                                    }
                                                    return const SizedBox();
                                                  });
                                            }
                                            return const SizedBox();
                                          });
                                    }
                                    return const SizedBox();
                                  }),
                            ],
                          );
                        }
                      });
                }
                return const SizedBox();
              },
            )),
      )),
    );
  }
}
