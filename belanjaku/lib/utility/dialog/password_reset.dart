import 'package:belanjaku/utility/dialog/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> showResetPasswordDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Reset password',
    content: 'Email sudah dikirim untuk reset password. Cek email Anda',
    optionBuilder: () => {"OK": null},
  );
}
