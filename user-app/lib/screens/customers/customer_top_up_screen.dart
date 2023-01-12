import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/success_dialog.dart';

class CustomerTopUpScreen extends StatefulWidget {
  final String customerId;
  final double balance;
  const CustomerTopUpScreen(
      {super.key, required this.customerId, required this.balance});

  @override
  State<CustomerTopUpScreen> createState() => _CustomerTopUpScreenState();
}

class _CustomerTopUpScreenState extends State<CustomerTopUpScreen> {
  TextEditingController amountController = TextEditingController();
  String initialValue = "0";

  bool amountEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Top up"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter your amount"),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          initialValue = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      decoration: InputDecoration(hintText: "RM 20.00"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("UserWallet")
                      .doc(widget.customerId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    double newAmount = 0;
                    if (snapshot.hasData) {
                      newAmount = widget.balance + double.parse(initialValue);
                      return Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              snapshot.data!.reference
                                  .update({
                                    "user_balance":
                                        newAmount.toStringAsFixed(2),
                                  })
                                  .then((value) => showDialog(
                                      context: context,
                                      builder: (context) => const Dialog(
                                            child: SuccessDialog(
                                                label: "Top Up Successfully"),
                                          )))
                                  .then((value) {
                                    /**
                                             * date
                                             */
                                    DateTime now = DateTime.now();
                                    FirebaseFirestore.instance
                                        .collection("Transactions")
                                        .add({
                                      "user_id": widget.customerId,
                                      "amount": initialValue,
                                      "time":
                                          "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}",
                                      "type": "1" //1 for top up
                                    });
                                  })
                                  .then((value) => Navigator.pop(context));
                            },
                            child: const Text("Top Up")),
                      );
                    }
                    return const SizedBox();
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
