import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../barcoding/screens/invantory_transaction_screeen.dart';

class CustomerActivityChart extends StatefulWidget {
  @override
  _CustomerActivityChartState createState() => _CustomerActivityChartState();
}

class _CustomerActivityChartState extends State<CustomerActivityChart> {
  String _selectedTimeRange = 'Today';

  final List<FlSpot> _dataPoints = [
    FlSpot(0, 5),
    FlSpot(2, 0),
    FlSpot(4, 6),
    FlSpot(6, 2),
    FlSpot(8, 2),
    FlSpot(10, 1),
    FlSpot(12, 0),
    FlSpot(14, 1),
  ];

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
                      'Hourly Customer',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    // Remove background grid
                    titlesData: FlTitlesData(

                      bottomTitles: AxisTitles(

                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('0 am',
                                    style: TextStyle(fontSize: 12));
                              case 2:
                                return Text('12 pm',
                                    style: TextStyle(fontSize: 12));
                              case 4:
                                return Text('2 pm',
                                    style: TextStyle(fontSize: 12));
                              case 6:
                                return Text('4 pm',
                                    style: TextStyle(fontSize: 12));
                              case 8:
                                return Text('6 pm',
                                    style: TextStyle(fontSize: 12));
                              case 10:
                                return Text('8 pm',
                                    style: TextStyle(fontSize: 12));
                              case 12:
                                return Text('10 pm',
                                    style: TextStyle(fontSize: 12));
                              case 14:
                                return Text('12 pm',
                                    style: TextStyle(fontSize: 12));
                              default:
                                return Text('');
                            }
                          },
                          interval: 2, // Equal spacing on X-axis
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false), // Hide Y-axis titles
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false, // Remove chart border
                    ),
                    minX: 0,
                    maxX: 14,
                    minY: 0,
                    maxY: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _dataPoints,
                        isCurved: false,
                        // Straight line chart
                        color: Colors.green,
                        barWidth: 3,
                        isStrokeCapRound: false,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: Colors.green,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(show: false),
                        aboveBarData: BarAreaData(show: false),
                      ),
                    ],
                    // Permanently show text labels on data points
                    showingTooltipIndicators: _dataPoints.map((spot) {
                      return ShowingTooltipIndicators([
                        LineBarSpot(
                          LineChartBarData(),
                          _dataPoints.indexOf(spot),
                          spot,
                        ),
                      ]);
                    }).toList(),
                  ),
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
                      backgroundColor: Colors.green,
                    ),
                    Text(
                      'Customers',
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
