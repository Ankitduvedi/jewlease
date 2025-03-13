import 'package:flutter/material.dart';

class CustomerWalkInProgress extends StatefulWidget {
  @override
  State<CustomerWalkInProgress> createState() => _CustomerWalkInProgressState();
}

class _CustomerWalkInProgressState extends State<CustomerWalkInProgress> {
  @override
  String _selectedTimeRange = 'Today';

  Widget build(BuildContext context) {
    return Container(

        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Walk-In',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '0',
                            style: TextStyle(color: Colors.green, fontSize: 25),
                          ),
                          RichText(
                            text: TextSpan(
                                text: '-77%',
                                style:
                                    TextStyle(color: Colors.green, fontSize: 12),
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
                  SizedBox(height: 16),

                  // Linear Progress Bar
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      // Background color
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        // Progress Value
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(5),
                          value: 0.5,
                          // 50% progress
                          backgroundColor: Colors.blue,
                          // Light blue background
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xff1E4861),
                          ),
                          // Blue accent progress color
                          minHeight: 10, // Adjust height
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),

                  // Progress Labels
                  Row(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0xff1E4861),
                          ),
                          Text(
                            '0 Old',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.blueAccent,
                          ),
                          Text(
                            '1 New',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            Container(
              height: 43,
              decoration: BoxDecoration(
                  color: Color(0xffFFF7EB),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
            )
            // Header Row
          ],
        ));
  }
}
