import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/widget/custom_edit_field.dart';

class EditFiledView extends StatefulWidget {
  final Mutable<String> content;
  final String hintText;
  final String title;
  final Function(String str) ok;

  const EditFiledView(
      {Key key, this.content, this.hintText, this.title, this.ok})
      : super(key: key);

  @override
  _EditFiledViewState createState() => _EditFiledViewState();
}

class _EditFiledViewState extends State<EditFiledView> {
  String str;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: widget.title != null && widget.title.isNotEmpty ? 0 : 32,
                  bottom: 32),
              margin: EdgeInsets.only(left: 32, right: 32),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: AppTheme.appTheme.cardBackgroundColor()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.title != null && widget.title.isNotEmpty
                      ? Container(
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(
                            widget.title,
                            style: AppTheme.appTheme.headline1(fontSize: 13),
                          ),
                        )
                      : Container(
                          height: 1,
                        ),
                  CustomEditField(
                    maxLength: 50,
                    autoFucus: true,
                    initValue: widget.content.value,
                    hintText: widget.hintText == null || widget.hintText.isEmpty
                        ? "记录些什么 ..."
                        : widget.hintText,
                    hintTextStyle: AppTheme.appTheme
                        .hint(fontWeight: FontWeight.normal, fontSize: 16),
                    textStyle: AppTheme.appTheme
                        .headline1(fontWeight: FontWeight.normal, fontSize: 16),
                    minHeight: 100,
                    containerDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: AppTheme.appTheme.containerBackgroundColor()),
                    numDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: AppTheme.appTheme.cardBackgroundColor(),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: AppTheme.appTheme.containerBoxShadow()),
                    numTextStyle: AppTheme.appTheme
                        .themeText(fontWeight: FontWeight.bold, fontSize: 15),
                    onValueChanged: (value) {
                      str = value;
                      widget.content.value = value;
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (widget.ok != null) {
            widget.ok(str);
          }
        },
        child: Icon(Icons.done),
        backgroundColor: AppTheme.appTheme.grandientColorStart(),
      ),
    );
  }
}
