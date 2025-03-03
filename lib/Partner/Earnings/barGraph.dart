import 'package:applicationstugo/Partner/Earnings/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({super.key, required this.weeklySummary,});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thuAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );
    myBarData.initializeBarData();
    return BarChart(
        BarChartData(
      maxY: 200,
      minY: 0,
          gridData:const FlGridData(show: false) ,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,getTitlesWidget: getBottomTitles,),),
          ),
          barGroups: myBarData.barData
              .map(
                (data) => BarChartGroupData(
                  x: data.x,
                  barRods: [BarChartRodData(toY: data.y,
                  color: Colors.white,
                    width: 40,
                    borderRadius: BorderRadius.circular(16),

                    )


                  ],
          ),
          )
          .toList(),
    ));
  }
}

Widget getBottomTitles (double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontFamily: 'poppins',
    fontSize: 12,
  );

  Widget text;
  switch (value.toInt()){
    case 0:
    text = const Text('Sun',style: style,);
    break;
    case 1:
    text = const Text('Mon',style: style,);
    break;
    case 2:
    text = const Text('Tue',style: style,);
    break;
    case 3:
    text = const Text('Wed',style: style,);
    break;
    case 4:
    text = const Text('Thu',style: style,);
    break;
    case 5:
    text = const Text('Fri',style: style,);
    break;
    case 6:
    text = const Text('Sat',style: style,);
    break;
    default:
      text = const Text('',style: style,);

  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}