import 'package:flutter/material.dart';


Future<bool> showErrorDialog(BuildContext context, String text) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("An error occured"),
        content:  Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ok"),
          ),
          
        ],
      );
    },
  ).then((value) => value ?? false);}