import 'package:flutter/material.dart';

displaySnackBar({required String content, required BuildContext context}) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content)));
}
