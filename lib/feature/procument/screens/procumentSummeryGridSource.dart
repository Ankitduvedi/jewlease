import 'package:flutter/material.dart';
import 'package:jewlease/feature/procument/screens/procumentBomOprDialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcumentDataGridSource extends DataGridSource {
  ProcumentDataGridSource(
      this.dataGridRows, this.onDelete, this.onEdit, this.canEdit,
      {this.showFormulaDialog, this.isFromSubContracting = false})
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final bool canEdit;
  final bool isFromSubContracting;
  final Function(int)? showFormulaDialog;

  @override
  List<DataGridRow> get rows => dataGridRows;

  // Method to recalculate all 'Wt' values
  void recalculateWt(int updateRowIndex) {
    var pieces = dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Pieces')
        .value;
    var weight = dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Weight')
        .value;
    var rate = dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Rate')
        .value;
    double stnWt = double.parse(dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Stone Wt')
        .value);
    print(
        'final amount is ${rate.runtimeType} ${weight.runtimeType} ${pieces.runtimeType}');
    if (pieces.runtimeType != int) {
      pieces = int.parse(pieces);
    }
    if (weight.runtimeType != int) {
      weight = int.parse(weight);
    }

    if (rate.runtimeType != int) {
      rate = int.parse(rate);
    }
    dataGridRows[updateRowIndex] = DataGridRow(
        cells: dataGridRows[updateRowIndex].getCells().map((cell) {
      if (cell.columnName == 'Amount')
        return DataGridCell(
            columnName: 'Amount',
            value: pieces.runtimeType == int
                ? pieces *
                    (weight.runtimeType == String
                        ? int.parse(weight)
                        : weight) *
                    (rate.runtimeType == String ? int.parse(rate) : rate)
                : int.parse(pieces) *
                    weight *
                    (rate.runtimeType == int ? rate : int.parse(rate)));
      else if (cell.columnName == "Weight") {
        return DataGridCell(
            columnName: cell.columnName, value: pieces * weight);
      } else if (cell.columnName == "Stone Wt") {
        return DataGridCell(columnName: cell.columnName, value: pieces * stnWt);
      }
      return cell;
    }).toList());
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
        bool isPcsColumn = dataCell.columnName == 'Pieces';

        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onDoubleTap: () {
                print("double tap");
                if (dataCell.columnName == 'Variant Name') {
                  print("duble tap ${dataCell.value}");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        alignment: Alignment.bottomCenter,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.41,
                          // 45% of screen height
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          padding: EdgeInsets.all(16),
                          child: procumentBomOprDialog(
                              dataCell.value,
                              dataGridRows.indexOf(row),
                              canEdit,
                              isFromSubContracting),
                        ),
                      );
                    },
                  );
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dataCell.columnName == 'Ref Document')
                      GestureDetector(
                          onTapDown: (pos) {
                            final RelativeRect rp = RelativeRect.fromLTRB(
                              pos.globalPosition.dx,
                              pos.globalPosition.dy,
                              pos.globalPosition.dx,
                              pos.globalPosition.dy,
                            );
                            showMenu(
                              context: context,
                              position: rp, // Adjust position as needed
                              items: [
                                PopupMenuItem(
                                  value: 'show_formula',
                                  child: const Text('Show Formula'),
                                  onTap: () {
                                    int rowIndex = dataGridRows.indexOf(row);
                                    if (showFormulaDialog != null)
                                      showFormulaDialog!(rowIndex);
                                  },
                                ),
                              ],
                            );
                          },
                          child: const Icon(Icons.more_vert)),
                    Expanded(
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
                              else
                                cell,
                          ]);

                          recalculateWt(rowIndex);
                          onEdit();
                        },
                        controller: TextEditingController(
                          text: dataCell.value.toString(),
                        ),
                        style: TextStyle(
                            decoration: dataCell.columnName == 'Variant Name'
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            decorationColor: Colors.blue.shade900,
                            color: dataCell.columnName == 'Variant Name'
                                ? Colors.blue.shade900
                                : Colors.black),
                        keyboardType: TextInputType.number,
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
