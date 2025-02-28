import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/point_of_sale/screens/Widgets/payment_varien_dialog.dart';
import 'package:jewlease/feature/procument/screens/procumentSummeryGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../main.dart';

class FlotatingPOS extends ConsumerStatefulWidget {
  const FlotatingPOS({super.key, required this.varients});

  final List<Map<String, dynamic>> varients;

  @override
  ConsumerState<FlotatingPOS> createState() => _FlotatingPOSState();
}

class _FlotatingPOSState extends ConsumerState<FlotatingPOS> {
  List<DataGridRow> summery = [];
  late DataGridSource dataGridSource;

  @override
  void initState() {
    // TODO: implement initState
    print(" varient is ${widget.varients.length}");
    intializeGrid(widget.varients);

    super.initState();
  }

  void onDelete(DataGridRow row) {}

  void intializeGrid(List<Map<String, dynamic>> varients) {
    setState(() {
      summery = varients
          .map((varient) => DataGridRow(cells: [
                DataGridCell(
                    columnName: 'Sr No', value: varients.indexOf(varient) + 1),
                DataGridCell(
                    columnName: 'Variant Name', value: varient['Variant Name']),
                DataGridCell(columnName: '', value: ''),
              ]))
          .toList();
    });
    dataGridSource = ProcumentDataGridSource(summery, onDelete, () {}, false);
    print("summery le ${summery.length}");
  }

  List<String> transferOutwardColumnns = ['Sr No', 'Variant Name', ''];

  @override
  Widget build(BuildContext context) {
    // bool value = dropDownValue['Payment Method'] == 'CHEQUE';
    // print("dropdown values $dropDownValue ${value}");
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 70,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, -2),
          blurRadius: 3,
          spreadRadius: 2,
        )
      ]),
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: [
          Container(
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
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Text(
                  "Total ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "0.0",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              intializeGrid(widget.varients);
              showDialog(
                context: context,
                builder: (context) => PaymentVarientDialog(
                    dataGridSource: dataGridSource,
                    transferOutwardColumnns: transferOutwardColumnns),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff28703E),
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Center(
                child: Text(
                  "Payement",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xff28703E),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Center(
              child: Text(
                "Qyotation",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xff28703E),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Center(
              child: Text(
                "Discout Approval",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
