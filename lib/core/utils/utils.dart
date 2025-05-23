import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../data/model/bom_model.dart';
import '../../data/model/formula_model.dart';
import '../../data/model/procumentStyleVariant.dart';
import '../../data/model/transaction_model.dart';
import '../../feature/formula/controller/formula_prtocedure_controller.dart';
import '../../feature/formula/controller/meta_rate_controller.dart';
import '../../feature/home/right_side_drawer/controller/drawer_controller.dart';
import '../../feature/procument/controller/procumentVarientFormula.dart';
import '../../feature/transaction/controller/transaction_controller.dart';

class Utils {
  static void printJsonFormat(Map<String, dynamic> json) {
    final jsonString = JsonEncoder.withIndent('  ').convert(json);
    print("json schema $jsonString");
  }

  static fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.blueGrey);
  }

  static flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(2),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

  static snackBar(String message, BuildContext context) {
    print("error is $message");
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  double operationMapping(String operationType, ProcumentStyleVariant variant) {
    print(
        "operation mapping start $operationType**HALLMARKING ${variant.totalPieces.value}");
    bool isEqual = operationType == "HALLMARKING";
    print("isEqual $isEqual");
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

  Map<String, dynamic> variantFormulaMap = {
    "procedureType": "Item",
    "transactionType": "INTER WC GROUP TRANSFER OUTWARD",
    "documentType": "SHIFTING OUTWARD",
    "transactionCategory": "READY TO SHIP ORDER (115)",
    "partyName": "",
    "variantName": "",
    "itemGroup": "Style(Pcs)",
    "attributeType": "VARIETY",
    "attributeValue": "CAS",
    "operation": "certification charges",
    "operationType": "MANUFACTURING",
    "transType": ""
  };
  Map<String, dynamic> transactionFormula = {
    "procedureType": "Transaction",
    "transactionType": "INTER WC GROUP TRANSFER OUTWARD",
    "documentType": "SHIFTING OUTWARD",
    "transactionCategory": "Machine Setting",
    "partyName": "",
    "variantName": "",
    "itemGroup": "Style",
    "attributeType": "HSN - SAC CODE",
    "attributeValue": "12312",
    "operation": "MAKING CHARGES PER GRAM",
    "operationType": "",
    "transType": ""
  };
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

  Future<FormulaModel> executeFormula(
      FormulaModel formula, ProcumentStyleVariant variant, ref) async {
    print("execure formula starts and fromBOM ");
    for (int i = 0; i < formula.formulaRows.length; i++) {
      // Utils.printJsonFormat(formula.formulaRows[i].toJson());
      FormulaRowModel formulaRowModel = formula.formulaRows[i];
      if (formulaRowModel.dataType == "Range") {
        //
        // formulaRowModel.rowValue = await rangeCalculation(
        //     formulaRowModel.rowExpression, variant, bomRowIndex, isFromBom);
      } else if (formulaRowModel.dataType == "Calculation") {
        formulaRowModel.rowValue =
            formulaCalculation(formulaRowModel.rowExpression, formula);
      } else {
        formulaRowModel.rowValue = intputCalculation(
            formulaRowModel.rowValue, formulaRowModel.rowType, ref);
      }
    }

    print("execure formula ends");
    return formula;
  }

  double intputCalculation(double currentValue, String rowType, ref) {
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

  Map<String, dynamic> metalBarcode = {
    "procedureType": "Item",
    "transactionType": "STONE ASSORTMENT",
    "documentType": "TRANSFER OUTWARD ( DEPARTMENT )",
    "transactionCategory": "Ghantan",
    "partyName": "",
    "variantName": "",
    "itemGroup": "Gold",
    "attributeType": "METAL COLOR",
    "attributeValue": "Rose Gold",
    "operation": "Labour per gross weight",
    "operationType": "MANUFACTURING",
    "transType": ""
  };

  List<Map<String, dynamic>> sampleBomRows = [
    {
      "BOM Id": "BOM-1",
      "Row No": 1,
      "Variant Name": "Summery",
      "Item Group": "",
      "Pieces": 4.0000,
      "Weight": 24.0000,
      "Rate": 9000.0000,
      "Avg Weight": 25.0000,
      "Amount": 180000.0000,
      "SpChar": "",
      "Operation": "",
      "Type": "",
      "Actions": [],
      "FormulaID": null,
    },
    {
      "BOM Id": "BOM-1",
      "Row No": 2,
      "Variant Name": "GL-24Kt-Rose Gold",
      "Item Group": "Metal - Gold",
      "Pieces": 0.0000,
      "Weight": 20.0000,
      "Rate": 8000.0000,
      "Avg Weight": 20.0000,
      "Amount": 160000.0000,
      "SpChar": "",
      "Operation": "",
      "Type": "",
      "Actions": [],
      "FormulaID": null,
    },
    {
      "BOM Id": "BOM-1",
      "Row No": 3,
      "Variant Name": "test1-MIX-NA-D-",
      "Item Group": "Stone - Diamond",
      "Pieces": 4.0000,
      "Weight": 20.0000,
      "Rate": 1000.0000,
      "Avg Weight": 5.0000,
      "Amount": 20000.0000,
      "SpChar": "",
      "Operation": "",
      "Type": "",
      "Actions": [],
      "FormulaID": null,
    },
  ];

  List<Map<String, dynamic>> oprRows = [
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
    }
  ];

  Future<void> fetchBomFormulas(ProcumentStyleVariant variant,
      BuildContext context, WidgetRef ref) async {
    List<BomRowModel> listOfBomRows = variant.bomData.bomRows;
    for (int i = 1; i < listOfBomRows.length; i++) {
      print("item group is ${listOfBomRows[i].itemGroup}");
      final data = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .fetchFormulaByAttribute(
              listOfBomRows[i].itemGroup.contains("Metal")
                  ? metalBarcode
                  // Utils().metalAttributes
                  : Utils().diamondAttributes,
              context);
      List<dynamic> rows = data["data"]["excelDetail"];
      print("formula is1 $rows");

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
      String FormulaName =
          "${variant.variantName}_${variant.vairiantIndex}_bom_$i";
      print("formula name is $FormulaName");

      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(FormulaName, formulaModel);
    }
  }

  Future<void> fetchOperationFormula(ProcumentStyleVariant variant,
      BuildContext context, WidgetRef ref) async {
    for (int i = 0; i < 2; i++) {
      final data = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .fetchFormulaByAttribute(
              i == 0 ? Utils().labourAtrributes : Utils().hallmarkingAtrributes,
              context);
      // print("data is $data");
      List<dynamic> rows = data["data"]["excelDetail"];
      // print("opr formula is $rows");

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
      String formulaName =
          "${variant.variantName}_${variant.vairiantIndex}_opr_${i}";
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update(formulaName, formulaModel);
    }
  }

  Future<void> fetchVariantFormula(ProcumentStyleVariant variant,
      BuildContext context, WidgetRef ref) async {
    Map<String, dynamic> data = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchFormulaByAttribute(Utils().variantFormulaMap, context);
    List<dynamic> rows = data["data"]["excelDetail"];
    // print("variant formula is $rows");

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
    String formualaName = "variant_${variant.vairiantIndex}";
    print("formula name is ${formualaName}");
    ref
        .read(allVariantFormulasProvider2.notifier)
        .update(formualaName, formulaModel);
    data = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchFormulaByAttribute(Utils().transactionFormula, context);
    rows = data["data"]["excelDetail"];
    // print("transaction formula is $data");

    formulaRows = rows
        .map((formula) =>
            FormulaRowModel.fromJson2(formula as Map<String, dynamic>))
        .toList();
    formulaModel = FormulaModel(
        formulaId: "",
        formulaRows: formulaRows,
        totalRows: formulaRows.length,
        isUpdated: false);
    // bomFormulas.add(formulaModel);
    ref
        .read(allVariantFormulasProvider2.notifier)
        .update("transactionFormuala", formulaModel);
  }

  Future<void> fetchFormulas(ProcumentStyleVariant variant,
      BuildContext context, WidgetRef ref) async {
    print("formula fetch start ");
    await fetchBomFormulas(variant, context, ref);
    await fetchOperationFormula(variant, context, ref);
    await fetchVariantFormula(variant, context, ref);
  }

  Future<String> createNewTransaction(List<Map<String, dynamic>> reqstBodies,
      WidgetRef ref, String transType) async {
    TransactionModel newTranscModel =
        createTranscModel(reqstBodies, ref, transType);
    await ref
        .read(TransactionControllerProvider.notifier)
        .sentTransaction(newTranscModel);
    return "";
  }

  TransactionModel createTranscModel(
      List<Map<String, dynamic>> reqstBodeis, WidgetRef ref, String transType) {
    return TransactionModel(
        transType: transType,
        subType: "OPS",
        transCategory: "GENERAL",
        docNo: "bsjbcs",
        transDate: DateTime.now().toIso8601String(),
        destination: "MH_CASH",
        customer: "ankit",
        source: ref.watch(selectedDepartmentProvider).locationName,
        sourceDept: ref.watch(selectedDepartmentProvider).departmentName,
        destinationDept: "MH_CASH",
        exchangeRate: "0.0",
        currency: "RS",
        salesPerson: "Arun",
        term: "term",
        remark: "Creating GRN",
        createdBy: DateTime.now().toIso8601String(),
        postingDate: DateTime.now().toIso8601String(),
        varients: reqstBodeis);
  }
}
