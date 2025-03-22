// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../../widgets/data_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../procument/screens/procumentBomGridSource.dart';
import '../controller/bom_controller.dart';

class MyDataGrid extends ConsumerStatefulWidget {
  const MyDataGrid({super.key});

  @override
  ConsumerState<MyDataGrid> createState() => _MyDataGridState();
}

class _MyDataGridState extends ConsumerState<MyDataGrid> {
  final DataGridController _dataGridController = DataGridController();
  final DataGridController _dataGridController2 = DataGridController();
  List<DataGridRow> _rows = [];
  final List<DataGridRow> _rows2 = [];
  late procumentBomGridSource _dataGridSource;

  late OperationGridSource _dataGridSource2;

  List<String> bomColumn = [
    'Variant Name',
    'Item Group',
    'Pieces',
    'Weight',
    'Rate',
    'Avg Wt(Pcs)',
    'Amount',
    'Sp Char',
    'Operation',
    'Type',
    'Actions'
  ];

  List<String> oprColumns = [
    'Calc Bom',
    'Operation',
    'Calc Qty',
    'Type',
    'Calc Method',
    'Calc Method Value',
    'Depd Method',
    'Depd Method Value',
    'Depd Type',
    'Depd Qty'
  ];

  @override
  void initState() {
    super.initState();
    _initializeRows();
    _dataGridSource = procumentBomGridSource(
        _rows, _removeRow, _updateBomSummaryRow, (String, int) {}, true, ref);
    _dataGridSource2 =
        OperationGridSource(_rows2, _removeRow, onEditOperation, context);
    _dataGridController2.addListener(() {
      log('Current cell: ${_dataGridController2.currentCell?.rowIndex}, ${_dataGridController2.currentCell?.columnIndex}');
    });
  }

  void onEditOperation() {
    _updateOperationSummaryRow();
    setState(() {});
  }

  void _addNewRowWithItemGroup(String variantName, String itemGroup) {
    setState(() {
      _rows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Variant Name', value: variantName),
          DataGridCell<String>(columnName: 'Item Group', value: itemGroup),
          DataGridCell<int>(
              columnName: 'Pieces', value: itemGroup.contains("Stone") ? 1 : 0),
          const DataGridCell<double>(columnName: 'Weight', value: 0.0),
          const DataGridCell(columnName: 'Rate', value: 0.0),
          const DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
          const DataGridCell(columnName: 'Amount', value: 0.0),
          const DataGridCell<String>(columnName: 'Sp Char', value: ''),
          const DataGridCell<String>(columnName: 'Operation', value: ''),
          const DataGridCell<String>(columnName: 'Type', value: ''),
          const DataGridCell<Widget>(columnName: 'Actions', value: null),
        ]),
      );
      _dataGridSource.updateDataGridSource();
      _dataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  void _addNewRowWithOperation(String operation) {
    setState(() {
      _rows2.add(
        DataGridRow(cells: [
          const DataGridCell<String>(
              columnName: 'Calc Bom', value: 'New Variant'),
          DataGridCell<String>(columnName: 'Operation', value: operation),
          const DataGridCell<int>(columnName: 'Calc Qty', value: 0),
          const DataGridCell<double>(columnName: 'Type', value: 0.0),
          const DataGridCell<double>(columnName: 'Calc Method', value: 0.0),
          const DataGridCell<String>(
              columnName: 'Calc Method Value', value: ''),
          const DataGridCell<String>(columnName: 'Depd Method', value: ''),
          const DataGridCell<String>(
              columnName: 'Depd Method Value', value: ''),
          const DataGridCell<Widget>(columnName: 'Depd Type', value: null),
          const DataGridCell<Widget>(columnName: 'Depd Qty', value: null),
        ]),
      );
      _updateOperationSummaryRow();
    });
  }

  void _initializeRows() {
    _rows = [
      // Summary row
      const DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: 'New Variant'),
        DataGridCell<String>(columnName: 'Item Group', value: 'STYLE'),
        DataGridCell<int>(columnName: 'Pieces', value: 0),
        DataGridCell<double>(columnName: 'Weight', value: 0.0),
        const DataGridCell(columnName: 'Rate', value: 0.0),
        const DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
        const DataGridCell(columnName: 'Amount', value: 0.0),
        DataGridCell<String>(columnName: 'Sp Char', value: ''),
        DataGridCell<String>(columnName: 'Operation', value: ''),
        DataGridCell<String>(columnName: 'Type', value: ''),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]),
    ];
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _rows.remove(row);
      _dataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  void _updateOperationSummaryRow() {
    final oprNotifier = ref.read(OperationProvider.notifier);

    final List<String> headers = [
      'Calc Bom',
      'Operation',
      'Calc Qty',
      'Type',
      'Calc Method',
      'Calc Method Value',
      'Depd Method',
      'Depd Method Value',
      'Depd Type',
    ];
    final List<List<dynamic>> operationExcel = [];
    for (int i = 0; i < _rows2.length; i++) {
      final List<dynamic> row = [];
      for (int j = 0; j < headers.length; j++) {
        row.add(_rows2[i].getCells()[j].value);
      }
      operationExcel.add(row);
    }
    Map<String, dynamic> operationMap = {
      "Headers": headers,
      "data": operationExcel
    };

    oprNotifier.store(operationMap);
    oprNotifier.update(operationMap);
    log('operationMap: ${oprNotifier.fetch()}');
  }

  void _updateBomSummaryRow() {
    int totalPcs = 0;
    double totalWt = 0.0;
    double totalRate = 0.0;
    double totalAmount = 0.0;

    for (var i = 1; i < _rows.length; i++) {
      totalPcs += _rows[i].getCells()[2].value.toInt() as int;
      if (_rows[i].getCells()[1].value.contains("Stone")) {
        totalWt += (_rows[i].getCells()[3].value * 1.0 as double) * 0.2;
      } else {
        totalWt += _rows[i].getCells()[3].value * 1.0 as double;
      }
    }

    double avgWtPcs = totalPcs > 0 ? totalWt / totalPcs : 0.0;

    setState(() {
      _rows[0] = DataGridRow(cells: [
        const DataGridCell<String>(
            columnName: 'Variant Name', value: 'Summary'),
        const DataGridCell<String>(columnName: 'Item Group', value: ''),
        const DataGridCell<int>(columnName: 'Pieces', value: 1),
        DataGridCell<double>(columnName: 'Weight', value: totalWt),
        DataGridCell(columnName: 'Rate', value: totalRate),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: avgWtPcs),
        DataGridCell(columnName: 'Amount', value: totalAmount),
        const DataGridCell<String>(columnName: 'Sp Char', value: ''),
        const DataGridCell<String>(columnName: 'Operation', value: ''),
        const DataGridCell<String>(columnName: 'Type', value: ''),
        const DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    });
    final bomNotifier = ref.read(bomProvider.notifier);

    final List<String> headers = [
      'Variant Name',
      'Item Group',
      'Pieces',
      'Weight',
      'Rate',
      'Avg Wt(Pcs)',
      'Amount',
      'Sp Char',
      'Operation',
      'Type'
    ];
    final List<List<dynamic>> bomExcel = [];
    for (int i = 0; i < _rows.length; i++) {
      final List<dynamic> row = [];
      for (int j = 0; j < headers.length; j++) {
        row.add(_rows[i].getCells()[j].value);
      }
      bomExcel.add(row);
    }
    Map<String, dynamic> bomReqBody = {"Headers": headers, "data": bomExcel};

    bomNotifier.store(bomReqBody);
    bomNotifier.update(bomReqBody);
    log('Bom Data1: ${bomNotifier.fetch()}');
  }

  int? _selectedRowIndex;
  String? _selectedColumnName;
  final FocusNode _focusNode = FocusNode();

  void showProcumentdialog(String endUrl, String value) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ItemDataScreen(
                title: '',
                endUrl: endUrl,
                canGo: true,
                onDoubleClick: (Map<String, dynamic> intialData) {
                  log("intial data is $intialData");
                  _addNewRowWithItemGroup(
                      intialData["Metal Variant Name"] ??
                          intialData["Stone Variant Name"] ??
                          intialData["OPERATION_NAME"] ??
                          "",
                      value);
                  Navigator.pop(context);
                  _updateBomSummaryRow();
                },
              ),
            ));
  }

  bool _contains(String input, String part) {
    return input.toLowerCase().contains(part.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth =
        screenWidth * 0.6; // Set grid width to 50% of screen width

    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.4,
              margin: const EdgeInsets.only(top: 80, left: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 4), // Offset only on the bottom
                  ),
                ],
              ),
              // height: screenHeight * 0.5,
              width: screenWidth * 0.65,
              child: Column(
                children: [
                  // Header Row

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'BOM',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: ItemDataScreen(
                                            title: '',
                                            endUrl: 'Global/operations/',
                                            canGo: true,
                                            onDoubleClick: (Map<String, dynamic>
                                                intialData) {
                                              log("intial data is: $intialData");
                                              _addNewRowWithOperation(
                                                  intialData[
                                                          "OPERATION_NAME"] ??
                                                      "");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ));
                              },
                              child: const Text('+ Add Operation',
                                  style: TextStyle(color: Color(0xff28713E))),
                            ),
                            // Inside the build method, replace the "+ Add Bom" button with a PopupMenuButton:
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                // When an item is selected, add a new row with the item group
                                log("choosen Item $value");

                                if (value.contains('Gold')) {
                                  showProcumentdialog(
                                      "ItemMasterAndVariants/Metal/Gold/Variant/",
                                      value);
                                } else if (value.contains('Silver'))
                                  showProcumentdialog(
                                      "ItemMasterAndVariants/Metal/Silver/Variant/",
                                      value);
                                else if (value.contains('Diamond'))
                                  showProcumentdialog(
                                      "ItemMasterAndVariants/Stone/Diamond/Variant/",
                                      value);
                                else if (value.contains('Bronze'))
                                  showProcumentdialog(
                                      "ItemMasterAndVariants/Metal/Bronze/Variant/",
                                      value);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'Metal - Gold',
                                  child: ExpansionTile(
                                    title: const Text('Metal'),
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('Gold'),
                                        onTap: () {
                                          Navigator.pop(
                                              context, 'Metal - Gold');
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('Silver'),
                                        onTap: () {
                                          Navigator.pop(
                                              context, 'Metal - Silver');
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('Bronze'),
                                        onTap: () {
                                          Navigator.pop(
                                              context, 'Metal - Bronze');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Stone - Diamond',
                                  child: ExpansionTile(
                                    title: const Text('Stone'),
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('Diamond'),
                                        onTap: () {
                                          Navigator.pop(
                                              context, 'Stone - Diamond');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Consumables',
                                  child: ListTile(
                                    title: const Text('Consumables'),
                                    onTap: () {
                                      Navigator.pop(context, 'Consumables');
                                    },
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Packing Material',
                                  child: ListTile(
                                    title: const Text('Packing Material'),
                                    onTap: () {
                                      Navigator.pop(
                                          context, 'Packing Material');
                                    },
                                  ),
                                ),
                              ],
                              child: const TextButton(
                                onPressed: null,
                                child: Text(
                                  '+ Add Bom',
                                  style: TextStyle(color: Color(0xff28713E)),
                                ),
                              ),
                            ),

                            TextButton(
                              onPressed: () {},
                              child: const Text('Summary',
                                  style: TextStyle(color: Color(0xff28713E))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: gridWidth,
                        // Set the grid width to 50% of the screen width
                        child: SfDataGrid(
                          rowHeight: 40,
                          headerRowHeight: 40,
                          source: _dataGridSource,
                          controller: _dataGridController,
                          footerFrozenColumnsCount: 1,
                          // Freeze the last column
                          columns: bomColumn
                              .map((columnName) => GridColumn(
                                    columnName: columnName,
                                    width: gridWidth / 5,
                                    label: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF003450),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                bomColumn.indexOf(columnName) ==
                                                        0
                                                    ? 10
                                                    : 0),
                                            topRight: Radius.circular(
                                                bomColumn.indexOf(columnName) ==
                                                        bomColumn.length - 1
                                                    ? 10
                                                    : 0)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        columnName,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.4,
              margin: const EdgeInsets.only(top: 20, left: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 4), // Offset only on the bottom
                  ),
                ],
              ),
              // height: screenHeight * 0.5,
              width: screenWidth * 0.65,
              child: Column(
                children: [
                  // Header Row

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Operation',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                          width: gridWidth,
                          // Set the grid width to 50% of the screen width
                          child: SfDataGrid(
                            rowHeight: 40,
                            headerRowHeight: 40,
                            navigationMode: GridNavigationMode.cell,
                            // Enable cell-level navigation
                            selectionMode: SelectionMode.single,
                            // Allow single cell selection
                            allowEditing: true,

                            source: _dataGridSource2,
                            controller: _dataGridController2,
                            footerFrozenColumnsCount: 1,
                            onCellTap: (details) {
                              log("device type ins${details.kind}");
                            },
                            onCellDoubleTap:
                                (DataGridCellDoubleTapDetails details) {
                              log("Column Index: ${details.rowColumnIndex.columnIndex}");
                              log("Row Index: ${details.rowColumnIndex.rowIndex}");
                              log("Column Name: ${details.column.columnName}");
                              setState(() {
                                _selectedRowIndex =
                                    details.rowColumnIndex.rowIndex;
                                _selectedColumnName = details.column.columnName;
                              });
                            },

                            // Freeze the last column
                            columns: oprColumns
                                .map((columnName) => GridColumn(
                                      columnName: columnName,
                                      width: gridWidth / 5,
                                      // Adjust column width to fit 4-5 columns
                                      label: Container(
                                        color: const Color(0xFF003450),
                                        alignment: Alignment.center,
                                        child: Text(
                                          columnName,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ))
                                .toList(),

                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDataGridSource extends DataGridSource {
  MyDataGridSource(this.dataGridRows, this.onDelete, this.onEdit)
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;

  @override
  List<DataGridRow> get rows => dataGridRows;

  // Method to recalculate all 'Weight' values
  void recalculateAmount() {
    for (int i = 1; i < dataGridRows.length; i++) {
      double wt = dataGridRows[i]
                  .getCells()
                  .where((cell) => cell.columnName == 'Weight')
                  .first
                  .value *
              1.0 ??
          0;
      double rate = dataGridRows[i]
                  .getCells()
                  .where((cell) => cell.columnName == 'Rate')
                  .first
                  .value *
              1.0 ??
          0;
      int pieces = math.max(
          dataGridRows[i]
                  .getCells()
                  .where((cell) => cell.columnName == 'Pieces')
                  .first
                  .value
                  .toInt() ??
              1,
          1);
      print("amount1 ${rate * wt * pieces}");
      dataGridRows[i] = DataGridRow(
          cells: dataGridRows[i].getCells().map((cell) {
        if (cell.columnName == 'Amount')
          return DataGridCell(
              columnName: cell.columnName, value: rate * wt * pieces);
        else
          return cell;
      }).toList());
    }
  }

  void recalculateWt() {
    for (int rowIndex = 0; rowIndex < dataGridRows.length; rowIndex++) {
      final row = dataGridRows[rowIndex];
      int pcsValue =
          row.getCells().firstWhere((c) => c.columnName == "Pieces").value ?? 0;
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
          row.getCells().firstWhere((c) => c.columnName == "Weight").value *
                  1.0 ??
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
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(row),
          );
        }

        bool isMetalRow = row.getCells().any(
            (cell) => cell.columnName == 'Item Group' && cell.value == 'Metal');
        bool isGoldRow = row.getCells().any((cell) =>
            cell.columnName == 'Item Group' && cell.value == 'Metal - Gold');
        bool isPcsColumn = dataCell.columnName == 'Pieces';

        return Container(
          alignment: Alignment.center,
          child: TextField(
            onSubmitted: (value) {
              double parsedValue = double.tryParse(value) ?? 0;
              int rowIndex = dataGridRows.indexOf(row);
              bool isDiamond = dataGridRows[rowIndex]
                  .getCells()[1]
                  .value
                  .contains("Diamond");
              print("is diamond $isDiamond $rowIndex");
              // if (isDiamond && dataCell.columnName == 'Weight')
              //   parsedValue = parsedValue * 0.2;

              // Update the _rows list directly
              dataGridRows[rowIndex] = DataGridRow(cells: [
                for (var cell in row.getCells())
                  if (cell.columnName == dataCell.columnName)
                    DataGridCell(
                        columnName: cell.columnName, value: parsedValue)
                  else
                    cell
              ]);

              for (var cell in dataGridRows[rowIndex].getCells())
                print("cell name ${cell.columnName} value ${cell.value}");

              recalculateWt();
              recalculateAmount();
              onEdit();
            },
            controller: TextEditingController(
              text: dataCell.value.toString(),
            ),
            keyboardType: TextInputType.number,
            enabled: !(isGoldRow && isPcsColumn),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class OperationGridSource extends DataGridSource {
  OperationGridSource(
      this.dataGridRows, this.onDelete, this.onEdit, this.context)
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final BuildContext context;

  @override
  List<DataGridRow> get rows => dataGridRows;

  // Method to recalculate all 'Weight' values
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
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(row),
          );
        }

        bool isMetalRow = row.getCells().any(
            (cell) => cell.columnName == 'Item Group' && cell.value == 'Metal');
        bool isGoldRow = row.getCells().any((cell) =>
            cell.columnName == 'Item Group' && cell.value == 'Metal - Gold');
        bool isPcsColumn = dataCell.columnName == 'Pieces';

        return RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (RawKeyEvent event) {
              if (event is RawKeyDownEvent) {
                bool isAltPressed = event.isAltPressed;
                bool isOKeyPressed =
                    event.logicalKey == LogicalKeyboardKey.keyO;

                if (isAltPressed && isOKeyPressed) {
                  if (dataCell.columnName == 'Type') {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'Type',
                        endUrl: 'Global/Type',
                        value: 'Config Id',
                        onSelectdRow: (selectedRow) {
                          print('selected row  is $selectedRow');
                          int rowIndex = dataGridRows.indexOf(row);
                          print(
                              "row index is $rowIndex ${selectedRow['Config value']}");
                          rows[rowIndex] = DataGridRow(cells: [
                            for (var cell in row.getCells())
                              if (cell.columnName == 'Type')
                                DataGridCell<String>(
                                  columnName: cell.columnName,
                                  value: selectedRow['Config value'],
                                )
                              else
                                cell,
                          ]);
                          onEdit();
                        },
                        onOptionSelectd: (selectedValue) {},
                      ),
                    );
                  } else if (dataCell.columnName == 'Calc Method') {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'Calc Method',
                        endUrl: 'Global/CalcMethod',
                        value: 'Config Id',
                        onSelectdRow: (selectedRow) {
                          print('selected row  is $selectedRow');
                          int rowIndex = dataGridRows.indexOf(row);
                          print(
                              "row index is $rowIndex ${selectedRow['Config value']}");
                          rows[rowIndex] = DataGridRow(cells: [
                            for (var cell in row.getCells())
                              if (cell.columnName == 'Calc Method')
                                DataGridCell<String>(
                                  columnName: cell.columnName,
                                  value: selectedRow['Config value'],
                                )
                              else
                                cell,
                          ]);
                          onEdit();
                        },
                        onOptionSelectd: (selectedValue) {},
                      ),
                    );
                  } else if (dataCell.columnName == 'Calc Method Value') {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'Calc Method Value',
                        endUrl: 'Global/CalcMethodValue',
                        value: 'Config Id',
                        onSelectdRow: (selectedRow) {
                          print('selected row  is $selectedRow');
                          int rowIndex = dataGridRows.indexOf(row);
                          print(
                              "row index is $rowIndex ${selectedRow['Config value']}");
                          rows[rowIndex] = DataGridRow(cells: [
                            for (var cell in row.getCells())
                              if (cell.columnName == 'Calc Method Value')
                                DataGridCell<String>(
                                  columnName: cell.columnName,
                                  value: selectedRow['Config value'],
                                )
                              else
                                cell,
                          ]);
                          onEdit();
                        },
                        onOptionSelectd: (selectedValue) {},
                      ),
                    );
                  } else if (dataCell.columnName == 'Depd Method') {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'Depd Methd',
                        endUrl: 'Global/DepdMethod',
                        value: 'Config Id',
                        onSelectdRow: (selectedRow) {
                          print('selected row  is $selectedRow');
                          int rowIndex = dataGridRows.indexOf(row);
                          print(
                              "row index is $rowIndex ${selectedRow['Config value']}");
                          rows[rowIndex] = DataGridRow(cells: [
                            for (var cell in row.getCells())
                              if (cell.columnName == 'Depd Method')
                                DataGridCell<String>(
                                  columnName: cell.columnName,
                                  value: selectedRow['Config value'],
                                )
                              else
                                cell,
                          ]);
                          onEdit();
                        },
                        onOptionSelectd: (selectedValue) {},
                      ),
                    );
                  }

                  log("column name is ${dataCell.columnName}");
                }
              }
            },
            child: Container(
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
                                  .firstWhere(
                                      (c) => c.columnName == "Avg Wt(Pcs)")
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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ));
      }).toList(),
    );
  }
}
