import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback callback;
  final String buttonTitle;
  const CustomTextButton(
      {super.key, required this.callback, required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: callback,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              buttonTitle,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ));
  }
}
