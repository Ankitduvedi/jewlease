import 'package:flutter/material.dart';
import 'package:jewlease/feature/barcoding/screens/status%20Card.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../procument/screens/procumentGridSource.dart';
import 'StockDetailsScreen.dart';
import 'itemDetailsGrid.dart';

class BarcodingScreen extends StatefulWidget {
  const BarcodingScreen({super.key});

  @override
  State<BarcodingScreen> createState() => _BarcodingScreenState();
}

class _BarcodingScreenState extends State<BarcodingScreen> {
  List<String> _tabs = [
    'Batch History',
    'Barcode History',
    'Inventory Transaction',
    'Financial Transaction',
    'Discount Approval',
    'Stone List'
  ];
  int selectedIndex = 0;
  final DataGridController _dataGridController = DataGridController();
  late procumentGridSource _bomDataGridSource;
  late procumentGridSource _oprDataGridSource;
  List<DataGridRow> _bomRows = [];
  List<DataGridRow> _OpeationRows = [];
  //<------------------------- Function To Remove Bom Row ----------- -------------->

  void _removeRow(DataGridRow row) {
    setState(() {
      _bomRows.remove(row);
      _bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Function To Update Bom Summary Row  ----------- -------------->

  void _updateBomSummaryRow() {}

  void showFormula(String val, int index) {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bomDataGridSource = procumentGridSource(
        _bomRows, _removeRow, _updateBomSummaryRow, showFormula);
    _oprDataGridSource = procumentGridSource(
        _OpeationRows, _removeRow, _updateBomSummaryRow, showFormula);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    double gridWidth = screenWidth * 0.4;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.08,
            ),
            height: screenHeight * 0.05,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                    children: List.generate(
                  _tabs.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        color: index == selectedIndex
                            ? Color(0xff28713E)
                            : Colors.white,
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.007),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.005),
                          decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? Color(0xff28713E)
                                : Color(0xffF0F4F8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                  color: index == selectedIndex
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )))),
      ),
      body: Container(
          color: Colors.grey.shade200,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: StockDetailsScreen()),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 50,
                                width: 220,
                                child: StatusCard(
                                  date: '4-12-2024 (GRN)',
                                  documentId: 'HO-FIX-GRN-24-25311',
                                  note: 'GOODS RECEIPT NOTE',
                                  status1: 'Verified',
                                  status2: 'Active',
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff075184),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: Text(
                                          "Item Details",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: Text(
                                          "Item Summery",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                    ),
                                  ),
                                  Expanded(child: Container())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              VariantDetailsGrid(
                                variants: [],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
