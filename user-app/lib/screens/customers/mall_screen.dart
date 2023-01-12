import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/customers/restaurant_screens.dart';

class MallScreen extends StatefulWidget {
  final String customerId;
  final QueryDocumentSnapshot data;

  const MallScreen({super.key, required this.customerId, required this.data});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.data['mall']),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Vendor")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]['mall_id'] ==
                                widget.data['mall']) {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurantScreen(
                                                  customerId: widget.customerId,
                                                  data: snapshot
                                                      .data!.docs[index])));
                                },
                                title: Text(
                                  snapshot.data!.docs[index]['restaurant_name'],
                                ),
                                leading: Image.network(
                                  snapshot.data!.docs[index]['image'],
                                  fit: BoxFit.cover,
                                  width: 100,
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
      )),
    );
  }
}
