/*
 * @author lsy
 * @date   2020/8/6
 **/

import 'package:flutter/material.dart';

import 'BasePickerNotify.dart';

abstract class IPicker {
  void initState(BasePickerNotify dismissCall, BuildContext context);

  void dispose();
}
