// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/utils/utils.dart';
import '../../../widgets/search_dailog_widget.dart';


class procumentBomGridSource extends DataGridSource {
  procumentBomGridSource(this.dataGridRows, this.onDelete, this.onEdit,
      this.showFormulaDialog, this.canEdit, this.ref)
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final Function(String, int) showFormulaDialog;
  final WidgetRef ref;
  bool canEdit;

  @override
  List<DataGridRow> get rows => dataGridRows;

  DataGridRow recalulateWt(DataGridRow row) {
    double wt = row.getCells()[3].value as double;
    double pieces = max(row.getCells()[2].value * 1.0 as double,1) ;
    double rate = row.getCells()[4].value * 1.0 as double;
    return DataGridRow(
        cells: row.getCells().map((cell) {
      if (cell.columnName == "Avg Wt(Pcs)") {
        return DataGridCell<double>(
            columnName: cell.columnName, value: wt / pieces);
      } else if (cell.columnName == "Amount") {
        return DataGridCell<double>(
            columnName: cell.columnName, value: wt * rate);
      } else
        return cell;
    }).toList());
  }

  DataGridRow recalculateRate(DataGridRow row) {
    double wt = row.getCells()[3].value as double;
    double rate = row.getCells()[4].value as double;
    print("rate->$rate weight->$wt");
    return DataGridRow(
        cells: row.getCells().map((cell) {
      if (cell.columnName == "Amount") {
        return DataGridCell<double>(
            columnName: cell.columnName, value: rate * wt);
      } else {
        return cell;
      }
    }).toList());
  }

  DataGridRow recalculatePieces(DataGridRow row) {
    double pieces = max(row.getCells()[2].value as double,1);
    double wt = row.getCells()[3].value as double;
    // double rate = row.getCells()[4].value as double;
    print("pieces->$pieces wt->$wt");

    return DataGridRow(
        cells: row.getCells().map((cell) {
      if (cell.columnName == "Avg Wt(Pcs)") {
        return DataGridCell<double>(
            columnName: cell.columnName, value: wt / pieces);
      } else {
        return cell;
      }
    }).toList());
  }

  void updateAllData(double oldSummeryPieces) {
    double currentPieces = dataGridRows[0].getCells()[2].value;

    List<DataGridRow> newData = [];

    for (int i = 1; i < dataGridRows.length; i++) {
      newData.add(DataGridRow(
          cells: dataGridRows[i].getCells().map((cell) {
        if (cell.columnName == "Pieces") {
          return DataGridCell<double>(
              columnName: cell.columnName,
              value: (cell.value / oldSummeryPieces) * currentPieces);
        } else if (cell.columnName == "Weight")
          return DataGridCell<double>(
              columnName: cell.columnName,
              value: (cell.value / oldSummeryPieces) * currentPieces);
        else if (cell.columnName == "Amount")
          return DataGridCell<double>(
              columnName: cell.columnName,
              value: (cell.value / oldSummeryPieces) * currentPieces);
        return cell;
      }).toList()));
    }
    for (int i = 0; i < newData.length; i++) {
      dataGridRows[i + 1] = newData[i];
    }
  }

  // Method to recalculate all 'Wt' values
  void recalculate(int rowIndex, int editatedCol, double lastSummeryPieces) {
    if (rowIndex == 0) {
      updateAllData(lastSummeryPieces);
    } else {
      DataGridRow row = dataGridRows[rowIndex];
      if (editatedCol == 2) {
        dataGridRows[rowIndex] = recalculatePieces(row);
      } else if (editatedCol == 3) {
        dataGridRows[rowIndex] = recalulateWt(row);
      } else if (editatedCol == 4) {
        dataGridRows[rowIndex] = recalculateRate(row);
      }
      row = dataGridRows[rowIndex];
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
    int rowIndex = dataGridRows.indexOf(row);
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'Actions') {
          return IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(row),
          );
        }

        bool isMetalRow = row.getCells().any((cell) =>
            cell.columnName == 'Item Group' && cell.value.contains("Metal"));
        bool isGoldRow = row.getCells().any((cell) =>
            cell.columnName == 'Item Group' && cell.value == 'Metal - Gold');
        bool isPcsColumn = dataCell.columnName == 'Pieces';
        bool noneditableCell = dataCell.columnName == "Amount" ||
            dataCell.columnName == "Avg Wt(Pcs)" ||
            isMetalRow && isPcsColumn;

        return Builder(builder: (context) {
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
                          onOptionSelectd: (selectedValue) {},
                        ),
                      );
                    }
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dataCell.columnName == 'Variant Name')
                      GestureDetector(
                          onTapDown: (pos) {
                            String itemGroup = row
                                .getCells()
                                .where(
                                    (cell) => cell.columnName == 'Item Group')
                                .first
                                .value;
                            print("item Group is $itemGroup");
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
                                    showFormulaDialog("Show Formula", rowIndex);
                                  },
                                ),
                                PopupMenuItem(
                                  value: 'Show Operation',
                                  child: const Text('Show Operation'),
                                  onTap: () {
                                    showFormulaDialog("Show Operation", rowIndex);
                                  },
                                ),
                              ],
                            );
                          },
                          child: const Icon(Icons.more_vert)),
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          double parsedValue = double.tryParse(value) ?? 0.0;
                          int rowIndex = dataGridRows.indexOf(row);
                          print("range is $rowIndex");
                          int cellIndex = dataGridRows[rowIndex]
                              .getCells()
                              .indexOf(dataCell);

                          // if(cellIndex==4) {
                          //   Utils.snackBar("Rate can be changed by formula", context);
                          //   return;
                          // }

                          double lastSummerryPieces =
                              dataGridRows[0].getCells()[2].value;
                          dataGridRows[rowIndex] = DataGridRow(cells: [
                            for (var cell in row.getCells())
                              if (cell.columnName == dataCell.columnName)
                                DataGridCell(
                                    columnName: cell.columnName,
                                    value: parsedValue)
                              else
                                cell
                          ]);
                          recalculate(rowIndex, cellIndex, lastSummerryPieces);
                          onEdit();
                        },
                        controller: TextEditingController(
                          text: dataCell.value.toString(),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: canEdit
                            ? (noneditableCell == true ? false : true)
                            : false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
      }).toList(),
    );
  }
}
