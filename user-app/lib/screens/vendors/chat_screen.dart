import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreenVendor extends StatefulWidget {
  final String itemName;
  final String vendor, customer;
  const ChatScreenVendor(
      {super.key,
      required this.vendor,
      required this.customer,
      required this.itemName});

  @override
  State<ChatScreenVendor> createState() => _ChatScreenVendorState();
}

class _ChatScreenVendorState extends State<ChatScreenVendor> {
  TextEditingController chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 500,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Chat")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data!.docs[index]['chatroom'] ==
                                  widget.itemName) {
                                return Container(
                                  margin: snapshot.data!.docs[index]
                                              ['vendor_id'] ==
                                          widget.vendor
                                      ? const EdgeInsets.only(
                                          left: 150, bottom: 10)
                                      : const EdgeInsets.only(
                                          right: 150, bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: snapshot.data!.docs[index]
                                                  ['vendor_id'] ==
                                              widget.vendor
                                          ? Colors.amber
                                          : Colors.grey),
                                  child: Text(
                                      snapshot.data!.docs[index]['message']),
                                );
                              }
                              return const SizedBox();
                            });
                      }
                      return const SizedBox();
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: chatController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your message"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (chatController.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection("Chat").add({
                          "message": chatController.text,
                          "vendor_id": widget.vendor,
                          "user_id": "",
                          "chatroom": widget.itemName
                        }).then((value) {
                          chatController.clear();
                        });
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.send),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.amber),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
