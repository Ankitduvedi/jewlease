import 'package:flutter/material.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';

class ProcumentOperationGrid extends StatelessWidget {
  final String operationType;
  final DataGridController dataGridController;
  final ProcurementBomGridSource oprDataGridSource;
  final double gridWidth;

  const ProcumentOperationGrid({
    Key? key,
    required this.operationType,
    required this.dataGridController,
    required this.oprDataGridSource,
    required this.gridWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: oprDataGridSource,
      controller: dataGridController,
      columns: _buildGridColumns(),
      columnWidthMode: ColumnWidthMode.auto,
      allowEditing: true,
    );
  }

  List<GridColumn> _buildGridColumns() {
    return [
      GridColumn(
        columnName: 'Calc Bom',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Calc Bom'),
        ),
      ),
      GridColumn(
        columnName: 'Operation',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Operation'),
        ),
      ),
      GridColumn(
        columnName: 'Calc Qty',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Calc Qty'),
        ),
      ),
      GridColumn(
        columnName: 'Type',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Type'),
        ),
      ),
      GridColumn(
        columnName: 'Calc Method',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Calc Method'),
        ),
      ),
      GridColumn(
        columnName: 'Actions',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Actions'),
        ),
      ),
    ];
  }
}
