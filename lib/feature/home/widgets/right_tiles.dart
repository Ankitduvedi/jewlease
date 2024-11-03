import 'package:flutter/material.dart';

class WorkToDoWidget extends StatelessWidget {
  const WorkToDoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Constrain the height of the widget
        children: [
          Row(
            children: [
              Icon(
                Icons.check_box,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(width: 4),
              Text(
                'Work To Do',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTaskTile('Task', '00', Colors.purple[100]),
              _buildTaskTile('Verification', '7', Colors.red[100]),
              _buildTaskTile('Acceptance', '0', Colors.orange[100]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(String title, String count, Color? backgroundColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Icon(
              Icons.refresh,
              color: Colors.blue,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
