import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

customToaster(String msg, {posision, color}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: posision ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color ?? Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}
