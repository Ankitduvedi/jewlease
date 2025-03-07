import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../procument/screens/procumentSummeryGridSource.dart';
import '../controller/formula_prtocedure_controller.dart';

class AddFormulaGrid extends ConsumerStatefulWidget {
  const AddFormulaGrid({super.key, required this.formulaProcedureName});

  final String formulaProcedureName;

  @override
  ConsumerState<AddFormulaGrid> createState() => _AddFormulaGridState();
}

class _AddFormulaGridState extends ConsumerState<AddFormulaGrid> {
  List<String> transferOutwardColumns = [
    'Row',
    'Description',
    'Data Type',
    'Row Type',
    'Formula',
    'Range Value',
    'Editable',
    'Visible',
    'Round Off',
    'Account Name'
  ];

  List<DataGridRow> outwardRows = [];
  late ProcumentDataGridSource _procumentDataGridSource;
  final DataGridController outwardDataGridController = DataGridController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _procumentDataGridSource = ProcumentDataGridSource(outwardRows, (_) {}, () {}, false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() async {
      await initializeRows();
    });
  }

  Future<void> initializeRows() async {
    if (widget.formulaProcedureName.isEmpty) return;

    try {
      List<List<dynamic>> excelData = await fetchApiUpdatedData();

      setState(() {
        outwardRows = excelData.map((row) => DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Row', value: row[0]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Description', value: row[1]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Data Type', value: row[2]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Row Type', value: row[3]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Formula', value: row[4]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Range Value', value: row[5]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Editable', value: row[6]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Visible', value: row[7]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Round Off', value: row[7]?.toString() ?? ''),
          DataGridCell<String>(columnName: 'Account Name', value: row[7]?.toString() ?? ''),
        ])).toList();

        _procumentDataGridSource = ProcumentDataGridSource(outwardRows, (_) {}, () {}, false);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<List<List<dynamic>>> fetchApiUpdatedData() async {
    if (widget.formulaProcedureName.isEmpty) return [];

    Map<String, dynamic> data = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchFormulaExcel(widget.formulaProcedureName, context);

    List<dynamic> tempList = data["Excel Detail"]["data"] ?? [];

    return tempList.map((row) => List<dynamic>.from(row)).toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
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
            columns: transferOutwardColumns.map((columnName) {
              return GridColumn(
                columnName: columnName,
                width: _calculateColumnWidth(columnName),
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF003450),
                    border: Border(right: BorderSide(color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(transferOutwardColumns.indexOf(columnName) == transferOutwardColumns.length - 1 ? 15 : 0),
                      topLeft: Radius.circular(transferOutwardColumns.indexOf(columnName) == 0 ? 15 : 0),
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
    );
  }

  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0;
    const double paddingWidth = 20.0;
    return (columnName.length * charWidth) + paddingWidth;
  }
}
