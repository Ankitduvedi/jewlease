import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';

class ProcumentOperationGrid extends StatelessWidget {
  const ProcumentOperationGrid(
      {super.key,
      required this.gridWidth,
      required this.dataGridController,
      required this.oprDataGridSource,
      required this.operationType});

  final DataGridSource oprDataGridSource;
  final double gridWidth;
  final DataGridController dataGridController;
  final String operationType;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.4,
      // margin: EdgeInsets.only(top: 20, left: 20),// fix this in procument varinet
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // color: Colors.red,
      ),
      child: Column(
        children: [
          // Header Row

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$operationType',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // Adjust this for desired roundness
                child: Container(
                  width: screenWidth * 0.42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.fromBorderSide(BorderSide(color: Colors.grey)),
                  ),
                  // Set the grid width to 50% of the screen width
                  child: SfDataGrid(
                    rowHeight: 40,
                    headerRowHeight: 40,
                    source: oprDataGridSource,
                    controller: dataGridController,
                    footerFrozenColumnsCount: 1,
                    // Freeze the last column
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'Calc Bom',
                        width: gridWidth / 5,
                        // Adjust column width to fit 4-5 columns
                        label: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF003450),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10))),
                          alignment: Alignment.center,
                          child: Text(
                            'Calc Bom',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Operation',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Operation',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Calc Qty',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Calc Qty',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Type',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Type',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Calc Method',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Calc Method',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Calc Method Value',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Calc Method Value',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Depd Method',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Depd Method',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Depd Method Vale',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Depd Method Value',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Depd Type',
                        width: gridWidth / 5,
                        label: Container(
                          color: Color(0xFF003450),
                          alignment: Alignment.center,
                          child: Text(
                            'Depd Type',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Depd Qty',
                        width: gridWidth / 5,
                        label: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF003450),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10))),
                          alignment: Alignment.center,
                          child: Text(
                            'Depd Qty',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
