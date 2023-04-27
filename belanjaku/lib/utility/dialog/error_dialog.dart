import 'package:belanjaku/utility/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future showErrorDialog(BuildContext context, String txt) {
  return showGenericDialog(
    context: context,
    title: "Terjadi kesalahan",
    content: txt,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
