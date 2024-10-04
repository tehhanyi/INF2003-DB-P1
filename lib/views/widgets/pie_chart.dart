import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';

class Donut extends StatefulWidget {
  // final Function onItemPressed; //= {} as Function;
  // final Map<String, double> dataMap;
  // final List<Color> colorList;
  // final int reportType;

  const Donut({Key? key,
    // required this.onItemPressed,
    // required this.dataMap,
    // required this.colorList,
    // required this.reportType,
  }) : super(key: key);
  @override
  DonutState createState() => DonutState();
}
class DonutState extends State<Donut> {
  List<Color> colorList = [
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xff6c5ce7),
  ];

  Map<String, double> dataMap = {
    "Shares": 250,
    "ETF": 180,
    "Bonds": 270,
    "Equities": 300,
  };


  @override
  void initState() {
    for (int i = 0; i < dataMap.length; i++) {
      // dataMap[] = 130;
      colorList.add(Colors.redAccent);
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      margin: EdgeInsets.only(top: 1.h, left:10, right:10) ,
      padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 3.h),
      child: PieChart(
        dataMap: dataMap,
        chartRadius: 35.w,//MediaQuery.of(context).size.width / 2.1,
        initialAngleInDegree: 180,
        chartType: ChartType.ring,
        baseChartColor: Colors.grey[50]!.withOpacity(0.15),
        ringStrokeWidth: 10.w,
        centerText: "Total Worth:\n" + '\$${dataMap.entries.map((e) => e.value).reduce((a, b) => a + b).toStringAsFixed(2)}',
        centerTextStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
        legendOptions: const LegendOptions(
          showLegendsInRow: true,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendTextStyle: TextStyle(fontWeight: FontWeight.bold,),
        ),
        colorList: colorList,
        chartValuesOptions: const ChartValuesOptions(
          showChartValues: false,
          showChartValueBackground: false,
          showChartValuesInPercentage: false,
          // showChartValuesOutside: true,
        ),
        totalValue: dataMap.entries.map((e) => e.value).reduce((a, b) => a + b),
      ));
  }
}
