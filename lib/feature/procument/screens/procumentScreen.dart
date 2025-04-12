import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/formula_model.dart';
import 'package:jewlease/data/model/transaction_model.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

import '../../../core/routes/go_router.dart';
import '../../home/right_side_drawer/controller/drawer_controller.dart';
import '../../transaction/controller/transaction_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentVarientFormula.dart';
import '../controller/procumentVendorDailog.dart';
import 'procumentSummeryScreen.dart';
import 'procumentVendorDialog.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class procumentScreen extends ConsumerStatefulWidget {
  @override
  _procumentScreenState createState() => _procumentScreenState();
}

class _procumentScreenState extends ConsumerState<procumentScreen> {
  List<String> _tabs = [
    'Goods Reciept Note',
    'Purchase Order',
    'Purchase Return',
  ];
  late Function(Map<String, dynamic>) addRowToGrid;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
        Duration(milliseconds: 500),
        () => showDialog(
            context: context,
            builder: (context) => Dialog(child: procumentVendorDialog())));
    // showDialog(context: context, builder: (context) => procumentDialog());
    super.initState();
  }

  String? selectedValue = 'Variant';

  Future<Map<String, dynamic>?> updateBomFormula(
      Map<String, dynamic> variant) async {
    Map<dynamic, dynamic> allFormualMap = ref.read(allVariantFormulasProvider2);

    List<FormulaModel> bomRowsFormula = [];
    String formulaName = "${variant["Variant Name"]}";
    for (String formulaKey in allFormualMap.keys) {
      if (formulaKey.contains(formulaName)) {
        FormulaModel formulaModel = allFormualMap[formulaKey];
        if (!formulaModel.isUpdated) {
          Utils.snackBar(
              "Rate is not added in variant ${variant["Variant Name"]}",
              context);
          return null;
        }
        bomRowsFormula.add(formulaModel);
      }
    }
    List<dynamic> bomDataRows = variant["Bom Data"];

    for (int i = 0; i < bomDataRows.length; i++) {
      bomDataRows[i]["formulaId"] = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .getFormulaId(bomRowsFormula[i], context);
    }
    variant["bomData"] = bomDataRows;
    return variant;
  }

  Future<Map<String, dynamic>> addVariantFormula(
      Map<String, dynamic> variant) async {
    Map<dynamic, dynamic> allFormualMap = ref.read(allVariantFormulasProvider2);

    FormulaModel variantFomrula =
        allFormualMap["formula_${variant["Variant Name"]}"];

    variant["variantFormulaID"] = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .getFormulaId(variantFomrula, context);
    return variant;
  }

  Future<bool> saveProcument() async {
    try {
      List<Map<String, dynamic>>? varientList =
          ref.read(procurementVariantProvider);

      List<Map<String, dynamic>> reqstBodeis = [];

      if (varientList == null) return false;

      for (int i = 0; i < varientList!.length; i++) {
        Map<String,dynamic>?updatedVariant = await updateBomFormula(varientList[i]);
        if(updatedVariant==null){
          return false;
        }
        else {
          varientList[i]=updatedVariant;
        }
        varientList[i] = await addVariantFormula(varientList[i]);
        Map<String, dynamic> reuestBody = convertToGRNSchema(varientList[i]);

        // print("req body is $jsonString");

        reqstBodeis.add(reuestBody);
      }

      TransactionModel transaction = createTransaction(reqstBodeis);
      final jsonString =
          JsonEncoder.withIndent('  ').convert(transaction.toJson());
      print("transaction schema $jsonString");
      String? transactionID = await ref
          .read(TransactionControllerProvider.notifier)
          .sentTransaction(transaction);

      Utils.snackBar("Variant Aadded", context);
      goRouter.go("/");
      return true;
    } catch (e) {
      Utils.snackBar(e.toString(), context);
      return false;
    }

    // Navigator.pop(context);\\
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.1,
        ),
        Container(
            height: screenHeight * 0.06,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                    children: List.generate(
                  _tabs.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(tabIndexProvider.notifier).state = index;
                      },
                      child: Container(
                        color: index == selectedIndex
                            ? Color(0xff28713E)
                            : Colors.white,
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.007),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.005),
                          decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? Color(0xff28713E)
                                : Color(0xffF0F4F8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                  color: index == selectedIndex
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )))),
        Container(
          height: 10,
        ),
        Expanded(
          child: Scaffold(

              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   color: Colors.green,
              // ),
              appBar: AppBar(
                actions: [
                  AppBarButtons(
                    ontap: [
                      () {
                        if (selectedIndex == 1)
                          showDialog(
                              context: context,
                              builder: (context) => procumentScreen());
                        log('new pressed');
                        if (selectedIndex == 3)
                          context.go('/addFormulaProcedureScreen');
                      },
                      () async {
                        saveProcument();
                      },
                      () {
                        // Reset the provider value to null on refresh
                        ref.watch(formulaProcedureProvider.notifier).state = [
                          'Style',
                          null,
                          null
                        ];
                      },
                      () {}
                    ],
                  )
                ],
              ),
              body: ProcumentSummaryScreen()),
        ),
      ],
    );
  }

  TransactionModel createTransaction(List<Map<String, dynamic>> reqstBodeis) {
    return TransactionModel(
        transType: "Opening Stock",
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

  Map<String, dynamic> convertToGRNSchema(Map<String, dynamic> input) {
    return {
      "style": input["Style"],
      "variantName": input["Variant Name"],
      "oldVarient": input["Old Variant"],
      "customerVarient": input["Customer Variant"],
      "baseVarient": input["Base Variant"],
      "vendor": ref.read(pocVendorProvider)["Vendor Name"],
      "remark1": input["Remark 1"],
      "vendorVarient": input["Vendor Variant"],
      "remark2": input["Remark 2"],
      "createdBy": input["Created By"],
      "stdBuyingRate": input["Std Buying Rate"],
      "stoneMaxWt": input["Stone Max Wt"],
      "remark": input["Remark"],
      "stoneMinWt": input["Stone Min Wt"],
      "karatColor": input["Karat Color"],
      "deliveryDays": input["Delivery Days"],
      "forWeb": input["For Web"],
      "rowStatus": input["Row Status"],
      "verifiedStatus": input["Verified Status"],
      "length": input["Length"],
      "codegenSrNo": input["Codegen Sr No"],
      "category": input["CATEGORY"],
      "subCategory": input["Sub-Category"],
      "styleKarat": input["STYLE KARAT"],
      "varient": input["Varient"],
      "hsnSacCode": input["HSN - SAC CODE"],
      "lineOfBusiness": input["LINE OF BUSINESS"],
      "bomData": input["bomData"],
      "operation": input["Operation"],
      "imageDetails": input["Image Details"],
      "formulaDetails": input["Formula Details"],
      "pieces": input["Pieces"],
      "weight":
          covertToDouble(input["Weight"]) - covertToDouble(input["Stone Wt"]),
      "netWeight": input["Weight"] ?? 0,
      "diaWeight": input["Stone Wt"] ?? 0,
      "diaPieces": input["Stone Pieces"] ?? 0,
      "loactionCode": input["Location Code"],
      "vendorCode": ref.read(pocVendorProvider)["Vendor Code"],
      "location": ref.watch(selectedDepartmentProvider).locationName,
      "department": ref.watch(selectedDepartmentProvider).departmentName,
      "itemGroup": input["Style"],
      "metalColor": input["Karat Color"],
      "styleMetalColor": input["Karat Color"],
      "isRawMaterial": 0,
      "variantFormulaID": input["variantFormulaId"]
    };
  }
}

double covertToDouble(dynamic value) {
  if (value is double) {
    return value;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0.0;
  } else {
    return 0.0; // Default for unexpected types
  }
}
