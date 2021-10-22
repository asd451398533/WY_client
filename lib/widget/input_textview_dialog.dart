import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'highlight_well.dart';

typedef void Confirm(String text);

class TextViewDialog extends StatefulWidget {
  const TextViewDialog({Key key, this.confirm}) : super(key: key);
  final Confirm confirm;

  @override
  State<StatefulWidget> createState() {
    return _TextViewDialogState();
  }
}

class _TextViewDialogState extends State<TextViewDialog> {
  TextEditingController _editingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  FocusScopeNode _scopeNode;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: 300), () {
      _scopeNode.requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (null == _scopeNode) {
      _scopeNode = FocusScope.of(context);
    }
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(160)),
          child: Container(
            width: ScreenUtil.getInstance().setWidth(560),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '填写备注',
                    style:
                        TextStyle(fontSize: ScreenUtil.getInstance().setSp(32)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onSubmitted: (text) {
                      if (widget.confirm != null) {
                        widget.confirm(text);
                      }
                      Navigator.pop(context);
                    },
                    controller: _editingController,
                    focusNode: _focusNode,
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: ScreenUtil.getInstance().setSp(32)),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: '备注...', border: InputBorder.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 49,
                  child: Stack(
                    children: <Widget>[
                      Container(height: 0.6, color: Color(0xFFEEEEEE)),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: HighLightWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '取消',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: HighLightWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '确认',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              onTap: () {
                                if (widget.confirm != null) {
                                  widget.confirm(_editingController.text);
                                }
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
