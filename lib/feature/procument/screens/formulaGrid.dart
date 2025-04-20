import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/formula_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../formula/controller/meta_rate_controller.dart';
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
  List<FormulaRowModel> formulaExcel = [];
  Map<dynamic, dynamic> rangeExcelData = {};
  late int selectedBomRowIndex;

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
    selectedBomRowIndex = ref.read(showFormulaProvider);
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
    try {
      _rows = newRows;
      String formulaName = "${widget.varientName}_${selectedBomRowIndex}";
      print("formulaName $formulaName");
      Map<String, FormulaModel> allFormula =
          ref.read(allVariantFormulasProvider2);
      FormulaModel? formulaModel;
      for (String formulaKeys in allFormula.keys) {
        if (formulaKeys.contains(formulaName)) {
          formulaModel = allFormula[formulaKeys];
        }
      }
      if (formulaModel == null) return;
      if (!formulaModel.isUpdated) formulaModel.isUpdated = true;
      for (var row in newRows) {
        int index = newRows.indexOf(row);
        formulaModel.formulaRows[index].rowValue = row
            .getCells()
            .firstWhere((cell) => cell.columnName == "Row Value")
            .value;
      }
      print("updating summary rowxcc");
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(formulaName, formulaModel);

      double updatedMetalRate;
      var metalRateRows = formulaModel.formulaRows
          .where((row) => row.rowType == "MEATAL RATE");

      if (metalRateRows.isNotEmpty) {
        updatedMetalRate = metalRateRows.first.rowValue?.toDouble() ?? 0.0;
      } else {
        var diamondRateRows = formulaModel.formulaRows
            .where((row) => row.rowType == "DIAMOND RATE");
        updatedMetalRate = diamondRateRows.isNotEmpty
            ? diamondRateRows.first.rowValue?.toDouble() ?? 0.0
            : 0.0;
      }
      print("updated metal rate is $updatedMetalRate");

      ref.read(formulaBomOprProvider.notifier).updateAction({
        "data": {
          "Rate": updatedMetalRate,
          "varientName": "${widget.varientName}",
          "varientIndex": "${widget.varientIndex}"
        }
      }, true);
    } catch (e) {
      print("error is3 $e");
    }
  }

  void _initializeRows() async {
    Map<String, FormulaModel> allFormula =
        ref.read(allVariantFormulasProvider2);
    String formulaName = "${widget.varientName}_${selectedBomRowIndex}";
    FormulaModel? formula;
    for (String formulaKeys in allFormula.keys) {
      if (formulaKeys.contains(formulaName)) {
        formula = allFormula[formulaKeys];
      }
    }
    print("formula is ${formula!.formulaRows.map((cell)=>cell.toJson())}");
    if (formula == null) return;

    for (int i = 0; i < formula.formulaRows.length; i++) {
      FormulaRowModel formulaRow = formula.formulaRows[i];
      if (formulaRow.dataType == "Range") {
        String rangeKey = "15 jan";
        // formulaRow.rowExpression;
        Map<dynamic, dynamic> rangeValue = await ref
            .read(formulaProcedureControllerProvider.notifier)
            .fetchRangeMasterExcel(rangeKey, context);
        rangeExcelData[rangeKey] = rangeValue;
      }
      _rows.add(
        DataGridRow(cells: [
          DataGridCell<int>(columnName: 'Row No', value: formulaRow.rowNo),
          DataGridCell<String>(
              columnName: 'Description ', value: formulaRow.rowDescription),
          DataGridCell<String>(
            columnName: 'Row Type',
            value: formulaRow.rowType,
          ),
          DataGridCell<String>(
              columnName: 'Data Type', value: formulaRow.dataType),
          DataGridCell<double>(
            columnName: 'Row Value',
            value: assignMetalRate(formulaRow.rowType, formulaRow.rowValue),
          ),
          DataGridCell<String>(
              columnName: 'Range',
              value: formulaRow.dataType == "Range"
                  ? formulaRow.rowExpression
                  : "0"),
        ]),
      );
    }

    formulaExcel = formula.formulaRows;
    _formulaGridSource = formulaGridSource(_rows, _removeRow, _updateSummaryRow,
        formulaExcel, formulaGridHeaders, rangeExcelData, varientAttribute);
    setState(() {});
  }

  double assignMetalRate(String rowType, double rowValue) {
    print("rowType is $rowType");
    final metalRate = ref.watch(metalRateProvider);
    if (rowType == "MEATAL RATE") {
      return metalRate;
    }
    else if (rowType == "DIAMOND RATE") {
      return metalRate;
    }
    else if (rowType == "PURITY") {
      return assignMetalFiness();
    }
    else if (rowType == "METAL FINENESS") {
      return assignMetalFiness();
    } else {
      return rowValue;
    }
  }

  double assignMetalFiness() {
    return 0.998;
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
