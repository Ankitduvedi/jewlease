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

import '../../../data/model/formula_model.dart';
import '../../../main.dart';
import '../../../widgets/data_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../formula/controller/meta_rate_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentFormualaBomController.dart';
import '../controller/procumentFormulaController.dart';
import '../repository/procument_Repositoy.dart';

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
  };

  @override
  void initState() {
    super.initState();

    _initializeRows();

    _procumentdataGridSource = ProcumentDataGridSource(
        _Procumentrows, _removeRow, _updateSummaryRow, true);
    setState(() {});
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
    setState(() {});
    try {
      procumentSummery['Wt'] = 0.0;
      procumentSummery['Total Amt'] = 0.0;
      procumentSummery['Pieces'] = 0.0;
      procumentSummery["Stone Wt"] = 0.0;
      procumentSummery["Stone Amt"] = updatedVarient["Stone Pieces"] ?? 0.0;

      _Procumentrows.forEach((element) {
        element.getCells().forEach((cell) {
          if (cell.columnName == 'Weight') {
            procumentSummery["Wt"] += cell.value;
          } else if (cell.columnName == 'Amount') {
            procumentSummery["Total Amt"] += cell.value;
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
  }

  Future<void> fetchFormulas(
    Map<String, dynamic> variant,
  ) async {
    String variantName = variant['Variant Name'];
    // List<FormulaModel> bomFormulas = [];

    List<dynamic> mapBomRows = variant!["BOM Data"];
    List<BomRowModel> listOfBomRows = mapBomRows
        .map((row) => BomRowModel.fromJson(row as Map<String, dynamic>))
        .toList();
    Map<String, dynamic> diamondAttributes = {
      "procedureType": "Item",
      "transactionType": "STONE ASSORTMENT",
      "documentType": "TRANSFER OUTWARD ( DEPARTMENT )",
      "transactionCategory": "Na",
      "partyName": "",
      "variantName": "",
      "itemGroup": "Diamond",
      "attributeType": "STYLE KARAT",
      "attributeValue": "24",
      "operation": "MAKING CHARGES PER GRAM",
      "operationType": "",
      "transType": ""
    };

    Map<String, dynamic> metalAttributes = {
      "procedureType": "Transaction",
      "transactionType": "STONE ASSORTMENT",
      "documentType": "TRANSFER OUTWARD ( DEPARTMENT )",
      "transactionCategory": "Glue",
      "partyName": "",
      "variantName": "",
      "itemGroup": "Zircon",
      "attributeType": "METAL COLOR",
      "attributeValue": "Rose Gold",
      "operation": "MAKING CHARGES PER GRAM",
      "operationType": "",
      "transType": ""
    };

    // Utils.printJsonFormat(data);

    for (int i = 1; i < listOfBomRows.length; i++) {
      print("item group is ${listOfBomRows[i].itemGroup}");
      final data = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .fetchFormulaByAttribute(
              listOfBomRows[i].itemGroup.contains("Metal")
                  ? metalAttributes
                  : diamondAttributes,
              context);
      List<dynamic> rows = data["data"]["excelDetail"];
      print("formula is $rows");

      List<FormulaRowModel> formulaRows = rows
          .map((formula) =>
              FormulaRowModel.fromJson2(formula as Map<String, dynamic>))
          .toList();
      FormulaModel formulaModel = FormulaModel(
          formulaId: "",
          formulaRows: formulaRows,
          totalRows: formulaRows.length,
          isUpdated: false);
      // bomFormulas.add(formulaModel);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update("${variantName}_${i})", formulaModel);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update("formula_${variantName}", formulaModel);
    }

    Map<String, dynamic> labourAtrributes = {
      "procedureType": "Item",
      "transactionType": "INTER WC GROUP TRANSFER OUTWARD",
      "documentType": "SHIFTING OUTWARD",
      "transactionCategory": "Hand Setting",
      "partyName": "",
      "variantName": "",
      "itemGroup": "Style(Wt)",
      "attributeType": "CATEGORY",
      "attributeValue": "CHAIN",
      "operation": "LABOUR PER NET METAL WEIGHT",
      "operationType": "MANUFACTURING",
      "transType": ""
    };
    Map<String, dynamic> hallmarkingAtrributes = {
      "procedureType": "Item",
      "transactionType": "INTER WC GROUP TRANSFER OUTWARD",
      "documentType": "SHIFTING OUTWARD",
      "transactionCategory": "Wax Setting",
      "partyName": "",
      "variantName": "",
      "itemGroup": "Diamond",
      "attributeType": "CATEGORY",
      "attributeValue": "CHAIN",
      "operation": "Hallmarking",
      "operationType": "MANUFACTURING",
      "transType": ""
    };
    for (int i = 0; i < 2; i++) {
      final data = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .fetchFormulaByAttribute(
              i == 0 ? labourAtrributes : hallmarkingAtrributes, context);
      print("data is $data");
      List<dynamic> rows = data["data"]["excelDetail"];
      print("opr formula is $rows");

      List<FormulaRowModel> formulaRows = rows
          .map((formula) =>
              FormulaRowModel.fromJson2(formula as Map<String, dynamic>))
          .toList();
      FormulaModel formulaModel = FormulaModel(
          formulaId: "",
          formulaRows: formulaRows,
          totalRows: formulaRows.length,
          isUpdated: false);
      // bomFormulas.add(formulaModel);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update("${variantName}_opr_${i})", formulaModel);
    }
  }

//done
  void _addNewRowWithItemGroup(ProcumentStyleVariant variant) {
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
      ref.read(procurementVariantProvider.notifier).resetAllVariants();
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

  void updateVarientRow(Map<String, dynamic> updatedVarient) {
    int varientIndex = updatedVarient["varientIndex"];
    _Procumentrows[varientIndex] = DataGridRow(
        cells: _Procumentrows[varientIndex].getCells().map((cell) {
      if (updatedVarient[cell.columnName] != null)
        return DataGridCell(
            columnName: cell.columnName,
            value: updatedVarient[cell.columnName]);
      else
        return cell;
    }).toList());
    setState(() {});
    print("updated varient proc summery is $updatedVarient");

    _procumentSummery(updatedVarient);
    _Procumentrows[varientIndex].getCells().forEach((element) {
      print("updated varient row ${element.columnName} ${element.value}");
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(BomProcProvider.notifier).updateAction(updatedVarient, false);
    });
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
                          print("selected value $selectedValue");
                        },
                        onSelectdRow: (selectedRow) async {
                          print("selected Row $selectedRow");
                          selectedRow["Operation"] = operationMapList;
                          print("selected Row $selectedRow");

                          Dio _dio = Dio();
                          List<dynamic> data = await ProcurementRepository(_dio)
                              .fetchBom(selectedRow["BOM Id"]);
                          selectedRow["BOM Data"] = data;
                          selectedRow["varientIndex"] = _Procumentrows.length;

                          ref
                              .read(procurementVariantProvider.notifier)
                              .addItem(selectedRow);
                          Map<dynamic, dynamic>? varientData = ref
                              .read(procurementVariantProvider.notifier)
                              .getItemByVariant(selectedRow["Variant Name"]);
                          print("variant is $varientData");

                          await fetchFormulas(selectedRow);
                          final basicVariant = ProcumentStyleVariant.fromJson(
                              selectedRow, _Procumentrows.length);
                          final completeVariant = await ProcumentStyleVariant
                              .initializeCalculatedFields(
                                  basicVariant, basicVariant.vairiantIndex);

                          print("proc2 setted ");
                          ref
                              .read(procurementVariantProvider2.notifier)
                              .addItem(completeVariant);

                          _addNewRowWithItemGroup(completeVariant);
                          setState(() {});
                          Future.delayed(Duration(seconds: 1), () {
                            print("self formula exec start");
                            selfExecuteAllForumulas(selectedRow);
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
    Map<String, dynamic> variant,
  ) async {
    print("selfexecuteformula start");
    List<dynamic> mapBomRows = variant!["BOM Data"];
    String variantName = variant['Variant Name'];

    selfExecuteBom(mapBomRows, variantName, variant);
    ProcumentStyleVariant? variant2 = ref
        .read(procurementVariantProvider2.notifier)
        .getItemByVariant(variantName);
    if (variant2 == null) {
      print("Operation self execution can't be done");
      return;
    }

    OperationModel operationModel = variant2.operationData;
    selfExecuteOperation(operationModel, variantName, variant2);

    print("selfexecuteformula ends");
  }

  void selfExecuteOperation(OperationModel operationModel, String variantName,
      ProcumentStyleVariant variant) async {
    print("self execute operation start");
    for (int oprIndex = 0;
        oprIndex < operationModel.operationRows.length;
        oprIndex++) {
      String formulaName = "${variantName}_opr_${oprIndex}";
      print("formula Name $formulaName");
      Map<String, FormulaModel> allFormula =
          ref.read(allVariantFormulasProvider2);
      print("all formula $allFormula");
      FormulaModel? formulaModel;
      for (String formulaKeys in allFormula.keys) {
        if (formulaKeys.contains(formulaName)) {
          formulaModel = allFormula[formulaKeys];
        }
      }

      if (formulaModel == null) return;
      print("formula loaded succefully");

      formulaModel = await executeFormula(formulaModel, variantName);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(formulaName, formulaModel);
      OperationRowModel updatedRow = updateOperation(
          operationModel.operationRows[oprIndex], variant, formulaModel);
      operationModel.operationRows[oprIndex] = updatedRow;
    }
    updateBomFromOperation(operationModel, variant);
    print("self execute operation ends ");
  }

  void updateBomFromOperation(
      OperationModel operationModel, ProcumentStyleVariant variant) {
    print("update bom from operation");
    double totalAmount = operationModel.operationRows
        .fold(0.0, (sum, row) => sum + row.labourAmount);
    BomRowModel bomRow = variant.bomData.bomRows[0];
    print("bom row amount ${bomRow.amount}");
    bomRow.amount += totalAmount;
    ref.read(procurementVariantProvider)[variant.vairiantIndex]["Operation"] =
        operationModel.operationRows.map((row) => row.toJson()).toList();
    print(
        "updated variant ${ref.read(procurementVariantProvider)[variant.vairiantIndex]}");
    ref.read(procurementVariantProvider)[variant.vairiantIndex]["BOM Data"][0] =
        bomRow.toJson2();
    print(
        "updated bom is ${ref.read(procurementVariantProvider)[variant.vairiantIndex]["BOM Data"]}");
    print("total operation Amount $totalAmount");
    Map<String, dynamic> updatedVariant = {
      'Amount': bomRow.amount,
      'varientIndex': variant.vairiantIndex
    };
    ref.read(BomProcProvider.notifier).updateAction(updatedVariant, true);
    ref
        .read(procurementVariantProvider.notifier)
        .updateVariant(variant.variantName, updatedVariant);
    print("update bom from operation ends");
  }

  OperationRowModel updateOperation(OperationRowModel operationRow,
      ProcumentStyleVariant variant, FormulaModel formula) {
    operationRow.calcQty = operationMapping(operationRow.operation, variant);
    operationRow.labourRate =
        formula.formulaRows[formula.totalRows - 1].rowValue;
    operationRow.labourAmount = operationRow.calcQty * operationRow.labourRate;
    print("labour rate is  ${operationRow.labourRate}");
    return operationRow;
  }

  double operationMapping(String operationType, ProcumentStyleVariant variant) {
    switch (operationType) {
      case "LABOUR PER NET METAL WEIGHT":
        return variant.totalMetalWeight.value;
      case "LABOUR PER PIECE":
        return variant.totalPieces.value;
      case "LABOUR PER GROSS WEIGHT":
        return variant.totalWeight.value;
      case "HALLMARKING":
        return variant.totalPieces.value;
      case "CERTIFICATION CHARGES":
        return variant.totalStoneWeight.value;
      case "HANDLING CHARGES":
        return variant.totalStoneWeight.value;
      default:
        return 0;
    }
  }

  void selfExecuteBom(List<dynamic> mapBomRows, String variantName,
      Map<String, dynamic> variant) async {
    for (int bomRowIndex = 1; bomRowIndex < mapBomRows.length; bomRowIndex++) {
      String formulaName = "${variantName}_${bomRowIndex}";
      print("formula Name $formulaName");
      Map<String, FormulaModel> allFormula =
          ref.read(allVariantFormulasProvider2);
      print("all formula $allFormula");
      FormulaModel? formulaModel;
      for (String formulaKeys in allFormula.keys) {
        if (formulaKeys.contains(formulaName)) {
          formulaModel = allFormula[formulaKeys];
        }
      }

      if (formulaModel == null) return;
      print("self execute bom formula ends $bomRowIndex");
      formulaModel = await executeFormula(formulaModel, variantName);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(formulaName, formulaModel);
      print("updated metal rate is->> ${formulaModel.formulaRows[0].rowValue}");
      BomRowModel bomRow =
          BomRowModel.fromJson(mapBomRows[bomRowIndex] as Map<String, dynamic>);
      print("bom row is ${bomRow.toJson()}");
      updateBomRow(
          variant, bomRowIndex, formulaModel, bomRow, _Procumentrows.length);
      //
    }
  }

  Future<FormulaModel> executeFormula(
      FormulaModel formula, String variantName) async {
    for (int i = 0; i < formula.formulaRows.length; i++) {
      // Utils.printJsonFormat(formula.formulaRows[i].toJson());
      FormulaRowModel formulaRowModel = formula.formulaRows[i];
      if (formulaRowModel.dataType == "Range") {
        formulaRowModel.rowValue =
            await rangeCalculation(formulaRowModel.rowExpression, variantName);
      } else if (formulaRowModel.dataType == "Calculation") {
        formulaRowModel.rowValue =
            formulaCalculation(formulaRowModel.rowExpression, formula);
      } else {
        formulaRowModel.rowValue = intputCalculation(
            formulaRowModel.rowValue, formulaRowModel.rowType);
      }
    }
    return formula;
  }

  Future<double> rangeCalculation(String rangeKey, String variantName) async {
    rangeKey = "15 jan";
    Map<dynamic, dynamic> rangeValue = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchRangeMasterExcel(rangeKey, context);
    Map<String, dynamic> rangeExcel = {};
    rangeExcel[rangeKey] = rangeValue;

    List<dynamic> excelData = rangeExcel[rangeKey]["Details"]["excelData"];
    List<dynamic> excelHeaders = rangeExcel[rangeKey]["Details"]["Headers"];
    List<List<dynamic>> matrixdata = List.from(excelData);
    Map<String, dynamic> variantAttributes =
        fetchVariantAttributes(variantName);
    double rangeOutput =
        findMatchingRowValue(variantAttributes, excelHeaders, matrixdata);
    return rangeOutput;
  }

  Map<String, dynamic> fetchVariantAttributes(String variantName) {
    Map<String, dynamic> variantAttributes = {};
    Map<String, dynamic>? varient = ref
        .read(procurementVariantProvider.notifier)
        .getItemByVariant(variantName);
    variantAttributes["KARAT"] = "22";
    variantAttributes["CATEGORY"] = varient!["Category"];
    variantAttributes["Sub-Category"] = varient["Sub-Category"];
    variantAttributes["STYLE KARAT"] = varient["Style Karat"];
    variantAttributes["Varient"] = varient["Varient"];
    variantAttributes["HSN - SAC CODE"] = varient["HSN-SAC Code"];
    variantAttributes["LINE OF BUSINESS"] = varient["Line of Business"];
    List<dynamic> selectedBomRow =
        varient["BOM"]["data"][ref.read(showFormulaProvider)];
    variantAttributes["Pieces"] = selectedBomRow[2];
    variantAttributes["Weight"] = selectedBomRow[3];
    variantAttributes["Rate"] = selectedBomRow[4];
    variantAttributes["Avg Wt(Pcs)"] = selectedBomRow[5];
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

  void updateBomRow(Map<String, dynamic> variant, int updatedRowIndex,
      FormulaModel formulaModel, BomRowModel bomrow, int variantIndex) {
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
    List<dynamic> mapBomRows = variant!["BOM Data"];
    List<BomRowModel> listOfBoms = mapBomRows
        .map((row) => BomRowModel.fromJson(row as Map<String, dynamic>))
        .toList();
    double weight = bomrow.weight;
    bomrow.rate = updatedRate;
    bomrow.amount = updatedRate * weight;
    ref.read(procurementVariantProvider)[variantIndex]["BOM Data"]
        [updatedRowIndex] = bomrow.toJson2();
    mapBomRows = ref.read(procurementVariantProvider)[variantIndex]["BOM Data"];
    listOfBoms = mapBomRows
        .map((row) => BomRowModel.fromJson(row as Map<String, dynamic>))
        .toList();

    updateBomSummaryRow(variant["Variant Name"], listOfBoms, variantIndex);
  }

  void updateBomSummaryRow(
      String variantName, List<BomRowModel> bomRows, int variantIndex) {
    print("start updating bom summary row");
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
    updatedVarient["varientIndex"] = variantIndex;
    updatedVarient["Variant Name"] = variantName;
    updatedVarient["BOM Data"] =
        updatedBom.map((bom) => bom.toJson2()).toList();

    print("updatedVarient map is $updatedVarient ${variantName}");

    //<----update ui updates the procum varient with new values---->
    print("start ui updates the procum varient with new values");

    ref.read(BomProcProvider.notifier).updateAction(updatedVarient, true);

    //<----update the procument varient with new values---->
    print("start update the procument varient with new values");
    // Future.delayed(Duration(seconds: 3), () {
    ref
        .read(procurementVariantProvider.notifier)
        .updateVariant(variantName, updatedVarient);

    /// tem work remove bom conversion to json
    updatedVarient["BOM Data"] = BomModel(bomRows: updatedBom, headers: []);
    ref
        .read(procurementVariantProvider2.notifier)
        .updateVariant(variantName, updatedVarient);
    // });
    print("end updating bom summary row");
  }
}
