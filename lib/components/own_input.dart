import 'package:flutter/material.dart';

class OwnInput extends StatelessWidget {
  const OwnInput({super.key, required this.labelText, this.controller});
  final TextEditingController? controller;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    var underlineInputBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xff54B541)),
    );
    return Column(
      children: [
        Text(labelText),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: underlineInputBorder,
            enabledBorder: underlineInputBorder,
            errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Color(0xffF4F4F4),
            hintStyle: TextStyle(color: Color(0xffCBCBCB)),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
