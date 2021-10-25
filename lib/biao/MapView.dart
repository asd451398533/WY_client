import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/res/styles.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/widget/app_bar.dart';

class LineChartSample1 extends StatefulWidget {
  final Map<String, List<XT>> dayMap;
  final XT xt;

  const LineChartSample1({Key key, this.dayMap, this.xt}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      appBar: MyAppBar(
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
        backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
        titleWidget: Text("统计"
        ,style: AppTheme.appTheme.headline1(fontSize: 16),),
      ),
      body: Container(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: Gaps.boxDe(),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${DateUtil.getXTToday(widget.xt)}",
                      style: AppTheme.appTheme
                          .headline1(fontWeight: FontWeight.bold, fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                        child: _LineChart(
                          isShowingMainData: isShowingMainData,
                          dayList: widget
                              .dayMap[DateUtil.getXTToday(widget.xt)].reversed
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<XT> dayList;

  const _LineChart({this.isShowingMainData, this.dayList});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: dayList.length.toDouble(),
        maxY: 15,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor:AppTheme.appTheme.normalColor().withOpacity(0.3),

        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: bottomTitles,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: leftTitles(
          getTitles: (value) {
            return "${value}";
          },
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  SideTitles leftTitles({GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 10,
        interval: 1,
        reservedSize: 30,
        getTextStyles: (context, value) =>
            AppTheme.appTheme.headline1(fontSize: 13),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 90,
        rotateAngle: 90,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) =>
            AppTheme.appTheme.headline1(fontSize: 13),
        getTitles: (value) {
          if (value == 0) {
            return "";
          }
          return dayList[value.toInt()-1].type;
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: AppTheme.appTheme.normalColor(), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        colors: [AppTheme.appTheme.normalColor()],
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: getFL(),
      );

  List<FlSpot> getFL() {
    List<FlSpot> list = [];
    int i = 0;
    dayList.forEach((element) {
      i++;
      list.add(FlSpot(i.toDouble(), element.number));
    });
    return list;
  }
}
