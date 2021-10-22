/*
 * @author lsy
 * @date   2020/8/6
 **/
import 'package:flutter/material.dart';

import 'IPicker.dart';

abstract class ICenterPicker extends IPicker {
  Widget build(BuildContext context, int alp);
}
