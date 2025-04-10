import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/formula_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentFormualaBomController.dart';
import '../controller/procumentFormulaController.dart';
import '../controller/procumentVarientFormula.dart';
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
  late formulaGridSource _formulaGridSource;
  List<String> formulas = [];
  List<FomulaRowModel> formulaExcel = [];
  Map<dynamic, dynamic> rangeExcelData = {};
  List<String> formulaGridHeaders = [
    'Row No',
    'Description',
    'Row Type',
    'Data Type',
    'Row Value',
    'Range'
  ];
  Map<String, dynamic> varientAttribute = {};

  @override
  void initState() {
    // fetchVarientAttributes();
    super.initState();
    _formulaGridSource = formulaGridSource(_rows, _removeRow, _updateSummaryRow,
        formulaExcel, [], rangeExcelData, varientAttribute);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeRows();
      // executes after build
    });
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _rows.remove(row);
      _formulaGridSource.updateDataGridSource();
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
    List<dynamic> formula_rows = [];
    for (int i = 0; i < _rows.length; i++) {
      List<dynamic> rowValues = [];
      for (var cell in _rows[i].getCells()) {
        rowValues.add(cell.value);
      }
      formula_rows.add(rowValues);
    }
    int selectedBomRow = ref.read(showFormulaProvider);

    //<------------------add formula rows to the varientAllFormulaProvider---------------->
    ref.read(varientAllFormulaProvider.notifier).update(
        "${widget.varientIndex}${widget.varientName}${selectedBomRow}",
        formula_rows);

    // ref.read(formulaBomOprProvider.notifier).updateAction({
    //   "data": {
    //     "Rate": updatedMetalRate,
    //     "varientName": "${widget.varientName}",
    //     "varientIndex": "${widget.varientIndex}"
    //   }
    // }, false);
  }

  void _initializeRows() async {
    int selectedBomRow = ref.read(showFormulaProvider);
    Map<String, FormulaModel> allFormula =
        ref.read(allVariantFormulasProvider2);
    String formulaName = "${widget.varientName}_${selectedBomRow}";
    FormulaModel? formula;
    for (String formulaKeys in allFormula.keys) {
      if (formulaKeys.contains(formulaName)) {
        formula = allFormula[formulaKeys];
      }
    }
    if (formula == null) return;
    rangeExcelData = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchRangeMasterExcel('15 jan', context);
    for (int i = 0; i < formula.formulaRows.length; i++) {
      _rows.add(
        DataGridRow(cells: [
          DataGridCell<int>(
              columnName: 'Row No', value: formula.formulaRows[i].rowNo),
          DataGridCell<String>(
              columnName: 'Description ',
              value: formula.formulaRows[i].rowDescription),
          DataGridCell<String>(
            columnName: 'Row Type',
            value: formula.formulaRows[i].rowType,
          ),
          DataGridCell<String>(
              columnName: 'Data Type', value: formula.formulaRows[i].dataType),
          DataGridCell<double>(
              columnName: 'Row Value', value: formula.formulaRows[i].rowValue),
          DataGridCell<double>(columnName: 'Range', value: 0),
        ]),
      );
    }
    formulaExcel = formula.formulaRows;
    _formulaGridSource = formulaGridSource(_rows, _removeRow, _updateSummaryRow,
        formulaExcel, formulaGridHeaders, rangeExcelData, varientAttribute);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    return Container(
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
                  'Formula',
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
                        source: _formulaGridSource,
                        controller: _dataGridController,
                        footerFrozenColumnsCount: 1,
                        columns: formulaGridHeaders.map((columnName) {
                          return GridColumn(
                            columnName: columnName,
                            width: gridWidth /
                                5, // Adjust column width to fit 4-5 columns
                            label: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF003450),
                                borderRadius: BorderRadius.only(
                                    topRight: formulaGridHeaders
                                                .indexOf(columnName) ==
                                            formulaGridHeaders.length - 1
                                        ? Radius.circular(10)
                                        : Radius.zero,
                                    topLeft: formulaGridHeaders
                                                .indexOf(columnName) ==
                                            0
                                        ? Radius.circular(10)
                                        : Radius.zero),
                              ),
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
}
