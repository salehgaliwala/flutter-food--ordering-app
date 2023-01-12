import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/customers/customer_screens.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckOutScreen extends StatefulWidget {
  final String customerId;
  const CheckOutScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController promocodeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  double totalPrice = 0;
  double discount = 0;
  String promoCode = "";
  bool isVerifed = false;
  List cartIdList = [];
  String behaviour = "0"; // 1-dine in, 0-take away
  bool isDineIn = false;
  bool isTakeAway = false;
  _launchURL() async {
    const url = 'https://www.pbebank.com/';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Check out"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("Cart").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!.docs[index].id;

                            if (snapshot.data!.docs[index]['user_id'] ==
                                widget.customerId) {
                              if (cartIdList.isEmpty ||
                                  cartIdList.length <
                                      snapshot.data!.docs.length) {
                                cartIdList.add(
                                    snapshot.data!.docs[index].reference.id);
                              }
                              totalPrice = totalPrice +
                                  double.parse(snapshot.data!.docs[index]
                                      ['total_price']);
                              return Dismissible(
                                // Each Dismissible must contain a Key. Keys allow Flutter to
                                // uniquely identify widgets.

                                key: Key(item),
                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                onDismissed: (direction) {
                                  // Remove the item from the data source.
                                  setState(() {
                                    snapshot.data!.docs[index].reference
                                        .delete();
                                  });

                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${snapshot.data!.docs[index]['item_name']} removed from cart')));
                                },
                                // Show a red background as the item is swiped away.
                                background: Container(color: Colors.red),
                                child: ListTile(
                                  leading: Image.network(
                                    snapshot.data!.docs[index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                      snapshot.data!.docs[index]['item_name']),
                                  subtitle: Text(
                                      "X ${snapshot.data!.docs[index]['quantity']}"),
                                  trailing: Text(
                                    "RM ${snapshot.data!.docs[index]['total_price']}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        behaviour = "1";
                        isDineIn = true;
                        isTakeAway = false;
                      });
                      print(behaviour);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  isDineIn ? Colors.amber : Colors.grey[500]),
                          child: Image.asset("assets/dish.png"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Dine in"),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        behaviour = "0";
                        isDineIn = false;
                        isTakeAway = true;
                      });
                      print(behaviour);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  isTakeAway ? Colors.amber : Colors.grey[500]),
                          child: Image.asset("assets/take-away.png"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Take Away"),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text("Pay with foodie wallet"),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber, width: 2)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: _launchURL,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text("Pay with card"),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber, width: 2)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                    hintText: "When you want to enjoy your meal?"),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                      width: 200,
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            promoCode = value;
                          });
                        },
                        controller: promocodeController,
                        decoration:
                            InputDecoration(hintText: "Apply promo code?"),
                      )),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Promotion")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            if (promoCode.toString() ==
                                snapshot.data!.docs[i]['promo_code']) {
                              return ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isVerifed = true;
                                      discount = double.parse(snapshot
                                          .data!.docs[i]['promo_discount']);
                                    });
                                  },
                                  child:
                                      Text(isVerifed ? "Verified" : "Verify"));
                            }
                            if (promoCode == "") {
                              return ElevatedButton(
                                  onPressed: () {}, child: Text("Verify"));
                            }
                          }
                        }
                        return const SizedBox();
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print(cartIdList);
                    print(promoCode);
                    print(discount);
                    print(isVerifed);
                    print(totalPrice);
                    DateTime now = DateTime.now();
                    if (isVerifed == true) {
                      /**
                       * appy promo code
                       */
                      totalPrice = totalPrice * discount / 100;
                      for (int i = 0; i < cartIdList.length; i++) {
                        FirebaseFirestore.instance.collection("Order").add({
                          "order_type": "1", //payment successful
                          "user_id": widget.customerId,
                          "cart_id": cartIdList[i],
                          "discount": discount.toStringAsFixed(2),
                          "payment": totalPrice.toStringAsFixed(2),
                          "time":
                              "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}",
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection("Cart")
                              .doc(cartIdList[i])
                              .update({
                            "type": "0",
                            "dine_in": behaviour,
                          });
                        }).then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerScreens(
                                      customerId: widget.customerId,
                                    ))));
                      }
                    } else {
                      for (int i = 0; i < cartIdList.length; i++) {
                        FirebaseFirestore.instance.collection("Order").add({
                          "order_type": "1", //payment successful
                          "user_id": widget.customerId,
                          "cart_id": cartIdList[i],
                          "discount": "-",
                          "payment": totalPrice.toStringAsFixed(2),
                          "time":
                              "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}",
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection("Cart")
                              .doc(cartIdList[i])
                              .update({
                            "type": "0",
                            "dine_in": behaviour,
                          });
                        }).then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerScreens(
                                      customerId: widget.customerId,
                                    ))));
                      }
                    }
                  },
                  child: const Text("Check out"),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
