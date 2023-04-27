import 'package:belanjaku/utility/dialog/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Yakin akan menghapus note ini',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
