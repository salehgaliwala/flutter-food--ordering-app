import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie3_admin/components/new_vendor_component.dart';
import 'package:foodie3_admin/components/sales_component.dart';
import 'package:foodie3_admin/components/show_dialog.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int locationIndex = 0;
  String locationId = "";
  String locationLabel = "";
  String categoryId = "";
  String categoryLabel = "";
  String cuisineLabel = "";
  TextEditingController locationController = TextEditingController();
  TextEditingController mallController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();

  TextEditingController categoryController = TextEditingController();
  TextEditingController customizationPriceController = TextEditingController();
  TextEditingController customizationController = TextEditingController();
  TextEditingController searchNewVendorController = TextEditingController();
  TextEditingController promotionTitleController = TextEditingController();
  TextEditingController promotionDiscountController = TextEditingController();
  TextEditingController promotionCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SalesComponent(
                    label: "Sales",
                    data: "400,000.00",
                  ),
                  SalesComponent(
                    label: "Customers",
                    data: "400,000.00",
                  ),
                  SalesComponent(
                    label: "Revenue",
                    data: "400,000.00",
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Foodie Users",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: Column(
                      children: [
                        NewVendorComponent(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 20),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 100, vertical: 80),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text("New Vendor List"),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              width: 200,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: TextField(
                                                controller:
                                                    searchNewVendorController,
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Search new vendor"),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("Vendor")
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (snapshot.hasData) {
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['type'] ==
                                                              "0") {
                                                            return ListTile(
                                                              title: Text(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'vendor_email']),
                                                              subtitle: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'restaurant_name']),
                                                                  Text(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'vendor_phone']),
                                                                  Text(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'restaurant_name']),
                                                                ],
                                                              ),
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
                                    ));
                          },
                          label: "New Vendors",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 280,
                          height: 300,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Vendor")
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
                                                ['type'] ==
                                            "0") {
                                          return ListTile(
                                            trailing: ElevatedButton(
                                              onPressed: () {
                                                const _chars =
                                                    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                                Random _rnd = Random();
                                                String getRandomString(
                                                        int length) =>
                                                    String.fromCharCodes(
                                                        Iterable.generate(
                                                            length,
                                                            (_) => _chars
                                                                .codeUnitAt(_rnd
                                                                    .nextInt(_chars
                                                                        .length))));
                                                String username =
                                                    getRandomString(12);
                                                String password =
                                                    getRandomString(8)
                                                        .toString();

                                                snapshot
                                                    .data!.docs[index].reference
                                                    .update({
                                                  "type": "1",
                                                  "password": password,
                                                  "username": username,
                                                });
                                              },
                                              child: const Text("Approve"),
                                            ),
                                            title: Text(snapshot.data!
                                                .docs[index]['vendor_email']),
                                          );
                                        }
                                        return const SizedBox();
                                      });
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: Column(
                      children: [
                        NewVendorComponent(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 20),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 100, vertical: 80),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text("New Vendor List"),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              width: 200,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: TextField(
                                                controller:
                                                    searchNewVendorController,
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Search vendor"),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("Vendor")
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (snapshot.hasData) {
                                                    return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['type'] !=
                                                              "0") {
                                                            return ListTile(
                                                              title: Text(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'vendor_email']),
                                                              subtitle: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'restaurant_name']),
                                                                  Text(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'vendor_phone']),
                                                                  Text(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'location_id']),
                                                                  Text(snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'mall_id']),
                                                                ],
                                                              ),
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
                                    ));
                          },
                          label: "Vendors",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 280,
                          height: 300,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Vendor")
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
                                                ['type'] !=
                                            "0") {
                                          return ListTile(
                                            title: Text(snapshot.data!
                                                .docs[index]['vendor_email']),
                                          );
                                        }
                                        return const SizedBox();
                                      });
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: Column(
                      children: [
                        NewVendorComponent(
                          onTap: () {},
                          label: "Customers",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Promotion Creation",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              Container(
                color: Colors.grey[300],
                width: 600,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 100, vertical: 80),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              "Add a new promotion",
                                              style: const TextStyle(
                                                  fontSize: 38,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            TextField(
                                              controller:
                                                  promotionTitleController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[300],
                                                hintText: "Add promotion title",
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  promotionDiscountController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[300],
                                                hintText: "20%",
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  promotionCodeController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[300],
                                                hintText: "Add promo code",
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(),
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("Promotion")
                                                    .add({
                                                  "promo_title":
                                                      promotionTitleController
                                                          .text,
                                                  "promo_code":
                                                      promotionCodeController
                                                          .text,
                                                  "promo_discount":
                                                      promotionDiscountController
                                                          .text,
                                                  "active": "1",
                                                }).then((value) =>
                                                        Navigator.pop(context));
                                              },
                                              child: const Text("Submit"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: const Text("Add")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Promotion List",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 300,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Promotion")
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
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: ListTile(
                                        hoverColor: Colors.amber[300],
                                        onTap: () {},
                                        title: Text(snapshot.data!.docs[index]
                                            ['promo_title']),
                                        subtitle: Text(snapshot
                                            .data!.docs[index]['promo_code']),
                                        trailing: Text(
                                          snapshot.data!.docs[index]
                                              ['promo_discount'],
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    );
                                  });
                            }
                            return const SizedBox();
                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Orders",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              Container(
                color: Colors.grey[300],
                width: 600,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Order List",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Transactions",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.grey[300],
                    width: 600,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Withdraw Request",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                        StreamBuilder(
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
                                        "0") {
                                      return Material(
                                          type: MaterialType.transparency,
                                          child: ListTile(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 80,
                                                                  horizontal:
                                                                      100),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      50,
                                                                  vertical: 30),
                                                          child: Column(
                                                            children: [
                                                              StreamBuilder(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "Vendor")
                                                                      .doc(snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                          [
                                                                          'vendor_id'])
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      return Column(
                                                                        children: [
                                                                          Text(snapshot
                                                                              .data!['username']),
                                                                          Text(snapshot
                                                                              .data!['restaurant_name']),
                                                                        ],
                                                                      );
                                                                    }
                                                                    return const SizedBox();
                                                                  }),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                  "Request to withdraw RM ${double.parse(snapshot.data!.docs[index]['amount']).toStringAsFixed(2)}."),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          300),
                                                                  child:
                                                                      StreamBuilder(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "VendorWallet")
                                                                        .doc(snapshot
                                                                            .data!
                                                                            .docs[index]['vendor_id'])
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot11) {
                                                                      if (snapshot11
                                                                          .hasData) {
                                                                        return ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              /**
                                                                               * calculation here
                                                                               */
                                                                              double balance = 0;
                                                                              double commission = 0;
                                                                              double withdrawalAfterDeduction = 0;
                                                                              //calculate admin commission
                                                                              commission = double.parse(snapshot.data!.docs[index]['amount']) * 20 / 100;
                                                                              FirebaseFirestore.instance.collection("AdminCommission").add({
                                                                                "commission": commission.toStringAsFixed(2),
                                                                              });
                                                                              withdrawalAfterDeduction = double.parse(snapshot.data!.docs[index]['amount']) - commission;
                                                                              snapshot.data!.docs[index].reference.update({
                                                                                "approval": "1",
                                                                                "amount": withdrawalAfterDeduction.toStringAsFixed(2),
                                                                              }).then((value) {
                                                                                //calculate vendor balance
                                                                                balance = double.parse(snapshot11.data!['vendor_balance']) - double.parse(snapshot.data!.docs[index]['amount']);
                                                                                snapshot11.data!.reference.update({
                                                                                  "vendor_balance": balance.toStringAsFixed(2),
                                                                                });
                                                                              }).then((value) => Navigator.pop(context));
                                                                            },
                                                                            child:
                                                                                const Text("Approve"));
                                                                      }
                                                                      return const SizedBox();
                                                                    },
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            hoverColor: Colors.amber[300],
                                            title: Text(snapshot.data!
                                                .docs[index]['vendor_id']),
                                            subtitle: Text(
                                                "RM ${double.parse(snapshot.data!.docs[index]['amount']).toStringAsFixed(2)}"),
                                          ));
                                    }
                                    return const SizedBox();
                                  },
                                );
                              }
                              return const SizedBox();
                            }),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    width: 600,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Transaction List",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Food Categories",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.grey[300],
                    width: 300,
                    height: 400,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: ShowDialogComponent(
                                              controller: cuisineController,
                                              label: "Add Cuisine",
                                              function: () {
                                                FirebaseFirestore.instance
                                                    .collection("Cuisine")
                                                    .add({
                                                  "cuisine_name":
                                                      cuisineController.text,
                                                }).then((value) =>
                                                        Navigator.pop(context));
                                              },
                                              hintText: "Add new cuisine"),
                                        ));
                              },
                              child: const Text("Add")),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Cuisine List",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Cuisine")
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
                                        return Material(
                                          type: MaterialType.transparency,
                                          child: ListTile(
                                            hoverColor: Colors.amber[300],
                                            onTap: () {
                                              setState(() {
                                                cuisineLabel =
                                                    snapshot.data!.docs[index]
                                                        ['cuisine_name'];
                                              });
                                            },
                                            title: Text(snapshot.data!
                                                .docs[index]['cuisine_name']),
                                          ),
                                        );
                                      });
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    width: 300,
                    height: 400,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: ShowDialogComponent(
                                              controller: categoryController,
                                              label: "Add Category",
                                              function: () {
                                                FirebaseFirestore.instance
                                                    .collection("Category")
                                                    .add({
                                                  "cuisine": cuisineLabel,
                                                  "category_name":
                                                      categoryController.text,
                                                }).then((value) =>
                                                        Navigator.pop(context));
                                              },
                                              hintText: "Add new category"),
                                        ));
                              },
                              child: const Text("Add")),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Category List",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          cuisineLabel == "" ? "Cuisine" : cuisineLabel,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Category")
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
                                                ['cuisine'] ==
                                            cuisineLabel) {
                                          return Material(
                                            type: MaterialType.transparency,
                                            child: ListTile(
                                              hoverColor: Colors.amber[300],
                                              onTap: () {
                                                setState(() {
                                                  categoryId = snapshot.data!
                                                      .docs[index].reference.id;
                                                  categoryLabel =
                                                      snapshot.data!.docs[index]
                                                          ['category_name'];
                                                });
                                              },
                                              title: Text(
                                                  snapshot.data!.docs[index]
                                                      ['category_name']),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      });
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
                    width: 600,
                    height: 400,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 100, vertical: 80),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  "Customization",
                                                  style: TextStyle(
                                                      fontSize: 38,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                TextField(
                                                  controller:
                                                      customizationController,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.grey[300],
                                                    hintText:
                                                        "Enter food customization",
                                                  ),
                                                ),
                                                TextField(
                                                  controller:
                                                      customizationPriceController,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.grey[300],
                                                    hintText: "Enter new price",
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Customization")
                                                        .add({
                                                      "customization_name":
                                                          customizationController
                                                              .text,
                                                      "customization_price":
                                                          customizationPriceController
                                                              .text,
                                                      "category": categoryLabel,
                                                    }).then((value) =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  child: const Text("Submit"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              child: const Text("Add")),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Customization List",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          categoryLabel == "" ? "Category" : categoryLabel,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("Customization")
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
                                                ['category'] ==
                                            categoryLabel) {
                                          return ListTile(
                                            title: Text(
                                                snapshot.data!.docs[index]
                                                    ['customization_name']),
                                            subtitle: Text(
                                                "RM ${double.parse(snapshot.data!.docs[index]['customization_price']).toStringAsFixed(2)}"),
                                          );
                                        }
                                        return const SizedBox();
                                      });
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Locations",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        color: Colors.grey[300],
                        width: 600,
                        height: 400,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: ShowDialogComponent(
                                                controller: locationController,
                                                label: "Add New Location",
                                                function: () {
                                                  FirebaseFirestore.instance
                                                      .collection("Location")
                                                      .add({
                                                    "location":
                                                        locationController.text,
                                                  }).then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                },
                                                hintText:
                                                    "Enter a new location",
                                              ),
                                            ));
                                  },
                                  child: const Text("Add")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Locations List",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w400),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Location")
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
                                          return Material(
                                            type: MaterialType.transparency,
                                            child: ListTile(
                                              onTap: () {
                                                print(snapshot.data!.docs[index]
                                                    .reference.id);
                                                setState(() {
                                                  locationIndex = index;
                                                  locationId = snapshot.data!
                                                      .docs[index].reference.id
                                                      .toString();
                                                  locationLabel = snapshot.data!
                                                      .docs[index]['location'];
                                                });
                                              },
                                              hoverColor: Colors.amber[300],
                                              title: Text(snapshot.data!
                                                  .docs[index]['location']),
                                            ),
                                          );
                                        });
                                  }
                                  return const SizedBox();
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Malls",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        color: Colors.grey[300],
                        width: 600,
                        height: 400,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: ShowDialogComponent(
                                                controller: mallController,
                                                label: "Add New Mall",
                                                function: () {
                                                  FirebaseFirestore.instance
                                                      .collection("Mall")
                                                      .add({
                                                    "location_id": locationId,
                                                    "mall": mallController.text,
                                                  }).then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                },
                                                hintText: "Enter a new mall",
                                              ),
                                            ));
                                  },
                                  child: const Text("Add")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              locationLabel == "" ? "Mall List" : locationLabel,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w400),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Mall")
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
                                                  ['location_id'] ==
                                              locationId) {
                                            return ListTile(
                                              title: Text(snapshot
                                                  .data!.docs[index]['mall']),
                                            );
                                          }
                                          return const SizedBox();
                                        });
                                  }
                                  return const SizedBox();
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
