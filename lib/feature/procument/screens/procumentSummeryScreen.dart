import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';
import 'package:jewlease/data/model/procumentStyleVariant.dart';
import 'package:jewlease/feature/procument/controller/procumentBomProcController.dart';
import 'package:jewlease/feature/procument/controller/procumentVarientFormula.dart';
import 'package:jewlease/feature/procument/screens/procumentFloatingBar.dart';
import 'package:jewlease/feature/procument/screens/procumentSummeryGridSource.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/utils/utils.dart';
import '../../../data/model/formula_model.dart';
import '../../../main.dart';
import '../../../widgets/data_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../formula/controller/meta_rate_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentFormualaBomController.dart';
import '../repository/procument_Repositoy.dart';
import 'formulaGrid.dart';

class ProcumentSummaryScreen extends ConsumerStatefulWidget {
  const ProcumentSummaryScreen({
    super.key,
  });

  @override
  _ProcumentDataGridState createState() => _ProcumentDataGridState();
}

class _ProcumentDataGridState extends ConsumerState<ProcumentSummaryScreen> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _Procumentrows = [];
  late ProcumentDataGridSource _procumentdataGridSource;
  List<String> procumentColumns = [
    'Ref Document',
    'Stock Code',
    'Line No',
    'Variant Name',
    'Stock Status',
    'Stone Wt',
    'Pieces',
    'Weight',
    'Rate',
    'Amount',
    'Wastage'
  ];
  Map<String, dynamic> procumentSummery = {
    "Pieces": 0.0,
    "Wt": 0.0,
    "Metal Wt": 0.0,
    "Metal Amt": 0.0,
    "Stone Wt": 0.0,
    "Stone Amt": 0.0,
    "Labour Amt": 0.0,
    "Wastage": 0.0,
    "Wastage Fine": 0.0,
    "Total Fine": 0.0,
    "Total Amt": 0.0,
    "TotalTransAmt": 0.0
  };

  @override
  void initState() {
    super.initState();

    _initializeRows();

    _procumentdataGridSource = ProcumentDataGridSource(
        _Procumentrows, _removeRow, _updateSummaryRow, true,
        showFormulaDialog: showVariantFormula);
    setState(() {});
  }

  void showVariantFormula(int variantIndex) {
    ProcumentStyleVariant variant =
        ref.read(procurementVariantProvider2)[variantIndex];
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: screenHeight * 0.35,
          width: screenWidth * 0.42,
          child: Center(
            child: FormulaDataGrid(
              varientIndex: variantIndex,
              varientName: variant.variantName,
              isFromBom: true,
              FormulaName: "variant_${variantIndex}",
              backButton: () {
                Navigator.pop(context);
              },
              formulaIndex: 0,
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> OperationMap = {
    "VariantName": "DIA-BAN-BAN-GEN-18KT-1",
    "CalcBOM": "DIA-BAN-BAN-GEN-18KT-1",
    "CalcCF": 0.0,
    "CalcMethod": "WT-CUS",
    "CalcMethodVal": "METAL WT + FINDING WT",
    "CalcQty": 26.6,
    "CalculateFormula": "s",
    "DepdBOM": null,
    "DepdMethod": null,
    "DepdMethodVal": 0.0,
    "DepdQty": 0.0,
    "LabourAmount": 0.0,
    "LabourAmountLocal": 0.0,
    "LabourRate": 0.0,
    "MaxRateValue": 0.0,
    "MinRateValue": 0.0,
    "Operation": "MAKING CHARGES PER GRAM",
    "OperationType": null,
    "RateAsPerFormula": 0.0,
    "RowStatus": 1,
    "Rate_Edit_Ind": 0
  };

  List<Map<String, dynamic>> operationMapList = [
    {
      "VariantName": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcBOM": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcCF": 0.0,
      "CalcMethod": "WT-CUS",
      "CalcMethodVal": "METAL WT + FINDING WT",
      "CalcQty": 26.6,
      "CalculateFormula": "s",
      "DepdBOM": null,
      "DepdMethod": null,
      "DepdMethodVal": 0.0,
      "DepdQty": 0.0,
      "LabourAmount": 0.0,
      "LabourAmountLocal": 0.0,
      "LabourRate": 0.0,
      "MaxRateValue": 0.0,
      "MinRateValue": 0.0,
      "Operation": "MAKING CHARGES PER GRAM",
      "OperationType": null,
      "RateAsPerFormula": 0.0,
      "RowStatus": 1,
      "Rate_Edit_Ind": 0
    },
    {
      "VariantName": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcBOM": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcCF": 0.0,
      "CalcMethod": "WT-CUS",
      "CalcMethodVal": "METAL WT + FINDING WT",
      "CalcQty": 26.6,
      "CalculateFormula": "s",
      "DepdBOM": null,
      "DepdMethod": null,
      "DepdMethodVal": 0.0,
      "DepdQty": 0.0,
      "LabourAmount": 0.0,
      "LabourAmountLocal": 0.0,
      "LabourRate": 0.0,
      "MaxRateValue": 0.0,
      "MinRateValue": 0.0,
      "Operation": "MAKING CHARGES PER GRAM",
      "OperationType": null,
      "RateAsPerFormula": 0.0,
      "RowStatus": 1,
      "Rate_Edit_Ind": 0
    },
    {
      "VariantName": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcBOM": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcCF": 0.0,
      "CalcMethod": "WT-CUS",
      "CalcMethodVal": "METAL WT + FINDING WT",
      "CalcQty": 26.6,
      "CalculateFormula": "s",
      "DepdBOM": null,
      "DepdMethod": null,
      "DepdMethodVal": 0.0,
      "DepdQty": 0.0,
      "LabourAmount": 0.0,
      "LabourAmountLocal": 0.0,
      "LabourRate": 0.0,
      "MaxRateValue": 0.0,
      "MinRateValue": 0.0,
      "Operation": "MAKING CHARGES PER GRAM",
      "OperationType": null,
      "RateAsPerFormula": 0.0,
      "RowStatus": 1,
      "Rate_Edit_Ind": 0
    },
    {
      "VariantName": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcBOM": "DIA-BAN-BAN-GEN-18KT-1",
      "CalcCF": 0.0,
      "CalcMethod": "WT-CUS",
      "CalcMethodVal": "METAL WT + FINDING WT",
      "CalcQty": 26.6,
      "CalculateFormula": "s",
      "DepdBOM": null,
      "DepdMethod": null,
      "DepdMethodVal": 0.0,
      "DepdQty": 0.0,
      "LabourAmount": 0.0,
      "LabourAmountLocal": 0.0,
      "LabourRate": 0.0,
      "MaxRateValue": 0.0,
      "MinRateValue": 0.0,
      "Operation": "MAKING CHARGES PER GRAM",
      "OperationType": null,
      "RateAsPerFormula": 0.0,
      "RowStatus": 1,
      "Rate_Edit_Ind": 0
    },
  ];

  //done
  void _procumentSummery(Map<String, dynamic> updatedVarient) {
    setState(() {
      try {
        procumentSummery['Wt'] = 0.0;
        procumentSummery['Total Amt'] = 0.0;
        procumentSummery['Pieces'] = 0.0;
        procumentSummery["Stone Wt"] = 0.0;
        procumentSummery["Stone Amt"] = updatedVarient["Stone Pieces"] ?? 0.0;
        procumentSummery["Total Amt"] = updatedVarient["Amount"];
        procumentSummery["TotalTransAmt"] = updatedVarient["TotalAmount"];

        _Procumentrows.forEach((element) {
          element.getCells().forEach((cell) {
            if (cell.columnName == 'Weight') {
              procumentSummery["Wt"] += cell.value;
            } else if (cell.columnName == 'Stone Wt') {
              procumentSummery["Stone Wt"] += cell.value;
            } else if (cell.columnName == 'Pieces')
              procumentSummery['Pieces'] = cell.value;
          });
        });
        procumentSummery["Metal Wt"] =
            procumentSummery["Wt"] - procumentSummery["Stone Wt"];
      } catch (e) {
        print("error in updating summery $e");
      }
    });
  }

//done
  void _addNewRowWithItemGroup(ProcumentStyleVariant variant) {
    print("bom length is ${variant.bomData.bomRows.length}");
    BomRowModel bomSummeryRow = variant.bomData.bomRows[0];
    setState(() {
      _Procumentrows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Ref Document', value: ''),
          DataGridCell<String>(columnName: 'Line No', value: ''),
          DataGridCell<int>(columnName: 'Stock Code', value: 0),
          DataGridCell<String>(
              columnName: 'Variant Name', value: variant.variantName),
          DataGridCell<double>(columnName: 'Stock Status', value: 0.0),
          DataGridCell<double>(
              columnName: 'Stone Wt', value: variant.stoneMinWt),
          DataGridCell<double>(
              columnName: 'Pieces', value: bomSummeryRow.pieces),
          DataGridCell<double>(
              columnName: 'Weight', value: bomSummeryRow.weight),
          DataGridCell<double>(columnName: 'Rate', value: bomSummeryRow.rate),
          DataGridCell<double>(
              columnName: 'Amount', value: bomSummeryRow.amount),
          DataGridCell<String>(columnName: 'Wastage', value: "0"),
        ]),
      );
      _procumentdataGridSource.updateDataGridSource();
    });
  }

  void _initializeRows() {
    print("intilizing start");
    _Procumentrows = [];
    Future.delayed(Duration(seconds: 1), () {
      ref.read(procurementVariantProvider2.notifier).resetAllVariants();
    });
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _Procumentrows.remove(row);
      _procumentdataGridSource.updateDataGridSource();
      _updateSummaryRow();
    });
  }

  void _updateSummaryRow() {
    for (var row in _Procumentrows) {
      Map<String, dynamic> updatedVarient = Map.fromIterable(
        row.getCells(),
        key: (cell) => "${cell.columnName}",
        value: (cell) => cell.value,
      );
      String varientName = row.getCells()[3].value;
      ref
          .read(procurementVariantProvider2.notifier)
          .updateVariant(varientName, updatedVarient);
    }

    _procumentSummery({});
  }

  void updateVarientRow(Map<String, dynamic> updatedVarient) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("here2");
      ref.read(BomProcProvider.notifier).updateAction(updatedVarient, false);
    });

    print("here6");
    int varientIndex = updatedVarient["varientIndex"];
    print("varientIndex is $varientIndex");
    setState(() {
      _Procumentrows[varientIndex] = DataGridRow(
          cells: _Procumentrows[varientIndex].getCells().map((cell) {
        if (updatedVarient[cell.columnName] != null)
          return DataGridCell(
              columnName: cell.columnName,
              value: updatedVarient[cell.columnName]);
        else
          return cell;
      }).toList());
    });
    // print("updated varient proc summery is $updatedVarient");

    ProcumentStyleVariant variant =
        ref.read(procurementVariantProvider2)[varientIndex];
    print("varient index is2 ${variant.vairiantIndex}");

    String formulaName = "variant_${variant.vairiantIndex}";
    FormulaModel? formulaModel =
        ref.read(allVariantFormulasProvider2)[formulaName];

    if (formulaModel != null) {
      double updatedStyleRate = updatedVarient["Amount"];
      print("proc amount is $updatedStyleRate");
      formulaModel.formulaRows[0].rowValue = updatedStyleRate;
      FormulaModel updatedFormula =
          await Utils().executeFormula(formulaModel, variant, ref);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(formulaName, updatedFormula);
      print("proc amount2 is ${updatedVarient["Amount"]}");
      print("here7");
      print("all formula ${ref.read(allVariantFormulasProvider2)}");

      double totalVarientAmount = 0;
      double totalCGST = 0;
      double totalIGST = 0;
      double totalSGST = 0;
      for (int i = 0; i < _Procumentrows.length; i++) {
        String formulaName = "variant_${i}";

        FormulaModel? formulaModel2 =
            ref.read(allVariantFormulasProvider2)[formulaName];

        if (formulaModel2 != null) {
          double variantAmount =
              formulaModel2.formulaRows[formulaModel2.totalRows - 1].rowValue;
          totalVarientAmount += variantAmount;
          print("variant $i $variantAmount");
          totalSGST = formulaModel2.formulaRows
              .firstWhere((row) => row.rowDescription.contains("SGST"))
              .rowValue;

          totalCGST = formulaModel2.formulaRows
              .firstWhere((row) => row.rowDescription.contains("CGST"))
              .rowValue;

          totalIGST = formulaModel2.formulaRows
              .firstWhere((row) => row.rowDescription.contains("IGST"))
              .rowValue;
        }
      }
      updatedVarient["Amount"] = totalVarientAmount;

      String transFormulaName = "transactionFormuala";

      FormulaModel? trnasFormulaModel =
          ref.read(allVariantFormulasProvider2)[transFormulaName];
      print("trans formula is ${trnasFormulaModel}");
      if (trnasFormulaModel != null) {
        trnasFormulaModel.formulaRows[0].rowValue = totalVarientAmount;
        trnasFormulaModel.formulaRows[7].rowValue = totalCGST;
        trnasFormulaModel.formulaRows[8].rowValue = totalSGST;
        trnasFormulaModel.formulaRows[9].rowValue = totalIGST;

        FormulaModel updatedTransFormula =
            await Utils().executeFormula(trnasFormulaModel, variant, ref);
        ref
            .read(allVariantFormulasProvider2.notifier)
            .update(transFormulaName, updatedTransFormula);
        updatedVarient["TotalAmount"] = updatedTransFormula
            .formulaRows[updatedTransFormula.formulaRows.length - 1].rowValue;
      }

      _procumentSummery(updatedVarient);
      print("here8");
    }
  }

  bool showDialogBom = false;

  void showProcumentdialog(String endUrl, String value) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ItemDataScreen(
                title: '',
                endUrl: endUrl,
                canGo: true,
                onDoubleClick: (Map<String, dynamic> intialData) {
                  print("intial data $intialData");
                  // _addNewRowBom(intialData["OPERATION_NAME"] ?? "", value);
                  // Navigator.pop(context);
                  // _updateBomSummaryRow();
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth = screenWidth * 0.6;
    final varientAction = ref.watch(BomProcProvider);
    if (varientAction['trigger'] == true) {
      print("varientAction $varientAction");
      updateVarientRow(varientAction["data"]);
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Goods Reciept Note',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  width: 40,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'Add Variant',
                        endUrl: 'ItemMasterAndVariants/Style/Style/Variant',
                        value: 'Variant Name',
                        onOptionSelectd: (selectedValue) async {
                          // print("selected value $selectedValue");
                        },
                        onSelectdRow: (selectedRow) async {
                          // print("selected Row $selectedRow");
                          selectedRow["Operation"] = operationMapList;
                          // print("selected Row $selectedRow");

                          Dio _dio = Dio();
                          List<dynamic> data = await ProcurementRepository(_dio)
                              .fetchBom(selectedRow["BOM Id"]);
                          selectedRow["BOM Data"] = data;
                          selectedRow["varientIndex"] = _Procumentrows.length;

                          ref
                              .read(procurementVariantProvider.notifier)
                              .addItem(selectedRow);
                          final basicVariant = ProcumentStyleVariant.fromJson(
                              selectedRow, _Procumentrows.length);
                          final completeVariant = await ProcumentStyleVariant
                              .initializeCalculatedFields(
                                  basicVariant, basicVariant.vairiantIndex);
                          await Utils()
                              .fetchFormulas(completeVariant, context, ref);
                          ref
                              .read(procurementVariantProvider2.notifier)
                              .addItem(completeVariant);

                          _addNewRowWithItemGroup(completeVariant);
                          setState(() {});
                          Future.delayed(Duration(seconds: 1), () {
                            print("self formula exec start");
                            selfExecuteAllForumulas(completeVariant);
                            setState(() {});
                          });
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.1,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Color(0xff003450),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "Add Variants",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeight * 0.6,
              margin: EdgeInsets.only(top: 10, left: 0),
              // padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.pink),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 4), // Offset only on the bottom
                  ),
                ],
              ),
              // height: screenHeight * 0.5,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  width: screenWidth,
                  // Set the grid width to 50% of the screen width
                  child: Theme(
                      data: ThemeData(
                        cardColor:
                            Colors.transparent, // Background color for DataGrid
                        shadowColor:
                            Colors.transparent, // Removes shadow if any
                      ),
                      child: SfDataGrid(
                        rowHeight: 40,
                        headerRowHeight: 40,
                        source: _procumentdataGridSource,
                        controller: _dataGridController,
                        footerFrozenColumnsCount: 1,
                        // Freeze the last column
                        columns: procumentColumns
                            .map((columnName) => GridColumn(
                                  columnName: columnName,
                                  width: gridWidth /
                                      5, // Adjust column width to fit 4-5 columns
                                  label: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFF003450),
                                        border: Border(
                                            right:
                                                BorderSide(color: Colors.grey)),
                                        borderRadius: BorderRadius.only(
                                            topRight: procumentColumns
                                                        .indexOf(columnName) ==
                                                    procumentColumns.length - 1
                                                ? Radius.circular(15)
                                                : Radius.circular(0),
                                            topLeft: procumentColumns
                                                        .indexOf(columnName) ==
                                                    0
                                                ? Radius.circular(15)
                                                : Radius.circular(0))),
                                    alignment: Alignment.center,
                                    child: Text(
                                      columnName,
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                            .toList(),
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.none,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _Procumentrows.length == 0
          ? Container()
          : SummaryDetails(
              Summery: procumentSummery,
            ),
    );
  }

  void selfExecuteAllForumulas(
    ProcumentStyleVariant variant,
  ) async {
    String variantName = variant.variantName;
    await selfExecuteBom(variant.bomData, variantName, variant);
    await selfExecuteOperation(variant.operationData, variantName, variant);
  }

  Future<void> selfExecuteOperation(OperationModel operationModel,
      String variantName, ProcumentStyleVariant variant) async {
    Map<String, FormulaModel> allFormula =
        ref.read(allVariantFormulasProvider2);
    FormulaModel? formulaModel;
    for (int oprIndex = 0;
        oprIndex < operationModel.operationRows.length;
        oprIndex++) {
      String formulaName =
          "${variantName}_${variant.vairiantIndex}_opr_${oprIndex}";
      for (String formulaKeys in allFormula.keys) {
        if (formulaKeys.contains(formulaName)) {
          formulaModel = allFormula[formulaKeys];
        }
      }
      if (formulaModel == null) return;
      print("formula loaded succefully");
      formulaModel =
          await executeFormula(formulaModel, variant, oprIndex, false);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(formulaName, formulaModel);
      OperationRowModel updatedRow = updateOperation(
          operationModel.operationRows[oprIndex], variant, formulaModel);
      operationModel.operationRows[oprIndex] = updatedRow;
    }
    await updateBomFromOperation(operationModel, variant);
    print("self execute operation ends ");
  }

  Future<void> updateBomFromOperation(
      OperationModel operationModel, ProcumentStyleVariant variant) async {
    ref.read(procurementVariantProvider2)[variant.vairiantIndex].operationData =
        operationModel;
    double totalAmount = operationModel.operationRows
        .fold(0.0, (sum, row) => sum + row.labourAmount);
    BomRowModel bomRow = variant.bomData.bomRows[0];
    bomRow.amount += totalAmount;
    ref
        .read(procurementVariantProvider2)[variant.vairiantIndex]
        .bomData
        .bomRows[0] = bomRow;
    print(
        "total operation Amount $totalAmount and bom final amount is ${bomRow.amount}");
    Map<String, dynamic> updatedVariant = {
      'totalOprAmount': TotalOperationAmount(totalAmount),
      'varientIndex': variant.vairiantIndex,
      'Amount': bomRow.amount
    };
    ref.read(BomProcProvider.notifier).updateAction(updatedVariant, true);
    ref
        .read(procurementVariantProvider2)[variant.vairiantIndex]
        .totalOperationAmount = TotalOperationAmount(totalAmount);
  }

  OperationRowModel updateOperation(OperationRowModel operationRow,
      ProcumentStyleVariant variant, FormulaModel formula) {
    operationRow.calcQty =
        Utils().operationMapping(operationRow.operation, variant);
    operationRow.labourRate =
        formula.formulaRows[formula.totalRows - 1].rowValue;
    operationRow.labourAmount = operationRow.calcQty * operationRow.labourRate;
    print("labour rate is  ${operationRow.labourRate}");
    return operationRow;
  }

  Future<void> selfExecuteBom(BomModel bomModel, String variantName,
      ProcumentStyleVariant variant) async {
    Map<String, FormulaModel> allFormula =
        ref.read(allVariantFormulasProvider2);
    for (int bomRowIndex = 1;
        bomRowIndex < bomModel.bomRows.length;
        bomRowIndex++) {
      String formulaName =
          "${variantName}_${variant.vairiantIndex}_bom_${bomRowIndex}";
      FormulaModel? formulaModel;
      for (String formulaKeys in allFormula.keys) {
        if (formulaKeys.contains(formulaName)) {
          formulaModel = allFormula[formulaKeys];
        }
      }
      if (formulaModel == null) return;
      formulaModel =
          await executeFormula(formulaModel, variant, bomRowIndex, true);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(formulaName, formulaModel);
      BomRowModel bomRow = bomModel.bomRows[bomRowIndex];
      await updateBomRow(
        variant,
        bomRowIndex,
        formulaModel,
        bomRow,
      );
      //
    }
  }

  Future<FormulaModel> executeFormula(FormulaModel formula,
      ProcumentStyleVariant variant, int bomRowIndex, bool isFromBom) async {
    print("execure formula starts $bomRowIndex and fromBOM $isFromBom");
    for (int i = 0; i < formula.formulaRows.length; i++) {
      // Utils.printJsonFormat(formula.formulaRows[i].toJson());
      FormulaRowModel formulaRowModel = formula.formulaRows[i];
      if (formulaRowModel.dataType == "Range") {
        formulaRowModel.rowValue = await rangeCalculation(
            formulaRowModel.rowExpression, variant, bomRowIndex, isFromBom);
      } else if (formulaRowModel.dataType == "Calculation") {
        formulaRowModel.rowValue =
            formulaCalculation(formulaRowModel.rowExpression, formula);
      } else {
        formulaRowModel.rowValue = intputCalculation(
            formulaRowModel.rowValue, formulaRowModel.rowType);
      }
    }
    print("execure formula ends $bomRowIndex and fromBOM $isFromBom");
    return formula;
  }

  Future<double> rangeCalculation(String rangeKey,
      ProcumentStyleVariant variant, int bomRowIndex, bool isFromBom) async {
    print("range calculation start");
    rangeKey = "15 jan";
    Map<dynamic, dynamic> rangeValue = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchRangeMasterExcel(rangeKey, context);
    Map<String, dynamic> rangeExcel = {};
    rangeExcel[rangeKey] = rangeValue;

    List<dynamic> excelData = rangeExcel[rangeKey]["Details"]["excelData"];
    List<dynamic> excelHeaders = rangeExcel[rangeKey]["Details"]["Headers"];
    List<List<dynamic>> matrixdata = List.from(excelData);
    Map<String, dynamic> variantAttributes = isFromBom
        ? fetchVariantAttributesBom(variant, bomRowIndex)
        : fetchVariantAttributesOpr(variant);
    double rangeOutput =
        findMatchingRowValue(variantAttributes, excelHeaders, matrixdata);
    return rangeOutput;
  }

  Map<String, dynamic> fetchVariantAttributesBom(
      ProcumentStyleVariant variant, int bomRowIndex) {
    Map<String, dynamic> variantAttributes = {};
    Map<String, dynamic>? varient = ref
        .read(procurementVariantProvider.notifier)
        .getItemByVariant(variant.variantName);
    variantAttributes["KARAT"] = "22";
    variantAttributes["CATEGORY"] = varient!["Category"];
    variantAttributes["Sub-Category"] = varient["Sub-Category"];
    variantAttributes["STYLE KARAT"] = varient["Style Karat"];
    variantAttributes["Varient"] = varient["Varient"];
    variantAttributes["HSN - SAC CODE"] = varient["HSN-SAC Code"];
    variantAttributes["LINE OF BUSINESS"] = varient["Line of Business"];
    variantAttributes["Pieces"] = variant.bomData.bomRows[bomRowIndex].pieces;
    variantAttributes["Weight"] = variant.bomData.bomRows[bomRowIndex].weight;
    variantAttributes["Rate"] = variant.bomData.bomRows[bomRowIndex].rate;
    variantAttributes["Avg Wt(Pcs)"] =
        variant.bomData.bomRows[bomRowIndex].avgWeight;
    return variantAttributes;
  }

  Map<String, dynamic> fetchVariantAttributesOpr(
    ProcumentStyleVariant variant,
  ) {
    Map<String, dynamic> variantAttributes = {};
    Map<String, dynamic>? varient = ref
        .read(procurementVariantProvider.notifier)
        .getItemByVariant(variant.variantName);
    variantAttributes["KARAT"] = "22";
    variantAttributes["CATEGORY"] = varient!["Category"];
    variantAttributes["Sub-Category"] = varient["Sub-Category"];
    variantAttributes["STYLE KARAT"] = varient["Style Karat"];
    variantAttributes["Varient"] = varient["Varient"];
    variantAttributes["HSN - SAC CODE"] = varient["HSN-SAC Code"];
    variantAttributes["LINE OF BUSINESS"] = varient["Line of Business"];
    variantAttributes["Pieces"] = variant.bomData.bomRows[0].pieces;
    variantAttributes["Weight"] = variant.bomData.bomRows[0].weight;
    variantAttributes["Rate"] = variant.bomData.bomRows[0].rate;
    variantAttributes["Avg Wt(Pcs)"] = variant.bomData.bomRows[0].avgWeight;
    return variantAttributes;
  }

  double findMatchingRowValue(Map<String, dynamic> attributes,
      List<dynamic> rangeHeaderList, List<List<dynamic>> rangeMatrixData) {
    print("range headers $rangeHeaderList  rangeMatrix $rangeMatrixData");
    print("attribute to compare are:  $attributes");
    List<List<dynamic>> filteredRows = List.from(rangeMatrixData);
    for (String rangeheader in rangeHeaderList) {
      // Get the index of the column for the current attribute
      if (rangeheader == "Output") continue;
      int columnIndex = rangeHeaderList.indexOf(rangeheader);
      print("headerName is $rangeheader columnIndex $columnIndex");

      // Get the attribute value to match
      dynamic attributeValue = attributes[rangeheader];
      print("attributeValue is $attributeValue ");

      // Filter rows where the value in the current column matches the attribute value
      if (attributeValue != null)
        filteredRows = filteredRows
            .where((row) => row[columnIndex] == attributeValue)
            .toList();

      // If only one row is left, return its first column value
      if (filteredRows.length == 1) {
        return int.parse(filteredRows.first[0]) * 1.0;
      }
    }
    return 0.0;
  }

  double formulaCalculation(String formula, FormulaModel formulaModel) {
    if (formula == '') {
      return 0.0;
    }

    String replacedFormula = formula.replaceAllMapped(
      RegExp(r'\[R(\d+)\]'),
      (match) {
        int rowNo = int.parse(match.group(1)!);

        dynamic value = formulaModel.formulaRows[rowNo - 1].rowValue;
        print("formula $formula row no $rowNo value $value");
        return value.toString();
      },
    );
    print("replace formula is $replacedFormula");
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(replacedFormula);
      ContextModel context = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, context);
      print("final calculated value $result");
      return result;
    } catch (e) {
      print('Error evaluating expression: $replacedFormula. Details: $e');
      return 0;
    }
  }

  double intputCalculation(double currentValue, String rowType) {
    print("input calculation ${rowType}");
    if (rowType == "MEATAL RATE") {
      return ref.watch(metalRateProvider);
    } else if (rowType == "DIAMOND RATE") {
      return ref.watch(metalRateProvider);
    } else if (rowType == "PURITY") {
      return 0.998;
    } else if (rowType == "METAL FINENESS") {
      return 0.998;
    } else if (rowType == "Labor Rate") {
      return 1000;
    } else if (rowType == "labor rate") {
      return 1000;
    } else if (rowType == "disc on rate") {
      return 100;
    } else if (rowType == "labor calc qty") {
      return 10;
    } else if (rowType == "labour amount") {
      return 20;
    } else if (rowType == "discount offered") {
      return 50;
    } else if (rowType == "sub total") {
      return 1000;
    } else if (rowType == "HALL RATE") {
      return 500;
    } else {
      print("row type is $rowType");
      return currentValue;
    }
  }

  Future<void> updateBomRow(ProcumentStyleVariant variant, int updatedRowIndex,
      FormulaModel formulaModel, BomRowModel bomrow) async {
    double updatedRate;
    var metalRateRows =
        formulaModel.formulaRows.where((row) => row.rowType == "MEATAL RATE");

    if (metalRateRows.isNotEmpty) {
      updatedRate = metalRateRows.first.rowValue?.toDouble() ?? 0.0;
    } else {
      var diamondRateRows = formulaModel.formulaRows
          .where((row) => row.rowType == "DIAMOND RATE");
      updatedRate = diamondRateRows.isNotEmpty
          ? diamondRateRows.first.rowValue?.toDouble() ?? 0.0
          : 0.0;
    }

    List<BomRowModel> listOfBoms = variant.bomData.bomRows;
    double weight = bomrow.weight;
    bomrow.rate = updatedRate;
    bomrow.amount = updatedRate * weight;
    ref
        .read(procurementVariantProvider2)[variant.vairiantIndex]
        .bomData
        .bomRows[updatedRowIndex] = bomrow;
    listOfBoms = ref
        .read(procurementVariantProvider2)[variant.vairiantIndex]
        .bomData
        .bomRows;
    updateBomSummaryRow(variant.variantName, listOfBoms, variant.vairiantIndex);
  }

  Future<void> updateBomSummaryRow(
      String variantName, List<BomRowModel> bomRows, int variantIndex) async {
    print("start updating bom summary row1");
    // int totalPcs = 0;
    double totalWt = 0.0;
    double totalRate = 0.0;
    double totalAmount = 0.0;
    double totalAVg = 0.0;

    for (var i = 1; i < bomRows.length; i++) {
      BomRowModel bomRowModel = bomRows[i];
      bool isMetal = bomRowModel.itemGroup.contains("Metal");
      if (isMetal) {
        totalWt += bomRowModel.weight;
      } else {
        totalWt += bomRowModel.weight * 0.2;
      }
      totalRate += bomRowModel.rate;
      totalAmount += bomRowModel.amount;
      totalAVg += bomRowModel.avgWeight;
    }

    setState(() {
      bomRows[0].rate = totalAmount / bomRows[0].pieces;
      bomRows[0].avgWeight = totalAVg;
      bomRows[0].amount = totalAmount;
      bomRows[0].weight = totalWt;
    });
    ref.read(formulaBomOprProvider.notifier).updateAction({}, false);

    //<------------------update procumentBom------------------>

    List<BomRowModel> updatedBom = [];
    for (var i = 0; i < bomRows.length; i++) {
      List<dynamic> rowValues = [
        bomRows[i].variantName,
        bomRows[i].itemGroup,
        bomRows[i].pieces,
        bomRows[i].weight,
        bomRows[i].rate,
        bomRows[i].avgWeight,
        bomRows[i].amount,
        bomRows[i].spChar,
        bomRows[i].operation,
        bomRows[i].type,
        bomRows[i].actions,
      ];
      updatedBom.add(BomRowModel.fromJsonDataRow(rowValues, i + 1));
    }
    //<------------------updating the varient after updating bom summery row------------------>
    Map<String, dynamic> updatedVarient = {
      'Variant Name': bomRows[0].variantName,
      'Item Group': bomRows[0].itemGroup,
      'Pieces': bomRows[0].pieces,
      'Weight': bomRows[0].weight,
      'Rate': bomRows[0].rate,
      'Avg Wt(Pcs)': bomRows[0].avgWeight,
      'Amount': bomRows[0].amount,
      'Sp Char': bomRows[0].spChar,
      'Operation': bomRows[0].operation,
      'Type': bomRows[0].type,
      'Actions': bomRows[0].actions
    };

    double stoneWeight = 0;
    double stonePieces = 0;
    for (var row in bomRows) {
      if (row.itemGroup.contains('Diamond')) {
        stoneWeight += row.weight * 0.2;
        stonePieces += row.pieces;
      }
    }
    print("updated stone weight is ${stoneWeight} $stonePieces");
    if (stoneWeight != 0) updatedVarient["Stone Wt"] = stoneWeight;
    updatedVarient["Stone Pieces"] = stonePieces;
    updatedVarient["totalStonePieces"] = stonePieces;
    updatedVarient["varientIndex"] = variantIndex;
    updatedVarient["Variant Name"] = variantName;
    updatedVarient["BOM Data"] =
        updatedBom.map((bom) => bom.toJson2()).toList();
    ref.read(BomProcProvider.notifier).updateAction(updatedVarient, true);
    updatedVarient["BOM Data"] = BomModel(bomRows: updatedBom, headers: []);
    updatedVarient["totalStonePieces"] = TotalPeices(stonePieces);
    ref
        .read(procurementVariantProvider2.notifier)
        .updateVariant(variantName, updatedVarient);
  }
}
