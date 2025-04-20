import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';

class ProcumentBomGrid extends StatefulWidget {
  const ProcumentBomGrid(
      {super.key,
      required this.bomDataGridSource,
      required this.gridWidth,
      required this.dataGridController});

  final DataGridSource bomDataGridSource;
  final double gridWidth;
  final DataGridController dataGridController;

  @override
  State<ProcumentBomGrid> createState() => _ProcumentBomGridState();
}

class _ProcumentBomGridState extends State<ProcumentBomGrid> {
  List<String> bomColumn = [
    'Variant Name',
    'Item Group',
    'Pieces',
    'Weight',
    'Rate',
    'Avg Wt(Pcs)',
    'Amount',
    'Sp Char',
    'Operation',
    'Type',
    'Actions'
  ];

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(10), // Adjust this for desired roundness
      child: Container(
        // width: screenWidth * 0.42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
          Border.fromBorderSide(BorderSide(color: Colors.grey)),

        ),
        child: SfDataGrid(
          rowHeight: 35,
          headerRowHeight: 40,
          source: widget.bomDataGridSource,
          controller: widget.dataGridController,
          footerFrozenColumnsCount: 1,
          // Freeze the last column
          columns: bomColumn
              .map((columnName) => GridColumn(
                    columnName: columnName,
                    width: widget.gridWidth / 5,
                    label: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF003450),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                bomColumn.indexOf(columnName) == 0 ? 10 : 0),
                            topRight: Radius.circular(
                                bomColumn.indexOf(columnName) ==
                                        bomColumn.length - 1
                                    ? 10
                                    : 0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        columnName,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
              .toList(),
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
        ),
      ),
    );
  }
}
