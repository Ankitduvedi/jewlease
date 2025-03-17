import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/search_dailog_widget.dart';

class procumentBomGridSource extends DataGridSource {
  procumentBomGridSource(this.dataGridRows, this.onDelete, this.onEdit,
      this.showFormulaDialog, this.canEdit)
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final Function(String, int) showFormulaDialog;
  bool canEdit;

  @override
  List<DataGridRow> get rows => dataGridRows;

  // Method to recalculate all 'Wt' values
  void recalculateWt() {
    for (int rowIndex = 1; rowIndex < dataGridRows.length; rowIndex++) {
      DataGridRow row = dataGridRows[rowIndex];
      var x = row.getCells().firstWhere((c) => c.columnName == "Weight").value;
      var y = row.getCells().firstWhere((c) => c.columnName == "Pieces").value;
      var z =
          row.getCells().firstWhere((c) => c.columnName == "Avg Wt(Pcs)").value;
      print("recalculate wt index $rowIndex $y $x $z");
      int pcsValue = row
              .getCells()
              .firstWhere((c) => c.columnName == "Pieces")
              .value
              .toInt() ??
          0;
      String groupName = row
          .getCells()
          .firstWhere((c) => c.columnName == "Item Group")
          .value as String;
      pcsValue += groupName.contains('Gold') == true ? 1 : 0;
      double avgWtValue = row
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
            else if (cell.columnName == "Weight")
              DataGridCell<double>(
                columnName: cell.columnName,
                value: Wt * (pcsValue == 0 ? 1 : pcsValue),
              )
            else
              cell,
        ]);
      } else if (avgWtValue != 0) {
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
      row = dataGridRows[rowIndex];
      x = row.getCells().firstWhere((c) => c.columnName == "Weight").value;
      y = row.getCells().firstWhere((c) => c.columnName == "Pieces").value;
      z = row.getCells().firstWhere((c) => c.columnName == "Avg Wt(Pcs)").value;
      print("recalculate wt index1 $rowIndex $x $y $z");
    }
  }

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
      int pieces = max(
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
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(row),
          );
        }

        bool isMetalRow = row.getCells().any(
            (cell) => cell.columnName == 'Item Group' && cell.value == 'Metal');
        bool isGoldRow = row.getCells().any((cell) =>
            cell.columnName == 'Item Group' && cell.value == 'Metal - Gold');
        bool isPcsColumn = dataCell.columnName == 'Pieces';

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
                                  child: Text('Show Formula'),
                                  onTap: () {
                                    showFormulaDialog(itemGroup, rowIndex);
                                  },
                                ),
                                PopupMenuItem(
                                  value: 'Show Operation',
                                  child: Text('Show Operation'),
                                  onTap: () {
                                    showFormulaDialog(itemGroup, rowIndex);
                                  },
                                ),
                              ],
                            );
                          },
                          child: Icon(Icons.more_vert)),
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          double parsedValue = double.tryParse(value) ?? 0;
                          int rowIndex = dataGridRows.indexOf(row);
                          bool isDiamond = dataGridRows[rowIndex]
                              .getCells()[1]
                              .value
                              .contains("Diamond");
                          print("is diamond $isDiamond $rowIndex");
                          if (isDiamond && dataCell.columnName == 'Weight')
                            parsedValue = parsedValue * 0.2;

                          // Update the _rows list directly
                          dataGridRows[rowIndex] = DataGridRow(cells: [
                            for (var cell in row.getCells())
                              if (cell.columnName == dataCell.columnName)
                                DataGridCell(
                                    columnName: cell.columnName,
                                    value: parsedValue)
                              else
                                cell
                          ]);

                          for(var cell in dataGridRows[rowIndex].getCells())
                            print("cell name ${cell.columnName} value ${cell.value}");

                          recalculateWt();
                          recalculateAmount();
                          onEdit();
                        },
                        controller: TextEditingController(
                          text: dataCell.value.toString(),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: canEdit ? !(isGoldRow && isPcsColumn) : false,
                        decoration: InputDecoration(
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
