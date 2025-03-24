import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProcurementBomGridSource extends DataGridSource {
  final List<DataGridRow> dataGridRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final Function(String, int) showFormulaDialog;
  final WidgetRef ref;
  final bool canEdit;

  ProcurementBomGridSource({
    required this.dataGridRows,
    required this.onDelete,
    required this.onEdit,
    required this.showFormulaDialog,
    required this.ref,
    this.canEdit = true,
  });

  @override
  List<DataGridRow> get rows => dataGridRows;

  // Comprehensive summary calculation method
  DataGridRow _calculateCompleteSummary() {
    // Exclude the first (summary) row when calculating totals
    final nonSummaryRows = dataGridRows.skip(1);

    // Initialize summary values
    double totalPieces = 0;
    double totalWeight = 0;
    double totalRate = 0;
    double totalAmount = 0;
    double totalAvgWeight = 0;

    for (var row in nonSummaryRows) {
      final cells = row.getCells();

      // Safely extract and sum values
      totalPieces += _safeParseDouble(cells, 'Pieces');
      totalWeight += _safeParseDouble(cells, 'Weight');
      totalRate += _safeParseDouble(cells, 'Rate');
      totalAmount += _safeParseDouble(cells, 'Amount');

      // Calculate average weight
      final pieces = _safeParseDouble(cells, 'Pieces');
      final weight = _safeParseDouble(cells, 'Weight');
      totalAvgWeight += pieces > 0 ? weight / pieces : 0;
    }

    // Create summary row with calculated totals
    return DataGridRow(
      cells: [
        const DataGridCell(columnName: 'Variant Name', value: 'Summary'),
        const DataGridCell(columnName: 'Item Group', value: ''),
        DataGridCell(columnName: 'Pieces', value: totalPieces),
        DataGridCell(columnName: 'Weight', value: totalWeight),
        DataGridCell(columnName: 'Rate', value: totalRate),
        DataGridCell(columnName: 'Avg Wt(Pcs)', value: totalAvgWeight),
        DataGridCell(columnName: 'Amount', value: totalAmount),
        const DataGridCell(columnName: 'Actions', value: null),
      ],
    );
  }

  // Helper method to safely parse double values
  double _safeParseDouble(List<DataGridCell> cells, String columnName) {
    final cell = cells.firstWhere((cell) => cell.columnName == columnName,
        orElse: () => DataGridCell(columnName: columnName, value: 0.0));

    if (cell.value == null) return 0.0;

    return cell.value is num
        ? (cell.value as num).toDouble()
        : double.tryParse(cell.value.toString()) ?? 0.0;
  }

  void recalculate(int rowIndex, int editedColumn, int lastSummaryPieces) {
    if (rowIndex > 0) {
      // Recalculate the specific row if needed
      DataGridRow updatedRow =
          _recalculateRowData(dataGridRows[rowIndex], editedColumn);
      dataGridRows[rowIndex] = updatedRow;

      // Always update the summary row after any change
      _updateSummaryRow();
    }
  }

  DataGridRow _recalculateRowData(DataGridRow row, int editedColumn) {
    final cells = row.getCells();

    switch (editedColumn) {
      case 2: // Pieces column
      case 3: // Weight column
        final pieces = _safeParseDouble(cells, 'Pieces');
        final weight = _safeParseDouble(cells, 'Weight');
        final rate = _safeParseDouble(cells, 'Rate');

        return DataGridRow(
          cells: cells.map((cell) {
            if (cell.columnName == 'Avg Wt(Pcs)') {
              return DataGridCell(
                  columnName: 'Avg Wt(Pcs)',
                  value: pieces > 0 ? weight / pieces : 0.0);
            } else if (cell.columnName == 'Amount') {
              return DataGridCell(columnName: 'Amount', value: weight * rate);
            }
            return cell;
          }).toList(),
        );
      case 4: // Rate column
        final weight = _safeParseDouble(cells, 'Weight');
        final rate = _safeParseDouble(cells, 'Rate');

        return DataGridRow(
          cells: cells.map((cell) {
            if (cell.columnName == 'Amount') {
              return DataGridCell(columnName: 'Amount', value: weight * rate);
            }
            return cell;
          }).toList(),
        );
      default:
        return row;
    }
  }

  void _updateSummaryRow() {
    if (dataGridRows.isNotEmpty) {
      // Replace the first row (summary row) with newly calculated summary
      dataGridRows[0] = _calculateCompleteSummary();

      // Notify listeners of the change
      notifyListeners();
    }
  }

  void _handleCellSubmission(
      DataGridRow row, DataGridCell dataCell, String value, int rowIndex) {
    final parsedValue = double.tryParse(value) ?? 0.0;
    final lastSummaryPieces = dataGridRows[0].getCells()[2].value as num;

    final updatedRow = DataGridRow(
      cells: row
          .getCells()
          .map((cell) => cell.columnName == dataCell.columnName
              ? DataGridCell(columnName: cell.columnName, value: parsedValue)
              : cell)
          .toList(),
    );

    final cellIndex = row.getCells().indexOf(dataCell);
    dataGridRows[rowIndex] = updatedRow;

    // Recalculate and update summary
    recalculate(rowIndex, cellIndex, lastSummaryPieces.toInt());
    onEdit();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final rowIndex = dataGridRows.indexOf(row);
    final isSummaryRow = rowIndex == 0;

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        // Action button for delete
        if (dataCell.columnName == 'Actions') {
          return isSummaryRow
              ? Container()
              : IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(row),
                );
        }

        return _buildEditableCell(row, dataCell, rowIndex);
      }).toList(),
    );
  }

  Widget _buildEditableCell(
      DataGridRow row, DataGridCell dataCell, int rowIndex) {
    final isMetalRow = row.getCells().any((cell) =>
        cell.columnName == 'Item Group' &&
        cell.value.toString().contains("Metal"));

    final isPcsColumn = dataCell.columnName == 'Pieces';
    final nonEditableCell = dataCell.columnName == "Amount" ||
        dataCell.columnName == "Avg Wt(Pcs)" ||
        (isMetalRow && isPcsColumn);

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) =>
          _handleKeyboardShortcuts(event, dataCell, row),
      child: TextField(
        onSubmitted: (value) =>
            _handleCellSubmission(row, dataCell, value, rowIndex),
        controller: TextEditingController(text: dataCell.value.toString()),
        keyboardType: TextInputType.number,
        enabled: canEdit && !nonEditableCell,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  void _handleKeyboardShortcuts(
      RawKeyEvent event, DataGridCell dataCell, DataGridRow row) {
    if (event is RawKeyDownEvent &&
        event.isAltPressed &&
        event.logicalKey == LogicalKeyboardKey.keyO) {
      // Keyboard shortcut handling logic (similar to previous implementation)
      // Use a switch statement for different column types
    }
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
