import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/components/register_input.dart';
import 'package:foodie/components/success_dialog.dart';

class VendorWithdrawScreen extends StatefulWidget {
  final String vendorId;
  const VendorWithdrawScreen({super.key, required this.vendorId});

  @override
  State<VendorWithdrawScreen> createState() => _VendorWithdrawScreenState();
}

class _VendorWithdrawScreenState extends State<VendorWithdrawScreen> {
  bool amountEmpty = false;
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw Request"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            RegisterInput(
                label: "Enter amount",
                errorMessage: "Amount cannot be 0",
                hintText: "Enter your amount",
                isEmpty: amountEmpty,
                controller: amountController,
                keyboardType: TextInputType.number,
                obscure: false),
            const SizedBox(
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Withdraw"),
                onPressed: () {
                  DateTime now = DateTime.now();
                  /**
                   * Calculation
                   */
                  if (amountController.text.isEmpty) {
                    setState(() {
                      amountEmpty = true;
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection("VendorTransactions")
                        .doc()
                        .set({
                      "vendor_id": widget.vendorId,
                      "amount": amountController.text,
                      "type": "1", //withdrawal
                      "approval": "0",
                      "time":
                          "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}"
                    }).then((value) => showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: SuccessDialog(
                                      label: "Withdraw Request Sent"),
                                )).then((value) => Navigator.pop(context)));
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
