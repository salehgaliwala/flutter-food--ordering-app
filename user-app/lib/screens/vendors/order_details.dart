import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/vendors/chat_screen.dart';
import 'package:foodie/screens/vendors/home_screen.dart';

class OrderDetails extends StatefulWidget {
  final QueryDocumentSnapshot data;
  const OrderDetails({super.key, required this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.data['order_number']),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.data['image'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                widget.data['item_name'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Quantity: x${widget.data['quantity']}"),
              const SizedBox(
                height: 20,
              ),
              Text("RM ${widget.data['item_price']}"),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreenVendor(
                                  itemName: widget.data['item_name'],
                                  vendor: widget.data['vendor_id'],
                                  customer: widget.data['user_id'])));
                    },
                    child: Text("Chat with customer")),
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Cart")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: 150,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                        return const SizedBox();
                      }),
                  Container(
                    width: 150,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
