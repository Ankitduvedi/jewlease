import 'package:flutter/material.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';

class ProcumentBomGrid extends StatelessWidget {
  final ProcurementBomGridSource bomDataGridSource;
  final DataGridController dataGridController;
  final double gridWidth;

  const ProcumentBomGrid({
    Key? key,
    required this.bomDataGridSource,
    required this.dataGridController,
    required this.gridWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: bomDataGridSource,
      controller: dataGridController,
      columns: _buildGridColumns(),
      columnWidthMode: ColumnWidthMode.auto,
      allowEditing: true,
    );
  }

  List<GridColumn> _buildGridColumns() {
    return [
      GridColumn(
        columnName: 'Variant Name',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Variant Name'),
        ),
      ),
      GridColumn(
        columnName: 'Item Group',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Item Group'),
        ),
      ),
      GridColumn(
        columnName: 'Pieces',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Pieces'),
        ),
      ),
      GridColumn(
        columnName: 'Weight',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Weight'),
        ),
      ),
      GridColumn(
        columnName: 'Rate',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Rate'),
        ),
      ),
      GridColumn(
        columnName: 'Avg Wt(Pcs)',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Avg Wt(Pcs)'),
        ),
      ),
      GridColumn(
        columnName: 'Amount',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Amount'),
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
