import 'package:flutter/cupertino.dart';
import 'package:timefly/add_habit/edit_name.dart';
import 'package:timefly/utils/pair.dart';

class UIUtil {
  static void editNote(BuildContext context, Widget child) async {
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, ani1, ani2) {
          return child;
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
  }
}
