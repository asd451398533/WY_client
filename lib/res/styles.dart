import 'package:flutter/material.dart';
import 'package:timefly/add_habit/edit_name.dart';
import 'package:timefly/utils/pair.dart';
import '../app_theme.dart';
import 'colours.dart';
import 'font.dart';

class TextStyles {
  static const TextStyle textGray14 = TextStyle(
    fontSize: Font.font_sp14,
    color: Colours.gray,
  );

  static const TextStyle textWhite18 = TextStyle(
    fontSize: Font.font_sp18,
    color: Colors.white,
  );

  static const TextStyle textWhite16 = TextStyle(
    fontSize: Font.font_sp16,
    color: Colors.white,
  );

  static const TextStyle textWhite14 = TextStyle(
    fontSize: Font.font_sp14,
    color: Colors.white,
  );
}

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap(double gap) {
    return SizedBox(width: gap);
  }

  /// 垂直间隔
  static Widget vGap(double gap) {
    return SizedBox(height: gap);
  }

  /// 水平划线
  static Widget hGapLine({double gap = 0.6, Color bgColor = Colours.gray_c}) {
    return Container(
      width: gap,
      color: bgColor,
    );
  }

  /// 竖直划线
  static Widget vGapLine({double gap = 0.6, Color bgColor = Colours.gray_c}) {
    return Container(
      height: gap,
      color: bgColor,
    );
  }

  static BoxDecoration boxDe() {
    return BoxDecoration(
      boxShadow: AppTheme.appTheme.coloredBoxShadow(),
      gradient: AppTheme.appTheme.containerGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    );
  }

  static void showEdit(
      BuildContext context, String word, Function(String result) result,
      {String hintText}) async {
    Mutable<String> content = Mutable(word);
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, ani1, ani2) {
          return EditFiledView(
            content: content,
            hintText: hintText,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Animation<double> myAnimation = Tween<double>(begin: 0, end: 1.0)
              .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutSine,
                  reverseCurve: Interval(0, 0.5, curve: Curves.easeInSine)));
          return Transform(
            transform:
                Matrix4.translationValues(0, 100 * (1 - myAnimation.value), 0),
            child: FadeTransition(
              opacity: myAnimation,
              child: child,
            ),
          );
        }));
    result(content.value);
  }

  static Widget line = Container(height: 0.6, color: Colours.line);
  static const Widget empty = SizedBox();
}
