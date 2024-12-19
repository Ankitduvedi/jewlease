import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentFormualaBomController.dart';
import '../controller/procumentFormulaController.dart';
import 'formulaGridSource.dart';

class FormulaDataGrid extends ConsumerStatefulWidget {
  const FormulaDataGrid(this.varientName, this.varientIndex, {super.key});

  final String varientName;
  final int varientIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return FormulaDataGridState();
  }
}

class FormulaDataGridState extends ConsumerState<FormulaDataGrid> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _rows = [];
  late formulaGridSource _dataGridSource;
  List<String> formulas = [];
  List<dynamic> formulaExcel = [];
  Map<dynamic, dynamic> rangeExcelData = {};
  List<String> formulaGridHeaders = [
    'Row No',
    'Description',
    'Row Type',
    'Row Value',
    'Range'
  ];
  Map<String, dynamic> varientAttribute = {};

  @override
  void initState() {
    fetchVarientAttributes();
    super.initState();
    _dataGridSource = formulaGridSource(_rows, _removeRow, _updateSummaryRow,
        formulaExcel, [], rangeExcelData, varientAttribute);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeRows();

      // executes after build
    });
  }

  fetchVarientAttributes() {
    Map<String, dynamic>? varient = ref
        .read(procurementVariantProvider.notifier)
        .getItemByVariant(widget.varientName);
    varientAttribute["KARAT"] = "22";
    varientAttribute["CATEGORY"] = varient!["Category"];
    varientAttribute["Sub-Category"] = varient["Sub-Category"];
    varientAttribute["STYLE KARAT"] = varient["Style Karat"];
    varientAttribute["Varient"] = varient["Varient"];
    varientAttribute["HSN - SAC CODE"] = varient["HSN-SAC Code"];
    varientAttribute["LINE OF BUSINESS"] = varient["Line of Business"];
    List<dynamic> selectedBomRow =
        varient["BOM"]["data"][ref.read(showFormulaProvider)];
    varientAttribute["Pieces"] = selectedBomRow[2];
    varientAttribute["Weight"] = selectedBomRow[3];
    varientAttribute["Rate"] = selectedBomRow[4];
    varientAttribute["Avg Wt(Pcs)"] = selectedBomRow[5];
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _rows.remove(row);
      _dataGridSource.updateDataGridSource();
      _updateSummaryRow(_rows);
    });
  }

  void _updateSummaryRow(List<DataGridRow> newRows) {
    print("updating summary row");

    _rows = newRows;

    double updatedMetalRate = _rows[0]
        .getCells()
        .where((cell) => cell.columnName == 'Row Value')
        .first
        .value;

    ref.read(formulaBomOprProvider.notifier).updateAction({
      "data": {
        "Rate": updatedMetalRate,
        "varientName": "${widget.varientName}",
        "varientIndex": "${widget.varientIndex}"
      }
    }, true);
    // ref.read(formulaBomOprProvider.notifier).updateAction({
    //   "data": {
    //     "Rate": updatedMetalRate,
    //     "varientName": "${widget.varientName}",
    //     "varientIndex": "${widget.varientIndex}"
    //   }
    // }, false);
  }

  void _initializeRows() async {
    List<List<dynamic>> excelData = [];
    Map<String, dynamic> data = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchFormulaExcel('a', context);

    rangeExcelData = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchRangeMasterExcel('13 Dec', context);
    print("range master excel is $rangeExcelData");
    formulaExcel = data["Excel Detail"]["data"];
    for (int i = 0; i < formulaExcel.length; i++) {
      excelData.add(formulaExcel[i]);
    }
    print("excel data is $excelData");
    List<dynamic> excelHeader = data["Excel Detail"]["headers"];
    for (int i = 0; i < formulaExcel.length; i++) {
      formulas.add(excelData[i][excelHeader.indexOf("Formula")]);
      _rows.add(DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Row No',
            value: excelData[i][excelHeader.indexOf("Row")]),
        DataGridCell<String>(
            columnName: 'Description ',
            value: excelData[i][excelHeader.indexOf("Description")]),
        DataGridCell<String>(
          columnName: 'Row Type',
          value: excelData[i][excelHeader.indexOf("Row Type")],
        ),
        DataGridCell<String>(
            columnName: 'Row Value', value: (i == 1 ? "0.9175" : "0")),
        DataGridCell<double>(columnName: 'Range', value: 0),
      ]));
    }
    _dataGridSource = formulaGridSource(_rows, _removeRow, _updateSummaryRow,
        formulaExcel, excelHeader, rangeExcelData, varientAttribute);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    return Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.4,
      margin: EdgeInsets.only(top: 20, left: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
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
                  'Metal Exchange',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10), // Adjust this for desired roundness
                  child: Container(
                      width: screenWidth * 0.42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.grey)),
                      ),
                      child: SfDataGrid(
                        rowHeight: 40,
                        headerRowHeight: 40,
                        source: _dataGridSource,
                        controller: _dataGridController,
                        footerFrozenColumnsCount: 1,
                        // Freeze the last column
                        columns: formulaGridHeaders.map((columnName) {
                          return GridColumn(
                            columnName: columnName,
                            width: gridWidth /
                                5, // Adjust column width to fit 4-5 columns
                            label: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF003450),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10))),
                              alignment: Alignment.center,
                              child: Text(
                                columnName,
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
