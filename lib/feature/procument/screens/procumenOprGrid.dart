import 'package:flutter/material.dart';
import 'package:jewlease/feature/procument/screens/operationGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';

class ProcumentOperationGrid extends StatefulWidget {
  const ProcumentOperationGrid(
      {super.key,
      required this.gridWidth,
      required this.dataGridController,
      required this.oprDataGridSource,
      required this.operationType});

  final procumentOperationGridSource oprDataGridSource;
  final double gridWidth;
  final DataGridController dataGridController;
  final String operationType;

  @override
  State<ProcumentOperationGrid> createState() => _ProcumentOperationGridState();
}

class _ProcumentOperationGridState extends State<ProcumentOperationGrid> {
  List<String> operationHeaders = [
    'Calc Bom',
    'Operation',
    'Calc Qty',
    'Rate',
    'Amount',
    'Calc Method',
  ];

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // color: Colors.red,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.operationType}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            // Adjust this for desired roundness
            child: Container(
              // width: screenWidth * 0.42,42
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
              ),
              child: SfDataGrid(
                rowHeight: 30,
                headerRowHeight: 35,
                source: widget.oprDataGridSource,
                controller: widget.dataGridController,
                footerFrozenColumnsCount: 1,
                // Freeze the last column
                columns: operationHeaders
                    .map((operationColumn) => GridColumn(
                          columnName: operationColumn,
                          width: widget.gridWidth / 5,
                          label: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF003450),
                              borderRadius: BorderRadius.only(
                                  topLeft: operationHeaders
                                              .indexOf(operationColumn) ==
                                          0
                                      ? Radius.circular(10)
                                      : Radius.zero,
                                  topRight: operationHeaders
                                              .indexOf(operationColumn) ==
                                          operationHeaders.length - 1
                                      ? Radius.circular(10)
                                      : Radius.zero),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              operationColumn,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
              ),
            ),
          )
        ],
      ),
    );
  }
}
