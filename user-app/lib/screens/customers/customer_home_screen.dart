import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/screens/customers/cuisine_screen.dart';
import 'package:foodie/screens/customers/location_screen.dart';
import 'package:foodie/screens/customers/mall_screen.dart';
import 'package:foodie/screens/customers/promotion_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  final String customerId;
  const CustomerHomeScreen({super.key, required this.customerId});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchInput = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchInput = value;
                        });
                      },
                      controller: searchController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "What food in your mind...")),
                ),
                const SizedBox(
                  height: 20,
                ),
                searchInput == ""
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Promotion voucher",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 100,
                            width: double.infinity,
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
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PromotionScreen(
                                                            data: snapshot.data!
                                                                .docs[index])));
                                          },
                                          child: Container(
                                            height: 80,
                                            width: 200,
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color(0xffeb721a)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['promo_title'],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "${snapshot.data!.docs[index]['promo_discount']}%",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Cuisines",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 40,
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
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CuisineScreen(
                                                              cuisine: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'cuisine_name'])));
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 130,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffeb721a),
                                                      width: 2)),
                                              child: Text(snapshot.data!
                                                  .docs[index]['cuisine_name']),
                                            ),
                                          );
                                        });
                                  }
                                  return const SizedBox();
                                }),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Locations",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 100,
                            child: StreamBuilder(
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
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LocationScreen(
                                                            customerId: widget
                                                                .customerId,
                                                            data: snapshot.data!
                                                                .docs[index],
                                                          )));
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 130,
                                              alignment: Alignment.bottomCenter,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          "assets/city.jpg"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffeb721a),
                                                      width: 2)),
                                              child: Container(
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['location'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                  return const SizedBox();
                                }),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Malls",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 100,
                            child: StreamBuilder(
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
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MallScreen(
                                                              customerId: widget
                                                                  .customerId,
                                                              data: snapshot
                                                                      .data!
                                                                      .docs[
                                                                  index])));
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 130,
                                              alignment: Alignment.bottomCenter,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/city.jpg"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffeb721a),
                                                      width: 2)),
                                              child: Container(
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['mall'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                  return const SizedBox();
                                }),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text("Search result"),
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
                                        if (searchInput.toLowerCase().contains(
                                            snapshot
                                                .data!.docs[index]['category']
                                                .toString()
                                                .toLowerCase())) {
                                          return ListTile(
                                            leading: Image.network(snapshot
                                                .data!.docs[index]['image']),
                                            title: Text(snapshot.data!
                                                .docs[index]['item_name']),
                                          );
                                        }
                                        return const SizedBox();
                                      });
                                }
                                return const SizedBox();
                              })
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
