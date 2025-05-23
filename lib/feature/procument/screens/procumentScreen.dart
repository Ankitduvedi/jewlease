import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/formula_model.dart';
import 'package:jewlease/data/model/procumentStyleVariant.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

import '../../../core/routes/go_router.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentVarientFormula.dart';
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

  Future<ProcumentStyleVariant> updateBomFormula(
      ProcumentStyleVariant variant) async {
    Map<String, dynamic> variables = {};
    Map<dynamic, dynamic> allFormualMap = ref.read(allVariantFormulasProvider2);
    print("all formula map ${allFormualMap}");

    List<FormulaModel> bomRowsFormula = [];
    for (int bomRowIndex = 1;
        bomRowIndex < variant.bomData.bomRows.length;
        bomRowIndex++) {
      String formulaName =
          "${variant.variantName}_${variant.vairiantIndex}_bom_${bomRowIndex}";
      for (String formulaKey in allFormualMap.keys) {
        if (formulaKey.contains(formulaName)) {
          FormulaModel formulaModel = allFormualMap[formulaKey];
          // if (!formulaModel.isUpdated) {
          //   Utils.snackBar(
          //       "Rate is not added in variant ${variant["Variant Name"]}",
          //       context);
          //   return null;
          formulaModel.formulaRows.forEach((row) {
            if (row.rowType != null &&
                row.rowType!.isNotEmpty &&
                row.rowType != "") {
              variables[row.rowType!] = row.rowValue;
            }
          });
          // }
          bomRowsFormula.add(formulaModel);
        }
      }
    }
    print("formula length is ${bomRowsFormula.length}");

    for (int i = 1; i < variant.bomData.bomRows.length; i++) {
      variant.bomData.bomRows[i].formulaID = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .getFormulaId(bomRowsFormula[i - 1], context);
    }
    variant.saveVariables(variables);
    return variant;
  }

  ProcumentStyleVariant addOperationFormula(ProcumentStyleVariant variant) {
    Map<String, dynamic> variables = {};
    Map<dynamic, dynamic> allFormualMap = ref.read(allVariantFormulasProvider2);

    for (int i = 0; i < variant.operationData.operationRows.length; i++) {
      String formulaName =
          "${variant.variantName}_${variant.vairiantIndex}_opr_${i}";
      for (String formulaKey in allFormualMap.keys) {
        if (formulaKey.contains(formulaName)) {
          FormulaModel formulaModel = allFormualMap[formulaKey];
          // if (!formulaModel.isUpdated) {
          //   Utils.snackBar(
          //       "Rate is not added in variant ${variant["Variant Name"]}",
          //       context);
          //   return null;
          formulaModel.formulaRows.forEach((row) {
            if (row.rowType != null &&
                row.rowType!.isNotEmpty &&
                row.rowType != "") {
              variables[row.rowType!] = row.rowValue;
            }
          });
        }
      }
    }
    variant.saveVariables(variables);
    return variant;
  }

  Future<ProcumentStyleVariant> addVariantFormula(
      ProcumentStyleVariant variant) async {
    Map<String, dynamic> variables = {};
    Map<dynamic, dynamic> allFormualMap = ref.read(allVariantFormulasProvider2);

    FormulaModel variantFomrula =
        allFormualMap["variant_${variant.vairiantIndex}"];
    variantFomrula.formulaRows.forEach((row) {
      if (row.rowType != null && row.rowType!.isNotEmpty && row.rowType != "") {
        variables[row.rowType!] = row.rowValue;
      }
    });

    variant.variantFormulaID = await ref
            .read(formulaProcedureControllerProvider.notifier)
            .getFormulaId(variantFomrula, context) ??
        "";
    variant.saveVariables(variables);
    return variant;
  }

  Future<bool> saveProcument() async {
    List<ProcumentStyleVariant>? varientList =
        ref.read(procurementVariantProvider2);

    List<Map<String, dynamic>> reqstBodeis = [];
    if (varientList == null) return false;
    for (int i = 0; i < varientList!.length; i++) {
      varientList[i] = await updateBomFormula(varientList[i]);
      varientList[i] = await addVariantFormula(varientList[i]);
      varientList[i] = addOperationFormula(varientList[i]);
      print("variables ${varientList[i].variables}");
      // varientList[i].variables= {
      //   "labout":200
      // };

      Map<String, dynamic> reuestBody = varientList[i].toJson();
      // print(reuestBody);
      // Utils.printJsonFormat(reuestBody);

      reqstBodeis.add(reuestBody);
    }
    String? transactionID =
        await Utils().createNewTransaction(reqstBodeis, ref, "Opening Stock");

    Utils.snackBar("Variant Aadded", context);
    goRouter.go("/");
    return true;
    // } catch (e) {
    //   Utils.snackBar(e.toString(), context);
    //   return false;
    // }

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
