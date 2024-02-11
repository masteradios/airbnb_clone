import 'package:flutter/material.dart';

displaySnackBar({required String content, required BuildContext context}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          content,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
  );
}

openDrawer({required BuildContext context}) {
  return SafeArea(
      child: Drawer(
    child: Column(
      children: [
        Text('hi'),
        Text('hi'),
        Text('hi'),
        Text('hi'),
      ],
    ),
  ));
}
