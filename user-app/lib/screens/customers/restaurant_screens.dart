import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/customers/add_to_cart_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final String customerId;
  final QueryDocumentSnapshot data;

  const RestaurantScreen(
      {super.key, required this.customerId, required this.data});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.data['restaurant_name']),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
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
                  Row(
                    children: [
                      Text("Open time: ${widget.data['open_time']}"),
                      const SizedBox(
                        width: 50,
                      ),
                      Text("Close time: ${widget.data['close_time']}"),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Bio: ${widget.data['bio']}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Description: ${widget.data['description']}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Menu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Menus")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data!.docs[index]['vendor_id'] ==
                                    widget.data.reference.id) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddToCartScreen(
                                            customerId: widget.customerId,
                                            data: snapshot.data!.docs[index],
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      snapshot.data!.docs[index]['item_name'],
                                    ),
                                    leading: Image.network(
                                      snapshot.data!.docs[index]['image'],
                                      fit: BoxFit.cover,
                                      width: 100,
                                    ),
                                    trailing: Text(
                                      "RM ${double.parse(snapshot.data!.docs[index]['item_price']).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
          ],
        ),
      )),
    );
  }
}
