import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RangeDataGridSource extends DataGridSource {
  RangeDataGridSource(this.dataGridRows, this.onDelete, this.onEdit,
      this.canEdit, this.onKeyBoardKeyPress,
      {this.isFromSubContracting = false})
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final bool canEdit;
  final bool isFromSubContracting;
  final Function(int, int) onKeyBoardKeyPress;

  @override
  List<DataGridRow> get rows => dataGridRows;

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

        return Builder(
          builder: (BuildContext context) {
            return RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.altLeft) &&
                      event.isKeyPressed(LogicalKeyboardKey.keyO)) {
                      onKeyBoardKeyPress(
                          rows.indexOf(row), row.getCells().indexOf(dataCell));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: TextField(
                    onSubmitted: (value) {},
                    controller: TextEditingController(
                      text: dataCell.value.toString(),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ));
          },
        );
      }).toList(),
    );
  }
}
