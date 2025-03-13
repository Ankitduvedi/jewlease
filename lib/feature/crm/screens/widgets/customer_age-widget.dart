import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jewlease/feature/barcoding/screens/invantory_transaction_screeen.dart';

class CustomerAgeChart extends StatefulWidget {
  @override
  State<CustomerAgeChart> createState() => _CustomerAgeChartState();
}

class _CustomerAgeChartState extends State<CustomerAgeChart> {
  String _selectedTimeRange = 'Today';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Age',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: '-77%',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                          children: [
                            TextSpan(
                                text: 'From Previous Year',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ))
                          ]),
                    )
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedTimeRange,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTimeRange = newValue!;
                    });
                  },
                  items: <String>['Today', 'Weekly', 'Monthly', 'Yearly']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Child',
                                  style: TextStyle(fontSize: 12));
                            case 1:
                              return Text('+18',
                                  style: TextStyle(fontSize: 12));
                            case 2:
                              return Text('+30',
                                  style: TextStyle(fontSize: 12));
                            case 3:
                              return Text('+40',
                                  style: TextStyle(fontSize: 12));
                            case 4:
                              return Text('+50',
                                  style: TextStyle(fontSize: 12));
                            case 5:
                              return Text('+60',
                                  style: TextStyle(fontSize: 12));
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(),
                              style: TextStyle(fontSize: 12));
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                            toY: 10,
                            color: Color(0xff1E4861),
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                        BarChartRodData(
                            toY: 10,
                            color: Colors.blueAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                      ],
                    ),

                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                            toY: 10,
                            color: Color(0xff1E4861),
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                        BarChartRodData(
                            toY: 10,
                            color: Colors.blueAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                            toY: 10,
                            color: Color(0xff1E4861),
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                        BarChartRodData(
                            toY: 10,
                            color: Colors.blueAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                            toY: 10,
                            color: Color(0xff1E4861),
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                        BarChartRodData(
                            toY: 10,
                            color: Colors.blueAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                            toY: 10,
                            color: Color(0xff1E4861),
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                        BarChartRodData(
                            toY: 10,
                            color: Colors.blueAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                      ],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(
                            toY: 10,
                            color: Color(0xff1E4861),
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                        BarChartRodData(
                            toY: 10,
                            color: Colors.blueAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            DashedLine(),
            Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor:Color(0xff1E4861),
                    ),
                    Text(
                      'Old',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.blueAccent,
                    ),
                    Text(
                      'New',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                Spacer(),
                Text('Not Available: 21'),
              ],
            )
          ],
        ));
  }
}
