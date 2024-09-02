import 'package:flutter/material.dart';

class CustomInfoSection extends StatelessWidget {
  const CustomInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade900, // Background color matching the image
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Metal Code
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Metal Code',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'AG',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Exclusive Indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exclusive Indicator',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                '-',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'ALLOY GOLD',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Row Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Row Status',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                '1',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Created Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Created Date',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                '29/01/2024 01:12 pm',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Last Modified Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Modified Date',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                '-',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
