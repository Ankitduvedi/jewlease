import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_detail_list_controller.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_history_list_controller.dart';
import 'package:jewlease/feature/barcoding/screens/status%20Card.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../procument/screens/procumenOprGrid.dart';
import '../../procument/screens/procumentBomGrid.dart';
import '../../procument/screens/procumentBomGridSource.dart';
import 'StockDetailsScreen.dart';

class BarcodingScreen extends ConsumerStatefulWidget {
  const BarcodingScreen({super.key});

  @override
  ConsumerState<BarcodingScreen> createState() => _BarcodingScreenState();
}

class _BarcodingScreenState extends ConsumerState<BarcodingScreen> {
  List<String> _tabs = [
    'Batch History',
    'Barcode History',
    'Inventory Transaction',
    'Financial Transaction',
    'Discount Approval',
    'Stone List'
  ];
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    int selectedIndex = ref.watch(barcodeIndexProvider);

    var historys = ref.watch(barcodeHistoryListProvider);

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
                            itemCount:
                                ref.watch(barcodeDetailListProvider).length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 50,
                                width: 220,
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(barcodeIndexProvider.notifier)
                                        .state = index;
                                  },
                                  child: StatusCard(
                                    date: DateFormat('d-M-yyyy').format(
                                        DateTime.parse(ref
                                            .watch(barcodeDetailListProvider)[
                                                index]
                                            .date)),
                                    documentId: ref
                                        .watch(barcodeDetailListProvider)[index]
                                        .transNo
                                        .toString(),
                                    note: ref
                                        .watch(barcodeDetailListProvider)[index]
                                        .transType,
                                    status1: 'Verified',
                                    status2: 'Active',
                                    isSelected: index == selectedIndex,
                                  ),
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
                                  // InkWell(
                                  //   onTap: () {},
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //         color: Colors.black12,
                                  //         borderRadius:
                                  //             BorderRadius.circular(8)),
                                  //     child: Center(
                                  //       child: Text(
                                  //         "Item Summery",
                                  //         style: TextStyle(color: Colors.black),
                                  //       ),
                                  //     ),
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: 20, vertical: 5),
                                  //   ),
                                  // ),
                                  Expanded(child: Container())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (historys[selectedIndex].bom.isNotEmpty)
                                Expanded(
                                    child: ItemDetails(
                                        bom: historys[selectedIndex].bom,
                                        operation:
                                            historys[selectedIndex].operation)),
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

class ItemDetails extends StatefulWidget {
  const ItemDetails({super.key, required this.bom, required this.operation});

  final Map<String, dynamic> bom;
  final Map<String, dynamic> operation;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final DataGridController _dataGridController = DataGridController();
  late procumentBomGridSource _bomDataGridSource;
  late procumentBomGridSource _oprDataGridSource;
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
    print("rebuilding item details");
    initializeBomOpr();
    _bomDataGridSource = procumentBomGridSource(
        _bomRows, _removeRow, _updateBomSummaryRow, showFormula, true);
    _oprDataGridSource = procumentBomGridSource(
        _OpeationRows, _removeRow, _updateBomSummaryRow, showFormula, true);

    super.initState();
  }

  void initializeBomOpr() {
    print("bom is ${widget.bom}");
    List<dynamic> listOfBoms = widget.bom["data"];

    _bomRows = listOfBoms.map((bom) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: bom[0]),
        DataGridCell<String>(columnName: 'Item Group', value: bom[1]),
        DataGridCell<int>(columnName: 'Pieces', value: bom[2]),
        DataGridCell<double>(columnName: 'Weight', value: bom[3] * 1.0),
        DataGridCell(columnName: 'Rate', value: bom[4]),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: bom[5] * 1.0),
        DataGridCell(columnName: 'Amount', value: bom[6]),
        DataGridCell<String>(columnName: 'Sp Char', value: bom[7]),
        DataGridCell<String>(columnName: 'Operation', value: bom[8]),
        DataGridCell<String>(columnName: 'Type', value: bom[9]),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    }).toList();
    List<dynamic> listOfOperation = widget.operation["data"];
    print("operation is $listOfOperation");
    _OpeationRows = listOfOperation.map((opr) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Calc Bom', value: opr[0]),
        DataGridCell<String>(columnName: 'Operation', value: opr[1]),
        DataGridCell<int>(columnName: 'Calc Qty', value: opr[2]),
        DataGridCell<dynamic>(columnName: 'Type', value: opr[3]),
        DataGridCell<dynamic>(columnName: 'Calc Method', value: opr[4]),
        DataGridCell<dynamic>(columnName: 'Calc Method Value', value: opr[5]),
        DataGridCell<dynamic>(columnName: 'Depd Method', value: opr[6]),
        DataGridCell<dynamic>(columnName: 'Depd Method Value', value: opr[7]),
        DataGridCell<Widget>(columnName: 'Depd Type', value: null),
        DataGridCell<Widget>(columnName: 'Depd Qty', value: null),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth = screenWidth * 0.4;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '   Modify Bom',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.28,
                child: ProcumentBomGrid(
                  bomDataGridSource: _bomDataGridSource,
                  dataGridController: _dataGridController,
                  gridWidth: gridWidth,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 1)
                ]),
            child: SizedBox(
              height: screenHeight * 0.33,
              child: ProcumentOperationGrid(
                  operationType: 'Modify operation',
                  gridWidth: gridWidth,
                  dataGridController: _dataGridController,
                  oprDataGridSource: _oprDataGridSource),
            ),
          ),
        )
      ],
    );
  }
}
