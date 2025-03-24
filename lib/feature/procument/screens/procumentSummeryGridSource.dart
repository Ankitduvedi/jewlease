import 'package:flutter/material.dart';
import 'package:jewlease/feature/procument/screens/procumentBomOprDialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcumentDataGridSource extends DataGridSource {
  final List<DataGridRow> _dataGridRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final bool canEdit;
  final bool isFromSubContracting;

  ProcumentDataGridSource(
    this._dataGridRows,
    this.onDelete,
    this.onEdit,
    this.canEdit, {
    this.isFromSubContracting = false,
  });

  @override
  List<DataGridRow> get rows => _dataGridRows;

  // Optimized method to recalculate values
  void recalculateWt(int updateRowIndex) {
    final row = _dataGridRows[updateRowIndex];
    final cells = row.getCells();

    final pieces = _parseNumeric(
        cells.firstWhere((cell) => cell.columnName == 'Pieces').value);
    final weight = _parseNumeric(
        cells.firstWhere((cell) => cell.columnName == 'Weight').value);
    final rate = _parseNumeric(
        cells.firstWhere((cell) => cell.columnName == 'Rate').value);
    final stnWt = double.parse(
        cells.firstWhere((cell) => cell.columnName == 'Stone Wt').value);

    _dataGridRows[updateRowIndex] = DataGridRow(
      cells: cells.map((cell) {
        switch (cell.columnName) {
          case 'Amount':
            return DataGridCell(
                columnName: 'Amount', value: pieces * weight * rate);
          case 'Weight':
            return DataGridCell(columnName: 'Weight', value: pieces * weight);
          case 'Stone Wt':
            return DataGridCell(columnName: 'Stone Wt', value: pieces * stnWt);
          default:
            return cell;
        }
      }).toList(),
    );
  }

  // Helper method to parse numeric values consistently
  num _parseNumeric(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value.toString()) ?? 0;
  }

  // Simplified summary row calculation
  DataGridRow getSummaryRow() {
    final columnTotals = <String, double>{};

    for (final row in _dataGridRows) {
      for (final cell in row.getCells()) {
        if (cell.value is num) {
          columnTotals[cell.columnName] =
              (columnTotals[cell.columnName] ?? 0) + cell.value;
        }
      }
    }

    return DataGridRow(
      cells: columnTotals.entries
          .map((entry) =>
              DataGridCell<double>(columnName: entry.key, value: entry.value))
          .toList(),
    );
  }

  void updateDataGridSource() => notifyListeners();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        // Action column handler
        if (dataCell.columnName == 'Actions') {
          return IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(row),
          );
        }

        return _buildEditableCell(row, dataCell);
      }).toList(),
    );
  }

  Widget _buildEditableCell(DataGridRow row, DataGridCell dataCell) {
    return Builder(
      builder: (BuildContext context) {
        return InkWell(
          onDoubleTap: () => _handleDoubleTap(context, row, dataCell),
          child: Container(
            alignment: Alignment.center,
            child: TextField(
              onSubmitted: (value) => _updateCellValue(row, dataCell, value),
              controller: TextEditingController(
                text: dataCell.value.toString(),
              ),
              style: _getCellTextStyle(dataCell),
              keyboardType: TextInputType.number,
              enabled: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleDoubleTap(
      BuildContext context, DataGridRow row, DataGridCell dataCell) {
    if (dataCell.columnName == 'Variant Name') {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildVariantDialog(context, row, dataCell),
      );
    }
  }

  Dialog _buildVariantDialog(
      BuildContext context, DataGridRow row, DataGridCell dataCell) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: ProcurementBomDialog(
          variantName: dataCell.value,
          variantIndex: _dataGridRows.indexOf(row),
          canEdit: canEdit,
          isFromSubContracting: isFromSubContracting,
        ),
      ),
    );
  }

  void _updateCellValue(DataGridRow row, DataGridCell dataCell, String value) {
    int parsedValue = int.tryParse(value) ?? 0;
    int rowIndex = _dataGridRows.indexOf(row);

    _dataGridRows[rowIndex] = DataGridRow(
      cells: row
          .getCells()
          .map((cell) => cell == dataCell
              ? DataGridCell<int>(
                  columnName: cell.columnName,
                  value: parsedValue,
                )
              : cell)
          .toList(),
    );

    recalculateWt(rowIndex);
    onEdit();
  }

  TextStyle _getCellTextStyle(DataGridCell dataCell) {
    return TextStyle(
      decoration: dataCell.columnName == 'Variant Name'
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: Colors.blue.shade900,
      color: dataCell.columnName == 'Variant Name'
          ? Colors.blue.shade900
          : Colors.black,
    );
  }
}
