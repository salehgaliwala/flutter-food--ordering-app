import 'package:flutter/material.dart';

class EditInputComponent extends StatefulWidget {
  final String label, hintText;
  final Function() function;
  final TextEditingController controller;
  const EditInputComponent({
    super.key,
    required this.label,
    required this.hintText,
    required this.function,
    required this.controller,
  });

  @override
  State<EditInputComponent> createState() => _EditInputComponentState();
}

class _EditInputComponentState extends State<EditInputComponent> {
  bool controllerEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label),
            InkWell(
                onTap: widget.function,
                child: Text(
                  "Done",
                  style: TextStyle(
                      color: controllerEmpty == false
                          ? Colors.grey
                          : Colors.amber),
                )),
          ],
        ),
        TextField(
          controller: widget.controller,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                controllerEmpty = true;
              });
            } else {
              setState(() {
                controllerEmpty = false;
              });
            }
          },
          decoration: InputDecoration(hintText: widget.hintText),
        ),
      ]),
    );
  }
}
