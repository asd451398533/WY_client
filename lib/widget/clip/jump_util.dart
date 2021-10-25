import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JumpUtil {
  static void jumpTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
      return widget;
    }));
  }
}
