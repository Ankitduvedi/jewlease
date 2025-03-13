import 'package:flutter/material.dart';

class InactiveCustomers extends StatefulWidget {
  @override
  State<InactiveCustomers> createState() => _InactiveCustomersState();
}

class _InactiveCustomersState extends State<InactiveCustomers> {
  @override
  String _selectedTimeRange = 'Today';

  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 300,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF410203), // Dark purple
              Color(0xFF8D1A1B), // Blue
            ],
          ),
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inactice Customers',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
                Text(
                  '7',
                  style: TextStyle(color: Colors.green, fontSize: 25),
                ),
                RichText(
                  text: TextSpan(
                      text: '',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                      children: [
                        TextSpan(
                            text: 'Over 12 Year',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ))
                      ]),
                )
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
                    backgroundColor: Colors.red,
                    // Light blue background
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                    // Blue accent progress color
                    minHeight: 10, // Adjust height
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Progress Label
          ],
        ));
  }
}
