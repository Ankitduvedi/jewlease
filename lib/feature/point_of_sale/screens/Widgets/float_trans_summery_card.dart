import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/point_of_sale/screens/Widgets/payment_varien_dialog.dart';
import 'package:jewlease/feature/procument/screens/procumentSummeryGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../main.dart';
import '../../../procument/screens/formulaGrid.dart';

class FlotatingPOS extends ConsumerStatefulWidget {
  FlotatingPOS({
    super.key,
    required this.varients,
    required this.summery,
  });

  final List<Map<String, dynamic>> varients;
  Map<String, dynamic> summery;

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
  TextEditingController discountController = TextEditingController();

  void intializeGrid(List<Map<String, dynamic>> varients) {
    setState(() {
      summery = varients
          .map((varient) =>
          DataGridRow(cells: [
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
  bool showOptions = false;
  List<String> options = ["Labour", "Diamond", "HallMarking"];
  Map<String, dynamic> discounts = {};

  @override
  Widget build(BuildContext context) {
    // bool value = dropDownValue['Payment Method'] == 'CHEQUE';
    // print("dropdown values $dropDownValue ${value}");
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
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
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    Dialog(
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
                Icon(Icons.edit),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Dialog(
                            // Set the shape with border radius here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // To control dialog width/height, avoid using fixed values in Container
                            // Instead, set insetPadding or constraints at Dialog level
                            insetPadding: EdgeInsets.symmetric(horizontal: 20),
                            // Optional padding from screen edges
                            child: Container(
                              padding: EdgeInsets.all(16), // Inner padding
                              constraints: BoxConstraints(
                                maxWidth: 300, // Or your desired width
                                maxHeight: 400, // Or your desired height
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                // Makes column shrink-wrap its content
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Give Discount",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.cancel),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Amount",
                                        border: OutlineInputBorder(),
                                      ),
                                      controller: discountController,
                                      onSubmitted: (val) {
                                        setState(() {
                                          showOptions = true;
                                        });
                                      },
                                    ),
                                    width: 200,
                                  ),
                                  if (discounts.isNotEmpty)
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 200,
                                      child: Center(
                                        child: Text(discounts.keys.first),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade100,
                                      ),
                                      padding: EdgeInsets.all(10),
                                    ),
                                  if (showOptions == true)
                                    Expanded(
                                      // Use Expanded for the ListView to take available space
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                discounts[options[index]] =
                                                    discountController.text;
                                                showOptions = false;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Container(
                                                // margin:
                                                //     EdgeInsets.only(top: 10),
                                                width: 100,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                  color: Colors.grey.shade600,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    options[index],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  SizedBox(height: 16),
                                  InkWell(
                                    onTap: () {
                                      widget.summery["TotalTransAmt"] -=
                                          double.parse(discountController.text);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Apply",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xff28713E),
                                      ),
                                      width: 150,
                                      height: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: Text(
                    widget.summery["TotalTransAmt"].toString(),
                    style: TextStyle(fontSize: 20),
                  ),
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
                builder: (context) =>
                    PaymentVarientDialog(
                      dataGridSource: dataGridSource,
                      transferOutwardColumnns: transferOutwardColumnns,
                      totalAmount: widget.summery["TotalTransAmt"],
                    ),
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
