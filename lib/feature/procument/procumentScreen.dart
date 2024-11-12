import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/routes/go_router.dart';
import 'dialog.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class procumentScreen extends ConsumerStatefulWidget {
  @override
  _procumentScreenState createState() => _procumentScreenState();
}

class _procumentScreenState extends ConsumerState<procumentScreen> {
  List<String> _tabs = [
    'Goods Reciept Note',
    'Purchase Order',
    'Purchase Return',
  ];

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
        Duration(seconds: 2),
        () => showDialog(
            context: context,
            builder: (context) => Dialog(child: procumentDialog())));
    // showDialog(context: context, builder: (context) => procumentDialog());
    super.initState();
  }

  InAppWebViewController? webViewController;
  String? selectedValue = 'Variant';

  @override
  Widget build(
    BuildContext context,
  ) {
    final selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.1,
        ),
        Container(
            height: screenHeight * 0.06,
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
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                    children: List.generate(
                  3,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(tabIndexProvider.notifier).state = index;
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
        Container(
          height: 10,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Goods Reciept Note'),
              actions: [
                AppBarButtons(
                  ontap: [
                    () {
                      if (selectedIndex == 1)
                        showDialog(
                            context: context,
                            builder: (context) => procumentScreen());
                      log('new pressed');
                      if (selectedIndex == 3)
                        context.go('/addFormulaProcedureScreen');
                    },
                    () {},
                    () {
                      // Reset the provider value to null on refresh
                      ref.watch(formulaProcedureProvider.notifier).state = [
                        'Style',
                        null,
                        null
                      ];
                    },
                    () {}
                  ],
                )
              ],
            ),
            body:ProcumentDataGrid()


            // InAppWebView(
            //     initialUrlRequest: URLRequest(
            //         url: WebUri.uri(Uri.file(
            //             "C:/Users/ASUS/StudioProjects/jewlease/lib/procument.html"))),
            //     initialOptions: InAppWebViewGroupOptions(
            //       crossPlatform: InAppWebViewOptions(
            //         javaScriptEnabled: true,
            //       ),
            //     ),
            //     onWebViewCreated: (controller) {
            //       webViewController = controller;
            //
            //       controller.addJavaScriptHandler(
            //         handlerName: 'openDialog',
            //         callback: (args) {
            //           if (args.isNotEmpty) {
            //             // Expecting args[0] to be a Map with 'row' and 'col'
            //             var cellInfo = args[0];
            //             int rowIndex = cellInfo['row'];
            //             int colIndex = cellInfo['col'];
            //           }
            //         },
            //       );
            //     }),
            // SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       // Padding(
            //       //   padding:
            //       //       EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            //       //   child: Row(
            //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       //     children: [
            //       //       Text('Load By'),
            //       //       const SizedBox(
            //       //         width: 10,
            //       //       ),
            //       //       Container(
            //       //         width: screenWidth * 0.1,
            //       //         height: screenHeight * 0.04,
            //       //         padding: EdgeInsets.symmetric(horizontal: 12.0),
            //       //         decoration: BoxDecoration(
            //       //           color: Color(0xff28713E),
            //       //           // Green background for the selected item
            //       //           borderRadius: BorderRadius.circular(5.0),
            //       //         ),
            //       //         child: DropdownButton<String>(
            //       //           value: selectedValue,
            //       //           hint: Text(
            //       //             "Select an option",
            //       //             style: TextStyle(color: Colors.white),
            //       //           ),
            //       //           icon: Icon(Icons.arrow_drop_down,
            //       //               color: Colors.white),
            //       //           // Down arrow icon
            //       //           dropdownColor: Colors.white,
            //       //           // Background color of dropdown menu
            //       //           underline: SizedBox(),
            //       //           // Removes the underline
            //       //           isExpanded: true,
            //       //           items: [
            //       //             DropdownMenuItem(
            //       //               value: "Variant",
            //       //               child: Text(
            //       //                 "Variant",
            //       //                 style: TextStyle(
            //       //                     color: Colors
            //       //                         .black), // Dropdown item color
            //       //               ),
            //       //             ),
            //       //             DropdownMenuItem(
            //       //               value: "Reference",
            //       //               child: Text(
            //       //                 "Reference",
            //       //                 style: TextStyle(
            //       //                     color: Colors
            //       //                         .black), // Dropdown item color
            //       //               ),
            //       //             ),
            //       //           ],
            //       //           onChanged: (value) {
            //       //             setState(() {
            //       //               selectedValue = value;
            //       //             });
            //       //           },
            //       //           style: TextStyle(
            //       //             color: Colors.white, // Selected value color
            //       //             fontWeight: FontWeight.w400,
            //       //           ),
            //       //         ),
            //       //       ),
            //       //       SizedBox(
            //       //         height: screenHeight * 0.04,
            //       //         width: screenWidth * 0.15,
            //       //         child: TextField(
            //       //           decoration: InputDecoration(
            //       //             labelText: 'Search',
            //       //             border: OutlineInputBorder(),
            //       //             prefixIcon: Icon(Icons.search),
            //       //           ),
            //       //           onChanged: (query) {
            //       //             setState(() {});
            //       //           },
            //       //         ),
            //       //       ),
            //       //       Container(
            //       //         padding: EdgeInsets.symmetric(
            //       //             horizontal: 10, vertical: 5),
            //       //         decoration: BoxDecoration(
            //       //             borderRadius: BorderRadius.circular(5),
            //       //             color: Color(0xff28713E)),
            //       //         child: Row(
            //       //           children: [
            //       //             Icon(
            //       //               Icons.filter_alt_rounded,
            //       //               color: Colors.white,
            //       //             ),
            //       //             Text(
            //       //               'Filter',
            //       //               style: TextStyle(color: Colors.white),
            //       //             ),
            //       //           ],
            //       //         ),
            //       //       ),
            //       //       SizedBox(
            //       //         width: screenWidth * 0.5,
            //       //       )
            //       //     ],
            //       //   ),
            //       // ),
            //       SizedBox(
            //         height: screenHeight * 0.8,
            //         width: screenWidth,
            //         child: InAppWebView(
            //             initialUrlRequest: URLRequest(
            //                 url: WebUri.uri(Uri.file(
            //                     "C:/Users/ASUS/StudioProjects/jewlease/lib/procument.html"))),
            //             initialOptions: InAppWebViewGroupOptions(
            //               crossPlatform: InAppWebViewOptions(
            //                 javaScriptEnabled: true,
            //               ),
            //             ),
            //             onWebViewCreated: (controller) {
            //               webViewController = controller;
            //
            //               controller.addJavaScriptHandler(
            //                 handlerName: 'openDialog',
            //                 callback: (args) {
            //                   if (args.isNotEmpty) {
            //                     // Expecting args[0] to be a Map with 'row' and 'col'
            //                     var cellInfo = args[0];
            //                     int rowIndex = cellInfo['row'];
            //                     int colIndex = cellInfo['col'];
            //                   }
            //                 },
            //               );
            //             }),
            //       ),
            //     ],
            //   ),
            // ),
          )
        ),
      ],
    );
  }
}


class ProcumentDataGrid extends StatefulWidget {
  @override
  _ProcumentDataGridState createState() => _ProcumentDataGridState();
}

class _ProcumentDataGridState extends State<ProcumentDataGrid> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _rows = [];
  late ProcumentDataGridSource _dataGridSource;

  @override
  void initState() {
    super.initState();
    _initializeRows();
    _dataGridSource = ProcumentDataGridSource(_rows, _removeRow, _updateSummaryRow);
  }

  void _addNewRowWithItemGroup(String itemGroup) {
    setState(() {


      _rows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Ref Document', value: ''),
          DataGridCell<String>(columnName: 'Line No', value: itemGroup),
          DataGridCell<int>(columnName: 'Stock Code', value: 0),
          DataGridCell<double>(columnName: 'Variant Name', value: 0.0),
          DataGridCell<double>(columnName: 'Stock Status', value: 0.0),
          DataGridCell<String>(columnName: 'Stone Wt', value: ''),
          DataGridCell<String>(columnName: 'Pieces', value: ''),
          DataGridCell<String>(columnName: 'Weight', value: ''),
          DataGridCell<Widget>(columnName: 'Rate', value: null),
      DataGridCell<Widget>(columnName: 'Amount', value: null),
      DataGridCell<Widget>(columnName: 'Wastage', value: null),

        ]),
      );
      _dataGridSource.updateDataGridSource();
      _updateSummaryRow();
    });
  }

  void _initializeRows() {
    _rows = [
      // Summary row
      DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Ref Document', value: ''),
        DataGridCell<String>(columnName: 'Line No', value: ''),
        DataGridCell<int>(columnName: 'Stock Code', value: 0),
        DataGridCell<double>(columnName: 'Variant Name', value: 0.0),
        DataGridCell<double>(columnName: 'Stock Status', value: 0.0),
        DataGridCell<String>(columnName: 'Stone Wt', value: ''),
        DataGridCell<String>(columnName: 'Pieces', value: ''),
        DataGridCell<String>(columnName: 'Weight', value: ''),
        DataGridCell<Widget>(columnName: 'Rate', value: null),
        DataGridCell<Widget>(columnName: 'Amount', value: null),
        DataGridCell<Widget>(columnName: 'Wastage', value: null),

      ]),
    ];
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _rows.remove(row);
      _dataGridSource.updateDataGridSource();
      _updateSummaryRow();
    });
  }

  void _updateSummaryRow() {
    int totalPcs = 0;
    double totalWt = 0.0;

    for (var i = 1; i < _rows.length; i++) {
      totalPcs += _rows[i].getCells()[2].value as int;
      totalWt += _rows[i].getCells()[3].value * 1.0 as double;
    }

    double avgWtPcs = totalPcs > 0 ? totalWt / totalPcs : 0.0;

    setState(() {
      _rows[0] = DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Ref Document', value: ''),
        DataGridCell<String>(columnName: 'Line No', value: ''),
        DataGridCell<int>(columnName: 'Stock Code', value: 0),
        DataGridCell<double>(columnName: 'Variant Name', value: 0.0),
        DataGridCell<double>(columnName: 'Stock Status', value: 0.0),
        DataGridCell<String>(columnName: 'Stone Wt', value: ''),
        DataGridCell<String>(columnName: 'Pieces', value: ''),
        DataGridCell<String>(columnName: 'Weight', value: ''),
        DataGridCell<Widget>(columnName: 'Rate', value: null),
        DataGridCell<Widget>(columnName: 'Amount', value: null),
        DataGridCell<Widget>(columnName: 'Wastage', value: null),

      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth =
        screenWidth * 0.6; // Set grid width to 50% of screen width
    print("widht ${screenWidth} ${screenWidth * 0.9}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.68,
            margin: EdgeInsets.only(top: 10, left: 10),
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Shadow color with opacity
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 4), // Offset only on the bottom
                ),
              ],
            ),
            // height: screenHeight * 0.5,
            width: screenWidth * 0.94  ,
            child: Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  width: screenWidth,
                  // Set the grid width to 50% of the screen width
                  child: SfDataGrid(
                    rowHeight: 40,
                    headerRowHeight: 40,
                    source: _dataGridSource,
                    controller: _dataGridController,
                    footerFrozenColumnsCount: 1,
                    // Freeze the last column
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'Ref Document',
                        width: gridWidth /
                            5, // Adjust column width to fit 4-5 columns
                        label: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF003450),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15))
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Ref Document',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      GridColumn(
                        columnName: 'Stock Code',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Stock Code',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Line No',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Line No',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Variant Name',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Variant Name',
                            style: TextStyle(color: Colors.green),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Stock Status',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Stock Status',
                            style: TextStyle(color: Colors.green),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Stone Wt',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Stone Wt',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Pieces',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Pieces',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Weight',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Weight',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Rate',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Rate',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Amount',
                        width: gridWidth /
                            5, // Adjust column width to fit 4-5 columns
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Amount',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Wastage',
                        width: gridWidth /
                            5, // Adjust column width to fit 4-5 columns
                        label: Container(

                          decoration: BoxDecoration(
                              color: Color(0xFF003450),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15))
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Wastage',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ProcumentDataGridSource extends DataGridSource {
  ProcumentDataGridSource(this.dataGridRows, this.onDelete, this.onEdit)
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;

  @override
  List<DataGridRow> get rows => dataGridRows;

  // Method to recalculate all 'Wt' values
  void recalculateWt() {
    for (int rowIndex = 0; rowIndex < dataGridRows.length; rowIndex++) {
      final row = dataGridRows[rowIndex];
      int pcsValue =
          row.getCells().firstWhere((c) => c.columnName == "Pcs").value ?? 0;
      String groupName = row
          .getCells()
          .firstWhere((c) => c.columnName == "Item Group")
          .value as String;
      pcsValue += groupName.contains('Gold') == true ? 1 : 0;
      final avgWtValue = row
          .getCells()
          .firstWhere((c) => c.columnName == "Avg Wt(Pcs)")
          .value ??
          0;
      double avgWt = row
          .getCells()
          .firstWhere((c) => c.columnName == "Avg Wt(Pcs)")
          .value *
          1.0 ??
          0;
      double Wt =
          row.getCells().firstWhere((c) => c.columnName == "Wt").value * 1.0 ??
              0;

      // Recalculate Wt
      if (Wt != 0) {
        dataGridRows[rowIndex] = DataGridRow(cells: [
          for (var cell in row.getCells())
            if (cell.columnName == "Avg Wt(Pcs)")
              DataGridCell<double>(
                columnName: cell.columnName,
                value: Wt / (pcsValue == 0 ? 1 : pcsValue),
              )
            else
              cell,
        ]);
      } else if (avgWt != 0) {
        dataGridRows[rowIndex] = DataGridRow(cells: [
          for (var cell in row.getCells())
            if (cell.columnName == "Wt")
              DataGridCell<double>(
                columnName: cell.columnName,
                value: pcsValue * avgWtValue * 1.0,
              )
            else
              cell,
        ]);
      }
    }
  }

  // Method to calculate column summation for a summary row
  DataGridRow getSummaryRow() {
    final Map<String, double> columnTotals = {};

    for (final row in dataGridRows) {
      for (final cell in row.getCells()) {
        if (cell.value is num) {
          columnTotals[cell.columnName] =
              (columnTotals[cell.columnName] ?? 0) + cell.value;
        }
      }
    }

    return DataGridRow(
      cells: [
        for (var entry in columnTotals.entries)
          DataGridCell<double>(
            columnName: entry.key,
            value: entry.value,
          ),
      ],
    );
  }

  void updateDataGridSource() {
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'Actions') {
          return IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(row),
          );
        }

        bool isMetalRow = row.getCells().any(
                (cell) => cell.columnName == 'Item Group' && cell.value == 'Metal');
        bool isGoldRow = row.getCells().any((cell) =>
        cell.columnName == 'Item Group' && cell.value == 'Metal - Gold');
        bool isPcsColumn = dataCell.columnName == 'Pcs';

        return Container(
          alignment: Alignment.center,
          child: TextField(
            onSubmitted: (value) {
              int parsedValue = int.tryParse(value) ?? 0;
              int rowIndex = dataGridRows.indexOf(row);

              // Update the _rows list directly
              dataGridRows[rowIndex] = DataGridRow(cells: [
                for (var cell in row.getCells())
                  if (cell == dataCell)
                    DataGridCell<int>(
                      columnName: cell.columnName,
                      value: parsedValue,
                    )
                  else if (cell.columnName == "Wt")
                  // Recalculate Wt as Pcs * Avg Wt(Pcs)
                    DataGridCell<double>(
                      columnName: cell.columnName,
                      value: row
                          .getCells()
                          .firstWhere((c) => c.columnName == "Pcs")
                          .value *
                          1.0 *
                          row
                              .getCells()
                              .firstWhere((c) => c.columnName == "Avg Wt(Pcs)")
                              .value,
                    )
                  else
                    cell,
              ]);

              recalculateWt();
              onEdit();
            },
            controller: TextEditingController(
              text: dataCell.value.toString(),
            ),
            keyboardType: TextInputType.number,
            enabled: !(isGoldRow && isPcsColumn),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        );
      }).toList(),
    );
  }
}
