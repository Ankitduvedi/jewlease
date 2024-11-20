import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../main.dart';
import '../../widgets/data_widget.dart';
import 'formulaGrid.dart';

class procumentBomGridDialog extends StatefulWidget {
  @override
  _procumentGridState createState() => _procumentGridState();
}

class _procumentGridState extends State<procumentBomGridDialog> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _rows = [];
  List<DataGridRow> _rows2 = [];
  late procumentGridSource _dataGridSource;

  late procumentGridSource _dataGridSource2;

  @override
  void initState() {
    super.initState();
    _initializeRows();
    _dataGridSource = procumentGridSource(_rows, _removeRow, _updateSummaryRow);
    _dataGridSource2 =
        procumentGridSource(_rows2, _removeRow, _updateSummaryRow);
  }

  void _addNewRowWithItemGroup(String variantName, String itemGroup) {
    setState(() {
      _rows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Variant Name', value: variantName),
          DataGridCell<String>(columnName: 'Item Group', value: itemGroup),
          DataGridCell<int>(columnName: 'Pcs', value: 0),
          DataGridCell<double>(columnName: 'Wt', value: 0.0),
          DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
          DataGridCell<String>(columnName: 'Sp Char', value: ''),
          DataGridCell<String>(columnName: 'Operation', value: ''),
          DataGridCell<String>(columnName: 'Type', value: ''),
          DataGridCell<Widget>(columnName: 'Actions', value: null),
        ]),
      );
      _dataGridSource.updateDataGridSource();
      _dataGridSource.updateDataGridSource();
      _updateSummaryRow();
    });
  }

  void _addNewRowWithOperation(String operation) {
    setState(() {
      _rows2.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Calc Bom', value: 'New Variant'),
          DataGridCell<String>(columnName: 'Operation', value: operation),
          DataGridCell<int>(columnName: 'Calc Qty', value: 0),
          DataGridCell<double>(columnName: 'Type', value: 0.0),
          DataGridCell<double>(columnName: 'Calc Method', value: 0.0),
          DataGridCell<String>(columnName: 'Calc Method Value', value: ''),
          DataGridCell<String>(columnName: 'Depd Method', value: ''),
          DataGridCell<String>(columnName: 'Depd Method Value', value: ''),
          DataGridCell<Widget>(columnName: 'Depd Type', value: null),
          DataGridCell<Widget>(columnName: 'Depd Qty', value: null),
        ]),
      );
      _dataGridSource.updateDataGridSource();
      _dataGridSource.updateDataGridSource();
      _updateSummaryRow();
    });
  }

  void _initializeRows() {
    _rows = [
      // Summary row
      DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: 'New Variant'),
        DataGridCell<String>(columnName: 'Item Group', value: 'STYLE'),
        DataGridCell<int>(columnName: 'Pcs', value: 0),
        DataGridCell<double>(columnName: 'Wt', value: 0.0),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
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
        DataGridCell<String>(columnName: 'Variant Name', value: 'Summary'),
        DataGridCell<String>(columnName: 'Item Group', value: ''),
        DataGridCell<int>(columnName: 'Pcs', value: totalPcs),
        DataGridCell<double>(columnName: 'Wt', value: totalWt),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: avgWtPcs),
        DataGridCell<String>(columnName: 'Sp Char', value: ''),
        DataGridCell<String>(columnName: 'Operation', value: ''),
        DataGridCell<String>(columnName: 'Type', value: ''),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    print("widht ${screenWidth} ${screenWidth * 0.5}");

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: screenWidth * 0.45,
            height: screenHeight * 0.4,
            margin: EdgeInsets.only(top: 20, left: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            // height: screenHeight * 0.5,
            // width: screenWidth * 0.,
            child: Column(
              children: [
                // Header Row

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bom',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                                            print("intial data is $intialData");
                                            _addNewRowWithOperation(
                                                intialData["OPERATION_NAME"] ??
                                                    "");
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ));
                            },
                            child: Text('+ Add Operation',
                                style: TextStyle(color: Color(0xff28713E))),
                          ),
                          // Inside the build method, replace the "+ Add Bom" button with a PopupMenuButton:
                          PopupMenuButton<String>(
                            onSelected: (String value) {
                              // When an item is selected, add a new row with the item group
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: ItemDataScreen(
                                          title: '',
                                          endUrl: 'Global/operations/',
                                          canGo: true,
                                          onDoubleClick: (Map<String, dynamic>
                                              intialData) {
                                            print("intial data is $intialData");
                                            _addNewRowWithItemGroup(
                                                intialData["OPERATION_NAME"] ??
                                                    "",
                                                value);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ));
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'Metal - Gold',
                                child: ExpansionTile(
                                  title: Text('Metal'),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Gold'),
                                      onTap: () {
                                        Navigator.pop(context, 'Metal - Gold');
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Silver'),
                                      onTap: () {
                                        Navigator.pop(
                                            context, 'Metal - Silver');
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Bronze'),
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
                                  title: Text('Stone'),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Diamond'),
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
                                  title: Text('Consumables'),
                                  onTap: () {
                                    Navigator.pop(context, 'Consumables');
                                  },
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Packing Material',
                                child: ListTile(
                                  title: Text('Packing Material'),
                                  onTap: () {
                                    Navigator.pop(context, 'Packing Material');
                                  },
                                ),
                              ),
                            ],
                            child: TextButton(
                              onPressed: null,
                              child: Text(
                                '+ Add Bom',
                                style: TextStyle(color: Color(0xff28713E)),
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {},
                            child: Text('Summary',
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
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust this for desired roundness
                        child: Container(
                            width: screenWidth * 0.42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.fromBorderSide(
                                  BorderSide(color: Colors.grey)),
                            ),
                            child: SfDataGrid(
                              rowHeight: 40,
                              headerRowHeight: 40,
                              source: _dataGridSource,
                              controller: _dataGridController,
                              footerFrozenColumnsCount: 1,
                              // Freeze the last column
                              columns: <GridColumn>[
                                GridColumn(
                                  columnName: 'Variant Name',
                                  width: gridWidth / 5,
                                  // Adjust column width to fit 4-5 columns
                                  label: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFF003450),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10))),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Variant Name',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Item Group',
                                  width: gridWidth / 5,
                                  label: Container(
                                    color: Color(0xFF003450),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Item Group',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Pcs',
                                  width: gridWidth / 5,
                                  label: Container(
                                    color: Color(0xFF003450),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Pcs',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Wt',
                                  width: gridWidth / 5,
                                  label: Container(
                                    color: Color(0xFF003450),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Wt',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Avg Wt(Pcs)',
                                  width: gridWidth / 5,
                                  label: Container(
                                    color: Color(0xFF003450),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Avg Wt(Pcs)',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Sp Char',
                                  width: gridWidth / 5,
                                  label: Container(
                                    color: Color(0xFF003450),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Sp Char',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Operation',
                                  width: gridWidth / 5,
                                  label: Container(
                                    color: Color(0xFF003450),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Operation',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Type',
                                  width: gridWidth / 5,
                                  label: Container(
                                    color: Color(0xFF003450),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Type',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Actions',
                                  width: gridWidth / 5,
                                  label: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFF003450),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10))),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                            ))),
                  ),
                ),
              ],
            ),
          ),
          FormulaDataGrid()
          // Container(
          //   width: screenWidth * 0.45,
          //   height: screenHeight * 0.4,
          //   margin: EdgeInsets.only(top: 20, left: 20),
          //   padding: EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //     // color: Colors.red,
          //   ),
          //   // height: screenHeight * 0.5,
          //   // width: screenWidth * 0.65,
          //   child: Column(
          //     children: [
          //       // Header Row
          //
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'Operation',
          //               style:
          //                   TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Expanded(
          //         child: SingleChildScrollView(
          //           scrollDirection: Axis.horizontal,
          //           child: ClipRRect(
          //               borderRadius: BorderRadius.circular(
          //                   10), // Adjust this for desired roundness
          //               child: Container(
          //                 width: screenWidth * 0.42,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(10),
          //                   border: Border.fromBorderSide(
          //                       BorderSide(color: Colors.grey)),
          //                 ),
          //                 // Set the grid width to 50% of the screen width
          //                 child: SfDataGrid(
          //                   rowHeight: 40,
          //                   headerRowHeight: 40,
          //                   source: _dataGridSource2,
          //                   controller: _dataGridController,
          //                   footerFrozenColumnsCount: 1,
          //                   // Freeze the last column
          //                   columns: <GridColumn>[
          //                     GridColumn(
          //                       columnName: 'Calc Bom',
          //                       width: gridWidth /
          //                           5, // Adjust column width to fit 4-5 columns
          //                       label: Container(
          //                         decoration: BoxDecoration(
          //                             color: Color(0xFF003450),
          //                             borderRadius: BorderRadius.only(
          //                                 topLeft: Radius.circular(10))),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Calc Bom',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Operation',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Operation',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Calc Qty',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Calc Qty',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Type',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Type',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Calc Method',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Calc Method',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Calc Method Value',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Calc Method Value',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Depd Method',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Depd Method',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Depd Method Vale',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Depd Method Value',
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Depd Type',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         color: Color(0xFF003450),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Depd Type',
          //                           style: TextStyle(color: Colors.white),
          //                         ),
          //                       ),
          //                     ),
          //                     GridColumn(
          //                       columnName: 'Depd Qty',
          //                       width: gridWidth / 5,
          //                       label: Container(
          //                         decoration: BoxDecoration(
          //                             color: Color(0xFF003450),
          //                             borderRadius: BorderRadius.only(
          //                                 topRight: Radius.circular(10))),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           'Depd Qty',
          //                           style: TextStyle(color: Colors.white),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                   gridLinesVisibility: GridLinesVisibility.both,
          //                   headerGridLinesVisibility: GridLinesVisibility.both,
          //                 ),
          //               )),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class procumentGridSource extends DataGridSource {
  procumentGridSource(this.dataGridRows, this.onDelete, this.onEdit)
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
