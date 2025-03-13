import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../procument/screens/procumentSummeryGridSource.dart';

class LedgerDataGrid extends StatefulWidget {
  const LedgerDataGrid({super.key});

  @override
  State<LedgerDataGrid> createState() => _LedgerDataGridState();
}

class _LedgerDataGridState extends State<LedgerDataGrid> {
  List<String> LedgerColumnns = [
    'Location',
    'Type',
    'Voucher No',
    'Batch',
    'Trans Date',
    'Particulars',
    'Dr Amount',
    'Cr Amount',
    'Running Bal',
  ];
  List<DataGridRow> ledgerRows = [];
  late ProcumentDataGridSource _procumentdataGridSource;
  final DataGridController InwardDataGridController = DataGridController();

  @override
  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0; // Approximate width of a character
    const double paddingWidth = 20.0; // Extra padding for the cell
    return (columnName.length * charWidth) + paddingWidth;
  }

  @override
  void initState() {
    _procumentdataGridSource =
        ProcumentDataGridSource(ledgerRows, (DataGridRow) {}, () {}, false);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return
      Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: screenHeight * 0.6,

          margin: EdgeInsets.only(top: 10, left: 0),
          // padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            // color: Colors.green,
            // border: Border.all(color: Colors.pink),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.2), // Shadow color with opacity
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 4), // Offset only on the bottom
              ),
            ],
          ),
          // height: screenHeight * 0.5,
          width: screenWidth,
          child: Theme(
            data: ThemeData(
              cardColor: Colors.transparent,
              // Background color for DataGrid
              shadowColor: Colors.transparent, // Removes shadow if any
            ),
            child: SfDataGrid(
              rowHeight: 40,
              headerRowHeight: 40,
              source: _procumentdataGridSource,
              controller: InwardDataGridController,
              footerFrozenColumnsCount: 1,
              // Freeze the last column
              columns: LedgerColumnns.map((columnName) {
                return GridColumn(
                  columnName: columnName,
                  width: _calculateColumnWidth(columnName),
                  // Dynamically set column width
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF003450),
                      border: Border(right: BorderSide(color: Colors.grey)),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                            LedgerColumnns.indexOf(columnName) ==
                                    LedgerColumnns.length - 1
                                ? 15
                                : 0),
                        topLeft: Radius.circular(
                            LedgerColumnns.indexOf(columnName) == 0
                                ? 15
                                : 0),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      columnName,
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      // Ensure text stays in a single line
                      overflow: TextOverflow.visible, // Prevent clipping
                    ),
                  ),
                );
              }).toList(),
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.none,
            ),
          ),
        ),
      ),
    );
  }
}
