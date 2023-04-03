import 'package:flutter/material.dart';

Future showErrorDialog(BuildContext context, String msg) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Terjadi kesalahan  '),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
