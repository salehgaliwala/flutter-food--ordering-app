import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CuisineScreen extends StatefulWidget {
  final String cuisine;
  const CuisineScreen({super.key, required this.cuisine});

  @override
  State<CuisineScreen> createState() => _CuisineScreenState();
}

class _CuisineScreenState extends State<CuisineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.amber, title: Text(widget.cuisine)),
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
                      .collection("Menus")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]['cuisine'] ==
                                widget.cuisine) {
                              return ListTile(
                                leading: Image.network(
                                  snapshot.data!.docs[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                    snapshot.data!.docs[index]['item_name']),
                                subtitle: Text(
                                    "RM ${snapshot.data!.docs[index]['item_price']}"),
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
