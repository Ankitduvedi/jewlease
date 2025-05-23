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
  const FormulaDataGrid({
    super.key,
    required this.varientName,
    required this.varientIndex,
    required this.isFromBom,
    required this.FormulaName,
    required this.backButton,
    required this.formulaIndex,
  });

  final String varientName;
  final int varientIndex;
  final isFromBom;
  final String FormulaName;
  final VoidCallback backButton;
  final formulaIndex;

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
    bool isJustOpened = true;
    super.initState();
    _formulaGridSource = formulaGridSource(
      dataGridRows: _rows,
      onDelete: _removeRow,
      onEdit: _updateSummaryRow,
      formulaExcel: formulaExcel,
      formulaHeaders: [],
      rangeExcel: rangeExcelData,
      varientAttributes: varientAttribute,
    );
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

  void _updateSummaryRow(
    List<DataGridRow> newRows,
  ) {
    print("update formula summary called ");
    // try {
      //<---------------Logic to update formula provide with new model-------->
      _rows = newRows;

      Map<String, FormulaModel> allFormula =
          ref.read(allVariantFormulasProvider2);
      FormulaModel? formulaModel;
      for (String formulaKeys in allFormula.keys) {
        if (formulaKeys.contains(widget.FormulaName)) {
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
          .update(widget.FormulaName, formulaModel);

      double updatedFormulaTotal = formulaModel
          .formulaRows[formulaModel.formulaRows.length - 1].rowValue;
      ("updated metal rate is $updatedFormulaTotal");

      ref.read(formulaBomOprProvider.notifier).updateAction({
        "data": {
          "total": updatedFormulaTotal,
          "varientName": "${widget.varientName}",
          "variantIndex": "${widget.varientIndex}",
          "updatedRowIndex": widget.formulaIndex,
          "isBomUpdate": widget.isFromBom,
          "isOprUpdate": !widget.isFromBom
        }
      }, true);
    // } catch (e) {
    //   print("error is3 $e");
    // }
    print("update formula summary called ends ");
  }

  void _initializeRows() async {
    Map<String, FormulaModel> allFormula =
        ref.read(allVariantFormulasProvider2);

    String formulaName = widget.FormulaName;
    print("formula name is $formulaName");
    FormulaModel? formula;
    print("allformulas $allFormula");
    for (String formulaKey in allFormula.keys) {
      if (formulaKey == formulaName) {
        print("formaula key $formulaKey ${widget.FormulaName}");
        formula = allFormula[formulaKey];
      }
    }

    if (formula == null) return;

    for (int i = 0; i < formula.formulaRows.length; i++) {
      print("formula is2 ${formula.formulaRows[i].toJson()}");
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
    _formulaGridSource = formulaGridSource(
      dataGridRows: _rows,
      onDelete: _removeRow,
      onEdit: _updateSummaryRow,
      formulaExcel: formulaExcel,
      formulaHeaders: formulaGridHeaders,
      rangeExcel: rangeExcelData,
      varientAttributes: varientAttribute,
    );
    setState(() {});
  }

  double assignMetalRate(String rowType, double rowValue) {
    print("rowType is $rowType");
    final metalRate = ref.watch(metalRateProvider);
    if (rowType == "MEATAL RATE") {
      return metalRate;
    } else if (rowType == "DIAMOND RATE") {
      return metalRate;
    } else if (rowType == "PURITY") {
      return assignMetalFiness();
    } else if (rowType == "METAL FINENESS") {
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      widget.backButton();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 15,
                    )),
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
