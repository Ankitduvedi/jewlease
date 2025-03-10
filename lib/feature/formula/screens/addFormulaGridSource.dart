import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AddFormulaDataGridSource extends DataGridSource {
  AddFormulaDataGridSource(this.dataGridRows, this.onDelete, this.onEdit,
      this.canEdit, this.onKeyBoardKeyPress,
      {this.isFromSubContracting = false});

  final List<DataGridRow> dataGridRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final bool canEdit;
  final bool isFromSubContracting;
  final Function(int, int) onKeyBoardKeyPress;

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  /// Generates a unique key for each cell
  String _generateKey(DataGridRow row, DataGridCell cell) {
    return '${dataGridRows.indexOf(row)}_${cell.columnName}';
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  /// Cleans up controllers and focus nodes when rows are out of view
  void removeUnusedControllers() {
    List<String> usedKeys = dataGridRows
        .expand((row) => row.getCells().map((cell) => _generateKey(row, cell)))
        .toList();

    // Remove controllers & focus nodes that are no longer in use
    _controllers.keys
        .where((key) => !usedKeys.contains(key))
        .toList()
        .forEach((key) {
      _controllers[key]?.dispose();
      _focusNodes[key]?.dispose();
      _controllers.remove(key);
      _focusNodes.remove(key);
    });
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        String key = _generateKey(row, dataCell);

        // Create controllers only when needed
        _controllers.putIfAbsent(
            key,
            () =>
                TextEditingController(text: dataCell.value?.toString() ?? ''));
        _focusNodes.putIfAbsent(key, () => FocusNode());

        return Container(
          alignment: Alignment.center,
          child: TextField(
            controller: _controllers[key],
            focusNode: _focusNodes[key],
            onChanged: (value) {
              int rowIndex = dataGridRows.indexOf(row);
              dataGridRows[rowIndex] = DataGridRow(cells: [
                for (var cell in row.getCells())
                  if (cell == dataCell)
                    DataGridCell<String>(
                      columnName: cell.columnName,
                      value: value,
                    )
                  else
                    cell,
              ]);

              notifyListeners(); // Refresh UI
            },
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
