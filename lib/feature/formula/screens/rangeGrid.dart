import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/formula/screens/rangeDataGridSourcr.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../providers/dailog_selection_provider.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../controller/formula_prtocedure_controller.dart';
import '../controller/heirarchy_controller.dart';

class Rangegrid extends ConsumerStatefulWidget {
  const Rangegrid(
      {super.key,
      required this.headers,
      required this.excelData,
      required this.rangeHierarchy});

  final List<dynamic> headers;
  final List<List<dynamic>> excelData;
  final String rangeHierarchy;

  @override
  ConsumerState<Rangegrid> createState() => _RangegridState();
}

class _RangegridState extends ConsumerState<Rangegrid> {
  @override
  List<DataGridRow> outwardRows = [];
  late RangeDataGridSource _procumentDataGridSource;
  final DataGridController outwardDataGridController = DataGridController();
  bool _isLoading = true;

  @override
  void initState() {
    _procumentDataGridSource = RangeDataGridSource(
        outwardRows, (_) {}, () {}, false, handleOpenDialog);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() {
      initializeRows();
    });
  }

  void initializeRows() {
    setState(() {
      outwardRows = widget.excelData
          .map((row) => DataGridRow(
              cells: row
                  .map((cell) => DataGridCell(
                      columnName: widget.headers[row.indexOf(cell)],
                      value: cell))
                  .toList()))
          .toList();
      _procumentDataGridSource = RangeDataGridSource(
          outwardRows, (_) {}, () {}, false, handleOpenDialog);
      print("outward row ${outwardRows.length}");
      _isLoading = false;
    });
    if (outwardRows.length == 0) AddRow();
  }

  void AddRow() {
    outwardRows.add(DataGridRow(
        cells: widget.headers
            .map((col) => DataGridCell(columnName: col, value: ''))
            .toList()));
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    final itemMap = ref.watch(itemListProvider);
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: screenHeight * 0.6,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: screenWidth,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Theme(
                    data: ThemeData(
                      cardColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: SfDataGrid(
                      rowHeight: 40,
                      headerRowHeight: 40,
                      source: _procumentDataGridSource,
                      controller: outwardDataGridController,
                      footerFrozenColumnsCount: 1,
                      columns: widget.headers.map((columnName) {
                        return GridColumn(
                          columnName: columnName,
                          width: _calculateColumnWidth(columnName),
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF003450),
                              border:
                                  Border(right: BorderSide(color: Colors.grey)),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    widget.headers.indexOf(columnName) ==
                                            widget.headers.length - 1
                                        ? 15
                                        : 0),
                                topLeft: Radius.circular(
                                    widget.headers.indexOf(columnName) == 0
                                        ? 15
                                        : 0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              columnName,
                              style: TextStyle(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
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
        InkWell(
          onTap: () async {
            final dataList = itemMap.entries.expand((entry) {
              if (entry.key == 'Number') {
                // For 'Number', add two maps for each value
                return entry.value.expand((value) => [
                      {'dataType': entry.key, 'depdField': '$value start'},
                      {'dataType': entry.key, 'depdField': '$value end'},
                    ]);
              } else {
                // For other keys, just create a map for each value
                return entry.value.map(
                  (value) => {'dataType': entry.key, 'depdField': value},
                );
              }
            }).toList();
            print("data list is $dataList");
            print(
                "selcted range is ${ref.read(dialogSelectionProvider)['Attribute Type']}");
            Map<String, dynamic> reqBody = {
              "rangeHierarchyName": widget.rangeHierarchy,
              "rangeType": ref.read(dialogSelectionProvider)['Attribute Type'],
              "details": dataList,
            };
            print("add range mamster body $reqBody");
            ref
                .read(formulaProcedureControllerProvider.notifier)
                .addRangeMasterDepdField(reqBody, context);

            // save excel data

            List<List<dynamic>> excelData = [];

            for (DataGridRow row in outwardRows) {
              List<dynamic> rowData = [];
              for (DataGridCell cell in row.getCells()) rowData.add(cell.value);
              excelData.add(rowData);
            }
            print("excel data is $excelData");
            final headerValues = itemMap.entries
                .expand((entry) => entry.key == 'Number'
                    ? entry.value
                        .expand((value) => ['$value start', '$value end'])
                    : entry.value.map((value) => value))
                .toList();
            headerValues.insert(0, "Output");
            Map<String, dynamic> excelReqBody = {
              "rangeHierarchyName": widget.rangeHierarchy,
              "details": {"excelData": excelData, "Headers": headerValues},
            };
            print("excel body is ${jsonEncode(excelReqBody)}");

            ref
                .read(formulaProcedureControllerProvider.notifier)
                .addRangeMasterExcel(excelReqBody, context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: screenHeight * 0.005),
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0;
    const double paddingWidth = 20.0;
    return (columnName.length * charWidth) + paddingWidth;
  }

  String _getColumnName(int index) {
    String column = '';
    int temp = index;
    while (temp >= 0) {
      column = String.fromCharCode((temp % 26) + 65) + column;
      temp = (temp ~/ 26) - 1;
    }
    return column;
  }

  void handleOpenDialog(int row, int col) {
    final String item = widget.headers[col];

    final isNonNumber = item.contains("start") || item.contains("end");

    print("showing dailog $item");
    final selectedItemID = ref.read(dialogSelectionProvider)[item];

    if (!isNonNumber)
      showDialog(
        context: context,
        builder: (context) => ItemTypeDialogScreen(
          value: 'AttributeCode',
          title: item,
          endUrl: 'AllAttribute',
          query: item,
          onOptionSelectd: (selectedOption) {
            // Handle the selected option

            // Optionally, send the selected option back to the WebView
            // For example, update the cell with the selected option
            updateCellValue(row, col, selectedOption);
          },
        ),
      );
  }

  void updateCellValue(int row, int col, dynamic value) {
    setState(() {
      outwardRows[row] = DataGridRow(
          cells: outwardRows[row].getCells().map((cell) {
        if (outwardRows[row].getCells().indexOf(cell) == col) {
          return DataGridCell(columnName: cell.columnName, value: value);
        } else
          return cell;
      }).toList());
    });
  }
}
