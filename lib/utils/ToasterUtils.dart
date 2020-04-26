import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToasterUtils{
  static show(BuildContext context,{String msg,int duration = 2,VoidCallback onDismiss = null}){
    showToast(
      msg,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: Theme.of(context).textTheme.subhead,
      onDismiss: onDismiss
    );
  }
}