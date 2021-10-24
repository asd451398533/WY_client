/*
 * @author lsy
 * @date   2019-10-18
 **/

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:timefly/commonModel/picker/pouring_hour_glass.dart';
import 'package:timefly/res/colours.dart';
import 'package:timefly/res/font.dart';
import 'package:timefly/res/styles.dart';
import 'package:timefly/utils/hex_color.dart';

import '../../app_theme.dart';
import 'base/DialogRouter.dart';

Future popLoadingDialog(
    BuildContext context, bool canceledOnTouchOutside, String text) {
  return Navigator.push(
      context, DialogRouter(LoadingDialog(canceledOnTouchOutside, text)));
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

class LoadingDialog extends Dialog {
  LoadingDialog(this.canceledOnTouchOutside, this.text) : super();

  ///点击背景是否能够退出
  final bool canceledOnTouchOutside;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Material(

          ///背景透明
          color: Colors.black38,

          ///保证控件居中效果
          child: Stack(
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: () {
                  if (canceledOnTouchOutside) {
                    Navigator.pop(context);
                  }
                },
              ),
              _aDialog()
            ],
          )),
    );
  }

  Widget _aDialog() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // SpinKitPouringHourglass(color: Color(0xFF333333)),
          Container(
            width: 80,
            height: 80,
            child: _center(),
          ),
          Gaps.vGap(16),
          Text(
            text??"加载中",
            overflow: TextOverflow.ellipsis,
            style: AppTheme.appTheme.headline1(
                textColor:  Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16),
            maxLines: 5,
          ),
          Gaps.vGap(30),
        ],
      ),
    );
  }

  Widget _center() {
    final customWidth08 =
        CustomSliderWidths(trackWidth: 1, progressBarWidth: 5, shadowWidth: 50);
    final customColors08 = CustomSliderColors(
        dotColor: Colors.white.withOpacity(0.5),
        trackColor: HexColor('#7EFFFF').withOpacity(0.1),
        progressBarColors: [
          HexColor('#3586FC').withOpacity(0.1),
          HexColor('#FF8876').withOpacity(0.25),
          HexColor('#FAFF76').withOpacity(0.5)
        ],
        shadowColor: HexColor('#133657'),
        shadowMaxOpacity: 0.02);
    final CircularSliderAppearance appearance08 = CircularSliderAppearance(
        customWidths: customWidth08,
        customColors: customColors08,
        size: 230.0,
        spinnerMode: true,
        spinnerDuration: 1000);
    final viewModel08 = SleekCircularSlider(
      onChangeStart: (double value) {},
      onChangeEnd: (double value) {},
      appearance: appearance08,
    );
    return viewModel08;
  }

  Widget _dialog() {
    return new Center(
      ///弹框大小
      child: new Container(
        width: 120.0,
        height: 120.0,
        child: new Container(
          ///弹框背景和圆角
          decoration: ShapeDecoration(
            color: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: new Text(
                  text,
                  style: new TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
