import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({required BuildContext context, required String txt}) {
  final dlg  = AlertDialog( content: 
  Column(mainAxisSize: MainAxisSize.min,
  children: [
    const CircularProgressIndicator(),
    const SizedBox(height: 10,),
    Text(txt),
  ],),);  
  showDialog(context: context,
  barrierDismissible: false ,
   builder: (context) => dlg,);

   return ()=> Navigator.of(context).pop();
}