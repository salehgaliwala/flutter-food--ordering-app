import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/customers/check_out_screen.dart';

class AddToCartScreen extends StatefulWidget {
  final String customerId;
  final QueryDocumentSnapshot data;
  const AddToCartScreen(
      {super.key, required this.customerId, required this.data});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  TextEditingController quantityController = TextEditingController();
  int quantity = 1;
  double newPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Add to cart"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.network(
                widget.data['image'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget.data['item_name']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("${widget.data['item_description']}"),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "RM ${widget.data['item_price']}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber[300],
                          ),
                          child: Icon(Icons.remove),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (quantity < 100) {
                            setState(() {
                              quantity++;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber[300],
                          ),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.data['category'] == ""
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Customize',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Customization")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  int i = 0;

                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.data!.docs[index]
                                                  ['category'] ==
                                              widget.data['category']) {
                                            i++;
                                            /**
                                               * category list check box
                                               */

                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        newPrice = double.parse(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['item_price']);
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 2,
                                                              color:
                                                                  Colors.amber),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: newPrice > 0
                                                          ? Icon(Icons.check)
                                                          : const SizedBox(),
                                                    ),
                                                  ),
                                                  Text(snapshot
                                                          .data!.docs[index]
                                                      ['customization_name']),
                                                  Text(
                                                    "RM ${double.parse(snapshot.data!.docs[index]['customization_price']).toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ],
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
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(newPrice);
                                    print(quantity);
                                    print(widget.data['item_price']);
                                    double totalPrice = quantity *
                                        double.parse(widget.data['item_price']);
                                    DateTime now = DateTime.now();
                                    FirebaseFirestore.instance
                                        .collection("Cart")
                                        .add({
                                      "type": "",
                                      "dine_in": "1",
                                      "having_time": "",
                                      "time":
                                          "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}",
                                      "item_name": widget.data['item_name'],
                                      "item_price": widget.data['item_price'],
                                      "quantity": quantity.toString(),
                                      "total_price":
                                          totalPrice.toStringAsFixed(2),
                                      "vendor_id": widget.data['vendor_id'],
                                      "user_id": widget.customerId,
                                      "image": widget.data['image'],
                                    }).then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckOutScreen(
                                                    customerId:
                                                        widget.customerId,
                                                  )));
                                    });
                                  },
                                  child: const Text("Add to cart")),
                            )
                          ],
                        )
                ],
              ),
            ),
          ],
        )
            //
            ),
      ),
    );
  }
}
