import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final VoidCallback callback;
  final TextInputAction textInputAction;
  const CustomTextFormField(
      {super.key,
      required this.callback,
      required this.hintText,
      this.textInputAction = TextInputAction.next,
      required this.controller,
      this.textInputType = TextInputType.text});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        onFieldSubmitted: (text) {
          callback();
        },
        keyboardType: textInputType,
        controller: controller,
        textInputAction: textInputAction,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Enter your ${hintText}';
          }
          return null;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black87),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black87),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black87),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
        ),
      ),
    );
  }
}
