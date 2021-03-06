import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timefly/blocs/bill/bill_bloc.dart';
import 'package:timefly/blocs/bill/bill_event.dart';
import 'package:timefly/blocs/bill/bill_event_1.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/DioInstance.dart';
import 'package:timefly/res/colours.dart';
import 'package:timefly/res/styles.dart';
import 'package:timefly/util/utils.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/widget/app_bar.dart';
import 'package:timefly/widget/highlight_well.dart';
import 'package:timefly/widget/number_keyboard.dart';

import '../app_theme.dart';
import '../home_screen.dart';
import 'bill_record_response.dart';

class Bookkeepping extends StatefulWidget {
  const Bookkeepping({Key key, this.recordModel}) : super(key: key);
  final BillRecordModel recordModel;

  @override
  State<StatefulWidget> createState() => _BookkeeppingState();
}

class _BookkeeppingState extends State<Bookkeepping>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _tapItemController;
  String _remark = '';
  DateTime _time;
  String _dateString = '';
  String _numberString = '';
  bool _isAdd = false;

  /// 支出类别数组
  List<CategoryItem> _expenObjects = [];

  /// 收入类别数组
  List<CategoryItem> _inComeObjects = [];

  TabController _tabController;

  /// tabs
  final List<String> tabs = ['支出', '收入'];

  /// 获取支出类别数据
  void _loadExpenDatas() {
    _expenObjects.clear();
    _expenObjects.addAll(ApiDio().apiService.expenList);
    if (widget.recordModel != null && widget.recordModel.type == 1) {
      _selectedIndexLeft = _expenObjects.indexWhere(
              (item) => item.name == widget.recordModel.categoryImage);
    }
    setState(() {});
  }

  void _loadIncomeDatas() {
    _inComeObjects.clear();
    _inComeObjects.addAll(ApiDio().apiService.incomeList);
    if (widget.recordModel != null && widget.recordModel.type == 2) {
      _selectedIndexRight = _inComeObjects.indexWhere(
              (item) => item.name == widget.recordModel.categoryImage);
    }
    setState(() {});
  }

  void _updateInitData() {
    if (widget.recordModel != null) {
      _time = DateTime.fromMillisecondsSinceEpoch(
          widget.recordModel.updateTimestamp);
      DateTime now = DateTime.now();
      if (_time.year == now.year &&
          _time.month == now.month &&
          _time.day == now.day) {
        _dateString = '今天 ${_time.hour}:${_time.minute}';
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

      if (widget.recordModel.money != null) {
        _numberString = Utils.formatDouble(double.parse(
            _numberString = widget.recordModel.money.toStringAsFixed(2)));
      }

      if (widget.recordModel.type == 2) {
        _tabController.index = 1;
      }
    } else {
      _time = DateTime.now();
      _dateString = '今天 ${_time.hour}:${_time.minute}';
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //动画执行结束时反向执行动画
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              //动画恢复到初始状态时执行动画（正向）
              _animationController.forward();
            }
          });
    // 启动动画
    _animationController.forward();

    _tapItemController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //动画执行结束 反向动画
              _tapItemController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              //动画恢复到初始状态 停止掉
              _tapItemController.stop();
            }
          });

    _updateInitData();
    _loadExpenDatas();
    _loadIncomeDatas();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    _tapItemController.stop();
    _tapItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      appBar: MyAppBar(
        backgroundColor: Color(0x00000000),
        // centerTitle: true,
        titleWidget: TabBar(
          // tabbar菜单
          controller: _tabController,
          tabs: tabs
              .map((str) => Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 38,
                    child: Text('$str'),
                  ))
              .toList(),
          labelColor: AppTheme.appTheme.normalColor(),
          labelStyle: AppTheme.appTheme
              .headline1(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelColor: AppTheme.appTheme.normalColor(),
          unselectedLabelStyle: AppTheme.appTheme
              .headline1(fontWeight: FontWeight.normal, fontSize: 16),
          indicatorWeight: 2,
          indicatorColor: AppTheme.appTheme.normalColor(),
          // 下划线高度
          isScrollable: true,
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
      resizeToAvoidBottomInset: false, // 默认true键盘弹起不遮挡
      body: _buildBody(),
    );
  }

  /// body
  _buildBody() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildExpenCategory(),
                _buildIncomeCategory(),
              ],
            ),
          ),
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
                          _remark.isEmpty ? '备注...' : _remark,
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
                padding: const EdgeInsets.only(left: 12),
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
                        _dateString = '今天 ${_time.hour}:${_time.minute}';
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
          MyKeyBoard(
            isAdd: _isAdd,
            // 键盘输入
            numberCallback: (number) => inputVerifyNumber(number),
            // 删除
            deleteCallback: () {
              if (_numberString.length > 0) {
                setState(() {
                  _numberString =
                      _numberString.substring(0, _numberString.length - 1);
                });
              }
            },
            // 清除
            clearZeroCallback: () {
              _clearZero();
            },
            // 等于
            equalCallback: () {
              setState(() {
                _addNumber();
              });
            },
            //继续
            nextCallback: () {
              if (_isAdd == true) {
                _addNumber();
              }
              _record(isGoOn: true);
              _clearZero();
              setState(() {});
            },
            // 保存
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

  /// 相加
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

  /// 记账保存
  void _record({bool isGoOn = false}) {
    if (_numberString.isEmpty || _numberString == '0.') {
      return;
    }
    _isAdd = false;
    CategoryItem item;
    if (_tabController.index == 0) {
      item = _expenObjects[_selectedIndexLeft];
    } else {
      item = _inComeObjects[_selectedIndexRight];
    }
    BillRecordModel model;
    if (widget.recordModel != null) {
      //修改
      model = widget.recordModel
        ..money = double.parse(_numberString)
        ..remark = _remark
        ..userKey = SessionUtils().currentUser.key
        ..type = _tabController.index + 1
        ..categoryImage = item.name
        ..updateTime =
            DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
                .toString()
        ..updateTimestamp = _time.millisecondsSinceEpoch;
    } else {
      model = BillRecordModel()
        ..id = null
        ..money = double.parse(_numberString)
        ..remark = _remark
        ..userKey = SessionUtils().currentUser.key
        ..type = _tabController.index + 1
        ..categoryImage = item.name
        ..createTime =
            DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
                .toString()
        ..createTimestamp = _time.millisecondsSinceEpoch
        ..updateTime =
            DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch)
                .toString()
        ..updateTimestamp = _time.millisecondsSinceEpoch;
    }
    ApiDio().apiService.addBill(model).listen((event) {
      if (event.code == 200) {
        BlocProvider.of<BillBloc>(appContext).add(BillLoad());
        if (isGoOn) {
          FlashHelper.toast(context, '提交成功，请继续');
        } else {
          Navigator.pop(context);
        }
      } else {
        FlashHelper.toast(context, '提交失败');
      }
    }).onError((err) {
      FlashHelper.toast(context, '提交失败');
    });
  }

  /// 清零
  void _clearZero() {
    setState(() {
      _isAdd = false;
      _numberString = '';
    });
  }

  /// 选中index
  int _selectedIndexLeft = 0;

  /// 支出构建
  _buildExpenCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GridView.builder(
        key: PageStorageKey<String>("0"), //保存状态
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8),
        itemCount: _expenObjects.length,
        itemBuilder: (context, index) {
          return _getCategoryItem(
              _expenObjects[index], index, _selectedIndexLeft);
        },
      ),
    );
  }

  /// 选中index
  int _selectedIndexRight = 0;

  /// 收入构建
  _buildIncomeCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GridView.builder(
        key: PageStorageKey<String>("1"), //保存状态
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8),
        itemCount: _inComeObjects.length,
        itemBuilder: (context, index) {
          return _getCategoryItem(
              _inComeObjects[index], index, _selectedIndexRight);
        },
      ),
    );
  }

  /// 构建类别item
  _getCategoryItem(CategoryItem item, int index, selectedIndex) {
    return GestureDetector(
      onTap: () {
        if (_tabController.index == 0) {
          //左边支出类别
          if (_selectedIndexLeft != index) {
            _selectedIndexLeft = index;
            _tapItemController.forward();
            setState(() {});
          }
        } else {
          //右边收入类别
          if (_selectedIndexRight != index) {
            _selectedIndexRight = index;
            _tapItemController.forward();
            setState(() {});
          }
        }
      },
      child: AnimatedBuilder(
        animation: _tapItemController,
        builder: (BuildContext context, Widget child) {
          return ClipOval(
            child: Container(
              decoration: Gaps.boxDe(),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Utils.getImagePath('category/${item.image}'),
                    width: selectedIndex == index
                        ? ScreenUtil.getInstance()
                            .setWidth(60 + _tapItemController.value * 6)
                        : ScreenUtil.getInstance().setWidth(50),
                    color: selectedIndex == index ? Colors.white : Colors.black,
                  ),
                  Gaps.vGap(5),
                  Text(
                    item.name,
                    style: AppTheme.appTheme.headline1(
                        textColor: selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 键盘输入验证
  void inputVerifyNumber(String number) {
    //小数点精确分，否则不能输入
    //加法
    if (_numberString.isEmpty) {
      //没输入的时候，不能输入+或者.
      if (number == '+') {
        return;
      }

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
        // 当只有一个数字
        if (numbers.first == '0') {
          //如果第一个数字是0，那么输入其他数字和+不生效
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
          //第一个数字不是0 为1-9
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
          //加号
          return;
        }

        //拿到最后一个数字
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
