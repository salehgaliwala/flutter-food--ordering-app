import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/customers/mall_screen.dart';

class LocationScreen extends StatefulWidget {
  final String customerId;
  final QueryDocumentSnapshot data;

  const LocationScreen(
      {super.key, required this.customerId, required this.data});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.data['location']),
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
                  stream:
                      FirebaseFirestore.instance.collection("Mall").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]['location_id'] ==
                                widget.data.reference.id) {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MallScreen(
                                              customerId: widget.customerId,
                                              data:
                                                  snapshot.data!.docs[index])));
                                },
                                title: Text(snapshot.data!.docs[index]['mall']),
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
