// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/search_dailog_widget.dart';

class procumentOperationGridSource extends DataGridSource {
  procumentOperationGridSource(this.dataGridRows, this.onDelete, this.onEdit,
      this.showFormulaDialog, this.canEdit, this.ref)
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function(double,int) onEdit;
  final Function(String, int) showFormulaDialog;
  final WidgetRef ref;
  bool canEdit;

  @override
  List<DataGridRow> get rows => dataGridRows;

  double updateAmount(int updatedIndex) {
    double rate = dataGridRows[updatedIndex].getCells().firstWhere((cell)=>cell.columnName=="Rate").value;
    double qty =dataGridRows[updatedIndex].getCells().firstWhere((cell)=>cell.columnName=="Calc Qty").value;
    dataGridRows[updatedIndex] = DataGridRow(
      cells: dataGridRows[updatedIndex].getCells().map((cell) {
        return cell.columnName == "Amount"
            ? DataGridCell(columnName: cell.columnName, value: rate*qty)
            : cell;
      }).toList(),
    );

    final totalAmount = dataGridRows
        .expand((row) => row.getCells())
        .where((cell) => cell.columnName == "Amount")
        .fold<double>(0, (sum, cell) => sum + (cell.value as num).toDouble());
    return totalAmount;
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
        bool isEditableCell = dataCell.columnName == "Rate";

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
                                    showFormulaDialog(itemGroup, rowIndex);
                                  },
                                ),
                                PopupMenuItem(
                                  value: 'Show Operation',
                                  child: const Text('Show Operation'),
                                  onTap: () {
                                    showFormulaDialog(itemGroup, rowIndex);
                                  },
                                ),
                              ],
                            );
                          },
                          child: const Icon(Icons.more_vert)),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onSubmitted: (value) {
                          double updatedValue = double.parse(value);
                          dataGridRows[rowIndex] = DataGridRow(
                            cells:
                                dataGridRows[rowIndex].getCells().map((cell) {
                              return cell.columnName == dataCell.columnName
                                  ? DataGridCell(
                                      columnName: cell.columnName,
                                      value: updatedValue)
                                  : cell;
                            }).toList(),
                          );

                          double totalAmount= updateAmount(rowIndex);
                          onEdit(totalAmount,rowIndex);
                        },
                        controller: TextEditingController(
                          text: dataCell.value.toString(),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: canEdit
                            ? (isEditableCell == true ? true : false)
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
