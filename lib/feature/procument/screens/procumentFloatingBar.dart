import 'package:flutter/material.dart';
import 'package:jewlease/main.dart';

import 'formulaGrid.dart';

class SummaryDetails extends StatelessWidget {
  const SummaryDetails({super.key, required this.Summery});

  final Map<String, dynamic> Summery;

  @override
  Widget build(BuildContext context) {
    print("procument summery is $Summery ${Summery["Pieces"].runtimeType}");
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
              child: TotalHeader(total: Summery["TotalTransAmt"])),
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
                      label: "Pieces",
                      value: Summery["Pieces"].runtimeType == String
                          ? int.parse(Summery["Pieces"]) * 1.0
                          : Summery["Pieces"] * 1.0),
                  DetailsRow(label: "Wt", value: Summery['Wt'] * 1.0),
                  DetailsRow(label: "Metal Wt", value: Summery['Metal Wt']),
                  DetailsRow(label: "Metal Amt", value: Summery['Metal Amt']),
                  DetailsRow(label: "Stone Wt", value: Summery['Stone Wt']),
                  DetailsRow(label: "Stone Amt", value: Summery['Stone Amt']),
                  DetailsRow(label: "Labour Amt", value: Summery['Labour Amt']),
                  DetailsRow(label: "Wastage", value: Summery['Wastage']),
                  DetailsRow(
                      label: "Wastage Fine", value: Summery['Wastage Fine']),
                  DetailsRow(label: "Total Fine", value: Summery['Total Fine']),
                  DetailsRow(
                      label: "Total Amt", value: Summery['Total Amt'] * 1.0),
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
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: screenHeight * 0.35,
                    width: screenWidth * 0.42,
                    child: Center(
                      child: FormulaDataGrid(
                        varientIndex: 0,
                        varientName: "",
                        isFromBom: true,
                        FormulaName: "transactionFormuala",
                        backButton: () {
                          Navigator.pop(context);
                        },
                        formulaIndex: 0,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: 35,
              width: 35,
              color: Colors.green.shade50,
              child: Center(
                child: Text(
                  "F",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ),
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
