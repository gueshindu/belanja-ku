import 'package:belanjaku/utility/dialog/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> tdkBisaShareDialog(BuildContext ctx) {
  return showGenericDialog(
      context: ctx,
      title: 'Sharing note',
      content: 'Tidak bisa melakukan sharing note kosong',
      optionBuilder: () => {
            'OK': null,
          });
}
