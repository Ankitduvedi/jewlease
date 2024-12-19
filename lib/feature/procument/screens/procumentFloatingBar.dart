import 'package:flutter/material.dart';
import 'package:jewlease/main.dart';

class SummaryDetails extends StatelessWidget {
  const SummaryDetails({super.key, required this.procumentSummery});
  final Map<String, dynamic> procumentSummery;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      // margin: const EdgeInsets.all(16.0),
      height: 50,
      // margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // color: Colors.grey.shade100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const TotalHeader(total: 47.26)),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 30,
            color: Colors.grey,
            width: 0.5,
          ),
          // Details Rows
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              height: 40,
              width: double.infinity,
              color: Colors.grey.shade300.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DetailsRow(
                      label: "Pieces", value: procumentSummery['Pieces'] * 1.0),
                  DetailsRow(label: "Wt", value: procumentSummery['Wt']),
                  DetailsRow(
                      label: "Metal Wt", value: procumentSummery['Metal Wt']),
                  DetailsRow(
                      label: "Metal Amt", value: procumentSummery['Metal Amt']),
                  DetailsRow(
                      label: "Stone Wt", value: procumentSummery['Stone Wt']),
                  DetailsRow(
                      label: "Stone Amt", value: procumentSummery['Stone Amt']),
                  DetailsRow(
                      label: "Labour Amt",
                      value: procumentSummery['Labour Amt']),
                  DetailsRow(
                      label: "Wastage", value: procumentSummery['Wastage']),
                  DetailsRow(
                      label: "Wastage Fine",
                      value: procumentSummery['Wastage Fine']),
                  DetailsRow(
                      label: "Total Fine",
                      value: procumentSummery['Total Fine']),
                  DetailsRow(
                      label: "Total Amt", value: procumentSummery['Total Amt']),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

// Widget for the Total Header
class TotalHeader extends StatelessWidget {
  final double total;

  const TotalHeader({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 8,
            child: Icon(Icons.check, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          Text(
            "Total",
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(width: 8),
          Text(
            total.toStringAsFixed(2),
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// Reusable Widget for Each Row
class DetailsRow extends StatelessWidget {
  final String label;
  final double value;

  DetailsRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.black87),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
