import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timefly/add_habit/edit_name.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/blocs/bill/bill_bloc.dart';
import 'package:timefly/blocs/bill/bill_event.dart';
import 'package:timefly/blocs/bill/bill_event_1.dart';
import 'package:timefly/blocs/xt/bill_bloc.dart';
import 'package:timefly/blocs/xt/bill_event_1.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/DioInstance.dart';
import 'package:timefly/res/colours.dart';
import 'package:timefly/res/styles.dart';
import 'package:timefly/util/utils.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/widget/app_bar.dart';
import 'package:timefly/widget/float_modal.dart';
import 'package:timefly/widget/highlight_well.dart';
import 'package:timefly/widget/number_keyboard.dart';
import 'package:timefly/xt/xt_check.dart';
import 'package:timefly/xt/xt_keyboard.dart';

import '../app_theme.dart';
import '../home_screen.dart';

const Map<String, IconData> xticons = {
  "happy": Icons.sentiment_very_satisfied,
  "normal": Icons.sentiment_satisfied,
};

class XTkeepping extends StatefulWidget {
  const XTkeepping({Key key, this.recordModel}) : super(key: key);
  final XT recordModel;

  @override
  State<StatefulWidget> createState() => _XTkeeppingState();
}

class _XTkeeppingState extends State<XTkeepping> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController mainController;
  String _remark = '';
  DateTime _time;
  String _dateString = '';
  String _numberString = '';
  bool _isAdd = false;
  List<String> foods = [];

  void _updateInitData() {
    if (widget.recordModel != null) {
      _time = DateTime.fromMillisecondsSinceEpoch(
          widget.recordModel.updateTimestamp);
      DateTime now = DateTime.now();
      if (_time.year == now.year &&
          _time.month == now.month &&
          _time.day == now.day) {
        _dateString = '?????? ${_time.hour}:${_time.minute}';
      } else if (_time.year != now.year) {
        _dateString =
            '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
      } else {
        _dateString =
            '${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
      }

      if (widget.recordModel.remark.isNotEmpty) {
        _remark = widget.recordModel.remark;
      }
      if (widget.recordModel.type.isNotEmpty) {
        itemType = widget.recordModel.type;
      }
      if (widget.recordModel.categoryImage.isNotEmpty) {
        iconStr = widget.recordModel.categoryImage;
      }
      if (widget.recordModel.foods.isNotEmpty) {
        var split = widget.recordModel.foods.split(",");
        foods.addAll(split);
      }

      if (widget.recordModel.number != null) {
        _numberString = Utils.formatDouble(double.parse(
            _numberString = widget.recordModel.number.toStringAsFixed(2)));
      }
    } else {
      _time = DateTime.now();
      _dateString = '?????? ${_time.hour}:${_time.minute}';
    }
  }

  @override
  void initState() {
    mainController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    mainController.forward();
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //???????????????????????????????????????
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              //??????????????????????????????????????????????????????
              _animationController.forward();
            }
          });
    // ????????????
    _animationController.forward();

    _updateInitData();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    mainController.stop();
    mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      appBar: MyAppBar(
        backgroundColor: Color(0x00000000),
        // centerTitle: true,
        titleWidget: Text(
          "??????",
          style: AppTheme.appTheme.headline1(fontSize: 18),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
          child: Icon(
            Icons.close,
            color: AppTheme.appTheme.normalColor(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false, // ??????true?????????????????????
      body: _buildBody(),
    );
  }

  String itemType = "";

  _Center() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: InkWell(
              onTap: () async {
                showTypes();
              },
              child: Row(
                children: [
                  Text(
                    "??????:  ",
                    style: AppTheme.appTheme.headline1(fontSize: 13),
                  ),
                  Expanded(
                      child: Text(
                    itemType,
                    style: AppTheme.appTheme.headline1(fontSize: 13),
                  ))
                ],
              ),
            ),
          ),
          Container(
            height: 0.6,
            margin: EdgeInsets.only(top: 10, left: 16, right: 16),
            color: AppTheme.appTheme.normalColor(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Row(
              children: [
                Text(
                  "??????:  ",
                  style: AppTheme.appTheme.headline1(fontSize: 13),
                ),
                Expanded(
                    child: Wrap(
                  spacing: 5,
                  children: chips(),
                ))
              ],
            ),
          ),
          Container(
            height: 0.6,
            margin: EdgeInsets.only(top: 10, left: 16, right: 16),
            color: AppTheme.appTheme.normalColor(),
          )
        ],
      ),
    );
  }

  showTypes() {
    showCustomModalBottomSheet(
      context: context,
      builder: (context) {
        return XTTypeSView(mainController, (s) {
          if (s != null && s.isNotEmpty) {
            setState(() {
              itemType = s;
            });
          }
        });
      },
      barrierColor: Colors.black87,
      containerWidget: (_, animation, child) => FloatingModal(
        child: child,
      ),
      expand: true,
      enableDrag: true,
    );
  }

  chips() {
    List<Widget> list = [];
    foods.forEach((element) {
      list.add(RawChip(
        backgroundColor: AppTheme.appTheme.cardBackgroundColor(),
        label: Text(
          element,
          style: AppTheme.appTheme.headline1(fontSize: 13),
        ),
        onDeleted: () {
          setState(() {
            foods.remove(element);
          });
        },
        deleteIcon: Icon(
          Icons.delete,
          size: 16,
        ),
        deleteIconColor: AppTheme.appTheme.grandientColorStart(),
        useDeleteButtonTooltip: true,
        deleteButtonTooltipMessage: '??????',
      ));
    });
    list.add(GestureDetector(
      onTap: () {
        editNote(context);
      },
      child: RawChip(
        backgroundColor: AppTheme.appTheme.cardBackgroundColor(),
        label: Text(
          '??????',
          style: AppTheme.appTheme.headline1(fontSize: 13),
        ),
        onDeleted: () {
          editNote(context);
        },
        deleteIcon: Icon(
          Icons.add,
          size: 16,
        ),
        deleteIconColor: AppTheme.appTheme.normalColor(),
        useDeleteButtonTooltip: true,
        deleteButtonTooltipMessage: '??????',
      ),
    ));
    return list;
  }

  void editNote(BuildContext context, {String str = ""}) async {
    Mutable<String> content = Mutable(str);
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, ani1, ani2) {
          return EditFiledView(
            content: content,
            hintText: "????????????",
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
    if (content.value != null && content.value.isNotEmpty) {
      setState(() {
        foods.add(content.value);
      });
    }
  }

  String iconStr = "happy";

  /// body
  _buildBody() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(flex: 1, child: _Center()),
          HighLightWell(
            onTap: () {
              Gaps.showEdit(
                  context,
                  _remark,
                  (result) => {
                        setState(() {
                          _remark = result;
                        })
                      });
            },
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  alignment: Alignment.center,
                  height: 33,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _remark.isEmpty ? '??????...' : _remark,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Gaps.vGap(3),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  xticons[iconStr],
                  size: 25,
                  color: AppTheme.appTheme.normalColor(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: HighLightWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        theme: DatePickerTheme(
                          backgroundColor:
                              AppTheme.appTheme.containerBackgroundColor(),
                          itemStyle: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.normal, fontSize: 16),
                          doneStyle: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.normal, fontSize: 16),
                          cancelStyle: AppTheme.appTheme.headline1(
                              textColor: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                        locale: LocaleType.zh, onConfirm: (date) {
                      _time = date;
                      DateTime now = DateTime.now();
                      if (_time.year == now.year &&
                          _time.month == now.month &&
                          _time.day == now.day) {
                        _dateString = '?????? ${_time.hour}:${_time.minute}';
                      } else if (_time.year != now.year) {
                        _dateString =
                            '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
                      } else {
                        _dateString =
                            '${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
                      }
                      setState(() {});
                    });
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colours.gray, width: 0.6)),
                    child: Text(
                      _dateString,
                      style: AppTheme.appTheme.headline1(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _numberString.isEmpty ? '0.0' : _numberString,
                    style: AppTheme.appTheme.headline1(
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenUtil.getInstance().setSp(48)),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget child) {
                  return Container(
                    margin: const EdgeInsets.only(right: 14),
                    width: 2,
                    height: ScreenUtil.getInstance().setSp(40),
                    decoration: BoxDecoration(
                        color: AppTheme.appTheme
                            .normalColor()
                            .withOpacity(0.8 * _animationController.value)),
                  );
                },
              ),
            ],
          ),
          Gaps.vGap(10),
          Gaps.vGapLine(gap: 0.3),
          XTBoard(
            isAdd: _isAdd,
            // ????????????
            numberCallback: (number) => inputVerifyNumber(number),
            // ??????
            deleteCallback: () {
              if (_numberString.length > 0) {
                setState(() {
                  _numberString =
                      _numberString.substring(0, _numberString.length - 1);
                });
              }
            },
            // ??????
            clearZeroCallback: () {
              _clearZero();
            },
            // ??????
            equalCallback: () {
              setState(() {
                _addNumber();
              });
            },
            //??????
            nextCallback: () {
              setState(() {
                iconStr = "normal";
              });
            },
            // ??????
            saveCallback: () {
              _record();
            },
          ),
          MediaQuery.of(context).padding.bottom > 0
              ? Gaps.vGapLine(gap: 0.3)
              : Gaps.empty,
        ],
      ),
    );
  }

  /// ??????
  void _addNumber() {
    _isAdd = false;
    List<String> numbers = _numberString.split('+');
    double number = 0.0;
    for (String item in numbers) {
      if (item.isEmpty == false) {
        number += double.parse(item);
      }
    }
    String numberString = number.toString();
    if (numberString.split('.').last == '0') {
      numberString = numberString.substring(0, numberString.length - 2);
    }
    _numberString = numberString;
  }

  String getFoodsStr() {
    if (foods.isEmpty) {
      return "";
    }
    int i = 0;
    String str = "";
    foods.forEach((element) {
      str = str + element;
      i++;
      if (i != foods.length) {
        str = str + ",";
      }
    });
    return str;
  }

  /// ????????????
  void _record({bool isGoOn = false}) {
    if (itemType.isEmpty) {
      FlashHelper.toast(context, '???????????????');
      return;
    }
    if (_numberString.isEmpty || _numberString == '0.') {
      FlashHelper.toast(context, '???????????????');
      return;
    }
    _isAdd = false;
    XT model;
    if (widget.recordModel != null) {
      //??????
      model = widget.recordModel
        ..remark = _remark
        ..number = double.parse(_numberString)
        ..userKey = SessionUtils().currentUser.key
        ..type = itemType
        ..foods = getFoodsStr()
        ..categoryImage = iconStr
        ..updateTime =
            DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
                .toString()
        ..updateTimestamp = _time.millisecondsSinceEpoch;
    } else {
      model = XT()
        ..id = null
        ..remark = _remark
        ..number = double.parse(_numberString)
        ..userKey = SessionUtils().currentUser.key
        ..type = itemType
        ..categoryImage = iconStr
        ..foods = getFoodsStr()
        ..createTime =
            DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
                .toString()
        ..createTimestamp = _time.millisecondsSinceEpoch
        ..updateTime =
            DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
                .toString()
        ..updateTimestamp = _time.millisecondsSinceEpoch;
    }
    ApiDio().apiService.addXT(model).listen((event) {
      if (event.code == 200) {
        BlocProvider.of<XTBloc>(appContext).add(XTLoad());
        if (isGoOn) {
          FlashHelper.toast(context, '????????????????????????');
        } else {
          Navigator.pop(context);
        }
      } else {
        FlashHelper.toast(context, '????????????');
      }
    }).onError((err) {
      FlashHelper.toast(context, '????????????');
    });
  }

  /// ??????
  void _clearZero() {
    setState(() {
      _isAdd = false;
      _numberString = '';
    });
  }

  /// ??????????????????
  void inputVerifyNumber(String number) {
    //???????????????????????????????????????
    if (number == '+') {
      setState(() {
        iconStr = "happy";
      });
      return;
    }
    //??????
    if (_numberString.isEmpty) {
      //?????????????????????????????????+??????.

      if (number == '.') {
        setState(() {
          _numberString += '0.';
        });
        return;
      }

      setState(() {
        _numberString += number;
      });
    } else {
      List<String> numbers = _numberString.split('');
      if (numbers.length == 1) {
        // ?????????????????????
        if (numbers.first == '0') {
          //????????????????????????0??????????????????????????????+?????????
          if (number == '.') {
            setState(() {
              _numberString += number;
            });
          } else if (number != '+') {
            setState(() {
              _numberString = number;
            });
          }
        } else {
          //?????????????????????0 ???1-9
          setState(() {
            if (number == '+') {
              _isAdd = true;
            }
            _numberString += number;
          });
        }
      } else {
        List<String> temps = _numberString.split('+');
        if (temps.last.isEmpty && number == '+') {
          //??????
          return;
        }

        //????????????????????????
        String lastNumber = temps.last;
        List<String> lastNumbers = lastNumber.split('.');
        if (lastNumbers.last.isEmpty && number == '.') {
          return;
        }
        if (lastNumbers.length > 1 &&
            lastNumbers.last.length >= 2 &&
            number != '+') {
          return;
        }

        setState(() {
          if (number == '+') {
            _isAdd = true;
          }
          _numberString += number;
        });
      }
    }
  }
}
